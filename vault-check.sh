#!/bin/bash

# Function to check if the token is valid
check_token() {
    vault token lookup > /dev/null 2>&1
    return $?
}

# Function to renew the token
renew_token() {
    vault token renew > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "Token renewed successfully."
    else
        echo "Failed to renew token."
    fi
}

# Main script
check_token
if [ $? -ne 0 ]; then
    echo "Token is expired or invalid. Attempting to renew..."
    renew_token
else
    echo "Token is valid."
fi
