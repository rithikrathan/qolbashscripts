#!/bin/bash

# Get dotfiles from $HOME
mapfile -t files < <(find "$HOME" -mindepth 1 -maxdepth 1 -type f -name ".*")

# Get dot-directories from $HOME
mapfile -t dotdirs < <(find "$HOME" -mindepth 1 -maxdepth 1 -type d -name ".*")

# Get all directories from ~/.config
mapfile -t configdirs < <(find "$HOME/.config" -mindepth 1 -maxdepth 1 -type d)

# Merge directory lists
dirs=("${dotdirs[@]}" "${configdirs[@]}")

# Extract base names
mapfile -t file_names < <(for f in "${files[@]}"; do basename "$f"; done)
mapfile -t dir_names < <(for d in "${dirs[@]}"; do basename "$d"; done)

# Combine and lowercase
display_list=("${file_names[@]}" "${dir_names[@]}")
display_list_lower=($(printf "%s\n" "${display_list[@]}" | awk '{print tolower($0)}'))

# Show in rofi
selection=$(printf "%s\n" "${display_list_lower[@]}" | rofi -dmenu -p "Open Config:")

# Exit if nothing selected
[ -z "$selection" ] && exit

# Match directory
for i in "${!dir_names[@]}"; do
  if [[ "${dir_names[i],,}" == "$selection" ]]; then
    gnome-terminal --working-directory="${dirs[i]}" &
    exit
  fi
done

# Match file
for i in "${!file_names[@]}"; do
  if [[ "${file_names[i],,}" == "$selection" ]]; then
    gnome-text-editor "${files[i]}" &
    exit
  fi
done
