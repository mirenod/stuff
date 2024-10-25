#!/bin/bash

#!/bin/bash

# # Get the latest release from GitLab
# PROJECT_ID="your_project_id"
# PRIVATE_TOKEN="your_private_access_token"
# # API endpoint to get the latest release
# API_URL="https://gitlab.com/api/v4/projects/$PROJECT_ID/releases"
# # Make the API call and parse the response
# LATEST_VERSION=$(curl --header "PRIVATE-TOKEN: $PRIVATE_TOKEN" "$API_URL" | jq -r '.[0].tag_name')

# latest_tooling_release="v1.1.1"
# current_date=$(date +"%Y-%m-%d")
# # Check if a files call tool-cache.json do not exist in the current directory if do not exist create it
# if [ ! -f "tool-cache.json" ]; then
#     echo "{\"version\": \"$latest_tooling_release\"}" >tool-cache.json
# fi

# echo "{\"version\": \"$latest_tooling_release\", \"version_check_date\": \"$current_date\"}" | jq "." >tool-cache.json

# # get the current date in a format that can be compared with the date in the cache file

# # PS3='Please enter your choice: '

# options=("Option 1" "Option 2" "Option 3" "Quit")

# select opt in "${options[@]}"
# do
#     case $opt in
#         "${options[0]}")
#             echo "You chose Option 1"
#             # Place commands or function calls for Option 1 here
#             ;;
#         "${options[1]}")
#             echo "You chose Option 2"
#             # Place commands or function calls for Option 2 here
#             ;;
#         "${options[2]}")
#             echo "You chose Option 3"
#             # Place commands or function calls for Option 3 here
#             ;;
#         "Quit")
#             echo "Exiting the script."
#             break
#             ;;
#         *)
#             echo "Invalid option. Please try again."
#             ;;
#     esac
# done


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
