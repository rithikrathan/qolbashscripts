#!/bin/bash

# Function to create .desktop file
create_desktop_file() {
    # Check if executable path is provided
    if [ -z "$1" ]; then
        echo "Error: You must provide the path to the executable."
        exit 1
    fi

    exec_path="$1"

    # Check if the executable exists
    if [ ! -x "$exec_path" ]; then
        echo "Error: '$exec_path' is not executable or doesn't exist."
        exit 1
    fi

    # Ask for metadata
    read -p "App Name: " name
    read -p "Comment (optional): " comment
    read -p "Icon Path (optional): " icon
    read -p "Categories (e.g., Utility;Development;) (optional): " categories
    read -p "Does it need a terminal? [y/N]: " needs_terminal

    # Default values for optional fields
    terminal_flag="false"
    [[ "$needs_terminal" =~ ^[Yy]$ ]] && terminal_flag="true"

    # Sanitize name for desktop file name (lowercase, replace spaces with dashes)
    desktop_name=$(echo "${name:-App}" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -cd '[:alnum:]-')

    # Define the location of the .desktop file
    desktop_file="$HOME/.local/share/applications/${desktop_name}.desktop"

    # Build the .desktop file
    {
        echo "[Desktop Entry]"
        echo "Type=Application"
        [[ -n "$name" ]]       && echo "Name=$name"
        [[ -n "$comment" ]]    && echo "Comment=$comment"
        echo "Exec=$exec_path"
        [[ -n "$icon" ]]       && echo "Icon=$icon"
        echo "Terminal=$terminal_flag"
        [[ -n "$categories" ]] && echo "Categories=$categories"
    } > "$desktop_file"

    # Make the desktop file executable
    chmod +x "$desktop_file"

    echo "Created: $desktop_file"
}

# Run the function with the executable path passed as the first argument
create_desktop_file "$1"

