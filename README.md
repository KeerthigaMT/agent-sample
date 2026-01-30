# Task Manager App

A simple and beautiful task manager application with a React frontend and Python Flask backend.

## Features

- Create, read, update, and delete tasks
- Mark tasks as complete/incomplete
- Modern, responsive UI with gradient design
- RESTful API backend
- Real-time updates

## Project Structure

```
agent-sample/
├── backend/           # Python Flask backend
│   ├── app.py        # Main Flask application
│   ├── requirements.txt
│   └── README.md
├── frontend/          # React frontend
│   ├── src/
│   │   ├── App.jsx   # Main React component
│   │   ├── main.jsx
│   │   ├── App.css
│   │   └── index.css
│   ├── index.html
│   ├── package.json
│   ├── vite.config.js
│   └── README.md
└── README.md         # This file
```

## Quick Start

### Prerequisites

- **Python 3.8+**: Download from [python.org](https://www.python.org/downloads/)
- **Node.js 18+**: Already installed (v24.13.0)

### Backend Setup

1. Navigate to the backend directory:
```bash
cd backend
```

2. Create a virtual environment:
```bash
python -m venv venv
```

3. Activate the virtual environment:
   - **Windows**: `venv\Scripts\activate`
   - **Mac/Linux**: `source venv/bin/activate`

4. Install dependencies:
```bash
pip install -r requirements.txt
```

5. Run the Flask server:
```bash
python app.py
```

The backend will start on `http://localhost:5000`

### Frontend Setup

1. Open a new terminal and navigate to the frontend directory:
```bash
cd frontend
```

2. Install dependencies:
```bash
npm install
```

3. Start the development server:
```bash
npm run dev
```

The frontend will start on `http://localhost:3000`

## Usage

1. Open your browser and go to `http://localhost:3000`
2. Add tasks using the form at the top
3. Click the checkbox to mark tasks as complete
4. Click the Delete button to remove tasks

## API Endpoints

- `GET /api/tasks` - Get all tasks
- `POST /api/tasks` - Create a new task
- `PUT /api/tasks/<task_id>` - Update a task
- `DELETE /api/tasks/<task_id>` - Delete a task
- `GET /api/health` - Health check

## Technologies Used

### Backend
- Flask - Web framework
- Flask-CORS - Cross-origin resource sharing
- Python 3

### Frontend
- React 18 - UI library
- Vite - Build tool and dev server
- Axios - HTTP client
- Modern CSS with gradients and animations

## Development Notes

- The backend uses in-memory storage (tasks are lost on restart)
- CORS is enabled for local development
- The frontend proxies API requests to the backend
- Hot reload is enabled for both frontend and backend

## Future Enhancements

- Add database persistence (SQLite or PostgreSQL)
- Add user authentication
- Add task categories/tags
- Add due dates and reminders
- Add task priority levels
- Add search and filter functionality
