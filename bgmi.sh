#!/bin/bash

# Create .devcontainer directory
mkdir -p .devcontainer

# Get the repository name from the current directory
OPP=$(basename "$(git rev-parse --show-toplevel)")

# Get the first Python file in the repository (assuming .py files are in the root)
PYTHON_FILE=$(find . -maxdepth 1 -name "*.py" | head -n 1)

# Check if a Python file was found
if [ -z "$PYTHON_FILE" ]; then
    echo "No Python files found in the repository."
    exit 1
fi

# Create the devcontainer.json file with dynamic values
cat <<EOL > .devcontainer/devcontainer.json
{
    "name": "$OPP Codespace",
    "image": "mcr.microsoft.com/vscode/devcontainers/python:3.8",
    "postStartCommand": "echo '*'; echo '*         @Spike_Magic Bot Running      *'; echo '*'; python /workspaces/$OPP/$(basename "$PYTHON_FILE")",
    "postCreateCommand": "pip install pymongo python-telegram-bot pyTelegramBotAPI certifi && chmod +x /workspaces/$OPP/*",
    "customizations": {
        "vscode": {
            "settings": {
                "python.pythonPath": "/usr/local/bin/python"
            },
            "extensions": [
                "ms-python.python"
            ]
        }
    }
}
EOL

# Stage, commit, and push the changes
git add .devcontainer/devcontainer.json
git commit -m "Add devcontainer configuration for $OPP with automatic script detection and watermark"
git push origin main
