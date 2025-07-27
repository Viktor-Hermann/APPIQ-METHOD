#!/bin/bash

# APPIQ Method - Release Builder
# Creates a complete deployment package ready for distribution

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "${SCRIPT_DIR}")"
BUILD_DIR="${SCRIPT_DIR}/build"
DIST_DIR="${SCRIPT_DIR}/dist"
VERSION="1.0.0"

# Banner
echo -e "${CYAN}"
echo "╔══════════════════════════════════════════════════════════════════╗"
echo "║                    📦 APPIQ METHOD RELEASE BUILDER               ║"
echo "║                                                                  ║"
echo "║                     Creating Distribution Package                ║"
echo "║                          Version ${VERSION}                            ║"
echo "╚══════════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Clean and create directories
echo -e "${BLUE}🧹 Cleaning build directories...${NC}"
rm -rf "${BUILD_DIR}" "${DIST_DIR}"
mkdir -p "${BUILD_DIR}" "${DIST_DIR}"

# Copy source files
echo -e "${BLUE}📋 Copying source files...${NC}"
cp -r "${PROJECT_ROOT}/expansion-packs" "${BUILD_DIR}/"
cp -r "${PROJECT_ROOT}/bmad-core" "${BUILD_DIR}/"
cp -r "${PROJECT_ROOT}/slash-commands" "${BUILD_DIR}/"

# Validate mobile expansion pack
echo -e "${BLUE}🔍 Validating mobile expansion pack...${NC}"
MOBILE_PACK="${BUILD_DIR}/expansion-packs/bmad-mobile-app-dev"

required_dirs=(
    "agents"
    "workflows" 
    "templates"
    "checklists"
    "teams"
)

missing_dirs=0
for dir in "${required_dirs[@]}"; do
    if [ ! -d "${MOBILE_PACK}/${dir}" ]; then
        echo -e "${RED}❌ Missing directory: ${dir}${NC}"
        ((missing_dirs++))
    else
        echo -e "${GREEN}✅ Found: ${dir}${NC}"
    fi
done

if [ $missing_dirs -gt 0 ]; then
    echo -e "${RED}❌ Validation failed: ${missing_dirs} missing directories${NC}"
    exit 1
fi

# Count files in each category
echo -e "${BLUE}📊 Package contents:${NC}"
echo "• Agents: $(find "${MOBILE_PACK}/agents" -name "*.md" | wc -l)"
echo "• Workflows: $(find "${MOBILE_PACK}/workflows" -name "*.yaml" | wc -l)" 
echo "• Templates: $(find "${MOBILE_PACK}/templates" -name "*.yaml" | wc -l)"
echo "• Teams: $(find "${MOBILE_PACK}/teams" -name "*.yaml" | wc -l)"

# Create the installer package
echo -e "${BLUE}📦 Building installer package...${NC}"
bash "${SCRIPT_DIR}/package.sh"

# Copy additional release files
echo -e "${BLUE}📄 Copying release files...${NC}"
cp "${SCRIPT_DIR}/init_appiq.sh" "${DIST_DIR}/"
cp "${SCRIPT_DIR}/quick-install.sh" "${DIST_DIR}/"
cp "${SCRIPT_DIR}/README.md" "${DIST_DIR}/"

# Create version info
echo -e "${BLUE}📝 Creating version info...${NC}"
cat > "${DIST_DIR}/VERSION" << EOF
APPIQ Method Mobile Development
Version: ${VERSION}
Build Date: $(date -u +"%Y-%m-%d %H:%M:%S UTC")
Git Commit: $(git rev-parse --short HEAD 2>/dev/null || echo "unknown")

Components:
- Mobile Expansion Pack: bmad-mobile-app-dev
- Core System: bmad-core  
- Slash Commands: /appiq interactive launcher
- IDE Integration: Claude, Cursor, Windsurf, Universal

Package Contents:
- appiq_installer.sh: Single-file installer with embedded files
- init_appiq.sh: Development version installer
- quick-install.sh: One-command download and install
- README.md: Complete documentation and usage guide
EOF

# Create checksums
echo -e "${BLUE}🔐 Creating checksums...${NC}"
cd "${DIST_DIR}"
for file in *.sh; do
    if [ -f "$file" ]; then
        sha256sum "$file" >> CHECKSUMS.sha256
    fi
done
cd - > /dev/null

# Create installation examples
echo -e "${BLUE}📚 Creating installation examples...${NC}"
cat > "${DIST_DIR}/INSTALL_EXAMPLES.md" << 'EOF'
# APPIQ Method - Installation Examples

## Quick Start (Recommended)

### One-Command Install
```bash
curl -fsSL https://raw.githubusercontent.com/Viktor-Hermann/APPIQ-METHOD/main/deployment/quick-install.sh | bash
```

## Alternative Methods

### Download and Run
```bash
# Download
wget https://github.com/Viktor-Hermann/APPIQ-METHOD/releases/latest/download/appiq_installer.sh

# Install in your project
cd my-mobile-project
bash appiq_installer.sh
```

### Manual Copy
1. Download `appiq_installer.sh` 
2. Copy to project folder
3. Run: `bash appiq_installer.sh`

## Post-Installation

### 1. Customize PRD
```bash
nano docs/main_prd.md
```

### 2. Start Development
Open your IDE and use:
```
/appiq
```

### 3. Validate Setup
```bash
./.appiq/scripts/appiq validate
```

## IDE Usage

### Claude Code
```
/appiq
```

### Cursor  
```
/appiq
# or Ctrl+Alt+A
```

### Windsurf
```
/appiq
```

## Project Types Supported

- ✅ Flutter mobile apps
- ✅ React Native mobile apps  
- ✅ New app development (Greenfield)
- ✅ Existing app enhancement (Brownfield)

## What You Get

- Complete mobile development workflow
- Interactive project setup
- Platform-specific guidance
- Automated document generation
- Agent-based development process
- Quality assurance integration
- IDE integration for Claude, Cursor, Windsurf

## Support

- Validate: `./.appiq/scripts/appiq validate`
- Status: `./.appiq/scripts/appiq status`
- Update: `./.appiq/scripts/appiq update`
EOF

# Create release notes
echo -e "${BLUE}📋 Creating release notes...${NC}"
cat > "${DIST_DIR}/RELEASE_NOTES.md" << EOF
# APPIQ Method v${VERSION} - Release Notes

## 🚀 What's New

### Mobile Development Expansion Pack
- **Complete Flutter Support**: End-to-end Flutter development workflows
- **React Native Integration**: Full React Native development lifecycle
- **Platform Detection**: Automatic Flutter/React Native project detection
- **Mobile-Specific Agents**: Specialized agents for mobile development

### Interactive Slash Commands
- **\`/appiq\` Command**: Interactive mobile development launcher
- **IDE Integration**: Native support for Claude, Cursor, Windsurf
- **Smart Workflows**: Automatic workflow selection based on project type
- **Project Analysis**: Intelligent platform and requirement detection

### Installation System
- **One-Command Install**: \`curl | bash\` installation
- **Self-Contained Installer**: Single file with embedded components
- **Auto-Configuration**: Automatic IDE and project setup
- **Validation Tools**: Built-in validation and status checking

## 📦 Package Contents

### Core Files
- \`appiq_installer.sh\` - Single-file installer ($(du -h "${DIST_DIR}/appiq_installer.sh" | cut -f1) 2>/dev/null || echo "~1MB"))
- \`init_appiq.sh\` - Development installer
- \`quick-install.sh\` - One-command downloader

### Documentation
- \`README.md\` - Complete setup and usage guide
- \`INSTALL_EXAMPLES.md\` - Installation examples
- \`VERSION\` - Version and build information
- \`CHECKSUMS.sha256\` - File integrity checksums

## 🎯 Key Features

### Mobile Development Workflows
1. **Greenfield Flutter**: New Flutter app development
2. **Greenfield React Native**: New React Native app development  
3. **Brownfield Flutter**: Flutter app enhancement
4. **Brownfield React Native**: React Native app enhancement

### Agent Ecosystem
- **mobile-pm**: Mobile project management and PRD creation
- **mobile-architect**: Mobile architecture and platform decisions
- **mobile-developer**: Mobile development implementation
- **mobile-qa**: Mobile testing and quality assurance
- **mobile-security**: Mobile security and compliance
- **mobile-analytics**: Mobile analytics and monitoring
- **mobile-ux-expert**: Mobile UX and design systems

### IDE Integration
- **Claude Code**: Native slash command support
- **Cursor**: Chat commands + Command Palette + Keyboard shortcuts
- **Windsurf**: AI-powered analysis and workflow suggestions
- **Universal**: Works with any chat-based IDE

## 🔧 Technical Details

### Installation Size
- Installer: ~1MB (includes all necessary files)
- Installed: ~5MB (complete mobile development system)

### System Requirements
- Unix-like system (Linux, macOS, WSL)
- Git (optional, for enhanced features)
- Mobile development environment (Flutter SDK or React Native)

### File Structure Created
\`\`\`
project/
├── .appiq/           # APPIQ Method installation
├── docs/            # Project documentation
│   └── main_prd.md  # Product Requirements Document
└── README.md        # Updated with APPIQ section
\`\`\`

## 🚨 Breaking Changes
None - This is the initial release of the mobile development system.

## 🐛 Bug Fixes
N/A - Initial release

## 📈 Improvements
- First release of complete mobile development workflow system
- Integrated mobile-specific agents and templates
- Cross-platform development support
- Interactive workflow launcher

## 🛠️ Migration Guide
N/A - New installation

## 📚 Documentation
- [Installation Guide](./README.md)
- [Usage Examples](./INSTALL_EXAMPLES.md) 
- [Version Info](./VERSION)

## 🤝 Contributing
Submit issues and feature requests at: https://github.com/Viktor-Hermann/APPIQ-METHOD/issues

## 📄 License
Licensed under [Your License]

## 🎉 What's Next

### Planned for v1.1.0
- Native iOS/Android workflow support
- Advanced testing frameworks integration
- CI/CD pipeline templates
- Performance monitoring templates
- Multi-platform deployment automation

---

**Installation**: \`curl -fsSL https://raw.githubusercontent.com/Viktor-Hermann/APPIQ-METHOD/main/deployment/quick-install.sh | bash\`

**Usage**: Open your IDE and use \`/appiq\` to start mobile development
EOF

# Create deployment manifest
echo -e "${BLUE}📋 Creating deployment manifest...${NC}"
cat > "${DIST_DIR}/MANIFEST.json" << EOF
{
  "name": "APPIQ Method Mobile Development",
  "version": "${VERSION}",
  "build_date": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "git_commit": "$(git rev-parse --short HEAD 2>/dev/null || echo "unknown")",
  "files": {
    "installer": {
      "filename": "appiq_installer.sh",
      "description": "Single-file installer with embedded components",
      "size": "$(stat -f%z "${DIST_DIR}/appiq_installer.sh" 2>/dev/null || stat -c%s "${DIST_DIR}/appiq_installer.sh")",
      "executable": true
    },
    "quick_install": {
      "filename": "quick-install.sh", 
      "description": "One-command download and install script",
      "size": "$(stat -f%z "${DIST_DIR}/quick-install.sh" 2>/dev/null || stat -c%s "${DIST_DIR}/quick-install.sh")",
      "executable": true
    },
    "documentation": {
      "filename": "README.md",
      "description": "Complete setup and usage documentation",
      "size": "$(stat -f%z "${DIST_DIR}/README.md" 2>/dev/null || stat -c%s "${DIST_DIR}/README.md")"
    }
  },
  "capabilities": [
    "mobile_development",
    "flutter_support", 
    "react_native_support",
    "interactive_workflows",
    "ide_integration",
    "auto_configuration"
  ],
  "supported_ides": [
    "claude",
    "cursor", 
    "windsurf",
    "universal"
  ],
  "workflows": [
    "mobile-greenfield-flutter",
    "mobile-greenfield-react-native",
    "mobile-brownfield-flutter", 
    "mobile-brownfield-react-native"
  ]
}
EOF

# Final validation
echo -e "${BLUE}🔍 Final validation...${NC}"
validation_errors=0

# Check all required files exist
required_files=(
    "appiq_installer.sh"
    "quick-install.sh"
    "README.md"
    "VERSION"
    "CHECKSUMS.sha256"
    "INSTALL_EXAMPLES.md"
    "RELEASE_NOTES.md"
    "MANIFEST.json"
)

for file in "${required_files[@]}"; do
    if [ ! -f "${DIST_DIR}/${file}" ]; then
        echo -e "${RED}❌ Missing release file: ${file}${NC}"
        ((validation_errors++))
    else
        echo -e "${GREEN}✅ Found: ${file}${NC}"
    fi
done

# Check installer is executable
if [ ! -x "${DIST_DIR}/appiq_installer.sh" ]; then
    echo -e "${RED}❌ Installer is not executable${NC}"
    ((validation_errors++))
fi

if [ $validation_errors -gt 0 ]; then
    echo -e "${RED}❌ Release validation failed with ${validation_errors} errors${NC}"
    exit 1
fi

# Success message
echo -e "${GREEN}"
echo "╔══════════════════════════════════════════════════════════════════╗"
echo "║                     ✅ RELEASE BUILD COMPLETE!                   ║"
echo "╚══════════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

echo -e "${CYAN}🎉 APPIQ Method v${VERSION} release package created successfully!${NC}"
echo ""
echo -e "${YELLOW}📦 Release Package Location:${NC}"
echo -e "${BLUE}${DIST_DIR}/${NC}"
echo ""
echo -e "${YELLOW}📋 Package Contents:${NC}"
cd "${DIST_DIR}"
ls -la
echo ""
echo -e "${YELLOW}📏 Package Sizes:${NC}"
du -h * | sort -hr
echo ""
echo -e "${YELLOW}🚀 Quick Test Installation:${NC}"
echo -e "${BLUE}cd /tmp && mkdir test-project && cd test-project${NC}"
echo -e "${BLUE}bash ${DIST_DIR}/appiq_installer.sh${NC}"
echo ""
echo -e "${YELLOW}📤 Ready for Distribution:${NC}"
echo "• Upload to GitHub Releases"
echo "• Update download URLs in quick-install.sh"
echo "• Share installation command:"
echo -e "${GREEN}curl -fsSL [your-url]/quick-install.sh | bash${NC}"

# Create test command
echo -e "${BLUE}bash ${DIST_DIR}/appiq_installer.sh --help${NC}" > "${DIST_DIR}/test-install.sh"
chmod +x "${DIST_DIR}/test-install.sh"