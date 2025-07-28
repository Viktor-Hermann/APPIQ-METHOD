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

__ARCHIVE_BELOW__� G��h �Ks#Ir0X3f2�����=� k�
]� YE5��!X�=jղ�@��a"�� ��5�{Z�]��L+�t�q���������{�##�^3�&��������Wxx���� �ky���{��h4�77=�w���X�`����^s����n6��m���X_۾�5>>�g��~
�\��qV�28 f�ú����|��o������;�{ދ����?���_��5��=�����X�����K�3��k�g��/zɨ��q�\���{?������K��?��=t��S�9�o�~?HW?����k�o567�y7���'����(G������vsc{�a}��|���\k.mn{�;���W{�?�Ӻk�>n���=���z�����o,m<��P��7�
ik|�=?Տ��W?T��?�K�7�`�o~(���O|���_?%�a��Z/M��6��|�����Eo������-��5xҼ��>��N��I���t����[�[�hnn���S��5666׷���?����?��������m���\����s>��Q�Z��-�h�;�:Dǜ $�%q��������� ��8�Y'��`�Yxx&�x����U%���4�e��8I�0��Γ|��G�<RϏ��I��r�+?���Cx+�˂(�a�^��Pu��AV_"Rΰ+5�|��kI�Y��y��S?��i��wN���krSn�Aj��PM�C��p���x��T����ʂ�$�Q%"���l�:I/Qr��X��d_i� iă0����Y )g-��,�������4��U�"�i�\�07�q����r�O'�wk���_���~��?�����I�����X����}g�}���C����`}}���������O�Ϸ�
�`ͭ;��1>��?n�i������(�i��{d�e��Q���/ ��恵��#RZ��^۟������q���Xj����#���I�olܭ�����ҟ���������m������S����|�����ϟ��L�����ܴ�ck����Q>���#F������?�)U�Q��B����<0�߂��y���Iػ�'y�OǸD�B�ePI��f
{��X N��T��h�o�1�_k�\�/��u��������Q>w��O�3_�w>p{�}sk�N������X__kl�����2���I��������]��G�����,i��_��������� F��{�0j��l,�5���^����O����PG��Ӹ�����Ɲ���|�쿟��:��A����_8�����w�߇������ۛ�����g�a�����ϼ��(��^_�hޝ��>���?�G���ƭ���ͭ�;������?�_�����s׿����hn�����_����`s�N��������������,��w��>ΧV�-�I�<��iҟ�r�ȏ�6ҥq�fI췼n�IZf�<�-y��Ӆk��G^y�1�'���~#�{>V�ա�N�y�Y�'����a��A�6�h#ͻ��:lWy��A؃����I���x�p���0 ��}�2�7�(_5�0�r�	/b�h�B`u�-��8��P2�ϟ#l�����i���+��W<���N��;f0V�4��0��]J$z4��~҃�oV��ۼ��LA��`�adD��}���\����{����f&
�7���(���x�j��.�"�'�0��tBY��=�j]��]�x�a��|�xȉ�uo7�Mط*�ڲ5��hZF{�t�+�MUH��^4�3��?ͺw�>C��Oԥcs�>��n0�ђN!F��M&iL3��0���ٸ����<��d�� � ��4��{��$Q�q����~8)n���������N���N���h0շ�>����U�qjc��$Z�+���q?M¾X��Ј�D!*$�qAޑ�0�FT���ui���xb]���i��H��n�:N1��ef���X��`�%���&1M*p�|J���)T�&q�;�°��<B5��G�fd�0>�(�n`�ٸ�I漠��͒����`E�:�qྡྷN~��x�#H�(���f�0�ϡ�Z���S�"��O�}l�7�E�2� ��h'8��d��`�R+0���>߃���0����0�k�/��������l��w����܃�7���b�`�=׻f�8��.<��je䉔�|���l��/٨7�IQ$~l{����s	Յ��J���Feri�2�@F�L��4r���91��bjpy�)��*Y�O�XQl���:�ㇺ���S����A����o��ZWP��������l{O)ǜ۶`�ռS��\���9gi ��1��9-�ؿ
/��\��&��+?@�@��� � � ,L�MF?�zQB�H1�#{��g��p2:��>�×0�+�c�1�%��?S� :s�������	�8zE2I��8vM2�#����wm5l�X�%A�p�v��$F�C����a)&�+̪.tJf}eՐ���� ��`� ��d�n�v������dD��.��7A�A&^0�#EM�>�pJ���. �
��AF��-?N�m�P�PuJ�E	l����t0��\��{�'~ڇ5O�8n�Ƌ��ڰ�˝0y
���K�HY�G�5����	L&�2\�]��>.�_)��O-���(8���ya��n�~��I]L�cF��ٯX� Wc.�Β+�X��z�(׏�T戈,��5�0A	�@B4���E
���4@��%.d�r`�� ���h��ͷ\Z��KY�3�!
�4�ķ纍n"`}����/�|�9��[R��v�|�!c6>ϒ䢤E�\�|c����Bw96��80r��r�a�"��P��W�L_�c�v����9z܄Hc<L �(<O} ��:k��1�r��/0$X{{<Ɇ^��ښ�ӛ��Ă@#���O�+/>����l��dW�/D?8� �������z��節5%���&�^$���XdC�,r=����{?���j���)�b]`K�`�;f�����w�}��g���x7�������?�#����$>,�2��'�F��#_��Āt&#���0�+r��B�.�0��.p�:�	�I@�ȡI2����0�8�&WU����p���/⠆��bt�C��%��7 ��ƶM���Nm���v��w�3�C����`l��a�*@�g��;f�B�0�If�A�ψZ���xu[v̠#G�-�5�N^e*Ba�Q�F>H�!)-��,L��_��2C6􅦑Yo4FEp]� �f�q�㡌C�R�P�|���z�:x��	դuC���fv�D -�v�*��roL���D��Yq!I�}|�E���:��Z�W�2|�k����?��7��Τ��)OlW���ܪX���l�6��A���0b�KX�O��CÔ�^WS聂�2�ƭ�R�E��$�����%�&�����,Z�m�/&�̡&ul�$Ȳ|1CR.�%�l`��������-4튜��N�E�9�QV�M�Xd�:��ZaN����%5Y=�.�Z7qg�vG�0��$���~�T�ߟD�a	����0�
�+�`t(x�\��nM��|S</&��b��LS���b�4�`�R�Q� �\���m ^h�8v���}�~fD�-��������$cD|�G�1�'!����?�S\��dXő���wk��
� wȸ�ٝ�F���V����wo>�D��4$���ĉ,J+���X���{#�]�b7� g!��o�	�m�ݘ�:
��W�A������<I@�2{#@cu�gp�~Ѧ�aqzU��A��|�#���.�W�i�-��~02�K�7�mL=���)Zp�d�q��� ?F���);�Cid��h@��@cc�ib&�����2��K��-�`̍ٗ܊Ԗ2�(��m~U��+SJPZ5�8����*�DM�TB}�}�ĵ9���$`�h��y��- �h�"�.A��$� ��صِ᷉�-J&d���
����NǂY�z�T˘�K�L�'9E���H�+�7�,bX"��'+^�s�^��7Utk�.�R��z�&��*�"G��r6��^F	��U��4T��h�������5�5��K~��M�q�[C u.&8��)̀
[P0�H�e��f�~Ñu�l�����c�~��Q��ȟ�G�vx��T�*�x��ZoՉ~�Km��brN��3Ή�:B^�i�C����D����k�46m	NH����m���J{~�emj�n.��IU�x��QRFȚ��� R�|���| Y��J �i^A�6Ӕ�b�.V�	7�9s�N��Q�v�9I��s�� �n�>	yi��2�����AH
����*��"�xY��
+O��+E�e�p�i
���]�jOb�7��A8W�;�Ig�;���>|���/�{�eK=�z��k��mS)u��� >ë��uOW���x��C��:,�Q8��/��M�S�%w1��0㶝��Y�y���YO�k���8���m��rY��4۞�[���*�^1���KGj�k'^T"��V�q9���&Q��@y����i9���Q�Yߜ����Mtl��Z��?O8�}�'����݌�P_2,Q��ῂ�k�2����>�\�4R�2�\E%I��>�D .�"�HQ���M?uǃ����X�B�'nd�0�$�%��HcӶ:� �x\��;�&��O�}�r�����ԆNXw�� �)'cA��r�ı��Ԗ�AN?����߂{�iv�	������X���7��R���X�U\cy��a��|ݢ->���%}�G9"�T��g!'a�{��mx0���W�Ap��DT��u�\ā�m��j6���\,�p�G�!h�b,����D�F�]P�vnS99��?4��ˣ�gTVN*/�I��u�؝��B�i�Ln� �d�u�9eu08���/j��Z&����q!R�6W[IΉ�s\�@Q?
��d?���w��`j�+0� +pfU!��ۼ���z���v&.Jë�*��$����9^lLWwt�+fHg�KKZ��Bq�21d�JD�¢yxX���� E!Fa��̈́k���E_
rTqS˯{�X[�w'�,�E�Ē &"*QČB=!=AN��(�B���'>�c�/�}��c����P��A�۟��^kl�����������������>�6��?|����߃���õ�����߇��s����n��nnm��_w���
��^~�O�������G ��>�}���\�2�4�G�L��u��@������-O��\�@ᯏ���mɜ�On���0 ÿ��/;هH���2���y�QP~��l�x�OoƄo�.�
@Z��N�x-|.P�V��fon����\ڹ�����v4'�`�Տ!cx�1��:Z""6�Z/@w	�����cz�i�^���B�
nqĐo$�(ɒ�p�v��'��q.��>p�)w�8���|
����Y���P��Վ1��ҜC&��T=�{�i��@ �ϔ��H1f�)�4=��>�F�Us�<:8���>��ѩ���Osg�:�g*���-��~w�ۆ�"}�IB��W���_~�0��� �7we\��6��b�xu�٣�+�ƈ~��Q\T���A��Á�1S퀠��gM�ŋ�l^��ӹ�8���%�ϊիw<H���@�5�8s&�V*��3g�#��x��)~�?��ڵ)�ŵNJn[v�Pcǥ'
u�\����aHGX&!�Y���<�z�R<�'���X'9���*�y�S?sX����51��y+~�
�!5vB����<�����[�$�v
 ���.��vt����q�ݰ�#7�>�/���"�c,��T-�[F0�)+�J͍vzX������#�y�2���\:�s�b�N2�9fY����[�b@9	MJ�049�u�7P�^Lm{Rk�U�M��3�:F���˖-��������sx�B"J�X	:��
�`��K��yքSPV���*�M�2t9[�E>�<��;P���� �K��I��� ��e����*_ȇ���:<\婗��l� ���Oq�����y�D<4����/���Ś;���@C�e0}�]���7e���h���Sb�=#t��:��1;q�A��B���f�ka�]�V������[�YMa5��3W7X(S{�{u�{�dl�~��gqF��\>r�=�Ҟxf5
N��e�򐄔
�7��q�ѨRa�Z���Ň_
<�'C�F+�c��P��^1l�i����/豫y��U��ȳ`-o�����v��J����0ܦEd��f�n@��ȾD7E[�dBC�zCT��������:�?�v&)�f�FQ��� -g?E�=,���V?�N�˄��8��}>	�~u�/N�q�G�|��3i�F$r8����&����(R63u��`�����' �$\�M����wu�	=��Rz�o��7+:�/������^GOr��u<l� �v:��F��훒�@� Ba�+~*F�
��e�⊄9g�ZxV�&t�Uk�(��S<҆"�N�U5�"��BKu:S�b@r��,( �Yg�)�c��v����m�z�a<p�Q�X�@�	����LWp�·T�z�l?��>�{0�q�G=��XDE�a��������mؕye�Q��6��>p��`,v��b�=4a���{�)&�P3L~��ܟ�7��V��0�M"?�>p����~r��-��M�����&!���#X�k[�F��h"�s$~�� 棅f%�[m�xk��y����Tr9���{WW9GP*��!���&�b�h�"�)�� ޢ9��o9��|������Fc��+<�?u�+�/k�����w���@3�5.D���\x˥��$6���1�z2��* 	�/ʪc��b�4v{�\�+�9��h��k��3�Ϫx�DE.no1&�k��u��!6��1pݠ����'�[�x[P��P�����&�F9nh�M�b	�=��U�
�3ɂ�`��i2�*�U�� ����P�y�vlN�����:���S�b��CZ�n8�=��W�v�c�[R�d��J�8#d�0GN��e��͕�����)��8>'ꁧ>���^E9��^Ap]��Rh�>��x�!73� F�5B�^a&N���b�]��8��Pɫ��+�c+�/  ��ba�Ywtn��DF���i�J����W��Z�h�jI��20�I*ֵ,M.Ԁ0;@3�*kg����Z���,U@���x��a�"��w�2`Y�%B@Q]=C'�EUveE��'��n�x�M�0vSt���`�1\���Ӿ)�+�'Vgo�K��b��	AG��` �x�-��3Tf��O�-R���_�����h%��߷�z]�&*<����`�ڪ[�2Y�Y�X�V��������Dy�Y^c��\H5i�`����~�N��滷���[2A��wUh�Ҩ�-�C0e�-fxE�>��yc>?��`�$�=,\ ~�K�=��Q����p�����y��l�}�8�σ*@��jx��)f�vN؇����c��������0?��?�W��7���&�����;�˚�	����	G��*>������ b�>G��B,2�����:�"��;�r�Q�ir���t`4�b�=^ao�XI8��R��'��-��!έ��+��zU0�3�7;�V�|�h4*���H����(��!G����(�F��ڦ�B��z�G/��+n�$�C*�hZ�����6�J��@��4G�o?�T/�V�j7˱]_+�vKVkH*Ir2��6q�����<S(�(��`skwK�4$Py9͔����5�Y)�(iD�i]ْt� m\M�RQrj���k�K���	,�R�#RK�Q޷}�(��) ���8�<��e}[�2��ܩҀ��n%�U�*YB#����T@��<Bġ�S����pZ$��JO(�{w����o(�TU8��v�a���k�O�X�(����08���~pc�Y6� �̜�|����8
M�Y�'���+q�9�x�3Sw�Y>֢Ӯfz��K'�q�[�mgZ��?�fJ�7��	����W���m�����b���y��i
~�����	�>+$�;]4:t��I�;�?>�ٕ�A��|��mLcD�4���n�T��0� ��	ٸհ�P��4�� ��M���Vpd?�3޷bN��It=�@��w_��}��˘�.Y��MU`h�.ze�B���X�e��d�����U�(gb�Ϛ�"��i7���c�
�7�5��sX*gK��(@d?�o	b�U�*JW�M.es�qbe���1Uk�nƔ*��sĚ����\?���tR�`�	�� �ȇE?7��)ȸ�=2�aAX4o��[��F���#��X2�5��Ųol\g9�_�=�0�a�+��&��k��E�[�$�E
��X�!����o}f�>��5y2>���uq��v8:A�u(n 0��Xt��`����Լ#,��D�n��iI�"|�jSamX;4J�=Q�vcL߫L�g�!��V1�̧�����R&q5��%m���R��`���;�g��f���F��ǽ#W��d\+	*�u��f�L�I}l���ޱ�v�D��ﳕ�����z?	�6��1�����~o;�	m��v]y]B�s���a��$7�F�e�>��(n(&��+KEm���3�$&�UV�<3�!+�����Gz[�/�j[f��_�/&(�N0#3�^�z5C3��E�Ax Td��5��L�	��7����}�xW+��đ��>
�Esi����l8�Q*��W`pFs���}�[�c�u�o�Q�>��b�����:�Kf����(X�7�PYA�$C�*�×��VΥ�) ������<G��)"d\�"d^H$�6'1T��I�lr�a�k����O��{j��?��O|/*�Ƥ����ds2�kP)~�N*Z�x�~��(|6H|3��q��]����	z���V�|�j6x����Boi��D�mG�y�x�cgJŷ�/�� ���I$){uh�`SL_1gZ�[�j������f{��� ���m�CO,�3,w=�$��涢�Y��a�&���k��Z^��a-�/$T�I�p��\0�R�����R.\���E���.�r�:Z��J��_�z�
��.�,Ý~v]��+�iSו�O_QR�����,�7R��A�����**��r��X��v#O}(<��`2K�U��")�<$���x�/�~��0qe|.�>�6��S�%���l�y�4��6]��"B�����Zo5���z�����[�i�-}��2k�.�o���C�N�1s0���#�1�Q�r��V��Ӫ���Ɩ�U���A3Q��YH;�g��E׵���1n��7��=�Ǐ��q����s�[agw@�T�̨6n���^�x��O5��7:ۛM���^$ۉ3�^��� ����2;�Khm��4Ia|������	v����w֭�N����΃��	�� �Zuu:6��Rj =�{��p��f�����Y+B�P�m��S��0�v���VjӀ�ۄ��E�-��k�߶��eh�~d-�W}h>|h�h^9�6vM��'x�0v@�Y���%;�&
?,�3�=�.��q6|��N�����ګU4�-[�#۞�RY�l���-b�� �HW�l�׷�8nV����,��5[�"�6���F`sQ�g"И��V9@`*E$�@���v(����p8O��wi���3S	�}�����(�P�9(�~�31�ͷF���Aa�$y��)a��qh,B�=����d	�9+��3G�`&Oh6��+rv�x;~�P;��]@��Vuo	(i�FXʭn<0Dȍªx��t���O���=���l�C��P��7��3qb�D ���K����g�~@���sO��!gt�� �0�|p�wMk򩹙�;xw���a,k�L�]�����o����2����|�ϻ`V�uW�L�{����gTn�����ؑ=��\rz���e��ڶ�gP�x(&�=�S��=	�����vu��+��r��^]��\�mf���9.��d<�:̇U{bM�����_J��W���=}�\s�.9�̭��=���T?\J���џY{~�Š)r��-w�
��nӕ�*�'�v���ã��py�|���'��x�N�c����ոEӜ���	O��%�����!v23��IuG[>.������1��N��Y�
;�(,�κt������6��t�Ψ�|֡Kl���	���ɗx;�+v�8/�i�U�y�
܂�6�˻\�ωR������{XЕt��>����Sv�«y�w�O4{��u$�����a�*`�Y����"恗s�_�Ҽ��@�<���O긕����`T؛2�$q�a[���^��):/�˃)+Y�.ev.�6:��4�W�<�_3�8'�9�B%���Wlx��e�s����h��Qd[Å$O�ï��ݕ��*'�Z������ȴ�����vSV�u���Zܸ=���P��	��m>\������l�n�m5dm�7Q������{�ʜ��M��q�+���;�&�'kڳ�8Q�2��ҋʫqn41�2TV�������k�	��4w�r'��0��n�U�+�E�)*��k�u��767$)�3�:<����3�;��;��N2~��ą���G�oC�Y&pt}���X_�}:(��؃�f}������[Cy��Ҙ��?���l�/�5;��������l�`�Y��-���Mi���8}Q�^��<u���#�Q9���fಱ����[.<��0�4ַ�+k�p���Y_{�xl:�X`^��_D:�?1*�{�c}���������ge���SҜK���Xԛ�U��("2J�s�d&��0g-�'e�p̘�E��XdZޅB���1�ʻ�h}c�Z�����CS�ȼ��Y�l.8 LL�}㱡su�*��W�;y� �����Ff-�xW=-�Y@�O�� ����L�ӈGlx?E�5�]�� �[NU��l����0K���7/c���o��A|�uE�>���[�"�?f�����*��1�V6�K# �'n'��:��+���0���Wk�	[� �A�(�����Jo�b�TfQ�i�*����_s������d8{=�*���2���.}z��&#�,,Kw��������m�A��G��?�G���o{J�f�&�����b7?�&��S�f���L5S�3�y�g�X	)v�~]�ma��Wz
��v�0<� ��}��./�gX��Jˁ�gb�r!�qh�����=P������jH�\����X�O):W�nm�+	d�w�wb�T�	�اt�F>�(�6Ke$��UJ=(�|�9��Xm"�ѧ�(�+S��B�����w�<�c�ٚpi�S ���"<��yW��1��eDՍa���H%�o.`������>�
Ϸe%c(D.}�^(��Ee�}�`��W%�u{�`��Ճ��I�d��_��W��|=��V�"��_|S�Xw[z��! "�-��Z?�cP�1�����b�㷽��o�oI�ĝ����$��{�hF��Z����T�k�ݰn�������mMX��u��2`]ۛ_w����&m`���	�U8��.�@UD ~�7nE�,6�_�''@��e�A<�`��D屷͠�m�vQ�<:خS?a�
R�c?L�hI;���I�UP^���{����,eu��tsϓ������ͺ�?�Sx���5��zP77*��6���y�w��5:��m�Y����	����V�U������$�<z��+D8�,��z��ςa+��8��<+gH4vh��:����!�̃������rU���E�?��x��'��������ƣ��T�ꔣ�X)I��!�a�#�٧E��*��/�f�*�9�tx�D���1�(m�89'�u"��'`D�����}���eJ�u�@B��׬\+6Z��Mb�&$F��0���\Ut����`v�z��S����,�E��W���*F~mj��ӎ)�(<�60������&/|�_�UX���A[�}��c�F���ZJ�ן|Q�;������M��Py��hW�pM���J󫲞㇥�׭���{d�H����Ͷդ#Ƭ��!<�a�8�Y_S�-dAPE�+�H��� �>��.tu�움����dֱih���ko�p���d�A����1��)W&wlX�����xQ!��;��$�g��W�.ӹ�U:����sf�5����Aԟǧ� KX���=��^?Ds���FB k��	�<E�S��S9�u��^':�Ǔ���e0=O������R�_��Kγ�$�j������(v��?Ya<��`�u�8V���/���d!�u�v|��������(�V�ʊW9�,��E@�H��6��\�!"�����ԫ��9���r��B^��˭U�w�0��Z\�KT���ۋ�C�k!���m�c��GKȖ�r�c2�PB�2
c����p�k֛�諤e�2����P֢h�V���y�h}�gF�γ��a��d-�[��8N�7�=��|�;�đ<�x�Ij��M&��ܑ�����?�)��8=X�.Wx@�'�=��� Ͻ��kp��t�Ntg��򣰏'��-t�W��@���Lw" �1�����lo4Χe%�d9�$W�au���l�U�X��4�����R��9f�.�aO�]QR�S_(G�k��Y �u�����e��$�^4��	�E�<�Pr�{R"U~��Ag��=�S�y��R��^�[�W^�8���#���i���?�R�!��@1�����|anXQ���1a�Q#�q��N�HjOudٜC�����/ݗI+]Xt Tw���O�H-��?�A�O��	?�䴼d`栙G�͏���l���w�����;u�ۍ8;��{��v�sZ��3�0���w�ˋ�=�dL}����0��ם��:N� Bx�u��Aa���;w�ݲ:�Lo�K�������jP�sݬ���:�(0~�y{-�\��qu���Ƭ�]�����!��RJ���ϥ!��3E�}|����>�9Q'�}T�ј��tE斺�	�"� Z�`]=4�of��uĮ���v�,����d��^@�I����?�o���йQLU^ZL+K���,�a}��T5,V���6�*�X�+��pU��+L	���zU^!R��d#W��D�6��fO��1G��_��@%9��p�;]|��B�] ȯ#�&�	K����z�7�	��d<��+�ʀg��O	�H3=x�=$li!�=۞��(Y�������c���Շ��\��À�ɛ 
�;��*颱Bo#�ƫa�5���+�"迆�.4i�����H �5m$~U�ĒJ ldv�k�Ym���5��pz2vT��9�pm�ұڄj��7W̷F�L��wmkK��mS��}�8Lc�L���v�Ύ�N�k����؆�K��q�V��'O
<aq�
�����S/O<vS���J�����<����Xl��#���$�"+ڞ�
R�E�[Z��V����d"�7x�۸��#��'�;mfx�qr�]c�}-��S��r�:@�.��ܻ�?�ơ���ؤր8&�ǧ�Q����h4�66<�w{k��m����}�kn66���F���5�Ks���xo��Lp?P��ja^`���zXW<����_��_����{G~�{����!>��W�w�~���/Ve���������z���u\��\$��������K�-�������ɻOه��c��ݭ�������l��������п�����_ox�<��ۛ��͍�͇����[0[�6��Ã��I���������iݵ\�}�_~y=Z]���7�6z](t��Y��5�����ꇯ�(��x?L����ܼ���S�Ֆ���>�.'o/�� H�@��@��ؿ8͜��N�(:y/�l'�Im�.K�\�Ҽ���2�Ï�ߡ���@�����P�<t�y� H�a�Q���I
� �;��_��Ǣ+���k�1/�Yj���l0F�qiG>D	�E]�`-�9��N� T%�ģ�$�製�u"�QH�*�̢+�7#�}h��0�c<��� k-a��f?<��Y����nf�L-���E&(C�F�0��]��;�9��5 �,Ԣ��iǋ��h-�p� ���!�G~�vy^(*[W�`zàw�1m����(S�%Py��E9M�ga���Dd%�=Z�9iʖˊw 4��vQch"��Ԡ�6��}��Q$)3#z�4w��._�Y8�j���Z��)ދ&}F#�Y���wоur��}�~�a��+��ɥ1�|�W�(R�N9
�.#r"�pCP���^Z�z����=SJb%��?���s/��Mq��K��Nǹ:�ְ��5c�0��VUg1��Aꏂ�$�DwFp�O
V���e+Z�N�~����vY"�S^��;քc�x_95$Q�$� ��U�	ۀ����)6�»"ٓl�GkelH�qH�D��Q��vr1U�E�%�KSJ�3���N�Y\�ًi �~��s{t}�[�2�N�(�/d̈���?؋S�ȥ��kKΧ�r�f��g=���4%�٥�x(��0<1�F˦~k��� )�(���b�WA�Ƶ�l��d��t��+���v{�;��0�ku4B�qY׼���h��0L��9gP��R/��bۼ��G���/cc��r��2�!oR���-,��q���U��%"���7!/�t��T�&�ai�HK[��/�����g�|�k�&͜���,�����XL'R���	 ��,�\�(�H��35�䊦��BC������8��ý ��ϊ#�/(;,;_�P6�f�2V.y�K:��R��w��n-����Ï�x.j�O��Ï�KOA	n��vEHsp7�G�
��.��.>z�q���.!Ԫ�¨�'7:k�s�2�cR��m���Q� u��E˹�����O��'��|0�d�ŗ��B���T�՛�!���64_�U��9/!p�Z������@㞲� �5�+��ɦ._�An�N�E@���Ո�A8-҆�q��L��Ǣ����_����i��1
��A�;�ӠϮ��3X/�_�c�E�u�8� �w"��l��E�j���0$��q4:�a{�'����9�FS�W��%�|��;�a����p��$����� ����Ҫ�L��\ �ܟ �<�tOHU	ؐӍ�|��2���=CX�gӸ�7|sGb�׿�C5��k���
�[�=M��ty�\`(��VlE�9�������y�%�zU-�ת�� ��}P-p�1a�	�����2�Ht@H��!*���'A���b�>��?Am6@�"��x[s�ƞ�>�����/n��c����-N9��{*���Af�T��_%�����>5��3%�+��B�9:.���n�_��Y���7���{�mVa�x����#%�H���$�����O�d��kG�6b�'<�5s��NԤ���b`�����BG�C�~�v�S��	9#J8Ěx��;��"��$ �< �A>���+�?eK�Rڛ3�+.�l
܈�x��1��+$�_�E'����
R��0sю�rg�7%�Y5؉�4�2;�A����K��3|n�@��q�(�bN�����I).Xc�Uq"�ڱg��
 �"e&�Quα"���r8�c'��Yz̬�I�hyg��,�e��>b�W��5�ӓYx�"�.�>����rݔx&%��@��liŪ��Q'�6���m]�l|Ec�o������%�@� R0��	�39�/uF1VL�40�����uQku}mū���j��t�6��mn-��
Idk���*�i�]��;��T���9K�o����qNC�|o7L`e� 9#��}�F�5YT)�K��!%�@�� ��KY����X�2������y-��<��q��O�Q b��H��TGӠ��7x]) �)���aQ�5�i��H���o�$֎U�:�3�D���:�<'+=��aL���=Y�!��|̦������Kӟۏ��I�r�c�ڣ�jݲ��s���!3,bj���8�g�{��<;��O�,_=	�1�/3�S)t���e8���:H���QA����R�Q�@_���s�|�&�w����f�>!$ͭa��ٵ�C����vz���$�Drit3&��~����P��Ft�1��V{��cIh�7�Oa�����@k��K!"�5�Wϵ1�^V���Dc	�\�0Y�V�V�0�Ox=�TJ��a� N���OŐ:��Mi���O	řg#�W�8#%?_-��0&��AlD�FA�M���'�A,a�8ӳ�	�
V{F��Ɔ���0A=�#]����Jj��I�[�5��;h��/Yݪjup��a�E9�x�K��~S��kx�����!r9�Jk�Q�}|P{�T3V�Yoh%�>;$�Ŝ����2��¤�6�Ƥr�x���g�[��Y�\&�]Ҧ��X��P淃Uy$�Y�2���SƖ���e��rzS)C��f�DczBY���b�LU.3��[�y-t��.�d�����0�U�ϵ���e]/n���v#�����&�w�誁'��{X�c�(Q{eϗgLӵ�"�V��S<�"/����	[[(��2�6��S5Af���n�s��f�W<��u�9��ʭkwsg��{̉6��_N2��6�q����e��jX)0	(�D/�̊�&���`u�8_	CQ�����z-�ϛr/��YW,�2�@�H��Dr=�CC�/�M��$*��Z��g�Ѫ�I�"�*��b�����S���JUX���Bmu~�D_M\�k@���&��4x0��m�������uO^3Y�8 �3�-k(ړ��碻���Ln�W���$�=hf-:V--���P�����;�]q7��3nj���� ���!e =S=f��8�`/�E:@2��g�B��$^>X%-�xfE�{Mۮ�t��]Sb�f	w�hS�����l���B{`�<D]'���͸�V��o����׿��*~{���/��������旕���ώp|���ȝ����k;Bb�R��#ߥ���m����.|E�x���`!4d�y�`N�ԅ�5 է�����k�{�̾�kϿ�C�?��_~�?����e|	���O��3r;\�I�yq�G��7�?p)D����ئ�'e�z�2�}��P��< �x<��"�xl���X���d�\<�Z�B4x�_���3��-�N Z[R�7-1�3[�����VV�#�F�E�"��T�Ѩ�t���9�����xc���@�}�IF� �{k����5��|�B��.�����o+Sym���DK�ǘ�U	3_K�gL.�r�[�A�7�y��̤l�t�`��9��W�vz��k+^���˺��G����ߦ�@�̭��=f�N���z��ò�_Q�t���om֘�:�t��-q�\�8\TQ�G˛���~7�9W�ۊ�](�_�qr�������:L&�h]�0<�2����Г�-��X �=�q��P>6QiY���<P-m?h�~)��������_R��7�B����t@+T�PVtc���R�++z�v.2���r�� �Pu��'^�qx�%3��]�r"m9�ʆ
oTcmz��cif�RhL�bw8̘�Q3��Ô��?�����MU}�$T�\��.tU�	��Ǯuei�1r�ݻ�h���c�ugһc�5��bՋ�)v�z �G��2���>Zc�n��;V�K��c��=%��v�:���&G�3D�\�ɯ�	zq�E�#ڙ,���|����z��k��P��&��S� �75���	���`ax�kc&Yf�U)V���H<I���y��$�x�ɮ�X��"�E�Ζ�ƝQܛ6�åj�	��VUg�x�;�E ��ؾ�xp!��4,Дm��#L	dja�S^_g�����MHo��ϵ��r�8�Wn�<��((d\(�5,EȪ-X��5�r���:z�T����/��Rϕ�
���a�D��cӓ��0�rL03PQvT�
�]m=����Vl ~@壭�]0	�����>]�MQ|'��EM��*�c����Y~���L�IT)
1�4#K͟iJ��[��!3�3�����d-�.`U'�m�sx��V�&muL��G�1�$�s�Cpou��a�(v0 𐹕�@����	^I��ڊh�ukP���s���`
wP�
���ClǑ�ԇ���o�GQa��Y���%��`Z���U���&�*�:xU�C�P�y߀'�=�jp���9�{�XѴ
�x0CږW��Xk��}���h��Nf��QI����[�n q���W{�S�=!r�����-���B�ǢHe#Όz#�#.�k���������pg8���T+_�Q��M�<r�H�d�L3�.�͎6����J������8[nJ��]tm@��l�@�*��fMW��
�Ѷh�?U%�u{&%��&nM���YdXhX��V����i��Y�/a�?��PC��vnt�1�5�,Q�w�%cOyru�zV��xJ1�	�SBC�Ë0G�Mx;��*;Y@΀EtIF�	�����qnX�;<��X�Z��vD	�����II*�5�t۵�nW�Ҩ�Қ�.}�v��a�`p�ݐ^���x��x������l�76k�f�BM��c^��9|U��ʵZ.\C�Ȗ�,�����0�3ִ��\���<�Z:;UC�(�R9"�-	֘�Ga���/"H܄'jy����ـ|�B����8}�+��C/{�"Za�M�oOW�"�|3���S� 7^�\�O��`q�R�#��Y�)]�(mű�#1C���c1���Ӿ��rɝ�5ӭB7�8h�^�=������[��Ue+x��DVl�i���.�]�S�0�GL;����}i���%^�x�����eC� �{-��S� �ŏ�hsq0�/J��^�����#�����?X��S�j������+��-�Ɗ���D�����,"����k3��5N�G��mbX�G��:��G��a�b
#�Hrc�4�02���v$���/��m��,N�d�WQ���b���QĢ�Q�I����y���� �-����gn�3�v���?-���f^0v"[{�
�b��>kWG%<�q����a��s�A�t(ܱ���ݠ��7!K+Cw��iw��.Avv/4�C��h錍b�6�n��U6�~�u�wCZє�v�X���J#~��v0Z��p�pyH�I`���yqO����F'ˎ#��)愖<#ݧ��(6�0�y���"�T���O'��)t���Ō�$�)Շ�djY-v���ɚa���	J�8���S�k��VM?�zQ�\St��7�̺ss�A��t�O!�����bl?����f袅ARc�3�:�ee\Z���P|�UڐM��⻥G}@�	a.�1wb�N��<d��q`�"]m�("Y�n����~Y��\~ �����	� ��$���>t(zS���e��K�O�������m�U���h��vU|�3�u'���hHX�b�V�i��ſ�W�缐�D��%?s�?���>r�ՅF=��p��-\�%OEK�V�T�P݁��,>��IDĢ�2ǔ�	�֏_�����}�9��������{����i }&�Ay������Yx��E�˳��{g�:G��bʿʯ�*�8���츽�{�ճ��^|�gՃ�a�f
'�~if0ť i��/�U��(�)��M�\���`?qw� (��[1;���o�ڇ�^��>?:k�u�4U�E	x���`���\�A�E�6XD~��9,}}5�����,Y��{V5��,�W4q�5!�k�sQ�ӑo�z�xH΂}������~�p�Th�rl"xQN�D�+
����wy��dߛf�u����Uرۭ�[f����i$�>�~SJ��iJȆ՛Q�3Hy����uxGj�S�"�g<��Yo|�Ѵ�<�f���ӧ �x5Z2]�FHzw��4���n�c6����$�?�e>�Il��|�)�Om����ʏ�����h�ǟ�5�6k�&��Ԓ� ���?�>o��Ons����Xo��ҝ�?v��;%�}tQ;(��0|����S-U�+-��Tˡ�| O�%�~��
R��8S�f]�3-�-?�M��x�'Q6��x�47���V�a2��b��9�X��h�ʙ�9� ���S8�����w�MSQ�Q�~��,;��ɵ+�v<�&5품�$�~ծJp�/�NS-G\���
��J�<�/�-l;��z�o���٘}bl���PGx��ΟKëO,N-���Ӽ!-�kA���҆��b]�2HX�r%�(�__&����4Kӏd��U�V���������G8
f��u��Q�����0�|XY^�"
(	VA4 ��0.4�U3��"
׺E�+*�~�2�T��a�5~N���(0����[�N��*kc �#-e����T��O'?n.3�v}=��8�^6�"���He��l���d��	@(�i�o��űw��9�#�}��j�'��p�#e�P�g�!殹�0���B�{��w��9��{�'/�X�����N���ei{�~kb�Z��2�b�.����#?�E�ki��ȑy�)��%v���8�K����Z�u�D���.�\�5��L�:U�f"���B��=��>ǥx0=?�PS������N1���k1�"3�e�����ɮޓ�I���X��0�d��5��x4O�6������)npx~��V���堧D-�F���F����80��|���]/�������&�<9�g���d۾�Q�y�S^��pd���;c:y�lj����u���T� kp���û��d'T��<����E�r�T�:@q;���n$��u��9�8����g�X�W�b�K<҈GT`\/>��)zI�GGH���lB�3k�$������D4�?2G�طeX����]����q�Ȝ^o��
I 0�G�u����P�q��z�r��qb���έ�f�����여��kg�8�:#Wl��M�����9��)��y�֎�	]�'�9�#z��x�nY�����c�X��t�͸H_��؈�,��u�2pn�*������ƫU�3��0H�y�Õ� l��'wu�LF9b��{i���`�$�4Gt��0r�A�2�:�����ND+���|ih����x�L[M�� �"�_��Q$&�|���p�E�M禧�<@������4���xZ����W�
t�Sf��J�w�_U��=c��\sG��'�\=��i�5���l��8���A���)�S��y�o>"�fFM������*�WԬ6��|ȏ|�Ҁ"qH�9��5:w,�d6rp��s�z�����պ^�%y�0���hQN�T�Bn�5�e��]���e`C��nj�ɲe�k�g��EHE�jt�6��F��g�dYU����)+{F����Bn��h���*�����9��$'δT��=B��u���2W'q��p�B��ȶ�=�fKǗ�a'I���A@��v���ů��7�K��B�bFe�C]B9$b��P�c����FRS�����S��Y�?|Gڋ$�*Xx��dɊ��4��W����y�5�$�����mR�CS�q$<�|���(��^8�k�1O[�B��VTG�v�;�x����p����0tZ����ځ�M[�<��9��ׂN7����q�Z�ʶ?J�֒�8�{t��y<;W�������GW��|\@��+5O��(H����A�t�=��V��y�������pe v]x�@�?���f�PϨ0��6Q�@١�U�Gu���v����A�9=��f�
�HJ�u��/��:d�<��g��맪{��Z��u��A{lq(�8YB�m��>�0l�_̬�cI��ᕀ{��GA?��JZ8����F�\ �u�\/\u1�+��a�;Ք{n$�EN*�S����~�@�w��\#c'9�U��Oa]�2
�rB�ŀ��Y��@�Z�Ѥ�D����ol���(����NIZAt�,��R2+���TZü%���r4��x���z��+^�a!]�t@`�����	��<��>�?�э��I��m������X8��Y�_	*6���>��'�D�D;��^:=F�q��@TXP,ċc^Δ�>!Rh��f�@���^��lV�/�:���2h����Fl�D��ۣ��R�l�1j\�]�3A���r���ѼO&y���V/�L�~�e��u�x��u�P%�7���o���u�C?��l��Bܬ�`_�Yz�e�8�O�b����}��a���"(�k��}�?Bt*}/
/����k�Ǿ��6o-�V�g�:l?�C������h4[����I�6������57��f��������=����� 3T����Z����`0��O��_����~~�ޑ��^t�o�R�g��
������/���Ūl����X���_[ ?S������� OE��uy�g?��/�X�o��ǿ��N�}�>|��7,���s�?�yc�Ã��{������O|��=�F�K>nno�o77�7��nnll��/mn{�;���W{�P�Һk�>n���=���z�����o,m<��P��7�
iK|�=?�_�P��[�k��5[�7w��c|�V{��� �SmAK`�fI죍�	& �(l�Oj`���9y������nLN��/x�=T�l�|��4�e�Y1�y��&Z0F��;��������t[7�������q{Fvu*���������t�� �ng�ͻ��`j������� S�����X�g�8��F�2��K�6�{��IV06����S�h�jj�j"NI��c�ed��bv>����sUNt��i�����B�
��D�^���$�X"��d|�v^:����C�6Z�A��W����sLhYD")�l~A�I�)�br/����B�AQ����+&�k��dc8 {x��Y����\�d�n��s��F&�R/E�� _�Z�� ��p�
�lG�F��a
;�y��(`�Z�Fe����p��b����H���z��s�tV;���������
^!��
�Ǡ'`G�:�ah��:	���4I�K���}������1HQTD����rw�"�(������Eu���S-�NB��"�P>��[����''��Ц"I����G*Ԕ��H~�(0qO�
��"��I੢)���n�u@ ���Stߠ�F��P��Il�	{���(�	�!�zT$c���qŊ$������KX�w��A4�m�ɵʕ*��Ūy��ai�q���^R�2�7sZ� �M�p2*��&�w���\E��Kۜ�;cT�&~o��{�������6r���^� ��Kqj���2�ga0nErK�oG_DH��u�(t0�gbڗ0�a�
�a� 	��u�w%B����a�aFg��a�28�(�PbZ"�)(C����oy���}�C���y�	φ>��H�L),U���m�
*�?���R����X�N�z:��� �����/a4�U��0��8�����dpX�x� S��bdVEχ��!͙�w����D�E��0��SeϒGj��d��"�H;a�d�)2s�+H䋵&�k �#`Ո9��`�**EL���@�*7�A;��tIg�*�I���� VӪ���ɵ�O�HV˚�:8ǹ4�0�!�m3=6��u�@s2�~m?Շ/�*�BZ�����D/
�SB� �Z�懩�r�[9T���4 y��'ٰ��S��	��J��~Γ�r���?cr��ȅ��3��}�m����(�.��E�)?��ڇ��`��_y�i`�{�N�)��ꡟ^�X1D�t�u���`��2]"z��jkyTj�D[d-`�k@�B�ط.�rФ��?�����~R��)�"2?�]�,��f�\���5b��;P�� ��X��f-9Q*�"��㰏�#�`���uM��ؑR���-������Y�W�D�LN��^��,Q�*�o�x~l0�	5'�A{5Q|�15�N�_��I��2'�Bf�����7�1-p��"���k�nt��-���཮0�
�O(�%����8��ftŝs��/�_�!3}J4�Y��M6`�q��T��B�"��ްZ���x�H^��qnb0�������2'�gQrN!Ef]�-���&7�kx=m����0�]y،�p��it����!�;%NB(UgƎ�=7�i��ɳ����?�#�U(V=��6
�>j��/� (�O�V��RU�٪^�Mg���B:�j5G��1b�.��q5f3x�߰������D���˜YhBZ�b?�b����QL�3�8i�9�9}�1�L$���ӓ((�������gt�8�*����#k�(*����� g1���E��g,ڒ=v�=�`����>2���d�R��Y]D7��`�z�qū�g#(��Y]��Pk_P�Y\I���4���$7Mǰ��Z� `.P��ֺ�A�

$��UU����T�NY��7�r��ei�dC��Ɓ�F�M2r+�<Ѐ������x��eb��.�\e���K׷P�mv�̚�d��� ��*W��`�k�����iA�Z�Dn����#��h	��K{P��g�̒�]A��@�Z���ϸ�������
z�\�ۘk`��Ϥ�o4,1���3T����G`(��)R&G~�T]���(E:���BIF!���<�Zc��Z�G,��r){�(4N����Ok�DݵA7Jk�M��8�t�:��97w6;/�KS�أ��x����&
��a#}��P�������З�	�Ԇ�f�,~�h�
�������^@����^�����m�������g9�ɗ�	(rzK�u�d��TC&��ar~����p�Kǋ�bqƞ(X:�T"#�~����m��,���-�jsBP��SL�5���37Jy�j$���<�&��e��

�.S�LI��?\ax���0Ch*�Χ2�ʚ�@��t�cű�߀������ن�1�����	C^S�
��q�h��,���(@��:��Y���vpt�)��w=��a����Z�Ħ�{ȹz���h��{y4��2a��{��$���M
�8�)<hA�v���r/I�r�g4��#w1!a���9�	q�]��.V��XW� *�h���W��;��_�9�F}ԅE_5vO���D�\Tx�}I�F�6��H�c�=a��$����\L��8'�����s���"<��N����G��#so���8� Fa���9�Pθ?����BBM%>�,P��8%dC�I�ܿ]ńi_@G��{��Ӯe$3�{s��ɫ��H`Ik@�`t�~2y8�Nt��y�3Vp̉��YyRHd�2s��
�nA�0cy)��D��!��r�צ�9+��4����
��n�(l��D'�{�t�FiJu�9�W��K�u��l���v�kv�9~��������r+�m�T�H�#�g9RS0�X ��J�>�s���������E���onml��}��]��O�S��>�����l�����w����p�o7ֶ��7����?f�����������Ɩ-�76��?ʧ���6(�`@AZ^0�T�ya�P{�a�>\���\+���rg�r��>�<˨��dR�.*3X8�E�86�Fo\��p#�<��C���8�*$���z^
cC)�L1n |��p��n@}�eԸF�%CT��yS���y  �GfS���h@FS��z �0т�-+�7�(���r��H&I-�^S*f
�%/�q�U�"ܞ6����~8�`���yY�;��B�T�솯�_������˱�};�Y��Q�E�u�c�8EH��L�H/^�g�e���r���"�~�Q+���rA)�\V����b<�P�\�����:��.�L-�����*y��Z�M�݋|��!y~�#�v5�H--�eJNFc�R)m�<��:ad�b5t<���|y Cޙ3��ۂ0r�'|76%��*Tρ�����?�x�~t�y3�П&�=F3�D�l;I��,�z�\S�e0=O���m���X0�]��䮤��.����̩��� yAM4`�=�	�?�	Z�[�;���X�VZj]_�#߱��������2��b�;����8B3��5�^&op~[1YD ,��(�B�+��/ș,BΆ�&ڡP3 ��!N�����"��f-y��KC͗"^̈́mi����0��
����msm�����Xmnb4 �dU�%b�\V�����Cw�9�q� �7<�ȫF��U�*���ûv�jR�n����S��%�G��0�*�&�*�`�y�f�LU;�>-�PIO�8�IC�:�dȁ�*��k�e.�)�FBЗ�ZW�ݖ8����vi
�x}P�ۄ�#�×��h�	�²�[fۀ]ܻ���+}�������B���G�E6�b�9���7P��q���S.!ig�*$<�jLug�!O:� �0�*T	ep���U���
,K��>�<0�(B�[aqVWP�(���Ay�4�Gaߺ��e���"�X�r�-A<bL�+\ѹ����㷣�Qһl�C��od��2>�mz�jUev2!��VM*{�j�
X�[�e��U�ܻG�}ݸ5w�G�(��Y�y<��`�n!�e)�-��N��,��(���z�&ԆQ��Ǿ��Z�1�w����K\XR��:^ю�� �V�R��;ҍ�{��gj&�Tì�rT�����;NXE+���ǝ��D�Lk�1Sf�И/<b��`�+�*Gg��&6R��ή��\Ce^�c7S���Ƃ��k
�Ԗ1(�j�{�*�
.�b�29��0�=�W&2���
�Dñ珱�R/d�+!wu�ʖ0ǌ)
�����)������2\�&��`tː����b=V�@����G`����7Lp��=��d�#�':��S�<��.����b���19�eF�a_�8o��p���S$�v´�R	:p�Y��\"\�"�͗-�2�P�	"���{��8�$Al��d2��O���F��*|��.6�A��4@` �{{�V1Q���fUeMeIf{����{�N�ڭ�N�ٚ�rvoҫ~���^���U6�M�lg�Ȍ���p������A�|Ӭo<�/��O�J����VP�ի3��4v��޾�D(��d��e��n���?J�Qܱ����2�&����9�:�z�w5��vB]7���mV��IR�$t���9�)į�F)�&V�3�[���3%�e�%Q'�j��`3Y+4J�Na'�I$j�v/M�%(޶=~����n��Gs�w9�~�����w2=RR�š�c��>��JS���7� �5���mj��K�p����h:��A�1K�����܏>]�V���,1�KBD@�� -�BGV"�ux�rUlE?�������W��]΢}��k`�w�u����#�;�O���0J^y3�;���S+K����)#�c%S�rfީEU��3��z�<��K>����؄'Ǡ��t��Ӥ������cX74O"�}A��k��#���/��W]�;r��ġ���er_a�����.T��/��P��J�SZk���g5_�U��o9��]�Kd��T��AWV'��ZK \nN�;�Z3�������Yܥ� ��SҀ2%�AZ@r�����ɽ�M&	xF;�%��K)�]��!�3S��kEP�S?��=��}�ꞩfv)�JyY��_����ѥ�M������M��4s��V�'Ɓ���0��%��e���ɴ�����4����� t41��4��=�A���6ʭ6L������P�1���e�y�'y�7����}i����G SP"�]��0��ac�&�����c%�v�p���a�;�n/�y�.�t��������"�+��bi��U`��Q��^�NNL�� ����߮`�zi�־/�ݍ]��=H��`Y^�ч,V��#{0��9=��BMl��p=r�I�sF�$�#�j��0�O��e x��x)���A�1���f�-I�(�z�PX4�Fbx
Uhq0%�ѮW���Q��( ��y������Z��0WyP�������w�IsH�Rw�U�],�9��@�A��_�>ڳ�H����B�a</ i"@�>$�(Y-v�נhE_E�`>�ԕ����$t�unW�g<�
�����Pƶ�S�Sp*(} �,PB�xp���(�_�C��i�{��4oEkj_s��H�$S��dv��V�d�Aap.�,5����p2��/���d\n�k���I���@D:	�ZJ��ӓx�`2�9����˭�Ou!:�7��V�h�_I�"���F�x��$~�j����[KzT�GH����B1&�w}��ıJW�*��2�����@��q��M�d��{ �Ԙ�V����X�kkk����P�T)�|lW�HC �@�cuǀ�ER_W_U����Ɠg	���3|PR��4=�I'�A&LW�x�u!���7i�y6MB2�?���"�pp!�A2:/�+�f�i��\����;���L�#�7,�%%��3��������(5��	o����{�ՎJ]Cky%:��r�j����?M���,����7Qb�b+�X{�A��~�G�P�9Kt�.'X�.��ȧ���P���9;��p��P>�kʹ�98��F��E�À�@pJ�����S��`��f-=
��uu!�Rkt?^�M)�)H���r;W��F�p�=�5��7�C�L1�՞+�����J���B� �9Wt[\����j(��M	!@�ɈN�i�@4@���$�(�+ڋ|�Ɯ`s(C��1~f8��qk�v�n3Is�J��^��f^2B��D�]i���|8�������lƎvE��|#�	��fG�Icʎ0�)��pҾ@��IY|��]��n����u ��8��2і�-8]�k���E��H���B]�Au����)�?�C/,Hq�_�=G��eal?��$�q7.|���cܳj��:|pG\Ҭ�%z�>�~{N�[�B5��P�'���nrBuwLMWǓ�^�B;O%�D��(��\��������/�B��v�}k�7��z��"�$࿕h�dUb�}�5pa`���b�3����UxL�g���*�afM����1�S 58/��Y��"��f��dWS��g�-�f��!/#춮q-?��#�9�K����C����*���`�g�,t�+N���o��J�H�P��x-$��y��z�_J�"��5��aDPX�x����^+��Ғ䶫�s񳭈l�KR�F��X	����x2���K�soۀ����G~�ep�=R�Oݍ,���p�Q;���qvw� 
�W�d�ԕ��M���h"��56�J�����A�ǲ�:����N�"�;@՝S�p�X�hi�yb���X��@k����0��gEd��ɶn�#w����2��TJ�dQ��62-��;��t6k	̢aic��(�vݺ��
-���D'�sS�h:"	J}��i�K����d�P�z�OGr��I���E�O'����'~Z$?�D}b���,���_iP�@W'.�z �ب��01��FJ�X�*��#���
��Y�7����V�˙_TL�ӇD����sc�M�L���|��,[�cPSD����p�,*����A=�v����Jdc%p���L�[p��@e V#��:,k���<�K��z��<� %���(�/�`2��F�z��3j!~�:�+fK$R�+����ù��)��4����Ƀ�7�w�DB�O	�,����O�u���:����\�R點�i�@Z�4���n;ֶ�I�f��R��/�Nۨ�oധ&��lg��lܿ��]��J�;1�?���l���D��+�U��h:<S�ªE_"n�֟�"C^�M�H�&T@�='i�vY�#�$�%�C2��f`�g�|�#�H�&c��6I�J�1��Y�>!h_>�'C�Z+):�sȘ�0Kֵ�Gn-��]�)>�f�A.�5�^���9��ټ�j:I���*�ӑ�pZ4�^O=*�B(�s���`B7B0�AͰh<�(r��'������J'+���$�����U��j�ǁ�p)��~b��ZΝ�U� ^g}���(S��gS��"���E�
w��1oL�5���� 	(\��*��X�ait�9x0&�:5�+C�tJ!�'�6�c�<nn5��9䢳Xy6E�*���)&u���=�A]�,�&i.PBx4��HFm�fd������4Jn:;��5~j@VF�kd�L��'��(`���x`l��)�߱�Gɼ}q�A)$;�C4��ͪ����T'Ll]�R�Sn������@�PG퀡;(F8�Q#�&p�tq��ߗ0-��ba�O�\���(����\/��~Fo!�D݅�B�>��3
�r����V�w�e<�!�#6:F�GT�+�!S��:V�&1���`Ld�EC<��9^�;%�t%X�J	�� �yoX�(&T[����|������B�yx[�z֠�P��k7)�� �3�o�\#�Q�:��)7�HFF��ޘG�\E\��� �`$��H�����p/5�q�A?~K	�3V�eQ�H��]�N'x�CKP�G}S��6���Ԉ�Z��B����n S��c#�E���5��Y�'�]kڼ��a�Wo�J�55(0�2|}���Ű*Rg�990�??������]=�筍�͏��>��c�ϟ��*���W����ڭ���!~���[7o}��͏�?��n���q�ϡ���͛7�������a~����vӼ4��%��hcX8�A����~�&]!u�q���\7�0�T;S���iEg�*��<	d�T��'^��#�TO�
�@���NNUbPT7�J�f���yB-DJ� �І�K\ hi>�8���ҁ�I��V]�c�,�԰T�)��
W��D��ϑ,��#�ǟ��V��	CI�L�:����mFEl���ɏ��3�\��7��A)�v��đQ�;�f��g���D��[K��CQ������ٿ��yMg �!5f#�����ƙ��+Qg�}��O�m�Nm��K��M�TSqv����{J���(ݸ�b{���t�6H&^�Oc���ɮ�8�4a ������J���4�S�	ؙB{�hB���ڑ�G�Y��۸��ܸen� T㜟l�hhMc�9t٥=zpt����9���fM c���	��ԊG���8#N��O�s7�*O	��&/	�5ŉ:FW��ie��o��員2h���1�͹c؂Nx���� ��Ծ��%E4W���M��EU6��F���MH����b���"Ү;P���Z��UIBC���\�v�R�P�,45��i^ )ş�� �¥�^T*$���E��ʧ8����!u 7�V��)Z��`����K]Q�(�B����%/
B�N5��s��.��*&Nl�9��1|RDu��;�ayd1����N���V�4���3���S#RT7��T��L��d2�T#��q6��X
/���a�1�<Nv�q��^ve�$��0�<w[pX9�:� fu�<��F����́��Y���U~;ʆj�6�4u;!GlVDm�\��<Ǚ>~b��I"���)��'\�#��c��] ����SP�'iK��FR��㰼rW��jXH]�e�����G�޵UQtǽ�Sզ�FF���c,Uü�jN��f\���5�w4�`�Q�v�t[7>H_�c��C��y�\(�]oF;�O��Y��^i�q(p�$]��`_���U#�x_C�q�YQ�:8.$�<�W�7JM�:y\s��.}��4���ԡ���.�ݽ��ũ@���v\���p���?��۔�����'�&�3՗�F�� �͘J���{����pXJ����vF��5�qP@\#��Ԭ�/������Q���{�s3O
��N6�b»��֭��y9�@LT#���FU��I7h mH��w�O��{y��dw�}z����A�ĕ�i�O�I/����8Y11C"zf�B��|���t����N�>�m����/�@K	�K'�e�t�Xnx��u�ɝh4,6F&MV��i��4��t'S"~�����.��༓|L��G��'�t�P�� !���U+[�g��F�#6�8�Јq���x��P����Igq�qBk�s�YWv��?`H�e\���cTf<�'��g[��t?�����l�S\�}Qsֳ`(A!X�b*y� ;'�$�TF�<a��]ܺ���3lV6��Ť=v�S�L���o?�"1�����9H�x��?���U�b�������ko�D�#oA}��M}1��
>p-c�!���� �@�Ȗ
��=~���������P�e�K��4��*�I6A�ִ��E�`��B!�j���.�Q�����D '�:�w�YG��h6��|�e��I$7��[�*�f2 ���va0�e��{���bhac�:<��e(`K.��?J/l����0	�%F1��l��R�`vނ[��+��.c�0Д�tb�H��-.��H��������S�\9۟`�Bs�Қ�M�I>�,ʾ�	|� ���T��e���X+M���1Ԋ�@*k���Ka�ЙA�O1j� %�@Ц�)�bM�N�O]��Ӭ����B��&��r��A��g��B��2<��fS�)��L���
NγHE�V�}��"�_&�)�����q���X+>�����ԭ�|i���d�nåG5b,���|�BBh�lcm�^:ͷ�c���4��Ƿ܃��K	E��U��a��H�_�JH�M6�8�Ϧʛ\q��w����6>��Ni�w�Q��w�r�3�`�j���n5�� ��S�\�U�B�L<�X���`H �m�`3G�M�1_�H�d�:	ig~�V��
��'���4˗"��1�-�қ%!� J�Ǻ�xo�nM�4��Z�BW+��*O��fo�	�鲂�hәN&F�
?ޗ�E��.ݱ�%Z��xyfA�MмR�:�A�,
p����d ����������=�]�B��	�t<�T�҅8��j���Ub�����C���5K�5�FP	c�s�w3�6+���L:!�@�Er!�j����,2F��y��^��!u@�}O���$C�B�p}\V��.va��.v�M��������!2�{� �_��.0r�0Ƨ��Yċ��z{M+b��^w�]G1��x*�=�=p�����XΉV1K�AQ��u�I  ���jL��g�����<K�����3�E�'6H8��HK�{[rp�z��d�R?��>E�����Ӽ��W�-+�r7{U�3H�	��4��4#����ԒA��C%�`[;����h��Κ��X���w@$)��^��Κ/�P0$�mK�-�N��/���[��
��-�q'HdQ+(:T}fp�+ٰ��\������ o/m��|�m_z��*�)��f��Bmn�d��ئ��΅Su?��|�L^��Q^���C*��"~��u(�3�T+0���|���>Yz��ō߭5�l%��!
��ݒ"á)�ݮy��׶=L�m�8S�C�eٻ��N��<j�׮7����N+s���iⳲ��l�yM�h����)�S(�	�շ�bN�b�޵.��L��,��U��W��W��ɺ��U);��m�Œ��q���t8`E�V�n��G��2 �@)�ӛ�2�-)�;V����9 <����������jђ�~��c�%��R].�T� ��^�:�K>I�]����3[\-�hcQ��]z�S֯�+��yƾ�rj�3�6�۟��E?͛R`�f��y�������9��e�ǵ��׵,�l)���$56���u��Ǆ\����u��VX�A��vW�}��8�.��%����h�+��*'.�c)�e\��Ζ��W$��R+�Z�:��Ұ�~=�Q72��Zvar#�A�o1A�V���Z�&絬SŔ�x���K�w�͌�О���
�3��2;S�"C�L,W8o*A����ޡ(H���P�x,�VR�O�9�-3���C�����'葉S��w,��
�:-���D�/G��1�ڶ_'���ux�v��3(�%@mz*��i�"UxV�~W��� �y.�e�4�p��"ܻBe�c��.�(���p�,�^��g��n�D꾞^h��B�6K��=��`����+l��K��Vu�U5�����SO�d	35~T91�4�����9ޒ.i߳^?�k��#�K;#�dz/쑸��A�J��+�,������u��jhvg\�}�5�wM��pS�wub�`�>�CQ8(�r�#�D�;Q�)��(}H�C�ǃ���H��X��V�L����r1.�� qz��x.��$�+~�!ذk���m�c�B�+������H�=��O�j�'@�U΂�W��U�x
�]?�0�W@�	��2��*����\׻r�#��ۺ�-��U~}�py������vUFC6�S�sz~j������u�����˶(���r�9O��u��y-���yµ���.��-��D������r�3�b��u@2�`.�I�$�]j��{�.;F��y5/����/κ�����*�8���s�<8����j�����,�����ֱO�"e����N��pY^��~7e3�?�4'����ҕ"�6��f� i������b���q�&��Ю`ң�b;��������܅_X�R�,�~��W��Z�y̓�� s>!�.�J\��r {�Sa�g�<�u��H�@������U���U��e?����*l�gTq��ԅ|�f��yغ��Y�\��~�D��/ܶ�V\O���y�e���m�����RsT$��JV��q�"��,'.lqG.�s�q�r��KY�\���a�M�d%g.�r�{r����0�is��pU���'�w�B�䅸�o! �g��u^�˕�&�qP��|T��1��f�Q��y]t�"]`��Wr���Z����ϕ���m��|`w��q|�4Ȥ_OKxd#>��v�����><�M�����D���ε��ᵕH���5y��P��HJ��S5�ۢ�p�)u�o�y.A�?{#܀���sZ�,ן�E��'�c�E|<=�>}��3N+�׎WJU�2C|SwR�&K����竣xC]�E����W�%����������n�e��y�:��;8���
�+�ܖ��:N�n��&5���ռL��E����Di:�W�p�jR�h�U&H��ZfI�հ*Uڬ>�|iW�D-���Mz]T�l���9yr/j�Xbxğ�rޘ�98?�9=�BE"0�ns�R���
��xԊzp�*��t�^T�3��Ӫo(�� � �),��>*�,�Qݏ9����+]^
8V@�A�5��S!/2w�GY^�jw����W�v��X
�~��Pe<>x@c�VhѨ�7�%/��	��"T٬�w&�d��/�{�w��Z�w�(Z�_�ߥN6��.;A��X�2�]׺���pڦF'���e	�o�)=��f������y�P��+|Dc�R�1M��h�7��ј���`���p3�#E<8Q�5�����D�P�o���!��Pw���͛���P_�d]dًh���'/��(����z�c\�����$;���LN��Y�E�+d�RX��§O��ʴG�����\ϧ
��X�XI���`��*�	����ѯ�_�-��P8��mB����v�z^u5�)k�֗W�:0���Ϯ���6�	7�@��y��+�^�2��)�����ٓ��nx��R5�q�s��WQ��+�iDjw�*�Ti����_iK���
{ҭK����<<[��"�-��$����PM|AL-�ʹ���X ���EG�OO�0V�S�N�_y�?.�1d枤�$o���|9��u��ȉ����q� ���6�ujVcv��/��۔��xl�,/�/Heecw#;�A%&��rA�[��n	 `|p�e��zmfch֦�3g���SW�,�5�sʩ[����zU���6����P	C�
�R]xW�o����l�
u�w��7�[I�M<ɹ�����.nfd���	�z�|��%Ϩ2{��O�8O�BZ�������������I�������B�qr�r���W������w�����*(���m6�?�^�4�LՔ��nYr��<��n`m�^�qd����+�,��"YDj"j���,��ކF���|�𢌽��]?���=]����)�F�z� O��bŤR���O��U6t�����#�܉�1��ֶxQ9L�tż��I@�I&5�<Յ��6�-,�Bk�D%��$|�)@c���4+z�I.�YJk�~��ْHD�G��}Pׅ��{7��C��D�T�Z�4���7l���i�'0�T#�H����	s(e����+��Y�7����\
�g%��A�%Ef��E�\���x�NՒQ���ʐ�v�h��*�gb�1;�1I�wA=�t� 2I�DO'i4�ރ4�ߵ�J\CS�B>�9�";�˩��+�+v�r�|3��y��&���+�)�@�dPq�.����o�Lρ���H���WDS�++����ž�����dqJAVǇ�߽���k~}ASɵ�x������f�(�J7
��+�B9�>}B�+%�@u��	��q9��n�儾۸�ă�_����K4�?�Cq;yXSZs��qY����Y��ߜ臚0����X�&E�ܕb�c���k-��6Ƶq�x8/�d}���Ǿ��Q[���d���g菤�H[-]��ɜZ(2�<[��iQ�+���s:��Ԥ��"�9��w4~u�T~O�gݨ��H�@.@���6��i��)�����),
������/���"Z�%�<c��,ޮRf6u�0�]J����B�4��۠�ԩɄ2(��B�A({h��)CK4AH-�g�qR�0��I	e�g�립^2�j���I,��ߞг�QDB=�֬,1�P���Jvu��P��j`.Lm��N�F\Z��&ɹ��N��q�%�0]�{��7K�02i�k �@�E
K��f��K.�"�PB��T/�+m��"L�d�����H�� ����>�U[Đ�4:�dk���6��i��0z�B)�`J"nH�u�?�`N�F.T��'erb
Gr�!�cu�u�5>��׃��n("W�m=�d�Ť,YX�T쉭�l+%[$��9���HDþӺ n��+r�b?}סV�����&����dӑ���K�ʼ�b>ov�������S�X�p2�..��K���	߇���;����| ~�`�})h����'���M� ��1$��N�uś�[IYZJQ��ӥ,_�is��q^(6V�"�my�kE����X[s-�Ǉ�l���P�[�f�#�98؜$��e�Ɨx8��X�xD�� 	ǔ�c��Qu�
$�)��^-Կ[�;����h0��e�����&��eйؘ�/��ս�u����	#�M�9�&�:V�)���N�7䎬nK�=��Ժd޶����^Ì��n�E.vL;P���tYH3K3���w2�g@c��xg9�;̥�����S%_��I���I\�l߇���8H��9\��բ��x�Ƴ+�� o/��gm���
�15l̂�;u|���3W̜Ч�P�QY���{���`%����K+�#��HH�����=��H�@bOy��6X����b�f�����wc��P���Vo�{������j�*��Ws¸!,5�T�1��[}�+�Ruߘ��^گ��*��z��p��+�X	�rC�p���ܲp����-��.D�U�ݦ��������p�v���n���ݶ�q�U��p�|���B%��sn�ȓ+bM(j���Q��oUy���xug�h;ڱ��崱z���m���M*3��U��i�^M+�>���ÚFG��d#��0Д1')l�iND�t����'�,z��?Nq��}�M%�f��"���g�g� �?�ۦq%����P8�oCl
~�MXic�F����|�9\C1��r�/�g�&!I��X	O�T�*\��X_4�i��P�!����F�N�PH��k<�Q���Q�oN�����4�L4ˉ�'i����aڿ���A
�gp�~�y���*� �j�x9a�=����HYk�C�ҧE��I�G��b�i5�FZ�HҨ`o��TH�6]KiB�圀9����ԙd9X\f^��L���+S�m��S(ij�p�E�ӑؐ
�?��x�f`��fN3'�g�<f����j�_��X�W�,4��T�p���eƱ ���䳻��B6N�Pe<�re<,���S��DW�sR%A�(j�>@�� �Fb���@�� �����Tz�+���R�c��4�]X�bo���`!FJ�̽�8�
�&�:j�0f8$YdJ�MG9�Z.M��&_�'��X4z�&��̙k�FV�4Tr�����q?�?�h3���K�]z�oK��d
�)�ū��,$ �۰����[���x���&]؋���}���ne:[���f>=�� ����V�B�����]����r9wX�$❵�whF�H�(��w�s�[��W<�͇�#���&">�ԥGԮ��D�E�MP{�]�ٿ?)7t�Z9����/js*PQ��n0�C`�'����׎�V0�)��t��P�����5�R�Т�o�%G�q7_��֬��*��v?/_��;��W�Ƹ�c.��t���^�V�ﱳ��ˑ�']��NM�70��N.�E�^��3�Fdy�E��[���K�!�� ����)�0�9UM먩apV� ��@3ʤB��Ҳf#]�>�\*o"�[�1�ND�!0��Б���cuV)mE�]�����G����M����ZҊ�g��?�O�"�lҊN�����g���x�f�^Z�u�M���8���5;�l<��˲��~��^��g�a3��2�����7��Oo�\q�����[��r���_8�6m������Y������l�,1�~�*�;u8���A��}�l�2O�h�3�%���h�������A�����H�A��̊�)�D@�z?I��
*'��wa�;��N�A�N?Т�ے%K��L�gNC(���D�L@n.�	f]��&	��C/?�ހ��_�5o�G;��Q��r0�\�>� �bc0p AV�ƕ`�i��A�6O��l:��7QP#���,��S-�Jv�(��رOޚ�������̣f>�)jdp�*Lb��$���{Z��Yx�D��7=�{���?��eD���������&�e ��]��1O"�9�EI���w(=����D�Ì�Ι�X6s�������Ҳ�4T�_ܽ �	/�\��r�0S���yVl��2�~\@�ݗ��U�a2�rx��P�I����7��X2^�U�܅×�:'i��dyN��f����`�B�������S����/u�A���zYG��l��/��O1�Q��6�����&�#n���kkk7��"�ﭛ7�k���{fl��Z_[_������\�E���&0�7[���K��y#-�کf�ތqh)����_~�������q':<��R�<��������[�?��]l����c�'�����c��?�������� i�00���?�����V���������"?��~L�G��Ǌw&���������K�k�n��E��],p��gN��k�Tw�o�ؼ��u�Ɨ��/o|��孭/j7nE�{���w�}��|Ť"�;ۿ����~�j���ۿڪm}��N����$h��ǆ������O�y��y���-��_�x��_�ѨM2�w�h�@�@��/��$�������q��U���nC	�pa-��m0�n�(_㕶Hs����qA�v
dsO��a�l�-��	�JH�W�㉞��D�@ �沚��N���+&;��2�9��'�a܁60H�MI��,�?;-E���U {�E���͚�rª9$yK}�H�0�#���h�i�"��J�/�k�k6�YG�g�cX���0�6^��x�#�6���Su��0���u@1H��|�2��y	mk�28c�_Hz�nE?�n�9�o|�Y���5,�W>	�2��
�ҷ��b��{��$=�����j��,���t:�i��F��z3�~��)��G]?�����y��K4�/0�,BH<ut�� �BH�h��,�Q��@ �5`����GȘ
l��.��,O1{3�@�ZbLť;�0= 8CE	c��F�ת!a�`�3�h��V��(��y[zf|��:����W����/w�%�	&�d5�vJ��&*tе���g���4�DO�V�����}���i��>��R�¿��`�p�fe�c4��V�E6BUQj#�+�Jn��>0�_�� ;?���T��1�R�����Q)ߦ�B��ؔPRк�`���G��v�O�%����Y�/�"�6�j�(��L�P'h���^��ɗ����fS���"m������t����+����L��~�F��Vɽ=��O����B���!N�����L빳�M��	9�)*��pT_C7N��y�t�1o��#M��� 8>G2���g�Pbw�rS���F�M�Km�8	t���\0VƨV���i��G� W�R5����2��Z����c�Y�S�QϘ2I.x>����q}�l �m=c��P#Ǔ.f�9���=�|κx���?��?�_���4���.�I�C�\1�O2"����\���7�i?���e����`�Ē����`���C�r�쳟��`�?�d�1`F֋r�A�%\9&4���o�m�=���W	�@u�j�
�R��������xڔ�j!�,F�"g����{�d���Ĝ`��l������?�����EU�ꫫ��i�7�A6j�}�4`�V�'˳���Z1�.б莧`�O���0&6��P�((*������ê;��=�>�����u�q������������L1�#�,�0��s���-�%dQ��?ꦍ���W�
�}��w?Ω�A�:y-�=?�Xf�m���7�Ám,��tq;���y^N�,�rh�tt!��:�
1�C���+�q1w��Ť�Ԗ;5��+�	��r��Hp$K]�Kv�j���a�I�Z���c콤�al�� 
v���4���e|�� ��9�(���Mŷ������b����|�Zt����Wn�"ؓ�M��?�߼����HF�ƲKEC�k�"HBx�f��;��m���@���f&]�9]zM�x�{>E��=Y��ȃ����K��x�v�qVM�٨��/����x|%r���4g`hO�fv�� t�R��_;�$2�Q�X�diIw����ψ�YwY3�=lO߻K�������{w�˶͂� �;��:��+��+�/�)�C�Čd����˫�}W�'�N8��̕�&��Є�}�J{���t����5Ǘ+:Y�
%�P���dT���n(���2�ܠ��h�H�hW�O�C��6Z2�gjO��r ��-F���W���U���9���X��� _�]�T��O��}%Q�XIz��S���w_N.�Mz�Aէ	������jGN�+<���iE�G���-
sn�0� 1:�����yR���Ȟu[ø�v�Is_�3F�="�U�;s��X�/J3ڥ����o��K���TS�j����5�2�=��E�0�������7yՑO�g��+��?��V�5�ѥXM�l���18�ΨQ�뒕��M7���:���Ȩ��̋Z5��#y߲&����HH=��o�
��*h�İN�O�����|p)��t[FL��S�` ��(��?S7NgZz���O���
1W� �1�v�D�e���֙+����|cG�StE�!�!t����wH����|�
g�+�����jLl��p�EQj\S���awQ�g�	
f&1"� ��R��[�a�Z�x��I�`���[��k�(�� c��,��G�j�*����ĵ����z �CH�fnr: d�J:����j^�d}���1���m��%�H�ט�٫�?w�"�Ɉڛ�5�/Z��A�4��^���2������4��		3�,��ɋn�j�/Xhv��f�����Z��s2�a.j��Y����$� ZT�ԊT�ZF�~%��z��5 %��G�*�R1C�7��X%���np��﵅��?�[��
1.W�Ns~A��@y#s�e�r,V�@@j||��5��]��2�g�	4�tF.$PE���B���7��	X���vI��I+M�[��X
d��/�W\� ��܊�%�	A}�l'!i�!~�Ơ�b��T tPs��'j��Da8�ǩV*F:���j��Hm�h<���H��	mO��`6C�e;QG�L��Dw%<z� �N;\iC�N2�'i��/šL�}�� �V)6ݐu.9��_dp6a����� �ߘI���ўkN!>é�f�N���L��b�P�=�a�& v�Fq}��s�#_Z�.Ӏk\=���M����\N�;�d���:B�r=������p�AE�"���]`��r?����A��z���B�J�T����qz��䲤D�\�٭فC�����O���N������N�;���@JvX�{v7?���6�L���ܯ���gr�8K�֚v��,[)@,QYۙ�)d1��${��(���ּ�jr͞�`�Js�r�G�y2��XԗF�L�^�MGo�ͦ��e�z���["Ʃ/��ދ%�����N�E��nw�J[n��Ca|�T�&y�:Ӕ�V�����8�<H��u�9�A��5%E��'"�#%15Ts֑.p��!�N�I�l��*2)r`�#Υu	���G�%T�tԠ5'���Jj�c�0�W2Ri]��Lr��
�D($�K��+R����E���O㱓�ˤ��Y=����m�n���E��P3�*�&�@#�E�	��#a��%Z�[�Y�`w����Æ����C%a�K�ʓ�\|�/��c��C���,�R�A�O�a_u��Ea0��]h�TMy,e��z
a%pO��� (��e/� �c�C�jDJD�S(��*8�Оh}	0L��;0M[���otي�_B����}eZ�y��RG�yC�����2���N�L��^�MNQ$�+QW�L/��E�M�jL3�	OU��8��it;w���r>w�ȿt(�:��ٴP��PI���>��ì�
YOwڏw�=>t���et�Ʊ��?/�� 7�� �����Bt��a��4;ƅ)����;o��t�Wj����٧�O������G���N�K��Zz�[�����ӽ ��z�t�\l.���6q3|)-��ם� ]vh��;�7G8��g��YO�v���r�6��))8z��Hh�%g̥�ƈs6;i�)p<��e����L%�a�)'�se�.6(�}�&�J��%Gaix8��17c�v⡺�K�6u��ɹ���)��_>T3�w7*��Q��z���8��J��Ϗ�z@�G�IR1[�����m�F���h������Z:SD��e���/7֜�u����~��ĭ��� o6��6ũk�&���� (X@J�b���_���6�(C�B��Y�zH����tao�%��������B�i�vMh�B�3���a��I�}W裝QZU��qg�t��Y9fu�L掸�P�g�����=�T�:��X_�M��,A�[��U��j�(�%
;, �Czp�] ��J��ǧ��5=h�7>��s���l�=A��*.�Ě�J�X�c�{�{����.�C�U��xǺ��r�y��߱?xGC�]�M�g��������Rᵈ��������պ�ϸ���ؒ��K2d6#uUjʲ���IFH+0EI��ȣ��tI�~��ֵ����B�:,�5��ƨ0g��j:�2��!�M�f?1�@x�Uo�J=��әN&b�3p�w�u?/KE��zK¾�l|���F�@������MHo@S��#6��	Fڅ:^�Z���E�t�CsΌ�M�l��SL&X\����*�N ^n���e�M��9�0��p�z�LA�D���&����������S�Ӟ]��О�%FcXpNZ��:��	�#ٔe'�:+��B��WX�?��j���]�unJ,����������>$�#�TgnA�R%��?1)�}qP4�hU%��u�&�H��W�dB���y	W"7M^�eS��
�&&�ԊN�B"9w�{x)~:�F�}���$W���q=����'���X��2Vg��^��_J��Qv&�"��	���??� ���J�t�6.����l�N��';����>i����AT@#��
�j�K�f@����sj:S��� a��@�0_�^_s{���/(��vg�\ryΙ�fN�:b���r��Ѫ\�k*���Q���d��dxƘ��NKc���p��ݤT��n�	���w3��S��|Z��p�"�Ke !��խ��e�c��+�6b������U��4E�{�5�6�}}�oܸJ����7?�����/?�M�����\����\[�����C�B�_�־غ����7?����Y�_}oߘG�@/��������{������_쿟3��$ o��+�����Z_�(�}��G��g��_��'����Z߼�Q���
���ͭ/nn}���������?���n�o����������tFZ?ԻZӬ��N�in�ǡt��������A�08\j��<��u2�@�	�>d����ϳK��P���u(�g�A7�/�"��]���	3=�G	�v�(��WXq�����lf���3H8�;N[eu�4���ռ����r���ft��}���� �<B�{��s��x7�f{��6�����\�.;'ɀ-�C�^z>��^��ڱ,5u���J��*�g�D��U���#1��*!o=�\aN�� ���[�zzx��=�N0�|���ϲ� JF/�I6���MF����Ly 
��HD�{]~3�>y6=�Xjq9:-%�m2o��Ep�f���1+M�ޘ@�"i� \tw�O"h H���;�j_q�B�4P���@�#!�@�._=s�Yr�3Hn�%3��Fcp%��&a �.���g����
jU1�:�P@�P�9��Y�!XsPwh�~
�q�a �b�X��:�� ;��V0�����?��i�5�u& YXqf�DA�.� ��E�쇮p�`,�-C�6*�**�9������������������ý���P�gN�3�G/��)�`妿�@O�\Dl`"3Z'�^q�QVD�$���i/�\(�),�E��/�)#���)r��N�X�FVgM1����y��Q ȋ⹂��7i�yF����L�s`� �*��]H�f�<�1(�����3�sϊ�?E�UM�0<���㍈�#{�'���g�(n��X	�O��@��y'D6Od{��TTEg�b|8��fO9�Mn�.9���Ht�&�MiPl����hë�3ٯ���7]u��}�t$qG���`�L�­!�e���� b9�f���z}9G���!n��*Qa�n�S$���=%ei�g��(��}���qr�C#�������sY��|y2��%��ӎ:��E6���� 	e�w�wN�'��~�[�o7�]$If6ɑ���P~~�QӇ�l�1�.��@?�¼bC�V���s)� C���$(��2�P�>���cH�6҄�?��v��FT�d�&�g��Wũq<(!o����$�Ns� �d�Ve95���6p�,<��A�ت">rdvEhy27(��n��ٖΔ�`s�M���1�uZ�)�~3M&���=���EGp��lgZ��j0n����e�H��.φ����f�:��~:�\(G�D��w��z'sے�b.��y_v�ن��7�tbb�� �jrZ�ݓ�GO�����݃�'���n)�Jz��3Ä/l:�%�v�����H�UC�Qf9�ٴӏ
�:+�)o2�C37�s}kx���J��Ew�7]��N~�',r��I���x�v+��/�B}�}i�n��ƙ{P�4T7Ĺ����s=�T�X��3�sps��)1p��F�E�"�PǢ��
�����/ �t�4�U1��!�$��Jx�j�@���B5�J�?Gݴ�`��d��Жb�F�U����l�%v~�7�*]Ğ׻��X�m�%��<h�
V����?R�����4�lF�x��=uãi�Ʈ:p~�o���9�ʲ��V��	S��f���W�"�%C��N�fv^ߐ9�U^�i�M(�By.��ow���,:`��
18ǋ��,S����Z$��"���a 荵�'���r)�ь��l?�~�LO�ד��o���{� zC1?8#����D�{r���G@L�ُ:��Bg(럯��{�=p���k@Ҕɩ�Շ�TG.
�AC]I�Y��AĻ�f����%�����dE:�5ْ态����é"v��r������o�S��CU�u[o�i�[�x��*sd�,歪�H�-���j3����X��0�����}��|$m���6��Dq���A�o3��!�C	f ��H�(F�A~0'�9�e��x�F��J�b�w#`�u�䩇>nL���Nj�"�%���/�W�@)�ق_bh�P8h R�4a�l�P��Q�%g'Y�)�u�u�x��藥�W��q"�"-;�n���B�/+([\�(�-���ft����x�����wS�8"Tj2Jb��]A @񸭅i&#m���$����9���:T䱣9Kt�}��!��Aœ��h�bR� ���3��l��JS5�3d6��o�O��!�4G�k�DEɀD�}s��1�
�%��)FZ:����,Cl�!F�$9�����b:����8ĦbG��cl��&��J�an7�`K�7F��h6��n�(Ӟ��}�7��!b�y��qt:�G9� ���II]�ݚvdt'��0�Mv֛��+?u����\ ��X�!Ng�_(y�(�� �V�l�<wC54&����[�)�'��ߌ3�e�"k�(�5qGK��4's���	IV~pt,���*Y0�s�h�j=0gj��W�\�q��ѩ�ǔ�dq��{:J)��x��ϣ��@�w�/�~I�P�lW6���7�Td�c�:kuӂ�H�B2U-!랗�%7�'R���%]k��0�`�Ī��N�cGQf]u��������	3K�J�4�E���m��d�nY�/V7E4I��0ؔ��)�y p~H�(�%]~Yx\����(�FB�ɉ�P����~c�C<c�;�,���[�fTuҀ؊8[���z�8ݤ�P>j�i%��U-��k���$��C}A�Mh>(.���!(v&�A��E3:�=o��';��������_	����)�+��+8�*!:UB�9���2������M8Q�Q�	
��:7po��tdy���#f�A� +��R��#J,O��8BQ�f�
 ��왎НaLu��m��UoD�4nz��]�L�F1�K_�/��U��+Mn�X�#w^@�U������3{O@r��xq�F������(h��9z��<꒿�&;�%�<���]��f�+�.|��v�A���Y^\��ޢ��0�'IO�}ROI��f!0�� +?��f�{��������
*��$��d7)aS1�/��l���dq�'�I�j� ��=�=�?��UDǻ���'�BoDp�R12H]̤I�,���Id��CAp��G��o��l%�G�q�n��t0s��l�-��;{�;�546��P����uȒ�_��Y��1���D.�|.�
�!V�ձ�̺[�qps1J����n3R�Ex�H;����*4�$�9������c�0�Km"��n�l*bC��&�U�ֳ)g�)�5��l֨���p ��V������@~A��sP�P�<���)������M����j����*d��)q)>�!�jږ��u�p�%Q��K/�0���+��(&��Q�6y�H돇�62��N�΋�@�KG|X~<H&,�H�}��֌�l?�@��p���h����c��fzn��s��
GF΁�n�RY�j���_t�]�EஎA� �����Yo7i���3N��3V�����N{4���%���j����f㼝W����Q'���xQ2��p!R��a A��rk���Ҙ�W���������Q6j�b$十��lG'SS]H}a5
(�'/��4�>z����1 A��D�j�nW[I�c4my��\�G3�g�`���K�_p��:�SJ�^&%�"�3�W���\�[VgaT�~p�e��SmΎXpt��B��g�/Fq���v4){��l�D��8��M��dw�W�O!�s�5����7����{��уÝ�F	T������%�*�8.$C��&��z�mTg\�qˮb������P��r�XI/Cph��]����r�:II��8CR�OJF�^� <�)J�-�����}lYy���n坋��܎#%�Ndz�@�`�#�@��A��Av~A
��.�g�U})�D����g��9�������&����˽�ż�2ڝ� h�Aʓ�����I?�h0;�R��Weބ�`�&�/XăO���'��@^�����Z@�@kF��<��s�39���&�L�4�=i燽J{U�$�º}{��N	h�~��W�j��T�mL@T飺.������~�_�����]\�w��;1;������y�5�8Vx���ޮ� 0��%��)���5������_+��|XMyN�m���i���j�:/l�"��/i`e�[v�pP�SB��#���v?��,d#���NaM�4��rn ��y��Nef/熄H�r��?[̝�턵��X�T���Eug��,F���ԍ�����C,t�\���FO�*�"p��N6��F�J�uE<O69�GB٥��ϒnw��'y��A�o���G�gx ��]�2� ���|��➞��Z���G����r�WPl��/�O��Su�:gu�/�^K���<���1�_xg������;ĵ#Z�� )��%t�4��\��H����Q<}`Ȥ�����5�6C��.Su����q���a�N�B��Tc�+�э]ώW�6$&�I�t" *&iF/*`�Q�狯�*�t�0�IC��KGZ���`���jF�;;�''{�
>Y�G{Ov����}��b(n��u׻��&U��<Ӿ��v0�,�PMkKn�0�����f�����`❋�b��_���;��<w_�]�ï� {�wg����u��߃�sN1c3�ȍ���Gg
B]�!,�W��ġZ��Ҙ*����I8=���
{������e�&���N�
?O�
��2	A�+P����D�d���-�mj�{%�N{�o�g&�5k�Y��bs��H�~��~|�������5x2U"�d9	� 59�"�h��Qè:�`W3?�A��;Xm�bn�ex��hF۠��>�G�O�N����TU����Ix�yl�)�4"�C�X|ۅC�������;�����F���=��'�7���Z��㤇��pV`Ն�06'�I	�6\���h�<���-��tJ��,��/�l�1�v�!?�|�A�?�8�c8�+��H.� FY����=��<�����C���w�ߤȅAr�A���f�%�X�FZELG�Uv���v��$�wA�q���bӈlƥ]���F���E'	�h�������*wevV�� ��7�of��i�4�۠���Y5���Bo�����Fxn�G��E�t$}��3�]��i�ȱ�L��e����N�J8���ak�*�e �Y%�y>=c�QW�Iޜ��
�</��@j����[J��N�����98!�
,K��4,C�[]�� +�s�?v�����_��c9�����������1���}�����٤���M��͵��_?�/��Um�ڈ/n}���g��T����k�c�����lC��|:�5�q����7�,���������Q��Y��[Q����h���}ss����!~_忍�77?��?A�����G�7�J��v������C�>�d�,���y�V�4�>:���y��nԈ�e����:�{mT�w�*��Egfm�5�}L��X�ޤU+��B�nop� kt^{t����������l����p�v��}���|����-?[������|�-��TO������xt|��ݝ������k��ǯ���j��=yp���a����kMM�j�����T�k���O]�����4��� Q.��l6?{�d���-c�}7��j��B~���7����L׫�t��P���+
~ߚh	��)��o������o�
t���Et�4uj��g�k�W_EK���jP��Z�M���kf���5va��͵�=՞��1UM��m�vר6�
�ȇ�h�D&�K��v�҉�/�R����|4��7v�/��R�lM�mk��6Pסf-x�]���X�.�s�8����E��lk�M��A����߆�N�x���o#��px���xq�2��k�s g¶q&�[����}�� %��6`��5t�E���W��⻵�t�2´�W�pJ�S�� cc%������p��3A�&d�mS�@�k���ٍ\<���E[=zvm<=�м���k+ѵAz�z����fW͵�Wl�[@��]��Y, P֚_r�Ks�amr\��0y�P�'�p����v��a�3�X�?�:��y��
��+�.y=�8���^��m�kM�p�����d[7�5�;0��EƔ��G>�d���m]1Q1ܢc�'�9���ӡ!A/"�᳜�Ĥ�y��j��Yٕ(ƛ����4x����p�X�]M��������c�̛'�Õ/~���?tM�ЁkNZq�JX�)�]>�*#r>��������<����;v��E>�������W�(���\��G�A�L�Ͼ��ùJ��8P��'H8X��Nù"O����K�A�UR��l�i�. C;E]�m$���&RXa>G6V����(v�O��,D�B�ݰ�.����h6CS�[p�e�j��o\���r��b��;�+p��̃�3_qLe�1�@g}�\I/�v���E����1�i�G�&ޕw�>�h��~��/�q�G�tD���^����n��5�}��Z���l�w�w`f�L���L�T�><��Fp�>3B�:��8�s˹H�u�ޱ��=��d��G�K��0�+lxs�Oq��� ���������8mB���,�-�~q��+!�݆Y����.p��,���=Q�}l�GhC�n���IhK> ���=y�R���}�]��������j̮������_��nFE�\f��^]�"�l3�f��ZN}�1��}��O� Mq�k���r�nWP��>y��Hh������OA5�n0ڌ���腰����V�{��w���-��O��qN�;8���znr��͇Ot��Sˏ�Qc�VWO�6�Pnԋ�Mf���:��>�ˍ������F?*��Ն�������V�F��m�^�,j�"�"}*�������ΎM"x�m�8����}y���J(��ch-�Q�������Q�'1chc�
�s�G�o.���(��0;�����\�=M �gySƭ(`Ũ:�["U����G��>���\�E$[FwW��uu4���N̟��k�r+���~Vs�MuKMUoK�ފbj��2A,C��^R\�}͓Yъ��^���\�o�4��#HOg�s�1�[sࣩ��m�~�L�d�U
��o(h6)R���Kur�O�L�˾�8���0�����/��<x�w'E2��V��hJ;c|V�
5w�!�m��=��2u�!��h"VzV�"�t�R�d4H��f3zH�z��!��Vq����h 1a�t	G-��U�P�j�u��a��U!����g�s�b�pq�B(�A>�	rB���?��@��U��Ȩ��?��F5B(�	IW:Ǖ`*�DAz�w���2`	������?����S}��Ϳ72�����]��tj>��n�{(9(����H��sOnw�����Xif��ןP(&���T���Iθ����yD�	�XW4-9��I��f�m)ٹ�N�~�]W�$�$ZJ�j�[�/�WI�"�;�5A �hE�-=J2)u2G����(��64D9�������B��j\^S�_|��ѻn/�)������4��%�X�$.��و?�����*�X��������ED'�gkz9��1��n��g3�kr}Iw�.�������؅Ԉc����_!=�\:���5��A�kP��m�b�"FiʩʄvMۻYg�Gr�_���fEz�ڷf�?��ӛa��Oҁh�֊g����&ln��Z�D�˸���U&�x���!=��n>PW��0q=�
���V��S~��FMb< ���V����5}��4��,v�Js�2��(�Ug��\AцR8�f!8���a&	����S$�:m����#��D����p���zX���BЌp��^<%�k�Y�W�y�S�&,;����h �0_�~�"�ְ(�+NU-a�A^�[ɠj��`J�u���_��aR�=
���P��|�J�bLr�R�����c(�u����_j�!����w�����P3V�%��%9�g�Q����&�Y�A�q5U���Ȧ��hJ��sEX(y̅����Zp�/����4�N2O����B��6��M�r`���6g���ߜ��C�\v�}�Fg�n��cG
'�K��� ��.T�T�4D�B�<Tt>�2l���9�۲�ܬ�S��l��5�5-�1<��5@H�@!�
2�O8�"����g�u�(�(�g<����>�4�ҌE��&���p�h?'��3�������ֶ>��������/��������766�o}����p���j����1 ���'��=������"v��߸�1����f;�� JP��EÿP�e�2W��O/�kg��]�"RP����{�it�jtuo& ���:�R�Ύ+wG���8_5Up��lCS�;;�Po;	��vf@}��g=��Hl�3yI*$�]���i�yɃ'����9�\�����40�}�)g�\��ک��M`5�Z�#�_����B�:k���f�WP���:%�cavc,��\v�Iz~N=G}9k�gBQ�NL�ɼ�`@L������ �	o$T���m?�V�wb+8._�t��`�^�����~��rL�щ^<����o�:�6�=�J.s���a�`�e���iB��9��ѽZm�)���̝�<�x� T�t�H��m4�1��vX��qe�c�jG��6��~�aԍ�>�g�%��k���/C7K��4��d���1��/��_g(�����A'��[ �T�����fY������t5��1�E_ |��I�)6Y�u�2&o��f3�E�D
k�3X���~%�@��&ß �χ�g^[X�Z��e�4�Js�1����8?� �-����*����
�O�x3Leh���ؚ��Р�f�1�1��5��%9�`M()\x��e]@ 㳺����V{@����c�O�-�:ޫտS}�~6�"�4L1W��*2�(XS��L��E�¢�N��*.��_(n�o���zQ����pb������2����*h\3mD�g� >g�gJӸ</<@)�O�� �?������iV ��ɹ&��%<Jp�f�҄�xxz���4�B
E��δH�+�9M�Ey�)I�y�i����Bv>_]5GX��R$ƺ���(~������_�q�݋�����X�������<�v-�Eu�kw�D�֯i�15M����]�.�5�J3�̐�g����\���e�{s�Qq�fd�ݦ�]���_��H��K�Ks�m6%@�to���Q{�p{�u��V}YC�j��m®���h�5���`�B���e?�e��O����V�z��K�i �G���)�8�H��P�R����D�@�!�17ݡ.�Rm�j���a�����a<�9綖\r��ԁֵ,{�tE��I������ڏ��c���Wʏf��σK}��k0����*�k�o�fs�q�v_���k�����t�π�2�4g��7k�� 6^��X�3�'�0�ets�k"��14 	p� ��WPH<���-6D+A��o��z���=EO���?�+<��i���~c��Y73�-��W�;�%���p|��A��K�à�+	d;�ؖ�TԷ�m��"Sރ��v�,b�Y�o���.�@Uj��j�Ʌ����S��J��tu�@�8r3��3ð0K8f�3�@uӉ��P���39��Le����<����\���،SIlE� K�Pb�~��7��u���@�u��7�\� ���u����?���Y��%�~�[��Q_�Y���Rچ�ׯS1�9����*A�ʼ?V`���Ѧ��(�B�JjCp+��-�pq�:��K�>����߱�-� ��7��!�[!z'�}#�&:���W=�p����!jA����8],��u�M�7߁����1>���tqA����8�槇 @X��(i�uDIWc�Q�=Q�~;0��Nv|����i�	T�x�L`�sB��w�Cx�d�]3�u�� �+���)�z�qDzL�~ >02�;��󢄷�Q�#�j �����_�7�ىq�� 7`@]�h[��$fX�|��oc1-]���I��\`e�
z�5�� Τ\a+@L�ȥ�*:mD�:�A61Q��z��4b�9�Pm9��)U�a}�v8���-3���X8�2�	)�؁�%'���{O������zx��Y��S�l�9��W�n�䣥�8nM��|���ԥ�a��~#ϏڮY�N23)"�P��j�m�5>S����<Ū�� ��O�>���K|���.0�@�*99f�1	�0n�&��Su4M��5��2	o������7����f{V��d~�S�k�qhSK��g8�3�v�r��92����(J�[�W�OL��C~)0/V�SuB��P<���lJ)4x�0}@j��b8��>������ЗL{D��8�A�E�G��!���P!�aei����r�3���x�9X8��GҞi�9m�`Yүv����i؜Q-��*nw���S��k�&E�#jqq¹�V�+����-�AL0��g����9���\���'����G����������?�1x��P��������?��X�y�ˏ���?A�����G�[��k�����??�o���)��|���Av��y�RH	�cL����y���>XK?P��Hn�tϽ�gf��'Gcf?�����ͪ�9K;�7IZ(��HM�N���=>�;|R�O�w�r ��~���w4��±��ލY* ��VB�Jcp������,utԡ>
w>���.���׶�Nt��X�M1ag���Ã�զz=�\s�sb
�t���\<4	�j	~��󑠫�q� +�o/������}1gťP�2���Z��P��i<俌A�}�ip�>5$v��l�N����c��e.D���&6�0��̔�#k��dY!u.�T�l�m�"��=��L'Hl�x�eh�u����ߊ��F�E�1��JQ1I��d���;��j��Z��k�'w�k�HF�� �Ɏ$�rSN�ǴXz�M:C��)�����:�������(��!��F��I����f���m�]N�E��o R����}�O$'�п�����g����������\a���������Fv���?���{��8�dMp�)�Y=%R�$%�VM��:�I�.�R$%U�Z�
f�hefdedRbK������m`��Y�����'�GX�����"��u���F��077777��`w{�ح��������)��s)FS����d|���?�>��5�M��ʵ��h��R���EѐDӂ�9����WH���~p4��O8{`AbP�6Dd�,� �֠:�؝P��;Ga���[���h)����/fMt��(O4�j{~���GȲ�Ƙ�ŝ4���/�H�
�䝣�9��ިP-�3ѱbB���ž�<���3���2�LJ��`����Y#@<D۞�J�ȴ�f
!�+�_D���{�L���Z���Ħ�5�ѧ�������t��
�`���2��O��5�ͬ66��Om�N�-�p�s��o�i]P�)�X����Z�t����OP�4嶵�A'N�v\�[���ϕ=&�K-�w5Jh�%nk>L�\�Ni�(�v�W�����D����NϘ�")�R�=��8�+�����wE�U�~˕}UD��,�o��˕����EA��C?������MǸKs6k,��,�;붪ï��s�[��O��L����yS
/Fjg}J	�U��C����)?�t�Yl�裯ׯֶ���KΆ5*��%n�~c�4��)��1���%k Q56��e'lP��8hE�[L1ɤ���E����Vc���:�f;��4�~�3i`��ja�a'��'�ɘF�6ټ�'ڍQ�}� M�L�%�fd�F|��=�l��9&{�=}+GB6���:>�&�n��/����;MId�Yu}�Sr 
���Dcc0�l'F x�0>k�^��	�����*N
!���55��:�N�"�y��r>��-@_�vw��R�����3��/��|M�a��y?;U�,����)��z���G�����txKF��$ԖI/��Z�o�/�~�a��'��N�$�MڌѐW�,��6�c>9Sg�����s�/��n���5S%�C� �n��0W*&��0j�o�o|�7�TODs6י5�s�G�d���Ϡ�)!����)t^N��x�]��%{�a7��J�rv����?�Z��/��E�-�,/�M"�T�����G�Oe��HTYhjPj�4SX�?����o:g���W�����ugY����x9�������2,e��Q]����"�C¡�j�0Ä.d"��\�F�����d;��擞�G�0�y��~ᅲ�<u/���,&L;��i��n����qu׽�!��Tc�I�x> �;� 9�Vመ���a9I���������|<�k++����ZL�`r�[���v�i�R��m��
�ڢqToW�ŰW]b)������u����q+�4ɽ&�ǫ�XƣCV��G;�4X+��u3��p���e���\a��B��^6��p�T���	2�O!���#�њ��i���!o_Ř������
�/�Q�g~���r�\�k%i`��C"n�׷f�w�,��sU#��[X����w�	�W���@�b�����5��9����>f�����
�2�~K�V]��ݺ
��(i�@�a^+�7M�}FR�9AB��*ʔ�h��F���.�&��D=��u��<b��@*}��0Y=c_h��8T�,M-�fb��W&9'�l����V��&�,E/Tt0�- ^��������+���d��A^>-u[}�x�~a	�Q�)�N#���J]#&�钋��p1wW����V�x� �jV����n8-��U���h뻄��]��O'��C�҄o'	�>7,c��C�ɻ���p��`>0<B�%Ἐ��$	Mj��:�'�?!�o.��r@x�^l�OT�Փn��������p􇹭C�'��xt)�|t�%�a�nԬ����1��o�?no��}�CZ�,��	]淦����{[�A|JPk�W�z��Uý�"P��jff���l�������գR���!l jFQ�`��[�W�wїJ�Ŏ�U¡����p�:��qX���e�PCt�j�����O:A���S8R,��/�<��>[c7�׀U�5B�Z�-�tc����S�Rg��N� s��D���6
U(����/`bm���W�r��)�7n�X{�iRQ,���#�z��[�ꗿ��S��[�,��,����M�^j�=��W&�h�P/v(���|HXk:r��+���\��u�S����nL�6�+������/}i�G_G��T[H���q��b��,,����u�߾G}����h���'��{Kr�+�9lT<t������F�ŝ�g�юtS�cECh��H<9��o�����c���@<�a� �H2n��n<���r����|(�g��[G����L<h"Y�u[�N�f�U8��m�]�qߨ~�e_��nf/^dW�Qf�]��;+K?������V�jq3��L/��cA��߾����4hS���Z���ekt�?} ���x�-N���'�e	�8#*LM���A˫m���φ�7n�ek�?h��|u_�Z�KX��Ʀ�e�n�U�E��#>��k1�Y�Ѥ�҇
͔4KI�<�sSu�Y�G��go~�.2���A��K6EOm���.&1��H��,�ϳn6�/��]_kux���T�L����H$�G�2j�#|�n������W$�mս��vhY�";\�G��r�����Qa̽�~��~�U��[ˤ�◹��1z1OZ��y����D�,z&�֕�v~SƼԊ[���F<��f9��1�q�w9��9+�#�x�lV#��MM>/���O�1������ m�憵<._���7א��s��g�?C��{�����5������q�����~p�������w�zp���5��/�'���j�������;w�^����7%�7��?Ϛ��j���eqyR�#8�V�qg2�)�4��ϗ����I~Q:�{%�6D�a�=="(|��9���޺��_�Ԏ���_�.�����x*Q��6N8K�1��wm�n���2�it�_���*�� L9�/8�D�z�j�ZB�0QC`R���M�3/�GSU�=��ކ��6�B�����Μ��L(�Op܈�8m���6b�=>a^���ا��¸,}���ȏb��W��QQCr'��I��\�Ƭ؆�A�J>!���J�����I�pO���7v���"���B�TT�����:��Bg<��.�����:y_���s�"��;)��e�EZ��e��]��MW��%��G�W�
m��X�w\���x��|�\PD_�����'8o��_�i�%���H�5m�m?��ν��?�M�W�gJ���{�&�E?�-�%��"��>IG�{ڜ+K�m��#>�Y��K�l�����X���ˑ9Es�8B:_/�ϵ���EȤ�c��/�^A���H�&A��p�~�]|G�=�� ��{��ί.�Z�E{/V2�����w5z�|����u�},f�}�̫�Q��z@]��W���m*�y ����Ըrv�{�_�����W������_�K��|d]�߉ATJ���c��թM�$����^��ȓE��òM03?�h/BZB��R�D.7��*ܔ�V��/E#��'b�9��/�]�M����Mh�A�7Mq �e�����1h&�,�~HMp����Y5 2LW
fq7���B�H�W�wf�h�_��!�E�/�0�gyZ*5�[Ǉ!%���e5��%�G����h�BZl�d��r��J�P�E�Ӭ�-��?G7�D�Нİ!ͺ	��6����_����-υ�'�3#��t�.�*A�8#���!�:�J�S�S5���#��T4�y�A�Ĥ�x�6�;�=�4rF��ڼ�.�ի�9W'�5�%6}0:>���ҕ�^�[~� ���L���bZ�t�&6A-\W*�z���t@����ݼ#r+(Ϊѥ7[O]}�>�l��o�Y��ȫX�b.rqԮ
p�Q��0����O
��ģ�p���6����P�T��+�PA�x����rO���ɣGOx6qF��L,�bLE�W#9"����5�|o�K>���	��48�m~��ѣ|7Vؙ�4�uTѨ�w��u�K�:PҴΚ�z�Y������ְ�#�������߲3��a7w��#$��q|����7�����x�\�+J���$U��9���ࠪ��.~��׿F������LStdR�rro6Y-�>WMͣy��;�M����������5d
oi�}\��O�q�����g�]��������Ɂ+��ݾ���k������}uo����;�������W>I��?�w�߽�@��{�d4��W����_n��F�#���q��ݫ���ݽ���<�k��W��ֿU?�������[����?>�/���^m��n߽��~�?o������}���{��g�����9~_踍�{+1��L�ss7o~ ℱx��Z�5�jeg�D�}�/���b��� E�iM��Af����.�}��s�( �74t���)�F��t�N�a.���6�n�u�ɩ6�ggT3����v�W����R929��e$��!A,ѹ��~�i�H������_=����X$��#y�r�D`�gEO�E��),𛹹+&Ğ��Y�箔�zn�!����ȸ|��ilt���[?�Q��_��O ��5��'��'�<4�HZ�h�o� �>Gح�΅U�&K&]\� �@�� ���rgp:Q5��8e.�P�T>q���Qgb:�A�rq�!�.����vKB{�ia9�fM+\7{�hd��Y���/��{�}N0�M���]&�Z�k1X��m�K��$-�@v��c�Q�ݼ9��~jN���^M[Xj�JAj)]ӡ7�ԛ7ź��&� �4iKŐ�eR>�Jtx�)�N{ ��5��$���+"l��!w޼)`\
d���͛���4��s��|{��b��P����M���S=�UoF��������Uލ�6f���Y�xK{�.�v)N5R2�SԞM
l� �&q>�� �Nes�= - �m�ld�V�¸�Y�*��U�1���A�������4�k����e���Y~y[=�z27�H�'�T�]s6? U���yW�K&��L�0?������L~ϼ{sS���MI��s�\�a���t^<�zfc�e��K������nnN�l�gJ�f�9r[��� �M��qI�|��e,,3��Z���i���L.4��n=����U�T��#�B8�r��$�~�����ˇǧ�U�%h���U����?���K�(��*YC�T|>�F� �Nk�
l�M�6?�@�)�2��������?��ч���-�2�T��#��%n1(�/�lA�op7���kg,)�D��߸��M�B��.zV�Wף�
P�W��d��SE��4ˀWh�5����HX4�whQ[M� �:����H(�n3��DvXWB�W�P����05�K����H-�qgy�?�ل�l�p\��2�5	�Ƀ�����A��	�){J	m8rW��防�{��Zj���r�	�*��s6W�F1pC�"EE�I��Y"��u�oՋ^\�g+B)�NzFEZ@I���|<<U�>)���#kv�H։����9?���[�P�jH�<T3l����7�!��~$�9|��������b��)u)i �Sk���HH�=�яPG')������n��Z�d�����ܟ�@W�v��P:>����N����pF��P��	�1��2��23��p4��p���F�|W�|?�=i������>��n֊���30n�B���t��q� ��n���W1uDG��dm`]��(gJ�x��Ϲ���=�j�&�\���R����j���&�u+�|!�6��c8"����L[U��R%N/�h�Ip�A% "$䮨��7�V�3f8N�Ln�;����Z�X/�2�A�&��
�0+<B����K�Vd�?k�"�O��5�պ]9��ݖ��!L����I7��|���_��}q������?YW���{{�����g�]��������Ɂ��߻�������E�n�_]�s����~�?��?��7����}������ߟ�g��1����5��?��+��*a��Z��,�k��W����j�[\���ν[������K����y��:������S�����ݻ�����{����?�O���\��ݵ��jK�i]@b�A�/ք+P�d��uQG�c�ʵ��2d���5�,d��|��[�0Y����=zˋ%Ki-��F�Y�{g$%����ܜ����7vUu�H>�o�NI���,�^�����9H�Z��~[u�¶-�����j��v�%�_ix����ޚy �#�Z���Q��v��&p��.j�g@�M��w�=��� ?��p  (�K���J�jta�.��Zod��n4.k�M�(9�g��aZ�f��]���>}�����!U����o	�	n�A����Fw�:f@m}��RRV�z)�}��r;�?=�쭖��k�C����t!��|�g�堓��_O�̯!��S�Q얲�������nk���k��N�Nap�I>���7,���4�B0$�\�{N\o�e�-e'z����{��,MsC�x��c��PR�\)I��������=ʑ�E��@,p�+�Gk�������b��o	D�dR�9T��SENpM��l��cd%�+���5��fݢS�xa/ۄ�s\t��+��m����p�^�c(]�*ő��
�!@jix�8�e�����b�NCo{K>�}�X������;HD�k��{t"���|U�� �ŠQCrTk�sp���XΞ�$�}�ʗ��Ώ�m�ZU������k�3(���f���;�ٿtF%zp�G�^�rJ����K���P�2:N�,V3,'�-�<-���*�������+�5�#I��Zֲ�vԟ�(^�	��V=髽�R�n��ev$^FEÉ��2n�z�F�XE���dN�7Q�F�1�����p�2A��^k�4�vt�5J�����i��7�&�z⠦��ߘ��S%�!r�M�w=-E߼Q_\Өz�{����f�nו���؝^���:x��s�U�M��觀r����@��w��b�JVmyB�2�q�z	G�ROMz3�Π}}��j�`l4xo�����_�ە�޶n(!����j�,FM�����A�K�K�����Z�X��VȢ%O�c���S���"�N���K_�]��G�kw�5��Xy�`r�jQ���`�j5=$c~a �� |��|��[��[�|�F�jk0�w�h
�;�jZ�6���D�T
/�TUvG���{�r�J?T�8��h�^c�Ԧh&�E�]�l��xS�F޼YRFd���|���٠�yCWQF���F�a驞��93��Gƛ������k�g|�^��J�����ڂ��N��Ypj�$��#ڰ� @���v��(eb
m��Zv��ģ[���C-k�O�W��#S�x�w��wzZC6<t�/������CqAE'~ez�F��nY1,�Xp��L	9��QX۶�i�[yF������j�_f����w���M�k��<��hm��Y���E�z�D��̨��?߼!�ݾ��#����������e~�3�e�ɼE�V.<=.�`�p�0������ �/PV��S�4��*��gNsGj�b9��j�waڣ�V������1�ξEyU�Mk�Ǫ��k�9M��d��.��1�cU��5�Dc��v\��^�tYD�@.�Xj�3�\�;�;����w��b�e�*���v-���	��'v`��i!?�nC�d�QFr��YY�y7��H��6ȤS���,�t��Qn�eFYFD��n�߼&�E\xek�(��M�q:�Va+��(6�c#8ȶSp�A��A1����=���ꈘ4	�`�-jhOƴ�O'�hQ,C�S��oH�t�`@��(a��V.;m�[��xH/��<�ӥ�W����S��
������"=��D���B`��JLm��Њ6P��9��԰�ʿ����Q1�j@�/i�0F~�8Ćh#�@њN�.�_d�Ң_e���c0-Nm�y����yq5&u�Q�Il\ ��"���2�QH�T鎲Tq�������,+��I9^a;٨)�v2T�]�sԁH_�']��'����R+�:�!��7��,w!l��(�<�U*#��Y��������A�S��I�6�';�PP����ӥ�� �(�hj��{�yB�������;,�a�S�@Z8�����!QZ�� �e¾Ǒ�-䲠�� È����}��R04�	�]!��؞�o�Q��hO��K�Db�t��Ms<8Y�m(�R���*}c���J�@T�m��6��I$)iR��'x
�4��l�,<���z�����Vf;<l��;ͫ�~L�kŰ�dO�P���R�g)��e�k-�����$u�F��n��ߞ�,��W�J_�L�|��_�<���[z�ܷ�v^���cP�l;�3r���h�I[�ԥ+M�SA��,�I�\VOvV��p���6��W&t;Ws&�Ē������,�3&�=]4-���1�_ߦ��i� 2n�ޝ�6��3��C�I4m�ԏ�9��̎��J6��G)����\�#��kӓ��%� �h��iZ��rmy�m�����\�����4	�]�v�ۺ���c�!��c��J�Un'9�D6�����h|��3�Z���1����o2kϬ�u���L/R8[$�)�G馵�g��+�4�m�_��#X�R�c����̺��p#�/�)Tk����R&􋯧�8�#9���Q�?&~e�Ih���KOSK*j��MA�̤�3=���r�9U>�1/���~�9W+��Ӵi�#�����P2ew��I&��mOV�A����	|Gǎx�M�]{o'*�HT�mm�H�l�@v�uI��\N�Y#Ck�L.i�u��_�h<c���+J�����z���\�����-���yR4��7���q��}�,���`�SJ9���K ����܂psӦ��{ח���u<�x��>6���Ew0Bd��E�D����!����Jg8�����;Aؤ|w�&b�0������r�r����;�p��3�6L��S�F��-y'��r؀t��1�s��N_���z	����s[ޘ  J���@ޥG�ܕ�5��)]���WU=��4�F�%�͑�M�) �~���SN��1j���сv�=����[>r$�F�5ؔ��d��\p8U�B�4�6nC�.8߁y����W�F��d��imM��.����~݊܊Z.��gW�-M��6�L0�0�l� +���5���sU��N���lc�E�~X�J#�|
���2�`bk����)!<���������J*��թQ��%��H�'p-4}�]��;�%Š�W�����&����!�+�����x�ƈ�k�ia�m^l�T��3VI.�HM'z��#���<�7A��b�����I̞��
�,�����/V�hIw��Z��2���	�Ɣ@�����j�|���:�������\4�&��A��au:� �NM����1�U� g�V S�V [��+6wV6���h=9A�n-)F�Z;B�� ��r��C�p�tm�.=�k�!�t�d[�o�=3į�iu8��(,C�wSM�5H�������5Oz�����W�[O�PSM�(ne�	���x��`[�~��%m�T�Is��w=��6�*�1o)+,�������ޠ��=t+T��I�yVd'#~]��j���j3�N���=��j�5e�/���Tӂ��_e#���o�z���hq��8��f8�/�X�6��C�-��aی��7���/.��m�m���>U���h�S�ıS����eݹL�Wgg�E��9=zga�����!�٘�5$�����]��4��I"gN�N�J��,D?[�\�y4�юW�y}�a?�ʠI"^r����_���wV#<�Zh�UM��j�;�Bb���p�~�`�Qg(_vz2Di���d���XL�J�\ZT������_@�:�֫4c'@nǈ�[k��q�Dֱ�_�ΐ�a�fZ;�d�[�yd�脙MU'#�0�:�5ʇ�:.��4�`6��F����M�"�	ͨ�=�Vtc��`��yl��Y�8=br�FT�$Ք9 ��ZG-	E>������@�5�嗾j��*߯cQ�e�,,���'x;hsP�ōZ'��E�fg�_G�S&���ωJ���6� hu�[a/��Z�=��b�����'c*	�M�g���]�I�ڴ^�\��b�$�\���%�B�f��=�[Sqr����'�� �B!5TH����!�e�Z���&�B�E�3^�k��PZ�S4����3*3E��U.�+�mt�LO0(=U��x=��M��c��}S;-��0s:��ב
��|���e��f�URkR�+N�hՓt��IT�#�gOB6�U\�ͺsa\��u!�,�,Sz&*�/�c��+M�j�;�x��#S�ǋ9sΕg�^>ʞ���i��}:"�|�Lۋ�1��bk�6}�i[�%UpB���ЮU��Q�p[�7�6фcp3����z��!�L�����y�Ɛ4��[U��B�����u����E��*Nơ��~�d��8���d�b8�$S(��aa }�R�h���L�A$5�/k��pc�k+ER�VM�$@�ψր�:�����m��
���~�8��<�]��@S��S�d�aR
�|��E��
iN�h�R��s��>�4��"���Q�#��������5��g�]�����M\����۷��??�/��y��_�>�w�������}�����`��]�����w�����K�"�a?���>�'��G�y��F��s���
�����4����-��/dc��R�. �;��.���㦶>�z��lƮ!!�&�����:�g�|	]#�����^@��QY�pf�:i��2�$��M�`z޶7�!��w_}�C�svT�~x��^�	Q��b;��� ��j�5�i�>�N��g��z+!�7��˳Q5��֔�É�/���`nm`B`��P�Ȁ0.|�޾W�� .eGǇ�{��(Rv����@g���A"hܧ��r�Q�L����3�#x)��j}��(?�"��PC�'x�b� v�du���j?�8J4�� 2$V<`# |)o);#�RL�-q(������$u4�ɓ��Ʃ7��'?�Ĵ��j8��],�Lz�"!�S��iUՈ!�}��`�l�vk5��l��񣹪6h�m����j�R]T%�W��W(Ũ��
�A�|�Rg�
�'#��7	PTM�S�s�&��M�3�}�{M����r�^�Z@5��Y	.Yog�Z�E�/1	�ͥ������ �l�I���1<�Ԩ{'}bf����2��f'3�e0��9x)�i'��7��j����9�Jř��W!.�8�'x�$�ʳ�a�%j�#3X7I�1�=���%qG�:�Il�X�A� ����M�����[j)-iC��zh䳥"�ы8�SF��M�#�Tq@���rU�Z^Hx����䣂Vm���r3˔���4b{9�d+�x<ָ�_�	hLA�3>?��	�Ar$��6m�g]t+�S_.���@�j|��S8�$`�13	1ǂE���rP�'}�e����̓���������_�3���8C�
�3��Ϥ��������Yq��$�|!��+Z��4PWL5��%�Nt	6���A��в�ն��M)8Ė�7<+/՚7����)`��~NUE>�MJ�gA��uBY�m��y�߽�]�@OE/�NM&��@��!����Ò[�O��D*=��-G]��_/�-�>"�	��o�k�o�Q��I΄���"��J�B�{���˫I~K7eL\EL�,��<aKE<oSO��(9�^y7�����\C�;��S���p�pg���,j���ω{�GUuF��e��l��5w�!]67���� ��P��¼jK:{l�܄����;z��M�m�'�N]��P�Dы�v�����213�kM��T���4�G�����Y�w��@6�����e�Q~ij$��g�AK<
:6�Ói"�X?�}��Ҩu&���um�����US�l�+;R
��8	V�A	a�.^�p3�WT﷕wN5�JA�>6��J��]�^�#��Z�t�+��L׷Y<<\E�Q�g#u�-`�O8��0]���U�A��H_��asw�0Y���IYщ�>E\��/ I����	�����F��1"���W��SRգa��Œ�����K�˞*�Qxfo�I�ai��^l��C{�D �E�b&��s�"�Xc�:�d�5�Ղ��C��a/��������[�v7�qX䁥�W��!�l��e�f`�����z�n�e"�ܥ�`e����G/������!p鮾����-{hw��7���=���R�ñM�!M�+Ov�]V��a���,���z��^B��j��=�<c��:�f��^������;T�(������l}��C��}�&�:����Z{f�$�ՠ����};Q�n�Y�G&�xI�ꢮ)Y� >�V�ny���j�9o=��R�H�G@{���/�Y�)|tk��u(p�����nAW�C��3jN���c��6������prg�A;�y٫�jxnUgGq`*9!8��mۜw� �ddv�Z��y�?�p��qM}��&xe�(;Ɖ��t�C_Kf�ym�yM�zG,���lJiFu�teݙM"e���ρr���D�R���$�x̠�h��������M��(�ˀm�ڷJH�)z��8�ը�9>l��C����Ch*������
L��?�x�u2>�B	薎��4���Ms-��dq�>U�=�>�b<i�w�Ћ�k��������n1���� ���k��_�FN�\��F�����9�� ����m|��r��-^�����aͲ�ҚT������Rڰb@X�js�vo0������ز���&u�f�>_a((���mpR�m��s�W����lK���V�U�qp�F"C#yG;9b�eE��SK�d�@88�"��,Q�LZIWx#����e-@�w����bj~�RJh1qR�C���\��F��j���pu���Rpv�Q�ZYC~�n��i���0��v9��԰�>�H��ٓ���b�� ���ٗQ�PoU�Q���0u�ti���h00�16P�/����=�zW�W$P��@�vty;7�|��	"��N,���oV=Ս���n:���:Ǘ�
��\�klG3�����/���j��׽r�s	g��%6ÖL��E��) {����9D�5 ���]r��@���&L;���,�?�p��N;��\}x�]�U�"c�i>鍡�������js	���cD��'�hM��8�w�����0�N!0��?VcT���#���9�\�1}����B����:E�7��L��S�
���!������o��o��o%��2��"��V�jk��R�ے��DۜI��������s�Q�5h�o�b1�w,E��*���Ũ������B�W�%���D����F�B����Ý������������\�Ef,h�-�g�K�<=K�m��ו��
C2���΋�Rt5�h�*�Ob�G9#֩����)�����ė-8�F0�]�]�^��O����A�r�?�$�2��^E?+�S)�1� �j��m7v/I�9�<�4	�O" DM˱�}�+ �9jů1�F����h�EDٕ�|s�PP!�6ۓ�l̀0Zyy�"��^�`����%�i�A��Ys�u|a,��m}�1&3o��v�}�ҧ5P�ӭA��Ou�H�`#��m!��+�Ԓ�(��b%����ϦKV��UV�nFg�sk�_��p���� y̢�$V߹�7-83�w)T^��z?��i1���t%<�����s}��EߎK(z�8��$����ݔ�q�젽���������wu����ma�7w�M���+�G�����4�����b��1D�ۘ $ x�	�;��힀�*MT:�GM��}湭ֵ�5��,Y�i&��Y؎m�m��'nAP�]��߂=���C��-��$�-�����7�-�Q׬��2	ri_�-�x��I��M��,�g��5R[��4�_���}q]�Qp��'��}Ye`ç* q%)�KW[�쩧�!�
6��G��(��N���IiqPz{�]�Zsa���	�(��:��H(�S ���}�����q��{��eI���i������z
�y�~��)�FǾh�E����ܿ���G�'��2s=M�j�X�j�^�89h��D��oj36|˃�7N������Sˎ��q�f[���wQ�r@�0�<;/��[=0R�pqqݐ'V�e�"�-�?��h�I�k��؍cO V+�̂FLE,d' =�{֎�I�Yќ6v�7vog�;�����O��6w����[D���Y�� ��\��a|�w�������Z��Q{7���:���χ�ҮC���cKя01[f�|h���:4���;���-�w��(�3 wu1��Rp0K%�1}�J��B�G���v�<-:���I3��}�"0�����l�fۺP�y��nrE
�l;�<��@GP�罾W�c#!Dv���,RI�������NʕNrvq�R�Ɏ|k1�[a��{�=\}�T@6�P"�AnB�F=B-C�5k]L�lo�@�6y2�{��ƒ,oG�Pu�H�L<�t\8�b�&Q��:��8}pV�u;�)�1}n�r#���NbS�����١�h;�ۻ�{�G�L;����[��Z�&"��2i�'0�#N����6�����]�"=�ô�c�S�yW[V�z����뵔ǩH���0�t�0�9��Q�B5�$��h��fl�'��1���j,���������HԄ�x����2@k�A\,z WOr�Õ
ֺ�!ϡ��߽[�v�W�X}�Q�e�����xuR��eSʧI@�f-��b�Z�L�-��8����Y�N�YB�yMZ{��w��f��>R�w�K�c�iK�W'~ޟfCww)Pr��<��� ���x�ASrq���2�,�3dh
��w��n���~#R�e���Y�Ы_���WՑ\�	����y12 �2���w��4�Sۀ��ELJ,�����`k�����-E�I/j���e�C*�7���Q �@��{����QOpS>�س������kRJQ;W_��1Q��/�	�-��h2���0`>MG�w'��O��Q :B��b��$���\��V����<���?p�9�}�GR[H4�H���~��\����ـ8�r��by��p@ac�� |o�[��=bM�1� �?�Cc�02ޚ%�v�(�N	���A��	��cAx�,F:J�*h�۩t���ƹ���f11��Eh�K7$	?ήDܨMÍ��f��f&4^�˄��	���N�����z	��u!�c��f�� ��S�"D�R�ƪ����q�ؤ
>PQ�G"��*�<!e.Gpt��;�:U��Mi��i3V.ꫢF����'�����=G�-u�G�ŋњ�_�1�S�����dE� &oy�{��Xk�����N�j"����P�<�+�z��L��"��@��J���^�� �����#{V�H>�����f�V�N��1���y���rۤ(�d} ��{W��}��������w�����Y��O'���Y��[���?�/��|g�ރ;�������̪_�t}L[��^��_���%���d���o����8��iY��-Γ��X�W���z���k������_�Ϯ� ��G�W��q�������������wnߺw�Z�������T����������\����'Sb�����t
�G敎�8���?� c){-���t̺_�i�\�"�r��&�A���	I��DWh��TK#<�?�<��`�}����'�C�^28����Rn��'������@q�Do��K�jeǽA��Y���Ő#����a\A�����#Di�;ļ�k��Y���&�^s�,�,:	Cᷤ�߆�.ŸN�@VQ �I�q� *�a;�m�2���*Ҽ�ghF��C4�x�f�VD��c���K�Ņ�ˎ֟ng�O���;��j�F��&#��iCpW�Yf�Co��)�_ؔ7���Kχt���{�6����K��0k�E�����ա�0�ה&���I7�V�#s��4�cV<�ؕ]yEh���&�S�f�nzD=�irVw?{7�����K8 '�� �|/OMe=�1�[j�7���iR�0�6	^"ό��ĸ*F��K�"#܅EjZߌ$$rӆܪ����9׃�\ٜ �Ǡ�(C9�ѥ�[��w�uBqd��ا�G�h����`~�������DȒ4S�D�^��;�L�1��:=r�=\O����9$�9ӏc�&�$�r�+ê�������.%�Yś���ϣ�g�	�kX�q����Q7&�L�_�=,D�"�x����ئ���p*)�������=Y�N� {�,7# Uڵyg�۪��N��~��V�;I�1��FVE��QG܄��s�g�Z�j� $f̟��x;q#Ɇ�Bo�kZ�A�r�s(Q���+��OJ�p|�b�KI�QT�P<ܧ���} A>�4�$`�F�gT��i/W3�m���0�����e]ObS��ޅ�;P <�� 5�]�8D�8-_{�LC�
�%gWKn}��1�6MC����`��gX/0=_:c��� ҹ9��(8L�]��ŕ@��s�vrl�#��TU/qĪ9T�U4)ކ�m�ȑ�Ow̡.��n��A�"�?�Űt�)�D��^�Q�Ȼ	���_/eŸ���P����UڒL��x�-���Gj ����}h��ȁB�0�2jb��=��5?@
��^���	K�\Hјi��c)�:���Bbgk[�Qr����}1�,5��p�kٿ!^�(.xi�r�:mn�f�$�a�3��R5�1���H#��V ��r�x�􊯐s�x(9S�jF�b���d�}o2i��,� �@��w1��i�!HQSӆhC�7,;��Վ��~���r:�vو��W��D8�E5�u?������&>BZ̏ٗ]�IISM^D҅�h�aC���ڱ[�8R8�<�k�GQ2�W�fV|�E���%g}�&9���Z�w¸Ķ�A�������������������f���Ԭ+��dn8`K�wfN�2-�-%"�o�d�*O/�B;Ea��S�R�� {�s(m\��j'fo���k���r�/]M�ӡ��ZjMm�E�7. =?l�L�I�D$��R�6g���U3`?P'��Z3�	磗ZCV�7^�u��D���S|�u�y��pt�5� ���0�?�ȯ�]-MVp��m�R�Μ��G6��nOvY���`撔ܬ�(������M(�)���r�����\����[�A����fQ�x�św���Pڟs���=�BP�^�P��A�G��T~d��`�*f�"QG���KP�X$=*����慎�MES��~�/�܉�Nn������:f�݀U9�=E�C����cA�0���ş߯/�|F\����� 0�C���/cs�லM�05A㲇��҄��Q}TLW�����`e�h�P`J��[E�Z�B��Qh�Q|��gV�8JG������W4wfpJ!�P^�s�$���E��0&Ν��"h�b�	��ig&��*��G�Ρ��&�q
F'J6k������Cx�pMp�2���iC�S�U^ޅ��(��,������JgRY�W���wA>q��>*#l����:��ŷ^x�
貮֩�sp��yW�H����_�r.�ρ�uw6�������*I�3`1��ܞK2]�<`��lp���E�rR/��oY�0�n~���1�oZ���bD�>M6A8ò�1_0�8��������O�B}aIk�5d�[v����j�̡�Wx��Z�6���*�V���7���ss��,Ķ�&���%���^J���V��jۺ���K��٪�X�a�Ǹ���|�5隵�l����#����xf�Ӱ{�^��]������f;��l�N�j�Uo�?>Vk��,���Td��� �h��#���Ϡ*�������f�^-��s�T�۰-����b?��Z�l#{Xv�y�_�b�Q˰����-g�e�7�o��y`X�ǟ�K}�{�Մ�>|�`�5��=�����l6�C���U$�k1�#;�c��Ϲ�QR����W�D�22(J��c�S1��Y�ʳ���� ��^E�y�{=6?���{��o�ln�1�l����ݚϏ?�6�����B4�#��O��?�n�בk��^x塣����%�&o����:	�9�H��ext���Qb�O�-����Ϊ�cݍ�H�6;B*mG:B�0�Fאݸgް��T��%z[v����ۣ�W�/�7ll(���}��[�ۿ�����[[_m��^�5��ozy��R��������M/��^>lz�ȼܸ�y�{��~yk��W���㦗?�˭��[[[�K��AU����l9�3�&�U�q�5SgC�Dr�=P�B�H����!�Cu�;ϵ�A������p�T�h`U�#����!�{��N���QQ%3t���ٜ;��2�K��Y���!+����3�j@I>�Ʀ�%�=����N����(h�1X��%p�S�x�z�D7H�W�&�r�L`if�0Z���т^�����{����yctT+�ѣm<$3
d��j,��jO3�{�q]C��ȲƮ	h�zs�&��p]��_�k����Dp�VA��J�C�4q	+2Q��e��H��j��� �n3S;��eu�F81�jA�ҾƝ1:�oh8�?�R�׭N�]��u,�Z���G�7}��Ðl]|��!��u��C�������g�S:�;�W�6���n5`	�l���,��jyɯQ�1��o��?�����T��9��ŀ�G����;����w����5�~49p��ϻ�}������۷n}�������_�/������������W�[�����%�?c\0�#@�X�{Z_ޜ�ի�x��Q����Papp(����	�Rg�\L���s�Rs�|����s�<�ƒw�7�clL��6m�1	'
��3��n��v��yյ����M�l���y�?����~�Y/��A�����?�q�G�[�x�om�&���w[�:��X�~1��5���z_�� �#R;����d�ߚN�fRNE���&c<O��pT�tI~����).��'pQ���^��թ��b�-��o���:{U�ȇ��uu9۩� �#/
��=r%�\Y�oLw\�[B�W��^"�p�ݷ��{�!��ۇ�k�=�2��/庬z��%%���!�!���)��'���tg�L��5����6�i�8a�!�E��v��w�9�7Fիde���U��������ݝG������~��8f�F�`�P�³���>d ɕ؀��"P�I(ja�]�a�*p��I�a$r���`̹���3X�D��A��{(���0dy�����0{��lJ���cJF��#�p$��@2�N�1�!��5�31"�~��Xۻ��[q�5P'�uʴ#��AתFk\��_�a������E����u�=�?�����g������kN��"���Eg2.��wy��S<�ȩ�ՅS��h�B:�C�>�M�BJ#��X�����$��"3dfg9��Np��A�RƠ 4�j�]w�Erc�b,+.��ĕ�w�m�A4���rk��Q�ڔ��������u��/�m��I׿ˌִ�� �!?V!@�ݚ���R�{�\�=Y*zÉp�x��p�����2��n��/���ˊt�2��s��s�LB���_��hP\J��0�D"hB���(m�.�e�"),*�4�W�9K���{z�4�Sԝ���r}�\|4+�Q0�uw?ww�bN /].]I�̖�����Ǧ��އ��ь͡�x�O1*.$N��"���_�a6�=)�đ)	��V(�D2@�m�t��3��	y&z��w�';�����2ؾ��Ym������Yw�&�i6��J-�E-��B�L�=[�Uzȗ�r-�N� ~3*_e�L�?ƃ�ft�ޜ��t�0`dV�5���,��Wm�n�����]���O��m\mɘ�0�1���R�'��,�[.����28�kgjo��H�`�63@�-��I[M�n?ΥW/�+��P�-t}_W�ru6~��i�l�6ؒ�`&�L�b[xF�/����_���ڙ�;n��\��ף���Z0�u_)=Ǎ[��9�c���3��D/5?�]�
t�z�C|���	� ���)�#
ޠ�ԗ����ܝ���7����L�����
K6r�e<=�f��`#磳bµ ��6gU��U�Vv�E"�:îD�G��;!n��2�]�f��8��e���H�R�8)c��,��O�Z7�ww���n����v�'h�q�K�u� Uȸ��Wggv<E�C%bG�0R4��|��é,��Y+��z:`ʹ(�y�U���tἇ�ۇ�p~L�Ҁʏ].0��%ӁP��c�R�Ze����Y��a�������
u~�D�|�����6���R��rX�=J��E�٠�xAj5��a��� k
n�)����n��ٖ W,ڢIr;L�OcX,M�l�-j��|�c�����;�=��=�EI�mb<`���|R�;�w8�'�܉���l�t@YX?��:=H�,þWx*Vڝ�&օ>s��:Z����ͱ5���˂���᷂����y9궆J%�t��{FoF�=D+��$"�����%�-�i�q��E�5,��0���a���0����Y>p���S� �S�$������@$K�D4c̫RIV%*"֕���ޔI�b� �4�Δ�m�D�6�ߕ��|@!߫B�F�����y�4�dN�q/��Ƕ6�,32��~Fɠ��h��\1�{I����X-\p'q��݈ҵ�&4(#�� P�=�Pw��R��p!�F鏖7Y��Ժ�s�{����F(P�g1�ib-oi΂�q�2<'�514Rg�jN��!���� ���Q�|e���RN�E��s���,�䦭�D���.1�h���-b����w��K��u29;�r[�-bR��b�
R����I�C�Գ�8j�v��50��?Eげ3r��6Lk၂��je�����]~��#.�reڨ��v��v�
x񚡍UJݢx�=C�Lu�[��\�׈�%�U4�ijԓ!n�Vሪ6:�n�#",D�Ý-Zb`986>�h9;�Z��A�R	����!ޕ,+YNS�ܒ�#R��ɠT'�pVG-��ɵ�e:�/�-���P��@�w�Y6ϝ��M�M9�S��:�?��G�DU�ϫ
�'�ݓ��Z���)���nn�\d]=�Vk7��+�Y�z;��.�u �s�t������(�
�!��`#L�.��G=�NIU�i�%�_xw6����7&g�9-r�<���Z7`�^h�Xy��a:v�t�i���B��8h(yJ�]˛q#�E�4���l�a�!,o�n]z�"�M��I�(4���(nxM±���Gw;��.iAy���H^��'J�G�����r��OX;�?�QS� A�)$�ٳ���Iw�QJ,�bY0%�H3&"��`��V���L(�TH߉����&��NH�e������^А�&��CCU��/2^Io�^���m�Zٽ�Z461�%��	=*{�/^���&G!uH������ꠙ�>��ا��L��!��M�����o�����-������X�XGn=?�4w�&aQ��@�'��L�A�4�%]	+�x���r{H	�b�/�������6�zn����4b�@-���V�l?7�a����5��{�������.U�Yqb�f��?#�Q���~~/AU}��XO~�B�S�cJ:+��*#����o��;s+v� OϷ�ie�n�� U�6�]�>'4;�i��0���
����"�|G��ߏ��w���?4�8T���Cq3`B����-��{O��ϕ�hm������Ni��o����9��}+S��TSvl��J?o����ѻc���P��k	�d#𠚲gf$W�Q��y�{yք�����k��1�]�˽&���K[jrB�u�,�||n����‖�yS"[�m�ma�,he���f��k6q���B����ؗ����؉x$��'��z���/�AJV#�t��8��	>�;J�t*�2{U��6�(50����{�ߜ��I]����x�Ă/�Z6��
����1�#I�o�$��-���d���"A�W`W��x���G}-��n�.I~��;�dq�"��t�F��=��9w�^�c_'�F�N6>`������&C� ��|#�غy���2�U^	4�"��(M��P*�eii�{��8R	�V�H�/����"��?�ݙ�����	��^+����I�:/��3k��Wv�n9�'+@b�&ʇ�#-V�P�O�w,H��>f��:��jĽ�Tݩ>>����fڴF�NS��2U�^^�����s�,:�4cF��c%9J�r"������P�J%��}w��Z6��H�ח�x��U��aN,|Jl��3ؗ7��DIE'�(��}1� �iOXi�!w�#��"��7S�Zv�%/(��6s+��c�|��_'NuJ�д4`��M�w�di����S�%D>8m����+� |�V@a&��6Ei�F�*Z�޼�U߽�����/0�ԧL��}��Q2@3��n�64H�先��X>�hJE�Z�Rg�k�<�lDuJ~q
� �&�A���񡵗޷�Cx~����D�P�1e�$�-[�� 1����T1�g���ûF9���C�Ѐ->d�j/��9��3"�4��a	J٥��7�.υ�	A<Z�X-$�Sꀜ�����)L|�ok�*�g�(��Ƅ ���d�R3�R~-dT��d�g�Е��\C��3w��&�~>��ħb�ug�0)y�&"W���߽��5��S=� (
��>����'��<��`�xt����L�'�����\*�y�cZ�]���jTM��{��2ōAlI�Π�ķ� ��.#����{w|k������9a�-�t��yku�(���'�u1*�+���r�(�џN���	0�WW�,�׏��9�~�M>6A�����J�) �mE��W9ԍ�.lZ��K٧��2Ǜkl�7",aR�a���F\m|*�]hj�F`v��������~���§�����^�}��5���׀�������?�<�����s����w��X��������}�����޿��[��ܿ���_�3�9�3���gi�.F�A@�O��9�D$������t0�E�D�.ơ<�%ڤ?�� �e��hy0�Q������e�?�!���9�j
�'?p���![�m����Wa.0�mF�ϲ��.��l�U\�Һ�v�a�SR2���fPѬ<%,�҅�t�g�[z�o���')R��%BH����'����>���x�;��ޥ)��1�h)�M<�\����]���{uP^��3��X��O&�����-��m,�Q>�4"��C�#�ca��V���]�JS>���Z��H�W9�Q��2)����!�f]YtGU�����kK4y�䕾��6QdW�\�[� n�?�C3�bP�ʙ�D�솱����6��:�ȓ���HdC�PK��󋜀V��d���N���:n�[��+�C�m޲V��h	}��w��1�5�OD���y��F��=�-��C�6�P1Щ�τ�4L���%wᆈn�<�}���ڇ.N^��H!հٹ���(��2#�\�>���j�q�Ð��r.�4������fm6�j�؉F�|l�2�����QN�4Ѹ� b5z�m:Qmȫ�4����`��Y�����%/�cR�	�qv�~0.�¿ݩ(�;��;�y����%��p��'�����!`��g�(�l|k��e<����6!��cj`�r�(#q�\7x��9/ş=y�Dnt��n4�.g䦓���Q�-Z��i�R�Ql�Cč���lP����2�� rmΌ�_���Ia��Ԕ���[���v:y8Tvh���6����u�,�^$���I<�x���#�}ퟞҕc|�J�d��Ӽ��縵�=e�?�b�[&}��LN��k_���]j���r:7W�+��!�-�=�Eg9�ch���:����&wP�8˩Q�z���η9�q��]!^���"/�l��I�v�t�9C�"���.�M��S�&uxrڤ�TqCC����c z6���x7��&z�LAt&<����+Sځl,p�R�:� L�d읨���pD0�}&P�v��@�0{Q<����lAd�%5��/�C�pb�'_+�����!��$��T�@���K\���0���~��8��1\�+NԘ���7��D��S�I}6�FC�(�M �rn>*�sR�p�ū�-:���e�5�v��RpU�MĘh�c�Sp/��[���}ǜ�<�a��BY��Z/H��W��8�{�il���v�b"#��|�4(���N��;+~���P�u<���Vǟ��@�6�R_�h�4�q�F4�Ɇ��)��&�_�NOA�&_����q����)��5L���qd��_�#�^�q����1W"���f@1���LY�f�i����4�ۜ�Q��j4EV���p��`^��Kb��켬NO���� 9c��`U�8W�i�
(����� U��<��s>d�ͪ73:E�B��D�xDh�fQؒ�Ȟ!���?1V�u�	��Qk�
î�:����$���HK.󶘀?LH�6��9_ �bǫ�cQ���Q:r)2$��}�ye]1 �x�j��lﹶ0��:Q]�s����;��Z1��c|��N�C9�?lIcWD=O��+�R1q#5��,v\�䐶���HlP��UG���o���]L�S�[ϞC���('������"��ìѬ�����	��q��^��~�˃��߇x>~��bc�������-�������m?U�Ք:�	�~�';:�@�g=ȣ@XnmΎs	a���?�әRG�����2��j�hC<�AI�8
��X�����]E+�?��6������B_Ш����{	�a4����mGpR����Y���z
q��j���'B�9�m
������"'�����U�;�Īc�W�7���� �\wf"'��W�ɚ� y��� a
��geG�4�[�6�bɠ����ɦ>1f�ج�� j��v�v^��t�
� Z���>o�t��Ya�X�W�KHP��?�kr�Aץ|��@GK�9Z"��<�>��	��,k�N�+����ptV�WJ����1�����Y�x��2�`$��G�n����7����������V4���S{5�}-�%$�� I��7�IM�]X5:H ��Y�����%`��$�Czt�M���kJ���S���IߞB:����͙�.kۭ��0u5��Z�w/@�HJ��n�W��!D2�A>�����l$�[�{���R���y�V�P3M�R/1IJ	�����[sfC�3U�e��!1���+�a�uι����� z>���9"��B��@l�?>����w�XXl�r�^P�p����R����)6�'�kuK��0!�˲��zQ���À�H���G���\���Z�W�"U1�0����w�V޼���_����{-�[vC3��{���u�����=�a(Ꞻy�=���L���[H ��7dpj��
�@�������p�����<5�6!ң�w��1�{�Æ�I��y/�!���n�$���/���AI���p/b���D����	�o!֟�xP��H�-��zxY����Jj���l5a�.��c���΃�l��}#X�͗���y<ɸ�`��3�;k[�,� AL�Hǁ��{���?��i'J(�f=��`�Dͤ6`�XG�%ܲDf���js �p�~�?����e�[����t��\�!�j��-IUc��&�,W�Q�a��6
nx #��f��r�]�jg�5����ϻDy�~�����z� :)��V ��ڎ�M��`:0��?�2� ����������6��%/��?����wnݽ���<����_��!���Ɂ���߽���u����%��o�����W�����_���w������������;��?�嗈�Op����I�4��ֹ8�:�%���'��^�p�6R�9S^�j �ct �'un{kQ�'���cc��C6ϖ��:�݂#ϸzY4 K�9k�Z�<ʾB�x� ;X��K�&� �#o2�ɨ,N��-�6z(I_+�1�;�68d�E8ī3�:9�ꢄ1�y���h�O���C2ф�hD ���A���C�j���+�Kb��	d.;)��-gG�O���'�O���^jۥG�K��7j8$�+�)/���\z�z��N�Gs���{�1�ݪ��:L{d#��Z�2��p� �:tCv����1�ц	�c�~n6��#^�[:��~�k����1�k�=�j�4��d��w�ˬ����w����d����7�qRd�E&�[t7��*�����:�_1bL]�dbK=���W:��8��>�:�[�c4��e<�͂�X�j[�-�,ޫ�X���r���pu���>u?[�����ٍͦx��G�8��B���¹Lrl��͉\"n-� ,�G\�`7�,0˒��ng��J[ሳ�"[�"�� ��3~n��c����_{�����s�&2y��FE�%('�'���֏��x\�۷�x��JĽ��������ݗ���a- N=8�,^��"��Y�O�m�A����z�Ω����Z�8S�^|~̻����V�{>���~Y���"'؜If\_��R}[�g�G�l�uL�Ƞ��y�y�+�nªU����:d?c)��8
�AF[76�Zp�8�4=t��Ge5�}�Quڧ�\MW�$��CnVmC�6%1
��`}.j�r��ƨ��� ��"�p78(�k��5�+h��bG�;Yz�0�'���^� ���>'wz��l\4�<�x}���l0|���S�8��dO�pEÜ�\��t��3���N&j�,�SPf譁����<؄�S��#-� 襬w��J�/��Q��K�%����!��o�V�!1UT�ĪSR�D���JԱ��	�R�,F�ƄM�h�Kq�4�'�'�&�o�l}r\Â4�����i:P��<���Ǹ͍5���併lk��Q͖������E5��/Ê�6�_�	w�CɌz��m0ӝ|�([���:ah2gU��.�b:H�LU �V��jE��2Ű�f�U/�A��sd��.ۦ npSrQMa������-�I���v �Y}��}a�����b�T�7�o�-���}e��Y���[�|���gN��(@&��c�Ί��XX���%g}5(9������x���O��rpGĚѓ����������kQ!B��J��;s#��坙���%W��YD+O�D�^f�D������U��R���[xL�|���T�{�/�;nt�9%�`��>�$���Vq[C�/���!;8D'b� ���h�aՃ����蒈 OX�{#�t-�4KW�»��ְ�6�'����w�6��9���������m���ذ�x��_o��sdg��V��b����'��Ry�1�{7��nO2J������:s�U��{rt����Z�F@�d�W���!��A3C�DتE�)v�˚e���8�����}���'���l"ĭm�W(A?����W~i���a*f�"�H�a�>N�ص~z�>4��?���_�=���`�2��l�FsQ
N9�mP.�&	�[�g0yd�^�����JL ( ��~}�	�K��c����]�d�A�����6���,��v�}���GC���"�P{�F�� 6��H��^��l�߷����Bm/��"�-�0���3� �\IaLU�`ѧ�V������>�&|�CxT���l��u�w^z�" �������ZB_V�U�>�b��\A��S0:[�Y�A�7_�csH��a����Ŷ ������ex��ޚ�@�^~� I�10��uq���Z,U�P��#��G�"�B�?�b���� v)�]����Tݍ`�;��21E�?,ℏ#Hw��BL���
!Œ�+=��^\
X�����C��r�	��0؅�̫̉�0Tz����:�]�a)�ԁ���#����9,0��1�L�p$'(M����Xg �'��j8��xn�5�CvȶtIc�w�b���a[W3���{G��a�Ǹ���d`]S��2�
�VaȈ7������^�g ����ߑdKz��ߚ��?>Vk�4.M��Ve�1܄�!"���xv_1��$��a�5؃����>��Pqy��qYA�/���=�6BH��뾶9�S� �FKm<+c���ÿ�7�y+�R�0_x5����k �p����1��
�ƪ�ԫ������O�������Da�/?f��O`{�D A<�|362}�x�U�A�g�2ql�~b��B��q�
k0b\?ت?>���5�0m���6l���"��G�'���l7��ȫ�xN/���������D����NycN��ext���ц�c���7�/�:���u�r�9;B*mG:B�2�Fאݸg鰗�T��E�s��kɞ�;ۙ�G@	M$�� �D_�7�<lz��O���r���æ���ˍ���������_mz/��^���ؗ����>�ʙs9V1�g��">qC{yR�CDE>�h3@	`@L�)��r�qV�7� bjY\�����0>"9l��~Dm��~���j%ګ�87�cu�i��Gm�������[{Fz�"j�u�2�n9;���FN�
�ˁ�E�D7\����@īp�M� �pb;ZP�09=D@����;�7PG��Q]��g�gƃ��zM$���y�9.z��	���B���uX�a �F�8�w�����׳�yJ�D�bu���/��Ay<������<�X�;
�9�9��Ɏ����N��;�wz���p�����p8�e����&�!w����|��I`�3����@��n]}2���Z�lN
<c�	�L���Y��ފ�yG�m3�/g�bRൻtQ0��3��0/�b�s�_$�צ�k1������z��u��g�]�����M�O����������}���:����?��?=����a��������%�C.�ӡ��į����m�幙�~m�c��X7m-A6���Aل�aC�~.���:�"r:���%�r�mW�uؕ4��m~ZH{��䙓��T�X^�ↇ�ʻ]��ž��/)���w½�%�U�	��E���v���u"-�l<e�ƥ�{ɶeb��Dߑ�"I�[U�1��f8�S��r|vo�=.�Kv7;�&�z�m�9;dp2��w:U�V��nN�x]�ݺ�/^fh��Y[&����R�b߾П������C����^A��ۺ�
L������	�{$�����RN.r���%���z͵����!�!+	�'Y�An\)�1q$�$p��oR8��=�`�1.E&^
��-��%�j"��n2)�'��n��zn� �1^�!�g��ԿB.����z�/�����4����}�>�y:��q���5����F��ȏ'�"d�v(�\�\ZkJ���#Mc�u֋�[���N
���{j �.����F��99#� �7����U�N #x���.R]l�s�{x�N���sj-v͵H�*_ϛ��"id!*����8�{p;u�#xUv�
ǚ�:K��a�Rd�'����P�r{9����&X�����}h�t�.�<�ȩex� ~*��J�n�vvY�1�U���5f_�ލE""��e����̚y��o��z�F�8������e�[H�
m�T@�E��QK@d�jC�������3�1q��<Ğ{���=w^�O�g�!��xEh���Ua�x(��#�nP�L�Ю�P�n�`v�(�:ńCY�:>��8t��p4o�7��_ �E4��rZ4�����sb@Ɍ�+�{_�7�@���UJ5$	,�59P=c���3R9]�����yw,q~��bgw�h�fƱ�:$$�Hy��3��S����Aй��諾�Y����;q:�O��4q$,�ܛ�gN���y$����HH*Z9��L��hzK�F�z�P	�^}o]�}�G?>�tZ���w��g��� t��S���6��u1n�2�<�3��^@磾�,���t�2C�ޔ����ݕ��q�8i��o�O�B�!�����%��,�l]j(���(�e�͕��lR*��.�e�J��d��\3�vJ�O|�8[2;TX��w;�� /���h����w)�E�e����&��J��|���nNNj�8��z�}m�nٺ@�Z���l�	a�B�P�	�:� ���W�^�!�4|���b�ڙ�T�_��^_�}�e^���ި�Zּ|�굔���탲��&���׾&��.�	>?7,�y^�,���k�wCTy��5���Vbx�ǧ����O��+��^n1AM�����L��xS���h��YG��M�����	�4��]���������������H�x�7�d�j�l�"47h/Ha�M��M�������5G�<�y�LR���O�ھY�}ʆ@,�,�|cM;�J��@ep�'{�?b�V�F ��;?� 4w��x�V�N�����	��V�0��+8�\�v�ʟI��-N#�[�x	t�#�̺䭋X�'*Qݜ�j��hs3�Zkm�� O-���	��^j۾��I>c��:�A��K@�̛)(��d����ه��H�߅���l}j��"` c{�Dy�`��jٞ.���S}%����r�ؘp�mD9��?8q��PV���E�Up�@���� ;;�!��M�䜷I9u��;K��1�p����ķ�ZJ�k?`�ܼ�Ss-�}l	Y�?�m�Ο��1QD��ޮ��^����rx=u��{y���T����v��:@��"���0�]��M��l� j1
������?׺���8v����.DG����͏��1��(v�Ӎ���J@됥��z�'�׷����t���۹��b�JV�`�i���@���̴��i�|�A"�Br��֓bp��]]\}�1�6���ql��k
jYh�v)����@�������_��dx�Š���:�\�<i��D���ZTC��[�6�#+����V���KC�.��{��>�vh�)������j��-b�]䑾��a��ꯐ[���y2Q6N���s"��� /���-Z��c��[��� p��ߗ��W-l�G�n �-Q?��g�e��j��� i'/�>sԺ����v&�.|⏋��蚶��?���.�r�v>w�?Y�ޖU�4zHn=۹.xO�-9�aE�z˳�^������Е>S�_Y*�sg"�Z�,�Y���~]�@M���^aJ]=�#~��Ծ9�%KO��-{݆�� ��p�\�8Fr~7�G���ࡍ����p�<��2�&�{����L��yS]Gb�iL��ft�������i��Z����W�_���+�-�_����+��x�����������������ю�u\��?��� ��W�P�	�b9 ׻䔚 )N����: yƗ �9� �@+Њ��H,�k�b@�T`t�d8�@�^W& �6��pէ"(cR$Puz���ruv��S0~��RL��M^F�R﫳(�����T$A+�Y��f�b��2�6E�M�tM�Q^� ���j�G�P�姬ln=I��^�h�hL��W�v0�+��|]>�2t:�j�Z��A������>UY�:8I��c���F:`U���|YY9E���8#�i5,�Tc	~q���j��χXBb�Q�/z����j�Mރ�E*
Ч����/��$o�^�=��HѲM�|-HQ��B�_mD�aCz��.z�O���nD�!�̵Z]�T!�@G�Һ^�],��ʹ�Tp �2��q��8�Z�B .�@f��~�H;Ѝ�b}��Y�<��W)��g%�BGOO�|�/��e�W͌��D@k�.M��C���L�E�IJ�,�+]����4�j���BI	2]W��Z\�D��
t���d&��bZ�fU(8A"�Nu"�3��8�Z�'"N
�p�Q� �=J���޳Ҥ ��$LAB���:EP����&ITD�Mu*�g��b�(|J�
�\݄gmB��]���A��EԻ +�Bы�5V��1�X�r����0�I�Z�D�0سMW#8�O���4�hI�c؆p7�oa *�grS=���8i%y/��FB9��F���	o\B��7��8Ҡ$��{��l/V�8G �r
�Υ/�<�EZ|��`N@ZՎ�j�����?C1� �                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     