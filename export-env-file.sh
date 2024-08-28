# Function to read the .env file and export the variables
load_env() {
    # Check if the .env file exists
    if [ -f .env ]; then
        # Read the .env file line by line
        while IFS= read -r line; do
            # Ignore comments and empty lines
            if [[ ! $line =~ ^# ]] && [[ -n $line ]]; then
                # Export the variable
                export "$line"
            fi
        done < .env
    else
        echo ".env file not found."
        return 1
    fi
}
