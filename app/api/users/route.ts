import { type NextRequest, NextResponse } from "next/server"
import { initializeApp, getApps } from "firebase/app"
import { getFirestore, collection, getDocs, doc, updateDoc, query, orderBy } from "firebase/firestore"

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

    // Get all users from Firebase
    const usersRef = collection(db, "users")
    const usersQuery = query(usersRef, orderBy("createdAt", "desc"))

    const usersSnapshot = await getDocs(usersQuery)
    let users = usersSnapshot.docs.map((doc) => {
      const data = doc.data()
      return {
        id: doc.id,
        email: data.email || "",
        name: data.name || "",
        createdAt: data.createdAt?.toDate?.()?.toISOString() || new Date().toISOString(),
        lastActive: data.lastActive?.toDate?.()?.toISOString() || new Date().toISOString(),
        tasksCompleted: data.tasksCompleted || 0,
        currentStreak: data.currentStreak || 0,
        isActive: data.isActive !== false, // Default to true if not specified
        badges: data.badges || [],
      }
    })

    // Apply search filter
    if (search) {
      users = users.filter(
        (user) =>
          user.name.toLowerCase().includes(search.toLowerCase()) ||
          user.email.toLowerCase().includes(search.toLowerCase()),
      )
    }

    // Apply status filter
    if (status) {
      users = users.filter((user) => (status === "active" ? user.isActive : !user.isActive))
    }

    return NextResponse.json(users)
  } catch (error) {
    console.error("Error fetching users:", error)
    return NextResponse.json({ error: "Failed to fetch users" }, { status: 500 })
  }
}

export async function PATCH(request: NextRequest) {
  try {
    const { userId, action } = await request.json()

    if (!userId || !action) {
      return NextResponse.json({ error: "Missing userId or action" }, { status: 400 })
    }

    const userRef = doc(db, "users", userId)

    if (action === "activate") {
      await updateDoc(userRef, { isActive: true })
    } else if (action === "deactivate") {
      await updateDoc(userRef, { isActive: false })
    } else {
      return NextResponse.json({ error: "Invalid action" }, { status: 400 })
    }

    return NextResponse.json({ success: true })
  } catch (error) {
    console.error("Error updating user:", error)
    return NextResponse.json({ error: "Failed to update user" }, { status: 500 })
  }
}
