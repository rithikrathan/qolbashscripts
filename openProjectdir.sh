#!/bin/bash

base="$HOME/Desktop/projects"

# Find all first-level directories
mapfile -t dirs < <(find "$base" -mindepth 1 -maxdepth 1 -type d)

# Extract base folder names
mapfile -t names < <(for d in "${dirs[@]}"; do basename "$d"; done)

# Show lowercase list to user
selection=$(printf "%s\n" "${names[@]}" | awk '{print tolower($0)}' | rofi -dmenu -p "Open Project:")

# Exit if no selection
[ -z "$selection" ] && exit

# Case-insensitive match to original name
for i in "${!names[@]}"; do
  if [[ "${names[i],,}" == "$selection" ]]; then
    alacritty --working-directory="${dirs[i]}" # uncomment this and comment the line below if you dont want to open the directory in nvim by default 
	# alacritty -- /home/godz/.local/nvim-linux-x86_64/bin/nvim "${dirs[i]}" &
    break
  fi
done
