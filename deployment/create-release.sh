#!/bin/bash

# APPIQ Method - Create GitHub Release Script
# Automates the complete release process

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
NC='\033[0m'

# Configuration
VERSION="1.0.0"
TAG="v${VERSION}"
REPO="Viktor-Hermann/APPIQ-METHOD"

echo -e "${CYAN}"
echo "╔══════════════════════════════════════════════════════════════════╗"
echo "║                    🚀 APPIQ METHOD RELEASE CREATOR               ║"
echo "║                                                                  ║"
echo "║                     GitHub Release Automation                    ║"
echo "║                          Version ${VERSION}                            ║"
echo "╚══════════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Step 1: Build the release package
echo -e "${BLUE}📦 Step 1: Building release package...${NC}"
bash build-release.sh

# Step 2: Commit and push changes
echo -e "${BLUE}📝 Step 2: Preparing git commit...${NC}"
cd ..

echo -e "${YELLOW}Current git status:${NC}"
git status --short

echo -e "${YELLOW}Do you want to commit and push these changes? (y/n):${NC}"
read -r commit_confirm

if [ "$commit_confirm" = "y" ] || [ "$commit_confirm" = "Y" ]; then
    echo -e "${BLUE}Committing changes...${NC}"
    git add .
    git commit -m "feat: Complete APPIQ Method mobile development system v${VERSION}

- Add mobile expansion pack with Flutter/React Native support
- Implement /appiq interactive slash command system  
- Create deployment system with single-file installer
- Add IDE integration for Claude, Cursor, Windsurf
- Include comprehensive mobile development workflows
- Create automated release build system

🚀 Ready for deployment!"

    echo -e "${BLUE}Pushing to GitHub...${NC}"
    git push origin main
else
    echo -e "${YELLOW}Skipping git commit...${NC}"
fi

# Step 3: Create and push tag
echo -e "${BLUE}🏷️ Step 3: Creating git tag...${NC}"
echo -e "${YELLOW}Creating tag ${TAG}...${NC}"

# Delete tag if it exists
git tag -d "${TAG}" 2>/dev/null || true
git push origin ":refs/tags/${TAG}" 2>/dev/null || true

# Create new tag
git tag -a "${TAG}" -m "APPIQ Method v${VERSION} - Mobile Development Release

🚀 What's New:
- Complete mobile development workflow system
- Interactive /appiq command for all IDEs
- Single-file installer for easy deployment
- Flutter and React Native support
- 7 specialized mobile agents
- 4 complete mobile workflows
- Comprehensive mobile development checklist

📦 Installation:
curl -fsSL https://raw.githubusercontent.com/${REPO}/main/deployment/quick-install.sh | bash

💡 Usage:
Use /appiq command in your IDE to start mobile development"

echo -e "${BLUE}Pushing tag to GitHub...${NC}"
git push origin "${TAG}"

# Step 4: Check GitHub CLI
echo -e "${BLUE}🔧 Step 4: Checking for GitHub CLI...${NC}"
if command -v gh >/dev/null 2>&1; then
    echo -e "${GREEN}✅ GitHub CLI found${NC}"
    
    echo -e "${YELLOW}Do you want to create the release automatically with GitHub CLI? (y/n):${NC}"
    read -r cli_confirm
    
    if [ "$cli_confirm" = "y" ] || [ "$cli_confirm" = "Y" ]; then
        echo -e "${BLUE}Creating GitHub release...${NC}"
        
        cd deployment
        gh release create "${TAG}" \
          dist/appiq_installer.sh \
          dist/quick-install.sh \
          dist/README.md \
          dist/INSTALL_EXAMPLES.md \
          dist/RELEASE_NOTES.md \
          dist/VERSION \
          dist/CHECKSUMS.sha256 \
          --title "APPIQ Method v${VERSION} - Mobile Development System" \
          --notes-file dist/RELEASE_NOTES.md \
          --latest \
          --repo "${REPO}"
        
        echo -e "${GREEN}✅ GitHub release created successfully!${NC}"
        cd ..
    else
        echo -e "${YELLOW}Manual release creation needed${NC}"
    fi
else
    echo -e "${YELLOW}⚠️ GitHub CLI not found - manual release creation needed${NC}"
fi

# Step 5: Show manual instructions
echo -e "${PURPLE}📋 Manual Release Instructions:${NC}"
echo ""
echo -e "${YELLOW}If GitHub CLI didn't work, create the release manually:${NC}"
echo ""
echo "1. Go to: https://github.com/${REPO}/releases"
echo "2. Click 'Create a new release'"
echo "3. Select tag: ${TAG}"
echo "4. Title: APPIQ Method v${VERSION} - Mobile Development System"
echo "5. Upload these files from deployment/dist/:"
echo "   - appiq_installer.sh (MAIN FILE)"
echo "   - quick-install.sh"
echo "   - README.md"
echo "   - INSTALL_EXAMPLES.md"
echo "   - RELEASE_NOTES.md"
echo "   - VERSION"
echo "   - CHECKSUMS.sha256"
echo "6. Copy description from: deployment/dist/RELEASE_NOTES.md"
echo "7. Check 'Set as latest release'"
echo "8. Click 'Publish release'"

# Step 6: Verify URLs
echo -e "${BLUE}🔍 Step 6: URL verification...${NC}"
echo ""
echo -e "${YELLOW}After release creation, these URLs should work:${NC}"
echo ""
echo -e "${GREEN}Main installer:${NC}"
echo "https://github.com/${REPO}/releases/latest/download/appiq_installer.sh"
echo ""
echo -e "${GREEN}Quick installer:${NC}"
echo "https://github.com/${REPO}/releases/latest/download/quick-install.sh"
echo ""
echo -e "${GREEN}Raw quick install (for curl):${NC}"
echo "https://raw.githubusercontent.com/${REPO}/main/deployment/quick-install.sh"

# Step 7: Test commands
echo -e "${BLUE}🧪 Step 7: Test commands...${NC}"
echo ""
echo -e "${YELLOW}Test these commands after release:${NC}"
echo ""
echo -e "${CYAN}# One-command install:${NC}"
echo "curl -fsSL https://raw.githubusercontent.com/${REPO}/main/deployment/quick-install.sh | bash"
echo ""
echo -e "${CYAN}# Direct download:${NC}"
echo "wget https://github.com/${REPO}/releases/latest/download/appiq_installer.sh"
echo "bash appiq_installer.sh"
echo ""
echo -e "${CYAN}# After installation:${NC}"
echo "./.appiq/scripts/appiq validate"
echo ""
echo -e "${CYAN}# In IDE:${NC}"
echo "/appiq"

# Success message
echo -e "${GREEN}"
echo "╔══════════════════════════════════════════════════════════════════╗"
echo "║                     ✅ RELEASE PREPARATION COMPLETE!             ║"
echo "╚══════════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

echo -e "${CYAN}🎉 APPIQ Method v${VERSION} is ready for release!${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "1. Complete the GitHub release (manually if CLI didn't work)"
echo "2. Test the installation URLs"
echo "3. Share with users:"
echo -e "   ${GREEN}curl -fsSL https://raw.githubusercontent.com/${REPO}/main/deployment/quick-install.sh | bash${NC}"
echo "4. Users can then use ${GREEN}/appiq${NC} in their IDE"
echo ""
echo -e "${PURPLE}📖 Full instructions: deployment/GITHUB_RELEASE_GUIDE.md${NC}"