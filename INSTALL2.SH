#!/bin/bash

set -e

# Function to get the latest release version from GitLab API
get_latest_release() {
    GITLAB_DOMAIN="gitlab.com"
    PROJECT_NAMESPACE="yourusername/yourrepo"  # Replace with your username and repository name

    # URL encode the project path
    PROJECT_PATH=$(echo -n "$PROJECT_NAMESPACE" | jq -sRr @uri)

    # Construct the API URL
    API_URL="https://$GITLAB_DOMAIN/api/v4/projects/$PROJECT_PATH/releases"

    # Fetch the latest release tag name
    LATEST_VERSION=$(curl -s "$API_URL" | jq -r '.[0].tag_name')

    # Check if LATEST_VERSION is empty or null
    if [ -z "$LATEST_VERSION" ] || [ "$LATEST_VERSION" = "null" ]; then
        echo "Error: Could not retrieve the latest release version."
        exit 1
    fi

    echo "$LATEST_VERSION"
}

# Function to download tool.sh from the latest release
download_tool() {
    VERSION="$1"
    GITLAB_DOMAIN="gitlab.com"
    PROJECT_NAMESPACE="yourusername/yourrepo"  # Replace with your username and repository name

    # Construct the download URL for tool.sh in the release tag
    DOWNLOAD_URL="https://$GITLAB_DOMAIN/$PROJECT_NAMESPACE/-/raw/$VERSION/tool.sh"

    echo "Downloading tool.sh version $VERSION..."
    curl -sSL -o tool.sh "$DOWNLOAD_URL"

    # Make tool.sh executable
    chmod +x tool.sh
}

# Main script execution
main() {
    # Get the latest release version
    LATEST_VERSION=$(get_latest_release)

    echo "Latest version is $LATEST_VERSION"

    # Download tool.sh corresponding to the latest version
    download_tool "$LATEST_VERSION"

    # Write the version to .tool-version
    echo "$LATEST_VERSION" > .tool-version

    echo "tool.sh version $LATEST_VERSION has been installed."

    # Optionally delete INSTALL.sh after execution
    # Uncomment the following line to enable self-deletion
    # rm -- "$0"
}

# Call the main function
main
