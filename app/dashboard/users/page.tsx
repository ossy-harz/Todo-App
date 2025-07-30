import { Suspense } from "react"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { UsersList } from "@/components/users/users-list"
import { UsersSearch } from "@/components/users/users-search"

export default function UsersPage() {
  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold tracking-tight">Users</h1>
        <p className="text-muted-foreground">Manage user accounts and view their activity</p>
      </div>

      <Card>
        <CardHeader>
          <CardTitle>User Management</CardTitle>
          <CardDescription>Search, filter, and manage user accounts</CardDescription>
        </CardHeader>
        <CardContent>
          <div className="space-y-4">
            <UsersSearch />
            <Suspense fallback={<div>Loading users...</div>}>
              <UsersList />
            </Suspense>
          </div>
        </CardContent>
      </Card>
    </div>
  )
}
