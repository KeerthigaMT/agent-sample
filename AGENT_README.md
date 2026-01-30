# Task Manager Opsera Agent

An Opsera-compatible agent for task management with React frontend and Python Flask backend.

## Agent Information

- **Name**: Task Manager Agent
- **Category**: Developer
- **Type**: Free Trial
- **Repository**: https://github.com/KeerthigaMT/agent-sample

## Features

- ✅ Create, update, and delete tasks
- ✅ Track task completion status
- ✅ RESTful API endpoints
- ✅ Docker containerized deployment
- ✅ Modern React UI with Vite
- ✅ Opsera MCP integration ready

## Quick Start

### Using Docker (Recommended)

```bash
docker-compose up --build
```

Access:
- Frontend: http://localhost:3000
- Backend API: http://localhost:5000

### Manual Setup

**Backend:**
```bash
cd backend
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
pip install -r requirements.txt
python app.py
```

**Frontend:**
```bash
cd frontend
npm install
npm run dev
```

## API Endpoints

### Tasks API

- **GET** `/api/tasks` - Get all tasks
- **POST** `/api/tasks` - Create a new task
  ```json
  {
    "title": "Task title",
    "description": "Task description"
  }
  ```
- **PUT** `/api/tasks/{task_id}` - Update a task
  ```json
  {
    "title": "Updated title",
    "description": "Updated description",
    "completed": true
  }
  ```
- **DELETE** `/api/tasks/{task_id}` - Delete a task
- **GET** `/api/health` - Health check

### Response Format

```json
{
  "id": "uuid",
  "title": "Task title",
  "description": "Task description",
  "completed": false,
  "created_at": "2026-01-30T10:00:00"
}
```

## Opsera Integration

This agent is designed to integrate with Opsera's platform:

### Environment Variables

```env
OPSERA_SYNC_ENABLED=true
OPSERA_API_KEY=your_api_key
OPSERA_API_URL=https://opseramcp-dev.agent.opsera.dev
```

### MCP Server Configuration

The agent can connect to Opsera MCP servers for:
- Project management sync
- User management integration
- Pipeline triggers
- Task synchronization

See `OPSERA_MCP_INTEGRATION.md` for detailed integration guide.

## Deployment

### Docker Compose

The agent includes a complete docker-compose configuration:

```yaml
services:
  - backend: Python Flask API (Port 5000)
  - frontend: React + Vite (Port 3000)
```

### Health Monitoring

Check agent health:
```bash
curl http://localhost:5000/api/health
```

## Use Cases

1. **Development Task Tracking**: Track development tasks and stories
2. **Sprint Planning**: Manage sprint tasks and completion
3. **Personal Productivity**: Organize personal work items
4. **Team Collaboration**: Share and track team tasks
5. **Opsera Pipeline Integration**: Trigger tasks from CI/CD pipelines

## Agent Capabilities

- **Task CRUD Operations**: Full create, read, update, delete functionality
- **Real-time Updates**: Live task status updates in the UI
- **Persistent Storage**: In-memory storage (database integration ready)
- **API-First Design**: RESTful API for easy integration
- **Containerized**: Docker support for consistent deployment
- **Modern UI**: React with beautiful gradient design

## Technical Stack

**Backend:**
- Python 3.11
- Flask 3.0
- Flask-CORS
- Docker

**Frontend:**
- React 18
- Vite 5
- Axios
- Modern CSS

## Contributing

This is an open-source Opsera agent. Contributions welcome!

## Support

- Email: keerthiga@opsera.io
- Repository: https://github.com/KeerthigaMT/agent-sample
- Documentation: See `/docs` folder

## License

Open Source - Free to use and modify

## Version History

- **v1.0.0** (2026-01-30): Initial release
  - Basic task CRUD operations
  - Docker support
  - Opsera MCP integration ready
