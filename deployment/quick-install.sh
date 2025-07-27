#!/bin/bash

# APPIQ Method - Quick Install Script v2.0
# Downloads and installs APPIQ Method with complete IDE integration

set -e

# Configuration
INSTALLER_URL="https://github.com/Viktor-Hermann/APPIQ-METHOD/releases/latest/download/appiq_installer.sh"
TEMP_FILE="/tmp/appiq_installer.sh"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

# Banner
echo -e "${CYAN}"
echo "╔══════════════════════════════════════════════════════════════════╗"
echo "║                🚀 APPIQ METHOD - QUICK INSTALLER                 ║"
echo "║                                                                  ║"
echo "║                One-command mobile development setup              ║"
echo "╚══════════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

echo -e "${BLUE}📥 Downloading APPIQ Method installer...${NC}"

# Download the installer
if command -v curl >/dev/null 2>&1; then
    curl -fsSL "${INSTALLER_URL}" -o "${TEMP_FILE}"
elif command -v wget >/dev/null 2>&1; then
    wget -q "${INSTALLER_URL}" -O "${TEMP_FILE}"
else
    echo -e "${YELLOW}❌ Neither curl nor wget found. Please install one of them.${NC}"
    exit 1
fi

# Check if download was successful
if [ ! -f "${TEMP_FILE}" ]; then
    echo -e "${YELLOW}❌ Failed to download installer${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Download complete${NC}"
echo -e "${BLUE}🚀 Starting installation...${NC}"

# Make executable and run
chmod +x "${TEMP_FILE}"
bash "${TEMP_FILE}"

# Cleanup
rm -f "${TEMP_FILE}"

echo -e "${GREEN}🎉 APPIQ Method installation complete!${NC}"
echo -e "${YELLOW}💡 Use ${GREEN}/appiq${NC} in your IDE to start mobile development${NC}"