#!/bin/bash

# APPIQ-METHOD Quick Installer
# Usage: curl -fsSL https://raw.githubusercontent.com/Viktor-Hermann/APPIQ-METHOD/main/install-appiq.sh | bash

set -e

echo "🚀 APPIQ-METHOD Quick Installer"
echo "=================================="
echo ""

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is required but not installed."
    echo "Please install Node.js v20+ from https://nodejs.org"
    exit 1
fi

# Check Node.js version
NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
if [ "$NODE_VERSION" -lt 20 ]; then
    echo "❌ Node.js v20+ required. Current version: $(node -v)"
    echo "Please update Node.js from https://nodejs.org"
    exit 1
fi

echo "✅ Node.js $(node -v) detected"

# Download and run the smart installer
echo "📥 Downloading APPIQ Smart Installer..."
curl -fsSL https://raw.githubusercontent.com/Viktor-Hermann/APPIQ-METHOD/main/tools/smart-installer.js -o appiq-installer.js

echo "🚀 Running APPIQ Smart Installer..."
node appiq-installer.js

# Cleanup
rm -f appiq-installer.js

echo ""
echo "🎉 Installation complete! You can now use /appiq in your IDE."
echo "📚 For more information, visit: https://github.com/Viktor-Hermann/APPIQ-METHOD"