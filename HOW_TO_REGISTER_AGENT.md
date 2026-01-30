# How to Register Your Task Manager as an Opsera Agent

## ✅ Prerequisites Checklist

- [x] Task Manager app is running (Docker containers active)
- [x] Agent configuration files created
- [x] GitHub repository available
- [ ] Logged into Opsera Agent UI

## 📍 Current Status

Your Task Manager is running and accessible:
- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:5000/api
- **Health Check**: http://localhost:5000/api/health
- **GitHub Repo**: https://github.com/KeerthigaMT/agent-sample

## 🚀 Step-by-Step Registration Process

### Step 1: Access Opsera Agent UI

1. Go to: **https://opsera-agentui-dev.agent.opsera.dev/agents**
2. Log in with your Opsera credentials (keerthiga@opsera.io)
3. You should see the Agents page with 65 agents

### Step 2: Create a New Agent

Look for one of these options on the Agents page:
- **"+ Add Agent"** button (usually top right)
- **"Create Custom Agent"** button
- **"New Agent"** or **"+"** icon

Click on it to start the agent creation process.

### Step 3: Fill in Agent Details

**Basic Information:**
```
Name: task_manager_agent
Display Name: Task Manager Agent
Category: Developer
Description: A simple task management agent with React frontend and Python Flask backend. Manages tasks with create, update, delete, and completion tracking capabilities.
Icon: 📝 (or upload a custom icon)
Version: 1.0.0
```

**Pricing:**
```
Type: Free Trial
Price: $0/mo
```

**Author Information:**
```
Author Name: Keerthiga
Author Email: keerthiga@opsera.io
Organization: Opsera
```

**Repository:**
```
Type: Git
URL: https://github.com/KeerthigaMT/agent-sample
Branch: main
```

### Step 4: Configure Technical Details

**Deployment Configuration:**
```json
{
  "type": "docker",
  "docker_compose": true,
  "dockerfile": true,
  "backend_port": 5000,
  "frontend_port": 3000
}
```

**API Endpoints:**
```
Base URL: http://localhost:5000/api

Endpoints:
- GET /tasks - Get all tasks
- POST /tasks - Create a new task
- PUT /tasks/{task_id} - Update a task
- DELETE /tasks/{task_id} - Delete a task
- GET /health - Health check endpoint
```

**Environment Variables (Optional):**
```
OPSERA_SYNC_ENABLED (optional) - Enable sync with Opsera platform
OPSERA_API_KEY (optional) - API key for Opsera integration
```

### Step 5: Upload Configuration Files

You may need to upload or reference these files:

**1. Agent Configuration** (`agent-config.json`):
- Located at: `c:\Users\keert\agent-sample\agent-config.json`
- Contains: Agent metadata, endpoints, capabilities

**2. Documentation** (`AGENT_README.md`):
- Located at: `c:\Users\keert\agent-sample\AGENT_README.md`
- Contains: Usage guide, API documentation

**3. Docker Configuration** (`docker-compose.yml`):
- Already in your repo
- Defines: Service configuration, ports, networking

### Step 6: Set Agent Capabilities

**Capabilities to Highlight:**
- ✅ Task CRUD Operations (Create, Read, Update, Delete)
- ✅ Real-time Task Status Tracking
- ✅ RESTful API Endpoints
- ✅ Docker Containerized Deployment
- ✅ Modern React UI with Vite
- ✅ Opsera MCP Integration Ready
- ✅ GitHub Repository Sync

**Tags:**
```
task-management, productivity, python, react, flask, docker, rest-api
```

### Step 7: Configure Integration Points

**Input Parameters:**
```json
[
  {
    "name": "task_title",
    "type": "string",
    "required": true,
    "description": "Title of the task to create"
  },
  {
    "name": "task_description",
    "type": "string",
    "required": false,
    "description": "Detailed description of the task"
  }
]
```

**Output Parameters:**
```json
[
  {
    "name": "task_id",
    "type": "string",
    "description": "Unique identifier for the created task"
  },
  {
    "name": "status",
    "type": "string",
    "description": "Task completion status (completed/pending)"
  }
]
```

### Step 8: Test the Agent

Before publishing, test these endpoints:

**Health Check:**
```bash
curl http://localhost:5000/api/health
```
Expected: `{"status": "healthy", "tasks_count": 0}`

**Create Task:**
```bash
curl -X POST http://localhost:5000/api/tasks \
  -H "Content-Type: application/json" \
  -d '{"title": "Test Task", "description": "Testing Opsera Agent"}'
```

**Get Tasks:**
```bash
curl http://localhost:5000/api/tasks
```

### Step 9: Publish/Save the Agent

1. Review all the information you entered
2. Click **"Save"** or **"Publish"** button
3. Your agent should now appear in the Agents list!

## 🎯 Alternative: Use Existing Agent Template

If Opsera provides a template similar to the agents shown in your screenshot, you can:

1. Look for agents like:
   - `opsera_cicd_deploy` (similar deployment pattern)
   - `opsera_cicd_dockerfile` (similar Docker setup)

2. Click **"Clone"** or **"Use as Template"**

3. Modify the configuration:
   - Change the name to `task_manager_agent`
   - Update repository to your GitHub repo
   - Adjust endpoints and ports
   - Update description and capabilities

## 📋 Quick Reference Card

**Copy/Paste Ready Information:**

```
Agent Name: task_manager_agent
Display Name: Task Manager Agent
Category: Developer
Icon: 📝
Pricing: Free Trial ($0/mo)

Repository: https://github.com/KeerthigaMT/agent-sample
Backend Port: 5000
Frontend Port: 3000

Base API URL: http://localhost:5000/api
Health Endpoint: /health

Docker: Yes (docker-compose.yml included)
Documentation: AGENT_README.md
Configuration: agent-config.json

Key Features:
- Task CRUD operations
- React UI (port 3000)
- Flask API (port 5000)
- Docker containerized
- RESTful endpoints
- Opsera MCP ready
```

## 🔍 Verification Steps

After registration, verify your agent appears:

1. **In Agent List**: Should show in the "Developer" category
2. **Agent Card**: Should display "Free Trial" badge
3. **Details Page**: Click on your agent to see full details
4. **Uses Count**: Should show "0 uses" initially

## 📞 Need Help?

If you encounter issues:

1. **Check Agent UI Documentation**: Look for help/docs section in Opsera UI
2. **Verify Docker Status**: Run `docker-compose ps` to ensure containers are running
3. **Test Endpoints**: Make sure API responds before registering
4. **Contact Support**: keerthiga@opsera.io or Opsera support team

## 🎉 Success Indicators

You'll know registration was successful when:
- ✅ Agent appears in the Agents list (https://opsera-agentui-dev.agent.opsera.dev/agents)
- ✅ Agent card shows "Free Trial" badge
- ✅ You can click on the agent to view details
- ✅ Agent status shows as "Available" or "Active"
- ✅ Other users in your org can see and use the agent

## 🚀 Next Steps After Registration

1. **Share with Team**: Other Opsera users can now discover your agent
2. **Monitor Usage**: Track how many times your agent is used
3. **Iterate**: Update agent based on feedback
4. **Integrate**: Connect with Opsera pipelines and workflows
5. **Enhance**: Add more features and capabilities

## 📝 Files Created for You

All necessary files are ready in your project:
- ✅ `agent-config.json` - Agent configuration metadata
- ✅ `AGENT_README.md` - Agent documentation
- ✅ `register-agent.ps1` - Windows registration script
- ✅ `register-agent.sh` - Linux/Mac registration script
- ✅ `OPSERA_MCP_INTEGRATION.md` - MCP integration guide

Good luck with your agent registration! 🎊
