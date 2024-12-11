#!/bin/bash
# Deployment script for a Next.js application with dependency checks

# Function to check if a command exists
command_exists () {
    type "$1" &> /dev/null ;
}

# App directory path variable
APP_DIR="/home/opc/ep_learning_app"

# Git Repository URL
GIT_REPO_URL="git@github.com:erklat/ep_learning_app.git"

# Check if application directory exists, create it if not
if [ ! -d "$APP_DIR" ]; then
    echo "Application directory not found. Creating directory..."
    mkdir -p "$APP_DIR"
fi

# Navigate to the application directory
cd "$APP_DIR"

# Check for npm and Node.js
if command_exists npm ; then
    echo "npm is installed."
else
    echo "Error: npm is not installed." >&2
    exit 1
fi

# Check for Git
if command_exists git ; then
    echo "Git is installed."
else
    echo "Error: Git is not installed." >&2
    exit 1
fi

# Check if a Git repository has been initialized
if git rev-parse --git-dir > /dev/null 2>&1; then
    echo "Git repository is initialized."
    git pull origin master  # Fetch the latest code
else
    echo "No Git repository found. Cloning repository..."
    git clone $GIT_REPO_URL $APP_DIR
    # Navigate into the directory if git clone does not change directory
    cd "$APP_DIR"
fi

# Install project dependencies
npm install --legacy-peer-deps

# Check for PM2 and install if it's not available
if command_exists pm2 ; then
    echo "PM2 is installed."
else
    echo "PM2 is not installed, installing PM2..."
    npm install -g pm2
fi


# Build the project
npm run build

# Start or restart the Next.js application using PM2
pm2 list | grep "next-app" && pm2 restart next-app || pm2 start npm --name "next-app" -- run start

# Verify the PM2 status and echo success message only when app is running
if pm2 list | grep -q "next-app.*online"; then
    echo "Deployment of Next.js application successful!"
else
    echo "Failed to start the Next.js application, please check logs."
    exit 1
fi