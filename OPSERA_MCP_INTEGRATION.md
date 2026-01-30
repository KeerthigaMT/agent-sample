# Integrating Task Manager with Opsera MCP Server

This guide shows how to integrate your Task Manager application with the Opsera Agent MCP server configured in your Cursor environment.

## MCP Server Configuration

Your current MCP configuration (`mcp.json`):

```json
"opsera-dev": {
  "type": "streamable-http",
  "url": "https://opseramcp-dev.agent.opsera.dev/mcp"
}
```

## Authentication Setup

⚠️ **Important**: The `opsera-dev` MCP server requires authentication.

### Steps to Authenticate:

1. Open **Cursor Settings** (Ctrl/Cmd + ,)
2. Navigate to **Features** → **MCP Servers**
3. Find **opsera-dev** in the list
4. Click **Authenticate** or check the status indicator
5. Complete the authentication flow
6. Verify the server shows as "Connected"

## Integration Approach 1: Direct MCP Tool Calls

You can call Opsera MCP tools directly from Cursor when working on your project. Here are practical examples:

### Example 1: Create an Opsera Project for Your Task Manager

```python
# backend/opsera_integration.py
"""
Opsera integration module for Task Manager
"""
import os
import requests
from typing import Optional, Dict, Any

class OpseraIntegration:
    def __init__(self):
        self.api_url = os.getenv('OPSERA_API_URL', 'https://opseramcp-dev.agent.opsera.dev')
        self.api_key = os.getenv('OPSERA_API_KEY')
        
    def create_project(self, project_name: str, project_id: str) -> Optional[Dict[str, Any]]:
        """
        Create a project in Opsera linked to this task manager
        Uses the Opsera MCP server endpoint
        """
        if not self.api_key:
            print("Warning: OPSERA_API_KEY not set")
            return None
            
        try:
            response = requests.post(
                f'{self.api_url}/api/v2/data/project',
                headers={
                    'Authorization': f'Bearer {self.api_key}',
                    'Content-Type': 'application/json'
                },
                json={
                    'projectId': project_id,
                    'projectName': project_name,
                    'department': 'Engineering',
                    'organization': 'Opsera'
                }
            )
            response.raise_for_status()
            return response.json()
        except Exception as e:
            print(f"Failed to create Opsera project: {e}")
            return None
    
    def sync_task_to_opsera(self, task: Dict[str, Any]) -> bool:
        """
        Sync a task from Task Manager to Opsera
        """
        if not self.api_key:
            return False
            
        try:
            response = requests.post(
                f'{self.api_url}/api/v2/task',
                headers={
                    'Authorization': f'Bearer {self.api_key}',
                    'Content-Type': 'application/json'
                },
                json={
                    'name': task['title'],
                    'description': task.get('description', ''),
                    'externalId': task['id'],
                    'status': 'completed' if task.get('completed') else 'pending'
                }
            )
            return response.ok
        except Exception as e:
            print(f"Failed to sync task: {e}")
            return False
```

### Example 2: Enhanced Backend with Opsera Integration

Update `backend/app.py`:

```python
from flask import Flask, request, jsonify
from flask_cors import CORS
from datetime import datetime
from dotenv import load_dotenv
import uuid
import os

# Load environment variables
load_dotenv()

app = Flask(__name__)
CORS(app)

# Opsera configuration
OPSERA_ENABLED = os.getenv('OPSERA_SYNC_ENABLED', 'false').lower() == 'true'

# In-memory storage for tasks
tasks = []

# Import Opsera integration if enabled
if OPSERA_ENABLED:
    try:
        from opsera_integration import OpseraIntegration
        opsera = OpseraIntegration()
    except ImportError:
        print("Warning: Opsera integration module not found")
        opsera = None
else:
    opsera = None

@app.route('/api/tasks', methods=['GET'])
def get_tasks():
    """Get all tasks"""
    return jsonify(tasks)

@app.route('/api/tasks', methods=['POST'])
def create_task():
    """Create a new task and optionally sync with Opsera"""
    data = request.get_json()
    
    if not data or 'title' not in data:
        return jsonify({'error': 'Title is required'}), 400
    
    task = {
        'id': str(uuid.uuid4()),
        'title': data['title'],
        'description': data.get('description', ''),
        'completed': False,
        'created_at': datetime.now().isoformat(),
        'opsera_synced': False
    }
    
    tasks.append(task)
    
    # Sync with Opsera if enabled
    if opsera and OPSERA_ENABLED:
        synced = opsera.sync_task_to_opsera(task)
        task['opsera_synced'] = synced
    
    return jsonify(task), 201

@app.route('/api/tasks/<task_id>', methods=['PUT'])
def update_task(task_id):
    """Update an existing task and sync with Opsera"""
    data = request.get_json()
    
    task = next((t for t in tasks if t['id'] == task_id), None)
    
    if not task:
        return jsonify({'error': 'Task not found'}), 404
    
    if 'title' in data:
        task['title'] = data['title']
    if 'description' in data:
        task['description'] = data['description']
    if 'completed' in data:
        task['completed'] = data['completed']
    
    # Re-sync with Opsera if enabled
    if opsera and OPSERA_ENABLED:
        synced = opsera.sync_task_to_opsera(task)
        task['opsera_synced'] = synced
    
    return jsonify(task)

@app.route('/api/opsera/status', methods=['GET'])
def opsera_status():
    """Check Opsera integration status"""
    return jsonify({
        'enabled': OPSERA_ENABLED,
        'configured': opsera is not None,
        'mcp_server': 'https://opseramcp-dev.agent.opsera.dev/mcp'
    })

# ... rest of your existing routes ...

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
```

## Integration Approach 2: Using MCP Tools via Cursor Agent

You can ask me (the Cursor AI agent) to call Opsera MCP tools on your behalf. Here are some examples:

### Example Commands You Can Ask:

1. **"Create an Opsera project for my task manager app"**
   - I'll use `post_api_v2_data_project` via MCP

2. **"Get all Opsera users with email @opsera.io"**
   - I'll use `get_api_v2_usermanagement_user` via MCP

3. **"List all available pipelines in Opsera"**
   - I'll use the appropriate Opsera MCP tool

4. **"Create a task in Opsera when I complete a local task"**
   - I'll set up the integration code

## Environment Configuration

Create a `.env` file in the `backend/` directory:

```env
# Opsera MCP Configuration
OPSERA_API_URL=https://opseramcp-dev.agent.opsera.dev
OPSERA_API_KEY=your_api_key_here
OPSERA_SYNC_ENABLED=true

# Opsera Project Details
OPSERA_PROJECT_ID=task-manager-app
OPSERA_ORG_ID=your_org_id
```

Update `backend/requirements.txt`:

```txt
Flask==3.0.0
flask-cors==4.0.0
requests==2.31.0
python-dotenv==1.0.0
```

## Docker Integration with Opsera

Update `docker-compose.yml`:

```yaml
version: '3.8'

services:
  backend:
    build:
      context: ./backend
      dockerfile: Dockerfile
    container_name: taskmanager-backend
    ports:
      - "5000:5000"
    environment:
      - FLASK_APP=app.py
      - FLASK_ENV=development
      - OPSERA_API_URL=${OPSERA_API_URL:-https://opseramcp-dev.agent.opsera.dev}
      - OPSERA_API_KEY=${OPSERA_API_KEY}
      - OPSERA_SYNC_ENABLED=${OPSERA_SYNC_ENABLED:-false}
      - OPSERA_PROJECT_ID=${OPSERA_PROJECT_ID}
    env_file:
      - .env
    networks:
      - taskmanager-network
    restart: unless-stopped

  frontend:
    build:
      context: ./frontend
      dockerfile: Dockerfile
    container_name: taskmanager-frontend
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=development
      - VITE_OPSERA_ENABLED=${OPSERA_SYNC_ENABLED:-false}
    depends_on:
      - backend
    networks:
      - taskmanager-network
    restart: unless-stopped

networks:
  taskmanager-network:
    driver: bridge
```

## Frontend Integration

Update `frontend/src/App.jsx` to show Opsera sync status:

```jsx
import React, { useState, useEffect } from 'react'
import axios from 'axios'
import './App.css'

const API_URL = 'http://localhost:5000/api'

function App() {
  const [tasks, setTasks] = useState([])
  const [opseraStatus, setOpseraStatus] = useState(null)
  // ... existing state ...

  // Check Opsera integration status
  useEffect(() => {
    const checkOpseraStatus = async () => {
      try {
        const response = await axios.get(`${API_URL}/opsera/status`)
        setOpseraStatus(response.data)
      } catch (err) {
        console.error('Failed to check Opsera status:', err)
      }
    }
    checkOpseraStatus()
  }, [])

  return (
    <div className="app">
      <div className="container">
        <header className="header">
          <h1>Task Manager</h1>
          <p className="subtitle">Organize your tasks efficiently</p>
          {opseraStatus && opseraStatus.enabled && (
            <div className="opsera-badge">
              ✓ Synced with Opsera
            </div>
          )}
        </header>
        
        {/* ... rest of your existing UI ... */}
        
      </div>
    </div>
  )
}

export default App
```

Add CSS for the Opsera badge in `frontend/src/App.css`:

```css
.opsera-badge {
  display: inline-block;
  background: linear-gradient(135deg, #10b981 0%, #059669 100%);
  color: white;
  padding: 0.5rem 1rem;
  border-radius: 20px;
  font-size: 0.875rem;
  margin-top: 0.5rem;
  font-weight: 600;
}
```

## Testing the Integration

### Step 1: Authenticate MCP Server

1. Open Cursor Settings
2. Check MCP Servers section
3. Authenticate `opsera-dev` if needed

### Step 2: Test with Cursor Agent

Ask me: **"Can you check if the Opsera MCP server is accessible?"**

I'll attempt to call an Opsera MCP tool to verify connectivity.

### Step 3: Enable Integration in Your App

1. Create `.env` file with Opsera credentials
2. Set `OPSERA_SYNC_ENABLED=true`
3. Restart Docker containers:
   ```bash
   docker-compose down
   docker-compose up --build
   ```

### Step 4: Verify Sync

1. Create a task in the UI
2. Check backend logs for Opsera sync confirmation
3. Verify the Opsera badge appears in the UI

## Available Opsera MCP Tools

Via the `opsera-public-api` server, you have access to:

- **Task Management**: Create, update, list tasks
- **Project Management**: Create/update projects
- **User Management**: Search, create users and groups
- **Pipeline Integration**: Validate and trigger pipelines
- **SCM Integration**: Access GitHub repositories and branches
- **Insights**: Create dashboards, filters, KPIs
- **Data Mapping**: Manage data transformations

## Next Steps

1. ✅ Authenticate the `opsera-dev` MCP server in Cursor
2. ✅ Add Opsera credentials to `.env` file
3. ✅ Create the `opsera_integration.py` module
4. ✅ Update `app.py` with Opsera integration
5. ✅ Update frontend to show sync status
6. ✅ Test the integration
7. ✅ Push changes to GitHub

## Need Help?

Just ask me:
- "Create an Opsera project for this app"
- "Show me all Opsera users"
- "Test the Opsera MCP connection"
- "Help me integrate with Opsera pipelines"

I can call the MCP tools directly once you authenticate the server!

## Resources

- MCP Server URL: https://opseramcp-dev.agent.opsera.dev/mcp
- Your email: keerthiga@opsera.io
- Opsera Docs: https://docs.opsera.io
