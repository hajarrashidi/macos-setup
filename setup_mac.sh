#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Function to print messages
print_message() {
    echo "===================================="
    echo "$1"
    echo "===================================="
}

# Function to install a cask if not already installed or present
install_cask() {
    local cask_name="$1"
    local app_name="$2"  # Human-readable app name for path checking

    # Check if the cask is installed via Homebrew
    if brew list --cask "$cask_name" &>/dev/null; then
        echo "✅ '$cask_name' is already installed via Homebrew. Skipping."
    else
        # Define the expected application path
        local app_path="/Applications/${app_name}.app"

        # Check if the application exists in /Applications
        if [[ -d "$app_path" ]]; then
            echo "✅ '$app_name' is already installed in /Applications. Skipping Homebrew installation."
        else
            echo "🔨 Installing '$cask_name' via Homebrew..."
            brew install --cask "$cask_name"
            echo "✅ '$cask_name' installed successfully."
        fi
    fi
}

# 1. Install Homebrew if not installed
if ! command -v brew &>/dev/null; then
    print_message "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH
    eval "$(/opt/homebrew/bin/brew shellenv)" 2>/dev/null || eval "$(/usr/local/bin/brew shellenv)" 2>/dev/null
else
    echo "✅ Homebrew is already installed. Skipping installation."
    # Update Homebrew
    print_message "Updating Homebrew..."
    brew update
fi

# 2. Install Applications via Homebrew Cask
APPS=(
    "warp:Warp"
    "termius:Termius"
    "raycast:Raycast"
    "notion:Notion"
)

print_message "Installing Applications..."
for app in "${APPS[@]}"; do
    # Split the cask name and the app name using IFS and read
    IFS=":" read -r cask app_name <<< "$app"
    install_cask "$cask" "$app_name"
done

# 3. Install BunJS
print_message "Installing BunJS..."
if command -v bun &>/dev/null; then
    echo "✅ BunJS is already installed. Skipping."
else
    echo "🔨 Installing BunJS..."
    curl -fsSL https://bun.sh/install | bash

    # Add Bun to ~/.zshrc if not already present
    if ! grep -Fxq 'export BUN_INSTALL="$HOME/.bun"' ~/.zshrc; then
        echo 'export BUN_INSTALL="$HOME/.bun"' >> ~/.zshrc
    fi
    if ! grep -Fxq 'export PATH="$BUN_INSTALL/bin:$PATH"' ~/.zshrc; then
        echo 'export PATH="$BUN_INSTALL/bin:$PATH"' >> ~/.zshrc
    fi
    echo "✅ BunJS installation and configuration completed."
fi

# 4. Source the updated ~/.zshrc to apply changes
print_message "Applying Shell Configuration..."
source ~/.zshrc

# 5. Clean up Homebrew
print_message "Cleaning up Homebrew..."
brew cleanup

print_message "Setup Completed Successfully!"
