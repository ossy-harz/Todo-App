"use client"

import { useEffect, useState } from "react"
import { Trophy } from "lucide-react"

interface User {
  id: string
  name: string
  currentStreak: number
  tasksCompleted: number
  isActive: boolean
}

export function TopPerformers() {
  const [topUsers, setTopUsers] = useState<User[]>([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    const fetchTopPerformers = async () => {
      try {
        const response = await fetch("/api/users")
        const users: User[] = await response.json()

        // Sort by current streak and tasks completed
        const sortedUsers = users
          .filter((user) => user.isActive)
          .sort((a, b) => {
            // Primary sort by streak, secondary by tasks completed
            if (b.currentStreak !== a.currentStreak) {
              return b.currentStreak - a.currentStreak
            }
            return b.tasksCompleted - a.tasksCompleted
          })
          .slice(0, 3)

        setTopUsers(sortedUsers)
      } catch (error) {
        console.error("Error fetching top performers:", error)
        setTopUsers([])
      } finally {
        setLoading(false)
      }
    }

    fetchTopPerformers()
  }, [])

  if (loading) {
    return <div>Loading top performers...</div>
  }

  if (topUsers.length === 0) {
    return (
      <div className="text-center text-gray-500">
        <Trophy className="h-12 w-12 mx-auto mb-2 text-gray-300" />
        <p>No active users found</p>
      </div>
    )
  }

  const getTrophyColor = (index: number) => {
    switch (index) {
      case 0:
        return "text-yellow-500"
      case 1:
        return "text-gray-400"
      case 2:
        return "text-orange-500"
      default:
        return "text-gray-300"
    }
  }

  return (
    <div className="space-y-4">
      {topUsers.map((user, index) => (
        <div key={user.id} className="flex items-center space-x-4">
          <Trophy className={`h-5 w-5 ${getTrophyColor(index)}`} />
          <div className="flex-1">
            <p className="text-sm font-medium">{user.name}</p>
            <p className="text-xs text-muted-foreground">
              {user.currentStreak} day streak • {user.tasksCompleted} tasks completed
            </p>
          </div>
          <div className="text-sm font-medium">#{index + 1}</div>
        </div>
      ))}
    </div>
  )
}
