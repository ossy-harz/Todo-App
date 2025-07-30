"use client"

import { useState } from "react"
import { Button } from "@/components/ui/button"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import { CheckSquare, Trash2 } from "lucide-react"

export function TasksBulkActions() {
  const [selectedAction, setSelectedAction] = useState("")
  const [selectedTasks, setSelectedTasks] = useState<string[]>([])

  const handleBulkAction = async () => {
    if (!selectedAction || selectedTasks.length === 0) return

    await fetch("/api/tasks", {
      method: "PATCH",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ taskIds: selectedTasks, action: selectedAction }),
    })

    // Reset selection
    setSelectedTasks([])
    setSelectedAction("")
  }

  return (
    <div className="flex items-center space-x-2">
      <Select value={selectedAction} onValueChange={setSelectedAction}>
        <SelectTrigger className="w-[180px]">
          <SelectValue placeholder="Bulk actions" />
        </SelectTrigger>
        <SelectContent>
          <SelectItem value="complete">
            <div className="flex items-center">
              <CheckSquare className="mr-2 h-4 w-4" />
              Mark Complete
            </div>
          </SelectItem>
          <SelectItem value="delete">
            <div className="flex items-center">
              <Trash2 className="mr-2 h-4 w-4" />
              Delete
            </div>
          </SelectItem>
        </SelectContent>
      </Select>
      <Button onClick={handleBulkAction} disabled={!selectedAction || selectedTasks.length === 0}>
        Apply ({selectedTasks.length})
      </Button>
    </div>
  )
}
