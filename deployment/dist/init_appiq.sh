#!/bin/bash

# APPIQ Method Mobile Development - Project Initialization Script
# Version: 1.0.0
# Description: One-command setup for APPIQ Method in any project

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
APPIQ_VERSION="latest"
PROJECT_ROOT="$(pwd)"
APPIQ_DIR=".appiq"
DOCS_DIR="docs"

# Banner
show_banner() {
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════════════════════════════╗"
    echo "║                    🚀 APPIQ METHOD INSTALLER                     ║"
    echo "║                                                                  ║"
    echo "║              Mobile Development Workflow Setup                   ║"
    echo "║                        Version 1.0.0                            ║"
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
    
    log_success "Directory structure created"
}

# Download APPIQ Method files
download_appiq_method() {
    log_step "Downloading APPIQ Method files..."
    
    # Create temporary directory
    TEMP_DIR=$(mktemp -d)
    
    # Clone or download APPIQ Method
    if command -v git >/dev/null 2>&1; then
        log_info "Cloning APPIQ Method repository..."
        git clone --depth 1 "${APPIQ_REPO_URL}" "${TEMP_DIR}/appiq-method" 2>/dev/null || {
            log_warning "Git clone failed, using fallback method..."
            download_appiq_fallback "${TEMP_DIR}"
        }
    else
        log_warning "Git not found, using fallback method..."
        download_appiq_fallback "${TEMP_DIR}"
    fi
    
    # Copy files to project
    if [ -d "${TEMP_DIR}/appiq-method" ]; then
        cp -r "${TEMP_DIR}/appiq-method/expansion-packs" "${APPIQ_DIR}/"
        cp -r "${TEMP_DIR}/appiq-method/bmad-core" "${APPIQ_DIR}/"
        cp -r "${TEMP_DIR}/appiq-method/slash-commands" "${APPIQ_DIR}/"
        
        # Copy specific mobile files
        cp -r "${TEMP_DIR}/appiq-method/expansion-packs/bmad-mobile-app-dev"/* "${APPIQ_DIR}/"
        
        log_success "APPIQ Method files installed"
    else
        log_error "Failed to download APPIQ Method files"
        exit 1
    fi
    
    # Cleanup
    rm -rf "${TEMP_DIR}"
}

# Fallback download method (using embedded files)
download_appiq_fallback() {
    local temp_dir="$1"
    log_info "Using embedded APPIQ Method files..."
    
    # This would contain the essential files embedded in the script
    # For now, we'll create the basic structure
    mkdir -p "${temp_dir}/appiq-method/expansion-packs/bmad-mobile-app-dev"
    
    # Create essential files (embedded content would go here)
    create_embedded_files "${temp_dir}/appiq-method"
}

# Create embedded essential files
create_embedded_files() {
    local base_dir="$1"
    
    log_info "Creating essential APPIQ files..."
    
    # Create basic workflow files
    mkdir -p "${base_dir}/expansion-packs/bmad-mobile-app-dev/workflows"
    mkdir -p "${base_dir}/expansion-packs/bmad-mobile-app-dev/agents"
    mkdir -p "${base_dir}/expansion-packs/bmad-mobile-app-dev/templates"
    
    # Basic agent files (minimal versions)
    cat > "${base_dir}/expansion-packs/bmad-mobile-app-dev/agents/mobile-pm.md" << 'EOF'
# Mobile Project Manager Agent

## Role
Mobile-focused project management and PRD creation specialist.

## Capabilities
- Mobile PRD creation
- Mobile project planning
- Platform strategy
- Mobile user story management

## Usage
@mobile-pm - [your mobile PM request]
EOF
    
    # Create appiq command
    mkdir -p "${base_dir}/slash-commands"
    cat > "${base_dir}/slash-commands/appiq.md" << 'EOF'
# /appiq - APPIQ Method Mobile Development Launcher

Interactive mobile development workflow launcher.

Usage: /appiq

This command will guide you through:
1. Project type selection (Greenfield/Brownfield)
2. Platform selection (Flutter/React Native)
3. PRD validation
4. Workflow launch
EOF
    
    log_success "Essential files created"
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
  }
}
EOF
    
    log_success "Project configuration created"
}

# Create IDE configurations
create_ide_configs() {
    log_step "Creating IDE configurations..."
    
    # Claude Code configuration
    cat > "${APPIQ_DIR}/config/claude.json" << 'EOF'
{
  "slash_commands": {
    "/appiq": {
      "description": "Interactive APPIQ Method mobile development launcher",
      "handler": "appiq-handler",
      "expansion_pack": "bmad-mobile-app-dev",
      "auto_context": true
    }
  },
  "agents": {
    "mobile-pm": ".appiq/agents/mobile-pm.md",
    "mobile-architect": ".appiq/agents/mobile-architect.md",
    "mobile-developer": ".appiq/agents/mobile-developer.md",
    "mobile-qa": ".appiq/agents/mobile-qa.md"
  }
}
EOF
    
    # Cursor configuration
    cat > "${APPIQ_DIR}/config/cursor.json" << 'EOF'
{
  "appiq.enabled": true,
  "appiq.mobile_expansion": true,
  "appiq.workflow_path": "./.appiq/workflows/",
  "appiq.auto_detection": true,
  "commands": {
    "appiq.launchMobileWorkflow": {
      "title": "APPIQ: Launch Mobile Development Workflow",
      "category": "APPIQ Method"
    }
  },
  "keybindings": [
    {
      "command": "appiq.launchMobileWorkflow",
      "key": "ctrl+alt+a",
      "mac": "cmd+alt+a"
    }
  ]
}
EOF
    
    # Windsurf configuration
    cat > "${APPIQ_DIR}/config/windsurf.json" << 'EOF'
{
  "extensions": {
    "appiq-method": {
      "enabled": true,
      "mobile_workflows": true,
      "auto_detection": true,
      "ai_analysis": true
    }
  },
  "workspace": {
    "appiq_integration": true,
    "mobile_platform_detection": true,
    "workflow_suggestions": true
  }
}
EOF
    
    log_success "IDE configurations created"
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
    
    # Create appiq command wrapper
    cat > "${APPIQ_DIR}/scripts/appiq" << 'EOF'
#!/bin/bash

# APPIQ Method Command Wrapper
# Usage: ./appiq [command] [args]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$(dirname "${SCRIPT_DIR}")")"

case "$1" in
    "init"|"")
        echo "🚀 APPIQ Method Mobile Development"
        echo "Available commands:"
        echo "  ./appiq status     - Show project status"
        echo "  ./appiq validate   - Validate project setup"
        echo "  ./appiq update     - Update APPIQ Method"
        echo "  ./appiq help       - Show this help"
        echo ""
        echo "To start development workflow:"
        echo "  Use /appiq command in your IDE chat"
        ;;
    "status")
        echo "📊 APPIQ Project Status"
        echo "Project: $(basename "${PROJECT_ROOT}")"
        echo "Type: $(cat "${PROJECT_ROOT}/.appiq/config/project.json" | grep project_type | cut -d'"' -f4)"
        if [ -f "${PROJECT_ROOT}/docs/main_prd.md" ]; then
            echo "✅ PRD: docs/main_prd.md exists"
        else
            echo "❌ PRD: docs/main_prd.md missing"
        fi
        echo "🔧 APPIQ Version: $(cat "${PROJECT_ROOT}/.appiq/config/project.json" | grep appiq_version | cut -d'"' -f4)"
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
        
        if [ $errors -eq 0 ]; then
            echo "✅ All validations passed!"
        else
            echo "❌ Found $errors issues"
            exit 1
        fi
        ;;
    "update")
        echo "🔄 Updating APPIQ Method..."
        # Re-run the installer to update
        bash "${SCRIPT_DIR}/../init_appiq.sh" --update
        ;;
    "help"|*)
        echo "🚀 APPIQ Method Helper"
        echo "Commands:"
        echo "  status    - Show project status"
        echo "  validate  - Validate setup"
        echo "  update    - Update APPIQ Method"
        echo "  help      - Show this help"
        ;;
esac
EOF
    
    chmod +x "${APPIQ_DIR}/scripts/appiq"
    
    # Create IDE integration script
    cat > "${APPIQ_DIR}/scripts/setup_ide.sh" << 'EOF'
#!/bin/bash

# IDE Integration Setup Script

echo "🔧 Setting up IDE integrations..."

# Detect available IDEs and set up configurations
setup_claude() {
    echo "Setting up Claude Code integration..."
    # Copy Claude configuration
    cp .appiq/config/claude.json ~/.claude-code/appiq-config.json 2>/dev/null || true
}

setup_cursor() {
    echo "Setting up Cursor integration..."
    # Copy Cursor configuration to workspace settings
    mkdir -p .vscode
    cp .appiq/config/cursor.json .vscode/settings.json 2>/dev/null || true
}

setup_windsurf() {
    echo "Setting up Windsurf integration..."
    # Copy Windsurf configuration
    cp .appiq/config/windsurf.json .windsurf/settings.json 2>/dev/null || true
}

# Run setup for detected IDEs
if command -v claude >/dev/null 2>&1; then
    setup_claude
fi

if [ -d ".vscode" ] || command -v cursor >/dev/null 2>&1; then
    setup_cursor
fi

if [ -d ".windsurf" ] || command -v windsurf >/dev/null 2>&1; then
    setup_windsurf
fi

echo "✅ IDE integration setup complete"
echo "💡 Use /appiq command in your IDE to start mobile development workflow"
EOF
    
    chmod +x "${APPIQ_DIR}/scripts/setup_ide.sh"
    
    log_success "Helper scripts created"
}

# Create .gitignore entries
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
   ```
   # In your IDE chat (Claude, Cursor, Windsurf)
   /appiq
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

### Required Files

- `docs/main_prd.md` - Product Requirements Document (customize the template)

### IDE Support

- ✅ Claude Code - Use `/appiq` command
- ✅ Cursor AI - Use `/appiq` or `Ctrl+Alt+A`
- ✅ Windsurf - Use `/appiq` with AI analysis
- ✅ Any IDE with chat support

### Learn More

- [APPIQ Method Documentation](https://your-docs-url.com)
- [Mobile Development Guide](./.appiq/README.md)
EOF
        log_success "README.md updated with APPIQ section"
    else
        log_info "README.md already contains APPIQ section"
    fi
}

# Create local documentation
create_local_docs() {
    log_step "Creating local documentation..."
    
    cat > "${APPIQ_DIR}/README.md" << 'EOF'
# APPIQ Method - Mobile Development Setup

## Overview
This directory contains your project's APPIQ Method configuration for mobile development.

## Directory Structure
```
.appiq/
├── agents/          # Mobile-specific agents
├── workflows/       # Mobile development workflows
├── templates/       # Document templates
├── config/          # IDE and project configurations
├── scripts/         # Helper scripts
└── README.md        # This file
```

## Getting Started

### 1. Customize Your PRD
Edit `docs/main_prd.md` with your project requirements.

### 2. Start Development Workflow
Use `/appiq` command in your IDE chat:
- Claude Code: `/appiq`
- Cursor: `/appiq` or `Ctrl+Alt+A`
- Windsurf: `/appiq`

### 3. Follow the Workflow
The system will guide you through:
1. Project type selection (Greenfield/Brownfield)
2. Platform selection (Flutter/React Native)
3. PRD validation
4. Automated workflow launch

## Available Commands

### In IDE Chat
- `/appiq` - Launch interactive mobile development workflow

### Command Line
- `./.appiq/scripts/appiq status` - Show project status
- `./.appiq/scripts/appiq validate` - Validate setup
- `./.appiq/scripts/appiq update` - Update APPIQ Method

## Mobile Development Workflows

### Greenfield (New Apps)
- **Flutter**: Complete Flutter app development from concept to deployment
- **React Native**: Complete React Native app development

### Brownfield (Existing Apps)  
- **Flutter Enhancement**: Add features to existing Flutter apps
- **React Native Enhancement**: Add features to existing React Native apps

## Support
- Run validation: `./.appiq/scripts/appiq validate`
- Check status: `./.appiq/scripts/appiq status`
- Update system: `./.appiq/scripts/appiq update`
EOF
    
    log_success "Local documentation created"
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
        "${APPIQ_DIR}/README.md"
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
    echo -e "${GREEN}"
    echo "╔══════════════════════════════════════════════════════════════════╗"
    echo "║                    ✅ INSTALLATION COMPLETE!                     ║"
    echo "╚══════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    echo -e "${CYAN}🎉 APPIQ Method has been successfully installed in your project!${NC}"
    echo ""
    echo -e "${YELLOW}📋 Next Steps:${NC}"
    echo "1. Customize your PRD: ${BLUE}docs/main_prd.md${NC}"
    echo "2. Open your IDE (Claude, Cursor, Windsurf)"
    echo "3. Use the command: ${GREEN}/appiq${NC}"
    echo ""
    echo -e "${YELLOW}📊 Quick Commands:${NC}"
    echo "• Check status: ${BLUE}./.appiq/scripts/appiq status${NC}"
    echo "• Validate setup: ${BLUE}./.appiq/scripts/appiq validate${NC}"
    echo "• Update system: ${BLUE}./.appiq/scripts/appiq update${NC}"
    echo ""
    echo -e "${YELLOW}💡 Supported IDEs:${NC}"
    echo "• Claude Code: Use ${GREEN}/appiq${NC} command"
    echo "• Cursor: Use ${GREEN}/appiq${NC} or ${GREEN}Ctrl+Alt+A${NC}"
    echo "• Windsurf: Use ${GREEN}/appiq${NC} with AI analysis"
    echo ""
    echo -e "${PURPLE}📖 Documentation: ${BLUE}./.appiq/README.md${NC}"
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
    download_appiq_method
    
    # Configure project
    create_project_config
    create_ide_configs
    create_prd_template
    
    # Create utilities
    create_helper_scripts
    update_gitignore
    create_readme_section
    create_local_docs
    
    # Validate and complete
    if validate_installation; then
        show_completion
        
        # Setup IDE integrations
        "${APPIQ_DIR}/scripts/setup_ide.sh"
        
        exit 0
    else
        log_error "Installation failed validation"
        exit 1
    fi
}

# Handle command line arguments
case "${1:-}" in
    "--help"|"-h")
        echo "APPIQ Method Installer"
        echo "Usage: $0 [options]"
        echo "Options:"
        echo "  --help, -h     Show this help"
        echo "  --update       Update existing installation"
        echo "  --version      Show version"
        exit 0
        ;;
    "--version"|"-v")
        echo "APPIQ Method Installer v${APPIQ_VERSION}"
        exit 0
        ;;
    "--update")
        log_info "Updating APPIQ Method installation..."
        # Remove old files but keep config and docs
        rm -rf "${APPIQ_DIR}/agents" "${APPIQ_DIR}/workflows" "${APPIQ_DIR}/templates"
        # Continue with normal installation
        ;;
esac

# Run main installation
main "$@"