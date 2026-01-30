import React, { useState, useEffect } from 'react'
import axios from 'axios'
import './App.css'

const API_URL = 'http://localhost:5000/api'

function App() {
  const [tasks, setTasks] = useState([])
  const [newTaskTitle, setNewTaskTitle] = useState('')
  const [newTaskDescription, setNewTaskDescription] = useState('')
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState(null)

  // Fetch all tasks
  const fetchTasks = async () => {
    try {
      setLoading(true)
      setError(null)
      const response = await axios.get(`${API_URL}/tasks`)
      setTasks(response.data)
    } catch (err) {
      setError('Failed to fetch tasks. Make sure the backend is running.')
      console.error('Error fetching tasks:', err)
    } finally {
      setLoading(false)
    }
  }

  // Load tasks on component mount
  useEffect(() => {
    fetchTasks()
  }, [])

  // Create a new task
  const handleCreateTask = async (e) => {
    e.preventDefault()
    
    if (!newTaskTitle.trim()) {
      return
    }

    try {
      setError(null)
      const response = await axios.post(`${API_URL}/tasks`, {
        title: newTaskTitle,
        description: newTaskDescription
      })
      
      setTasks([...tasks, response.data])
      setNewTaskTitle('')
      setNewTaskDescription('')
    } catch (err) {
      setError('Failed to create task')
      console.error('Error creating task:', err)
    }
  }

  // Toggle task completion
  const handleToggleComplete = async (task) => {
    try {
      setError(null)
      const response = await axios.put(`${API_URL}/tasks/${task.id}`, {
        completed: !task.completed
      })
      
      setTasks(tasks.map(t => t.id === task.id ? response.data : t))
    } catch (err) {
      setError('Failed to update task')
      console.error('Error updating task:', err)
    }
  }

  // Delete a task
  const handleDeleteTask = async (taskId) => {
    try {
      setError(null)
      await axios.delete(`${API_URL}/tasks/${taskId}`)
      setTasks(tasks.filter(t => t.id !== taskId))
    } catch (err) {
      setError('Failed to delete task')
      console.error('Error deleting task:', err)
    }
  }

  return (
    <div className="app">
      <div className="container">
        <header className="header">
          <h1>Task Manager</h1>
          <p className="subtitle">Organize your tasks efficiently</p>
        </header>

        {error && (
          <div className="error-message">
            {error}
          </div>
        )}

        <form className="task-form" onSubmit={handleCreateTask}>
          <div className="form-group">
            <input
              type="text"
              placeholder="Task title"
              value={newTaskTitle}
              onChange={(e) => setNewTaskTitle(e.target.value)}
              className="input"
            />
          </div>
          <div className="form-group">
            <textarea
              placeholder="Task description (optional)"
              value={newTaskDescription}
              onChange={(e) => setNewTaskDescription(e.target.value)}
              className="textarea"
              rows="3"
            />
          </div>
          <button type="submit" className="btn btn-primary">
            Add Task
          </button>
        </form>

        <div className="tasks-section">
          <h2>Tasks ({tasks.length})</h2>
          
          {loading ? (
            <p className="loading">Loading tasks...</p>
          ) : tasks.length === 0 ? (
            <p className="empty-state">No tasks yet. Create one to get started!</p>
          ) : (
            <div className="tasks-list">
              {tasks.map((task) => (
                <div key={task.id} className={`task-card ${task.completed ? 'completed' : ''}`}>
                  <div className="task-content">
                    <div className="task-header">
                      <input
                        type="checkbox"
                        checked={task.completed}
                        onChange={() => handleToggleComplete(task)}
                        className="checkbox"
                      />
                      <h3 className={task.completed ? 'task-title-completed' : ''}>
                        {task.title}
                      </h3>
                    </div>
                    {task.description && (
                      <p className="task-description">{task.description}</p>
                    )}
                    <p className="task-date">
                      Created: {new Date(task.created_at).toLocaleString()}
                    </p>
                  </div>
                  <button
                    onClick={() => handleDeleteTask(task.id)}
                    className="btn btn-delete"
                  >
                    Delete
                  </button>
                </div>
              ))}
            </div>
          )}
        </div>
      </div>
    </div>
  )
}

export default App
