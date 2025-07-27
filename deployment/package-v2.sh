#!/bin/bash

# APPIQ Method - Deployment Package Creator v2.0
# Creates a single-file installer with all necessary components and IDE integrations

set -e

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "${SCRIPT_DIR}")"
OUTPUT_DIR="${SCRIPT_DIR}/dist"
PACKAGE_NAME="appiq_installer.sh"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}📦 Creating APPIQ Method v2.0 Deployment Package...${NC}"

# Create output directory
mkdir -p "${OUTPUT_DIR}"

# Copy the v2.0 installer as base
echo -e "${YELLOW}📋 Copying v2.0 installer base...${NC}"
cp "${SCRIPT_DIR}/init_appiq_v2.sh" "${OUTPUT_DIR}/${PACKAGE_NAME}"

# Create temporary directory for files to embed
echo -e "${YELLOW}📦 Building embedded archive...${NC}"
TEMP_DIR=$(mktemp -d)

# Copy essential mobile development files
mkdir -p "${TEMP_DIR}/agents"
mkdir -p "${TEMP_DIR}/workflows"
mkdir -p "${TEMP_DIR}/templates"
mkdir -p "${TEMP_DIR}/checklists"
mkdir -p "${TEMP_DIR}/agent-teams"
mkdir -p "${TEMP_DIR}/installers"

# Copy all mobile agents
cp "${PROJECT_ROOT}/expansion-packs/bmad-mobile-app-dev/agents/"*.md "${TEMP_DIR}/agents/"

# Copy mobile workflows
cp "${PROJECT_ROOT}/expansion-packs/bmad-mobile-app-dev/workflows/"*.yaml "${TEMP_DIR}/workflows/"

# Copy mobile templates
cp "${PROJECT_ROOT}/expansion-packs/bmad-mobile-app-dev/templates/"*.yaml "${TEMP_DIR}/templates/"

# Copy mobile checklists
cp "${PROJECT_ROOT}/expansion-packs/bmad-mobile-app-dev/checklists/"*.md "${TEMP_DIR}/checklists/"

# Copy mobile team configurations
cp "${PROJECT_ROOT}/expansion-packs/bmad-mobile-app-dev/agent-teams/"*.yaml "${TEMP_DIR}/agent-teams/"

# Copy IDE integration installers
cp "${PROJECT_ROOT}/deployment/installers/"*.sh "${TEMP_DIR}/installers/"

# Copy slash command documentation
mkdir -p "${TEMP_DIR}/slash-commands"
cp "${PROJECT_ROOT}/slash-commands/appiq.md" "${TEMP_DIR}/slash-commands/"

# Create the embedded archive and append to installer
echo -e "${YELLOW}📦 Creating embedded archive...${NC}"
cd "${TEMP_DIR}"
tar czf - * >> "${OUTPUT_DIR}/${PACKAGE_NAME}"
cd - > /dev/null

# Cleanup
rm -rf "${TEMP_DIR}"

# Make the package executable
chmod +x "${OUTPUT_DIR}/${PACKAGE_NAME}"

# Show package info
PACKAGE_SIZE=$(du -h "${OUTPUT_DIR}/${PACKAGE_NAME}" | cut -f1)

echo -e "${GREEN}✅ Package created successfully!${NC}"
echo -e "${BLUE}📍 Location: ${OUTPUT_DIR}/${PACKAGE_NAME}${NC}"
echo -e "${BLUE}📏 Size: ${PACKAGE_SIZE}${NC}"
echo ""
echo -e "${YELLOW}📋 Package Contents:${NC}"
echo "• Complete APPIQ Method mobile development system"
echo "• IDE integrations for Claude, Cursor, Windsurf"
echo "• Terminal integration with global command"
echo "• 7 mobile development agents"
echo "• 4 mobile development workflows (Flutter/React Native)"
echo "• Mobile development checklist and templates"
echo "• Team configurations and agent orchestration"
echo ""
echo -e "${YELLOW}🚀 Usage Instructions:${NC}"
echo "1. Copy ${PACKAGE_NAME} to any project folder"
echo "2. Run: ${GREEN}bash ${PACKAGE_NAME}${NC}"
echo "3. Follow the installation prompts"
echo "4. Use ${GREEN}/appiq${NC} in your IDE or ${GREEN}appiq${NC} in terminal"
echo ""
echo -e "${CYAN}🎉 Ready for deployment! Users get complete IDE integration automatically.${NC}"