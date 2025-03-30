#!/bin/bash

# Create a function to clean up processes
cleanup() {
  echo "Cleaning up processes..."
  if [ ! -z "$BACKEND_PID" ]; then
    echo "Stopping backend server (PID: $BACKEND_PID)..."
    kill -TERM "$BACKEND_PID" 2>/dev/null || kill -KILL "$BACKEND_PID" 2>/dev/null
  fi
  
  if [ ! -z "$FRONTEND_PID" ]; then
    echo "Stopping frontend server (PID: $FRONTEND_PID)..."
    kill -TERM "$FRONTEND_PID" 2>/dev/null || kill -KILL "$FRONTEND_PID" 2>/dev/null
  fi
  
  # Kill any remaining processes in the process group
  pkill -P $$ 2>/dev/null
  
  echo "Cleanup complete."
  exit 0
}

# Set up traps for various termination signals
trap cleanup EXIT INT TERM

# Start the backend server
echo "Starting backend server..."
cd backend-server
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
python main.py &
BACKEND_PID=$!
echo "Backend server started with PID: $BACKEND_PID"

# Navigate to frontend server
cd ../frontend-server

# Check if yarn is installed
if ! command -v yarn &> /dev/null
then
    echo "Yarn not found, installing..."
    npm install -g yarn
fi

# Install dependencies and start frontend
echo "Installing frontend dependencies..."
yarn install
echo "Starting frontend server..."
# Start yarn in a way we can capture the PID
yarn run dev &
FRONTEND_PID=$!
echo "Frontend server started with PID: $FRONTEND_PID"

# Wait for both processes to finish
# This keeps the script running
wait $BACKEND_PID $FRONTEND_PID