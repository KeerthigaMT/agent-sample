# Task Manager App - Docker Setup

This project includes Docker configuration for easy deployment.

## Prerequisites

- Docker Desktop installed and running
- Docker Compose (included with Docker Desktop)

## Running with Docker

### Quick Start

1. **Start all services:**
   ```bash
   docker-compose up --build
   ```

2. **Access the application:**
   - Frontend: http://localhost:3000
   - Backend API: http://localhost:5000

3. **Stop all services:**
   ```bash
   docker-compose down
   ```

### Detailed Docker Commands

**Build and start containers in detached mode:**
```bash
docker-compose up -d --build
```

**View logs:**
```bash
docker-compose logs -f
```

**View specific service logs:**
```bash
docker-compose logs -f backend
docker-compose logs -f frontend
```

**Stop containers:**
```bash
docker-compose stop
```

**Remove containers:**
```bash
docker-compose down
```

**Remove containers and volumes:**
```bash
docker-compose down -v
```

**Rebuild a specific service:**
```bash
docker-compose up -d --build backend
docker-compose up -d --build frontend
```

## Docker Architecture

- **Backend Container:** Python Flask API on port 5000
- **Frontend Container:** React + Vite dev server on port 3000
- **Network:** Both containers communicate via `taskmanager-network`

## Development Workflow

1. Make code changes in your editor
2. Rebuild the specific container:
   ```bash
   docker-compose up -d --build backend  # for backend changes
   docker-compose up -d --build frontend # for frontend changes
   ```
3. View logs to debug:
   ```bash
   docker-compose logs -f
   ```

## Troubleshooting

**Port already in use:**
```bash
# Check what's using the port
netstat -ano | findstr :5000
netstat -ano | findstr :3000

# Change ports in docker-compose.yml if needed
```

**Container won't start:**
```bash
# Check container status
docker-compose ps

# View detailed logs
docker-compose logs backend
docker-compose logs frontend
```

**Rebuild from scratch:**
```bash
docker-compose down
docker-compose build --no-cache
docker-compose up
```

## Production Deployment

For production, consider:
- Using production builds for the frontend
- Adding environment variables for configuration
- Using a production WSGI server (gunicorn) for Flask
- Setting up proper logging
- Adding health checks
