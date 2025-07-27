#!/bin/bash

# APPIQ Method Mobile Development - Complete Installation Script v2.0
# One-command setup for APPIQ Method with proper IDE integration

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
APPIQ_REPO_URL="https://github.com/Viktor-Hermann/APPIQ-METHOD.git"
APPIQ_VERSION="2.0.0"
PROJECT_ROOT="$(pwd)"
APPIQ_DIR=".appiq"
DOCS_DIR="docs"

# Banner
show_banner() {
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════════════════════════════╗"
    echo "║                    🚀 APPIQ METHOD INSTALLER v2.0                ║"
    echo "║                                                                  ║"
    echo "║              Complete Mobile Development Setup                   ║"
    echo "║             Claude • Cursor • Windsurf • Terminal               ║"
    echo "╚══════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_step() {
    echo -e "${PURPLE}[STEP]${NC} $1"
}

# Detect available IDEs
detect_ides() {
    log_step "Detecting available IDEs..."
    
    local ides_found=()
    
    # Check for Claude Code (check for .claude directory or claude command)
    if command -v claude >/dev/null 2>&1 || [ -d "$HOME/.claude" ]; then
        ides_found+=("claude")
        log_info "✅ Claude Code detected"
    fi
    
    # Check for Cursor (check for cursor command or common installation paths)
    if command -v cursor >/dev/null 2>&1 || [ -d "/Applications/Cursor.app" ] || [ -d "$HOME/.cursor" ]; then
        ides_found+=("cursor")
        log_info "✅ Cursor IDE detected"
    fi
    
    # Check for Windsurf (check for windsurf command or installation)
    if command -v windsurf >/dev/null 2>&1 || [ -d "/Applications/Windsurf.app" ] || [ -d "$HOME/.windsurf" ]; then
        ides_found+=("windsurf")
        log_info "✅ Windsurf IDE detected"
    fi
    
    # Always include terminal
    ides_found+=("terminal")
    log_info "✅ Terminal integration will be installed"
    
    if [ ${#ides_found[@]} -eq 1 ]; then
        log_warning "Only terminal integration will be installed"
        log_info "Install Claude, Cursor, or Windsurf for full IDE integration"
    fi
    
    echo "${ides_found[@]}"
}

# Check if we're in a git repository
check_git_repo() {
    if [ ! -d ".git" ]; then
        log_warning "Not in a git repository. Initializing git..."
        git init
        log_success "Git repository initialized"
    else
        log_info "Git repository detected"
    fi
}

# Detect project type
detect_project_type() {
    log_step "Detecting project type..."
    
    if [ -f "pubspec.yaml" ]; then
        echo "flutter"
    elif [ -f "package.json" ] && grep -q "react-native" package.json 2>/dev/null; then
        echo "react-native"
    elif [ -f "package.json" ]; then
        echo "web"
    elif [ -f "pom.xml" ] || [ -f "build.gradle" ]; then
        echo "java"
    elif [ -f "requirements.txt" ] || [ -f "pyproject.toml" ]; then
        echo "python"
    else
        echo "unknown"
    fi
}

# Create directory structure
create_directory_structure() {
    log_step "Creating APPIQ directory structure..."
    
    # Create main directories
    mkdir -p "${APPIQ_DIR}"
    mkdir -p "${DOCS_DIR}"
    mkdir -p "${APPIQ_DIR}/workflows"
    mkdir -p "${APPIQ_DIR}/agents"
    mkdir -p "${APPIQ_DIR}/templates"
    mkdir -p "${APPIQ_DIR}/config"
    mkdir -p "${APPIQ_DIR}/scripts"
    mkdir -p "${APPIQ_DIR}/installers"
    
    log_success "Directory structure created"
}

# Download APPIQ Method files from embedded content
extract_appiq_method() {
    log_step "Extracting APPIQ Method files..."
    
    # Check if we have embedded content (from packaged installer)
    ARCHIVE_LINE=$(awk '/^__ARCHIVE_BELOW__/ {print NR + 1; exit 0; }' "$0" 2>/dev/null || echo "0")
    
    if [ "$ARCHIVE_LINE" -gt 0 ]; then
        log_info "Extracting from embedded archive..."
        tail -n +${ARCHIVE_LINE} "$0" | tar xzf - -C "${APPIQ_DIR}/"
        log_success "APPIQ Method files extracted from embedded archive"
    else
        log_info "Downloading from GitHub repository..."
        # Fallback to git clone
        TEMP_DIR=$(mktemp -d)
        if git clone --depth 1 "${APPIQ_REPO_URL}" "${TEMP_DIR}/appiq-method" 2>/dev/null; then
            cp -r "${TEMP_DIR}/appiq-method/expansion-packs/bmad-mobile-app-dev"/* "${APPIQ_DIR}/"
            cp -r "${TEMP_DIR}/appiq-method/slash-commands" "${APPIQ_DIR}/"
            cp -r "${TEMP_DIR}/appiq-method/deployment/installers" "${APPIQ_DIR}/"
            rm -rf "${TEMP_DIR}"
            log_success "APPIQ Method files downloaded from GitHub"
        else
            log_error "Failed to download APPIQ Method files"
            exit 1
        fi
    fi
}

# Create project configuration
create_project_config() {
    log_step "Creating project configuration..."
    
    local project_type=$(detect_project_type)
    
    cat > "${APPIQ_DIR}/config/project.json" << EOF
{
  "project_name": "$(basename "${PROJECT_ROOT}")",
  "project_type": "${project_type}",
  "appiq_version": "${APPIQ_VERSION}",
  "installation_date": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "mobile_platform": null,
  "workflow_preference": null,
  "auto_detect": true,
  "required_files": [
    "docs/main_prd.md"
  ],
  "output_directory": "docs/",
  "workflows": {
    "mobile_greenfield_flutter": ".appiq/workflows/mobile-greenfield-flutter.yaml",
    "mobile_greenfield_react_native": ".appiq/workflows/mobile-greenfield-react-native.yaml",
    "mobile_brownfield_flutter": ".appiq/workflows/mobile-brownfield-flutter.yaml",
    "mobile_brownfield_react_native": ".appiq/workflows/mobile-brownfield-react-native.yaml"
  },
  "ides_installed": []
}
EOF
    
    log_success "Project configuration created"
}

# Install IDE integrations
install_ide_integrations() {
    log_step "Installing IDE integrations..."
    
    local ides=($(detect_ides))
    local installed_ides=()
    
    for ide in "${ides[@]}"; do
        case $ide in
            "claude")
                if [ -f "${APPIQ_DIR}/installers/claude-integration.sh" ]; then
                    log_info "Installing Claude Code integration..."
                    bash "${APPIQ_DIR}/installers/claude-integration.sh"
                    installed_ides+=("claude")
                fi
                ;;
            "cursor")
                if [ -f "${APPIQ_DIR}/installers/cursor-integration.sh" ]; then
                    log_info "Installing Cursor IDE integration..."
                    bash "${APPIQ_DIR}/installers/cursor-integration.sh"
                    installed_ides+=("cursor")
                fi
                ;;
            "windsurf")
                if [ -f "${APPIQ_DIR}/installers/windsurf-integration.sh" ]; then
                    log_info "Installing Windsurf IDE integration..."
                    bash "${APPIQ_DIR}/installers/windsurf-integration.sh"
                    installed_ides+=("windsurf")
                fi
                ;;
            "terminal")
                if [ -f "${APPIQ_DIR}/installers/terminal-integration.sh" ]; then
                    log_info "Installing Terminal integration..."
                    bash "${APPIQ_DIR}/installers/terminal-integration.sh"
                    installed_ides+=("terminal")
                fi
                ;;
        esac
    done
    
    # Update project config with installed IDEs
    if command -v jq >/dev/null 2>&1; then
        jq ".ides_installed = $(printf '%s\n' "${installed_ides[@]}" | jq -R . | jq -s .)" "${APPIQ_DIR}/config/project.json" > "${APPIQ_DIR}/config/project.json.tmp" && mv "${APPIQ_DIR}/config/project.json.tmp" "${APPIQ_DIR}/config/project.json"
    fi
    
    log_success "IDE integrations installed: ${installed_ides[*]}"
}

# Create main PRD template
create_prd_template() {
    log_step "Creating main PRD template..."
    
    if [ ! -f "${DOCS_DIR}/main_prd.md" ]; then
        cat > "${DOCS_DIR}/main_prd.md" << 'EOF'
# Main Product Requirements Document

## Project Overview
**Project Name:** [Your Mobile App Name]
**Type:** Mobile Application
**Platform:** [ ] iOS [ ] Android [ ] Cross-platform

## Target Platforms
- [ ] iOS (iPhone/iPad)
- [ ] Android (Phone/Tablet)
- [ ] Cross-platform (Flutter/React Native)

## Core Features
### Epic 1: [Core Functionality]
- [ ] User registration and authentication
- [ ] User profile management
- [ ] Core feature implementation

### Epic 2: [Secondary Features]
- [ ] Feature 2 implementation
- [ ] Feature 3 implementation
- [ ] Integration features

### Epic 3: [Advanced Features]
- [ ] Advanced functionality
- [ ] Analytics and tracking
- [ ] Performance optimization

## Technical Requirements
### Platform Specifics
- **Framework:** [Flutter/React Native/Native]
- **Programming Language:** [Dart/JavaScript/TypeScript/Swift/Kotlin]
- **State Management:** [BLoC/Riverpod/Redux/Context API]
- **Backend Integration:** [REST API/GraphQL/Firebase]

### Performance Requirements
- App launch time: < 3 seconds
- Screen transition: < 300ms
- Offline functionality: [Required/Not Required]
- Device compatibility: [Minimum versions]

### Security Requirements
- Authentication method: [OAuth/JWT/Biometric]
- Data encryption: [End-to-end/Transport layer]
- OWASP Mobile Top 10 compliance
- Privacy compliance: [GDPR/CCPA]

## User Stories
### Authentication
- As a user, I want to register with email/phone
- As a user, I want to login securely
- As a user, I want to reset my password

### Core Functionality
- As a user, I want to [main feature]
- As a user, I want to [secondary feature]
- As a user, I want to [additional feature]

## Success Criteria
- [ ] App store approval (iOS/Android)
- [ ] User acquisition: [target number] downloads in first month
- [ ] Performance: App rating > 4.0 stars
- [ ] Technical: Crash rate < 1%
- [ ] Business: [Specific business metrics]

## Timeline
- **Phase 1:** MVP development (X weeks)
- **Phase 2:** Feature enhancement (X weeks)
- **Phase 3:** Launch and optimization (X weeks)

---
*This PRD will be used by APPIQ Method to generate detailed mobile development workflows.*
EOF
        
        log_success "PRD template created at ${DOCS_DIR}/main_prd.md"
        log_info "Please customize this file with your project requirements"
    else
        log_info "main_prd.md already exists, skipping template creation"
    fi
}

# Create helper scripts
create_helper_scripts() {
    log_step "Creating helper scripts..."
    
    # Create appiq command wrapper (local version)
    cat > "${APPIQ_DIR}/scripts/appiq" << 'EOF'
#!/bin/bash

# APPIQ Method Command Wrapper (Local Project Version)
# Usage: ./.appiq/scripts/appiq [command] [args]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$(dirname "${SCRIPT_DIR}")")"

case "$1" in
    "init"|"")
        echo "🚀 APPIQ Method Mobile Development"
        echo "Available commands:"
        echo "  ./.appiq/scripts/appiq status     - Show project status"
        echo "  ./.appiq/scripts/appiq validate   - Validate project setup"
        echo "  ./.appiq/scripts/appiq help       - Show this help"
        echo ""
        echo "To start development workflow:"
        echo "  Use /appiq command in your IDE chat"
        echo "  Or use 'appiq' command in terminal (if installed)"
        ;;
    "status")
        echo "📊 APPIQ Project Status"
        echo "Project: $(basename "${PROJECT_ROOT}")"
        echo "Type: $(cat "${PROJECT_ROOT}/.appiq/config/project.json" 2>/dev/null | grep project_type | cut -d'"' -f4 || echo "unknown")"
        if [ -f "${PROJECT_ROOT}/docs/main_prd.md" ]; then
            echo "✅ PRD: docs/main_prd.md exists"
        else
            echo "❌ PRD: docs/main_prd.md missing"
        fi
        echo "🔧 APPIQ Version: $(cat "${PROJECT_ROOT}/.appiq/config/project.json" 2>/dev/null | grep appiq_version | cut -d'"' -f4 || echo "unknown")"
        
        # Show installed IDEs
        if command -v jq >/dev/null 2>&1 && [ -f "${PROJECT_ROOT}/.appiq/config/project.json" ]; then
            local ides=$(jq -r '.ides_installed[]?' "${PROJECT_ROOT}/.appiq/config/project.json" 2>/dev/null | tr '\n' ' ')
            if [ -n "$ides" ]; then
                echo "🎨 IDEs: $ides"
            fi
        fi
        ;;
    "validate")
        echo "🔍 Validating APPIQ setup..."
        errors=0
        
        if [ ! -f "${PROJECT_ROOT}/docs/main_prd.md" ]; then
            echo "❌ Missing: docs/main_prd.md"
            ((errors++))
        else
            echo "✅ Found: docs/main_prd.md"
        fi
        
        if [ ! -d "${PROJECT_ROOT}/.appiq" ]; then
            echo "❌ Missing: .appiq directory"
            ((errors++))
        else
            echo "✅ Found: .appiq directory"
        fi
        
        # Check for workflows
        local workflow_count=$(find "${PROJECT_ROOT}/.appiq/workflows" -name "*.yaml" 2>/dev/null | wc -l)
        if [ "$workflow_count" -gt 0 ]; then
            echo "✅ Found: $workflow_count workflow(s)"
        else
            echo "❌ Missing: workflow files"
            ((errors++))
        fi
        
        # Check for agents
        local agent_count=$(find "${PROJECT_ROOT}/.appiq/agents" -name "*.md" 2>/dev/null | wc -l)
        if [ "$agent_count" -gt 0 ]; then
            echo "✅ Found: $agent_count agent(s)"
        else
            echo "❌ Missing: agent files"
            ((errors++))
        fi
        
        if [ $errors -eq 0 ]; then
            echo "✅ All validations passed!"
        else
            echo "❌ Found $errors issues"
            exit 1
        fi
        ;;
    "help"|*)
        echo "🚀 APPIQ Method Helper"
        echo "Commands:"
        echo "  status    - Show project status"
        echo "  validate  - Validate setup"
        echo "  help      - Show this help"
        echo ""
        echo "Development commands:"
        echo "  /appiq    - Use in IDE chat to start workflows"
        echo "  appiq     - Use in terminal (global command)"
        ;;
esac
EOF
    
    chmod +x "${APPIQ_DIR}/scripts/appiq"
    
    log_success "Helper scripts created"
}

# Update .gitignore
update_gitignore() {
    log_step "Updating .gitignore..."
    
    if [ ! -f ".gitignore" ]; then
        touch ".gitignore"
    fi
    
    # Add APPIQ-specific ignores if not already present
    if ! grep -q ".appiq/temp" .gitignore 2>/dev/null; then
        cat >> .gitignore << 'EOF'

# APPIQ Method
.appiq/temp/
.appiq/cache/
.appiq/logs/
.appiq/installers/
EOF
        log_success ".gitignore updated"
    else
        log_info ".gitignore already contains APPIQ entries"
    fi
}

# Create README section
create_readme_section() {
    log_step "Adding APPIQ section to README..."
    
    local readme_file="README.md"
    if [ ! -f "${readme_file}" ]; then
        readme_file="README.md"
        touch "${readme_file}"
    fi
    
    # Check if APPIQ section already exists
    if ! grep -q "APPIQ Method" "${readme_file}" 2>/dev/null; then
        cat >> "${readme_file}" << 'EOF'

## 🚀 APPIQ Method - Mobile Development

This project uses the APPIQ Method for mobile development workflow automation.

### Quick Start

1. **Start Development Workflow**
   
   **In your IDE (Claude, Cursor, Windsurf):**
   ```
   /appiq
   ```
   
   **In Terminal:**
   ```bash
   appiq
   ```

2. **Check Project Status**
   ```bash
   ./.appiq/scripts/appiq status
   ```

3. **Validate Setup**
   ```bash
   ./.appiq/scripts/appiq validate
   ```

### Available Workflows

- **Greenfield Flutter**: New Flutter app development
- **Greenfield React Native**: New React Native app development  
- **Brownfield Flutter**: Existing Flutter app enhancement
- **Brownfield React Native**: Existing React Native app enhancement

### IDE Integration

- ✅ **Claude Code**: Use `/appiq` command in chat
- ✅ **Cursor**: Use `/appiq` or `Ctrl+Alt+A` keyboard shortcut
- ✅ **Windsurf**: Use `/appiq` with AI-powered analysis
- ✅ **Terminal**: Use `appiq` command globally

### Required Files

- `docs/main_prd.md` - Product Requirements Document (customize the template)

### Learn More

- [APPIQ Method Documentation](https://github.com/Viktor-Hermann/APPIQ-METHOD)
- [Mobile Development Guide](./.appiq/README.md)
EOF
        log_success "README.md updated with APPIQ section"
    else
        log_info "README.md already contains APPIQ section"
    fi
}

# Validate installation
validate_installation() {
    log_step "Validating installation..."
    
    errors=0
    
    # Check directories
    for dir in "${APPIQ_DIR}" "${DOCS_DIR}" "${APPIQ_DIR}/config" "${APPIQ_DIR}/scripts"; do
        if [ ! -d "${dir}" ]; then
            log_error "Missing directory: ${dir}"
            ((errors++))
        fi
    done
    
    # Check essential files
    essential_files=(
        "${DOCS_DIR}/main_prd.md"
        "${APPIQ_DIR}/config/project.json"
        "${APPIQ_DIR}/scripts/appiq"
    )
    
    for file in "${essential_files[@]}"; do
        if [ ! -f "${file}" ]; then
            log_error "Missing file: ${file}"
            ((errors++))
        fi
    done
    
    if [ $errors -eq 0 ]; then
        log_success "Installation validation passed!"
        return 0
    else
        log_error "Installation validation failed with $errors errors"
        return 1
    fi
}

# Show completion message
show_completion() {
    local ides=($(detect_ides))
    
    echo -e "${GREEN}"
    echo "╔══════════════════════════════════════════════════════════════════╗"
    echo "║                    ✅ INSTALLATION COMPLETE!                     ║"
    echo "╚══════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    echo -e "${CYAN}🎉 APPIQ Method has been successfully installed in your project!${NC}"
    echo ""
    echo -e "${YELLOW}📋 Next Steps:${NC}"
    echo "1. Customize your PRD: ${BLUE}docs/main_prd.md${NC}"
    echo "2. Start development workflow:"
    echo ""
    
    # Show IDE-specific instructions
    for ide in "${ides[@]}"; do
        case $ide in
            "claude")
                echo -e "   ${GREEN}Claude Code:${NC} Open Claude and use ${CYAN}/appiq${NC}"
                ;;
            "cursor")
                echo -e "   ${GREEN}Cursor:${NC} Use ${CYAN}/appiq${NC} in chat or press ${CYAN}Ctrl+Alt+A${NC}"
                ;;
            "windsurf")
                echo -e "   ${GREEN}Windsurf:${NC} Use ${CYAN}/appiq${NC} for AI-enhanced workflows"
                ;;
            "terminal")
                echo -e "   ${GREEN}Terminal:${NC} Use ${CYAN}appiq${NC} command anywhere"
                ;;
        esac
    done
    
    echo ""
    echo -e "${YELLOW}📊 Quick Commands:${NC}"
    echo "• Check status: ${BLUE}./.appiq/scripts/appiq status${NC}"
    echo "• Validate setup: ${BLUE}./.appiq/scripts/appiq validate${NC}"
    echo ""
    echo -e "${PURPLE}📖 Documentation: ${BLUE}./.appiq/README.md${NC}"
    echo ""
    echo -e "${CYAN}🚀 Ready to build amazing mobile apps with APPIQ Method!${NC}"
}

# Main installation function
main() {
    show_banner
    
    log_info "Starting APPIQ Method installation in: ${PROJECT_ROOT}"
    
    # Check prerequisites
    check_git_repo
    
    # Create structure
    create_directory_structure
    
    # Download and install APPIQ Method
    extract_appiq_method
    
    # Configure project
    create_project_config
    create_prd_template
    
    # Install IDE integrations
    install_ide_integrations
    
    # Create utilities
    create_helper_scripts
    update_gitignore
    create_readme_section
    
    # Validate and complete
    if validate_installation; then
        show_completion
        exit 0
    else
        log_error "Installation failed validation"
        exit 1
    fi
}

# Handle command line arguments
case "${1:-}" in
    "--help"|"-h")
        echo "APPIQ Method Installer v2.0"
        echo "Usage: $0 [options]"
        echo "Options:"
        echo "  --help, -h     Show this help"
        echo "  --version      Show version"
        exit 0
        ;;
    "--version"|"-v")
        echo "APPIQ Method Installer v${APPIQ_VERSION}"
        exit 0
        ;;
esac

# Run main installation
main "$@"

# Exit before archive (if embedded)
exit 0

__ARCHIVE_BELOW__