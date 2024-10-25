#!/bin/bash

update_file_with_marker() {
    local file="$1"
    local content="$2"
    local marker="$3"

    # Define the start and end markers
    local start_marker="# BEGIN MANAGED SECTION: $marker"
    local end_marker="# END MANAGED SECTION: $marker"

    # If the file doesn't exist, create it
    if [[ ! -f "$file" ]]; then
        touch "$file"
    fi

    # Escape delimiters for sed
    local esc_start_marker=$(printf '%s\n' "$start_marker" | sed 's/[\/&]/\\&/g')
    local esc_end_marker=$(printf '%s\n' "$end_marker" | sed 's/[\/&]/\\&/g')

    # Check if the markers already exist
    if grep -qF "$start_marker" "$file"; then
        # Update the existing block

        # Delete lines between the markers (excluding the markers)
        sed -i "/$esc_start_marker/,/$esc_end_marker/{//!d;}" "$file"

        # Write the content to a temporary file
        temp_file=$(mktemp)

        printf '%b\n' "$content" > "$temp_file"

        # Insert the new content after the start marker
        sed -i "/$esc_start_marker"/r"$temp_file" "$file"

        # Remove the temporary file
        rm "$temp_file"
    else
        # Prepare the block to insert
        local block="$start_marker"$'\n'"$content"$'\n'"$end_marker"
        # Append the block to the bottom of the file
        echo -e "\n$block" >> "$file"
    fi
}


# Define your content with actual newlines
config_content="apiVersion: v1
kind: ConfigMap
metadata:
  name: my-config"

# Or, using a here-document
config_content=$(cat <<EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: my-config
EOF
)
update_file_with_marker "config.yaml" "$config_content" "my_config_section"


# update_file_with_marker "config.yaml" "apiVersion: v1\nkind: ConfigMap\nmetadata:\n  name: updated-config" "my_config_section" "top"
