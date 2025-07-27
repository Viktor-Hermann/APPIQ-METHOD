#!/bin/bash

# APPIQ Method - Deployment Package Creator
# Creates a single-file installer with all necessary components

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

echo -e "${BLUE}📦 Creating APPIQ Method Deployment Package...${NC}"

# Create output directory
mkdir -p "${OUTPUT_DIR}"

# Start building the package
# Use the new v2.0 installer
cat "${SCRIPT_DIR}/init_appiq_v2.sh" > "${OUTPUT_DIR}/${PACKAGE_NAME}"

# Logging functions
log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }
log_step() { echo -e "${PURPLE}[STEP]${NC} $1"; }

# Check prerequisites
check_prerequisites() {
    log_step "Checking prerequisites..."
    
    # Check if we're in a project directory
    if [ ! -f "package.json" ] && [ ! -f "pubspec.yaml" ] && [ ! -f "README.md" ]; then
        log_warning "This doesn't look like a project directory. Continue anyway? (y/n)"
        read -r response
        if [ "$response" != "y" ] && [ "$response" != "Y" ]; then
            log_info "Installation cancelled"
            exit 0
        fi
    fi
    
    # Initialize git if needed
    if [ ! -d ".git" ]; then
        log_warning "Not a git repository. Initialize git? (y/n)"
        read -r response
        if [ "$response" = "y" ] || [ "$response" = "Y" ]; then
            git init
            log_success "Git repository initialized"
        fi
    fi
}

# Create directory structure
create_directories() {
    log_step "Creating APPIQ directory structure..."
    
    mkdir -p "${APPIQ_DIR}"/{workflows,agents,templates,config,scripts}
    mkdir -p "${DOCS_DIR}"
    
    log_success "Directory structure created"
}

# Extract embedded files
extract_embedded_files() {
    log_step "Extracting APPIQ Method files..."
    
    # Extract files from the end of this script
    ARCHIVE_LINE=$(awk '/^__ARCHIVE_BELOW__/ {print NR + 1; exit 0; }' "$0")
    tail -n +${ARCHIVE_LINE} "$0" | tar xzf - -C "${APPIQ_DIR}/"
    
    log_success "APPIQ Method files extracted"
}

# Create project configuration
create_project_config() {
    log_step "Creating project configuration..."
    
    # Detect project type
    local project_type="unknown"
    if [ -f "pubspec.yaml" ]; then
        project_type="flutter"
    elif [ -f "package.json" ] && grep -q "react-native" package.json 2>/dev/null; then
        project_type="react-native"
    elif [ -f "package.json" ]; then
        project_type="web"
    fi
    
    cat > "${APPIQ_DIR}/config/project.json" << EOF
{
  "project_name": "$(basename "${PROJECT_ROOT}")",
  "project_type": "${project_type}",
  "appiq_version": "1.0.0",
  "installation_date": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "mobile_platform": null,
  "workflow_preference": null,
  "auto_detect": true,
  "required_files": ["docs/main_prd.md"],
  "output_directory": "docs/"
}
EOF
    
    log_success "Project configuration created"
}

# Create main PRD if not exists
create_prd_template() {
    log_step "Setting up PRD template..."
    
    if [ ! -f "${DOCS_DIR}/main_prd.md" ]; then
        cat > "${DOCS_DIR}/main_prd.md" << 'EOF'
# Main Product Requirements Document

## Project Overview
**Project Name:** [Your Mobile App Name]
**Type:** Mobile Application
**Platform:** [ ] iOS [ ] Android [ ] Cross-platform

## Core Features
### Epic 1: Core Functionality
- [ ] User authentication
- [ ] Core feature implementation
- [ ] User interface

### Epic 2: Advanced Features
- [ ] Advanced functionality
- [ ] Integrations
- [ ] Analytics

## Technical Requirements
- **Framework:** [Flutter/React Native]
- **Performance:** App launch < 3 seconds
- **Security:** OWASP Mobile Top 10 compliance
- **Platform:** [iOS/Android/Both]

## User Stories
- As a user, I want to [functionality]
- As a user, I want to [feature]
- As a user, I want to [capability]

## Success Criteria
- [ ] App store approval
- [ ] Performance targets met
- [ ] User satisfaction > 4.0 stars

---
*Customize this PRD with your specific requirements*
EOF
        
        log_success "PRD template created at ${DOCS_DIR}/main_prd.md"
        log_warning "Please customize the PRD with your project requirements"
    else
        log_info "main_prd.md already exists"
    fi
}

# Create helper script
create_helper_script() {
    log_step "Creating helper scripts..."
    
    cat > "${APPIQ_DIR}/scripts/appiq" << 'EOF'
#!/bin/bash

# APPIQ Method Helper Script

case "$1" in
    "status")
        echo "📊 APPIQ Project Status"
        echo "Project: $(basename "$(pwd)")"
        if [ -f "docs/main_prd.md" ]; then
            echo "✅ PRD: docs/main_prd.md exists"
        else
            echo "❌ PRD: docs/main_prd.md missing"
        fi
        ;;
    "validate")
        echo "🔍 Validating APPIQ setup..."
        errors=0
        
        if [ ! -f "docs/main_prd.md" ]; then
            echo "❌ Missing: docs/main_prd.md"
            ((errors++))
        else
            echo "✅ Found: docs/main_prd.md"
        fi
        
        if [ ! -d ".appiq" ]; then
            echo "❌ Missing: .appiq directory"
            ((errors++))
        else
            echo "✅ Found: .appiq directory"
        fi
        
        if [ $errors -eq 0 ]; then
            echo "✅ All validations passed!"
        else
            echo "❌ Found $errors issues"
        fi
        ;;
    *)
        echo "🚀 APPIQ Method Helper"
        echo "Commands:"
        echo "  status    - Show project status"
        echo "  validate  - Validate setup"
        echo ""
        echo "To start development:"
        echo "  Use /appiq command in your IDE chat"
        ;;
esac
EOF
    
    chmod +x "${APPIQ_DIR}/scripts/appiq"
    log_success "Helper script created"
}

# Update README
update_readme() {
    log_step "Updating README..."
    
    local readme_file="README.md"
    if [ ! -f "${readme_file}" ]; then
        touch "${readme_file}"
    fi
    
    if ! grep -q "APPIQ Method" "${readme_file}" 2>/dev/null; then
        cat >> "${readme_file}" << 'EOF'

## 🚀 APPIQ Method - Mobile Development

This project uses APPIQ Method for automated mobile development workflows.

### Quick Start
1. Customize `docs/main_prd.md` with your requirements
2. Use `/appiq` command in your IDE (Claude, Cursor, Windsurf)
3. Follow the interactive workflow

### Commands
- `./.appiq/scripts/appiq status` - Check project status
- `./.appiq/scripts/appiq validate` - Validate setup

### Workflows
- **Greenfield**: New Flutter/React Native app development
- **Brownfield**: Existing app enhancement
EOF
        log_success "README updated"
    else
        log_info "README already contains APPIQ section"
    fi
}

# Show completion message
show_completion() {
    echo -e "${GREEN}"
    echo "╔══════════════════════════════════════════════════════════════════╗"
    echo "║                    ✅ INSTALLATION COMPLETE!                     ║"
    echo "╚══════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    echo -e "${CYAN}🎉 APPIQ Method successfully installed!${NC}"
    echo ""
    echo -e "${YELLOW}📋 Next Steps:${NC}"
    echo "1. Edit: ${BLUE}docs/main_prd.md${NC} (customize for your project)"
    echo "2. Open your IDE (Claude, Cursor, Windsurf)"
    echo "3. Use command: ${GREEN}/appiq${NC}"
    echo ""
    echo -e "${YELLOW}💡 IDE Support:${NC}"
    echo "• Claude Code: ${GREEN}/appiq${NC}"
    echo "• Cursor: ${GREEN}/appiq${NC} or ${GREEN}Ctrl+Alt+A${NC}"
    echo "• Windsurf: ${GREEN}/appiq${NC}"
    echo ""
    echo -e "${YELLOW}🔧 Helper Commands:${NC}"
    echo "• ${BLUE}./.appiq/scripts/appiq status${NC}"
    echo "• ${BLUE}./.appiq/scripts/appiq validate${NC}"
}

# Main installation function
main() {
    show_banner
    log_info "Installing APPIQ Method in: $(pwd)"
    
    check_prerequisites
    create_directories
    extract_embedded_files
    create_project_config
    create_prd_template
    create_helper_script
    update_readme
    
    show_completion
}

# Run installation
main "$@"

# Exit before archive
exit 0

__ARCHIVE_BELOW__
INSTALLER_START

echo -e "${YELLOW}📦 Building embedded archive...${NC}"

# Create temporary directory for files to embed
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

# Create the embedded archive
cd "${TEMP_DIR}"
tar czf - * >> "${OUTPUT_DIR}/${PACKAGE_NAME}"
cd - > /dev/null

# Cleanup
rm -rf "${TEMP_DIR}"

# Make the package executable
chmod +x "${OUTPUT_DIR}/${PACKAGE_NAME}"

echo -e "${GREEN}✅ Package created successfully!${NC}"
echo -e "${BLUE}📍 Location: ${OUTPUT_DIR}/${PACKAGE_NAME}${NC}"
echo ""
echo -e "${YELLOW}📋 Usage Instructions:${NC}"
echo "1. Copy ${PACKAGE_NAME} to any project folder"
echo "2. Run: ${GREEN}bash ${PACKAGE_NAME}${NC}"
echo "3. Follow the installation prompts"
echo "4. Use ${GREEN}/appiq${NC} in your IDE to start development"
echo ""
echo -e "${CYAN}🚀 The installer contains everything needed for APPIQ Method mobile development!${NC}"