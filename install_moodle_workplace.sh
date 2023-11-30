#!/bin/bash

# Ask the user for the name of the site
echo -n "Enter the name of the site: "
read SITE_NAME

echo -n "Enter the name of the repository"
read REPOSITORY_NAME

# Path to the ZIP file
ZIP_FILE="/home/xare/repositories/$REPOSITORY_NAME"

# Destination directory
DEST_DIR="/var/www/html/$SITE_NAME"

# Check if the ZIP file exists
if [ ! -f "$ZIP_FILE" ]; then
    echo "Error: ZIP file not found at $ZIP_FILE"
    exit 1
fi

# Create destination directory if it doesn't exist
if [ ! -d "$DEST_DIR" ]; then
    echo "Creating directory $DEST_DIR"
    mkdir -p "$DEST_DIR"
fi

# Unzip the file to the destination directory
echo "Deploying site to $DEST_DIR"
unzip -o "$ZIP_FILE" -d "$DEST_DIR"

echo "Deployment complete."
