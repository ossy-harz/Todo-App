import { NextResponse } from "next/server"
import { initializeApp, getApps } from "firebase/app"
import { getFirestore, collection, getDocs, query, collectionGroup } from "firebase/firestore"

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

export async function GET() {
  try {
    // Get users stats
    const usersRef = collection(db, "users")
    const usersSnapshot = await getDocs(usersRef)

    const totalUsers = usersSnapshot.size
    const activeUsers = usersSnapshot.docs.filter((doc) => {
      const data = doc.data()
      return data.isActive !== false
    }).length

    // Get tasks stats
    const tasksQuery = query(collectionGroup(db, "tasks"))
    const tasksSnapshot = await getDocs(tasksQuery)

    const totalTasks = tasksSnapshot.size
    const completedTasks = tasksSnapshot.docs.filter((doc) => {
      const data = doc.data()
      return data.isCompleted === true
    }).length

    const pendingTasks = totalTasks - completedTasks
    const completionRate = totalTasks > 0 ? Math.round((completedTasks / totalTasks) * 100 * 10) / 10 : 0

    // Calculate average streak
    const streaks = usersSnapshot.docs.map((doc) => doc.data().currentStreak || 0)
    const averageStreak =
      streaks.length > 0 ? Math.round((streaks.reduce((sum, streak) => sum + streak, 0) / streaks.length) * 10) / 10 : 0

    // Get top badges
    const allBadges = usersSnapshot.docs.flatMap((doc) => doc.data().badges || [])
    const badgeCounts = allBadges.reduce(
      (acc, badge) => {
        acc[badge] = (acc[badge] || 0) + 1
        return acc
      },
      {} as Record<string, number>,
    )

    const topBadges = Object.entries(badgeCounts)
      .sort(([, a], [, b]) => b - a)
      .slice(0, 3)
      .map(([name, count]) => ({ name, count }))

    const stats = {
      totalUsers,
      activeUsers,
      totalTasks,
      completedTasks,
      pendingTasks,
      completionRate,
      averageStreak,
      topBadges,
    }

    return NextResponse.json(stats)
  } catch (error) {
    console.error("Error fetching stats:", error)
    return NextResponse.json({
      totalUsers: 0,
      activeUsers: 0,
      totalTasks: 0,
      completedTasks: 0,
      pendingTasks: 0,
      completionRate: 0,
      averageStreak: 0,
      topBadges: [],
    })
  }
}
