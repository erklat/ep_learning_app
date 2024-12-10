#!/bin/bash
# Deployment script for a Next.js application

# Navigate to the application directory
cd /path/to/your/nextjs-application

# Fetch the latest code
git pull origin main

# Install dependencies
npm install

# Build the project
npm run build

# Start or restart the Next.js application
# Check if the app is running and use restart. If not, use start.
pm2 list | grep "next-app" && pm2 restart next-app || pm2 start npm --name "next-app" -- run start

echo "Deployment of Next.js application successful!"