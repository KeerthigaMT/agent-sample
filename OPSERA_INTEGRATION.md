# Opsera Integration Guide

This guide explains how to integrate the Task Manager application with Opsera using the Opsera MCP server.

## Available Opsera MCP Servers

1. **opsera-public-api** - Production Opsera Public API
2. **opsera-dev** - Development Opsera API (requires authentication)

## Integration Possibilities

### 1. Task Synchronization with Opsera

Sync your task manager tasks with Opsera's task management:

**Available Opsera Task APIs:**
- `post_api_v2_tasks` - Get all Opsera tasks
- `post_api_v2_task` - Create/manage individual tasks
- `post_api_v2_tasks_status` - Get task status
- `post_api_v2_tasks_lookup` - Lookup specific tasks

### 2. Pipeline Integration

Integrate tasks with Opsera pipelines:

**Pipeline APIs:**
- `post_api_v2_pipelines_validate` - Validate pipeline configurations
- `post_api_v2_pipelines_step-metadata` - Get pipeline step metadata
- `post_api_v2_pipelines_pipeline-run_notification` - Handle pipeline notifications

### 3. Project Management

Link tasks to Opsera projects:

**Project APIs:**
- `post_api_v2_data_project` - Create projects in Opsera
- `put_api_v2_data_project_projectId` - Update project details

### 4. User Management Integration

Connect task assignments with Opsera users:

**User APIs:**
- `get_api_v2_usermanagement_user` - Search users by email
- `get_api_v2_usermanagement_users` - Get all users
- `post_api_v2_usermanagement_user` - Create users
- `get_api_v2_usermanagement_groups` - Get user groups
- `post_api_v2_usermanagement_group` - Create groups

### 5. SCM Integration

Link tasks to GitHub repositories:

**SCM APIs:**
- `post_api_v2_tools_scm_repositories` - Get repository information
- `post_api_v2_tools_scm_branches` - List repository branches

## Implementation Examples

### Example 1: Create Task in Opsera When Task Manager Task is Created

Add to `backend/app.py`:

```python
import requests
import os

OPSERA_API_URL = os.getenv('OPSERA_API_URL', 'https://api.opsera.io/api/v2')
OPSERA_API_KEY = os.getenv('OPSERA_API_KEY')

@app.route('/api/tasks', methods=['POST'])
def create_task():
    """Create a new task and sync with Opsera"""
    data = request.get_json()
    
    if not data or 'title' not in data:
        return jsonify({'error': 'Title is required'}), 400
    
    # Create task locally
    task = {
        'id': str(uuid.uuid4()),
        'title': data['title'],
        'description': data.get('description', ''),
        'completed': False,
        'created_at': datetime.now().isoformat()
    }
    tasks.append(task)
    
    # Sync with Opsera (optional)
    if OPSERA_API_KEY:
        try:
            opsera_response = requests.post(
                f'{OPSERA_API_URL}/task',
                headers={
                    'Authorization': f'Bearer {OPSERA_API_KEY}',
                    'Content-Type': 'application/json'
                },
                json={
                    'name': task['title'],
                    'description': task['description'],
                    'externalId': task['id']
                }
            )
            if opsera_response.ok:
                task['opsera_task_id'] = opsera_response.json().get('id')
        except Exception as e:
            print(f"Failed to sync with Opsera: {e}")
    
    return jsonify(task), 201
```

### Example 2: Link Tasks to Opsera Projects

```python
@app.route('/api/tasks/<task_id>/link-project', methods=['POST'])
def link_to_opsera_project(task_id):
    """Link a task to an Opsera project"""
    data = request.get_json()
    project_id = data.get('project_id')
    
    task = next((t for t in tasks if t['id'] == task_id), None)
    if not task:
        return jsonify({'error': 'Task not found'}), 404
    
    # Link to Opsera project
    if OPSERA_API_KEY and project_id:
        try:
            response = requests.put(
                f'{OPSERA_API_URL}/data/project/{project_id}',
                headers={
                    'Authorization': f'Bearer {OPSERA_API_KEY}',
                    'Content-Type': 'application/json'
                },
                json={
                    'assets': {
                        'tasks': [task_id]
                    }
                }
            )
            if response.ok:
                task['opsera_project_id'] = project_id
        except Exception as e:
            return jsonify({'error': str(e)}), 500
    
    return jsonify(task)
```

### Example 3: Using MCP Server Directly in Cursor

You can use the Opsera MCP tools directly via Cursor's MCP integration:

```python
# In your Python code, you can make calls through the MCP server
# The MCP server handles authentication and API communication

# Example: Get Opsera user information
from cursor_mcp import call_mcp_tool

user_info = call_mcp_tool(
    server="user-opsera-public-api",
    tool_name="get_api_v2_usermanagement_user",
    arguments={"search": "email=keerthiga@opsera.io"}
)

# Example: Create Opsera project
project = call_mcp_tool(
    server="user-opsera-public-api",
    tool_name="post_api_v2_data_project",
    arguments={
        "projectId": "task-manager-001",
        "projectName": "Task Manager Application",
        "department": "Engineering",
        "organization": "Opsera"
    }
)
```

## Environment Configuration

Add to your `.env` file (create if doesn't exist):

```env
# Opsera API Configuration
OPSERA_API_URL=https://api.opsera.io/api/v2
OPSERA_API_KEY=your_opsera_api_key_here
OPSERA_ORG_ID=your_org_id_here

# Optional: Specific Opsera configurations
OPSERA_PROJECT_ID=task-manager-project
OPSERA_SYNC_ENABLED=true
```

Update `backend/requirements.txt`:

```txt
Flask==3.0.0
flask-cors==4.0.0
requests==2.31.0
python-dotenv==1.0.0
```

Update `backend/app.py` to load environment variables:

```python
from dotenv import load_dotenv
import os

load_dotenv()

# ... rest of your app code
```

## Docker Integration

Update `docker-compose.yml` to include Opsera configuration:

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
      - OPSERA_API_URL=${OPSERA_API_URL:-https://api.opsera.io/api/v2}
      - OPSERA_API_KEY=${OPSERA_API_KEY}
      - OPSERA_SYNC_ENABLED=${OPSERA_SYNC_ENABLED:-false}
    env_file:
      - .env
    networks:
      - taskmanager-network
    restart: unless-stopped

  # ... rest of docker-compose.yml
```

## Integration Workflows

### Workflow 1: CI/CD Pipeline Trigger on Task Completion

When a task is marked as complete, trigger an Opsera pipeline:

1. Task marked complete in UI
2. Backend validates pipeline configuration
3. Trigger Opsera pipeline using `post_api_v2_pipelines_validate`
4. Monitor pipeline status

### Workflow 2: Automatic Project Creation

When creating a new project-related task:

1. User creates task with project tag
2. System checks if Opsera project exists
3. If not, create project using `post_api_v2_data_project`
4. Link task to project
5. Add task to project assets

### Workflow 3: User Assignment Integration

Assign tasks to Opsera users:

1. Search Opsera users using `get_api_v2_usermanagement_user`
2. Assign task to user
3. Notify user through Opsera
4. Track assignment in both systems

## Next Steps

1. **Set up authentication** with Opsera API
2. **Enable opsera-dev MCP server** in Cursor settings (currently requires auth)
3. **Implement desired integration points** from the examples above
4. **Test integration** with Opsera sandbox/dev environment first
5. **Deploy to production** once validated

## Authentication Setup

To use the Opsera MCP server:

1. Go to **Cursor Settings** → **MCP Servers**
2. Find **opsera-dev** server
3. Click **Authenticate** or check status
4. Follow authentication flow

## Resources

- Opsera API Documentation: https://docs.opsera.io
- Opsera Public API: Available through MCP server
- MCP Tools: All available in `C:\Users\keert\.cursor\projects\c-Users-keert-agent-sample\mcps\user-opsera-public-api\tools\`

## Support

For questions about Opsera integration:
- Contact: keerthiga@opsera.io
- Opsera Support: https://support.opsera.io
