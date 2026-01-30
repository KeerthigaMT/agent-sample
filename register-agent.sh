#!/bin/bash

# Opsera Agent Registration Script
# This script helps register the Task Manager as an Opsera Agent

echo "=================================="
echo "Task Manager Opsera Agent Setup"
echo "=================================="
echo ""

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker Desktop."
    exit 1
fi

echo "✅ Docker is running"

# Build and start the agent
echo ""
echo "Building and starting the Task Manager Agent..."
docker-compose up -d --build

# Wait for services to be ready
echo ""
echo "Waiting for services to start..."
sleep 10

# Check backend health
BACKEND_HEALTH=$(curl -s http://localhost:5000/api/health)
if [ $? -eq 0 ]; then
    echo "✅ Backend is healthy"
else
    echo "❌ Backend health check failed"
    exit 1
fi

# Check frontend
FRONTEND_CHECK=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3000)
if [ "$FRONTEND_CHECK" = "200" ]; then
    echo "✅ Frontend is accessible"
else
    echo "⚠️  Frontend may not be ready yet (this is normal)"
fi

echo ""
echo "=================================="
echo "Agent is running!"
echo "=================================="
echo ""
echo "📍 Access Points:"
echo "   - Frontend: http://localhost:3000"
echo "   - Backend API: http://localhost:5000/api"
echo "   - Health Check: http://localhost:5000/api/health"
echo ""
echo "📋 Next Steps to Register in Opsera:"
echo ""
echo "1. Log in to Opsera Agent UI:"
echo "   https://opsera-agentui-dev.agent.opsera.dev/agents"
echo ""
echo "2. Click 'Add Custom Agent' or 'Create Agent'"
echo ""
echo "3. Fill in the agent details:"
echo "   - Name: Task Manager Agent"
echo "   - Category: Developer"
echo "   - Description: Task management with Python Flask and React"
echo "   - Repository: https://github.com/KeerthigaMT/agent-sample"
echo "   - Docker Compose: Yes"
echo "   - Ports: 5000 (backend), 3000 (frontend)"
echo ""
echo "4. Upload or link the configuration file:"
echo "   - Config file: agent-config.json"
echo "   - Documentation: AGENT_README.md"
echo ""
echo "5. Test the agent endpoints:"
echo "   - Base URL: http://localhost:5000/api"
echo "   - Health: /health"
echo "   - Tasks: /tasks"
echo ""
echo "📖 For detailed integration guide, see:"
echo "   - OPSERA_MCP_INTEGRATION.md"
echo "   - DOCKER.md"
echo ""
echo "To stop the agent: docker-compose down"
echo ""
