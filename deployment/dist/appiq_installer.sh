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

__ARCHIVE_BELOW__� Y��h �Ks#Ir0X3f2�����=� k�
]� YE5��!X�=jղ�@��a"�� ��5�{Z�]��L+�t�q���������{�##�^3�&��������Wxx���� �ky���{��h4�77=�w���X�`����^s����n67כ^����޼�5>>�g��~
�\��qV�28 f�ú����|��o������;�{ދ����?���_��5��=�����X�����K�3��k�g��/zɨ��q�\���{?������K��?��=t��S�9�o�~?HW?����k�o56��y7���'����(G������vsssc��Ӵ�p�������O:�^��o�<O�������h��������������B����*���?�8�T?ڪ_�Pm�[��^,��܂�����??�����l���Q@?k�4ɲ�8��A���S�e0[����������Q>w��O�����_>0w���������1>n�ok���z�����g�������s�?,z{���57������O�~��</�GA�;"�N����1� 	{I���������G?�zi8�C|�IF�4q^�I<�+(pD�x�!�y�d<N�<�/��$z��$σ���w�����ϱ����� 
zج���>T�a�՗��3�J�;��Z���A��~���ԏ�h�����x����Ԃ�q� >T��$='�;ާ �~�뿲�7I�|jT���a/[�N��A�\s�V��5�WZ�:�E� �~m��mH��Y�i8p�ir=�*dfU��j�<��8�ߍy�}>����I��ڸ���lnl������~ҟ��߻�뿱m�ۍ;��|�:����lݙ��2���I���_��a�q'�?�g����1���?�o��y ��2c�l�l�B?
� ��<�v��aDJkp<�k����0�0��K�r�0#?�#�������Q>w��O�3_�w>�����ڝ��1>%������������)��ߟ����77m���ھ��}��,���р���?���aJ�~��m���>\෠�f��~�.�I���1n��dT����f�"�S�7�9��[o����)���<o�����������>w��O�3_�w>0w���7�w�������?�h<|pg ������'�����[kw���3K��c�����?������nq[�m/���'�!�h��L�?;{���~?uv��C��O�V�^���Ѹ���8�;��'���>0w����������G���Ç������?�[���7}��F�^��k���;���?|���<���﹍�����om����8�;��'������|�v�\�����?�����6�[��;�������������V�����>ʧV�-�I�<��iҟ�r�ȏ�6ҥq�fI췼n�IZf�<�-y��Ӆk��G^y�1�'���~#�{>V�ա�N�y�Y�'����a��A�6�h#ͻ��:lWy��A؃����I���x�p���0 ��}�2�7�(_5�0�r�	/b�h�B�t�-��8��P2�ϟ#l�����i���+��W<���N��;f0V�4��0��]J$z4��~҃�oV��ۼ��LA��`�adD��}���\����{����f&
�7���(���x�j��.�"�'�0��tBY��=�j]��]�x�a��|�xȉ�uo7�Mط*�ڲ5��hZF{�t�+�MUH��^4�3��?ͺw�>C��Oԥcs�>��n0�ђN!F��M&iL3��0���ٸ����<��d�� � ��4��{��$Q�q����~8)n���������N���N���h0շ�>����U�qjc��$Z�+���q?M¾X��Ј�D!�#�qAޑ�0�FT���ui���xb]���i��H��n�:N1��ef���X��`�%���&1M*p�|J���)T�&q�;�°��<B5��G�fd�0>�(�n`�ٸ�I漠��͒����`E�:�qྡྷN~��x�#H�(���f�0�ϡ�Z���S�"��O�}l�7�E�2� ��h'8��d��`�R+0���>߃���0����0�k�/��������l��w����܃�7���b�`�=׻f�8��.<��je䉔�|���l��/٨7�IQ$~l{����s	Յ��J���Feri�2�@F�L��4r���91��bjpy�)��*Y�O�XQl���:�ㇺ���S����A����o��ZWP��������l{O)ǜ۶`�ռS��\���9gi ��1��9-�ؿ
/��\��&��+?@�@��� � � ,L�MF?�zQB�H1�#{��g��p2:��>�×0�+�c�1�%��?S� :s�������	�8zE2I��8vM2�#����wm5l�X�%A�p�v��$F�C����a)&�+̪.tJf}eՐ���� ��`� ��d�n�v������dD��.��7A�A&^0�#EM�>�pJ���. �
��AF��-?N�m�P�PuJ�E	l����t0��\��{�'~ڇ5O�8n�Ƌ��ڰ�˝0y
���K�HY�G�5����	L&�2\�]��>.�_)��O-���(8���ya��n�~��I]L�cF��ٯX� Wc.�Β+�X��z�(׏�T戈,��5�0A	�@B4���E
���4@��%.d�r`�� ���h��ͷ\Z��KY�3�!
�4�ķ纍^"`}����/�|�9��[R��v�|�!c6>ϒ䢤E�\�|c����Bw96��80r��r�a�"��P��W�L_�c�v����9z܄Hc<L �(<O} ��:k��1�r��/0$X{{<Ɇ^��ښ�ӛ��Ă@#���O�+/>����l��dW�/D?8� �������z��節5%���&�^$���XdC�,r=����{?���j���)�b]`K�`�;f�����w�}��g���x7�������?�#����$>,�2��'�F��#_��Āt&#���0�+r��B�.�0��.p�:�	�I@�ȡI2����0�8�&WU����p���/⠆��bt�C��%��7 ��ƶM���Nm���v��w�3�C����`l��a�*@�g��;f�B�0�If�A�ψZ���xu[v̠#G�-�5�N^e*Ba�Q�F>H�!)-��,L��_��2C6􅦑Yo4FEp]� �f�q�㡌C�R�P�|���z�:x��	դuC���fv�D -�v�*��roL���D��Yq!I�}|�E���:��Z�W�2|�k����?��7��Τ��)OlW���ܪX���l�6��A���0b�KX�O��CÔ�^WS聂�2�ƭ�R�E��$�����%�&�����,Z�m�/&�̡&ul�$Ȳ|1CR.�%�l`��������-4튜��N�E�9�QV�M�Xd�:��ZaN����%5Y=�.�Z7qg�vG�0��$���~�T�ߟD�a	����0�
�+�`t(x�\��nM��|S</&��b��LS���b�4�`�R�Q� �\���m ^h�8v���}�~fD�-��������$cD|�G�1�'!����?�S\��dXő���wk��
� wȸ�ٝ�F���V����wo>�D��4$���ĉ,J+���X���{#�]�b7� g!��o�	�m�ݘ�:
��W�A������<I@�2{#@cu�gp�~Ѧ�aqzU��A��|�#���.�W�i�-��~02�K�7�mL=���)Zp�d�q��� ?F���);�Cid��h@��@cc�ib&�����2��K��-�`̍ٗ܊Ԗ2�(��m~U��+SJPZ5�8����*�DM�TB}�}�ĵ9���$`�h��y��- �h�"�.A��$� ��صِ᷉�-J&d���
����NǂY�z�T˘�K�L�'9E���H�+�7�,bX"��'+^�s�^��7Utk�.�R��z�&��*�"G��r6��^F	��U��4T��h�������5�5��K~��M�q�[C u.&8��)̀
[P0�H�e��f�~Ñu�l�����c�~��Q��ȟ�G�vx��T�*�x��ZoՉ~�Km��brN��3Ή�:B^�i�C����D����k�46m	NH����m���J{~�emj�n.��IU�x��QRFȚ��� R�|���| Y��J �i^A�6Ӕ�b�.V�	7�9s�N��Q�v�9I��s�� �n�>	yi��2�����AH
����*��"�xY��
+O��+E�e�p�i
���]�jOb�7��A8W�;�Ig�;���>|���/�{�eK=�z��k��mS)u��� >ë��uOW���x��C��:,�Q8��/��M�S�%w1��0㶝��Y�y���YO�k���8���m��rY��4۞�[���*�^1���KGj�k'^T"��V�q9���&Q��@y����i9���Q�Yߜ����Mtl��Z��?O8�}�'����݌�P_2,Q��ῂ�k�2����>�\�4R�2�\E%I��>�D .�"�HQ���M?uǃ����X�B�'nd�0�$�%��HcӶ:� �x\��;�&��O�}�r�����ԆNXw�� �)'cA��r�ı��Ԗ�AN?����߂{�iv�	������X���7��R���X�U\cy��a��|ݢ->���%}�G9"�T��g!'a�{��mx0���W�Ap��DT��u�\ā�m��j6���\,�p�G�!h�b,����D�F�]P�vnS99��?4��ˣ�gTVN*/�I��u�؝��B�i�Ln� �d�u�9eu08���/j��Z&����q!R�6W[IΉ�s\�@Q?
��d?���w��`j�+0� +pfU!��ۼ���z���v&.Jë�*��$����9^lLWwt�+fHg�KKZ��Bq�21d�JD�¢yxX���� E!Fa��̈́k���E_
rTqS˯{�X[�w'�,�E�Ē &"*QČB=!=AN��(�B���'>�c�/�}��c����P��A�۟��^�����>w��~ҟ�������Zc{}���������|���p���ߟ��<��!�����l��o�?�����S8���~r������85�9��>��:��Q�	<�f�����LT�ƌly����� 
}�g=�hK�0�{r���5���>D�Əx��\��돂�f��~zk0&�\xkt��U ��/p:��k�s���j4{s�����7��Ŷ�99Xí~�k��V�����z�K��V�4�7d��O#�X�j���Up�#�|#�xFI���Su���=�ό�s��3O�����	.D��S(����Z>�R<]�v�Y�T��2)n���3N���}���E�a0�N������5򭚛�����(�P��e�N��|�%x�;��� >S�_hQ���#X�6��Nj���>?'���9�����+�B�qX�;ū��^�7F���⢺���GpԎ�j�^8#h�-^Dg�⌟�e�!_.9~V�^��AB����ř3�;�R��9�Y�k�lM�����׮M�,�u�Pr۲s�;.=Q���_~'C:�2	�̊�����k��Q<�|=�:���(V�u�Ӝ���2����y���[�;V ��<�P��5�7�*&���S �d�u�ܷ+���ml�s��S�����~i7y�c��j1�b0��LY�Ujnİ��*�~�X��ϻ�1Ж��=��a�Ӏv� ��1���-(���IhRJ���������bjۓZ���l��y�1�̠��_�l�?�0�~=���QB�J��U���,\Bhγ&������U��l���R/��	@�߁Rt8�0]��L"^� =�-�nN�P��B>|T���*O�$>fc� X��|�S��W�Γ$�1l��D|�$.�܉l��/��S�2���/�)��nD�=��3���=�Q��ى#ʅ �6@�7�^�
���e���b�j
������BY��K߫���'3`�P��%>�3�4���	u��Ļ0�Qp�.���$�T�(�ƏC�F�
����H��/>��P�Q?��B�0Z!���t�� ����`3M\מA�]���80�2-E�ky��[uF`��3?�U��|��6-"�H4kvZ<E�%�)�:%j��B���ר?�����A�3IA5�5��>f i9�)��aіG5 ��Yp��p�_&��Ǚ���I��;�qZ�>b�� �H�I�0* �Ùħ�x7��nV�D�����/f?� %��\hz��g��SL���ҫ|ÿ�Yё|9^EP�@���8z��<��aKa��A�4��nߔ���
#\��S�0�Txm-�W$�9+�³�4�+�ZsD���6�u���AxaZ�ә���M�`AH�z8COQ�����t�o�C�y�3�jǊ�M��lg����v>�R��e�����I�؃)>�3�=��t�"*�(�4�v�wmî��(3�"��͵�m���^c�+���3 �eܛ,H1���a����	���U�io�i����Mw�����m᥇h��E54	��~�]�*6BE��c �0-4+��jc�[s`�X�{=w���c�1��5�ػ��9�R1���4)3G'!�M)~���}�!��f_~�_o5�]�����s]�|Y�\�0��M���N�	�q!hD��#X.��%�|�1֓�WI|QVS����ۣ�\i��$GӨP/_3t��	}V�� *r�pCx�1�_c��;���A �7��������=�ߊ�ۂ2܄2���V67��qC�-hJK��)~���W �I��7H��W����/>U����cs�4����Ա�0���r�4�Bw���$��b����ܒ�&�tP��!��9r��,;l��<%�LT��9Q<���x��*r���
���BC/�I�ǃ�X����( 10����
3qJm���~�i�P瞀J^�\Q[} ٗcͺ�s�%�0�4,?H�T*E �&��rF�PK�6��QLR��eir����UY;ӌu�����Pg��h�T�3����C��j-���:�/��++��<!�u���n�����3�%��:��0��MY_�<�:{\�C]N:"���o�^@��2+�|�o�2^��B��.F+I�������5Q�����S�V݂����Ĳ]�2nU��$�u��#��B�I��f�<|��p*�`5߽����ؒ	�M�ۨB��F-o1��)��l1�+�l������A���'Y�a� �[@0_*o�����Fx���+�~N����?ek�S��DP2tV��H1[�s�>4����s�WU��ׅ����AX����y�t\01D/��G�ؑ\֬N���7O8�V��|�@�=k��9:��b�Q��,ԙ���9����M[���t�� �9@���
{��J����Jt=�ooa�qnm?wX��ի�����a�R�F�Q�_��F�X�׬Ei�9���7FY6�(��6�b���8zA\qS� �RaD����o�v��U���V�i8�}�Q�zI�rT�Y���ZY�[�ZCRI��	u���n��W���BiF���[�[��!���i���8M���J�DI#��M�ʖ�Ci�j2����S�n�oX3^�eN`	�")�ZR����G!'dN��7�y��]-����\�N��w+٬*V��MV�b0<�"U���ގoT���"y�WzBIܻ_wCq(�����ͷ��,�^#�|���F��������ȲQ�e�,�H����=]�Qhz���<�n�^�3��ĳ�������v5�k���^:���ݺ� h�8����q4S:��H�d�G��ZůlM�-�{�\��LS��D��|�O�1X!ܡ�ѡ#TO:�ؙ��I̮��E��Tlc#�p��lvӤR��A] )�O�ƭ�5���d�QP�o�܈��#�Q��s�`�L�;�!�Zu��z��k�_ƌtɚOn�C�u�+K���Xp�j,�v&��f�e�/��zE�8���iX�(�L��SWȾ�����ÚP9[�|G"��KX��TQ�*mr)�{�+����Z��w3�T���#��5����%��B�M��E>,����Nq�,D�mZ�r�yS���4��I�ǒ���_.�}c�:����y�9sd�X��5�,\{g�/�ܒ�, �.R$�R�=?}��3����ɓ�a00�/�+�����	"�C�p��Ƣ���U�����aI�'�u'L{`H��[T�
k�ڡQ*���2��3c�^�`j�<[�W��axg>�]��2���Vn(i�EX�2�c�,��)<c�6�o%7ʇ?����%C�ZIP)��E6�f�O�c+ܮ��ͷ�$��~���������I����!�x���{۹Oh�-����r�#<wh{�� ��7�0(�-S�q�FqC�0�foXY*j�Lמ�%1I����X�Y��%}?��|�U�2�'��8@~1A!w��1��mЫ��}/B���"kO��\dR�H]�q�_�3ĻZٌ&��_�Q/��K�D�g�A�R),�s�$�3�C�p�{�"�^8���n�
�Y$Å�|�P��9]2Ӈ�ЌE�J��@��
:�%�W��4O�аr.EOlM�W�i�8Z�L!�!�B"ɷ9�����Hd�s�_��'��xE�S��x�	�{Q7&��/��' ���\�J��uR�B0�����E�A��<�s ����mL�{|�"�[V���4X=�zKK�'"�l;B��;���8S*���O"I٫CS� �b��9Ӫ�zT�ǌ�<6�F 'X@�Om+zbAh�a��'I��0�5�R��49�/p__���k�!�
NJ�� �\��1���@�r��4M.RLM��pϐ��AЂ�W����`�sU�Lu	f�����]�M�Z��\~���������f	����2=�D���PQ��8�[�B���y�C�)��Y��I���!q<���|A��u���+�sa��O�J.��g�ϻ�Y������E��@�z�	���[M�}��ZL�m铅�Y�u�~[Ϳ*vr�����'I�����ۖ�2f�V���0�$�z����"�Bڑ8>k/��ml�q{%��~�?~�f��(�pO����
;����eF�q����r8��@��|������|hB���"1��N�	�"�l����Cŕ9�q_Z@k��,�I
�k���7�v�L���oU���n�w�t6pow�M��x�Ъ�ӱq��S��ރ���E�5�����Zj݀�l��"Ԇ�ۄ���P���&��.Bm�]\���-C�d�#k��C��C0G����k�}?�C��r͂�$-ف5Q�)`ٝY��@xvՌ���+�t:N.0���^�*��mْ����(��:�d�T�m��D���c����/�q�$H�4g!����Z�����5��"�>��l��x� C�P)"y
��C�֨o�/��yҟ�K���>��J(����F����A�+���(l�5
,g
�$��$�M	�o�Ccj��t|&Kh�Y�e84�9�3yB���\��k����S��1���%��{K@ISe0��Rnu�!BnVœ����=}*\U�!f�BFh�����	圉%�h�~_���3O�?���\@=�{���p�9��X����#�kZ�O��4��[���`Y�e:�
~�d[�D�/�yw�_W��㞀x���𬻪gZ��OtlE8�rC����Ď��Qt���� .��Hֶ=<���C1�쩝"�,�Iи��ս�s��\��s���t��n3��=g�q�V�%���a>��k*ϯ��RJ����7��S暓u�qdn���Yo\����R\�h�����(M9Ȑ;%hgl��ST� �v���V�=��#���m�����eh��8O��v��n��x��-��n�Ox�G-��ޘ�������9�a�N��8��q��</��77t:���V��x=@av֥������釤�vF]�`�]b��PO�W��L�����^��H�)xYOˬR��U�,�y]���}Nt�����䀏N��Â���^�������;^��ӧ8x���#��O�#)�M�<�V+�j����1��;�z��-����	�f@~Rǭ<��T��ެ���%��(�ʥ�����L�y) ]LY�:w)�sѶ!�QG�Y������Q�9�0��*����b�#/k�����F[�"�*@.$yꘇ$~����U9Aך���.UG�u��6w�������L���������buN��n����/`{wsm�!k;u���:�����>��(T�]o�G�]����i7�?YӞ����J�!Ԗ^T^�p����9��
�&w��d];N�f��Ӕ�8�M��t��^���(
OQ��^c�cW� �x���!I����	��������QM����t���%.d<T?*}��2�����������A)����5�s,���Ng������44����f{}٭ٹ��X=e��f��s��blqe�oJ;|���鋒������?n6��ͷǥp��r��e��f����^�X3�C�h�O�����cӉ�����"�Љ���Q�����d͟���<+�E$���\�,Ǣ�t���F��SҜ;%3�pȆ9+�h�?)�cƤ,2��"��.�d���X`VޅF���
m�.0-�:�E�e��Bds�Y`b������T��
�a���wG62k�Ļ�iA���6x��H���gz�F<b��)�ٿ肴� ��rZ��d�L��Yb����yk���x�˯�(R����޲Y�1\ݝ&�P�/����y]=q;�$�1g_	��Qd%�-�Z�Nؒ�JD�=�D�MVz�+�2�JO�U�G������-��T�%�����Tq�<���XuW%w��г�4igaY��7��խ�oCB]�X<�׼�?���~��Sj6��0�F�ŧ����T5��0�6M%f���J��;�=3��JH�K���l��~��S߶+?���`t�kuwyQ}8�tTZ�<��9ύC�5�=�J��Ԑ��UC���}&�D�rX~Jѹ��pkc]I #���������L0�>��0�i�G��Y*#��R�AQ����X��h��>�Eq]�*g�](����܀�k����քK#��qF�qeͻ׏�h=,#�n��G*�}s#@�~���&����Ux�-;�(C!r����@i�-*����̽*i������XOj$���R?5�b�����5��1����zǺ�һ�� �nqW� ��������D���?����s~C|K�'8U ��`��SG3ʯ�Rw�஦�_���uS�����Wlk��*��+Ք������~�76iۇ�O�v�"�+�q+�e�Q��b>89q z��(��!S�%*��mͰm˴��ѹ��v��	U���a�DK�رN��L����*�����]e)�����{��$���m�M������m���Ѓ���P��ȷAfw�+���4�љo����6`�N�l�u��'��v�T��%	X�ѳ$ _!��g	?����}[1=�4�Y9C��CsF�a����gt�7,dpŮ��*<�Pv(r���{�=y�5x���W5m�Ʀ:V�E��JI�^iSi�>-2�V��}�4+T!�!x��+%g��IG�hS��9�X��9�>� W��~��|,S2�+⬽f�Z���Gl�x'|�6!1�g��u�窢3��6���<�����fY,
��dTq0�chSӗ�vL�G�q��af�7y��"�����
�b�[�����5*d��Rڽ����1���\�l�`�z��ȫ�G@��k���إU�_��?,e�n�u����#3E�5�o��&1f.g����	����Zo!�*�^�E�n���-u���f�d]����%���MC���?]{��'[rtݝ��	hl O�2�c�� ~�<d�ˈ
�t���%!>�$��w�έ��)�o=(M�3�_���}��x?��<>��Xª]'�q���!��<67X�lNp�a(���'��ʹ �����:!�A<��ķ/��y��Sƿ����JT_r��&�T�T���E�����	�
�A��ıB_�~��&I�����m�4G~/hGQ��UV��Ye�M�(:F���I��Z�!���^��QWϖ+���^n�꾳��l��Z`�]�Zt�>�^�j_��tn�[�<ZB�t��^�!���Qk�,M�+�X����G_%-�	�����Ä�E˵J�GϋF�<3v��m~$�h��B}�q:�aG�%��q'����LRÔn21�<�$M�����O����bv����?��y��=^X���kpv�;���}<�xm�[O�*r'f�x��^(����f{�q>-+)%���a&Ѩ���O��`�b�B����]�ǖ�=�1�u�{�튒z��B9�\;�&������.K/='�����H -繄��ޓ���(:�h�����+؏�
<��X��B��o�d��E���dUN��O�����Y����̴��s�Z�Zp�x��8�	����k,8t�ER{�#���6���}~��LZ������[�X|�Dj�e��q�z�xZ�O��'��%3�<:m~�5e�e����L~�ީ��n�ّo~��,�ӟ��24����(/`�\^��1'c�s�]����d��q���S<
�� ܹ{��fz3 0X���$H����P����f����~@��[��ky�����-�0f����Y O��R���|.��g�)���sVfW�1ω:A죢���V�+2���OP�К�b���|3�l��#vM�W��Ce9<.'#���L�0�<(��|[5��΍b���bZY�� ��`a�#���a���m��7Ti��x^1}����_aJ��eoի�
��b�%��%���1h�6{�'�9�E�JL*��h��؆���E����xc>	���7�OX�e����L��%�!hEx]T<+M|J� Fr�a����!aK������F�Zfή��<�wt��>l�b/l�L��P�ݡ`UI�z�7^s�Q�^��XQ^A�5$v�I6��F��i#�$�Ta#k�co]K�jS���U�I��ӓ��ʷ�Y �k;ߕ��&T󭽹b�5ZgR�ȼk[[Z�o�j�����a�#d��N&ߵ�uv|v�]+U-��6�^j�����}�8yR�	��W�TF��ߟzyⱛ:��P4�xg7��=.��@�b� ��0�'!&Y��$W(�j,��Һ��r�E�&�����Ɲ� !��<��!h3�����k����(h�ϰ�J��e�@��v�����ݧ��/0m�~�&��1>>���כֿF�������[��oc��n���^s����n67�^�l�����	�g *W@cY-��� l0�Q�'���������{?�w���y/��7B?�g��
������/���Ūl����X���_[ ?S�R��� ���$�����޿�b�%����:y�)����߰��V? ������_klm6�y7�s??�������(x���\�nnnnl�>\�`�������O:�^��o�<O�������h��������������B����*�-�?�0�d?|�@�?o��#�a�����֝���Z���&�H��aw9	x{�EA�
~z?���!h���trG!��{i8f;�OjKtYj���x������5~�M�0�� Ze�@V��塋�C@���j�6F`LR�P	ޡ�����=]9M�^�ya�ȒP���e�0b��K;�!H�-�: k	�1t��u�� �*�&�&1G�5�юB�V��X`]��)a�Cc�!�!��Yk	�>F�0��y5�Z�5�v3�pdj9�֧�(2A�5Bހ��첼�I?́E��� g���N;^`TGkip�{�A�^y>�����BQٺ�����i�~pDɘ�/���5@�(�i2>�,O'"+��т��IS�\V���ϵ�C������v��+Ϗ"I����+�-t�2���T[T���M�^4�3�?ͺw������K��3�S3�_�O.�	�s��Dq��t��Q@w��g����U���0�̥���P+�|�	�}�sx��h��]ҽt:�ա������ۇ1ĵ�:��K�R\'�%�3�~R��e0,CX�ЪwJ��'��D��)��lޱ&�`��*ȩ!�Z'�ᅬj'L����O�Q�ɞd�<Z+cC��CB'r�%�B�����.�.1]�Rr�a��u�����^L3@ 9�0��x�ۣ����"��tB8F�� cF��5���^���@.M���X[r>՗#7� >��c��؏�Y(��$�.=�C������36Z6��Xs��H�E�\�wۿ
R5��g��'+^�s�^�����yx凑�\��"�˺�}wD���ar��9���z�|��5���;B/F�}#8^X�#T�9y����la��������5,Y!X�	y��SM���3�K�EZ��g|�&HԔ�>+��^5i�<%_f���5����b:��@�O �p,�`q���G�F����%W4�RL$n縬�)����|V�}�@�a��R��7[���rɳ_��age����#$wk�?��~�G��sQ+~ʘ�~�'Xz
Jps M��+B���+��Y>�V`���v�Pw��C�ӭ/t	��V}F�<��	Xk�˔��B���l×� ����B��$,Z���-�&~�_=y�%�I&�- (��&��`-��د����>>����(�j%�y	�K���WT��m� y�a\1WFH6u��2r�u�-�4ϯF$@�i�6��s�gBV>-�؞��b̵UN���Q�|�ݡ�}v�m���z���+C,*��g�����le�/�V�~��!����)Бۣ<�}xN��[4���M-	��'ީ�|}����&q��.�pO�, GG-�]�VEf*8���� ������xB�J���n������tE���Z?��=�ᛃ8[����y�_�U(�b��i�e������ND�E�b+���Q>PM���W��3,��Ыj��V}�X��j���	�O(�,�AE�BtQɞ��8	P�c�Y�	j��-1���ۚ5�|��	�v~�p�mX�l>nqʱ��S�υ2�"��*��̷�����)�\�d��y�q�,p==wS��t��(���d��#m�
�����)iG�W$�f���~&��x��X;����8ṭ�CԶp�&���CU�:�:��@��"mO�Q�!�ī��Y�-$��&P��8��Y�^)-��9(CXR��ޜ!]q��gS�F|�e��D^!qP��/:���V���q��vĔ;K�)Aͪ��N����ٱ�M�]��_��sc��$��F�s�P, �g0NjHq�z�%���֎=3|T �)3!�t��#p��=���);!T��cfuMb�@�;_Wd�,]��b��!����ۘGt��٥�U���3)�� �dK+V= ��:���Q�f7m�:f�+��<�FH,A��I�O��	}�3��b:�y��|�t&���Z��k+^5�(oVS=��yumsk�\WH"[0?`�U�N3���뚎�����������YZ~{v���s��{�a+��!hg���4�ɪ�J�_F)��/PoU�X��f������@�����hI��	�$��^~��-G
��:��� ���
xH	�L�_��үaL[�EB@�=V�%�v����8�	%��-F�A�9Y�7c2���*Y}��c6�?&�^���~�\Ob��{�{��V�����}�aS�ǯ�i?K�cu��i��$�~d��I��a~�A��H��-éL]�A�~��
�8�}&��J�z�����k�0�ȼ�g�o6�	A in��ή�zd�pe�s�sL&?%)&�K��19��CL�7��s�7��0����ڋKB��A}
����Zkl\
��!Ÿz�������V>&K(�� �ɢ�j�b�Y�뙧R��3��p�@��*���y4oJ��~J(�<���Ĺ)��hyՄ1�ob#�5jjm�}�<�b	�ƙ��N�W��3*�L66ܬ6�	�y�:��V�PL"�*�Q��A� �~��VU���vS6(�aƫ_*m��Ƞ_�C0��o����WZӎ����+�����zC+!���!�.��>H�&��&�`_��5&�����?��"�"�2ن�6��΅2���#�Ⱥ���2��`U�@/�<�ӛJB6�$�����e�r�	l0P���k�p�˽w�&+75~����j|����-�zq�e5����xG��0aG���FW<�<����KF��+{�<c���Y_�r��r��y!�/�oH��B�ДѶ���ڨ	2S5 u�k�.�4��)L���)=Vn]��;;��cN���U�r�I�����{U6.(k�T�J�I@�'z��eV<7�5�`�k��J�Z���L��k�ޔ{��7ͺbI��jGJ�'����|QehJ�$Q���?+h�VOr`�UY��� VL�2յW��RdhMj���'�j�b\B&�6a� �q��)}lƷ�_U�^�{��B�!��nYCў��?�5��frC��\L� ��A3k��ji�Xu��j�`�F���y}�C�Q��qS����G�x)��1;D�y{Y-����8��� ��&��(��*ii�3+Z�k�v�����4K�[t@�"ص�e�$��C ��!�:	.�n�մ�?~�׵�����V���_�C}�W�퇵��7��,ׇ~v����F�l?蕬^�K�����.�p<�hcT%�p�+���~x���!+ϓsҧ.$��>}\���_���e��]�{�������������_/�K ���x��������O�̋<���(�A��K!
xu��t�6�?)c�s�H�Yx��φ�-�ƃ�aL��c4��b�e�$[���iՒ��#�2��}X�Q�6hYu� �ڒ��i�)��r}�g���q5J.BP�����
�F��KL�Q�f���f��KL2
y��[k4-0��,�c�:��w̌,��}[A��k��&Z�=��J�A�Z�<�`ri���"JǸ1��(�e&e��3� U����Ӌ$^[�W_֭?��7�6��ZdnT�1�Gu�������*�3�}k�ƬԱE��'ny�sOt���ᢊR?Z���xe�3��̹��Vt�B	�Z��kX~�_���a2AG�چ�	��t4���o)��A�1�����J��-�X���ji�A��K�Et�ǰmX��`���|�q�>��7��Z�b����C��
/\Y��s�q��#�+�����hm<�Ó,�����i�A%P6Tx�kӓ�K3��Bc��a�t�j�i|��idTĭn���;$���*0�v���N��M?vu��+K#�����5FF ˭;��3P/���^�O�[��A>"����Q�\x��� sv[ܱJ\Z�L�ΐ`�)qm��A<��4��8���!�"p`L~EOЋ�,���d�|���Ǽ5�[�@]{��*�7��4�:h������H �uÃ]�0��0�J���F�AHZ� 0�ͫ �'�ī �fHv�łT�.�v�L6��޴9.�P;L@���:��C��.H����5ǃ�A,��a��l˖`�aJ Ss�����:���د�vfhBzӟ��U������rs�/FA!�B�a)BVm���ѕ�w���*�(��}�͔z��Th���c�$�����~��/�c`��q������ZvP���j{�%6�b�*me�I�\dż����l��;9N/�hj�VI��eмX��T�fL�JQ���YYj�LS�\���%��9�Q�M��%k)vۨr8�n���ۥ�:6i�c2�=
��h'���:�{�C�(�G����̭���N��J�4��VD{�[�2�g�#= �S���U���|��b;����>��u }�<�
��κW/)�Ӻ�?�z��0Y�U�����
�z��<��U�cT,�!��CĊ�U�ƃ�Ҷ�BG�ZX��_�F�v�0�7�J��[U��
t��U5�*����	�+\��@hm��uR�8E*qf��q1^Vvƅ��;�]�\�Z�2W��:l���D�%�g���w�`lv��_�W��-4����rSRV�kR�d�"WM0k�j��U���E���*� ��3)i]6qk2TU�"�BÒ��ed��>N3�H��	�����rn�cp��S����f����/{ʓ�{ճ��S��S�)N؟��^�9zn�y$V��Bp,�K2�N(70�E�s��z��a��R�j���#J��^__NJR����ۮw���F����<�u�{�����d��*���íƃ�����fc���Xk4+jj�Z����J�KV�5�r��D�Tg�ͷ_̅����m�䒖/�	f���ة
�@���lI���<
{<�A�&<Q��НE��[�bǇߕ ��3^Y�zٛ�
{n�~{�Ra�;�A\n��R�J|�M�;��Q�͊��L��G�k+���]%��=5&�����K�n���A#�� ����$�l��z��*[���$�bcO��OtQ����b�A<bb��N? �K3�//��;_��-� i(�kٌ��oU�-~�Dc����h~Q�-�R7���I������e�V��@�Ϗ�^am��0V���&����X�f�h��(T\�i��q��=Z�n���>������8�.�S(�D��q����#��l>x�oK�fqB%� ���:��T�D�v�� �/x��M��x瀼�,-�g1n��d�=sk����<��iI�m�6��ڻW�3��Yc�:*�i�[�g_��%�S��C�E�$���0vh5�	YZ���N�w	���x��ZuFKgl����0�t�߯�q�3���Ҋ��д��*�]'V!�s(ݵ��J��ۇ�C:(FH�g�΋#x�D�w6:Yv��O1'����>M|G�A��(�[��qP���>�x:	O1�Ԭ/f�h'O�>d�%S�j�VDM��'�(�HP� ����]��\c}�j��ԋ�皢[ܽg֝��b�S�}
����c��$�L��5C-���ߘyh�Y.+������G�⓯�ІlB��h�-=�ZOs���vz�) {�����j�F�v��� W���8���`�FN���'鵟��CiЛZ�P-��_�|z��GT\el������G��������;9�FC�"��{��M�.���*<煴@%R���(�9���+���(�����.4������l�
-�x*Z�]�
�z����e�i}Ǽ�N""%�9�TN���~����Ew�l���o�O�ߗ��ݣ�<�HN�3��kt�e�o��;�/:_����;{�9zmS�U~�T�8����Wg���݃���}��=�37S8���H3�).HC�|������hhE�N)ǝ8lZp�T�����@tߊٱ/�~s�>|�������Y{����/J�#��� S����5�(.J�Y��� �[l���`�h(�1e��d�zܳ��W�`)����K�	�_�H��b���0x����Crt苅�^w�u���S�B��c��r*%2_Q��v�����+�'���4{䨻<�=�����n��2��M#Yn�A�k��P��MS@6�ތ�՘A�#�gL���;R���=���z�S�����0���>�īђ�R5Bғ���X��o�<p�����0��?%���.�Hb�$��O��}j+�V~�f��DF>�t���Yk4�ϧ��h��x�i�yw-?}r��ޏV�z���,��+���)�裋�A�d���e�j�J_iI}�ZU� y-���]U�B��ᘲ4�*�iAl�qmJ��3>��Yeœ��1�g���I�+����6FSV�<�͹ t���P�x6��l��j���Ød���Y�O�]�c�!6�i�D4'�`G��vU���xav�j9�����W(�U�W��la���q��}������c��:���Ot�\
^}bqj9Dv��i^* 8�6���
�A��8�+)E9��2a���V�Y*�~$k����b�'�|\\��?¡P0{̮K����VV������
Q@I�
���M�q�1���]Q��-^Q�h��3�)��M��s*5�F�`P\TD��2t�\UY�i)+�����<:�qs�I���C��o�	���)�G*˕f�%�&��N B�O+_x�'/������1���V��8)]�3)n��0?��1wͅ�i��j�+ݽýΩw��?yq�Z��~�w���,K�S-��[��r���xv��t��1,:�XK�-D��L�d,Ѱ��š\�l�]f�:��%��v�t���y�d��Щ�7�O��5﹟��8.Ń�����:ܯ�t��']�y���(��.�mpvOv���Lb���ꅅ��&s��Y�ģy2����fGM�Oq���s��"ϖ�(=%j�4�W%7�H�ā)��N'�z	(����D\�]�0����)=;�&��5��r���rW�#+�D�y��sg�P{8�W|��S,�̥*XÀ�ޥh]� s8����G5��.�����I�� v#��7�ku�q�!TU�?���:3^�F<��z��0<Mi�K�>:B:�d��Y�� )�/���'�A��9"ľ-Ê��r6��SG��z[�VH� ���>��#|��������Ӕ�/�s\0,tn�7C�O�8�g�dݐ�];#�A��b���l:�(F����M���[�v�O�:�<���ы$�kt�����ؠ��ꟗ��o�E��� �F-`���(��s�TI�,�|�V6^�j��g�Abͻ��`�=��g2�[m�Kk�'Q�9�� PD����渐��1���w"Zq%��KCۜ���{f�j�	7dq��%�"11�{���/Bl�(87=����^�&&θX���l���ڥ�n��FP�#�2�T�����-��t�Z�;�<���q]O,�Yef{mĹЯp=RL?O���ϫ|��43j���<'�V)�Z�f����C~他d�Cαt�ѹc	&���Ke�+�p�~�������(�Å��,@�"p
�Br3��-CW��Jf,��wS�N�-�^�=�5/B**7T�[��m5�}<�%�r��&n�NY�3
%�er�D��DU���g�9ߍ'�8q������Ǭ�m�[���:����[�G�e �	4[:�T;I�/f�,*���4�-~�a]ꐼ�3*3����!ceW��^��e5b�@���W�U��G-H�*���;�^ ��U��3��%KVD-��aE�%>�ͣ'��$����l��� �y�C�7F���\{�9x�*
���:"����Iƛ����,΄sx'����*X����dlڊ����y�@�t��QU��u�s�
gT��Q������Aܣ�ݞ���ع�����=��p7(��R�wX�y�#n�FA�H��r��S��d���������,��+��2�Q�^7��zF�yM���z���<�C���k��/���H5kTFR2'��u}1d�!���U=0\?U�C�O����=��c�CI���v�k_�9�a��bf�C0K�~��[�?
��dT���|�6��� Ȯ��z᪋A�\�t�ܩ����s#�.rR1��U�D�K�K��;��8��/~
��藑pP0�Z-�ϲ'r�JǍ&��%�ծ7~c{$�F)�OOwJ�
��eٽ��Y�=OT����-�=��i�����\^��骥�lǀE�L@�������n��ORTl�df�_��<��	( �̲�JP�酥�!o@<�&"%�y0�����1���X�� �b!^�r���	��BS��5�� �-W���p(e��:�~��)n6�A�]��4b�%*(u�5��"�g���(P�"	Ҵ��˜��}2�[�%�zfj��.{��ċ����*)�q�}㧼�;���e��f=����-3�Ʊ~���E���̽HAy_ˌ����S�{Qx �n��`\���?�����xki�Z?��a�io�p�G���F���������M����~7��u����hn7������^k�����Y�	2c@�
((��y�3�a]���U>�7y�����=�E��F,u|v��������_�����	��%�����3��xjoh	�Tp?\��~��{��������{��ݧ������2�~ >0w�7��_klo4�y7�>?���=B]�qs{s}�����Q���������wx��>�<?x�W�]*�������ڣ��/�G��������C��3���Ɨ����S������������X����y'�?�o�[0�$�&h��>�1�`@��Q����&������H�n���t� ��w�C��&`�gxJ�]�3�W�hR��`�j����X�l��H�%qs�:;�gdW��y��((.��@�/AO�A���{�v�p&ܼ˘���k	,�Z0��?�8̀uz6P��Q�i4�!s?��m3�G���`�gcyo�0�����&��8v�QF�k�!�`�#�_�<W�D�`�Fɘj��)Ĩp^AOD�^M�`�%�L�gh祓�=n���x�;�_>Ǆ�E$����Tl�$�9��.&�r���ѱ��,�E�k�b"�6O1���ʑ�ź���e!IV�(�1G!^md�-�Rt��~�;	0|w�0�v�kD��&����'ʏ֩5>`T�Xz]�.��K����[��0;�Ig�39a�N�_�8���߬�qjvD�C�����?��N�$����9zܧZ�ț�EEt0Z�O,wa�.R�b[[z�n�YPT��o:��$�.+� �9�E��/y9pr"
m*�D�����z~�BM�Q
��W1(���D� A,���*�BY���Z�˹;E�*o4�	%y���@�7
��R�� ��GE2FW�H�J��>^����|wD��0�v�\�\�L�Y�����&y�߿�%�.c1~3����D'��lk�A~����Pd���y�3�aA�Ai���K(��>+�9�}Aa��o#GY����5��� �.~�V$����v�E��,�\��B�|&�}	�h&q��0&	��y�_Ay�P"�8�l�Fft� ���Z�!���
%�%r��2������h�ڧ8�ښ���l���4ɔQuzX��f��p�r��y�+Uk�/Q������l.�0ܯ�FSX��
���Kй��L������2��k!F�`U�|HyҜ�z�k�:�@�_�y ÎQI1U�,Ip��zI6�@-��L�p �B!�1���t@�X�a� <V����h6���QĤ�<D�r�X�s^�K�tV����4��
Pa5�j��*�\��T�d��ɯ�s�Kab0�6�c����Z�4'�0���0�S}�2��+�u�h�q�k�LO���<U�!T���5P�j~�z/Ǹ�C��].ZA����x�kY>�I�0X�d��<I.�L�Q��3&�O�\�,<kڧ�V,��b�"�^���#�^�}�� ����w���~���d������AK�\G�H�,�%��.���G��N�E�v`�`+t>�}�(M���������'��A�r��!"��>�e��b�m&�ř��X�'&ڸU�����E	i֒e��-���?�x9��f�{�\���)�N1��¸K�K����z�NtQ����Ց��a�u����'��S1P�@Ps��Wŗ1SC���>p���(s")t`�(<|S��+�!r�?��F�FY��9���
�����"!�^�~?
���iFW�9W<���52ӧD��}�d1gN0ZA��,�)B�����ϊw��u���&C�i8I��(s�y%�R�a֥�"	�Har�����&��H{�
�ە��ȱ�mq�F�o�b��P�$�REp�a��s����n�<�K��_���?�P��`�s|�k�0��������o�
(UE���e�t։�)��#�Vst1�#��20Wc6�G����豠��M��ͽ̙�&��*�#/�O���1;#��6������D��>=��bk������zF7Џc������=�֑�����9
r�3��\�|Ƣ-�cG9���(`�!���'S�O�� �H��E4q�P�.P ��GW��Qz6�B���E�����E�1����As �a�Lr�t�0+�e �2�m���Y��@��_U9�*�NU!
��)x�-�J�P��L6
h�l���$#���H+�Qߊ���Y&�ͅQ�+��t}��f'Ȭ���AVL1i���@�r��v�fY~*L_��T�U1M�ɪ�n[<�K���J���p{��0�,���������������9���.���˅���&��L�P�F��=CU���}t��O͐"er�GI�E�X�R�s�*�d�Z�*��pL�5��u}�r */��ǈB�$�i�l���I�]t����D���K�Û�sc�pg���Һ4��=�^h��9�)o�`K6ҷI�Hy(H��}� ��Im�jƮ��Gዶ��z	�o�.�DܮA��U� �_��PЦ>��{��{��|ٙ�"��T]�*A�pO5dr-&W�gށk�'(�t�H*g쉂��N%2��W��K�����aL��6'u8�Z�.�/8s�� ��1�F"�=�Snҭ\v]����2հȴ���������3�!�V�R�|*���]I�>Vk�8	(�?�ݐm�C*�H
;(П0�5孀(g�f?��	;�4�/�CI����nG��I {׳[����%LlJ�����]�l?�6/ϰ�GS(-&x�'��HR0��	ۤ`����c���k'X�*�$(w~F�(k0rƌqx���}ѥ��r`E؊u�pQ�r�&��qx�~���ސ�坣o�G]X�Uc����N���E�gڗ4nDn�ځD>��hI��O��Ť�sr��� ��9i.³���)`�؍�<2���_��bV:�^�[�3�����O+$�DP�c�R ��K�SBF0T�D���UL��tD��g�9�ZF2�,�7�잼J���t�&@�'��3�D'k��9cǜHy�5�'�D�+�0������l 3���\A�k�x!'ymڙ���NC��]��P������Ntb��Kgm����DP7퐳8p��Y����\m��va�
��!�
�0�M��)��ض�A%�;�}�� 5���-?���#:'ݎ�����_��}������]��G�����?e����:������q��1>����������]����ǌ�������X�ز����]��G���� H�"�&�*1/j8���K�3�k��0\�,�@V�b���g��̃B@J�Eeg��Ǧ��q�: n��sH��G^�d��Z�Ka�a(��)���2�������h�a��46o�u0 ���lJ��h���YDb&ZP��e����Rβ�$���kJ�L��DB����!��
Q���F�V�l��1/��\�^`�
����k��q�U�"|9���oG;Kw��7��(��ap,��@֓i���򌴬��\.b1�Uۏ0�c�vRX.(E��*|�ݣS��G7
�+5��C�QS���e\��X�!q|�_%�Q�z�ia �{�3<$��c#ܮf�%�E��L	��h̽@*���'8�^'��U���G�R�/d�;s���`[C.��Ʀd��Z��9p��]����ԏ.1o���d���h��Hفm'�����Bo�kJ��牟���_���2�ܕԴ�ݥ��"֝9r�� /��,��3���6A��zK`|�R��JK-��r�;�5՟�^�1�ZZ�}C�|�r3G�bf��������o+&��Ŕ%T�q%5`�9�E��p�D;j�9ĉ���y�#[$0߬%/X�4qi��Rī��-m�:<&q@Q�Q1��m��6�W���M�@��*�$B,��
w� S�s��=<N@���yՈ�w��U�~�cx�SA���]��}j��d��h4ơW%�t�@%�=O�̘�j�Ч*�i�0i(_G�o�9�W�q����ES"� �H��Z�*���g�"Z�.Mau��y��OqDy�ru�m9�XXvu��l0��{7@�A~�Ͽ!C�a��\h��ȿȆ�X�6�a����W=N0�{�%$��Y���\���L0�I bfS��*���Ժ���\�e	��E�u� ,��
�žr6(o���(�[����\��T�T.�%�G�i�u��":7Y���y�v4;Jz��q(�����Z�'�Mo\���N&��تIe�R�P+4b��,ֲ�{�������(�z�:3�gzL"�-$��,%��x�I���� Ô�eb�U�C�҄�0����W�_��"���x�K*�\�� �qv���@���aG��v/7�Lͤ�j�U[�J2>�~�	�h��~������ȕi�=f���G��r�Z��,\��F����U֐k�̫p�f
���XpM��2e^mv�Y�Z�_�]&G�fc����D���Q�h8��1�B[ꅬx%䎣��_���#EA�4��:���aw<Wy�C�K����n��1�S��*#�WД��4���	.=��T�y�#�D��x*��G�}ѥ�zVL�a�7&����h?�K�-3�~�|��$�N��P*A.0�K�C��^ļ���XF�"A�[Ӄv�`}{�?{o��F�-��n��a�y�\��i���)u7Ԓ��(5�I�CRݷ�܆�@��&� 
�8jF�u����wvm���k;����o�����7�:�Gf���@��O1bUfV��sN�<���}�}V��[��:�^��إ�fP��e&BY6&#-/�uE�P������H,#lR�����NAᠣ��zWc+m'�u��ߩ�f%ݝ$E1HB���c�B�jh�"kb�:���%l�>SR]6Zu��y6�U�B�$��vҟD��>h��d�]��mK��Wɫ��ֻ[p�1�x���g����y'ӳ!%�_z9����c���0eH�|��[3	hئ��йd������h��ď.�h*�����k���#�$D��
�� )t4�a%BZ��,GQ��V��	,8�~i��,�g��&�q�_�߈�!��0���ToPn. ��7��3�-~9��d/n
�2;V2% g�ZT�>�Ϭ���s*��ʙȁMxr�I��x0M꯹���9��qC��$��d����;��:��]�z��g�#�*M:|�H(��Q�w҅����U*�T	yJk�r;�����
r?�� ��Ku��>��4�!���;^k	���	~'Wk��?��_�_ 6#��$�}JP�D3�C� H�5R99�w��$�h��DWp)����|#D{f�A�x�Jv�PX��6��T�3�̮T�#�!���KX�^7�R���ֿ���n6�fNW��=��8p�������Ar:�}]|^����7�"��&f^w��u��"���F�Նi�}5�^J<fX�����$��F�}�U����}m�`�J�w���]T ��:l��"�\�;b�d��.��T�#l}�bܝ�9�ܥ�y#�[`^�{a^dv%�Q,�J�
l�?��K�ɉi��U;Yb����[/����%~����r��I��,˫7���j��t�o�2��r_��m�a�G.>	�a��vY-q� f�I�Ϣ�/�?>>�1�~v�L�%�eT�
����HO�
-�d;��*q<8��Dp=ϒ���C+��F�*���ݱ]9���7i�Q���ˀ�3ǁ^��(5_�����G{6�x� Q�:�'�$Mh܇�%��N6����h̧����}C��n���J����¶���6����T��
J�$��:<(58J�rH�8m~�~a���hM�k�I�d������ӊ��4�"�嗥T�:��N���e���mvk�´�=)���H'�SK�Usz��6L�6�R�t����.D�B�F^ܪ�<m�!�[�3�hO�c���oZ�S8{kI�j�)��"���X(����/7�8V�J]�";�D��&�t3(�;.��b�i��q�t ��ߊ��<?UK}smm����ʔ�!e���:�iD�s��P@�H��ꫪ��p�Wx�,�y}�J*���g<��=Ȅ�jϲ.��Q��&M^6Ϧ�@HF���QD�.�9HF�E%���`��+�]|�4U��u�����⡄�x���_���=x��;ፔ�t��Q�kh-�D��^�v@mbC�a� v����a�A�#�e�Q�&J�Ul%kO6�q�O��%
5g��������Ԡ?�v�P?1g'��_�'~���6��B�H}��q�N	!��p~���,��ݬ�G!���.$�Zjm����kC��)e4i�|Pn�J��h���&��t��)��s%��w5X)1z_��0�n��p�Y%4��)#��0�I9��(x"��|E{��՘le��7��G@�|5�aM ��m&iNQ�QЋ���KF�ۜh�+����e����x���Ѯ�5w�o�3����6iL�<%�N�(�>)�O��z�Ⳑ�@1����T&�Ҳ�k�z��ϱȺ��^��1���R�<e��g��a��)��K�稓�,��Ǘ�d6�����p{�{V�x!"Y��K���Do�'�o�)KY�&����`��"?7��MN�N⎩��xR��� Qh�$�H��6�+3�^��`���"+�n�k��7F{3��׻*�L�[�VHV%��W[&�9�-��(��,�.\���zVl�B�f֤��*s�a1�P#�����=�e</�^n��M�q5�:|��"`*8�2�n���3��1�̐��t���0<T^ I?�b��Fz��Bg��T�a��f8�$��
���Br��m��w���,��_soF�Ո'�>�k��.-In�
9?ۊ��$%�lt����?Ɋ'���Z ���8'����> q~�Z'�#�����l{0�7�3N�gw� ��|�O&I]	�����&B�~a��$����]�y,ˮ�x��4*2�T�9�W�e!��vA�'�k鈵o
�����K���yVD�1���ڐl�6;r;��/�mL��H���k#�Rz�NOg���,�6Fy�"l׭�M��BʙLt�;7%��#��ԇ{�6�t)��M	�>�W�t!g�`�I����_���t��z��E��N�7!&)�B�n��%tu�"������1Qo��q8���>2�M�p	ϛ�z���A�n�����E�d:}Hĩ��)�07�N����\��g٫���=5E����
g΢"xI���o�O�L�D6V��ZH��`��		Ta5�y�ò���Q���g���KP�������	&��jĬ7 9;�6�w�*�3�b�4A"��R�ޱI:��ț�<O����{ a�<H�qS�q�I$T�t�0ʲ� A���]W~O���nK�ε-��뙞�	�UK�ai�cmk�n�|-u���촍:�N{jR?��vf����KO��5{�d�s3�C?
ζ���}N������]%����3E.�Z4�%�m��*2t��Da��kBd�s�&�lǐ�92N�^�>$s[jvx���8R��ob0�Aai�$J�4)�U��&��W�dWk%E��Ar3ufɺ6��M��0�1�'�1h"�%�C�+ �:8�`�:��RmA'�S"�R�a:�N�F�k�Ge^�t.?:L�F�{#���Ey�d=����\�d�Rs���R�������^-�8�.�"�O���B�����*�������ej2��l�QVCĔղ��U��<�I�f|���$��A�K:�#��4ƄP�&weh�N)����&|̟��x4ǁ\t+Ϧ�S%�p<�d��A���?�+��Y�$�J��P�#iè���삌����Z�F�Mg����O��hX��c���)���L��q��<%�;�[�(����o��/(�d�{��t�Yu}��Ӛꄉ�K]J~�-R�ut5H��0t��1j�A�.ЁN"�P���ő�C�!�)���_���%ـb���-�����\h�G�~F�P�~"��w�ª��β��1�~�F�����p%?d
P�
�$�{>������ha�GS6��r�Ĝ��Z)!�u�4��ńj+�1��ϵ<���y�<Q��2o�B_������m�?=H��8��+�z�����yfʍ!҂� �7�1&WQ Wli0�;	+y�5��k�19�Kvj�Ǐ�R�̀�aY�` RknW��	�@��T�Q��ԧ2��&�/4��V�F�����!��T���g(Ǽs�b��jך6�bcE��5�ۣRbM
̾__�F���VE��l4'������4���b"�����lcs�C��������g�����6����n�v���_8�����?_���C��?�����]��s�}c���-��_�p���_)����4/�m	b:��j�]���	AWH]a���=��:�F)�N���jgZљ�J.=O�>ե���!��-��F>P3����S�������A����pf�P�R3 hC���HZ��[�j~�t�eR���UW��!/5,ʫ2��U�;�F��s$K�C���'��(l�PAR3S������F�Q��n�#4���)d�MG�dP���<9q�D去k�Y%*?�'�֒E���P��{����{�/��m^�@eH��7�帤�´q&%�Jԙ�y8���c��S���f`S4�T��'c��F��5J7��ޠ��9������Әa�w��=1M�#���?��w~;M�Ԁwv��*�Ц@��v$�{�v�6.���'7.�GA�[2�8�'5Z�Xx]vi���wv��=��Y���9BB+8��Q6�4�ÈS����M��SB?���pMq���ur~�BY?�[/�g�d��Z:/yzsn����).1;H��/quIM�G*��cC�sQ��=�giiҥ���=Ǆ�������q����|U���y0;W���Ǹ��2p�MM�p�@J�'s6x�pi���C�D]��RZ�8 '^=�������[8E�����5���a��#J�Xh�@�#Ӵ�E�A�ѩF�:b��e7Q�ĉ� :8�O����~G6,��,��|^�ɰs�
������䃤��ƈ�Mr9�k$�<8�L!�da�"8�,Gc:ig�)��{�襗]�1ɵ1L ��V��<�Y�5�}����j�0s`�pVF'$�ߎ��Z��)M�N���Q��?f1�qf�������7FR��<��pʭ�	W������F�ȩ���7�I��:g�����8,��U�R����%x�B�D �wmUC�q��V�i�����K�0/��S��z,8pM�M'Xo�����э�W������e^m�Jjכю�hs�e�W��A
<IW�>���8|Ո'���s�vG���K	,�%x�ߋRӷN�\m�K�v?M~���Kuh�5�K�@����Eq*����W��2��e<�E����6e����l�ɤ	�L�%�Q��%@b3�RplD���yfr6����Q�pMd׈"8,5+�����)q~��^��̓�������.��u��k^*�H���Q�$z�� @���������_m?��o�~��Dx�+q�pZ���aҋ���E(:#NVL̐����55�~�4�탣��ӧw�_�~�狳�RB��Ɖ�AY�:]1��x}t7M���I�U<u�z=�$��ɔ�v�΂���;8�$�~�Q��I5%��*@H,�b��V�IbF���!�F4�A��3$=�|�C���x�D�Y\g��Z��\s�ĕ����q�?����	%n�ٖG�2�O�Gf>j'��i_�Ŝ��J�DV��J^1��	�I)�Q;�GX)zW�n�,��[��͠j1i���T5�i��ۏ�B}s��|Rb��ϣk}է�nr6=�/���5ч��P߮{S_�渂\˘�DH�,���)�7PA�4��Bz|�����8y�C���8�g��m,�Jk�MP�5mp}����.Xd�PH��+y=��Es���/7�"�I�N��q�)-���}�u��w����J��@���]Gb٭�������Zؘ��;,q
XÒ�!�O��)b�7L��n�Q��x�8�T*��݆7�'���� � 4e&�X!R�%xD�K%6R$�yG9��k�;�<W��'���\��&bj���8���_�@����4z}U�$8>�JSf0s��%���z�0�R��tfP�S�1�D�BA1�)iJ�XƤ�S�@��4+w?}�����	C*�\ey�$D�Y"�P4B��6��l
/ Ӭ{����,RQ�w�=����E�lC�?����bc\�j!֊�a��1:u+,_�26����p�Q�� �.>߃��Z!�X���N���+�8���-����RB�,r���E�8�A!���m�'���i��&W���]�$��u���}�B�A�y�`���\�=X��t��[F��5H���T?��Dս)>�d�C4t"���pӁ�G�ė =��=Y�OBڙ_�������I�h9��H�xL�zKo��fI�;����n ��[r M����@�����J ���ٛdCBźm��  �t���ѣ��eeƱ�Fwlj�(5^��YPg� 4�T��bP.�����2��"��.f�h��sv��`kB*� �3��t!"���t�X�)!5�Pk�k�tMG�T������Ŋ/�.�N?мH.���A�����E��<o��+�^"����)s�dc�]���j���.��Ů����W�ݞz�b5�B��bO �7��F.���<�xq׶Co/�i�A��γ�(��N�S�����VVb�^�9�*f�4(*�O��{#i �Z�_�ɶ�R��g	�պ�t���b�d�	iivoJ.ZϿ����pC�g�ܧ��2V�t�׵����\�e��R��f�jwI<�q܂�����`��6���Z2��dlk��"��̀ ��Ys��6��$%W�+��Y�e
���m���I�s�E�[C<�\��E8�W� �Y�
�F��Z6,�0���4���K�o&߇t�W����lJ/�w�Pہ*�� �i��s�T�O`0�p��o`ԟ�c�琊-{��_�rJ��!�
L�89�}5�O���gq�wk�/��C���v��B�~���ph�v�k^���m��s[;��T��FY�.��S<�,q����!o������pE�}�����9��F^S|&�f��v���Jp@y��^��Z�ٻ֕�T=�)����л
P�ja q�* �:Y��*e4��X�\4N�v���hԊ>������CB#(%zz}U�c��{%�@ s��tR70�G�ޕ5�5"󗗔T-Z�گ��}���`Z��%�*���Z�w)�'I�|���|f�ˠEm,�2wJ�s��z��|2���a�ON�p&�!x�sbٽ�yS
����B<s>�<�_"Y��<ǘ㺬Q㸖6������!R����f��=?�.�2����=��.�Ҋ�#���ꀲ�?�UU�ę^�u%�P��E|,尌��Q�����D;]j%WkV�;�_vBԯg�!�F��~�.L�b�8h��-&(�j��~��伖5�b���/��<s���:��Qړa��\ArFSWfg�Zdh����
�M%(����;�	u�*�Ey�JJ�Ic4g�e�Z u(����=2q��C��E�R!^��Ov����hx��"�V����28չ�Վ�8�p���MOE�<�.�Q�g%�w�~�/ 0��"Y�N�	��)½+T8FZ�bY��o�Y	�2),�U	~&8@��I���酆>/th�T��ƍ/�����{ԊoU�[%Q��a�a�?��}A�0S�G��N�8�Oq���-��}��C�6�?r1�İ3�K�������th�~ٹr�Ȓ�����PWϯ��awƅ���_s|��7���'����3=���,�<rOt�՜B�҇t>��q<ޞ�a��J��?m��ī��f���	����B��Ar������0�.�V8.D��_�	//�t����fD[�,(}+\��`�Q����q��j-s=a�BZ���u�-�>�N���߂hY�׷^
�'��K�InWe4d8�>�G��1��O Yg����z-�l�r�{,���Լ\�<�גP�'\��a��'؂.x>A�|�|�]-g9�-&�[$����I�٥v/��cD������)���[\�+�q���.qa�8�!��s���6�	{��ɂ(���.m�-R�{���/	����Q6S�SIs,0��k])��a��l�P�6��^��(�xh���kR��
&=�*�C�O��]���*e���W�H}����<zq2G���R����.��:�xv��X�{��4��L޺��Q%�y.\X�c
�Y�)���yFU�,L]ȇk��������U̵��O����mki������]��q|���@�_�:,�0GE��e�x.���r���q�b=�g.g�*|���̅�Ș����+@Vr��)w�'�OPA.��6����W5�i��p�zK*�@O^����L�p�hP�U�\Yh��/�Gu=�Yo���ו�AW+�����q-������Z=/�\�8��F-�v����J�L����G0�xh�K:?�M�C��z��O�����\K�^[�^��YP����=�$�t���U3�#��R���������H��<�5�r�	�Q}~p��?V_��ӳA��ѷ,�;�~�x�T5ю(3�7u'�m�$9��x�:�7ԅ�P����}uZҩ(�Z^��X��f]vZ��Q��뾃��;����;P�m���D�V��`R��*�^��4�Yd���K��zUG�&u��]e����e��Y�R���ȗv�OԢyޤ�Ee�6
��'����%�G�,����3�j ��S,T$2��6�/U谏���G����*H��Eu;�a�L1���"y0����r-��r�bE����i��啀c�\���!�q�{���v'��xUo�������<�
U���4�n����0|s]�B�9��� /B�͊~g�J�x���R�G�pW�u�-qW��%�%��]�d�.�D�=��-�u�K�i
��mjt�nY��^��p�v�B����lf;9�[��נ˿�G4�= 5ӄ+؀Fz�^�9Ho�\��.7S;Rău_Ps?H��aO�
��֚k����u/Z�ݼ����+���,����\q����k�����8ƅp?��N����p�����UaZ��Bv*�E.|�D�L{��]�����|���5���:	F/�3�л��a�*�������C��MH��u�N]ϫ��:�b���JT�0q��5R��:�ƣ���>/���vE�k�!Q�Ub6%�t�`>{����Y�f;�zs�*����3��OB�T��*-<3���+m	�6UaO��a��8��gKPĶE��PS���/��eV9�T����@�����#����E�S�W�_�2sO�n�7��Y����:�v��������z��E\�p�:5+�1;�p���Y�mJ�c<�d�W����2����ߠ�Y����̭CD� �>8�2����6�14k����3rz���z��ꚉ�9��-�Z@R���Xj��e}����b�@�.�k�7�tE6~�:»P������&���\��B�l73���߄�U����gT����'�x�'�!-�T�Tπ��J���Xڤntc�g��r!�89X9A{�{���a�;PN�RNL��&՟d/Kt�jJ^v�,9�
V�V7��F/�8����A�u��y���?"5��a�z�FSoC#�Dc�ixQ���ͮ�WӞ.��r�j��
�P��'ݗ�b� �\�?�y�2���Yb�@�vݑG����Qk[����]�b���$ �$��U��BHR��R�X�5G���WE���1[Cd�=�$�,��P���lI$��#\q�>����~��]ߡ�w�|�v�YōA�����4���n�F�\�
�Nݍ�݄����Jt�vɬ��krJ��S.�o%��A�%Ef��E�\���x�NՒQ���ʐ�v�h��*�gb�1;�1I��@=�t� 2I�DO'i4�ށ4�ߵ�J\CS�B>�9�";�˩��+�+v�r��|3��y���&���+�)�@�dPq�.����o�Lρ���H���WDS�++����ž�����dqJAV�G�߽���k~}ASɵ�x������f�(�J7
��-�B9�>}B�+%�@u�	��q9W�n�儾۸�ă�_����K4�?�Cq;yXSZs��qY����Y��ߜ臚0����X�&E�ܕb�c���k-��6Ƶq�x8/�d}���Ǿ��Q[���d���g菤�H[-]��ɜZ(2�<[��iQ�+���s:��Ԥ��"�9��w4~u�T~O�gݨ��H�@.@���1��i��)�����),
������/���"Z�%�<c��,ޮRf6u�0�]J���>�B�4���ԩɄ2(��B�A({h��)CK4AH-�g�qR�0��I	e�g�립^2�j���I,��ߞг�QDB=�֬,1�P���Jv}��P��j`.Lm��N�F\Z��&ɹ��N��q��0]�{��7K�02i�k �@�E
K��f��K.�"�PB��T/�+m��"L�d�����H�� ����>�U[Đ�4:�dk���&��j��0z�B)�`J"nH�u�?�`N�F.T��'erb
Gr�!�cu�u�5>��׃��n("W�m=�d�Ť,YX�T쉭�l+%[$��9���HDþպ n��kr�b?}סV�����&����dӑ���K�ʼ�b>ov�������S�X�p2�..��M���	߇���;����| ~�`�})h����'���M� ��1$��N�uś�IYZJQ��ӥ,_�is��q^(6V�"�my�kE����X[s-�Ǉ�l���P�[�f�#�98؜$��E�Ɨx8��X�xD�� 	ǔ�c��Qu�
$�)��^-Կ[�;����h0��e�����&��eйؘ�/��ս�u����	#�M�9�&�:V�)���N�7䎬nK�=��Ժd޶����^Ì��n�E.vL;P���tYH3K3���w2�g@c��xg9�;̕����S%_��I���I\�l?����8H��9\��բ܋x�Ƴ+�� o.��gm���
�15l̂�;u|���3W̜Ч�P�QY���{���`%�w��K+�#��HH�������H�@bOy��6X����b�f�����wc��P���Vo�{������j�*��Ws¸!,5�T�1��[}�+�Ruߘ��^گ��*��z��p��+�X	�rC�p���ܲp����-��.D�U�ݦ��������p�v���n���ݶ�q�U��p�|���B%��sn�ȓ+bM(j���Q��oUy���xug�h;ڱ��崱z�G�m���M*3��U��i�NM+�>���ÚFG��d#��0Д1')l�iND�t����'�,z��?Nq��}�M%�f��"���g�g� �?�;�q%����P8�oCl
~�MXic�F����|�9\C1��r�/�g�&!I��X	O�T�*\��X_4�i��P�!����F�N�PH��k<�Q���Q�oN�����4�L4ˉ�'i����aڿ���A
�gp�~ҹ E^dY��o�U���0ǞT�Ȇ�?��5��z��"��$ƣlt9ĴZ#�s$iT�7xC*$Q���4��rN�����u�L��.3/�It&�x�畩����)�45T8S�"��HlH����ys�
U�
0�j3����سm���J�v=�/�T��+a�\yW�t8��� �X��Uz��]�`!�C�2��X�2ALͩ�Rx�+�9����5U �X�F#1�gf �M ���n� *��珍q�T)�1}}�.�f��F�
q�#%N�^R�wM�~��z5l3�,2%禣�Z-�&�m�/쇓Y`,=J�AW��5W#�*9����m�׸��ğJ��HG��t�.=ӷ%��@2�����z��m��Qt@�-w�~�q�v�.�E}Z�>W��Q�2��K`Y3��QR���J�y��a!Y[A��.	U��	^��;�g��Z�;4�b�Kˇ���9G���B�+���Cڑ�H�ד	�P��#j���"�"�&�=���ߝ��
��	��A^���9���u7��!����S��k�X+���w�z�vh���{^ҚW)FhQ�7��#x���/y��k��Jj}]{��/e�͝��+zc��1�no:����C����YW������p|�&����_'��#S/�ՙx#�<�"z`�-���%��|W����M�Μ��u��08�t��e�eR���iY���WG.�7���F'����w�HIL��:�����.������Xl}�����dd-iE�W͟�'[�_6iE��D�F�3��N<Q3R/-�:�&�drw�iڿ��t6�I��e���I?�f/[�3�0���c�kf��̛gŧ7n�8M�S��-�U��a9�C�8�6m������Y������l�,1�~�*�;u8���A��}�l�2O�h�3�%���h�������A��_zZ�� �mf���`"�s����}��û���a�� q��h��mɒ�eo��3�!�TL�@& 7����m���ա��Ho@��/њ�ϣ����b��A�i�yC�^�18� �p�Z��p� d�'�e6��ٛ��
��J�ph橎P%�ZL�P��'oMLۃ�|
ZKQ�Q3�52�tW&1���Z�}0-
��,<�@�Gxț���DN�Z�2"V������	Eeg���2����VJ��'�Ċ�$�X�;�@��`��a�d��l,����~A^l��hi�[��/�^��΄�a�P[9o�)I��<+6N~E?. ��u��0C9<@W(���t}Z�Lq,���c���Kn���SP�<'oi3�O�O0�P"��>m��e�@�K�h�^@�SXS/�(���>��[�);*��f� �PW�d q��a�m}cmm���V����[��k���{fl���~ks-Z[�lcs���ۚ���l�j*/�n捴�j���z3ơ�D�������������8�;��I������/�#����ߪ�����bCn���?������{M��}��U4�I����/��?����������������W�c�?�_}�xg2Y}|`.�������ڭ�"z�68��3��!�>�vk��[����_|�v����V��g��ރ�㝯���m���b�������m�O�~9\���_mն��NT���fu4^�c����c����<�߼uk�3��_�p���_�ѨM2�w�h�P�@��/��$�������q��U���^C	�pa-��m0�n�(_㕶Hs����qA�v
dsO��a�l�-��	�JH���㉞��D�@ �沚��N���+&;��2�9��'�a܁60H�MI��,�?;-E���U {�E���͚�rª9$yK}�H�0�#���l�i�2��J��5�5ݬ���1���lwg���1���T]n *�v�_Ҽ0����a^B��Nǘ��^�[я��v��V�=q���A��L=����-��ط����6I�zp�l���$�;}5��`ڥ�Q�YoF7oR4Ŷ���w�&]Q"�t��%F�E����Q7DQ	x�e=����L�?P�S�!`�x��)fo�h�A[K���t����b�(�a�z ��Z5$ l L~���W�Z? e�]?�bKόo�]���<����η4��r����N	2�D���}"|��߃�Ɨ����ӿs��o��3�����]�]���L�ڡ���u��c�*��F�*Jm��r%�Pɭ�ڧ���d��:?��r8�T��#W�7*��48@���J
Z�����H�:���I�d����;K��E�PD��&Q�������������:���㖽�l`���tP��A<:���8����Y�v���iq�/�t��>T��"�7��7��`���W�!qV7��P��i=w���	�6!G8E�p��j�k�f��=Ϛ�=�m���a�I5] ��HFX��LJ�XnJ2Ј�	ti�-'�����j ?�>.1�h�JRʡ��|: W�R���#t0ktJ4�S&����4��䶭g,[�j�x��L8�oܿǖ�Yop��ǿ���K��"�Ƒ"�ߥc5	uȝ+��6�IFѝZ�+R���_#M����,b`��a<��X�tu�����`V�X�}���l��l:��zQ��5���+ǄF�?������Q�2��T�WABj�}����O��\�!D��(_�����sw���x���l������������OQe���~G{�d��ѧ�Okulp�<;�à�����x��8z0�cr`�
9e����b���y)8��C<���#��'!��o�$��=!ː��|����L�C8bɢ��QL?�[A�ܲ[Bu��nڈ�}ɯ���h~✚��ґ�B80��c�e��v.�[�:����@~K�c�����4��.��HG�PI^���s;�)9��>sO�XL�NmY�Sê�"��aN(�j�G��Ždw����f�t���?��KzƦ�`ъJ:��P�w� b^��⼜�T|K��nn+F?+�7�u@�.�~5�.�=ɰ ���X����Z0���d�`�n,�T�1D�V-�$D�w�af��k��qZ:a�k*af�՘�ѥ��W��S�	ۓe�<�?N���0?��iWg����	�bY���^���"Wj�Ns���ifg��Ag)����CL"c�UM��t��܀������u�5������{�aۊ���ي�w��l�,�2��?!�c1�n���B�"��:�I�Hv9������w�{��3�\�ql��	Mx�Ǯ�W)L�{_P@<|O^s|�����Pb�nN�@����Bih)S��J|����d��q����1M�:a�%3����$y�!�?�"`4�|��=ʺ�ӊ;��-��Nz8@�đ�;�����*:U���/��r2�p�n�C�>Mp`Fo�j�=�W;r2\���O+�<ڨg�&��hiP�s����h���a���؎��͓b_UG��s��ݴ@M����1��)������*QҘ��.�x�4�|�O]�ݡ�zT��?]��˘�z?��6c�Sh����UG>!�Yo�D�����[E�x0FWb5��2��xc8�F5�KV�6�<�k�`��"���3/j��b��}˚��
�#!�샿�Kt�����:QL>��S�
�1T��4Dr�m1�N�Wh����3�L�8�i�=�R>�W�+�\�Ǩ���)ף[g�����N�9����E�B�B�!-�;g�*���<'S���1�7��	D�qM��.+��E}0��'(���L���xNLp,K��n�jŏ≚'e{�qn�lE�� x�0���R7�����A��j�W���J�f�!�O!y���逐+��bc�ym��ծf�Ƅ"��m�W�P#Q^c
Nd/k���͋t'#jo�W��h)^i��4Jz=�z�b�0n2��cА�'$�0h(�3�'���(�_���>��:w��%��d:T�\�ѳ�{5�I"v������"��3�J���,Wk J���BU4�b�`o��;�Jzq������k���J�b�]W]���������F��8!�X����:����jl��B�e(Ϧh��\2H���7�o�+��(;� w�V� j�Qc)�5�>�_q-�s+���'�PX�������M��N�'S�Q@�i��e��x�Zy�8��V���#�̢�t�v#�_�&�=mB�1����D2�&ݕ��+8t�q�J�w�Q<I3�(e�م�J�醬s�ٔ�"���k�/�$8���L�ݶ��\s
�N�5Ku���d}��r�I6!�;4*��K|���Ҋu�\����n�����rB���&�~�:���q�w|�O�c*�����(� +���\��փ|)���P�ʖ�w��Ӄ�$�%%���n��U��~�~�dt
N�6�.�vZ�����to��P��
ܳ���?���gJw.�~m��>���Yb�ִ�}e�Jb�����N!��X5� �\�Eit��ݨP�k�DsW����h?��k�)\�ʠ�4j7`���m:z�l6ͬ���{N�1N}���H�^,a���t2-��u�V�rKL
��e�41ț7��d�x�j?�U>���A�A�$���q*H$��(�(:T<)�q���x���dp�#��t�O�d�N�T�I�s�<�q.�K��8P7w<zo(�
Ϥ��9I��UR���a�����H�B,`��7Ph%B!	_J}8^���T,��'�x��_&}]�"�i��ߨm��p#��6����yT96I��(JL0,/	�/��݊����T�76@|�g�)	_JU�4��|!�}����gdA�B�`���((ب�,-
���R��j�c)M�S+�{�n�A��,��L;��A��Y(�O�8仪�B{��%�0�~��4m��׈��U+�	U�B��!@hu�5�"���1D�e`�5���x��&%���H�W��ʙ^H���v՘f ���F-q$�}�{et;w_��r>w_˿t(�:�ǗٴP��PI���>��ì�
YOw�_��=��T�G����M�6r��Z�k��$;�t<N�'�3p��������0��*�^_�]_�!���g��>�1Jc8�Ja~�:�/�[k�	o��"g���N��t^����as���r��up�𥴰.^w�t5ء��K��� K��Wg=Q�I_�c�	�dƦ���Ev���KΘK=$��lv�j%R�x�}G���,�J�âSN�ʈ]lP��u��PWK����p��c6n�v��Cu���m�<&Y�s`�S�|�fx�^T��Q��z���8�\`�n��G�W=�أ�$�����M�?�m�F���h������Z:SD��e���/6֜�_� ׵���8_�[��J��llWm�S��M��'r#P�"������!�,X��mQ*�:�h�=����Z�-Z)��^�K)�!$�Pw	5��ܝ��n;��g��%�S�B���G;�����ή�4S�r���q��]qߡ&ψ˳��{:�(uO��D���Y�X�&٫N���Q�KvX0 f���ڻ nM�Jo�O9�kz��o|@}�h��3�@{���U8\h�5���e�(�n���T�+%�]9����A�u7�����#�%�c>~���Z����@Ek]�+J�Rᵈ��������պ�O����ؒ��K2d6#uUjʲ���IFH+0EI��ȣ��tI�~��ֵ����B�:,�5��ƨ0g��j:�3��!�M�f?1�@x�Uo�J=��әN&b�3p�w�� /KE��zK¾�l|���Z�@����O��&�נ)e���#�B/V����"G:�9g�F�&�I6l	�)&,	.^]d|�c' /��s��c�&��O}�C�wC�U��]�A��J����r���^u�)�i�.�thO��1,8'��y�	�s��lʲe��L�h!��+,ٟ��Ǐ�Fa���:7%�����z�EM�p��w�3� ���s蟘�^��8(��A���ۺh�I$���}2�OB��+��&�첩?�|	V�qjE'R����;�}�?t#����{N�������Y�B_�]�
E�_I��3jp�U�/%�(;��q����G����r���l%f�`��RX^6R����N�������� *���pp�E���;3 ��[���95�)�
I��Bj��K�/T����{�����A��].��	�L�A3��~1�|l���hU.Έ5��Y�Ϩ^M`2�v2<cLTk���Q{~8Z�nR*~Q7��uG��ь��i>-z��x_�ǥ2�b����߲�1�ɕ�1X��R�҂�ڷ�����m���q߷n-��e=Z[�ڀ�����C�����&~yw|`.�;�_��o�������}���_n5�ֶn��o�������g�~��}c��x������[�lF��3���~@�"����7���O��������?���A��Y��W� ��|`.��}���������6��_�������������N�y��uk}��+������g��C��5��`�Z��6{ڰ@���ㅝ������RpG�}�����L0�� ��'E~�]J=ׄ��Cy?��Q~�����:��O��y?J0���F	����$4�4g3��$T����A�y��q�*����&�����@���S�7�����G��ѧ���ݝӧǻ�7��{�A�N6���u�9Ili�*���)�=�b�Ԏe`���emU��V���M�Z*�1�0�ぎ���֣���� �nʽ�����'�ۣ�J�|j�,�P.�d�"�d#�m>��d�:�Δ�੎�Ad�g��7��g�sΉ����RR�&�6��PWi&�?���	d-�&	�Ew�$�p���̼c��w,Ԏ�I%*�	9bB	���37O�%�<��]2#�m4W��o����[Qpa�q֛�����V3�s��	���_����5�q�&� �,L�,�u���a�3�n���M�+�Ӏ����ZC�a]g��g��A��R�X��~�
g. c�l��Q9�PQ!��A̅�������7N�vw��픘φb>s���,8z�=O�x' +7��zb�"b��:i��3��"%I��-x5H{I�RQM�`�}(�F~IM���M���p2��0�r8k�Q�ť̻�P܈q@^���ԿI���3ʷ��f
� #�` (T�0%�B�6��9�AaN܄�y��xV��)��jb���^oD�٫>au?�/Eq�@����J����]�;!�y� �#Ǧ�*:�P��1X�7{�ipojp[7u�y5�E��74�n�H���`��G^���~u�~���s���s�#�;�l�e
n�-��t�~
�i5�Et����9�=�q�6�U�
�uÜ� A�����))K�=C]FY0<�{/�����I$�pEH���˺h�˓��,��v�	>-�a\�H({���s=Q����j~����"I�X0�I���}@��#����>d�_A�R�	
��.�+6�i%�;��0�i�L��� �9+3�	x=��m#MH��ykg�nDUqiAFlb�|�/�pU�������X_IHRm�4GO�oU�S����j���C��$��*�#GfW��g!CqӁ�l��f�Z�m�L96�ؤ+�S^���2.�7�dr�z��C��\t�&p��٭㖋�\�ځ$���lޙ�lƪ�p��#ʅr4I�Q!y�{�w2�-�N!��h��e'�A�m�k{#N'&�X� �׭&�5Q�=�{�$�;8��=�}r*��b��G0I�13L�¦�P`^blW�)iQ�D]5�e�s�M;�������&�04s�<׷�����D[�w�z�5z��z�"����Խ>_M�nE6��q����/-��Q�8s
ҁ��8W��y��z�
Tu�pn��=%N��(��.o
u,
��@n�L��q��L�A�Xӹ�L��$�T��η��T��9�5�]'þ>���4¬�n�`�-��{�IV�"���e��J�h[,y_�i�@�(X�>H(���XA��&�Lx���1����u��EN��������L+�Z[Ѷ��&L�n�A|r.,\]p�|�qB4;A;��y}C�Vy!d�A6��
1�H�����~,���uB*�P���Y�$9%xk�Hp=E���� �k�+N@��1�Rt�)r;:�~����B�'������1��b~pF�I��r��TKc���~�ui�:�P2�?_5Y�0�"z�r�/�׀�)�S��{��\:f����<سP	�
>�w#�Ty��3JF����Ɋt8k�%�mCU�S;D�t]3�&���56���� UM�mE�E�io!j|�AW�̑񳘷�"���{��͔w6�b���|ƺ��)8�]���3:�@'7�J:��h�3�|
%��H�"5��A���`�4�i
�=<�+5�!ލ �}�O�m����0շ:;�U�(��r�z�P_�6 ��f~���B�HMӄ���B��Fٖ��d�%R��,��*����/K7�r��DVEZv��l��.T_VP��tQ Z1����dw�����wA��qD��d����� ��q[�LF��k��7H |E�s>mu��cGs�:�0���C�3��''��8Ť�A���g���0��?�j�g�lD��n�iC�i6���D����.��<��cvbK��S��tHK�CX&��PC�8�IrT=�y	��td5j�q�M1Ďl���v3L@�����n����mo$<�\!�2l����Q�=%,�a)��oJ�C������t�rAL3q����5���Nλ`B��7�,	V~�2��;�� fY��C��=^(y�(�� �V�l�<wC54&����[�)�'��ߌ3�e�"k�(�5qGK��4's���	IV~xt,���*Y0�s�h�z=0gj��W�\�q�5�S%�)�-��>S,��(��nh ��G�?��ދ>_�%YB�]�H���,�S=���5��T��MN#i
�T���{^^��\�HM7O�t�EV�`�m�n�;�E�u�1F*lL�*'�,*1Ө����#��ۓ��eɾX��$�W�`S�¦�} ��!�T�,t�e�q�ƻ�n��	�''B��f��)���L�<o�K/l��Q�mHb+�l5�Zf��4t�B�0�a��l�V�HЮ-�~��hv��7����@/��ؙ������h��M����F�G�{{%���p;T��~�(������T	a�R�_� �ξ�6�D�F]k$(�����qpґ�!���|�����<�RJeP�(�<n��E��U+�@�g:Bw�1՝��E�W��Ҹ��:vu2��@/}e�L�VYs�4�}c1k@�Dܹ���^	?kwug�2�������6���)h31�Q�Աs�ԟy�%�Lv`K
y»�O���pW�]�ν�:�d%���nӽECah0N��=�$6���h��B.`��V~$m̜�8c!�e�mT��I����nR�8�bH7^����3��<O
��ն.�E3z�{�����w�w�Ov�ވ���bd���I��Y�˓��ᇂ�M����"���J&������`�o�h[kw�Vw.khl w�2G�%Y�TW�/�cl#�\��
\�C�:�c��u����&�b����E'��f�L��ΑvC	Uh�=HBs*&)U��|aP��DL�>�TĆ�M�I��gS�"�S�k>��=�*�Q�3�� r��D���X�����#栜��y<��S��Z�ia�B�͑�ꃙ�U��|�S�R|0C��<�-%%���%
>
J��'��^�EaxI�W@�QL.]��%l"�*�4�	md��;:��@�KG|X~<H&,�H�}��֌l?�@��h���h�����c��fzn��s�_�##�@g�_�,d�^�/:�.��"pWǠ�~���� ]��ì����T���[��e�P�h�=���Ӓ^�f��YEc�q�Ϋg���Ϩ�M�x�(��C��M�0� �^�5^u�aiL������^c�X��(5D1����p�s�����������ϓX@�m=�g��z�� ��q�n�l����B�1��<�T�[���3[�i|�%�/�|ǅ��)%y/��[���+	�AG.�-��0�o?<΁�zʩ6gG,8��Y!E�����ۅ��p;�����6t"`l��&mj�;Ì+��9К�~��֛��ჽ������S�*G@x�� �M�j��!TQ�f��6��	�߉�eW�O���|^(A^��i���!8�vӮdj�d9t����c�!)��'%#[/�f ��������>����p�`���e�nnǑC�� =} }0��x ����I� ;�$�th���3Ҫ�["^�OǳA�FZGpN^�	���K��^�b�M���� � �I�Iy�p�E���'�����U�7�;��	���S���In?���.g�P$Кѷ�6O�<����Lb6�	"*cO���a��^�%	��n���S��_*��	�Z<?�uU���ˠ�G&諬���;�/�quW�]C��N��$9��*�tw�3������k0�Lvp��zJf/nM%=����
?6VFS��[��Go���ڹ΅�Y��%����N��|J����{����P9��l����)��\1�&2�Y� 7=/tש���ܐ0 �V.���g��s�������j�㲷��L��Ũ�`�`z����}[z��.��қ����@����T��a������Pi�����&��H(����Y�����$�R"9�����h�DP2�YF����V�ϸ�@��s��BK~����<_�Y��
�������7a�� ��N���kɱ����=���L������x��vD��&E����ւ涞kIs>7�Ǡ��4W���f���e�nX��0z3bA6���A�j��a�?�����Jцd��9���N@�$���v5�y��J���I�ӱ�4��!0�t��X�&���f����{r��.����i��dg����7�/��_w�[K�L`Ru�Q�3�hS��մ��Vs.�D4s�w�@6 �\�l�<��m����~�� ��;���8D���ܟs���@n�.xȝ>:S�aٿb�'����Tq��6�M��y_�LW��d��P�h�/s�4�4w2V��x
��P`'�I
��X�j�d%� ;}]oـmS��+�w�;}{=3)�Y��Ȃd�{F
����WD�����h�Χ��`����q&+��I(�� ��A1f@����F�A� ����
�����jC3�p.Ë��V3:���1�4:8|�wzxl<��o��J��Um8H»�c+�Hi�����.�@<�׏&����[�DD�0b�����d>�x�1�t���'=����6���9�OJ` ��|�@��G�o��8�Sm8gI?~�f��9�����:l���y�\��"�ԃEd��C��J�|j�x�#~P)�bޕ~�"ɥYJ��q�c�i1}�W٩�zp8N�!~����%5�ٺ�o�M#��v�R�c�W�$H�y
��oL
�ܕ�yX�F���X�e��x��n��;_(f��8�K������Y8���9ӑ�:�8v0ާE �Z3�J���nfg8�*���6D������0g����F]]�'!xs��*��P��1r�VOhl)A[�;�b�b��X��*�,�-d�_а�zynuy��L����I�>�*�6PK����7� ����և�o���!����g���;>0������׶�>�}�`���5�[�����,��i��������}���7�P�;�Nza�k�����k��k�}���~~俟�Oп�2�K�~������>�������/�X��A ���	�G��<�߸�U���v�������}���Y:Z=��~��q�}t��p��gݨ}�(�=�u<�4ڨ>��<ZU L��
:�6��k�!��"Q��I�
V��Z���fA����xw��ݥ�tms��ڝ͍�R����]�dK=�nw��[~�~gsS=��n[����<���?�2�����׻;�����ӻ7>��_v�oԾ�{������ý�7��:n�jI����F7>y���ǿ��?h(���\$���l~������Z���n
yղɥ�,Z}�o�95�/��W��n?2�P���+
~ߚh	��)��o������o�
t���Et�4uj��g�ї_FK����jP��F�Mn��f���va��͵�=՞��1UM��m�v7�6�
�ȇ�h�D&�K��v�҉�/�R����|4��7v�mm)�F�&ڶ5�r����P��خF�K,I���9\���P�"�e���Ԇ������oËm�C<��淑�S�8<�vi�8	A��i���9�3a�8���z�>ˊb����E�f�j�v�e��$���=��nm!]`��0��e<� ����{�,��X�?0<G�%&)�LР	�a�'P���Aq3}v#��!d�V���Oπ#4/����Jtc���޼�z��UDs����P&i}p� �����J�\mX�+?L��ԇ�I�>\䯼��ix���>������r,����
¸F^)�! ��&�n��F9ܪ�h�-��n����n�1��F��&���'j[WLT��DŘ�zh�r���thHЋ�z�,g.1�s^$�Z<zVv%��&�>0�0#�%�41\%�DmWS���c-t�c��2��	�p募���]�2t���V���|
m��Jƈ�#��y缷�;���C�8�s��#��9����C���7ʽ�i�9.�Qf��Ӳǳ/�h��p��+!�&�	���G��p��S!�x��Rml��'�Z���NQ�rɃ�r���V�ϑ����/4�]�%5Ѥ�w7������5���������v����[�x���#���
\�1�`x��WS�t/�Y�>W�K�]$=zQ@+�:�u�q�� �o�w�]�O�#Z(Ż�(�l�/�����>8|�[�mx�v�|N���O���;�;�0���Ui&�i*d`N#8n�!D^E�Ĺ�\$�:m�X{�}C����?��	�%�n��56��ʧ8�a�O�I��{�[�F�6!_F�{��ҋ����n�,���i8�A�CvǞ��.�È#�!|7i��$�%�~<N
�T��>�.s�|_��}u�5f�FxX����C�7�"u.�xo���U�}����_P-�>���}��O� Mq�k���r�n�P��>y��Xh������OA5�n0ڌ���腰����V�{��w���-���у8���ʿa�=79������'�e����Gͨ1�_���bQ(7�E�&3T�s���Ff����y��i�	\t�J�j�����JLG�Z#{�Ŷi/z5z�{����OG���B��g�&<�Ll}�ފ���������1���(�����f�}l����1�1y���#<0���N�ox��f	V��t.�&�
Ɓ��)���bT�-�*�����O#ukG��F��"�-��{���:���E'���ʵ����w�|?���Φ������zoE15�b� �!��q/).���ɬ�hEOG#�:��?����!�\yL���h��pǧ_*�Yl�Bo�
�M�T�j�B��p��,S�o+�o��o8����"�K�:�@��I��5���z3څ�����B�u�t��.a�-��L]Ft�a6����U��8��T*��ٌQ�u�aHF7�U?${n5�@LE�=]�QK�}�8T��nݤt�*|UGH�h��Y뜴X3\��
o�~���ߤ���_F�3:o�vv2ji�2�Q�JqBҕ�q%��$Q�E���&�ŬX�8s��,����w>�T��,�%ya}W�<��O����@����lE,ER��ܓ��njo-A.V��`��'�	o�3�G��r�3��b�eb(��MK�k���s[Jv�ӡ�rW��2	8��ҡZ�V���e�\�~'�&��� �h���GI&�N�H�B[~E6#�F��(G�u���!�>\H�[�������?z��e�#eQۼ�s����K��eA>���\��]��3����H���dM/7f^2���"��l�yC�/���%;�����Ղ��ql�A��+�G��K��w�F�;�}���U��]�(-B9U��nh{7�,�Hna�z �ҬH�T�֬�G�yz3̞��I:m�Z��V�!��τ��X+��u7Pr��d��O�r>��7����&�gZ��b��T�u��ϡ����I�������6�������!����.Ui�BV��E��lR��!(�Pj'�,�ǝ~S#L�$�S|�DV�m��uľ���c�a�N�>W�_4S�n�ՋǣD�z�:���#;��rJׄep�V ���o�]�c���vũ�%l8ȋq+TM�\cL	}����o��5Lj��GaW}�`����A��\�I.\�����6�
J�`]d�:��Zr�~�����b{;D<���h�hhI��Ey%�Ik�xk\M����>{.��D��<���\Jsa�?���������!�r�����I�){���A�[ݦԴ�bT�Q�������򛓼z���O��L�m� �c�H��Api�dVsÅJ�
��f�H](����gQ��\�6Gw[���5�c���������E9��3�I(�YA&�	ZDP��=�l���eE����Ч�fQ��hA��?�����u񴛼g��P���������������2x�������_����Z���[�[��������?���?�X/�m����^~�Mv%(���_��2�k�+V�������.{)������C��=�4�Z5��7�Ń�k�)]gǃ�;�#��z�/��*�v��)���B����QK;3�>h�Oz�������$�n���4�\@��Iq�f+zN�<W��-���h��!Wb�v� cFXM�V�ȵǗ������f|����/�$��N��X��ˤ9��b���S��Q_�Z��P���2o"�S�=��F ��	�G`�}�OF�C坆�
N����]�k�9��/�E�-�����ct����ǿ�ۿ��MjO���l�f3m�#�g��4t��lt�V[oJkg#s�.�4; �:]t���jMi�m��a\Y옵�値�`��uu������h�*�/�v�����RDu;�e �G�o�ex�˭�7�` .�t�	4�� 8Uh﫻�A�_�}�*�]��o�eC� ��an�MV���[��ٌ�A�*�����;��°_�6P5���'���a��V���r?ͺҜt�,!e/�χ#��A��<z �����}���(��F��1%�f�b 4(��Bg�oL�t�I�#X��C
�tDpYE�����ꤩ��a9�����jK���k��T���M�H�>S��>E�� 
��9(cу��軓t��Kp嗊���[�/|��^�j�f��4��a�.��#���5{o�
���A���!�ϙ��4.�P
�ӣ8����)(�b���Ccr���x	����4a9��^.}<���B��3-��
`GE�fQ�rJ�~�vZx�������WW�ч�1������x7�_�j�8��|��3N��Q}}���˂��X�S��gܩ����|�������:����`�B��k�Ŷ�Yiƚ�􌿱��뵺�l}o`�0*NЌ��4�~���u�v�PviαͦH��-2�:jo?�`o�n��ê�j�P�ԲMص~�M�f��V��y��g�L��u�P�ފ!�TsI:$�ӓ�0����?`j^���V<���b �>D3 �;��X���C=�8lص�>��9��֒K��:�ú�eO�Ꮾ���=������X����~���V�
B��l���yp����|F��A%{-����l��#���1�s-�=����[最�̃��f��ƫ���k}f��$&ߣ��n�xM�8�A� �D��

��\8�ņh%�w�W[B��}���iz��v���b<-�U�oLx:�f���Q�2tG�B�s�B�o8>�y~IS`4u%a�lg۲���ֵ-=\d�{�v�n5�EL1k=��m�>���
A�ڇlrig�9��j��@oD,]�%P;���>��0,L�����P�tb�<T����L�G�;SY&�i82�c�� s�+6�T[Q���-��oެ�M�yS��;� u�h���!�/�-�y�m�6��v�tV�z	� n����~�W{��������9��͛TL}N/*<�JТ2�_)�J\�hS���o
�r%�!�a�T��y�����Z��V��X�^ ����魐������Q�n�ȫ�Z��T����X�B}����� ߺ�&ٛ�@P�N��^�J�� `mDDT��C  ��p�4�:����P�(���(L���n';>FN��4�*L�H&��9!�	ܻ��!<w��.���:mx �G�ÔT�=�8"=�j? ���u�yQ�[�D���_5tG��|��/�����8ssQ�[0��R���q3�`>�鷱��.�EO�
.��B=��C{�gR�� �F�Rm�6�S� ��(lb=�e1ќ^��A��*갾Y;��r^�ȍ�C]j,�R���J�@�����ӽ'�Oڏ��w}=�i���l�)k��IЃ�X7K��RA�&BQ>y�|���0Jl���Gm�,R� ��z������6���SrP~z�b����vZ�ߍ�y���%��MF��{�v��3Ә�S�7R]�:�&�	њ�n��7�Y�s�����~Zl�=+�F2�X�)���8���G�3�w��9�E�PC�V%�-�+�G&�s�!���+��:���(���w6��i�> 5�f1GK�D����j�K�=��l/Ȣ���]L���O�EYZ/��\�L-a'�D6���g�zfN-X������o6�AT�cų���݅����+��I��Z\�p�C�U���=p��G�e�s���a��~��g'��r�	���������>���A�Ϸ��������������7o}����?���������omn�*��������������?�ٙj�%K!%�1�߱����C�`��@)�#���=����!�9N�������6���,���$i��"#5��:��������ᓪ|"�������{�=�#�Ae.�M6�n�RѬ��<P���ߦ�f���m�Q��I].w��lp���t����l�	;�O�:<�]m�ד��='��޸@�����#@�P���縱;	��^g�r��Ҫ�ߜ���P�sV\	�(S�K��9��o��C����K�'�h5Po�.��AOZC\]� ���d��2��719���!�+7�%7�!ӣ�Å����`���C�s.�/2x�̋ �ѥ�d>�(Y+�$�
���$8lS�
n�rg:�@.e�w����yfa~+�:J�lMǈ8�F�$!`�A��"���ڴgjk�nDݍn�"�v3C&!�hʩS9��鵶~���/���\�לGj�<d�@H���!��F���M���HFf=��m�z]�F��s} R����}�A'�ѿ�����g���]�������qI��<E6�G�(� o-ب�  Rh �n����J ٬�,UV��H����]�9?f�l����ٟ�om_���<_"��U�Ms$����̈���}A�n�,�����RRaw�����lk��������c��jfJ�W��֦���Mm�����P����}v/�"�޿���������R���Eѐ*ӂ�9���2�Я���AB|� q�X�D�@mr��Y���h|=�!�w����x����)�'��/fM@���k4�j{~X��ʲ�9�ث����u)�/�H�
��5��9��^�P��3D�b����ž�<���3�ٗ2gM��!������x4��=���im���Wz� ��w�i�2��Z�����5���w�����t��
�`���2�Fl��5�ͬ56�@)Om�v�-�p�sC��i]�QW*�X�#��lɳ�EN�0���=��mk�ÞNtm�*Sx˟+{���Z��j`�p$nk>2�\�Ni���~|��ە���U�:���0�"�R=)�8m�I��L�"ϪE���>d��o�W����`Q� �Ӣ �t����jz�xۈ֦cܥ9�5��,�;붪#���s�[��O��L���yS
;/zjg}��	�U���"����)?�t��l��ׯֶ���KΆ5*��%n�c�4��7Gۘy<q�HT���	T�(�Z��SL2i%��_gm|��X���أ�NA�7M���L��Z�f؉��	:l2���M6o�v#B~�-HS"~I�����=��O�<�Q8�dOb�CD�o�HȦ��}�ʇ�d����="�Cr�)	�?ˡΡ8g@��Q� p��������.�g��뙁T���W�I�d�b]�m�N���C�v���:����ƣ�%�{��r�L$�Ëpq�k6t]�d����A�����g��znH��
���dt0��@Bmy�(�����f�b���7FVz���Ȕ��I�Q" �K���}1�؜�c�D��|��#������k�J�E+�"q�� �a�TL4�w�a��o_;c|�7�TO�6י5|t� X2�G�i��)Q����) u^N��x�]��%{��7��J�rv���ד��\�����E�-ڰ//�N"lU���Ο�F�ʦ������8��i�H������o:g����\O���gY����y9��A������N,e��Q]����"���ц�j�0�2d"��\�F�ɠ��d;x-�擞�G�0�z�~ᅲ�<u/���,&L;��i��n��v�qu׽�!��Tc�I�x>��;� ��Vመ�t�n9y���y������|<��++����ZL�`rDx���w�i�Bu��u��
~�E7�ޮt�a���tS?8_�;0�o2�i&��V�'j�Mj�W^ƣCV�H;�4X+�}3d8g��n�2�c��yL�Ɇs/Ng�o��X��Ƨ�V��h���Y�����bLm`SVO|���ƨz��ê�WN�K3c�$�}H�- v����������a<W5r������~���{���u�*��ـ_#ẚ�ޏ\��gvΟ�\W�ȕ��[���٭�����V�����q�$�g$��$��+�L��F�i�L��%8 �`bD����s��n�S��#]L_H��2$&�g�~���
|����e�L�ۣ����M��~��j�ۄ��腊nfC�����4�~��{E�Q����1����N����N��,a9�?E�iđHTi�k�adrq�.��j�5:��׀(�d�jw����\��j�?m}�p�Կ+9���|W��j�p #t�2�<�T��	o�S=�� �:,����|tF�LhP}�㼟�tz��ܹ���Adz�`<QuVO��b$����gvD��'��:����ѥ��џ.�ct�f-��g�xs�q���ޗ:��B�����e~k
����շ%�ħ��z�n�7�Z5��)�a�ff�/��YoOʩS]�+ŉ^�5�mu6��}/�{p}I8�X��k%ڛ�{w�3��e0o��Q5Dǟ�~���<��8�#ł����l��(^<
�yj���ҍ���N�JM��/;)��i�-��(T�P�ǿ�� õ�`~_��1�دq���=�̊bqW�[/9ëU���^���ܺ�g��Z����稜��l~eR�V�b��n�������5�޺��+���E��X'X0�.=9��thS1�����}��җ&U|�u��M��4|w�'�.F)����������oQ�?�X���1�ג��Jd�T]/"����~qg�y� K��鱆�!4ʤ'���7m�sl��M�a ��^ `%7�w����������,�g��[G�����x�D�PkU��|��W�pZ�۰�:�V�}�}�eֺ�}�}�q��e���Y�X�YƇ�L��V��Y�d.zU'�M��5t�m�AӘR���E�z��t'-["��=��'��M�8��C��K�%|6�$�05E�V-�����X]��[�z���&�R������M��"݀��O��Y�^_�1��&��*4S�L,%fM��M�If�G]dޟ��)��zHB9l�/5�a�1%�^L_4�~��z�M$�_g�f<._�+;�����)ާ��ʘ` 3�H����������C���*������P ���	�c$~���(�@C�����c�+��7~Ϟ�֯���s�TP�2��3�J��I�cF����CLGϸԺ���o��Zq��_��V� �W1f8��]0�E�N�
��3���vS���."��3B������_XO��ܰ6���K8����O��?z���nݺw���W�ݻ��4�k��_�/���������?��Z�u���)~���w�}q������#��S���[�����������.����'7_���@i|��<��*y��"�h1$�/M�e���~�`���g�Qx۩���f.�)/Q�}ka�3Ͼ\�.$|#$���1b��υ�>�G�JP����Ek�Ô8%�C�i�������Ql4�O�hh �v�ϻ�N��3��A���:�W��W��~;3Z�ٮ��v؉�f������T�h�?��~�������Fp5�.G��U����ƻi�6��)F\��={�O���3v���{��rЫ�.�P��1���U9��a>/kͰFb�) ;�W�����J|ߩ'�5U����e)'����Z�Vȼ�݅��hv��:�"�֢�Lӣ3��b�Y^�5��� `�ܕX�҄aY]b򉽋��s�.'��f؋�:҇0��Y�\^@��y>^�R�8�'�A��R��H�HI����^-��J�K:ˇ�2HX�H���|
��pg$�Њ����L�I�Qx��{f��0G�`[{sł�v��2-��W:��-�d���{f�\�U\<��b������bS�z���=�����b��_�߄�o����9�Oq"T�-f㉑�چkD��=��*��2S������8�7ѷ_ͬ��A�e��XC%�<bQ�����t�%�镦�R!��T��)��H~�P(���}�Qe���%���j'����$�z�����>�\�>�ϱ��,���b��nݽ{����I~���_�/j���r��?ݾ�zm���D��յ�k��sm�������H�����zo�ޚ��߾s�z���f�?�L�h15������<�����#Hg2&3?��qs��KꧧG���U���勺����%����r�<=�T���!�*�?Yt]��/mj�O����v$oc��MT�9����.� gI�.:��|]�Ћ�DN�n�\'u�_����d�	SN�N;]��ڦ�%�xh������^�壩��/�͆��6�B����o�Μ��L(�Ov܋��z�Rm�{ļ�)6����+/;���q@-��P��ن��.����������N9��*�m�t��R��L���������4!����󃝽���{���"���\���7�U���x��]��.G����/�]�9S�������2�-k��e��ݣ��	����j�f2�C	�B��_���-�~����&��������89�m6}$��/�=��<t]ۿ� ��s���ן�&�+�3%~EsZ�_�&��w�YKޛE��$i�N�iL&oY(�6]���,���R6]��0&���=��Ȝ��9B!�����Z���"d��1��b� ~�������v_8�8�&�#�/�� ���	2�k˷�o�ދ�Գ��y3�����]�^K�7 s������1�52��F�Z����w�s^�zm&bH'�}~:R�ʱ�y�e~Yϋwة^��J>��J���k��y+:Q)�����YH��d�$�L��F��ȓE�E�M03?�hp߇�ל����\.��U�)E�, _*G��������><���ߤJ��N)؄Vd{��Y��+���fʂ��	Θݿ�U"�t�`vw��O�-$�ԙq�3�G��R4�ΰ�yVCS�i��ln	�0�Nu粚��R�%�tX��?��aYռi2����)����W�i���r��c��=��4lH�n�g�)&����/RQl�#���%�3��1J�ee	��P��Z֐�#��%�����D�Z
�#n�t9�a^���x�G�FΨ�Z��%�z;���=}&G'5vT�r�+�q��${Y�8b���LM+�N��&��J���6�H�T��w�6���]�~����Gi�f�l��ig�z0h1�\$Ʈ]�*��=��ϩ�ӟp��C�a_#+m�v�P�LW������37�%��#�=�G�,ҟ�l��
�C�9D��n9�F�G��E	�ޗ|��x���i��߄dZ�2l���X��z�Fc�і�#^��Ё��uּ�c��ܝ��.����td����n�,�n����l�U�}�ӣ��FW������5�uW&C�$�0~�7K�[4cz/�;O6TU�į����Ȁ����N��i��B���rro6Y-�>W��׽�2�s�;�`�#���������9�1�qe�?��������w�����Y���'����z����������}o����߽����������i�֋���ܻ���ݏ���+_���3�r���1�!��ݻ{�:�������_��[�ԇ�S��qk��u��'����;������������v�i�_1��]��}�����)~�鸍�{+1�k蕹��7�����������j����l���Z��l��A^�9�WmZ��z0�ܼ�9fጴ �⌡����Θ� jLS����: �N� �v �C6�ggT� t�Q5�`�n5����-��T��>�uQ/#�	������sD
�'���}w�CH<U�U{��W=G��HSMJ����/ֱID�yV��[L�1�~37�.��6թ�&Y>��0Z��_�ͭ.g�Lr{�{�K]O͡�����_�[[��<�����A��3ö97g/u9a�*����)�D[[Ǽ�:Q)A{�m�B/��/e�ׁךt�����BE�Ұ+��J��)�jyYM��d��*w��O��Ws�S\�c���}�Q܈ˤa����';)N!����NQ���b�2�j��*�8�qtFt�Mق��jл\�{��,ɱ�ݒR��톜�~�_�y�$�s��p�\W���MW�)ћF1�FgŘXNsR+�Uu�2up�[JlOI&K�"+�/�#������=.��J��
EP��eJ�C.ekK@��>�﬛+�l���`?�m��X�U$i���[��z��͹V��I?3Z�D��˼���W��-,�h�ЬESNM�޸Ro��:ޛS �Ͷ^��KY��)o%�=Ӕ�G�=���v�������r�֑;o����J]����M�BD�
�9p���y�H��d�W�Hd�M���S_�IoF��������Uލ�6f���Y�xK{�v�v)1�E�R������C`SB��Y��5'Pz��B���3����̀2�C�0.^�>�I�8m���B������4�k���s�2Y�d�,��������́��A1:U��V�a��K��5x����׿v*^Ϛw��fQ
l�XW�{��υ��+����xY�*.B�Vk��>.tNm�&�ܤ����x"�I���:0.��>�����ew=%u]10���ac��$&��w�wuy6`�\�zfcSb������` ��=S�.:�Q9�TӍ���j ٥�p����5�[�)��JfC�\O_t���Ԋd#,��W=>�-���%�d�8U���fԶ�Z�����>��HY���9�@n�ss��G�9 .�������e��W�]9� �����Ʌf��I"[Uc�\�J�z�R�v@�ܙ̃�m)��y��s���*�4xL��UO8I��\ti�=V%k�א���e[�r�t�5K��6�&K�P��X������?�����h ��β�>�"l��#v�[��1[P���b���t��K�%���w��dS�P�������E1�z�Y��ʓ�l�|ʡ�Ӓf�ʹFX	���-j�	��s�>��1��[�L�Č������N���f) �y�Ҡ1^-6\�_`�V�e_)��l��RjbՁ��~ЀjlwʞRBD����;�,=�c-��[v9Ą�XU�9���s��!�S��"�$L�,�HA����hW��
�p�����C��^����y�v�_�����5;��Ť�X!��;��=�A�CX#�q�8��TC�硚aC `���<�м���#9�̹�� � =��Qt��Ҧ�����#L���JJ !y�@G?B���ss�@B�Y� �DUt�DgHd��L�B7�s����L4ub�����P��	�1��2 fl���h�m�ly�R��`�~�{.�P���}�B���n����P��:��j��1@����h��UL��ҷJ2�6���q�3��?\��\tbq�t�� ����X)C@�s�G�� ��_��[�Ӈ�1���lmvL��*�T���S4܈$8��rW�|�1�2�1�qzfrs�1�ct6���j��zqX��iLzK2]��� ��#d+�^�X�i��]��,?���0W떐��(a�$��9}�m`ֆ�����2�����m���o\������u��O����U����ǓW���{��u��O��[��ŭ;�׮�~�?��?��7����}���[��ߟ�g��1����5����W��^[��:�ߧ�]���]�V��r���߷�޺��}�_B��s��ڽ���_�Ϯ����O[�w�ܽ����w�]�������,+���Ֆ.Ӻ����_�W�^ɾ���*w�3�.C�W�n]'�j����c���!e4�^Am�-z��K"��z6�����6�y��tH:J����9���1vUu�H��j%��׳�{��OU��╪ߖE��ĺ�m�/'�@��|��u�jI�W�^�c|��n@�����:u�5��]�	܅i�����Pӿ��f�� ����;�� ��.!H ���<����\4���Ȃ��h\�~�Qr��@_ô��^����}�t�K�C�T{����":~�[�i9(���@ù�����C�R�/� ��~d���-B�P����"�Ӆ�n�q�՗�N6(�n�}=�2���:O�F�[�6v؃f|^���a>R���_:E�:9��M&�H�ܱs����Jrm!A.�='��7�2���	=�����y�9K��*�C�B�hd��>WJR`i})ǭ�-g�r�{Qi!�\��њ⭳pp�����[Q<��j�l�T�� \��-�l�Y��J:���d�n�)k�4\�	����W��p%1�a����P��U�#;�0�C����Zq�����i?UԸ��������'�%�,A�)i��D$���G'y��W�9
�Qq^j5${��='��g�	~_��z��#q��V-�� ٫�q�n��g���^|5���r�O�Q���ѤW���RG�i17�$x�T�s'm��������˖�P�����*���������+�5�#������а��0g$@��L@ܴ�I_�͗rw��/�#�2*"N�4�qs�7�$0�*J�e%s:=H�J�1��͋�p�2A��^k�4�vt�5J�zZ	����͛�\E=qPSQ�oL�ک���M�w=-E_�V#���iT� ʽ~��E�o6�v]�m_����t�� ���sN_n�>�)�\1��?��"�辒U[�ЀOٸ�sD_	{�ROMz3�N�}}��j06��7~�yh����JJo[7����GE5`��I�W��ؠ��ץ����c�R�K�+dђ�ر�a�)pVj�R��J奯׮��ǣ�Қ]N�<`0�Y�(����ZMɘ�� Ȩ"�_��� �1k[�ՙ�ׯū�S}���P����h�8�N��A��r]Ue�wd���۷+w����A���N;���5��Lm�f�[tޅ���7m��� eDF|F����u5��+�7ted[,l���Y�p�33��|4`���Q���|��Uy�tP��s�W[���jp��ZL5>&���}ڮ����C@'��e�zL<��o�<Բ��)�*Q#ad�����NOkȆ�n�Eּu��Cy(.Ƞ��O�Lo��1�-+����	!!Ƕ8Jkۖ3Mu+ψ�V����\�r��,t�v�.��Ivm�'�x3Z�ik���A�����(Ѫ(3*s��ׯIr�W�~$�\s���r�tߴ�O�s�L3���ȅ��e��n��x���/���U���4���?�&��ܑڭX�a�Z�]���5�/�E|�4y̮�oP^�c���&��ڂgNS�A:辁�i�X�x��3ј����ì׀7]�Q4�˹��!tĎ�v`���݃@/���f��1x���]��m�8���/gZȏ᳡D2䅨#9�Ӭ�ۼ��eq$�OdҩF�J����(���<�,#"PA7��^��".���t�&�8o��0��cqαd�)8� �Р��u�ih�z�LuD���D����ߵ'cZѧ�Y�(�����7��x�e0 w{����R]+�툶ƭ�m<�`a���ҟW����S��Xc��9(Ez��2�����
�c#$�����%�m�:=�s(f-�a;�?����V5 ��I�#?�b]��i�hM'�j���g�miѯ��R��1������}`�Ӽ������(�$�/���w�Ftu��($�K��tGY�8�����b�������lT��q?2T�]�sԁH_�']��'���p�[�א���U���6No��Y��*����,d
A�_D@��ՠp�)M��F��Q(�_��C��ti�9�/�3�Z��y����|�ɍ�ڰ�)y�-�W��됨
-i|�2�Ǒ�-䲠�� È����}��R04�	�]!��؞�o�Q��hO��K�Db�t��Ms<8Y�m(�R���*}c���J�@T�m��6��I$)iR��<r�D^6��fU��D=��N���F+����R��ՠӠ�a����)�8c��b=K��/3]k�Dm~�&���6B�w���gy$��T��l`��c;���d��.����oM� ��#Ơ�y�v�g�>�&��KW�"����Y^�2����<��j+J�m^I%�L�v��L,�%md'8�%֝YlgLT{�hZ:��#Bt����6m�M�:�q�|ݙj�)=�q�?�C��h�~���.�ev�UT�i��]>J����r���n�MO�������ݣ�i)nʵ�
�i����s�G��3�$�vt9D�E�n�/��i���T{��N+W���`�l~����h|��3�Z���1����o2kϬ�u���L/R8[$�)�G馵�g��+�4�m�_��#X�R�c����̺�aw#�/�)Tk����R&􋯧���#�9���Q���ۤ��0�������ieS�*3��L�$8�t�GՀw�K�a�_t��
��4mZ�H�}|"�-�L�s|҂I�jۓU��t��q���~��k��De��٣�-	Ձ��μ.�����0kdhM�ɥ"͝���k�g���z#��d��K\������U�HѺqڢ�'E��L�a_V�덟��dYo�:#��R�9\� ��	����6u��۾��'��D�c7d��y���.��"��H.b$�M��r�<q�t���ʺ�M��{6[��O�'�K���5�9�������a�<�z�}o�;����H��P�9��������>^��� D�|r4P��w��>w�hMpdJ�c~�CU���q�F�h<���9Ҁa�I#��!�<�/r�|��	P;F�?�8:Ю���0[��#GrmD^�M�Q�pK�������Q5.ľ@]o��04���;yP�zq5Qi�KV�Ckk¤u�����V�V�r�|zv�Ҕ�o3����tC��f
��+�^�Ͱ���W��L�|q4��ϻh�+_���O!x�]FLl�X?V �2%��ap{q4�!���B�s^I�w�:5ʐ�������סKRs'��t[�U�6�$2t���pe��Z���'����v�����Ŷ�H�?c��"��tҡG�?���h�3|T� F�+PM��$��ح`�±Z�k�^�b���t{��(��L��jL	�G૛�T3f�j T	tB���s�Ϲh&MM�x�-��t(A���r����bث.AΤ� ��� ���V>l�ln-	��zr�>�ZR�
6�v�&IA�)�;�z�����R]zj�CL��ɶV�:{f�_���p��QX��連r4H�������5Oz����:�W�[O�PSM�(ne�	���x��`[�~��%m�T�Is��wzJ�m�U�c�RVXjo3/}�A�z�V�z���ȏ��qt1��^R�ͼ:�[>�x��qה�>���RM�6���3��s�AG\�%Bx�����o�0�A@�$b�����ϲ��M_�|�.(i�0���eߵm_�� �6y�P�����`;5[@;5�h�X֝����quvZ��ӣ�q&���(�������Y�A�񀱞}�@�K[A����"I��	ө�V�9����b����n�{��o^a�ϸ2h���\3�&~/Z����;�i-4ƌ�&ZX���Bb�Cc8U�|���c(_vz2Di���d���XL�J�\ZT�:�����_@�:�֫4c'@nǈ�[k��~�Dֱ���ΐa�fZ;�d�[�yd�脙MU'#�0�:�5ʇ�:.��4�`6��F�ǁF�զ�H�aB3�jO8���;yGl�kw(N��\��U)I5e�9��QK�E��c)���8�lt���Z{(A�ʷXTs�.���.�	��\nq��I�q������w�$p�v��9�C�ᴱ�& �Nx+�E:Y˵�ҼU����dL%�g�ᙡ����$��LmZ�}�dn�#�8g�}Dɳ�٠kO��T�������<$�X(d碆
I��:8D�L\k��D7"B����y�sM���aJ���x�&CzSv`Fe������Ź�n��	����Ի)�t̗�o�`��fNG0�:R��~�_b(�y��Yu�Ԛ���-�C�$���$�ڑ��'!��*.�f�9�0.X�ۺ�{�h�)=֗ͱɋ앦]�ݝG��������Ŝ9�ʳI/eO����4��>T�������s��A�����*8�wDTp�fhתi�t��ӂS�h�1��mgz=��ň�O��F�<gcH[�-���@!|����:�O�SĢ@l'��ML�V2�d��S2l1���)���0�>_)p4�Hd&� �sэ�5\���ނ��"��m�&��R �gDk@}> ��[-��f>8Cm��q^�y�XI��p����ä4|��E��
iN�h�R��s��>�����������wu�O�p���I~�����_���W��\���v���)~	��/V�n�z�������|����y������{����O�K�"�a?���>�'��G�y��F��s��O
��w��4����-��/dc��R�. �;��.���㦶>�z��lƮ!!�&�����:�g�|	�$F�q)�5�����p� �u��'d>ItQ�����mo <�C����8,�쨢��j��� �2��v4��+� kH��{ |�L�֯�VBz?�;/�F�d��[S.'V���S��� ���D�q�#�����p);:>��{���"e�I?\t��I$��}*[(�ձ�-�~,�)9��KY�V��S�+E���}��B=����� �;d0xP�8��(�RȐX� �ؽ���J1}�ġd�";ϓ��Ѱ'O~7N��M>	�%�]V�	�n���ɤ�+ rQ�:��VU���׋	�V[k�0�g�|x���ڠA���ª�KuQ��^BP^��>��K�Y�=K�*L�����$@Q5"Lŧ�9�L;4]θ���5!H�G��ˡzMTk��g%<pɺ��jMP���$�7�Ғ�b惔�-'-6���S���)`�el�f'3>2����Ĵ�g�����nhv�u�Rq����U��A1���	�)�D���|lh�������M�q�h2�t�C�ѫ�|�l�<�o�*".kz������ZJK�и��l)���j�}���)#�٦�卑L�ءZzq��@-/$<O�o�Q�+��kow��eJSvYv�������x<ָ�_�	hLA�3>?��	�Ar$��6m�g]t+�S_.���@�j|��S8�$`�13	1ǂE���rP�'}�e����̓���������_�3���!�Z0�}g��<��~��=+Nԟĝߋ��V-1T�S�G��܉.��w6?UZV��6�)���g��Z�a��5T9��1�ϩ��g�Ii�,(�a0�N(�����6O�۷����ʢS�ɻ�1��}�b+�����D+>�JO'�{�Q�u���%��G�6!��w��u>꾄�"əP��_�qZ��A�{�[�uy5�o馌�������Q×'�!lɣ��m�%��K聯���kHuG5t*[;=.�Ղb�E�7��9q�����h;���m���ե��&��0=d��*4R�WmIg���87��i����$x�w��I�S� T8�@�������7�L�̅�z�%;U�m8螯��z���ƭ0����vYo���A�I��A5h�G���;��d�H(��7�^ciԺ��	@Ѻ��RQN�W�����E���R
��8	V�A	a�.^�p3�W��W�wN5�JA�>6��J��]�^�#��Z�t�+��L׷Y<<\C�Q�g#u�-`�O8��0]���U�A��H_��as�m7Y���IYщ�>E\��/ I����	�����F��>"���W��SR�E%�(I�%��"e9,���=U����,L��Z�q�yG{A�U`*�!�`Yg���V��M�p�a�U�D�Y�\cT�{�Z�����S4�r�Z��n�> �a���^�l���� �p/3D(0c�h�$��kus.i��+k�n>z��V^'���@��8Hw5B_N^����������OK��65�4�<��.tYq2����R��6~ x	٪��r��F��1.�h��C{ɦ�J�2�PT�j���g������/s�qЛ �l���[k홱�hRT���R��Dq��f����%����d�1�6X���#��I���zK�#%���"�Pg��0��6x+�P����|?݂�8�f3!fԜ>u�Ǵ7�m%��9V���<�v��W���ܪ�)5����TrBp&�ڶ9�`)����n�z���h��4�M��Qv�'76���������2� ��XAٔҌ�0���c6���bf>�^�bn�H�bH>�A��L�;���3�͛��!P�<��^����RS�P�q��Q�s|�>�^w���T.d�;���
L��?�x�u2>�B	薎��4���Ms-��dq�>U�_}�E��.̡W�IIՏ��b0��/^Q1����t��J�l���gs'5r
AR?���|=�.�[�\D�a�!��eA!�5�v}c'��#KiÊa��U۽������b�ڷ�ԑ���|���h,�%��R��T/}EE)lٖj�|����>�D�F�~䈕�%CO-Y�I�਋�V��D��3i%]�0������ �ߍ7�W����K)�9��I�_z�6�Ct(se'�F��ͪbTx�Յ:/K�١G�je�#�����v^ø���S�F��"�FlfOF�>�U���>��z�ҏ�ԍ���8�Kk�. G��I�!��
}1e��d]�_�@��u��1���ܔ�Er'��/;��z*�Y��g$D'�/|�K�s|9��Z�U���q�0c��[y]O�"��;��{�+=�pVK�Xb3l���1]ԋ����:�C�]��.���%��ě�l´3m^���]����S���Ã�:���N�Iou'�V<�6��߁<F�z}Bѭ��T(�z�j�p����S��c�G�� {�9�<���!�+ڧ�o�p[���S�Q�fZ���V�l�A�W<��M�}��~#�����i-�W[ӗ�Bݖ<d&��LB���L4����Z�A�|��)��c�(�DV1�P�\���L_.X��]��jC���w�h���bY�3�y�s����8����9��߃�Ȍ����b�ly)��g	�-����u���8�̡���]�!������QΈ}T�Ht�����ξ������E#�.�.c�FЌ��C`ؠz��]���\��tU���۩��f	E5��6���$��	i^���' ����L�o�+ �9jů1�F����h�EDٕ�|s�PP!�6ۓ�l̀0Zyy�"��^�`����%�i�A��Ys�u|a,��m}�����u��H���p��� Tӧ�Y��]�G׶G�\jIm]�H1�apB�g�%��^�*�M7�3��5د6� �4�@���.��w��MΌ�]
�W��O=mZ���)<]	�cp�\_�tp�m�%�|n�O�{��n��8}v�^غ�igd��
�����N�鶰ƛ���&�J9J��?GO�ER�E��MPn1��"��mL <ք���@�vO�|�&*�У�ZӀ����w�O�Z�O}��,�4��,lG������7� �ͮYȎo���u�!AזJj�S��d�dx��5�f�L�\��d�/^�mR&o}'��Y/����f�ںǾ���(8{ϓ@�2��S�����򥫁-v��S�y	�޻���e��\�Q�ʤ�8(�=�.�q��0�|��(��:��H(�S ������	�?�2���n��4�:x1��6DU����z
�y�~��)�FǾh�E�����}e�'�pO��e*�z�(�k�b�R��<qrЎ��&����fl��{o�u!9������Ͷz�=�倲afyv^���z`�2���>C�TX�����L�@��&����c72�=X�31��� ��Y;Z&gEs�����x;�>��̎��}������h�-�":��g�j���sq7��!6�)[@0 c\r�j	2��F���b���Çaiס��m�R�#�A̖%Z����M�l��N�ym��Eu��f=���]]̩��R�r�7w%���QFh9��+O��e�g�Lk�E_���=g+��ٶ.�v^?��\��/�N�O��%�ԟ�y��k�"�M�g���W|O��vʕNrvq�R�Ɏ|k1�[a��t'z��<;��l�D���܄8���Z:��k(ֺ�0"�^��Rm�d|�V��%Yގ���,"�3�X��q����DIXr��p����Ya�m4찦<�4�d�F�!�Ħ�����?g�J��n�n�2�?�}�$�
��j6Y�`� �9H;<��q���f�yT���=���b�M�?V;%�q�e�����!��a�^Iy���, �sKg���/TK2��zn�F|B?�k1.ʬ�2Ϝ>o���DM(�GHpo�,����r�$W��]�`m��������%Qh'{	Z��GeZ��+���w1P� un_6�|�t�l���,F�˔������+�^ߙE��:Kh:�Kk/}���y��$����;�%N��却%��?�O����(9�L��j�rm� �Š)����_p�t��24���� i�q8�߈vٯ�~,��""�Uud���#�T�_�#r)�kM}��H�<��z^Ĥ��By*>�l͝�����h>�E���LvHe��#�@5P���^�!���b�ܔO'�,rp�������R���(p3�#
r�e5�{áEyMb�w��t�xw�!*�`X��J�5$�ȼ��zM�ꀔ���ѭW��[�!�#�8���D�E�����c�h��@$0 ��ĩ�5�Sv�
c��{��h�
���k�I��Q꓆���,a_�;D�tJ8/8EB��LX^��g1�t��ָ�J�~�l���\mC�Zā�>��$��ٕ��i�ќ��w�̄�k�]��6�3� ���n���^����o]�y��,���Y-�/�T�Qw����jƠ�3N�T�*
�HD=��A�'�������N\~��V�����)��=m��E}UTOY}#|��=�~S��a����Q�n�b�n�c�5��|���p&Y�=��[^�^}(֚1qF�#������x��.�&��.-9䆈 #���⵾��&���=��mA�Ȟ%�O�+,.�ٴ��o�f̟;��[n�%���x���Ϸ�[�wV�ݺ��$�k��_�Ϣ><90u�;�ϰ��޿u���S�B��;�_|���{���X�����̪_�xߘ��a�x���U���~�.�߯|���7�?��lsZ�n��d�'�����_[[��v��}�ߵ���������`r�j�?`�߾�ֵ��)~	�O���k������c������z��Ō���'�ɔ�!�9��y�#�%�����!ȘF�^��@)�(��.�4`.X�O9rwU� �}Ǆ$c�DWh��TK#<�?�<��`�}����'�C�^28@���Rn��'������@q�Do��K�jeǽA��Y���Ő#����¸����9��G��B�F�s�fm����z�M��s��$H\�ߒ����68YE�')�%��� �I���7��K��F����+v��V�͚�Z1�ƏM�.���/;�x���?9>xr��KJ�񲚌�H�l�=\ug��~�uL`ߧ�~aS�d�F.=�ӵ���?�ydۤ/�^:]�Ys.�p�n���	��4��#��Z�A�|�ixǬx��+���R3FkM��T���.�z����{7�����K8 '�� �|/O��zpcL���o&	SӤ�a|m�D�-���qU�S�8:EF��Դ�IH��UKi)v%�r�Y��9A<�A�Q�r�K{�,�f�"�Ȧ�O����$��)2�����)�'��!`��%i�ЉԽ��w�pc"b7uz�{��.z!9;9rH�s"��$L Ih��W�Uw�Q1�nq)�1 ]J���7���)�G��(&tHװ���	���nL(����{X��E(�q���M3}��TR��|����=Y�N� {�,7# Uڵyg���m���%�Ω��w�ZcS���D?t���0�	-�p�g�Z�j� $f̟��x;q#Ɇw�Bo��Z�A�r�s(Q���+��OJ�p�@1	륤�(*^(��\X�>� \��$`�F�gT��i/W3�m���0��f��'��?�F�B�( �q�\�.D"v
^����i��u����%�>�`ĘE����~��j0Rw�Lϗ�Xvm#�tn� ���`�oq%��ܤ�[�H�(U�K�jUpD�A��al rdf(��9��E����=�T��G���:e��Y߫:jy7�е񫥬w��Jհ\��j@[���O�e���Hu�[��;����QF\FM��aX������H��+?`y�#a�B��)� �r�y,�YG�t\H�lmK2J.��/f3��f�vu=���u����q*���u�,��=L�qF5[�f6��~i��
D�X��^�r.%g�U��TLw����̺�M&͗����.�S4�4��"jj�mh@��e'5��Q����0�VN��.�����g�����g����nR�#����}�	4)i��΋H���7l�2vV;~,�N8��Z�Q�L��Ƕ�_g��G(C{həE_�I�b��V��0.���A"�j�j�@g�v��xgo��zvh3Vr`j�Yk27���;3�u���	�ڎ7k�k���M���0����L�y�Yu��68�6�Wv��7UF�5{it�问����P��g-�����آI��6T&�$�X����`m)r��g������#��Z3�	�ZCV�7^�u��D���S|�u�y��pt�5� ���0�?�ȯ4����+�KжR�mg���#CK
�'?Y���`撔ܬ�(��d���M(�)���r�����\��0�-� �q~Y�(Y���ͻ]�@�폹I��|!�m�W(�Ѡj�j7���@���C��T$�ȝ�q�oиu�Eң�9��Oü��\��h���o�%�;��ɍ���r0Q���j!���p�_�v�XP�L����ۍE�ψ�K��d)$ ��,o���*��l��&h\���:��4�xTSĕ����q8X=�+���EQĭ��F�iTdl��� ���| 7A�|���RH1���܄0	�')9G��X���d�4G�yτ�[ش3��{MǣJ��HLb�8�%�5��nSE�!<S�&�A_�ʴ��)�2����cHt��r�`j�3�,x��vo�ܻ �8ax��	U�mr[��}��[/<bt�P�T�9�^���1���Tt�Y���9����4������n#ÆJ��X�6��L�))8�u�'{Qr���b�[0L��*�{���b���O�M�Ű�m�L-Ni����}=E?��C�P#,iM`���x�N��#8^��9��
�g�����`^�������ss��,Ķ�&���%���^J���V��jۺ���K��٪�X�a�q㕭�k>�5k���m�GX��׎��X�a�b��+��5�y��~��H
�u:AH��W����|X�s�4S��������O��7�=����7�{��6�Y��jA�v���J܆m��^����{8�:jɲ��a���u݋-G-��ǂ���ţ*�c>�c��y`X�ǟ�s}��ޫ	�>|�`�5��=���b�l6�C���U$�Ӣ�G�����?榏FIu������'�+#��$�p��x*:��y!�<�]y=�2}�ޫ��0Ϟ�W���Ol���C���k2��C��;[���}�n����L�y��c�v!��3��/����ll �2:|=x�ܿ����� ��`�<Rrw�>�7J�|�2}��}PgMԱ�F��o�!
��#B�0���!?�yï<�:�W�����tU�����~�ԫǗj(����ŭ��/nyow�������y/��^�7�<lz�;�����w���M/��^>lz�ȼ|pos�{��~yk���7���M/��/��6nmmy/SU�����Ϝ�00W��x�XL��%��zG
t<����y�E�JG�H�&�;���V�;�n��B���-���+J�dz�.<Q�;�sǎ.�Ę�űs�1^��M�,�=���ll:Y��.X�C��ZΎr���e�_�?u���Kt��{��h�.w��f:�
��-�U�<<�^�w}����GG��=*���]2�@V|��r��4#���5D�a�,k욀&�7�`�*A���v!1z_s'&&�cd�
�|TjO튧�sOX��/�D�OV�@660t���a_�_V�k��d/��`����������Qj����ɵ����%�U��q=���(�F�O;z����O���mݦ(ہ}��~����̠}JGsg�J�&Y����,����U���pS-/��#��c�t�������/�?��u� �^1 ��yg��u��'�]����L\=���_�~�_<��ɿ��:����??��?m�߹s羿��o�z���D�g��t(˼pO�˛���z9�t�7J��*�%�#S2U2!�T�<��)U�xRjΒ/�՛bp��X��&r��	��ڦ�6&�D���p�|��w��b|^um0�;��������8���q�헜�B�@!T��:�k,��ם~��e�ױ�֖o�O�y�U��Q������-�^9^�����
�I1"�����`I6���j� �T��j2���YG%L��g����2�v����r��N�p8fCn�� �-\����D>���k��NM�yQ0/x� �+���jP|eZ������:�@�zU�!�+�.<�%��}X�r�!��.���RP�˪W�]R�x����[����pbH�Mw�Ȅ�\s�m?kS������VR^���n��xg�S���z��,W��*�q�p�p�����p|!@�] ��/ǌt��*Zx���}��Y@r%6�>�ԲF�Z�s�a�
\mo�e�\�z5s..A���V=�ln�m�<�h�����M��H��^}6%�f��1%���~8�]W �o'ܘ�l��h��L�ȼ��;����E��8���uʴ#����U�ָji�����>���Nң�M�l�𛇏��e7�6�vXs*o��]�*:�q�nFp�˳����DN=�.���F�9��m�R�m�z�l,�F'$q��!3;�A�hw����2� ��Uӎ躽,��cYq��&����l��QuT֐[#��W������WvF�X���6xoYm+��`oL��]f��uX�� ���
���$��R�+����R�N�{�C_����ǰE�avk�wx��]V<�@������$G�s'`��o��VMF��Rz}��%A���Di��pY/p9HaQA�韬�,�^�����NQwv�~��	@r1hVУ`0:
��~��Ŝ@^�\��t�-#%,K�����ޅ��ь͡�x�O1*.$N��"���_�a6�=)�đ)	��V(�D2@�m�t��3��	y&z��w�'?2%-D��e�}��"?���ngݥ���ٸ+�T�#�Z(Ӆ���{<�����/��Z���A>:�fT�ʞ�"��u�莽9���a��>�vk���Y<"ۯڪ�0oÿ�ly+�tK۸ڒ15faRc�8���-NƱ>�_6��\�72@���������7"U���� �R�l/'mu4ɻ�|8�f\�H���C���}]�����Ͳ�m���l`K6���2�m��"���׳�~�F�whgR3츽�"p��^����
k�l�}�8�7n����jd��\����wI*Б��w�z&���?Lz�t�(x�RS_H~nzrw..����g$2�gޣgc+,��Q��t�aZ��x��Ίqׂ�ۜU9��WuZa�=�`�?%*?��	q���삇0�}�A�-��GEJ��"�I#�gy�7��usww��{j�}�����[�R%����}uvf�SD=T"v�#EC��G�?��"!
���OO��%c3O�J��қ�E8����3�ӻ4`�r���@_C�d:j�~�PjR��W���!ˠ9:�56���@ [��ϝ���a9�o�9�\����Ǘ���Q2��(����R��`�񣚳�)����6z���g[\�h�&��0�>�aM�<4ݲ����!�ź~�&�����G��%I���-tئ�I��P��W��r'R{��5�ea�`'�� ��z\�Xiw�3�O�3�鯣�ln�[��,(.����ؤHį���nk�T�K')�g��a��A��}�H"���)\�R��w]\�]c��}�z�Ƙi#�����w��]�:��>�N�*�q�.j{�	D��ND3Ƽ*�d�Q�"�aC��q�ۛ2�Z,#�@�fәr��m���f��Ҵ�(D�{�C���<���1o��LÉ=�t���f�eFf���H�0�x��+F~/���k��$��Q�VaB�2��5ړ	u�I(Lw �l�~oy��I�K8Ǿ�l`{�l��}V=�&&���,xg*�sr[]#u�6�\�HaL `��%�W��.�dX��:���-��In���AD���潞�"��X���g�r	F�lP'��3� ����"&�*&� �i��T9�O=k���l�
^3h�S4(9#�n�T��(h�ɠVfkQ����A�����:��(W��Z��`�Jh��g��X��-��߲�1�ԧ��c˽���+���䶊F3M�z2�-�*Q�F�B��qD���z��E���A,��FC��-gg�@�r�*�`x�����]ɲ��4a�-�>ʙ:"|��Au�7
guԢX�\�[��RڲH��e���y�a��e��I����ܔ�:E0�������|TMT����P~bW�=y�	���)�������E��cm5�v��⎫?8�Ro�ϸ""܅�Dx�.c�����Y��8�l�Iޅ����)��J=���!���&�r���3��Ü9RD�vh-�0Q/4t��sQ�0;M�ȴQVK!v�N4�<%ή�͸ϢSF�~���a�!,o�n]z�"�M��I�(4���(nxM±���Gw;��.iAy���H^��'J�G��y��CX;�?�QS� A�)$��gI���F��X�R�Id��|h"͘<��g��R[��S�2��S! }'j��Z7���[4O8!ɖi��_�{eD@C.�d�Uq7W��`x%�!z�b�eke�Jk}��Č��'�<�p�i�x���M�B�6��)��1��A3������?q&��x��&����ό7�����n��w{]o�I,d�#��}��E
��(ͽ'�M`�ՠO������{��O�u�=�� G��PN�Fl��&�zn����4b�@-�Ͷ�V�l?7�����5_1�to����]�޳��8��=FN��}�}8^����9�XO~�B�S�cJ:+��*#��՟�o��;s+~���o��ʌ�!�ǂTaۄv����4섦��ÐNR*<�j������6?�����6��hP�PM7��L�	e�������A<e�>W���]z=g'g���c����9��}+S��TSvl��J?�����ѻc�zB(Oϵv�xPM�3�	��p�(��y�{yք�����k��1�M�˽&���K[jrB�u�,�||n����‖�yS"[�m�ma�,he���f��k6q���B����ؗ����؉x$�d3bO4��6K�_��.��FB�mq70|Rw���8TRe����m�Q�c^IM#�r�95�'��
����
Z�_��l>0�OUc�G�_�Iě/�:Z��	�?yE��'����3�H�G}-�a7E�$G-�8Y��p0���)uOm{Ν�W��W�	�ѧ���c>#���F�4HD�$�o��[7��V&��+�&b@VD<�	8JE\�,m#M�7��!5��-aՠA��_'H�q���1���$�mH`�4��X!�WNr�yQOg�Y���[t�I?Y�@4Q>,i�r�j��cA�HU�1#��С=V#�U��N���-�F�5Ӧ5ru�*v@�����d�i�G�uG��l��H�Y^���(ˉ�z֫N�kC�{*�p�-w��Z6��H�ח�x��U��aN,|Jl��3ؗ7��DIE'�(��}1� �iOXi�!w�#�bH������-?�%/(��6s+��c�|��_'NuJ�д4`�7&�;P�4�r��C|S�%D��o�BS��I >G+�0��X����m�W�g�_˪o�J�d��g��O�S���>p�( ��G�7g$��B��D,e
4�"v-G�3�Z)Oネ�N���"�5�2^6�vć�^^xc���<�7PW"I�?�LΊ�-v(G,@Li�"-U��i��ENy�� 4`�O�ü�ڋ�kN��̟H1M��FX�Rv�q�&��P�!"!�C����rJ����i�����}[T�=CEqmo5&(��$#����k!�r�'S=ӆ���pQ�����9�����2��6�E0ä�}��\��j{|�63�`N���,�(�g� ��:�k�C���э���7,2A���N�F$s�����ivy�ϫQ59;�]f��7�%9�;���2;�`ۻ���:���5�w:�	Ύ��@����ҽ���I��+C��bT<�W<q��(�џN���	0�WW�,������A?�&� �����J�<R .ۊޥ�r�;]شd'����o��1ވ��IM���zq��dv��9��a2T'ӟ��C�"�����������������_��w�����5�~09p5�OX�����5�������w�U�Woݿ{w�����??��?m��^��z�[����ߺ��?�/��r�����v�ܳ4X�� ��'�9�D$������t0�E�D�.ơ<�%ڤ?�� �e��hy0�Q������e�?�!���9�j
�'?p���![�m����Wa.0�mF�ϲ��.��l�U\�Һ�v�a�SR2���fPѬ<%,�҅�t�g�[z�o���')R��%BH=D��F�F[���I<ΝKr�����Z���&�t.�B�}	�.�pV�:(�����a,O�'\������6��(�����!�ر0�s
���qӮS��)� l������;�~�˨ny���T��� 3��l���txxGĵ%�<R�J_�I�(�+R.鋭X7���q1(�C��u�Yv���}c�pfj{�Ilg��$��X�%Q�O�EN�+�Am2[�c'��@7�銃�m���l*ZB߫�k�r�u���<�`���if�j�=��PâM+Ttt��3�?�.��?ߒ�pCD7s�ؾ��f�}'/� g$���j��\��t���W�I.i�AB}�`��n�uE9k��\�YX��z�`�D#�G>4�P�F�qcm/�K�h\v �	��6Qmȫ�4����`��Y�����%/�cR�	�qv�~0.�¿ݩ(�;��;�y����;%��p��'�����!`��g�(�l|k��e<����6!��}j`�r�(#q�\7x��9/ş=y�Dnt��n4�.g䦓���Q�-Z��i�R�Ql�Cč���lP����2�� rmΌ�_ﵩ�Ia��Ԕ���[���v:y8Tv����6����u�,�^$���I<�x���#�}ퟞҕc|�J�d��Ӽ��縵�=e�?�b�[&}��LN��k_���]j���r:<�6W6�C4[�{2֋�r$��l!�u�=*��eM�Nq�S�l!���9�qz��உ�/f�_�K3[hvҬ],t��P���o��x��F`��I�܄6)�9U�Pgd� ����.D ;�M'�I�^"S�	�,cn�ʔv ������W�j2�NTIwO�q8"	�.	�V;�f �f��(BD�]� 2��`��Z81˓��o�� ��݆t�NC*Z��N�%.�NB��Xm?C~ ���.�� jL����d"
O�)�>N���T��&F97��9)�?��U�Vr��i;�E)���&bL4��1��)�Χ[�����9y(�.B�����^� 51��q�	��?��b���4B�DF">���NiP����P#6nwV�4�Q��x�1�)�0�?uU�2m����;Вh<$c�=3�h(�ɮS�,M.� ����L� Q��q����)��5L���qd��_�#�^�q����1W"���f@1���LY�f�i����4�UN�Ĩlb5�"k�Sq8�Li0/S
�%��xQv^T��t�S��q��1�i�*v���4`N�U؀`��pY��92�f՛�"J!��D�xDhfQؒ�Ȟ!���?1V�u�	��^k�
î�:����$�ß^KK.󶘀?LH�&��9_ �bǫ��~�=��:t�R�K$�����(��C.���7��sma�C"t��R�~��?w��3�b����A��@9�?lIcWD=O��+�R1q#5��,v\�䐶���HlP��UG����7��]L�S�[ϞC���('������E�.�Y�Y9	y�]���&ȋ�&ȋ���M/��0|�7H��d{Q����y[ �'�Ok?�~���)u�:�fOvt,�R�z�G���ڜ�²�Weҧ3��V/i��e���6цx�!���s�K5X�����]E+�?��6���������Q��.���haI�ێ.ब�U��6\�����P߻O��r,�m
������"'������*�Tb�a�W�7���� �\�DN�_'�^���/t�I(Ԉ�ʎni�Xm�ŒA�5�7fE�M|b��Y!�m�T[� ��������I}�"6�������q5�Ɨ��XU��䊃�K��E��:��s�D<;y@}^V���Y&.�q��W&m]�������-;�9�cPש������e��2H���ݶ�'6�oN���Mp����Z���O�դ7ZDKHt�A�(P�%n�#5]wa�h'���/d�®���!G�%	mh�ҽozl�_W��DΘZM�Mb���	��&�n΄vY�Ϻ(��PWcx�gy�Ċ�D��v{��B$#�3Y@k���F�A���̝L 5=/����le	1�D ������Ⱦ�k�ug6dg�?S�Z��1�����޸.�\�L�9���i��#"-�(vĆ���*m�x犅�v,���
w/+/!eik�b��nx��V��a?2�,��EP��>x��j({�!x]��i���x�1�-RÁ�}���u?��2��k�ݲ����ܛ��e��_�m�q�@Q���+왔��$����%�@�~M@�a ��vz@�0$��?�=���w�@p��	�	�/��|�>���:l�DY���o�Lba9����~�c>�n��"& �LDxɟ�����a�)���O@
o��@7��J����VRKݝ�e�	Cw㭧u� f�~&��z�h��4��I�=�H8Gh��ma�l�1�"	JR��s?��Ǧ�(���=�4�C�!5�ڀ}c�p����h��(@24�@}q�?����e�[����t��\�!����-IUc��&�,W�Qð\t7<��Rr3mt��.N�3��`u�n��]�<a?����j�z=I ���~� z�Qm��&�q0�A��ş]�tM��R����D���i��w�Z��-���u��u��'�]������L\-�������^���_�g��/����ݵ�{�����_���w�����n����ڽ�k�����%��\0�A ��cC>�u.� �~In��	䄴W5ܪ���AΔ����H�I���Z��Dù/9߱1S�!��gKtPu���n����g\�,���5^�ge�!@�p�� @�%Rb {���7���dT�����^=���Ø�U���� �ՙ_�puQ�w�x4O��]��!�hBM4" xl���[w��5p��%1��2����EY�����������'��_/���#�%���5������s.�}=Cq'ͣ�{�����n��X�=��Ge�K�pp�E g�!;Kve�w�hÄ�1M?7��/�-�j��5�}@��5͞R��	b���;���2�'gg��.���&�,=u?Pփc���8)2@�"�W-�Ip�G[ts�1�.vX2����Lҍ+��dWV�o�-�1�|�2��fA`�I��ؖY�U�c��w`9��A��Ocf�����I�gl����fS<Op�#L�o!U�L�\&9���L��D.�^��#�o�z�e�w@L~p���D��p��
G�-JhyMFM�?7ﻱL�� 	�ѯ=��`��9K���j��I���l���gGZW<����-E7q��6����������q�q7�ĩǟūSD^9k�����>Ц�-�޳sj��}��0�T���. -3�cA��O��_@����	6�F���z�Tc����h\�-���T�9/:/z�QB�MX�j�\�_�l��g,%uG�q#�h����Y.���.�QYMj�qT��i/W��5ɾ��U��MI���?�G����-�>*�A�6�)��-�v���_ysM]�
&���N�^?� ��v����5� p���݆��6ujG�{"^���7_9�?b�V���S'\�0'#�?7{-���>����:�m��zk`�f� >lB�)�ۑ�t�RV�;ˋ����v��b��ђ�P����7�+�����*�e	b�))a�_�s%�XH�
A�B�#cc¦]4���������t�̷��O��9�aA���]]��8�@��Ŀ0�iy��1n��:\@O��z�5�ϨfK������"��[���aEZ�脻�dF���6��N>l��ULf��04���QR�w1�i����s�Fm���u�bXvR��*���s��9��h�mS 7�������g����nR�#�@xV_~�Ҿ0�D�I`�}*؛�Ƿ���B�����,K���X����y�3��y ��yg�Wo,,�v��В3������{}Zp<P��'ȗ9�#b��I�����������u��!rj%C睹D������ؒ�t����j�N/3w�R�OH��t�����:	<�C>�zh*�ї�7��^0�c�qSKl������p=�N��щX(��f,xX��"í$7�$"�V�B�+]�����uC��|�Bk�j��|�Ļf������WX�d�K���6k��rlXe<��n4��9�3�����},�k��T�3G�ލ���ۓ�R��c&�e�Μu�:����"� �ֿQP+��`��xH.i��P� ��A�a����f��x����D�1o����}�2�qk�J�O8r��ʑ�����bf*���(6hp�Į�ӣ��9������_���#hf+�*��o4����I��Bh�0���G����@�قR)�	ğ�n,b߁!A}��,sf�'Yk���@+�6�M���q���@[���!`TLf�=�K��X �}�Uo�P`���[tN��Dt���qU�Ň}��� �O������`ѧ�V������>�&|�CxT���� ��&~���E@v������ZB_V�U�>����\A��S0:[�Y�A�6_�csH��a����Ŷ �������ex��ޚ�@�^~� I�10��uq���Z,U�P��#��G�"�B�?�b���� v)�]����Tݍ`�;��21E�?,ℏ#Hw��BL���
!Œ�+=��^\
X�����C��r�	��0؅�̫̉�0Tz����:�]�a)�ԁ���#����9,0��1�L�p$'(M����Xg �'��j8��xn�5�CvȶtIc�w�b���a[W3���{G��a�q�������6��g����}cI���� "��kC�#)Ȗ�!�6Q�z>�֍i\�����Vc�	�7BDd߼�쾢{�H��fk�E���}5����{���_���=�6BH��뾶9�S� �ZKm<+c1�;�o��}��>�'�ｚ0����Z�:#\��=�c-a�G��j���޵�č,���
k?)Lx$�,�R4�co�d/�� �&��.�f'�߯��U��m���c����:�Εs�s����/σ��Є*��D���韼|��F�m�5,O~/!Bo�o6���1�����V����w�˷�!��d��W���k�%�?����~/��w������v(����o���.�^O�U�����!�~�@tN�������3t���O[�2���iI�b��$
�ք���2�Ʀ���t�˺N�Ns��/��9�T4����2�tZ(��O)�l�Q on�n�'u���'YI�\K�\O��o���,x7�$�����+�͝���PL����s�ԗZ���s`>������IRF"J|zl3P	d@����n[u=��
A�y ���z\	{O�C���8^[¶1����G�T�O�˫ڎ�/��k%�M�Q�{&B�7�Զ9���g��"���9<
G]'�(�9�(@7����p�U����M���N�J�.��!уze�/S*�k�0{�pX�q�Z&A����q�=���xO��:�YHI<U�k�JCC��n#r=��찝��(�Bܞ��8���P�ޔ�l���G�Y��ރ�����=F��f�:6� wT����bq^����TqF�:���\�#���)���v ��@���nL�EKaߞ�1Iɻ�r �b:�6uR>��ުj��;6o���m��&�r�S��gfV�a�<���w}	�_"oΨ�4�[��Z�O#W��������y�:�w���m��M\2���b����-���_���տ8���Ӯ7��ݥv�o���^0c��N�k�\
��5ly�4���>Ơ����䨿� ��vhD�����^����ډ���= �8̊�Q������{��U�%�����6č)�����E}q�/O�J�uR�;��{^0Gݪ���Q�Z�����x	������)���ۦ������$H��F�W�(��6��z���fW�-�C�쿲���������� 8;�����i
TM�zF|s6����ܒu��x��#(�6��1���R��ٳ�OW��c0 nG[��B���zyV`��@���@|��=�����D)����_�����^�F� ;S�A_��$
��L�R�D	��� ��ś$�e�91o���NBP
F��ϩ�j�٥�n���'�qN74�z0�(��^�~�d�ɼ8P��T���>���L���}?/|�%�3��I���ؐ?I�x�/R�(���J���lpp{�4�J��g���9,߻��o��VHU�%�UT\ofh��@�a�ˊ�"�2�c�-W��V<��1E~o����Mh-�u$�Ը��cE%�l6TE|��Y�D#�=��0iR�/��'̚���$����D?>y��21��H��C�c/&���
�^�9q��T�!��� ߉>���^0����tbG��k]ҁzaQ��� +�g`���7��]�w�"ɔb�-7e#�ٽ������L��US ���k&�X�pn
��Һ!�U; V��-� �F�N��0S/f����v�������� �{Ih���^�Fv�s.�PsFē���?�ʡ���:�J	,�59H?����#�9}�q�nm������D%�m�a�0��q2�Hu6>�g+���4|+�`k�v�S��g��,��w�;�o��6�\!�	�7���4�}d��Ζ`$4+��w��;c�;�h�To���7��ž�G�8�h��$��5�TaH��\ ��/dM�S�iz�K�!.���c	���,L>����?��*\��Q>ν�5�_�I{�y0�4x�)���m������.8ٶ���y�-�Wn��f��"�l�$�)�>kn:�2���7Ҏw�̎5�%a���TwI�����* �X)"�YYk'k�m}�Z�~���Ӝ��| r�̧Z�X۟a,r�� �������8�M��m�%X�%��^�q?_�����k:U����J����k��?ם�M��+���^�#_�z-�ע��꼴Kr��lϾX�ƵK-���ȅ���E¥��q����_Ĳ�Nbtߜ�O���$���5�r�������̜M��r�'V�`eAu�4��[�`M�
�ij�!k�a+^?	�]��¬���d*�fӡ�(L����tZ�f��hК����<!��l{�7���Y���@ؾ9��vГ��կ 7趞տ9�s�0��h\ )�7�-����݆����p�3�D����0L�l�E�B�aW��_��#^;:9�h!�ھ���7��R@��@�򭋸ֿN�Tb���h�b��qµ$���OG�Ԛ�1����P�P����?x�=�oU i%3�l��f�/�_��>�	��H�ף�X��؁��c^îdF��l�6H�,$t_M�ޱ�r�Ne���ۄ��*|��'�Ǫbk��$��$w	w5�;,�"dgoR��7��{�\Ƥzɡ���w�A=|�v���+��r�uX`8��x=ב���¡I�{�þ���#���'f��Z>�t�>)ފ�?��롟@�y5�@2���U4zd�[%��qh�:�@7)TN��a��	t=���}uo=E�����b������������n���<�J��-E�Nr�_�n������R�n�V�D�Z��1��5=����q~j��/?��I�;��U�Tv�sK�@�Շ�i��|�#�����6�!gg'g�#�`#a��c��i{���B<V��������"*ӓ	 �1��d2<��D�(���2�\l"�4�
Y�
.hՐ+F뵀>v�K�,�K#߮��6���"-�������\���[����"ү��68���|a�:O&�İAa��%ID��hyՏu�o����	��z��$�k��s�s� �%�^������rUM��(�q�U�\���o&q2q�p������������p�����\��d�F[6y��Cv��樠�z�x�p� R����A��{ގC_�� �
�TsϽ���V�UV�&l�� C�'�^Q��yl��UVR��U-�=�y�˞ӆ7�$�0p�\�r#���p�_�\�W@�6&��c��#��%�M����$ϭ�L���e��'10m�R{�ѕ��O/�w�y��k�j��?�U���x���O[�����|�;?����?�+��o(��Rw�Y����]������b�o"��]�@a$�� �蒷�(䛅�gB� v[�	`�b�X�������*4��F�l���Ah�׵	�Cr�6Ps*х2%%�է'�"�>�L���U}J'�^�	��+���X W}���:|Y��Kj� ��7�C�+�a��*�1EV�i����Q]��ě>ZōE�����l=������q�*`jB\��N��s{�?�����Q�o�[��V��:(�u�'�h`jk���z��"��tJ� 8�6(������/�*�@_1UM֜	a�r=,���$��
���Ư�b	%���q�#�tT�`��G�(��B�_>�\��$�A�}����v�^P"E���yu*"}�w<�[�{�4X�&����{����%uH6���nC0k�7H;�&X���Íex=�w-�� �t`;���a�H;pCy��C��]�<��W%�^g�b.��O�}I(�@ef�V�D"`�鐦D�!���4�U4=I	V��JW����<�-�$���BI	����KV��{�U���Of"�(6�5�{V���ŷS�H�LY�	��F�'����(�c7������4)ا��`)Zu�V�"��S$���$*p��:Q_ny�
�
��b��W��"&|�j������Dջ`'�Bы(k��)`,˹P�"<7����9	!ѷ�aD7�%1$�&4-�~��n \���J�#mT&ϓ32�A�$��燫�Qb����F�AuC�%� �!�d5���LQ�C>�}���,V�8G���:d�e(���\�yzOv�V���ګ����?錱                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               