#!/bin/bash

set -e

# Function to get the latest release version from GitLab API
get_latest_release() {
    GITLAB_DOMAIN="gitlab.com"
    PROJECT_NAMESPACE="yourusername/yourrepo"
    PRIVATE_TOKEN=""

    PROJECT_PATH=$(echo -n "$PROJECT_NAMESPACE" | od -An -tx1 | tr ' ' % | tr -d '\n')
    API_URL="https://$GITLAB_DOMAIN/api/v4/projects/$PROJECT_PATH/releases"

    if [ -z "$PRIVATE_TOKEN" ]; then
        LATEST_VERSION=$(curl -s "$API_URL" | grep -oP '"tag_name":"\K(.*?)(?=")')
    else
        LATEST_VERSION=$(curl --header "PRIVATE-TOKEN: $PRIVATE_TOKEN" -s "$API_URL" | grep -oP '"tag_name":"\K(.*?)(?=")')
    fi

    if [ -z "$LATEST_VERSION" ]; then
        echo "Error: Could not retrieve the latest release version."
        exit 1
    fi

    echo "$LATEST_VERSION"
}

download_tool() {
    VERSION="$1"
    DOWNLOAD_URL="https://$GITLAB_DOMAIN/$PROJECT_NAMESPACE/-/raw/$VERSION/tool.sh"

    echo "Downloading tool.sh version $VERSION..."
    curl -sSL -o tool.sh "$DOWNLOAD_URL"

    chmod +x tool.sh
}

main() {
    LATEST_VERSION=$(get_latest_release)

    echo "Latest version is $LATEST_VERSION"

    download_tool "$LATEST_VERSION"

    echo "$LATEST_VERSION" > .tool-version

    echo "tool.sh version $LATEST_VERSION has been installed."

    # Self-delete the script
    rm -- "$0"
}

##curl -sSL -o INSTALL.sh "https://gitlab.com/yourusername/yourrepo/-/raw/master/INSTALL.sh" && \
chmod +x INSTALL.sh && \
./INSTALL.sh
