#!/bin/bash
set -eu
exec 3>&2

# This function will dynamically generate a select menu based on the options provided.
# The options are passed like this:
# select_menu_dynamic "$(jq -r '.options[]' options.json)"
select_menu_dynamic() {
  set +eu
  local options="$1"$'\nQuit'
  local IFS
  local options_array
  local opt
  
  # Convert options into an array
  IFS=$'\n' read -r -d '' -a options_array < <(echo "$options"$'\0')
  
  while true; do
    select opt in "${options_array[@]}"; do
      if [[ -n "$opt" ]]; then
        case $opt in
          "Quit")
            echo "Exiting the script." >&3
            exit 0
            ;;
          *)
            echo "You chose $opt" >&3
            # Place commands or function calls for the chosen option here
            echo "$opt"
            return
            ;;
        esac
      else
        echo "Invalid option. Please try again." >&3
      fi
    done
  done
  
  set -eu
}

result=$(select_menu_dynamic "$(jq -r '.options[]' options.json)")
echo "End $result"
