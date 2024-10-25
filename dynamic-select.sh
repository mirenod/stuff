#!/bin/bash
set -eu
exec 3>&2

# Read JSON file and parse options
select_menu_dynamic() {
set +eu
local options="$1"$'\nQuit'
local IFS
local options_array
local opt

# Convert options into an array
IFS=$'\n' read -r -d '' -a options_array < <(echo "$options"$'\0')

select opt in "${options_array[@]}"
do
    case $opt in
        "Quit")
            echo "Exiting the script." >&3
            exit 0
            ;;
        *)
            echo "You chose $opt" >&3
            # Place commands or function calls for the chosen option here
            break
            ;;
    esac
done

set -eu
echo "$opt"
}

result=$(menu "$(jq -r '.options[]' options.json)")
result=$(select_menu_dynamic $'Something\nSomething\nSomething')
echo "End $result"
