import { type NextRequest, NextResponse } from "next/server"
import { initializeApp, getApps } from "firebase/app"
import {
  getFirestore,
  collection,
  getDocs,
  updateDoc,
  deleteDoc,
  query,
  where,
  orderBy,
  collectionGroup,
} from "firebase/firestore"

// Firebase configuration - replace with your actual config
const firebaseConfig = {
  apiKey: process.env.NEXT_PUBLIC_FIREBASE_API_KEY,
  authDomain: process.env.NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN,
  projectId: process.env.NEXT_PUBLIC_FIREBASE_PROJECT_ID,
  storageBucket: process.env.NEXT_PUBLIC_FIREBASE_STORAGE_BUCKET,
  messagingSenderId: process.env.NEXT_PUBLIC_FIREBASE_MESSAGING_SENDER_ID,
  appId: process.env.NEXT_PUBLIC_FIREBASE_APP_ID,
}

// Initialize Firebase
const app = getApps().length === 0 ? initializeApp(firebaseConfig) : getApps()[0]
const db = getFirestore(app)

export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url)
    const search = searchParams.get("search")
    const status = searchParams.get("status")
    const userId = searchParams.get("userId")

    // Get all tasks from all users using collection group query
    const tasksQuery = query(collectionGroup(db, "tasks"), orderBy("createdAt", "desc"))

    const tasksSnapshot = await getDocs(tasksQuery)

    // Get user names for each task
    const usersRef = collection(db, "users")
    const usersSnapshot = await getDocs(usersRef)
    const usersMap = new Map()

    usersSnapshot.docs.forEach((doc) => {
      usersMap.set(doc.id, doc.data().name || doc.data().email || "Unknown User")
    })

    let tasks = tasksSnapshot.docs.map((doc) => {
      const data = doc.data()
      const taskUserId = data.userId || doc.ref.parent.parent?.id

      return {
        id: doc.id,
        title: data.title || "",
        description: data.description || "",
        completed: data.isCompleted || false,
        createdAt: data.createdAt?.toDate?.()?.toISOString() || new Date().toISOString(),
        dueDate: data.dueDate?.toDate?.()?.toISOString() || null,
        completedAt: data.completedAt?.toDate?.()?.toISOString() || null,
        userId: taskUserId,
        userName: usersMap.get(taskUserId) || "Unknown User",
        priority: data.priority || "medium",
      }
    })

    // Apply search filter
    if (search) {
      tasks = tasks.filter(
        (task) =>
          task.title.toLowerCase().includes(search.toLowerCase()) ||
          task.description.toLowerCase().includes(search.toLowerCase()) ||
          task.userName.toLowerCase().includes(search.toLowerCase()),
      )
    }

    // Apply status filter
    if (status) {
      tasks = tasks.filter((task) => (status === "completed" ? task.completed : !task.completed))
    }

    // Apply user filter
    if (userId) {
      tasks = tasks.filter((task) => task.userId === userId)
    }

    return NextResponse.json(tasks)
  } catch (error) {
    console.error("Error fetching tasks:", error)
    return NextResponse.json({ error: "Failed to fetch tasks" }, { status: 500 })
  }
}

export async function PATCH(request: NextRequest) {
  try {
    const { taskIds, action } = await request.json()

    if (!taskIds || !Array.isArray(taskIds) || !action) {
      return NextResponse.json({ error: "Missing taskIds or action" }, { status: 400 })
    }

    // Note: This is a simplified approach. In a real implementation,
    // you'd need to know which user each task belongs to
    const promises = taskIds.map(async (taskId) => {
      try {
        // Since we're using collection group queries, we need to find the task's path
        // This is a limitation of the current structure - ideally you'd store the full path
        const tasksQuery = query(collectionGroup(db, "tasks"), where("__name__", "==", taskId))
        const snapshot = await getDocs(tasksQuery)

        if (!snapshot.empty) {
          const taskDoc = snapshot.docs[0]
          const taskRef = taskDoc.ref

          if (action === "complete") {
            await updateDoc(taskRef, {
              isCompleted: true,
              completedAt: new Date(),
            })
          } else if (action === "delete") {
            await deleteDoc(taskRef)
          }
        }
      } catch (error) {
        console.error(`Error processing task ${taskId}:`, error)
      }
    })

    await Promise.all(promises)
    return NextResponse.json({ success: true })
  } catch (error) {
    console.error("Error updating tasks:", error)
    return NextResponse.json({ error: "Failed to update tasks" }, { status: 500 })
  }
}
