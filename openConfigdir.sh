
#!/bin/bash

base="$HOME/.config"

# Find all first-level directories and files
mapfile -t dirs < <(find "$base" -mindepth 1 -maxdepth 1 -type d)
mapfile -t files < <(find "$base" -mindepth 1 -maxdepth 1 -type f)

# Extract base folder names
mapfile -t dir_names < <(for d in "${dirs[@]}"; do basename "$d"; done)
mapfile -t file_names < <(for f in "${files[@]}"; do basename "$f"; done)

# Combine directories and files into one list (lowercase)
display_list=("${dir_names[@]}" "${file_names[@]}")
display_list_lowercase=($(printf "%s\n" "${display_list[@]}" | awk '{print tolower($0)}'))

# Show the list to the user via rofi (all lowercase)
selection=$(printf "%s\n" "${display_list_lowercase[@]}" | rofi -dmenu -p "Open Project or Dotfile:")

# Exit if no selection
[ -z "$selection" ] && exit

# Check if the selection is a directory or a file
for i in "${!dir_names[@]}"; do
  if [[ "${dir_names[i],,}" == "$selection" ]]; then
    gnome-terminal --working-directory="${dirs[i]}" &
    exit
  fi
done

for i in "${!file_names[@]}"; do
  if [[ "${file_names[i],,}" == "$selection" ]]; then
    gnome-text-editor "${files[i]}" &
    exit
  fi
done

