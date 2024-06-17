#!/usr/bin/env bash

DIRECTORY_PATH=$1
DOT_OBSIDIAN_PATH="$DIRECTORY_PATH/.obsidian"
APP_JSON="$DOT_OBSIDIAN_PATH/app.json"
HOTKEYS_JSON="$DOT_OBSIDIAN_PATH/hotkeys.json"
VIM_RC="$DIRECTORY_PATH/.obsidian.vimrc"

# Function to display usage instructions
function usage() {
    echo "Usage: $0 <path-to-vault-directory>"
    echo "Example: $0 ~/Vault"
    exit 1
}

# Function to check if file exists
function fail_if_file_not_exists() {
    local file=$1
    if [ ! -f "$file" ]; then
        echo "Error: $file does not exist"
        exit 1
    fi
}

# Function to backup file
function create_backup_file() {
    local file=$1
    local current_date=$(date -u +%Y-%m-%dT%H:%M:%S%Z)
    local backup_file="${file}-${current_date}.bak"
    cp "$file" "$backup_file"
    echo "Backup of $file created at $backup_file"
}

# Function to merge two JSON files
# Saves merged file as $1/$file1
function merge_json_files() {
    local file1=$1
    local file2=$2

    # Check if both files exist
    fail_if_file_not_exists "$file1"
    fail_if_file_not_exists "$file2"

    # Create backups of the files
    create_backup_file "${file1}"

    # Merge the two JSON files
    jq -s '.[0] * .[1]' "$file1" "$file2" > "${file1}.tmp" && mv "${file1}.tmp" "$file1"
    
    if [ $? -eq 0 ]; then
        echo "Merged JSON files and saved to $file1"
    else
        echo "Error merging JSON files"
        # Restore the backup if merge fails
        cp "$backup_file" "$file1"
        exit 1
    fi
}

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo "Error: jq is not installed. Please install jq and try again"
    exit 1
fi

# Check if the correct number of arguments is provided
if [ "$#" -ne 1 ]; then
    echo "Error: Invalid number of arguments"
    usage
fi

# Check if the provided path is a valid directory
if [ ! -d "$DIRECTORY_PATH" ]; then
    echo "Error: $DIRECTORY_PATH is not a valid directory"
    exit 1
fi

# Merge general app setings
merge_json_files "$APP_JSON" ./app-adjustments.json

# Create hotkeys file if needed
# Fresh vault doesn't have hotkeys.json created
if [ ! -f "$HOTKEYS_JSON" ]; then
    cp ./hotkeys-adjustments.json "$HOTKEYS_JSON"
else
    # Merge general app setings
    merge_json_files "$HOTKEYS_JSON" ./hotkeys-adjustments.json
fi

# Backup .obsidian.vimrc if exists
if [ -f "$VIM_RC" ]; then
    create_backup_file "$VIM_RC"
fi
# Copy .obsidian.vimrc to the vault
cp ./.obsidian.vimrc "$VIM_RC"
echo "Saved .obsidian.vimrc file in $DIRECTORY_PATH"
