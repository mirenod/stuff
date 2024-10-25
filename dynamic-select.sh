#!/bin/bash

# Read JSON file and parse options
options="$(jq -r '.options[]' options.json)"$'\nQuit'

# Convert options into an array
IFS=$'\n' read -r -d '' -a options_array < <(echo "$options"$'\0')

select opt in "${options_array[@]}"
do
    case $opt in
        "Quit")
            echo "Exiting the script."
            break
            ;;
        *)
            echo "You chose $opt"
            # Place commands or function calls for the chosen option here
            break
            ;;
    esac
done
echo "End $opt"
