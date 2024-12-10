#!/bin/bash
# Deployment script for a Next.js application with dependency checks

# Function to check if a command exists
command_exists () {
    type "$1" &> /dev/null ;
}

# App directory path variable
APP_DIR="/var/www/html"

# Check if application directory exists, create it if not
if [ ! -d "$APP_DIR" ]; then
    echo "Application directory not found. Creating directory..."
    sudo mkdir -p "$APP_DIR"
fi

# Navigate to the application directory
cd "$APP_DIR"

# Check for npm
if command_exists npm ; then
    echo "npm is installed."
else
    echo "Error: npm is not installed." >&2
    exit 1
fi

# Fetch the latest code
# Assuming the repository has been initialized; you may need to add git clone before this if needed
git pull origin main

# Install dependencies
npm install

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

# Echo success message
echo "Deployment of Next.js application successful!"