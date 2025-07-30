"use client"

import { useEffect, useState } from "react"
import { Badge } from "@/components/ui/badge"

interface Activity {
  id: string
  type: "task_completed" | "user_registered" | "streak_achieved"
  message: string
  timestamp: string
  user: string
}

export function RecentActivity() {
  const [activities, setActivities] = useState<Activity[]>([])

  useEffect(() => {
    const fetchRecentActivity = async () => {
      try {
        // In a real implementation, you'd have an activity log collection
        // For now, we'll generate activity from recent tasks and user registrations
        const tasksResponse = await fetch("/api/tasks")
        const tasks = await tasksResponse.json()

        const usersResponse = await fetch("/api/users")
        const users = await usersResponse.json()

        const recentActivities: Activity[] = []

        // Add recent completed tasks
        const recentCompletedTasks = tasks
          .filter((task: any) => task.completed && task.completedAt)
          .sort((a: any, b: any) => new Date(b.completedAt).getTime() - new Date(a.completedAt).getTime())
          .slice(0, 3)

        recentCompletedTasks.forEach((task: any, index: number) => {
          recentActivities.push({
            id: `task-${task.id}`,
            type: "task_completed",
            message: `completed "${task.title}"`,
            timestamp: getRelativeTime(new Date(task.completedAt)),
            user: task.userName,
          })
        })

        // Add recent user registrations
        const recentUsers = users
          .sort((a: any, b: any) => new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime())
          .slice(0, 2)

        recentUsers.forEach((user: any) => {
          recentActivities.push({
            id: `user-${user.id}`,
            type: "user_registered",
            message: "joined the platform",
            timestamp: getRelativeTime(new Date(user.createdAt)),
            user: user.name,
          })
        })

        // Add streak achievements
        const usersWithStreaks = users
          .filter((user: any) => user.currentStreak >= 7)
          .sort((a: any, b: any) => b.currentStreak - a.currentStreak)
          .slice(0, 2)

        usersWithStreaks.forEach((user: any) => {
          recentActivities.push({
            id: `streak-${user.id}`,
            type: "streak_achieved",
            message: `achieved ${user.currentStreak}-day streak`,
            timestamp: "Recently",
            user: user.name,
          })
        })

        // Sort by most recent and limit to 6 items
        const sortedActivities = recentActivities
          .sort((a, b) => {
            // Simple sorting - in a real app you'd use actual timestamps
            if (a.timestamp.includes("minute")) return -1
            if (b.timestamp.includes("minute")) return 1
            return 0
          })
          .slice(0, 6)

        setActivities(sortedActivities)
      } catch (error) {
        console.error("Error fetching recent activity:", error)
        setActivities([])
      }
    }

    fetchRecentActivity()
  }, [])

  const getActivityBadge = (type: Activity["type"]) => {
    switch (type) {
      case "task_completed":
        return <Badge variant="default">Task</Badge>
      case "user_registered":
        return <Badge variant="secondary">User</Badge>
      case "streak_achieved":
        return <Badge variant="outline">Streak</Badge>
      default:
        return <Badge>Activity</Badge>
    }
  }

  // Helper function to get relative time
  const getRelativeTime = (date: Date) => {
    const now = new Date()
    const diffInMinutes = Math.floor((now.getTime() - date.getTime()) / (1000 * 60))

    if (diffInMinutes < 1) return "Just now"
    if (diffInMinutes < 60) return `${diffInMinutes} minute${diffInMinutes > 1 ? "s" : ""} ago`

    const diffInHours = Math.floor(diffInMinutes / 60)
    if (diffInHours < 24) return `${diffInHours} hour${diffInHours > 1 ? "s" : ""} ago`

    const diffInDays = Math.floor(diffInHours / 24)
    return `${diffInDays} day${diffInDays > 1 ? "s" : ""} ago`
  }

  return (
    <div className="space-y-4">
      {activities.map((activity) => (
        <div key={activity.id} className="flex items-center space-x-4">
          {getActivityBadge(activity.type)}
          <div className="flex-1 min-w-0">
            <p className="text-sm">
              <span className="font-medium">{activity.user}</span> {activity.message}
            </p>
            <p className="text-xs text-muted-foreground">{activity.timestamp}</p>
          </div>
        </div>
      ))}
    </div>
  )
}
