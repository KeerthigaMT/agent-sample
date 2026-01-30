# Opsera Agent Registration Script (PowerShell)
# This script helps register the Task Manager as an Opsera Agent

Write-Host "==================================" -ForegroundColor Cyan
Write-Host "Task Manager Opsera Agent Setup" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""

# Check if Docker is running
try {
    docker info | Out-Null
    Write-Host "✅ Docker is running" -ForegroundColor Green
} catch {
    Write-Host "❌ Docker is not running. Please start Docker Desktop." -ForegroundColor Red
    exit 1
}

# Build and start the agent
Write-Host ""
Write-Host "Building and starting the Task Manager Agent..." -ForegroundColor Yellow
docker-compose up -d --build

# Wait for services to be ready
Write-Host ""
Write-Host "Waiting for services to start..." -ForegroundColor Yellow
Start-Sleep -Seconds 10

# Check backend health
try {
    $response = Invoke-WebRequest -Uri "http://localhost:5000/api/health" -UseBasicParsing
    Write-Host "✅ Backend is healthy" -ForegroundColor Green
} catch {
    Write-Host "❌ Backend health check failed" -ForegroundColor Red
    exit 1
}

# Check frontend
try {
    $frontendResponse = Invoke-WebRequest -Uri "http://localhost:3000" -UseBasicParsing
    Write-Host "✅ Frontend is accessible" -ForegroundColor Green
} catch {
    Write-Host "⚠️  Frontend may not be ready yet (this is normal)" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "==================================" -ForegroundColor Cyan
Write-Host "Agent is running!" -ForegroundColor Green
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "📍 Access Points:" -ForegroundColor Cyan
Write-Host "   - Frontend: http://localhost:3000" -ForegroundColor White
Write-Host "   - Backend API: http://localhost:5000/api" -ForegroundColor White
Write-Host "   - Health Check: http://localhost:5000/api/health" -ForegroundColor White
Write-Host ""
Write-Host "📋 Next Steps to Register in Opsera:" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Log in to Opsera Agent UI:" -ForegroundColor Yellow
Write-Host "   https://opsera-agentui-dev.agent.opsera.dev/agents" -ForegroundColor White
Write-Host ""
Write-Host "2. Click 'Add Custom Agent' or look for the '+' button" -ForegroundColor Yellow
Write-Host ""
Write-Host "3. Fill in the agent details:" -ForegroundColor Yellow
Write-Host "   - Name: Task Manager Agent" -ForegroundColor White
Write-Host "   - Display Name: Task Manager" -ForegroundColor White
Write-Host "   - Category: Developer" -ForegroundColor White
Write-Host "   - Description: Task management with Python Flask and React" -ForegroundColor White
Write-Host "   - Repository: https://github.com/KeerthigaMT/agent-sample" -ForegroundColor White
Write-Host "   - Icon: 📝" -ForegroundColor White
Write-Host "   - Pricing: Free Trial" -ForegroundColor White
Write-Host ""
Write-Host "4. Configuration:" -ForegroundColor Yellow
Write-Host "   - Docker Support: Yes" -ForegroundColor White
Write-Host "   - Docker Compose: Yes" -ForegroundColor White
Write-Host "   - Backend Port: 5000" -ForegroundColor White
Write-Host "   - Frontend Port: 3000" -ForegroundColor White
Write-Host ""
Write-Host "5. Upload or reference these files:" -ForegroundColor Yellow
Write-Host "   - agent-config.json (configuration)" -ForegroundColor White
Write-Host "   - AGENT_README.md (documentation)" -ForegroundColor White
Write-Host "   - docker-compose.yml (deployment)" -ForegroundColor White
Write-Host ""
Write-Host "6. Test the agent endpoints:" -ForegroundColor Yellow
Write-Host "   - Base URL: http://localhost:5000/api" -ForegroundColor White
Write-Host "   - GET /tasks - List all tasks" -ForegroundColor White
Write-Host "   - POST /tasks - Create a task" -ForegroundColor White
Write-Host "   - GET /health - Health check" -ForegroundColor White
Write-Host ""
Write-Host "📖 Documentation:" -ForegroundColor Cyan
Write-Host "   - OPSERA_MCP_INTEGRATION.md - MCP integration guide" -ForegroundColor White
Write-Host "   - DOCKER.md - Docker deployment guide" -ForegroundColor White
Write-Host "   - AGENT_README.md - Agent documentation" -ForegroundColor White
Write-Host ""
Write-Host "⚙️  Useful Commands:" -ForegroundColor Cyan
Write-Host "   - View logs: docker-compose logs -f" -ForegroundColor White
Write-Host "   - Stop agent: docker-compose down" -ForegroundColor White
Write-Host "   - Restart: docker-compose restart" -ForegroundColor White
Write-Host "   - Check status: docker-compose ps" -ForegroundColor White
Write-Host ""
