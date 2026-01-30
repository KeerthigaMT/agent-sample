# Task Manager Backend

Python Flask backend for the Task Manager application.

## Setup

1. Install Python 3.8 or higher from [python.org](https://www.python.org/downloads/)

2. Create a virtual environment:
```bash
python -m venv venv
```

3. Activate the virtual environment:
   - Windows: `venv\Scripts\activate`
   - Mac/Linux: `source venv/bin/activate`

4. Install dependencies:
```bash
pip install -r requirements.txt
```

## Running the Server

```bash
python app.py
```

The server will start on `http://localhost:5000`

## API Endpoints

- `GET /api/tasks` - Get all tasks
- `POST /api/tasks` - Create a new task
- `PUT /api/tasks/<task_id>` - Update a task
- `DELETE /api/tasks/<task_id>` - Delete a task
- `GET /api/health` - Health check
