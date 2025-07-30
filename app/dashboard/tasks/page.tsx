import { Suspense } from "react"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { TasksList } from "@/components/tasks/tasks-list"
import { TasksSearch } from "@/components/tasks/tasks-search"
import { TasksBulkActions } from "@/components/tasks/tasks-bulk-actions"

export default function TasksPage() {
  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold tracking-tight">Tasks</h1>
        <p className="text-muted-foreground">View and manage tasks across all users</p>
      </div>

      <Card>
        <CardHeader>
          <CardTitle>Task Management</CardTitle>
          <CardDescription>Search, filter, and perform bulk actions on tasks</CardDescription>
        </CardHeader>
        <CardContent>
          <div className="space-y-4">
            <div className="flex flex-col sm:flex-row gap-4">
              <div className="flex-1">
                <TasksSearch />
              </div>
              <TasksBulkActions />
            </div>
            <Suspense fallback={<div>Loading tasks...</div>}>
              <TasksList />
            </Suspense>
          </div>
        </CardContent>
      </Card>
    </div>
  )
}
