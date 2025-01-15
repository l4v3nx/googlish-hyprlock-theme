#!/bin/bash

# Set paths
CONFIG_DIR="$HOME/.config/hypr"
BACKUP_DIR="$HOME/.config/hypr/hyprlock-backup-$(date +%Y%m%d%H%M%S)"
REPO_URL="https://github.com/Tamarindtype/googlish-hyprlock-theme.git"

# Backup existing configuration folder and file
echo "Checking for existing configurations to back up..."
if [ -d "$CONFIG_DIR/hyprlock" ] || [ -f "$CONFIG_DIR/hyprlock.conf" ]; then
    echo "Creating backup directory: $BACKUP_DIR"
    mkdir -p "$BACKUP_DIR"
    
    if [ -d "$CONFIG_DIR/hyprlock" ]; then
        echo "Backing up folder: $CONFIG_DIR/hyprlock"
        mv "$CONFIG_DIR/hyprlock" "$BACKUP_DIR/"
    fi
    
    if [ -f "$CONFIG_DIR/hyprlock.conf" ]; then
        echo "Backing up file: $CONFIG_DIR/hyprlock.conf"
        mv "$CONFIG_DIR/hyprlock.conf" "$BACKUP_DIR/"
    fi
else
    echo "No existing hyprlock configuration found. Skipping backup."
fi

# Clone the repository
echo "Cloning repository..."
git clone "$REPO_URL"

# Move files to the config directory
echo "Moving files to $CONFIG_DIR..."
mkdir -p "$CONFIG_DIR"
mv ./googlish-hyprlock-theme/* "$CONFIG_DIR/"

# Navigate to the hyprlock directory
echo "Navigating to $CONFIG_DIR/hyprlock..."
cd "$CONFIG_DIR/hyprlock/" || { echo "Directory $CONFIG_DIR/hyprlock/ not found!"; exit 1; }

# Make scripts executable
echo "Making scripts executable..."
chmod +x *.sh

# Run hyprlock
echo "Running hyprlock..."
hyprlock
