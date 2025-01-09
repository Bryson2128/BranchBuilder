#!/bin/bash

# Exit on errors
set -e

# Define the usage function
usage() {
    echo "Usage: $0 <branch-name>"
    exit 1
}

# Check if a branch name is provided
if [ -z "$1" ]; then
    echo "Error: Branch name is required."
    usage
fi

BRANCH_NAME=$1

# Pull the latest code from the branch
echo "Switching to branch: $BRANCH_NAME"
git fetch origin
git checkout $BRANCH_NAME
git pull origin $BRANCH_NAME

# Install dependencies
echo "Installing dependencies..."
npm install

# Build the project
echo "Building the project..."
npm run build

# Serve the project (Assumes a script like `npm run start` or similar is available)
echo "Starting the local server..."
npm run start &

# Capture the PID of the server process
SERVER_PID=$!

# Wait a moment to ensure the server is running
sleep 3

# Open the local server in the default web browser
# Adjust the port if your project uses a different one
echo "Opening the project in the browser..."
xdg-open "http://localhost:3000" 2>/dev/null || open "http://localhost:3000" 2>/dev/null || echo "Please open your browser and navigate to http://localhost:3000"

# Allow the user to stop the server
echo "Press [Ctrl+C] to stop the server."
wait $SERVER_PID
