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

__ARCHIVE_BELOW__� Jj�h �Ks#Ir0X3f2�����=� k _U�z�*��.���Q���D����Sk2��f����V�=���i��O�?��M�u�xGF`�f4MtU���������A����g�>̧�hlmlx��&���Zg���k^s���\��h6[^����ֺ�5>>�g��~
�\��IV�28 g�ú����|��o������;��ދ����?���_�������_�����1��%�����3���d\�����$M.�؏������޿�b�%����:y�)��������]�͆��7��{��{���������7��q𸹵����p����Z�񠹵������ow����_�֯�<O��������x��˫����������A����*���?�8�T?ڪ_�Pm�[��^,��܂����??�����t���Q@?k�4ɲ�$��a���7�8z�6`<6��o���������Q>w��O�����_>0w���_k��ٺ��>�ǩ��<�l<X߼����?���0���o�ڷ���q'�?��l����y�?��!рw4�u��8 H�O����_���?A�O�I�n2���(���2�L��]A�� J&c 8i�˦�I��a|�%��ۋ�y��������W~��]��VV�Q��f��?��0���D��aWj���Ԓ�?
�<��$��~�G7YN�9�O����u-����C5aM��I���}
R�����+��4�o�*�<�gKWIz1��+������&�J+P9O� �A4�ٸ�Iq8k1g�,M��T��̬
QM��Z���1������:)�[���������ϝ����̷�ޝ���kmn��������~��������O�Ϸ�
��Vc�ռ���3�����f��������<��[��G6\6	�����YmX;^�0"�58���Y�yqgX��vY��?�����������(�;��'�����;x�m�N������Vkk�u��������'����[�76����3K�?d4�������s�R���,DA*����-h��o����|�'��7��T�*	U�La�`����
����7f�km�����}��n������v��?��N��I�����n���ml5�����)��o=l5�kw�����L����Z���ٺ���(�Y���%��?���������t���zo{F�?��EC�f����+w���������7}�>���޸��|�ϝ����X�?����7�kw�_�����͍����;�����V�;�M�y�Q8���Z_�;��1>|���2��﹍[�����w������~���������Ɩ���֛[w����������zk}�N������������r+��w��>ΧV�-�I�<�Gi2��s�Џ�6ҥI�fI췽^�IZf�<�-y�.�Ӆk���^y�1�'���~#��>V�ա�n�y�YG�;���a����6�h#ͻ��:lWy��a؇����i���x�p���0 ��M|�2�7�(_5�0�r�	�c�h�C`u�-��$�P2�ϟcl�����頖�+��W<���N��;f0V�4��0��]H$�4��A҇�oV��ۼ��LA��a�ad���}���\����{����f&
�7���(���x�k��.�"Χ��0��tJY��=�� ]���]��y�a��|�xȱ�uo'�Oٷ*�ڲ5��覌��V?�Q!m���t���4������Q�����40;�FKn8q���6��qp���1����E����ɴ?b C� q�N�A���o$��*�"?���0Hq��@�^�.`M'�tr_4Z�;�VB�� T���7�)�R�S�_'�^!�4ԉi�"U�F|$
Q!)��,�Y5ڠ�T�Kk�%?���>�N��(F�=w��p���O/2��d�z47^2b��pӤ'�o3\t^v�I��F�0,g4�P0�1⃙� *�O#ʬ����=6�D@�9/���x�d>�f2X���`܇����!3�(J�0��4��3��m��H���� ���#IQ �{���b�:��X��|����~wD��p�Gɕ����ptHD�	s6
����XH��������d�X�Þ�]�HK[��2�DJ^�|DI6N͗lԂk�(?�=�K��չ����g%���2���_{7@F�L��4r���91��bjpy�)��*Y�O�XQl���:�ㇺ��7 �?S�#�d�ފ׵����--ݿ����R6�8�m�
�y'ȥ����s�� �cڵ3ZR����-�6M��W~����c"��X��s &��A�����b�� �8����t|V"��/a�#V�>c$K��8�>t��)2��SXq�d��q�d�0;)F���j��K�8F�8�`I���
5sB�R8L�_�U]*���ʪ!��C;\�8Y�86=�`����m�ñ��4o],Ao��L�`=F������)E�^û��+8)Jt��8�wPB!�g@�)�%����;S��@�se�s�E|��� �<I�	./J΁h�N/��d�)̛oTD/u"Md���@��O�0���pAw	�"��D8~�H�s <�(:ڢ�؞�g�eƺ���'u1�L<�D�g�b�\y���:K.qb/g��\?�R�#"f�D�׼�5$�	����)W�`-�����ʁ��R |���R6�riI�fL<,e�F�t��(`Ӽ�ߞ�������<�(}�ρ�ߒ�=X���X�����y�$�%-
����5��˱	?Ɓ�����
�A.��3�Ddb��\�� 4^����c�&D�QxD�Y�y�}P�Y{ώ��%|�� ���ۣi6��$��4��&�}*_y��$��ec'�D~!��1Ո��?��9=�)Y���0��"�|�"�d���t� �����5T��O�%���[���1{�$Ԙ����%>��#��e-�?�������g�%�a!���?�6��@-��]g� �0Q���0��\�+/J����<�r���a_N�GM�1�2�?�9��4����TV�+�}x5�����.������Hv6��Րf�Ɩ�
Lj�z�=�9TȾ=F�fAF��p&�h�kf,$��df�����	�W�e�:�qt�R�=C���U�"�k䃴�����`a��"l�����/4���Z�1.�� 5��meʗ
�#����1�3%O�&��"]�40��8� i9p��U�o�{k`��&��ϊIr�}/BU]Ձ�Z�_���9/$�����+�t
�:�FX:�<�]ںs�b}X��&�Q��,S�`�	.a�>)SR�Z]-L�
&�$��Jm_�,�z7���.97%e�Ef��� }1�f5�c#�$A��73$�^����OxNQ.�9P��@Ӯ�9+��Y����`܄�E����1�����89�PR��c�rl�uw�hw�	��^��n���P�A�1��i���θ3�п�	F����5h+������0���|�)+�z�4��Y̞��\*<*dݓ�YX¶�+ �Ǯ7�B��O`ݯ��u#� ���t�d��/�hJ;&�$�����'~�+u��8t9}�n�T���0{S���Q�Ӫ���<����G#�(���dU���8�Ei��cx +8�|o����#\��,D�=�-r!��ul�϶R�@�b:�
3V�=��%	(]Tfwh�N�,�8(ڔ3,N�
2�<Hѽ��x�����
C3�7��A�v	����'{�8EN��8n9����`�2E`�~(���7�hl�5M�$t2��	�\&r3b	��eb���1��[���B�%Ӂͯ
^ye�C	
B���pZր�I�J��ϼ���6�Tt��͚oc����~ S�%�b?�$�>B�62�6�E��z�\PA��ӛ�`V���8U�2&��(��IN�:{D.�����h1,������=�,��*�5p\�L)D�Y�B��d���#ed9�be/��F�*M���	*^T4��N�z����x��C�s�#?]��8�!�:�SB�f@�-(}��`O�|/��ȁ�`6Qi�{�1M�PO��
OD���G�vx��T�*�x��ZoՉ~�Km��brN��3ɉ��B^�i۝@����D����k�4v����8���ۂ	��������`�\����0�+����5E
0�3]�A�t�l��� �b�@*�����m�)��P]�n�s�(����>�s�B5zg�!�[�(�}��9eX��=`{ÐR顝U
�y �lV�`�V���,x���lsQ�,Ԟ�&n��p�V���w�#(����+^���˖z���d�NۦR�0SAA|�W�;�희>K�����@uX��pD�_ ��B��K�6b~=e�m'E��� ]����4���q3�V�岢�i�=�����*�^1��HGj�k'^T"��V�Q9���.�Q��@y����i9���U�Yߜ����Mtl��Z��?K8�}�'����݌�P_2.Q��ῂ�k�2����>�\�4R�2�\E%I��>�D .�"�HQ���M?uǃ���Z,F!7�]R�XY��i[���rN��.C���J�s�'�ؾM��?���ZjCǬ;�z�Ŕ�����x�o�8��fjKn?'��N�cs�o�=�4��荄�X_�o~IJ,O�7��l��XZ��2���b���it�f�D���Σ{*�𳐓0�=��6<��X�+� 8T"*}׺o���
Ҷ�w4��ނg.f�
�#��z1�E�y�`�j#�.(�;7�����sX�sC��Q�3*+'��Τ�i�:G�M��!�4`&7N
H��':ޜ���E_��	���B-�LVr��)H���$�D��9��J����p���qz���epc�+0� +pfU!��ۼ���z�����.Jë�*��$��s��9^lLW�u�+fHg�KKZ��Bq�21d�JD�¢yxX���� E!Fa���̈́+���D_
rTqS˯{X[�w'W,�E�Ē &"�+QČB=!=EN��(�B���'>�c�/�}��c����P��A�۟��j5w���sw��'�);��>������������>��j�6����>���!���fsm������;��1>��/��'��N��Q�l�a�#�P�þ����xE���#m���:z����A��`�Ȗ'�l.����Gz�s��d�ÿ'7�nq��_c����C�j��W�U���8(?�g6Y<৷cBaʅ�F�y] -���M�>�[��A�7�oyzP���`p��_l;���E0��ǐ1��ju-i����ouH}C�1=�4R��f�l!_�8b�7�Fa�d�dt�v��'��q.��>p�)w�8���|
����Y���P��Վ1��ҜC&��T=�{�i��@ �ϔ��H1f�)�4=��>�F�Us�<:8���>��ѩ���Osg�:�g*���-��~w�ۆ�"}�IB��W���_~�0��� �7we\��6��b�xu�٥�+�ƈ~��Q\T���A��Á�1S퀠��gM�ŋ�l^��ӹ�8���%�ϊիw<H���@�5�8s&�V*��3g�#��x��)~�?��ڵ)�ŵNJn[v�Pcǥ'
u�\����aHGX�!�Y���C<�z�R<�'��FX'9���*�y�S?sX����51��y+~�
�!5vB����<�����[�$�v
 �����vt����I�]��#7�>4(���",��T-�[F0�)+�J͍vzX������#�y�2�����\:�s�b�n2�9fY��	����b@9	MJ�029�u�7P�^Lm{Rk�U�M��3�:A��˖-������F�sx�B"J�X	:��
�`��K��yքSPV���*�M�2t9[�G>�<���P���� �K��i��� ���e����*_ȇ����<\婗�Gl� ��������ի�$�xh<1_0���5w"[�������wܬ�/�)3 �nD�=��3���=�Q�O؉#ʅ �6@�7�^�
���e���b�j
������BY��K߫���'3`�P��%>�3�4���	u���{0�Qp�/���$�T�0�ƏC�F�
����H��/>��P�� ��B�0Z!���t�� ����`3M\מA�]���80�2-E�k{;�[uF`��3?�U��|��6m"�H4kvZ<A�%�)�:%j��B���ר?�����A�;MA5�5�&>f i;�)��cѶG5 ��Y���r�_&��Ǚ��i���qZ�>b�� �H�I�	0* �Ù�'�d'��nVOE�����d f?�%��\hz��g��SL�>��ҫ|ÿ�Yё|9YEP�@���8z��<��aKa��E�4��nߔ���
#\��S�0�Txmm�W$�+�Ƴ�4�+�ZsD����6�u���AxaZ�ә���M�`AH�z8COQ����\w�o�C�y�3�jǊ�M��lg����v>�R��e���H�؅)ޏ3�=��͘ETQ%i�;��okݮ��(3�"����ܶ�q/��ؑ?����`���2�M���B�0�I
svܔFZ���ô?�����Y�7��U�����C4��"���\V?�`��6��PC�T��H�$�!�G�J���X�Z��y����Tr9���{WW9GP*��!���&�b�h�"�)��ޢ9��o9��|�������Fc��+<�?u�+�/k�����w���@3�5.D���\x˥��%6���1�z2��* 	�/ʪc��b�4���\�+�9��h��k��3�Ϫx�DE.no1&�+��u��!6��1pݠ����'�[�x[P��P�����&�F9nh�M�b	�=��U�
�3͂�`��i2�*�U�� ����P�y�vlN�����:����b��CZ�N8�=��W�v�c�[R�d��J�$#d�0GN��e��͕�����)��8>'ꁧ>���^E9��^Ap]��Rh�>��x�!73� ��5B�^a&N���f�]��:��Pɫ��+�c+�/  ��ba�Ywtn��DF���i�J����W��J�h�jI��20�i*ֵ,M.Ԁ0�G3�*kg����Z���,U@���x��a�"��w�2`Y�%B@Q]=C'�yUveE��'��n�x�M�0vRt���`�1\���Ӿ)�+�'Vgo�K��b��	AG��` �x�-��3Tf��O�-R���_�����h%��߷�z]�&*<����`�ڪ[�2Y�Y�X�V�����ПFy�Y^c��\H5i�`����~�N��滷���[2A��wUh�¨�-�C0e�-fxE�>��yc>ߏ�`�$�=,\ ~�K�=��Q����p�����y��l�}�8�ς*@��jx��)f�vN؇����c��������0?��?�W��7���&�����;�˚�	����	G��*>������ b�>G��B,2�����:�"��;�r�Q�ir���t�c4�b�=^ao�XI8�!�]O��[�EC�[��V4��`@gdov��T���hT�/��(�kQ;#�,��Q��.
�ֆ�B��Z�G/��Kn�$�C*�hZ�����67K��@��4G�o?�T/�V�j7ʱ]k�U�)�5$�$9�PG�����^E�)�f��x�����J���fJq�a��dKV�%JфnZW6%"HW��T��Xup~ݚ��MsK��H�Ԗb��m�>
9!s
�� ��#�jY_�֨L�"w�4 ��[�fU�J�Јor�:��9�q���?�}�*܇���J��h����CiU�o��tf�#���<V6ά}'<ε��x\[�E��*�-3g1�@2<����B��F���	v;�J�y'���ԝw���贫�^;����g����Aę�?�����3@�&�>�'�*~e�hbnq����z��d���&���C|�x��
��E��zҵ���Ocvep08(��b��3ͤ`��&�zl0�H1~B6n6����c��0��sf��Ƥڏ����S�d�~�Ъ���+d_��2f�G�|r]���^Y��f��Ƃ#Vc��3��0�-�Ճ(
'����f�H��Dg�I�����zB��eM���Ā�ْ�;
��[`դ��Ui�K��{�XY��pL՚���	��,������)���-1���mBp�(���Q�ύo��{d!2ns�L|X��͛*����Ѧ�H�=��hE��r���Y��o�3�i�#��Jl�$�p��hsSb���:OA�K9�������,�GW�&O&��࿴�� ���ǈ�E�Ʒ�����7@V���7c�%Y�B�M��0�!	V�oQm*�k�F���c� ��`��{����l5�_�*���Tw}�W�$��Z���MaYX��������������(B��w�*���k%A���ٌ��>���p��;6�Βhp�}�Ҿ��Z$���>�T�Q����-�>�m�ܮ+�K�q��ܦ5�{��&�� ��L��Y�e�䊽ae��-3]{f��$��*bb�g4d%6v��HoK�Vm۬��� ����1fd��+�A�fh���1����=�Vc�Ȥ
� �x��(�g�w��Mj���0^t1�ƉH?κ��RX|�I
g4������E8��pPw�v��H(�����^�s�d���?���~Á
�tnK2��b;|i�ޡa�\��ؚ�	�ΓPq�(�"B�+B�D�osC���Ȧg���O{�4���Fi������"nL�_\}O@6'����뤢�`0�'�E	��g��7�y�$ ޵��ۘ����iEȷ�f��i�z�/���~_D��v�j�w��;p�T|���)�D��W��86��s�U�����yl��@N��ȿ��t��y��g�$Q��V�8K�;
���?�}m|Y��>�����*8)��s��PJ4w�\ʅ�4�H15U��e<CNVAV^��r�Y�U2�%�e��Ϟ�rw6mh�r��+J�C���W֛%�Fj:�� ��CE��pPnY��c���0,Bfɳ*�W$�����\/���֡&��υ�'�f?}*��;��>�f�ަk2\CD��]��U�&<>^o5��q{k1�OZf-��m5�~���5fߞp$5�;
Vn[�ʘ}Z�3�ؒ��64�b&�T0iG����蹶1�=���f������9�x�=�c.p+��6H�
���������=����zwk�	���� c;q&؋��`{{W�`Ga|a�v�,�i
�k�u�6Z;�&�q0��Z�^��;	@:�w��:&�o<Jh���ڸ?K����݇kE����ngw�U�Z3��[�_��n@�4��"Ԇ���u�P�f[�ߖ��eh�~d-�W}`>|h�h^9��wL��x�0v@�,HNҒX�����e���gQ͈8�ROn&�9����W�
hb[�dG<�=1ʥ��-�2gK�nG2��8�ب�m�qܬ	)�Y��5��"К�@��X���4f#�Y�����J�3Phn�
�F}}mΒ�ͻ�����㙩��>�Q�|kX��@�����[���p�0L�<N�ٔ���84�ƾO��g���Y�C����a0�'4�o���9���m?U���.�Yb����4U�,�V7"�FaU<yj�O�ӧ�U���g��!d�v��܏�RΙ81Q"����?�t��3k?���󹧉�g�3��a�e�>8»�5���L�������0��_����`J��EMD�B�wW�uu>�	��=0+Ϻ�z����D�V�3*7��}^N�H�Ew.9=�@��2X�dm��3(Z<͞�)�����]�{;��Q��Q9wm��Aw��6���s��i�~2��:�GU{bM�����_J��W���=}�\s�.9�̭��=폂�T?\J�k�џY{~�Š)r��-w�
��nӕ�*�'�v���ã��py�|���%��d�N�c����ոEӜ���	O��-�����!v23��IuG[>.������1��N��Y�
;�(,��zt������6��t�Ψ�|֥Kl��	���ɗx;�Kv�8/�i�U�y�܂�6�˻��ωR������{XЕt��>����v�«y�w�O4{��u$�����a�.`�Y����"恗s�_�Ҽ��@�<���O긕����`T؛2�$q�a[���^��):/�˃)+Y�.ev.�6���4�W�<�_3�8#�9�B%���Wlx��e�s������Qd[Å$O�ï��ّ��*'h��hl�pPudZǫ���Ք��\0f�7nvv��s7w�[�X��t�����fC�v� 1pu8[���y��^��	�ք�7�"K��i���]����.C�#���'�z�)s@eXMn��ʺ��@�ns�)�qJ�3*�!\5��a�Q������n׮���p}c]�2?���í��]󽣚n���#�$�J\�x�~\�6��eG�ךk��5٧�R���]�k��X�;���5�'��/�ih�������[�s��z�8� �&�� ��*���ߐv�\���%�E�S.>�C~�l.�o�K� ��£���@cm��2�C�h�O�Z�����c�yi=x��<t"2bT&����ښ�B�g���ge���SҜK��Xԛ�U��("2J�s�d&�Y7g-�'e�p̘�E��XdZޅB���1�ʻ�h}}�Z�����CS�ȼ��Y�l,8 LL�}㱮su�*��W�;y� �����Ff-�xW=-�Y@��<����������~�8k�/� �3@*���(�8ӯ�a���#n^�Zk���1����� �T}�lEV�Ww��3T��c(�8l^�F FO�N4Iu��WBw{aY	v�֢�$0�QhO=f���(Ŋ�̢��hU�Qem���eGK12�k�p�z6�/T,=e>V�U�]�>�l/M��YX����us}�[׃P$���5/~ď&���>�����)L����i�n~�)UM�)L���BS��j��Rg��~�=�R����>�����·��Oax�]�Z�=^�Eΰ��1�Ħ�B�s��.G?B{�o+5d�mՐ��t��)����Rt�b+��XWȈ�f���'?�",̱O���|�Qfm��Hl9��zP���s!��:�$D��OuQ\W�ʙ�`�?�7:7���;y(��5��-�@�уEx\Y���c4Zˈ����Jr�\����97��9�}��o�6J�P�\�2�>Ps��,�2�>s�JZ����0��֓�`���O��ؿ�&<zr��pE*���ޱ��n;�C0@D�[�7�0~�Ǡ&c Q��c����o{{���ߖ�;��CN�H�=�/��ь��ԝ9�����*9�a�����)d�ۚ&�J��J5e���7��v��M�����cīp`�]��� �
o܊`Y��7��NN�^�7ʠ�x����co�A3l;2��y|&$�]�~�D�rG~�>ђ8v��'2�����
ý?�pksGY���c��'/I��o{u����=B�-��zP77*��6���y�w��5:S��m�i�nF��f]w��qҪk�ME�cP��U=K�"|��S~=��g���w@s��3$;4gtV�iߏ�q�AW�BW�
���Se"�jp�Wޓ�^����{U��:jl�cu�Q�o��$�ѐƀ0ő���"sj��J�B��G:�R"q��t��6E����պ���0��qe�����2%�b !��kV��|�&1�w�Wl#~vZGx�*:�Kmc0�}=�өjjkn�Ţ�ޫ�AFc?�65}�i�}GF�a�~y�>�/�*�L�-־Ŋ�?^�BVx-���O�(�CXz�E�&�V�����j|�+p�&i��]Z��UY���R��֊Pg�]2S�P��f�j�cV�r��ΰz� ���� �"�Y���y�n�R�:h�M@��?ތ\2��44oqO��ӵ7P8@�~�� G��y˘���+�;6����CV����Lǝ�\�H�y����*��փ��9������ی�� ���I�%��u�Gjw���cs#!����g�"��xBJ�:����ǓiN|�"�9K�tp����R�_��Kβ�4�j������(v��?Ya<��`���8V���/���d!�U�v}��������(�V�ʊW9�,��E@�H��6��\�!"�����ԫ��9���r��B^��˭U�w�0��Z\�KT���[��C�k!���m�c��GKȖ�r�c2�PB�2
c����p�k֛�諤m�2����P֢h�V���y�h}�gF�γ��a��dm�[��8N�7�=��|�;�đ<�x�Ij��M&��ܑ�����?�)��8=X�.Wx@�'�=��� Ͻ�Gkp��t�Ntg����p�'��-t�W��@���Lw" �1�����lw<�o�JJ�"8r�I4*�����Sg5ظ�X���ivsW���^s��E]0Þr������P�.׎�	�@��b�9y���K�I*�h*�H��y.����D���ʃ�.��{��<�
�c��)7�$�Я��/r`ѱ7F>Y����5~,��C��b�33-g��\���\?,>�c��F���f�Ԟ�Ȳ9���)�q�_6�/�V�:��@����2�Zr)~"�;��~��iy���A3�N�uMA�xY����!�߱w���qv��>M���.�Mg.a.�X;�$��{�ɘ�Am�arG�7��u�nA����ԟL��{1w�޻eu���H��=�c�{�AY�u��BP�v�?���m��<s�����˶~��w���r�,�'ZK)}�	N>�N��s����9+�+���D� �QQGcn+��[��'(�P�h̓u1J��p��U���&�+Zء���1|��m&�r�F�@��[CgF1Uyi1�,Ms��v�0G��]հX��6����ba<��>�U��0%�Ʋ��Uy��I1ʒ�\َ�^��G�=��͢|%&��p<��alC�t��"�
y~t�1��~���,�2�~���&�˒��"��*��&>%L#9�0��y����l��f�d-3g�{�G��;�_V6s���6T&ol(��@0�����
�����9�(w/CX�(/���;Ф���[#Tִ��U	K*���5ر���f�)��ê֤z����Q���,�õ��J�j����\1��3�fd޵�-�ϷM�kn�i�p�cd��N&ߵ�uv|v�]+U-��6�^j�����}�8yR�	��W��Wƀ�?����c7uz�u?�4h���n��{\�9��0�Ŗ>0X�a�OCL ���I�P �Dd��u8a帋~�Le�~w�p���d{�͌�"N��+lr�£�e?�z*XNA����{w���?�8���)�����M}<xom4���u���ܠ-�����y͍�zs}s��ly��V��y�k�7f|����\�e�0/���pF=�+������/��/���޽C���y�����+�ۂ���_���U�999�_��?�߿�@~����v8FA$�I�{?������K��?��=t��S����ȿfw��~ >0w�7����jln��y��s??���z��p<nnm�m�=\����l�o=\{�����ow����_�֯�<O��������x��˫����������A����*�-�?�0�d?|�@�?o��#�a��ͭV�N��O�V[Jt����{����<�� ]?�c��4s�Q:�����4����'�%�,5Hsa<J�^���?
��WK[ ��2c �C���E� FALG5dc0�)X(��P�^|�����$�	Ƽ0NdI��\޲��Rĥ�$x�u����:@�:qr�P�h��Ә���։hG!y��n,0�.��a��Cc�!��!��Y{	�>ƈ0��y5�Z�5�v3�pdj9��o�qd�2�k�����Ey��A��0_rA�B-j9�v</�������.	����l�jg���u5!�?
��6���2��	�_��k�,Q��tr�Y�NEV�ߣ����l��x�@��k5��!!2~.Hm���W�E�23�Ns�@[��e���mQ�Z34���t�h�4����ڷN.ݿ��O5�8~��=�4����r�A���# G�cDNğnjvW�KK�\0�~�g�CI����0�q����\m��7�\ʀ?-촸nG���!�U�Y�_*�p����*I/Н���/��2��z't�z|MT�,��)/��k�1
V������u�x�˪�Äm@Y���U�]��I�Σ�26$k8$t"�H�(tp;9�Q�C�%�KSJ�3���N�Y\�ٍi �~��s{t}�[�2�N�(�/d���?�؋�ȥ���HΧ�r�f��g}���MJ�;�O�P��a4xb����M�8֜��RlQ<�]��/�T�k�������uV���G��2w^�a�3��x��㲮y����;Da�\�sΠ4��^"Ŷy&w��Ћ�}_�����eNCޤ."y[X`�� �j#�FKD=�oB^&�&R���t���"-m�3�`$jJK���}���4s��/�\@ؚ��rb1�HI B��'�`8_���r�t#����ؒ+�j
)&�3\֓O�TN>+�̞`���|�Cـ�m|�X���/Q谳�KEF�������?�#�Ṩ?e��?�,=%�9����!EH���,y+�k~X�P�����������Q���~�\����e���	H!dlj��KD�s`|�!�Q-��ȖgS?�?��4��_^�S
�f�Sy�Woz�p����|aW�漄��g�Jګ����m� y�0��+#$�zL|���:�m��W# �HRƹ�S!+��rl��1��*��[�(L>���O��R�6p�`��~���!��S�XÌGމl����=�U��ǐD^��Бۣ<��xN��[4�~E�Z��O�S���ןN�(�_���)X 0��Zn����Tp��R�Ƚ)R�#Lg�T��9����	/���g�k��&���đ�����P�c�
�-�B�6�DO�/#�]$�p"JΫ[�v��j�%��"w�a��G^U���=�jeT�}LX}B�f�8�*�c�Jvž��I��*���b��Q�Pn��4��\�����O�8�s�ˇ�m��Xf{�q�S���
~.d��?)�W�l��e��O��L���'�Gm΃�;(g���鹛��sVGq��'+�i�UX6^��t��HI;���* �7�e� ��0Y�ǫ��:Q���-�	�m����5�����b�����Й����i�BΈ�&^=�N�k!�'7	�"��|��ꃳJiA��A�����>�7�;�(c�$�
���|��7�𵂔�(��\�#��Y�M	jVv",��̎|�m�e�Ҏ����0��&a\5ʯ�Ӡ�bi<�qRC����-AU�ȵv��ȽH�	��CT�s���N��	�:`�3�k��ީ��"f� ���u��d�Ƽ�8���.���\7%�I�|0��&[Z��)t�	���7�i[�1_���}>�6Bb	:�0�L�A��L��K�Q��y��ȇN�`¿�����Z�!Ey���1��ͫ���es]!�l����UV�:��O��i:~W�O�J>T�r2 gi��I��:�iЃ��	�,$g���"�/ӈ�&��*E~	1��ȿ@�U�b)+��^P�|�Z�;o�-1�'��8��I8@,�)Ԛ�Hb�P�f �)�$�3�U�,J��1m�6	��X�m���Q�
Z�|&�·Y��d��$��pw�'�8d�Q�O�tt���3xi�s��r=��C�!{�U��[�[��~�44d�ELͣ���,}�����ٷ���i���A6��eq�#�.T��2uQ���*(��� �W@*9�)�+�0|���u¤#�ΞU��h<�'���5J2:��{����A�1�����H.��'��1���ϑ߈�V� v��,�y,	��(�v:1Pj��q)D�#����6&��*[��h,����&�~��Պf�	�g�J�Z;�$��	����C�Ѽ)�>4�)�8�l��*�b���K��U��V���֨!�����]��"�%gzv;�^�jO��2��p��&��q��?~[�@-x0�p��Fw���%�[U���=L٠(��~���oj| �A����9<@.�_iM;�w��k��j�
7�����g����3� �X��ژT�}զ֘T�_O �w��s�@<���d�K�8��v�*��v �^f0tr���U����TNo*eج�hLO(�7�W���e&��@q3��.��%��\��9�������Ӷ���u���n$c0S�U~�c]5���x�c"%j����i��Sd}��!zʁZ�<��ؾ!aket]SF;rj�&�L5Ԁԍs���\Ҍ���0�n>��X�u�n��L�9�f�W��I�Qֆ>�U�����qS+&%��E��Y��$�0�1���+a(jYX>3�_�e�yS���4�%Q��)=W�H�Gsh(�E��)Q�D�Zh�=~V��*���,r��8/����<e�k�T���К*�V��O���Ÿ�Lm��~L�S�&�oѿ���V��5���B<ݲ��=��.�kPk=��|u��:Aۃf֢�a��>��p���*�1�����p��=�69����R�3�cv���
��Z�$C�9q��!DA^�M��Q��U�ҊgV��״�J���5%Vi�p��6E�k���I�)�� ��C�u��^O�i����j�P�����׿���������7��,�G~v����F�l?蕬^�K�����.�p<�hcT%�p�+���~x���!+ϓsҧ.$��>}\���_���e��S�{������������_/�K ���x�������:H�̋<���(�F��K!
xu��tG6�?)c�s�H�Yx���F�-�ƃ�aL��c4��bd�$[���iՒ��C�"��}X�Q�6hYu� �ڒ��i�)��r}�g���q5J�CP�����
�F��KL�Q�f���f��KL3
y��k5��t��z�w��fFG侭 L��b
-�crV%� |-y�q0���E�o��cܘ�y�2��E�V���g�^�:�y�V� �חu�Ïr���M7r��[�{��Q�������e�����L5C�ڬ1+ul��[���vq���ԏ�7�'^���'!s����P����
�?T��u�L���Z7<�2����Гm��X �=�q��P>6Qi[���<Pmm?h�~)��������_R��7�B����t@+T�PVtc���R�++z�v.2���r���Hu��'^�qx�%3��]�r"m9�ʆ
oTcmz��cif�RhL�bw8̘�Q3��Ô��?�����MU}�$T�\��.tU�	��Ǯuei�1r�ݻ�h���c�ugһc�5��bՋ�)v
�z �Ǥ2���>Zc�n��;V�K��c��=%��v�ڏ���&ES�3D�\�ɯ�	zq�E�#ڙ,���|����z��k��P��&��S� �75��>	���`a���gc&Yf�U)V���H<I���yă$�x�ɮ�X��"�E�Ζ�ƝQܛ6�åj	��VU��x�;�E ��ؾ�xp!��4,Дm��#L	dja�S^_g�����MHo��ϵ��r�8�Wn�<��((d\(�5,EȪ-X��5�r���:z�T����/��Rϕ�
���a�D��c����0�rL03PQvT�
�]m=����Vl ~@壭�0	���>]�MQ|'��E�دU�y�|Y4/V�� ���ӨRb�iF��?Ӕ*��p�-BfNgTaSaa�Z�]�6�N�۠��v������a��c��I>�f�����!J��Q�` �s+������(��0�M����ՠL�Y�P�c��f &8/���N"?d�gmH�,����/����KJ�����O�ރ�/LtY,���*�¡��O�{F���s����i��`$��-�Б�6ր�����񲅝<̀���:�V��� �zU/��b{B�
��1�Z��g���)�E��F��F�G\�׀���q�����pDz'�V��-�N�dy�>�l��>f�]4�mm ���z;cM�q6�ܔ�ջ�ڀ-���U�G�̚��e�m�:�J.@��LJZ�MܚU��Ȱа$C�|*����9��_�2���.������&�c,k�Y�l��Kƞ���^��4�Tw�b����(����a����<v�Uv����蒌���Lo���,���yد�T��5���7З��T�k>�ujG���Q!>�5`=�^�=��h���!�Jc��p��`s�A����Xk�7Z�f�BM��c^��9|U��ʵZ.\C�Ȗ�,�����0�3ִ��\���<�Z:{���-P�rD"[�1=��>��_D��	O��6tgс���-����w%Hq��WV��^�fE���ߞ�E�f��;�$n���r���Υ`Ga��}+S��Q�ڊc�Gb�hW��bzO�	�}!��;k-ӭB7�8h�^�}������[��Ue+x��DVl�i��.�]�S�0�GL;���}i���%^�h�˝�ֲ!���½���)�VU���G�A4��8����R/u�m��Hb?9�[�a
X�~ a>?���U�)7�X�:����#�E��ᶢPqm��&i��h��B���?SG�{��<�^L�`d>In���F�>�׎�3�y�EO�-���	��<�*��6SQ�u�!��XԿ�!j6����2o����]ĸ���9�ͭy�����-�:��Ndk�^!R���g��ꨄ�=n;�}=
�tN=���;�_<�@���ء��:die�N:�N�%�ΎⅦrh�-��Q,ۆ��ӝ�����ϼ��NH+��C����v�XI`��ϡt�F+=n.�!	l��;/���y���d�q�?>�Ӓg$��4����0o[�_�A�
�{x��8>ŀP���1��drC�!/�ZV��"j�f=��@�D�� �����U3�^T?����8����w��"�S�'�-f���O%�f�F��ha��'����C��rYY�V�/=�|Ճ6d��G��n�� �zB�`̝�uҳ0Oك�d��HW[5�H��ൾ��_�'!����w5r�4�l/I��t J���UOղ��%�'=~D�UQ�6��Yo=Z�]��L|��٠0���أUm�w���U�9/�*����@E��A�\�=�D��܇eu�QϿ,�gWh��S���U(�+Tw��/�O���w�(���r�������G/z���_u�st������.��Er@�ɷQ^�c/�~k�>x�����������k����
�9N�/�:=��������_�Z�`x�����}PE��Lq)@"���gյFC+JwJ9��aӂ3��r>�O�]����V̎}���������'�O;�=0M}Q!������APEqQ�͂���b�EKDCA_�a(�'K�#��UM�*K�UM\hM��F�\�t������~8���K_,$w{�@��_%�2���^�S)����o��| �]^� �����#G���+�_v��v��𖙸~�m�r��_�T��dn�� �a�z��R�=e*Dޑ������?m��z4m@-�?�Y�=��)H$^��L������2��|��[�G�M.���)��Ou�O%E[%9�<�S[a`o��h6ì$2��Fk��hO-����������Z~��6ǽ�N���+�^�cWJ?�SR)�G����
�g�)�8�R��Ғ��h9T��	���OvaTA
��Ҭ� t���ǵ)���$�f�O���ԟ�J6J��@�;gK�ݰr��m�)�'������{��f�TT{��� ���b~r�ʨ�IM�$�9�;�_���m���T�Wo�B����*���f�Ǝ㼞���e,w6f���l/�Q�}���R����S�!��4oH�ZP(`���a�XW�ǹ\I)��ח	cD�:�R��#Y{u�`�{>����b�g����cv]�leo��:
�(U�W��J�UE�h*��y�쪈µn���
F+���L1�oj�x��S�a6
� ��"B얡��:@�HKY!��'����ɏ��L��_@�+N��ͧH��8RY�4�-����0�ft
~Z���9~q�t�v�Ae_x�ڧ�I�1��HYpT���Eu��k.,L��P�^���vO�����Cֺ�����]/fYڞj��ߚؿ�+�������+�Џa�yGZZm!rd`�&c��]p�(�e��1��y��(Q�uz'�,�x��%Ӵ�N�����H!^��� ���R<���Z����Z�z@��nAqҵ�w�{�2����g�dG���4���^X
m2g���I<�'sh	�kv���npx~��V���堧D-�F���F����80��|���]?�������&�<9�g���d۾�Q�y�S^��pd���;c:y�lj'���u���T� kp���û��d'T��<����E�r�T�:@q;���n$��u��9�8����g�X�W�b�K<҈GT`\�>��)�I:@GH���lB�3k�$������D4�?2G�طeX����]����q�Ȝ^o��
I 0�Ǔ�u����P�q��z���K���[�����S���/Y7${���quF�خ+6��?�d��sFaS`%���c��7O�3�G�<��ݲ@%=�-6��(���e���q��>9��GX6��.Je��<U%0���W��g��f�X��+o�lWO��ę�r�V�������Ii��6a����9.d�u��;e���V\�����6'w�񞙶� AA�D�pɣHL��.�=����:
�MO19x������3.h4=��0�v(����舧�����z/��hK{�>���@!On�z\��jVY��^q.�+\����S6���A'��*�2|D ͌�(�=ω�UJ��Ym�'�����D␀s,]kt�X��l��R�
,���--y�u��- J�pa /�Т�B�����?kD�Е9�R�������Ԡ�e˨�h�v̋�����Vmp[�x�tɲ���۱SV��B	l�Ņ�F=�b!QUp����s�w�i:I�i���{�<�1�z��,e�N��9ᶅ�ǑmH{Ͷ�/��N��0��
'�� p�_�Ao�C�:$���Ō�'���0rH�X��(ǀ&uY�8���DU'�QR�J%~���H0dU��~aɒQ�)hX��D�Dk��	k>N"-��9ۤć�<�Hx�P��Q���p���c��ʅ�m�����w���!����K�3�����Q�
w?����by>)s/��*nT��k��ܵ��m��!�%�����|�'�x2v�l}GAc�a��*�	J���T�Vj����Q�>�ヵ��;��{4Y�"��4�}?˥��@��f�L����n��Qa^m����CE��/�ꐹ��1��`sz�R�����	�l]_�U��y|U��OU�Q�����z�����P�q���]��Ɨ}�`�.��Y��ǒ���+�����A8��pH/߹�(�*4 �� �Z��b�%W:]�<w�)�6��H���TL�vU)����z����F��6Nr<������0�e$�V�G���I�\��u�I)v�|����	�Q���ӝ����rYvo�dVr����>�yKa_�h��/��6�W�*��B�j��:;1`%S�yx	}�/~8�o���4���8;�p
�7��Tlza)}�O��H�v��K�tz�~�4�3�!����X�G��)a}B(�ДSr��.����U�n#J�.��_du���e�j%'��x�
JݷGMm���.c8
Ը��"g�4�K�2g��y�L�Vu	�^��������0�ԅC��߸�Ҿ�S�ם��\�Q�
q�̃}f酖X�X?]����"�m{�^�����eF�q�ѩ�(�z7L�0�I���N��||��4[������?
q�����j��hl��{������h���}�kn4֛��f�k4�Z͍{^�}!0�3Ef�\e�0/���pF=�+������/��/���޽C���y߈������m����/���Ū윜�X���_[ ?S������� OE��uy�g?��/�X�o��ǿ��N�}�>|���,���s��a��Vck}�w�>:8��_�ko�������������ꛍ�����Ɩw���9�>��[�]*�����ί�;���/�ƫk������C��~3���Ɨ����S���������jn��l��w��c|�V{��� �SAK`�fI죍�	& �(l�Oj`�^�9y������nLN��/x�=T�l
�|��4�e�Y1�y��&Z0F��;��������t[7������q{Fvu*���������tă �ng�ͻ��`j������� S�����N�Jq4j1�F9d�g�m����>�`�l"�M��������D��ǎ1��zM;��l�jg���� ,�(�P��8��+苈����I,�D�����t���������x�7���в�DR����-��?�7��ɽ\�.rt,�3mE��������ǓE�� ��r�f�..3sYH�ջ!Jc�Q�W�dK�ݧ|�jŎ�+����GI(�d��u�%�'��K��������^"��6�1L��A�]�N�B��c�W:I+x��7+h������Ї���8L���$�.���G���.�:� EQ���S ��E����і��`�9��N��:	�ˊ �@�@Nxn�c�K^��ȿ��6I�@�E�e}?R���(F��C���"W � �LLOM���vc�x��ܽA�*o4�	%y���@�7��R�� ��GE2FW�H�J��>^����|wD��0�v�\�\�L�Y�����&y�߿�%�.c1~3����T'��lk�A~����Pd���y�3�aA�Ai��GK(��>+�9�sNa��o#GY����5��� �.~�V$����v�E��,�\��B�|&�}	�h&q��0%	��Y�_Ay�P"�9�l�Fft� ���^�!���
%�%r��2������h�ʧ8�kښ���l���4ɔQuzX��f��p�r��y�+U�h�/Q������l.�0�/	�F7���f�'��sC��k��od*S�B��������8�9�#���U�?�1� ���b��Y��H����&�+�N�3x
���
��b-	���X5bN��1ج�JF�b�8��McE��y�;`,=�Y��
r��:�+@�մ�Ac�xr-P=�ղ&��p.�1d��@x�L����h�7М��tP�����×a�_!��D��\ez��g�
�
_�t��rT���{9���L�r�
��G�lT����)��J��~Β�b���?cr��ȅ��3��=�m����(�.��E�)?��ڇ��`;�_y'i`���N&)��ꁟ��X1D�t�u���`��2]"z��jk{Tj�X[dm`�k@�B�ط�rФ��?�����~R��.)�"2?�]�,��f�\���5b��;P���{X��f-9Q*�"��p��#�`��UM��ّR���-�{����Y�W�D�LN��^��,Q�*�o�x~l0�	5'�A{5Q|�15�N�_��I��2'�Bf�����7�1-p�� ���k�nt��-���཮0�
�M)�%��
8��ftŝsœ/�_�!3}J4�Y��M6`�q��T��B�"��ްZ���xH^W�qnb0�������2'�gQrF!Ef]�-���&7�kx=m����0�]y،�p�6�it����!�;%NB(UgƎ�=7�i��ɳ����?�#�U(V=��6
�j��/� (�O�V��RU�٪^�Cg���B:�j5G��1b�.��q5f3x�߰������D���˜YhBZ�b?�b����QL�3�8i�9�9}�1�L$�����((�������gt�8�*����#k�8*����� g1���E��g,ڒ=v�=�`����>rc����	���&n��
�����W3J�FP�߳�h�־�B��(8���;h�̓In��af��L �\&���u΃<+H���� 'Z�۩*D!��:o��\	�ҾɆ@�����f�Vx��i%3�[q��>;��`����0�|%���o�4���58�Ȋ)&���U��}�;�n�,�O��k�>�j�*���  Y5��Gz)�X���Bnϲ&�%��0��p�r�9��q��=����%�x�з	��D�I*�hXb ��g�Js�q�.�P�R�L��(��(�Q�t��C���BZK_x�)��""_���XD��R�Qh��5���<��k�n���h�qx��ux�sn�lv^Z���#�G���2;�MlI�F��#�+�!�7`�/}�9?�]��UY�(|і^/��-|ׅ����5���k��C
�ԧ�p/u}�r|�/;P�����J�!�72������3����T��X:^$�3�D��a���+�ߥn{�d��(&o	T���?�b�i����pPʃ�V#��)7�V.��UxP�t�jXd�H�e����
�� ̅�@�P�wv#���]J�>Vk�8	(�?�݈m�C*�H
;(0�2�5孀(g�� ��);�4�/�CI����nG��I {׳[����%LlJ����\�l?�6/ϰ�G7PZ&L�v����`���I�9�'-(��N��U�!IP����Q�`�Χ$���0'<!N��K5������J�B�Mz�����P}�!��;Cߨ������i�1��Hy��
ϴ/i܈��5��|�'�ђ�9�1�P��I1g�|��A��_s.�\�g3��S����Syh���(�tb�`� g��3�VH����ǘ� ������`�2������0���y�0sڕ�d&Y`o.`�]y�	,i��L��O&gЉN�>s�
�8��<k"O
�lWfaNS�!�-H� f,/�5���6$�BN�ڴ3g�t��\!��^����Q���~�� �(#"�O��n�!gq�*>|i�.�ÙR��q��."�/B�Yba��bSne�m��J	v�!�,�Aj
@[~Ri�GtN4�����^C��s���͍�]��G�����?e����:������y��1>���f��z��xp��g�1�?���������7m���~��Q>���_w@*Ҳ��I�J�����������Z�<�;0��ì��x��YF��&��RtQ����-�ű)4z�B��A����u�ƑW!�����RcJ�d�q�Å�녌�p�{�-��5��(�@�:�͛r�� �<2��lEE2�b�x�����T.hYy�yDy�����G2Ij1��R1S��/�x�%p���B���l�U�!�|g����q?�X�Bf7|���fh\�D��_�}�����]`��b/J�j��)B2��dZDz�<#-+��=��X�t��"��X���J�
�f����э��J�(� w��-uuWdj�vH��W�cEԺhZ �^����������Ej�h~��-7��t<�^ ��V�p��A�*VCǣX�ɗ�2�9��~�-�!z�wcS�^h�B���
�.`��w�G�7S�I2��c4SN�����DI��k���5%_7g����_���2�ܕԴ�ݥ��"֝9r�� /��,��3���6A��zK`|�R��JK-��r�;�55��^�1�ZZ�}C�|�r3G�bf��������o+&��Ŕ%T�q%5`�9�E��p�D;j�9ĉ���y�#[$0߬%/X�4qi��Rī��mm�:<%q@Q�Q1��m�V�k�����F�NV]!�e�{� �)�9dq���	 x�C��jD�Z��bP�1�넩� E��.��5�[��~4��Ыk�P�ƞ'if�T�s����� �R�4��c��@�ȫb���\��)�B�o$Y�u��mi��a-l������ռ��8�<|����6�@,,���`����k�x� ���ߐ�!��0�x.4��^�g�p"V��pPKqի%��=��v��B���T���
1��B@�PGHj]U�l�����k���"ԺUgu��b_9�� ݤ�8X����\��T�T.�%�G�i�u��":7Y���y�v4;L��I(�����Z�'�MoR���N&��تIe�R�P+4b��,ֶ�{�������(�z�:3�gzN#�-$��,%��x�I���� Ô�eb�U�C�҄�0����W�_��"���x�K*�\�� :qv���@���aG��N?7�Lͤ�j�U[�J2>�~�	�h��~������ȕi�=f���G��r�Z��,\��F����U֐k�̫p�f
���XpM��2e^mv�Y�Z�_�]&G|f����D��P�h8��1�B[ꅬx%䎣��_���#EA�4��:���aw<Wy��K����n��	�S��*#�WД��4���F	.=��T�y�#�D��x*��G�}ѥ�zVL�Q�7&����h?�K�-3�A��I��0�T��c�}1�@����y�e��:#D��?{o�G�$�͝�L����9���(pQ�O���&9 �� vO/�*&��P٬����"�a�lOvz:}��IZ���I2[�^��Mz�O�?�}ӫ�?"�#2���&9�i��l����ye|%�4���� �Ӱ<����y��}�.�]0���/3ʲ1�hy���(����ww�bg ���Ii�j�FN;������]����P׍�~�j��tw�� 	��y
�Q�x��������q�LIu�hI�	���1�LV�
��@�S�I�Z���K�Aw	��-A�_%�c��[�n��\�]���ol���Lφ�~q����'��5�RÔ!��7�o�$�a��B�E0�"(�;��qP�k�?�ģE�$��Oׯ�l4:K�t����+@������i^�E�[�j�&����y|��h�%���Ɲ~�~#r�������S�A�� ��Wތ��8����ʒ���)x�H�Xɔx���wjQv��>��D3ϩ�*gj 6��1h�_&�o��4����/f|��MÓ�s_���Z.�����vA�Uן�ܪ4q��8~��W�����U��K�:Tn����v�Y��y�~��Apa��}8�i.CЕ�	v�����N��L7|C��@lFw).H���4�L�f��,k�rrr�d�I��N{���R
i���F���T���Z�����@Omh���g��]
��G�@V�����nt�>ES��)z�l6͜.�ջ.q� �y5��c	�g���t2-����D5!�o�E. M̼�2M�`�uE�+n��r����j8�.$�x�2�`w��I^ꍺ��v_�=��������B7�� Lguؘ�	D��w2�X�|�]8��G���Ÿ�s^�K?�F6������¼��J��Xڥh�:-~�7������#@�v�ļŷ+X�^ڳ��K�lwc��d�"{-X�Wo�!��f�����eN��P�$�(\�\|2Ü&	��Z���(|�E%!^�||�cL�좙vK�;ʨ�9̓���BZL�v��U�xp#z
��z�%�;8�/p�V����U����c�r4�o�R��l�q��g�3�l�Pj��Ļ���l"��~��uO�H�и�9JV��l�5(Z�W�&�O3u%(��6� 	�n�ە���¶���6����T��
J�$��:�/58J�䐀3p�����@5�[њ���1�.�}1����3�iE��/K�4u��L���20 �����/�iG{R�5�ND��ҫ��$^�m*��m)�*�r+�S]���䍼�U�y&��BR��g��&�@�*-�ߴZ5�p�֒���R��E6~���P���]_n6q�ҕ�JEvp�L�mn�fP>w\z��z�*��<�@.5����y~�$�����Ze�y,�)C�0�U���6P�X�1��v����WUG%�&���Y��:��T"?M�x҉{�	��*�e]ȇ�f�M��j�MӁ���f���D1\Hs��΋�J��}��)W"�<��i�6���p��C	?�{}���{�6J�*v�)w1�l��R��Z^�{�\��Ć�����O�9��,�$G��,�M����J6֞l�㴟��+j�]å�	��)�AD�(T�~b�N.5�(�O�Z3�mv����t��0�)�.B�����%X<'��YK�B�q]]HF���ŏ׆rGS�h
�>����Ε��>xtM(��'Sh��Jn��j�Rb���!@a���'�`�Jh�ASF��a2��r�'P:�D.	9
���"߫1'�ʐ�o����"�j�Ú@���LҜ�R��!����P�9�~W�=*8��������84���]�k� �gB)��lҘ�#xJ�-��/P,}R�(|����g!�'E�b ����L��eN�B�Z)�c�u5R)>�PcP+��$y�z�� ���R��p�Q'aYۏ/ �l܍ǅ3=�����BD���4+}�޲O&�ߞS���PM y);��F�	E~n����P��S��񤢗����SI*� '
m"Wf��=�f����P�x��k��� 3�^愈2	�o%Z!Y�Xn_m\��ෘ��2���p��Y!��
�{�Y��ƫ0x����C��#�˟�|��{��F�6Y����Yw�x���D����k\��`��3CN��5�{2��Py$����{7�6��Sq�)��Ḓ(�+�#^�at��y��������~ͽq�V#�p�|���
�C��$��*�\�l+"[������i<VBz�$+�L�j�����p��6��������j�|���Sw#����.�t��h8�C��;��B�U?�$u%8w�w�?��{M�ͮ��.�;w��,��q��Ө��Pu�3\1��(Z�u�د�#־)�ڇ��.=�&�Y�����jC�����]��1��"Yԯ���LK��N8=��Z�hX��)��]��7�B)g2щ�ܔD<��H�R�q��ҥ8~7$T�`�^����Ń'y�&;Q&���������ɏ;Q߄�0|�8e���W�8�Չ���&6j�#L>�D����V�
���87��%<o�Mj����Ճ�r����!�����ܘ:ES��ru>�e�����?+�9���%iDkP��>92��X	��j!���'$PH�Ո���34OD��k���>�.@	n����&�Lf��ހ���DH�߁����������Ji{�&�pn"oJ�<M �;$���m� 9�M1�'�P��A�(�>�,9��Cw]�=�3�-1;׶T��gz&�V-͇�m�ێ��eR�����K��6��8�I��ۙ)"�/<�k�쵒��A���(8��k��9���Ǌv��6����j�ė�۶�'��ЅWn�)��	�}�I�D�C��8�{����m���'_�H=������M�(��|�`V�O�ė�����J�N��2f�̒um���Farb�O�b�D�Kb��W@�up��lu6/�ڂNҧ2Dz�
h�t$9�����S�ʼ��\~t2�ЍL�FP3,O'����z2=3w���
�� 	��<'0k+Gթ�Z�q )\�E(����)���sgaU ��Y��'}G;��d.��T����)�eG���zy��t�.�h>�H
1:�
�5�tFGi�	�NM���6�R�Ƀ�M��?��[�h���,V�MѧJj�x��D��80iOPW:���I����G: ҆Q���1��e/������a����Ѱp#�#S���	+.
��ţ,�yJ�w���Q2oE�n��/(�d�{��t�Yu}��Ӛꄉ�K]J~�-R�ut5H��0t��1j�A�.ЁN"�P���ő�C�!�)���_���%ـb���-�����\h�G�~F�P�~"��w�ª��β�1�~�F�����p%?d
P�
�$�{>������ha�GS6��r�Ĝ��Z)!�u�4��ńj+�1��ϵ<���y�<Q��2o�B_���y�&�$pf��k=�VGY�<3��i�������(�+�4����<���5ݘ�;5���o)�wf��ݰ,J0 �5�����O }h	*���b�S��FЗ�U�Z#pAȃ��x�`*Ssl���c޹�^1�q�D�kM�W��"��
��Q)��f_��/u�A��VE��l4'������4���a"�����bc����_��1����W���]�+���P�>����`�ϵ[�������1�������>N�9������[�������0�R�O[�i^P��t�1,�� ��Lj?b�����8��{��t��R���)A�δ�3E�\z��}�K	�/C�[�'p�|�f�]'�*1(��z%s��ځ]e��<�"�f ІhC�%.�
�4�w���v�@ˤ YA��ʱC^jX*��We
��jw�����H�T����O�k+P؄���f�E��}��f�6�"6�A��Gh��S.�ԛ�Fɠ��Q;xr�ȉ(�w3��JT~"Oέ%�
c����?���}s���_�ۼ�3�ʐ�n��qI�i�LJ̕�3��>p��'�6c�6��%���h��8�O�v�=�%�Ak�n�I��A�s:_$/ק1��	�d�{b�0�GZ��w%��n����L�=T4�M�XF�H�#�,��m\A�On\���2�d�q�O6j4�������=8:����m{v�&�1��s��
Vpjţlta����'ɹ�z���~\�����D�������~ڷ^����P��t^���܀1lA'<S\bv��Oj_��"��+�T�ǆ&��*�{@#���&�K�_��{�	MIi����f-s��$���`v�P;�q])e(������4/���O�l�^��D/�Ut�Ji�� �txA��:�j�n��_v0��ІR��.�(`�c�qՏLӒ!G�I�9Xn��D'���H�>)����ٰ<��_�yi'��I+h�����I婍)���r��H&yp2�B���8Dp,�Y��t�0�S';�8�K/�2c�kc�@��-8�Yx�:k��@#rM�^a���ᬌNH�*�eC�HpS����#6	+���.�b���?��o��y
y��[����?�1��a�.	�S�O�)(o����u�r#)��qX^���u5,���2MuK����#� B�ڪ�(���ߩj�l##PO�1��a^T5�P{3.�Xp���;�N�ި@��?�����1��!�˼چ.�Ԯ7��'��,�T�4߃88x���}���q��O�����,�(t�	�
X�+�����o�<���\���~�����W���kv�B����Ӌ�T ��
z;���e���xڋ�x�m�V��ΓI���Kv�RK��fL��؈�=
����l8,%be�g;�B��8( �EpXjV�@o�YS�(��߽ܹ�'��c'p1�]tq���׼T &��TOO��I��4�6$`�ç�탽�m?��o�~��Dx�+q�pZ���Aҋ���E(:#NVL̐����55�~�4�탣��ӧv�_�~�狳�RB��Ɖ�AY�:]1��x}r'M���I�U<u�z=�$.�ɔ�v������;8�$�~�Q��I5%��*@H,�b��V�YbF����!�F4�A��3$=�|�C���x�D�Y\g��Z��\s�ĕ����q�?����	%n�ٖG�2�O�Gf>j'��i_�Ŝ��J�DV��J^1��	�I)�Q;�GX)zW�n�,��[��͠j1i���T5�i��ۏ�B}s��|Rb��ϣ+}է�nr6=�/���5ч��[P߮{S_�渂\˘�DH�,���)�7PA�4��Bz|�����8y�G���8�g��m,�Jk�MP�5mp}ѽ{�.Xd�PH��+y=��Es���/7�"�I�N��q�)-���=�u��w����J��@���]Gb٭�������Zؘ��;,q
XÒ�!�O��)b�7L��n�Q��x�8�T*��݆��'���� � 4e&�X!R�%xD�K%6R$�yG9��k�{�<W��'���\��&bj���8���_�@����4zsY�$8>�JSf0s��%���z�0�R��tfP�S�1�D�BA1�)iJ�XƤ�S�@��4+w?}�����	C*�\ey�$D�Y"�P4B��6��l
/!Ӭ{����,RQ�w�?����E�lC�?����bc\�j!֊�a��1:u+,_�26����p�Q�� �.>߃��Z!�X���N���+�8���-����RB�,r���E�8�@!���m�'���i��&W���]�$��u���}�B�A�y�`���\�=X��t��[F��5H���T?��Dս)>�d�C4t"���pӁ�G�ė =��=Y�NBڙ_�������I�h9��H�xL�zK��fI�;����n ��[r M����@�����J ���ٛdCBźm��  �t���ѣ��eeƱ�Fwlj�(5^��YPg� 4�T��bP.�����2��"��.f�h��rv��`kB*� �3��t!"���t�X�)!5�Pk�k�tMG�T������Ŋ/�.�N?�|�\��ŃZ��?�5���{y�>�W>�DHPq�S,�(�Ɛ�&\�զ��]x��]yӫǯ��=�t�jH��oĞ( �oq��\,��)�y��m��^@ӊ� �םg�Q�+-ޟ
�D{ܭ���.�s�U�R;hPT��~]�F� @���m��b1:<�*�u��Lg���Ɇ."���ޖ\��y+Y9��Ϻ�Ote��+�4�k;��չF�
����^���x��m7����mhu�d�'�P�(���%�Ez9.�0���#Vl��IJ��Wp���� 	a��k���D�8�`���x��pm�p��� �Y�
�F��J6,�0���4���K�o'߇tۗ����lJ/�w�Pہ*�� �i��s�T�O`0�p��o`ԟ�c�琊-{��_�rJ��!�
L�89�}=�O���gq��k�/��C���v��B�~���ph�v�k^���m��s[;��T��FY�.��S<�,q����!o������pE�}�����9��F^S|&�f��v���Jp@y���G�سw�K��z S(�K�w����@��U bu�n5rU�htr��+�h���<NXѨ}�ۧ�Q�"��F>PJ��沌Ǆ�wK
� ���n` ��3�+k�kD�//)�Z��_���s�?��T�K4U* i����R�O�n�>;����A�0�X�en����+���d�������Z�L�M���Ĳ{�O��񁙅x�|�y��D�</x�1�uY��q-m�u-'C
�.'I��,E{~F]�e�1!�!z�s]���G�+���e"�˪j�3�,+�J�ʉ��X�aWE���%z��v��J�֬��E�4섨_�tCԍ�⽖]���q�@�[LP��"ὖ��y-k��T1�=^p}y���uF3�$�'�"���䌦��Δ��Ђ%�ΛJP��-�w�
�~7T2�򂕔���h�v�t� �P~50��#��ĩ[�;YK�x��?����O�ᅗ#`L�x[mۯ���T�:<V;�� ���6=��4{��*<+y�+�s|��<ɲv�N8_O�]���1�J�
�}�J�X�IaA�J�3�J7O"u_O/4�y�C��Z��@0n|���_ܥV|���*�x��K�������?��t���~���oI���Y�µY����%��]2��H\d��_�C���Ε�G�d��wh|c��|~5��3.�����&P^��ݻ:1|0d��(g9�{�띨��`�>��!}������$Ur,�i�t&^�vx9�X@�8=O��rt����lص����U�±p!���Lxyy��_�p5�G@�U΂�W��U�x
�]?�0�W@�	��2��*����\׻r�#��ۺ�-��U~}�py������vUFC6�S�sz~j����� �,w=�[�%�mQ�sσ�s����'|�Z*��k��!�]4�[��'��ϝ����,g��{�d��\<�>I>���E�]v�����j^r3E��_�u�z�9NqU>q�%.��8�y�p}��3a/;<Y��W٥�c��E�z�����%᲼bA�n<�f�*iN8�&ty�+E�3l���
��`����<-���CuM*q�]��GS�v��	áٹ��\�LY�����⃵��'C/�A�(|B~]
�����@�J��Ϯy�xo���f��[��?�2υ��~L!<:EU �<Ϩ*★��p�v5�u1���V#�����_�m-���tW���V5��s�"�kY���H�ѕ�o��E��YN\��*�\������W�����0��қ~�J�\>�����	*���a���*xt�F;�NZ�H���q��B �)�-�
�+M>�������c4��"�W�26�jE�>���?��~U_�>W��%�+�ۨ�������^i�I�����F| �vI�'��}xh�Z��t��k���k+���k6j�zc������v�j&�Ec�S�p߾�\���F�Iן紆Y�??���N����xz6H;|"��zg�V¯���&�e���M�$g��WG�p�>�<z��NK:E��+~뷃ݬ�N��>
uv�wp �s�pWr
�-��u���jWLj8W%Ыy�f9����{��tB���դ�Ѽ�L�6��̒6�aU��Y}�Ү�Z4/Û�����C�s��^Ԗ����?��1�sp~�_rz���D&`|����
��|����`UT�:��ng0̟)�U5�P$�pA�SX�%�}TNỴ(�sBc1W��p����kvߧB^6d2�v������ă���풳���"��QC��x|���ޭТQ3�o�K^(:�1��E��Y��LX�0<_j�H�����%�jQ���D�K�lХ]v�(���e���u	?M��M�N�-���2���S(z���lg#gw��ԡb�W��ƺ�c�p�Ho ��k�1�������fjG�xp��j�)T#�V���Zs�Czݡ�F�7�7�P�C}�u�e/�A6:W���ǣ��Zol�/�q!��Ϸ��l�l;#�39�>�gU�鯐�Ja��>�+��v�?l{�s=�* {cMb%�N�ы��&��b�G�
~�c���C���	i��nک�y��\�P�!Z_^���&�?�FJb�X'�x����%���®�{m<$ʼJ̦Ğ��gO"���Q8K�l�Q�a.^EUP��|��I�݅�0R��gf:|�-�Ҧ*�I�2,�#���l��ض�O�j*SC5�1��*��Vb�t�H=>==�X]�NYd:����(Ɛ�{�v��y>��b��,�iX�[ '^���c���/�ڄ�֩iXh���{���ȂoS��%��4� ��i�ݍ������_�en"�% �X��AX��.<赙��Y���|����O]�c�T�L��)�n����U��R�@�/;�C%+Juq�]9���+��+�ށ���o%U6�dp$�rN�gk������f�&���u�<����~?��<�i����zvV�?nf��&u3��?;7�i����	�_�kO��;ށr"�r��`���٨�${UҠ3US�eȡV�򰶺��5ziǑ��:����ϋde����E@[ Գ4�z�&�MË2��nv�迚�t�n��P%V腂T<龊�H��i?ͣW�tЍ�[x��<r'�X�Z��uD�0���6oH'�&�Ԭ�TB��,�B���
�9E��.��ݧ ��"CЬ�'��f)���U�gK"�3�A]��#�������S�k��(n�ް�n7$����4tS�0"�"\P�w�Nd�&�m���V�S��;Hf��\�Sb,Ȟr)���ȗr����-s	v���a;UKFuޢ*C���@|��WH�ܞ�����$m�y`�t2�Y�$�=���t2x�~�^*qM=�y���Ћ�(/��ïx��	�q?�1�$��	~�#���w@��|�@1̓A�A�d�cK�m2=���#��G/\MI����C�N�c^XF*��1�)uY�������M=$׶�YF*>�Û��@+�(���L
��{��	Y��ե^&�7��\�����n�C��ۗ/�@�����!`M�i�q��e1��vdJs�j�tڪ�b���rW��׎en�~���~��ƽ�.�Ἤ��yp~F��WzDm=�>3���Ͼw��?��#m�t�N&sj����l	^�E��L����H�S�
�0�`����ՙR�}<Q��u��v"�v � ��{tۈ榩N�P�
d�O��(ȫg��{��0(n�h�T�	�"�x�J���A�0v)���{`
���o�fhS��A$ʠP�5��q���-�!��m�I�� r&%���Ѯ��z���jDh&��:~{B��G	��Z��ĬCA���+��i�ZCe:���0��^:ɋ�qi%Z�$��z:��ݗ �t�����,��Ȥu���Q(,���.�<
c�XB	U�R�(��٦�0E�X�>os��"��슳&;� VulC���`��qH���`v|����Q
��)���!�nԡ���9U�P)����9�)y�q�x���A֡k��ؒ�^*����\a���h��O��dae`S}�'����l�ȖK�P«#�N������q��L�\�Zi��/�,����MG�
8/m*�N(�y���Ug�#��Z�OLub��ɨ��H�.�&n'|�r � �^2C��9����T��3 ҟ8�w7E��Ɛз;=�oZo%ei)Em�O��|��=�mS�y�,�Xъ��孮9PU��.bm͵T����D;@-n�/�Ɏ���`s����_��nc!��F$S�{���G�	P+� � n�z�P�n�oV� [�Z ��N��a<��ctc�����A�bc
��("W������g�F��&��7��|���X���
7M�ސ;���B�-M0�D�R�y�6s�{3~�m��1�@=W��e!�,�t�G�ɨ��=/O����0��ޏN�|�'���'q�r�}Z�g� ��p��W�r/�IϮ|�����a�v�+��԰1����5��\1sB��CGeaO�g��o�����6�/���P�#!qӟ�cv���g�#m��=����`1o��Y�MB��jލ�.B���[�-�MZʎZʧ�e�p�_�	ㆰԜS��<�o�q��J�}c&zi�N��s�H����!��b%��]��#s��m^>o����Vav����f���^ñ[�m:��m���v�&ƭV�R�]�����F�!��"O��5����G��U�у��՝���h������q���2o�6����gVᖦ�{5����2���k)v��L��@SƜ��ɦ9E��R����a���8Q��2��7��@�qp���$�^�y���x��n�ƕ@Ϗ;��B��Z�5�)��7a��E�;���p�t���������$�~<b%P<�R�tp���b}��{�VC	·0�{!:�B!}J��F�JNG��9E7�wS�0�2�,'F��E�bR�mh���)L?�E`�!�I�(b�"�h�|���� �9���F6��!e���K�iW�&1e��!���i�#I����R!��t-�	�sV�H�_�Sg��`mp�y9L�3���>�L��mN����"!OGbC*P,����U��U�!W�9�t�Ğm�<��Vr���~I�b�_	s���ʻR��)/`@���ғ��
0�8B����ʕ�bjNM��]��I�~���� )Ƃ4��>3�o N�Pt�P�-<l����zH1���Ӹva5C��5�W���)q2���k*��\��aØ�d�)97��j�4!o;�|a?��c��a��2g��Y��P��O�n����l$�T��D:�/��v陾-�o�)��h���f����n�g���o�;���7�ta/�ӢwK!zG��t�.�e�|zFI�k+ѭV�B�����]����r9wX�$❵�whF�H�(��w�s�[��W<�͇�#���&">�ԥGԮ��D�E�MP{�]�ٿ?)7t�Z9����/js*PQ��n0�C`�'����׎�V0�)��t��P�����5�R�Т�o�%G�q7_��֬��*��v?/_��;��W�Ƹ�c.��t���^�V�ﱳ��ˑ�']��NM�70��N.�E�^��3�Fdy�E��[���K�!�� ����)�0�9UM먩apV� ��@3ʤB��Ҳf#]�>�\*o"�[�1�ND�!0��Б���cuV)mE�]�����G����M����ZҊ�g��?�O�"�lҊN�����g���x�f�^Z�u�M���8���5;�l<���e���I?�f�Z�3�0���c�kf��̛gŧ7n�8M�S��-�U��a9�C�/�z�����{�O��W��OO�6J�m�N���:�_���L�>�L6r��P�˙�Nvw4I؂�с�� 	m�zZ�� �mf���`"�s����}��û���a�� q��h��mɒ�eo��3�!�TL�@& 7����m���ա��Ho@��/њ�ϣ����b��A�i�yC�^�18� �p�J��p� d�'�E6��ٛ��
��J�ph橎P%�ZL�P��'oMLۃ�|
ZKQ�Q3�52�pW&1���Zֽ?-
��,<�@�Gxț���BN�Z�2"V������	Eeg���2���.WJ��'�Ċ�$�X�;�@��`��a�d��l,����~A^l��hi�[��/�^��΄�a�P[9o�)I��<+6N~E?. ��Ku��0C9<@W(���t}Z�Lq,���c���Kn���SP�<'oi3�O�O0z�DL�Q}��)V�ȁ���� }INaM���xb6������W�m�LC]a��7��w������[[����7�k���{fl�oݼ����������h�]M`�o
�P5��j7�FZT�S�z���R"���������?��?��/�Ntx�V�<��������;�?��]l����c�'�����c��?�������� i�00���?�����V���������"?��~L�G��Ǌw&���������K����/���b��~?s��\�������ō͛�_n}y�ys��/��rm�V���������{��6_�E1i�����o�����_��n��/�j[_F'���w�:	�����s�1�����o޸����}<�?̯�h�&�;H4~�Q����Vt��@��ۊ�u�~۸�ŪQ}t���]��Z�6�E�W���J[�9F��� X;��'^�԰{6q���r%$�+��D��x�n ��sYM�Q'U����d��X��0�@���$�zƟ����r�*�=�"���fMi9a�����W$C��Eԁ_4
��y�G����5�5ݬ���1���lw/��<�@b���@TN�:���ya>aAü��5t��1�/$�h��U���7>��D{��+��g�zR�	p�[p{�oi���m������\5�Iw�j:���K{��o�]�N��򣮟���tEm��T�%�M!$�:�F�E!$T4�a��(Os  �0]�@�#dL6|��Q�q�����[��m-1���vG���������X#�kՐ��@0��N4\w_�k� �v���-=3�Yw`[|���B��;����	�o;%�p:�������W~v_��{�O+�Fk߄��f-�����o')� �C�Y���*�Uh��PU��H��J���[}�O��W�5���u~ ��p�TO�n%nTʷip�#%6%���-X�} ��u���r�.���w� �D��F�M�Z9
�;SC;�	��) �׭u�%o�-{���T��H�xt>�q>����J�1>-��_���}���EroDϯ����9|��PC�n��-� t5�z��#E"mB�p���.����̈́�a{�5{��F���H�j�6 �ϑ���+��$��]�ܔ"d�w��@[8N�%}5��1��@~�}Zb��6ȕ��CMu�t@��%�<�'F�`��h�3�L���-hD<�m[�X�8)��񤋙p�߸�,��.�������"/E<�#E<�O�j�;WEm����;�2W�:���F���+`uY��>'�x0X!�$��$?�������g�)���'�t����\�kc	W�	�j��9E����U.PݩZ��8�Ԡ������)�6���C�&�Q��'���8����=1'� =[������+�D����j�}�z���;F��?�ձ����0p�V��t�{�*�������4�Ɂ�+���"
��q�!����t����㟄�7�~�l���,C�v��~���3=S�%��.LG1�o�r�n	Y�9�i#:����oߥ�ݏsjz��NG^��@Ϗ-�Y�c۹�n���p`?�-]܎��j��� ���#]�C%y���B��P���
�`\�]mc1�:�e�N��|B`�9�\�-�R��ݡZ�3�aҥV���{/�e�2<��0D+*�"CYߡ3�yu�'��rzS�-�:d��~��d�(ߠ�]�|��Մ[��$Ât�c���7oj�t~.�������R��Z���a��mx��a{�iA�-�/����IWc�F�^,^��OG$lO�}<���()~ka~�Ӯ<Ϊ	:�ŲWC���D�԰���	���r��R���k��D�6*��,-�5���1�]�5�.kF����{w�ö{���}�.ٶYdrGBP�bb�x�p��E0Eu�����rT�yy���J�d�	g0���ؤ���O]i�R���� �x�����rE'_���9ܜ́j1�;����R�0���"��-��)�c(� u��CKf��L�I�8C��E�h>��*8��
�u=�w+�[�+�K�
�p��#���$
+I�ut�V�b�4���� ��I9��4��������/\���p�'s`>��h���� â�AaέF���"F���C�c;�_7O�}=Tٳ�A``kw�n 5i��xƨ��G��Js�c���EIc�C���_Ҝ��>u	�v�j�Q���t���^ƴ�������;�B{8��&�:�	��z{%z��t`�*�ƃ1��)��W�1��5�q]�w���_SW5=�yQ��{$�[����`|	�g�M^��T�։b�I5�2T`���.��#��nˈ�0uʽB �%���g���LK��W���z]!�
�8F�N�h�L��:se�X >�o�(p���!8?�.��B�iq�9�/T�u�99�R=T��-�΀�H J�k�uY9�.��>A��$fB��#pb�c�X�t+8P+~O�<)��s�z+�}���`̖��%��UR�UC����V2�5��X ~b���MN��XI'��X�k���v54&��m���$���Sp� {UC��n^�C8Q{��F�EK�:H����Q���CS�q3�����<!aƀAC���a<y��^�B�� ��3ڬSp�^�PbN�C5�E�=��W3�$b@�ꀞZ��[+��>ïd~�@�r��$�|�(TES*f�f~�����N|������z��X!��u��٩a�/h:h!od��B�Ŋ�C���~٠�V�+�^��l:�ƛ��%��h Ѡ^�Aq#����:+����.	r7�a�	��50�Y����k`>�[��?!���$� 6D�o��vB�8�
��jN��D-s�(��8��C�a�H���U����`������5��i��f��l'��	6�讄G���iǁ+mH�IF�$� P�e�8��O6d�*Ŧ��%gS��Φ"���4����3	v�>�s�)�g8�,թ�cs�	�Q�ʱ'5L����Ш �/�q.z�K+�ep��G֗�i>V���	�'�L0�AG�P���u��]s<�9��_C$�z�����[�gp]�?�:Z�T��BI�*[�޹:N2�\�����2�5;p�W9���i����) 8��<���i}�cct2ҽQ(B�+p���#��[��f�)ݹ����:�L�g��Zӎ��e+�%*k;s;�,Fb�0�dp��ѝۚw��AM���]i�V.���3o@��+��Ҩ݀��K���M��4���V�28yK�8�%�v#�{������ɴ�_��Xi�-1}(�O@��J�� �_g��=�����W�\�it���2�1� ��ƣģ�P�Ddt��#ơ�J�a�:����7ө?��M:RE&E̽���Ĺ�.��@����!���*<����$1VImr���J�B�#��8�In��@���$|)��xE��S���p �i<v|��Ut!���UV~��M�Í���Jb�Q��$hs�(1���`$l#�DK�w+2k��S5_w�P �a�A��$L|)UyҜ�����a�6z�sB��U
A0���:�ˣ�`�β�(�F��͚�)��4UO!��ɻ�E���E`�a�w`bU-��B�
�!�U���/���s�i�u�A��.[�K�x°�B�;o��_�(�;o�pS@�Z\܉��w�kR��)��{%ꪜ�T���iW�ib:�j�Gҝ7��/�nG����o�V�����n�T���"�j�� I^[��p�UU!���A���ޣǧ��8bU����8�����]�&���q�=���C��W=�_�fǸ0�q�AWq������J����=����Q�QW���I	�ZKOxk`�9[�|v���\����Ŕ��&��c�/��u����V_b��X�,�:��N��[N�&36%G/�	M��䌹�C�q�f'�V"� ��wT�l���P�i��;,:�dp����E���$Z	u��(,�z=f�fl�N<T�x�٦�c�59w6�;Ű��C5�{w�"~���1��j�����ԍ����{Ԛ$�غ	����l�+{�=�?����3E4�\Z]�rc�y�X���/��|%nE�n����خ���9p�TO�F�`E )����C~Y�*��,�Tu:Ѧ{dq�!��[�"RЅ��4R6CH���j
���5��vy�<�;�K�-��&��]��vFiUzǝ]�i�f�1ԡ�2�;�CM��g3��tRQ��b}�6�۳�"lM�W�«����(�` ����wܚ*���r����-t������v�g������p��k�+��bQ,�����WJ0�t1Wу��n���m��G�K|�>|���v	6����ֺW��HQ��"����C�OG4JW��?���cK".ɐٌ�U�)�j�'!��%�NZd ���i$���+Zג.kF\�\d�L��9��ʔ��87����tD �W�=*���Ng:����d�e��U ���,��-	�F������^��4!�M)ۏ�0��&xi�x�j�Oo9�a�i836:4�O�aK8O1�`I@p��"�{�;x����[4��|������2��_T�pW�S�����O�N{v��C{b���a�9i��L g �&x�dS��(�drDɦ^a���>~�5
�w-ֹ)�p0ܧ����.jZ�����S���wH��C�Ĥ�"��A��U����E�L"i�_=�	}j�%\��4ye�M���+����S+:�
u���	�� ����Mt�s�\].��� �r�R��W(b�J�X�Q�{�:)��Gٙ\����'<B�l����6g+1�۸Ԗ��:�w��wt�w�����w�Q�d��+,j��/�v�A��ZVΩ�L�_�SH��R�_�|�z}��ݓ&���7\ڝ�r��M8g2�9]��9�c�eG�rqF��$βF�j�9���c�Z;-�����Ѣw�
P�'����`�fL5N�iѻ��}E�� B�=�[�3~�f�\$W�m�`9kK)K�j�i����k�m����}߸q��/[7�?�����/?�M�����\����T-?���`�����T[q�c��?��������y�������o����Ϝ����9 1c�L�߸r������͏���}��~�?A�U9 2�z�?�����߇��忛�_~ys��G����'��=����������W,����!~��H�zWk�����i?�m�8�a�U��v҃�7h�Km����N�Ȃ3��g����yv)�\�����l:�F�E^$CP��� ~<a���(��n��%��
+����|Ҝ�,"�P�b�c	�b�i��N0�&��������WN5�ތ���OD�G�uOwwN��F�l��=�;��֛��e�$���s���Kϧ\�܋�R;����Ζ�UiRZ��,�(�
T�c�aD#�C%�G�+�)�  ݔ{K�UOOV�G�	�����Y֡\@��e:�F��| ��hu<��)@�S	��zϢ�o��'Ϧ�K-.G���:�M�m�����Lx6f�	��Z$M���.�I�)=`�y�P�+�X���JT�r� �(��gn�"Ky�-�dFt#�h�$���$�ץӷ�����77#?]A�*fP��
�J5'��1�9k*�M�OA 0Y�0 Y�T[��<dgX�
F{��bW�U7�a��bú� +�}�(����3�ܗ��μ �Ųe��F��CE��"12<>�zz�{�89���{��Sb>���I~F�����<�� ����艕��LdF��+�<ʊh�$]\��� �%�E5%����h�%5ed�~6E��u��K�����)F52�Cq#
�y�B<WpR�&M^5�(��s�)|n ���P����L��<�=8qr�u��Y��H0����G3xu��rd������lc��m ��c+�)�v9���Ƀl� ����C]�o�`���)�����m��%�հ��B����#���^mx�~&���a�����s�ϝ�$�~��)\�5$��ҁ�9@,����Y�O�3�h�;�mۀW%*,�sʂr�����,�C�ue����B:N�vh$�x�Y ��y.�2P��/O���r�Q'��Ȇq ������i�D��ov���ⷋ$Ib��&9���ʏ�2j�p�M?�إ �]�Wl��J�Qw.%`�Ӳ���AsVf
�g�z	�F������ΐ݈��҂��Ģ�L_r�85#n�%���������i�$"�lߪ,�#ѱ�����2�=H[U�G�̮-�B�������� �ҙrl.�IW0?��N3e\�o���b�4��6���.>�M�L�[�-��̵Iv����3�ٌUg�8�OG��h�(��B���X�dn[��B���4��N��"�P��F�NL���[MNk� �{���I�wp��{���T0�-�\I�`�zcf���M�����خtSҢ<��j(9�,�4�v�Q�Wg%:%�M�wah��y�om?<Y��nu�z�5z��z�"����Խ>��j�"��(�G}ї��k���@CuC�+�̼?�s=A��:C87����y�`�Pd/o
u,
��@n�L��q��L�A�Xӹ�L��$��0	ĝo)T����s�MkN	&�N�}} m)�i�Y����[b��z���E�y��
��HѶX������/�`�� �hX�#y���L3��f������S�1<�9a��@��Zo�3�,khmE�Nj�0��m�ȹ�pu�)�Y2�	���`f���SX児�لR*Đ�"��vg��,���	�C�s�H.�2%�)�[�E��)����X�\q�?�)���Hɐ������G��z=�=�����'��7�3rO��L��'�Z{�����3H+�q������ɺ�}��k���$M��J�X}�Ku�"��14ԕ����JT�A�i����Q2z��OV��Y�-ih��:��!b��!7Q�<�����f?��1T5q\��������\�2G��bު:��ߢ��6S��\_�e���_ڧ��wA����`��@(�4�6���9�`"�N�Ԍb��s���X�)��j����(�x7� ��?Q�I�z��V�T��`�V-�\�����B}�� �"�-�%�
�� 5M��f
uh.e[rv�u^(��^g�-PW�\�~Y�y�['b�*Ҳ��`��,t�����Ņ�B ��B���lF'�;O��N�
x7�#B�&�$6h� ��Z�f2��^�<�A��+���i��CE;���A��W��T<9ُ�)&b�\?-͆	�$�9Uc=Cf#:�v��H�N�q��&JT�Ht�7�a�`��[2��b��CZ���21Ćb��L����K8/�#˨Q��Cl�!vd+=ƶ�a�4�v3�� n{#�a�
��a�_���2�)aK���}S�"6�<G��x��b������uحiG�@wr�m �dg�i�`I��S�	N��0ˊ��tp���7�2K	��mˆ�s7TCc�����xr +��8S�P.�&��Pw��9Ls2W�m���`%�G�rL��3<w����s�v��z��E3:U�ۂ,��➎R��2~���(+!�����/���ʦ@25��`A��t��O�b�nZpISH��%d������Dj2�y��k-�l�Xus�	x�(�����1R�`cr�U�8af�P��F�^>��-ܞ��-K��ꦈ&���26�0� ����d��/��4�uE�HH?9�
56[`�oLy�g,g��y�\za�Ԍ�nC[g���2[����ʇA3�dӷ�E��vm����D�{�/h�	��:x9��7H�o5���c�6�~�������`+��v�N��XQn_�T	ѩ��!�A�%(�}m����HP�ֹ�{�.�#�Cl��0�Xy ��ʠ�Qby�h��z5�V �d�t��c�;5Po�\�z#*�q��u��d�5��^��|�����^ir��bր�����z%���՝٫x�c�ǋ�42����GAS���S�Q���F0ف-)�	�~/<m�2L7�]Yv�8����5����M�}��-�8IzJ��ؐzBH�71��AFX���}0s��h�\D�ŷUPaw'1�&��I	㘊!�x�g��$��<)L�V�����������w�":����>�z#�×��A"�b&M�g/,O"S�
�4=2N��f�+�<��cxw���k�e�mI���[�y�����܅�M�C�d=�R]�b�`���$ri�+pQT��ꬎ�g������Q�v��wc��2-�;G�	%dT�A� 	ͩ��lT-d�A]j1Mt�dSj47!'����M9��NѮ���d��F�̇Ƚ�=T^`��Վ��r����$�N!�hݧ�m
�7GP��g�V!��}O�K�y�QV�ж������(�((�ʞ�^z��%�_�G1�p5�R���ȫD�X<$�����p�w^��\:�[���A2a1F���ft�`�AZ����F{ONwK��5c�skw���W82rtv���BV��e����r�,wuz��/��Ex8̺x�IK�\�q���Z��fpڣ��<-��lVk�U46��z68�0��:�D�ǋ�)<��ڤ	��[�U�Ɛ������5Vn�5\��QC#)og`8g;:�ʘ��(@��Q@�<y����уx&H��7���'��V�v��J*���i�sM庥8�A<����_b����w\��y�R��2)�	�� t�Bݲ:�����(�7��jsvĂ���R4?�(}1��]H/��Iً<�`C'�ƱmҦ&�3̸�~
a����o����ߍ�<5J�rt ���/�T��q!"@5�n�n�:�����[v�������{��Jz�Ckg0�J��@�C�IJ�<��~xR2���h�qMQ
o�,,�/��c���= v+�\D���v)1t� �������:(�����PH�v�>� ��K�%�e�t<d�a�u ��5�0)|�D_X�,�ݔ��L� A0R�����G �H��D�ف�Bx�*�&|�5�~�"|
6�>���2�����Z3�v��	���8��a@�F6AdB�a�I8?�Uګ�$�o����4vJ@��Kž���P�秺nc�J�u��}���3�rg�e�?���* �k�߉ٙ$�PT���qƱ���vx��.^O��ŭ���]���Z�g����h�s�o����M>W;�yak��~Ikx(�߲�}��:�*���m���9T�`!���w
k:W���h�s�M��u*3{97$@��˾���b��n'�e�������-�;��f1�0X7���n��vߖb����7z�?P9p h ��lXp�A�l7B'TZ�+�y��y<�.��dx�t���?��H�~���<Z?����B��w 0$�U�3�&����g�В��,>:�w����b�|1~�|�m��3��9��}a�Zr�䱿F�1��;��-0��p5�!��2�I��.�������DG��܄ύ�1�C&5͕��!��>w��� �ގ�X�{uzf�F���X��n�zv�R�!0yN��x�P�0I{0zQ;��<_|%�U����XMZ�]:�b�@����V3����=9�SU���<�{����d��CqK���ޭ�x&0���(����)ey�jZ[r��9�/�D4s�w�@6 �\�l�<��m����~�� �K�;���8D���ܟs���@n�.xȝ>:S�aٿb�'����Tq��6�M��y_�LW��d��P�h�/s�4�4w2V��x
��P`'�I
��X�j�d%� ;}]oـmS��+���;}{=3)�Y��Ȃd�{F
����WD�����h�Χ��`����q&+��I(�� ��A1f@����F�A� ����
�����jC3�p.Ë��F3:���1�<:8|�wzxl<��o��J��Um8H»�c+�Hi�����.�@<�׏&����[�DD�0b�����d>�x�1�t���'=����6���9�OJ` ��|�@��G�o��8�Sm8gI?~�f��9������:l���y�\��Er�1�Ȓ��$(�)����05�G��RTż+�&E.�K��N7�,9Ʋ5�*b�8J��S}��p��C�$A��j��u��Fd3.�T�4�.:I�D���ߘV�+�󰚍�(|��~�0%�L��w�P̪�'pz#�'X]7�s�$p8�/r�#�u�q�*`�O�@��f�h/cu���8p�U��m�[#PI-`�*���;���`OB��dMU`�y��Rc�T��8��R���w2L������IU`Y�[�\��a1x'�����X������\}�U��m�����o�E��͵�}�����?�M��������������C���_7�6����y�c��?����\���6?���?���6��Χ�^C�y��~�������������Q��Y��[Q��+�77n~��>įB���ŭ�_~���������?��7nl�}�����/�>�����'�g�h�,���ڧ�����o�ͣ�u�F�-�D��`����h����hU�0�:+�0�h{�1��c�DŚ�&�*Xy�j5p{k��Y��ڣ���'w��ӵ��gk�77�K���Ow�-������o�����M�l�m��z�dG����/�ƣ��_��O�\��>~�]�V�v�Ƀ�������\kj�V�%�~��]��|������ �r� �f��ٛ';��ph��)�U�&��h�������`:�^5������z5�0�\Q��ք@KpF/M��?�?���T��Xu'.�����4�S�<]���*Z�=|�T�����nr�]3� u쯱�Xo�5���<T��j�8mk��F��W�E>�'E�$2q_2ƶ;�N�}	�0���Χ��࣑����8�֖Rodk�m[-��jȸ5k���j��Ēt1�k����5-2^f[nJm��-���6��v:ă�`~�8u���Cn�Ƌ��ٞX��8��3�ߊ���(�(�(���P���.�l�$�R��߭-�̐���'�S��z��+����H�Ą#%�	4!3l[����^;(n��n��<�,��ѳk��p��E<\[��ҳ���W�7��h�}�b� ��$��b� ������\
��k��b��Ü���p>�Ї�����3s����1��W΃�VpK� ��`�����{i2�-��5�íꎦޒm�����p�S.Xo��l��Z|��u�D�p�NT�Y����,W�N�������r��:�e�ţgeW�o2�3��YbN�UbI�v5�˚:�B�?�ڎ!3o��W���[�;��5-C�9i�)*aͧ�v��d���0�o�w�{K���;�K<D�؉�:�<b̞s��/84^}���Fh�s�em�?0-{<�R�FH�*��@i �`-O/xT8�<B�G�.��VI�z�=��� �uQ,��<x+<�Ha���X���2@��u>YR�M
yw�ʻ��;\��xL|MQ o�]l�a���epq�'���12�e3�7�|�1�M�����s%���Eң�2�CZ�� �xW�u�D<��R������A��y1���{����ۆ�l��cpj}��~������	t��]3m/K3QLS!�� s�q��!��*�t �-�"��i{��3��k�Tn�	M�.�wpô����U>�9�G�xrNB�#@�j4�a��2�����ŕ^<ȯ�,vf)/�O��Y��f�;�D���F��I�&�-� ����QRH�����/t�3��JN�;�1�6�3����Rv��s��{{et��<�ͼ/���j9���ػ���>�t4�y���.�U�]A%�s����#��op�b*>մ��h3��2���B\Z%�%ߙ���>���9E��pT�s/��I��?7>�-[4\O-?jF�a�Z]=C؈@�Q/R7��B��|�72�/7��O;O���P2V��&'Tb:Z��K,�M{ѳ�ы܋|��m�x:2��_�;;6��I�e�`�;f�V��_._+�d����FQ�ǿ�_0{�#sG5�0Č���+ϭᾹ<�Gp�|���p4K�'�s	�4�TX0��M�^�����n�TqD�G��[�8j�.r��lm�]UW���t0��.:1�V��˭t����Y=�U6�-5U�-�{+��a��I<�{Iq��5OfmD+z:z1R�sA���@� =�B̕�Dó��
�q|��2q��V)�����٤Hծ�/��7<�2%/������Ì��/"�����	�ޝ�XC�Z�7�](��Y�*��Q�L�9���b��eD�f��X�Y�����J��� ����!��QG�dtC[��C��VS`��T���%�$�W�C5���MJ���Wu�T�����I�5��I�p���'�	�M�:�����et Q8��Vig ���� ���'$]�W��L�Q�@�m^�ʀ%�3���r��?���N��������rZ��w5�ө��O���X����V�R ժ�=������b��	f_B����*Sy�N/'9�.�[�!&�b!X\Ѵ��>�&=_�=��d�n:�-w\)���h)�un5nE���E�w�k�@,LЊ6[z�dR�d�d�!��GQQd32m$h�r4\*_+)2�Åd�ո��8+�����w�^6;R�ͫ۷i{K��tI\����%<P�U��p={�����N����r�qc�%#��,��f�����<��]��*A�/^/x���K�X�Bz��tz}�k���נn��X�,�E��"�S�	횶w��"`��&�
�P/͊�J�o͚���7��)������h�R9�L�ܠ��R�Z�q%'�L�iY�T+�Czx3�|���ma�z���)��L�[�*�*=���x@
�q!�lo�k��+�i2�Y:�R��.de ~QT��&E����6p��B8p��75�L0?u��Hdu���]G�[��;�fy�d�s���E3���]�x<J�׬��8��
�!�tMXv go�� `a�,�&�E:ƭa=PhW��Z����A��5&���'����p]äL{v�0�V{���>�Ř�¥X��o��P:�"3����ԒC�+%�����!�f(�DKDCKr�.ʣ(i_�MZ�ăX�j�$005��s�M'\�є�O犰P�+0�1յ�4�_H?<�)�i*j�d��������mJM�.F���mΎ�	(�9ɫ����>����4ݖr;ƎN�vI�Af57\�T�	h�ԅ�!x��|e���ist�e/�Yc9�z9N��?kkZ�cx83k��$�B�d2�0p�E%����f�Q�QD�x�)k}
i����M�S����~N�WgO������m}���@���_?�_0��󁷈�R���_���ڸ�������������?��׿�X/�m|�1����f;�� JP��EÿP�e�2W��_��������E��l��=V�p��r����" L@"Ưu8�t�V�� ��q�j����ن��v
��vF-�̀����z>�.��g�THX�~�7Ӵ��O���[�s�eo1��h`F��S,��k�S3��j�G�8� ��@u�0���h���}9&	�uJt��(��X&͹�����z&��r֪τ�4����y��6�Z����5��H�>3P��~2�*�4�Vp2\�/�\����x�-Jo	F�h����x��?����U�m2P{��\�`�'0Ø�h�=ӄ��s\g�{��zSZ;�;uy������#�,W�hJcn�����bǬՎ($m{��è-|�FKV��xQ�3^�n&�"��i,�<To}c.�;_n]��Pp�3���N�9� ��B{_������R�UA%�j�5|c(.�� ��pSl����eL�:��f��V���g��)��J����M�?.h�Cϼ���=�@���i֕�c`	){q~>fZ����U�8���@�f0�4�Ќ�	(�5�A��:c|c�k��Kr��PR��#��*��@�gueU'M���˹�N�V[
u�W�����l
E
�i�b��)�Ud�P��hϙ@���Eߝ��U\�+�P�\�2�[-?��V36+����u9>Ye���{�Uи�fڈ��A|�,ϔ�qy^x�R��A<(5MAQӬ@��sM��Kx��\�P�	����r��	hd��p%�i�tW s8*�6��S�����3�E��|��j�><����6H�u�;Q�*V�����]�6㔻�ח���,8ٵ��5�y��Zڋ����܉��_Ӯcj��	�)T���]lk��f��!M�����^������
����0�M3��W�!��Z�.k��e���lJ�D��"ë���#����f{;������J-ۄ]���Ѥk&����`����~v˴��PG5��+�����@"�8=	S
q���f�楎�o��X+��C4bn�C]���h9�p���&�]���x�s�m-�����?�k1X��芜?ړ�G�-\Ϗ�����?�o5� ��f�8���:� ��`�ϡT��Rߊ��?�~�S=���݃�X��e�	h�<8`�o��l���'<��g�O�a�=����Dh�c$h �lA����x΅�[l�V�~G�x�%�Lݷ{�����nWx8-�ӂ]U�Ƅ��nfx[e�Bw$(K0G/$���ボ�4�ASW�v�-��o]���E��oG�F3X���9�4�s]l��Ծh�}�&vV��O��+�F���Y����@�C�`��,���? �M'�C5
����xĻ3�e2��� 8v�p10�b3N%�%?�,�B����
�����j�	P׍�߈p�����٦n�`oGLg�� ���o�G}�g���Ki�.\�N�������-*��X�uP��F���|S�+����O�������.e|��<�� ����>��o�Ho�l�}�4�����p�0vD^���զB�������t}�L��U6��|�jvr�������kc "⠚� a톣���%]��:D7�Da���|vc8��1r"��'Pa�e2�M�	O��ELṓ�/t���i��8���"\8x��!�1U� h�����tt�Kϋ�R$BD���B���;��~	^�xf'ƙ���܀u��m����a��N��Ŵt�.r7$}"Vp��*�QD��,8�r�� 15"�j������D9`�)/ӈ���B��ڧTQ�����v��zDn���Rc��L&8�Pb���잞�=yt�~������M{�gecOY�m�H:�\źY���
�5����S�n��Qb��<?j�f�:�̤h��C�_��_����L�������և_ ��"�n<���_�/�n2������䘙�$��D����O��49O�֌v�$�1�����_�-��b��Y�70�	��bL�uơM-=j�� θ��nȑ/���X���(QnY_Y?1��K����X�O�	5�^By�O��	(���M��q��6��8Z�,�W/WWC_2��g��A=uֆ�dB����]�����e�d�v�J�`�`SI{��g�тeI��!�
��asD�8V<{���]��nO����Y����	�:dZE(���~�X1�<ǟ�����pr�+ן>��ڍ��������g���c>�6�����G�������������������'��=����kssm����������<e����y>��T;/Y
)�x�i���>�w��o�J����W����q���`�쇷�>x�Y�<gi��&I��)�����7��'{�O���R�����������@86�ܻ1KD��JH�@i�����e���:��G��gu��eֳ���6҉.Ps k�)&��>{|x���T�'�k�{NL��q�nw���G�&�T-��qcw>t�� �`���US�>c����/欸
Q�T�P+sJ� ����1�җ�O0nԧ��.�ܕ���i�|�q �̅�su� ��F�1�����tdM��,+��Eڂj�m�MY$��GW��d��/�;����[���h�`�h:�]4\)*&	��R4�`�W}Pm=S[k�p-��Ntmɨ��4ّDS�c�I�K��)Bg(�y"e�sq^sR�5�PМ����c�c1D��(�`3��������{9��-���)�h�t�@
5�u�O����W���o�,��p����\}��+�>>|������������7���G�ON�>�{��Ǒ���OQCϵH���M��$s,>LR�=�]�.�5��jwuS�H.v������8�����Op?�f<23�U��k6��X����������jfJ����֦����Mm�?�ѓ������,���D6���o*׳�.��1�K�B�EC5L���g6h_3d 1K���>���A�f�q�ͳxZ���6`wB]���m�ӷd��K���Ҷ6��54!Й��<�<���- �!��c2`wҔ�sTlԿT#�*@��w����z�B����hDǊ	�[���q�\睙��~/Ȥ�~&Ϳy�5ģA�����Lkk��һE����C�ɔ�I�E>�IlJ^�}J�Z��/O��\��V)�,�i����Xc��Zc3��Զ�F��	�<w��f����@��E:	�eK��.�����ASn[+t��iǅ��Z�[�\ه`ҿ�yW���_��ä���;�F��n���ݮ<,L��z׏0���,��-e�>ѳaK�Ӿ2���y~��Y��]��QE�����*[�Z,J�Z�N1��OMo��t��2g��b?�¾�n�:�j9>7ѽ~����X�`
���1��q�b�FAp��gѠ�`]w{�1Dq����CIט����>�z�jm[ˁ߸�lX�l�Q�6@�7VLC�{��h3O\�Ucc�_v��8��Vt���LZI{�P�Y�=`5V�:1�3�h�S��MӼ���1����v"�y���idn��[x�݈��{ҔȄ_RlF�h�'�xOp���+�c�'1�!<ٷr$dӌ`����j2膨��\�ӔD֟�P��<%����H46c�vb�W{� �v��������Y�����XWc��S�,ꐷ�-��3N�����hwO	)��|���=	��"�M��>������Q���~AP���g��zn�h��K��dt0X�@BmyА�����f�bq��7�9z���dJ�ܤ�(y��Iic=��3u�ʪ;K?�����v�]3UB.Z1	��hs�b�q�p�6���Ʒ~SN�D4gs�Yc9�K���������A���*�����QX�7Fp�^i�d+���>��˕??�\=\�ڢ����$bHe����}4�T6��D����6N3�5��oX>���s6�����)Zw�U��-`����1��`�/P �R�5��h� O/�1$�g�v�0L�B&BP=̥o4��|O���Y>�)y���Y�^(;��3�������b´���qA��+�ƺiOWwݯb��@5��d���  ����i���J����d���a��|P?�.��a���2�_.���49&G���\kW�+_����.��9X�^[t#���J���+���3 �x����&�n_�=n���!�פ�x��xt�
��h��ke<�nF�Y��۽��ߙ+lRQh���ˆ�n���?Q3A��)D�Uv�:Zwy9m��8�í��Sؔ�_a��1����aտ�7ΔK3c�$�}H�- ������]+K`��\����h���b��"�7��Xl�_�f~���j�z?r�ϟ�9�a��@�M��ҠU�?gw�C.;JZ-Pg��J��M�p��zN�f���2e:�2��Kp���,��Q�p�,o��8G���6�J�+LV����=	�ASˤ�ط��I��/����B��x+�	5K��̆|�@���h��*����F3Y?c��DK��V!ޝ��Y�rT}��ӈ#a��B׈	b����#\����kt����' ���,NK1�,G��u<��&���r��I���4��$� ��e�[x�7yu�N��CC ��G��"���9�$�i@��_������'$��U�W�ҋ�Z����zҭ#����c�p ��0�u���D���ĝ���;�ѭ����R��1&ד���'������,��sB���)��3�ޖ@`��Z�e��� k�p/�������h�8/[d�=m(�Au��'zuC��Q�=�8������]��c�㯕pho�?�}��(~���GY<�]�bn���N�)���{��-����ح�`�`�����-ݚ�)�Ԩ������2Ȝ�<�b/��B
������X[� ���#h��%���A�T���Ƞ�z��V���/���,��%>ˬ7K����W��K-�'��ʤ����3ܘ)k]GN:�u��W�������N�`�]yr�M��ЦbvE�ۛ����L���눛�ji��#N�\�R��ŵ0�����oQ�?-X��roI�w%2������[���C����l2ڑnjz��h͟2�'���-���}lu�>���I�­��ã��'?�~��\'��S>�����������-���L<h"Y����A'�g�U8��m�]�q_�~�f��}ֺ���c�q�e�����B����[�:je�7�����"�N:����k��H��1�.1����(�NZ�F'��{0�_]�7���y�OQ��ـ3����Z���F���lxku=[o�A땷���JժoY�r�46-.�t�2,�T�Y�^_�1��&��>Th���XJ"晈����̢�8�ȼ?{�St����r�_�%zjh��c�0w1��Pw�E���`�h�u��x}����Z��[�x�v��d��̇E"�?��Q���tC��6���e��"�ok��%��&�Cc�����R<�ߐ��`���؎
c���g��믡��z&�����ыax҂�0γ ,n'�f�31��m��2�V�J�7⹕4��U�1�������H�YQ��cf���nj�y�ED}zF������?�� i��0���ap������|����=[��߿�����n�տx��+����ߟ����`�Η_<�����d��O���`�A��x��Û��S����F�@��Y�[-���(�N�|��j4�L�5��V��R�w�u`R�_ր�Nɽ�b�x���{��KEjo]��/aj��|�/y˅����i<���f��%Q�Ȋӻ��7N�b��4������*�� L9�/8�D�j�j�ZB�0QC`R���M�3/�GSU�=��ކ��6�B���o�Μ��L(�Op܈�8m���6b�=>b^�������¸,}���ȏb��W��QQCr'��I��\�Ƭ؆�A�J>!���J�����I�pO�6w���"���B�TT��-�ũuT���x��]��.���u���w��LEx3vZ:�����wˊ�:כ��K&���.�����̱|o��K���V7�������(���Op�fӿ���K,�摠��F�~�Ý����6�^1�)�+��8�a������7�(��$i�N�is�,I��rX0���f��/���Jd�cb��?�\��Y(�#���fI�%�.B&M��~!�
�|�E�7	�o�����o�;����X���Ku0��p~m����{��I&h淗������D�HU�k�c1c�d^��*���@ ��缒�nS���4p�t�ƕ��������0FX�:˕|ϕ�B_Z_�#��V�R*P/��NuhJ$If�׎�Z-E�,B�x�m����@�1�%d�� �L�rC��M)je��R4B�"ƛ���cx����I��5�R"�	�>���)$�L��T<1�$���	�7�7�D��J��"�?�@[Hi0����,��+��	������,�J�F`sK��0�D�`���&����Hy��?�cYH���L:^�QVi*��r��e�����f�>����6�Y� !�؆�/���(6Cv�sa�����zn>ݲ���J�(Έm-k�`�΁ꅒ�T�Lm��Ȧ+��a�hP71�>޵���}�4��Q��6/�Kh�*v���xMp�M������t�W���-H��~AS����V4���-P7�ʷ�-l)���8r/��Ċ��jte���SW�O6�e�G��v��B/�*���\��\gԼg5�9�s���;�3kd��<b�n� *���J��T�6�y�� ��ܓ<t��G��E��M�Q�a�:�3�S�-��H���wr{�;�����ᆧs�p?�w[�߹%}�(���v�2�dU4����t���4���s���d�$w�5l���0����GvkfQv+��޲q���1�Ou���;�����yeB��c9���ʞ!�!�25TU�į����������A��i���L�TN�ͦ!�%���ɡyT"/�s��������}��r��L�-�B��k���?�>����$���_��:�}<9pm����ܻ��������ܹs�����sW��G�c������{���������׿7��m���~�>=ܻw����{7���w����������S��qg��M��'�%����_~��F�������v�i��ޝ����������)~�鸍�{+1��L�ss�o ℱx��z�5�jew�D�}�ϲ��b��� E�iM��Af����.�}��s�( �74t���)�F��t�N�a.���6�n�u�ɩ6���T3����v�W����R929��e$��!A,ѹ��~�i�H������ �_=����D$��#y�b�D`�gEO�E��),𛹹k&Ğ��Y�箕�zn�!����ȸ|��ilt����8�Q��_��O ��5��%��'�� 4�HZ�hů� ��@ح�΅U�&K&]\� �@�� ���rgp:Q5��8e��P�T>q���Qgb:�A�jq��.����vKB{�ia9�fM+\7{�hd��Y���-��;�}N0�M���]&�ڠk1Xƛ�m�K��$-�Av��c�Q�߾=��~jN���^M[Xj�JAj)]ӡ7��۷ź��&� �4iKŐ�eR>�Jtx�)�N{ �74��$����+"l��#w޾-`\
d��������4��s��|{���b��P����M���S=�UoF�������'Uލ�6f���Y�xK{��v)N5R2�SԞM
l� �&q>�� �Nes�=$- �m�ld�V�¸�Y�*��U�1���A���S����4�k���s72Y�d�,����?O=��K��\��9��*L�׼��%��e&i��qoq���H&�c޽�)y��$�ˀ9M.�0E�\:/H=��Ų��%S��M�c77�s��3�k3�C�-��m�&��怸�v�z�2���^�w�h�4�C�F&�Y~�R���*V*��J!�!9rgz?�V���������*�4�����	�@��{sѥ}���D���^*��_�r�t�5K��6�&K�P��X���������_���C����e�}*E؂�G���b���7���
��3��K"U�o\Eɦl�Yi=+���Qg(�+OW���)�"NK�e@��4�}P`e$,�;���&d�n�}Lmc$o���@F";l(��w�G�jr�����\�	K�b��Ѹ���͟�l���j8.�J����A��]������=���6�+��tLY�=�c-��[v9Ą�XU�9���s��!�S��"�$L�,�HA��:���E/�ȳ
��&=��"-�$x�b>�*N��y��5;�t	����X�Ϝ��vk�-�s�H5$}�6����
͛�ML?��>]���C���n1Tڔ:��4}���\ZI	$$�>��Ǩ�����s@B7�f�O�EWKtF�D��t�+c'WZ(�D�P'v�{j8#@D����iD�jx��a8P8�F^���+X�ឋ4�D�v������t7k����7^�TAu:Eո�c�R_������:��ҷJ2�6���q�3�`<\��\bq�t�� vL����D)C@��G�� ��_��[�Ӈ�1���lmvL��*��R%ή�h�Ip�A% "$䮨��7�V�3f8N�Ln�;����Z�X/��2�A�&��
�0+<F����K�Vd�?k�"�O��5�պ]9��ݖ��!L����I7��|���_��}q������?Z������v�����n�~�?����������������O�[�2�����X�����/�gV��q�������>|�z���)~v����Zk�^���=������?�n��O���~�?���&���������_�s��}�_��{f������g��������{��?\����n��?�O���\������jK�i]Bb�A�/օ+P�d��QG�c���lu���u�:�a2�Y>zѭ^��WP�t���Œ����Ϳ~��u޾5���j~~n�z@f����p$��ܷe�$��z�w/A@u[���l��U�-�:�a�F_NZ�J5�V��;Ԓ䯴?�V��~o�<�
�W�t�(kp	��{��~���3���ͻ�cNѽ|���u8 ��	@�%O5��~Mp-�7��{7��ߦC���3��0�l�W�.�����n�K�C�T{����":~���Y9(���@ù������x�R�/� ��vrpv�[-!�(R׀�Tq��BN7�8��A'E7��B�_C��J��-e���A3�(G��0)���/�"h���&�|$|roX�#�+�i��`H�����&�p��[�N$���
�{��,MsC�x��c��PR�\)I��������=Α�E��@,p�+�Gk�������b��o	D�tR�9T��SENpM��l��d%�+���5��fݢS�xa/ۄ�sRt.�+��m����p�^�c(]�*ő��
�!@jix�8�e�����a�NCo{K>�}�X�������HD�k��{t"���|U�� ŠQCrT��sp�����=C�H���/�S����쵪�y	�=ډ��מfP�{�ռ��w���J��n�&���:*Ί�!P���P��et��Y�7?�fXN�/[�CyZb/�Uޫ��e��;Vrk G���g?5�?�	P�*:7�z�W{���v���X����5�eܜ�č,	��RkYɜNo�&��c�#�����e��Ž�`iF7��k� �	�i%��>(&�o;rM��AMEi�1�/j�JlC�ě6�zZ��~���.�Q�(��5&o�ͦݮ+��;�J�����;ԫp�h��O助��� �o������ted��������� f��A��5����h�>����忊�+)�c�PBbՀY��&-\!Vc��^�Zw3���J�.�/��EK�b�ʇ٧�X�EJ�V+���^�J���W�6Hkv9����fբ�����jzH���@FA.���g����:3���x��`�o���w�մ m�݉?�^�������38�v�>2�~<��q�i��ڽ�0��M�L~�λ��x�񦢍�~���Ȉ�H��\��A󆮢�l������S=k�sf�I���7})�#���א��2�*O��*;w��?��V����*IgG�a�A��ۧ��	Q�<�چ���\��G����GZ�P�"�5F���(揄�쬆lx�_t�a�[��1����N�4���!�C1ܲbXJ���rl��$��m9�T���iE*���*��B7m��RA�d�uy̛��L[�d��.0~�F�VE�Q���~M�����#����]������e~�3�e�ɼE�F.<=.�`�p�0������ �/PV��3�4��&��gNs�j�b9��j�waڣ�֜�����	�ξAyU�Mk�ǚ��k�9M��d��.��1�cM��5�Dc��v]��^�tYD�@.�Xj�3�\�;�;����w��
b�e�*���v-���	��'v`��i!?�nC�d�QFr�gYY�y7��H��6ȤS���,�t��Qn�yFYFD��n�߼&�E\xek(��M�q:�Va+��(6�c#8ȶSp�A��A1����>=���ꈘ4	�`�-jhOǴ��&�hQ,C�S��oH�t�`@��(a��V.;m�[��xD/��<�ӥ�W����S��
������"=��D���B`��JLm��Њ6P��9��԰�ʿ����Q1�j@�/i�0F~�8Ćh#�@њN�.��e��Ң_e���c0-Nm�y���gyq5&u�Q�Il\ ��"���2�QH�T鎲Tq������S�,+��i9^a;٨)�v2T�]�s܁H_�']��'����R+�:�!��7��,w!l��(�<�U*#��Y��������A�S��I�6ŧ��PP����ӥ�� �,�ij����yB��������,�a�S�@Z�����!QZ�� �e¾Ǒ�-䲠�� È����}��R04�	�]!��؞�o�Q��hO��K�Db�u��Ms<8Y�m(�R���*}c���J�@T�m��6��I$)iR��'x
�4��l�,<����z�����Vf;<l��;ͫ�~B�kŰ�dO�P���R�g)��e�k-�����$u�F��n��ߞ�,��וJ��L�|��_�<士�[z�ܷ�v^���cP�h;�3r���h�i[�ԥkM�SA��,�I�\VOwW�~���6��W&t�Ps&�Ē������,�3&�=]4-���1�_ߦ��i� 2n�ޝ�6��3��#�I4m�ԏ�9��̎��J6��G)����\�c��kӓ��%� �h��iZ��rmy�m�����\�����4	�]�v�ۆ���c�!��a��J�Un'9�D6�����x|��3�Z���1����o2kϬ�u���L/R8[$�)�G馵�g��+�4�m�_��#X�R�c����κ��p#�/�)Tk����R&􋯧'8�c9���Q�?&~e�Eh���KOSK*j��-A�̤�3=���jйU>�1/���~ѹP+��Ӵi�#�����P2ew��I&��mOV�A����)|Gǎx�M�]{o'*�HT�mm�H�l�@v�uI��\N�Y#Ck�L.i�u��_�h<c���+J�����z���\�����-���yR4��7��q��3}�,���`�SJ9���K ����܂psӦ��}ۗ���u2�x��>6���Cw0Bd��E�D����)���S�Jg8�����;Aؤ|w�&b�0�Ι���r�r����;�p��3�6L��S�F��-y'��r؄t��1�s��n_���z	����q[ޜ  J���@ޥG�ܕ�5��)]���WU=��4�F�%�ͱ�M�) �~���SN��1�����v�=����9�k#�lJ��[2�On.�?��q!�z���y���<�Ƀjxԋ��J#�C�����&LZ�j{J��nEnE-L׳+薦l�I&gzE6S��^��o�u߀︪]g
���`�1�y?�|��z>��mv]0�5b�X�˔���u�uЈ� JJ}�y-����(C�^h$���>\�.I͝Ԓb�m��V�^H�h���CÕ�|��G<Uc���˴0�6/��F����$I���=R�1\�Fk�㛠�1Z]�jj�$	fO�n{���Y���kE��;Z-�D�g�PcJ�?_���A5c�W}U�P�{���s.�I�A� ^x��:J~�&��������+�3i+�)rM+��g䆕[�+[�Kw����O�����M��IR�~
���^áE�t��T���5�S�{��շΞ���Ǵ:�`��������dvXq{	tv���'=}��b�+߭�y���`�����pR<F^�-Y�m䒶h��̤�`Ͽ������6�*�1o)+,�������ޠ��=t+T��i�yVd'#~]��j���j3�Nᖏ=��j�3e�ϳ��Tӂ��_g#���o�z���hq��8��f8�/�X궰�#�-��aی��7���/.��m�m���>U���h�S�ıS����eݹL��T��E��9=zga������!�٘�5$������]��4��I"gN�N�J��,D?[�\�{y4�ѮW�y}�a?�ʠI"^r����_���wV#<�Zh�UM��j�;�Bb���p�~�`�Qg(_vz2Di���d���XL�J�\ZT���g��_@�:�֫4c'@nǈ�[k��q�Dֱ���ΐa�fZ;�d��Gۚyd�脙MU'#�0�:�5ʇ�:.��4�`6��F����M�"�	ͨ�=�Vtc��`��yl��Y�8=br�FV�$Ք9 ��ZG-	E>������@�5�嗾j��*�n`Q�e{,,���x;hsP�ŭZ'��E�fg�_G�S&�[��ωJ���6� hu�[a/��Z�=���b�����'c*	�M�g���]�I�ڴ^�\��b�$�\���%�B�f��=�[Sqr����'�� �B!5TH����!�e�Z���&�B�E�3^�k��PZ�S4����3*3E��U.�k�mt�LO0(=U��x=��M��c��}S;-��0s:��ב
��S|���e��V�URkR_+N�hՓt��IT�#�gOB6�U\�ͺsa\��wt!�,�,Sz&*�/�c��+M�j���x��#S�ǋ9sΕ�^>ʞ���i��}6"�|�Lۋ�1��bk�6}�i[�%UpB���ЮU��Q�p[�7�6фcp3�;��z��!�L�����y�Ɛ4��WU��B�����u����E��.Nǡ��~�d��8��gd�b8�$S(��aa }�R�h���L�A$5�/k��pc�k+ER�VM�$@�ψր�:�����m��8Cm��I^�y�XI��p����ä��K�\�Ҝ�4���7�~o|��h�'�E�?��������?U��7�_��w�����5�~09p}����wo�??�/���v���/�����������>\{x�����Û��S����i��Fh�����94ő}/��ǅ����ӂ��y�ݰ?�a*wq������h���K�Bꎪ��$㸩�ϡ�$#��kH����ࢫ3����9#_B��>.���ТpT.�٠N����'�!j�6��w���x����W�~��U�^-�}DT�c�؎f�8@c�`i��O��i�����Ã�JH�ͼ��|TMh�5��pb���<3�[����8T$2 �� ���$�K�������'?���&�p5��'u���l�kT�:S��������^��E��_)ʏ��+��	^��8�����SAc����w%Aj +� �����^)��8���Od�yr�:����~���䓀Pb��a5����.N'�^����������jĐ�^L�@���Zˆ�(?���h��t[}q%���TU��%e�J1�?��|�%߳�٠���Ho�MU!�T|�\��ɴ�@��{�^�4z쾿��D�PͼqV¦K��Wk��h�%&�����3��m9i��5�'�u�O�L��X����dƿ&�� /1��Y���f�X�04�₺�T�8�ZB�*�����ϔD�Qy~16�DM`~d���&�8f�X��!��U�>u��m��7H��5�I_�Q�|[-�%mh\_�|��A�@5�1NF����lS���H&UP-��\U�������7����E۵����2�)�,;��X�^Nyي=^�5����rS�&�ǌϏ�`s@�m��e�M[�YW�J��WKF��� P�_|��8	e�L�Ḇ`�mh���I_jY�j�9�d���jf"c����+?ΐA����3�/x�;�l){V��?�;M��Zb��+��s'����� TyhY�j�h��bK����j͆���P�0c��?��"��&�ɳ�����:����?�<�o��.[����E�&�wc�����V�a�-觉V|"��N쏖�.�򯊗�Dڄ���7�5�����n�$gB�~�i�ʇ��n}���$���2&��&BG_����-�"���'VX�\T/��^��O{�!��Щl�@�D�3n�V�m5�X���=��:���*[`��ښ;Ԑ���؁��p��r��Ha^�%��6�qn���\�=H���F�.�a�p"��E[;c�olt������Kv���p�#_g�m�,ọ[a ������(?�45��xسՠ%w���4�P��>�QciԺ��)@Ѻ��RQ��W��GG�E���)�Ei�+֠�0M�r����+��U��]P;�_ХπM ���@������%�J@��%��m����hT��H}����C�,L�u�}��� �ף7C��];L�uvZVt��Oת�Hұ��~�2�Ű�{r�F����B����C��D%i�d6Cd�,�����
}�ٟ�iҽEG�w�[���>2f�u��Im�ܤw�X�N4�u�5F�`���}�E�K�)8E(���z���&1�<����<`�}d�Mtý����=�u��^��͹L��{4��=ܻ��Zy� ��!N� ���bp�e�.���>v��g�xZ�|8��9�	p��nvI�ˊ�1�6p�e�RTϵ��K�VU��G�5�g�qY@G���K6uVr�q�j�BW�?��x�ml�������Xg5�Zkό�D���P����'��-4K��D/i8@]�5%������-��qRM:�G`�[�+�h�_��:K|��o�B
�o�*?N��+Ρ�L�5�߹�c��6������prg�A;�E٫�jxaUgGqh*9!8�Wmۜw� �ddv�Z��y�?�p��qM�.�M��Qv�'76���������2� ��X�AٔҌ�0�ʺ3�D�n13��(�0��v�m�I>�A��L�;���3�����!P�%<��^����RS�H�q��Q�|�>�^w���T.d������������$.d|n�&�-gYi&����Z����"�	},(��+z}��x��.̡W�II�O�ӕ�b0��/^Q1����t��J�l���gs'5r
AR����z�].�x�
��âC�4˂BHkR���N��G�KiÊa��U۽����Ƃb�ڷ�Ա���b����[�K��i��9
Ω^���Rزm�Z�Z���}����䘕�%C�,Y�I�਋�V��D��3i%]�0������ �ߍ7�W����K)�9��I�_z�6�#t(se'�F��ͪbTx�Յ:/K�١G�je�#������^ø���S�F��"�FlfOG�>�Ut�_g�G�B�U�GM����qҥ5n����$��@�������d]�_�@����1p��ܔ�Er'��/;��z*�U�T7��������\+��rU��y1���V^ד��~�Ϊ�����E�%���?��[60mB�":�����Ά�y׀ �K"dv��r�f;�0�L�׳��å�:E�V�s���w�Wm��Ig��7����W+�O��% �� ��^�Ptk�5��ޥ<�9>ø:����D�Q-#�d�8�TS7�@sE�t��n�G�����(G3-�[OU+\�� �+Yڿ&¾ar���~��~��[����KJ�nK2ms&�vn��
�IdG-נi����Kܱ@M"�w&�z6ӗV���_m(��NmV>A,a|r淎vOv�6�d�;[�ǻ�p���X�u�P,�//E��,a�e��-^Wz�3(��;/�J�����\?���X��G�@��wt�}n~_��l,��v�v{5�f<u" ��C�-����ʄ��
x���N�$�0K�(��޷�ؽ$	�LH���$�>� 5-�fR��� ���ƼM����5eWn��eBA� �l_^�5�h��A��z%���kG��-��g�E���V~����Ř̼���u�EJ��@�3L���>��"�8���8b��RKh��G�Q��
?�.Y}�BWYm��	έ�~�a>�i@�~ �1���X}�N޴��xޥPy�n���ӦŜo��ӕ�`�7W��UL};.����p�j���S�vS^�鳃���N;#��V��U�Ev
N��5�4�7�Wʯ��9rx�/��,B�o�r�a�,�oc�� �&|���{�4Q�5՚�]�綾C~Zג�|�4hd�����fa;:�}��-�F_��qAmv�jh@|���kxa��TR�@���N��@��G\�n��$ȥ}M���[�&e�6�w�8 ���WHm�7�8��#��u]G��sx���e���"��ĵ��/]l�������K���=<.�H��:�:~P&��A�Agt5�kͅy�'袈��8�"��O(�����M���eį��:��i$u�bf�m����S����)��Q�U2����=�M�ës�>ʺO���T��4Q��6��b��-zy��wMhW�����-��8�B.rN1,;և���.{��E�!e����<�h��He�1��=tC�TX��˼�L�@��&����c72�=X�31�����Y;Z&gEs��;��}����ne�;�>�������nVɳF�@n�������-��1.9v]��U��nt1{yA����]�b_oǖ�ab��(�В^e�th"g+vw2�k�[,.��4�Q�g ��bNե�`�J�c�ܓ,�_�p�2B˙�^yVt�:=�fZ�-�JE`H��9[�<Ͷu����9��|�N�x��-������{}��7�FB� �6�Y��6_�=���ݔ+��(�6�D�f�/��b���F��t/z��<;��l�D���܄8�z�Z:��k(ֺ�0"�^��Rm�d|�V��%Yގ������x,�ٸp`�pM�$,9u�%8Tq��0�6vXS�c��d�F�!�Ħ�㓃��#%�v�v�v�O��v�h_�1	�½��MD�-�e�O`6G�����GmU).|k��Ez�i��j�d�"�"��8�4���3,�+)�S�� �an�la`s����j`IF�����؈Ocv-�E��X晓�����"ޑ�	��	e�ւ��X<�@���
r�+�5C�C��}�$
�f/A+��(�L�2uE;���.����˦�O��.��Z��(�a�r+Z��q~%��;�ȝ������Ro��;�$)�}�����8%Ɩ7Җ��N,��?͆��R��h3yPc�A,�;ʵ-������#|�e�Y�g��6w�������F�0��~E��`	�W�Y��#��9L%~�ˋbd@.et���8i���[ϋ�4�X(�Dw���ܹ(:/��[��^Լ���dGT�o<��w� �����:)l����|6�g�ãm�פ��v��7c<� �_U�7Z���d �y�a�|���N:�#�)�� t���0FI<6/��^ӭ: ���)xt�U�s��X-����3�h@�=�#~��!ڹ'	@��q��@�������qA��`#�Bq{<Ě�cR�T�Ƥad�5K���Q:��NQ��-$�zǂ��Y�t��U��S��ϑ�ss���bbH[�8�X�n H~�]��Q�����~�Lh�ޕ	m>�q��vG5��?~�B�k'�`	�u�j�x)���E��3�čU3e�3��I|����D��;T�yB�\.�����w�ou�
ܛ�����V�\�WE�D��7�GO0��7E�{��k�ȏ�u��u�c���ۍu_�3Ɋ�L���:�C�֌�3z!T���D��ýu�6y�WL�0u�h�!7D�4.ϔ���L7Al7��m
F��(�|:_cqͦ�0�|�5c����~	��IQ��� ��������zo�����'���?�����Ɂ����^��p�����E�W�yp��7�Ͽ��Y�+��i�֋���YS��������׿�����6ge��8O�{b�_?�����{7��'�����]�A��&������;k7�ߧ����k�<���������c������z����yx����L�!�B.��)@�W:�_�����i������1�~�s��|ʑ��� ��s8&$�]���S-����l��)�Q��#.,���{y�� # K�9�l��3N`���en.Ԫ�u��Bg�O��C�����q���spk�����F�s�fm����z�M��s��$H\�ߒ���68YE�')�%��� �I���7�pH��F����+��V�͚�Z1�ƏM�.���/;��n';xzr���a�W�P3 0�U5��N2؀{��2��z���Oq�¦���\z>Ԡk7eO��ȶE=�^:]�Ys.�p�n���	��4�/|G������U����Ʈ��+BK��5���j6�p�G��&gu���򫬞����p��	B����tPփ[c��f�}3I��&E�k��%��h�M��bt����)2��]X����HB"7mȭZJK�+!��s=�ʕ�	�y��2��]ڻe�x7['G6��}�~ ��'Q�N�9�ǝM�<��q K�,I3�N��%o�#Ȅc���#'���t���ɑCB�1�8&�`� HB+G�2��+�����KQ��R2�U�9|GN�<
|F1��@���g(M`��ucBɤ�����B�/Bэ�x�m���������Nۓ��D
��0�r3� �	Rա]�w���:h�t/.�w�l���c�jdU$���u��Mh�?�x��U�v@b��9:�w�7�lX�@/�ָ�uD)�>'1��NM�"`O�����(�!a���AE���}����+�i@vl�yF�i��r5Sݶp�êm��]��$6����]H��#\1�Q�+Х�C�A����7�4�� _rv������h�4t��AQF�~����3�C� ��#����!���[\	�97i'ǖ9)JU�G��CQE�ǐ�m����p��������@*���[�AW��J���U5���@����RV�;ˋ��jX.�Q5�-�D�'ݲZ��X�[��;���9PF\FM��aX������H��+?`y�#a�B��)� �r�y,�Y��t\H�n�H2J.;�/f3��f�u=��!���/��T.R���u�,��=L�qN5[�f6��~i��
D�X��^�r.%g�U��TLw����̺�M&͗����.�S4�4��"jj�mh@��e'5��Q����0�VN�������g�����g����n��#����}���4���E$]xp��6D;���#��c��y%��mf��Y�����Zrf��m����~'�Klkx�H��z�������o<Yώl�JLͺ"kM��tyg�.�RؒQ"!R��fmAv���)�S�<?��)5/:�������ʮvb��ʨ�f/�.7��Ք� 1J������vq[4�q�Ѓ��Æ�D��K��A�-Ens��P_U�1�u���5��p>z�5d�}��e^��!�O��y|1�g�_Pך�
G�Z�
2~�S�s��J����T`�a	�V*���Y�~dchI��d��+8�a.I�ͺ�B�qO�I�_�߄��!�Z?/J1.�1~��5[`�߿���:ίj%��[�y����97�ށ/� ���
%�!T}��M�G\��
v��bf*u�Nٸ�7�u�Eң�9�خa^�h��T4Ui�7��ȝ���FQ�J9��c�X����St8�^�]A8�~ S/>^���Ƣ�g��%N?Y
	 �;�[�26��
�*��S4.{ء�/Mx+�G�qe�8}}VF��
�D��EQq��.��{Ձ�}f5��t4�M�+�yE�pg�R��7!L�IJ�Q�c����,ҁ�(p�vfz���xT��iB��`t�d��y�m�<�g
�7(�Z�6�8%_��]8y�����[NL�t.�q��M�{�'�2b�6���Mn��/_|�G��.j�J=׫�w��dq�o*����,�r�xXwg�<�?0�:0��Ȱ���9C ���$�u�F
�G��^�!'�������J�������>+F���d�c1,k�S�S�-!�x_O�O?��/���&0YCv�m���1���Z��V���s>X�ת6��&�zn�^��ؖ�ۺ�9��KI�U�j�XmGW3wy��;[u�>��7^ٚ���c]�6���Y�Vy�U�~�όuv/�˿��+_C�7?��lWR���	BR���M����jݘ��Yؘ�l�]���Ŀ�y�T���{�������W����7U�6l�>�d����ϫ��,��>�=x^�׽�r�2l�,x�Z�Y<�b�͇���}��'�\�~�j�w=wW0����m�oqt6��}��*�Ե�����܌�(��^��W�T�22(J���wb���wv(�"_�'�L�~�*� ̳g�����m��{�Mfs�}�q}o����W��}~�޴���=�h��p�2��v���\�,�4�W:��|�_l�Fh�ol�@ޜ3���]�G����}�oQ�/�ꬉ:��݁�m�#D��N�#T�ntٍ{�{yDu�^���aw���.�q�=�z��J}�榒~���g_������v�_nlo���{������Q�K=�G�v�m��^n5��iz����c�r��֪��[���΃/���'M/����w��������Jg�	��r���M����
<k,�Φv���{�d�ޑυC��w�k(��Q�=���	������vG��M�} #B�U����>ݵ��$Jf4��Ż�9w��e`���8�3&�+CV�	���g�Հ�|6��M'Kr�K{h!�!�^Q��qВc�,��K������`�n�x�M��n���� a�B�ӣ�
����+�������V< �G%�xHfȊ��XC�՞f���㺆(7L�e�]�����L^%��~�!$��לÉ�����<��S��i�<Vd����/���(����f�v�+���t�pb�Ղ�}�;ct8_�pt8��oX�\�j��X�[�>���bo4����!	غ�4�C0}�6Շ�(��g���):-�ڧt4w��4m�'>��j��\u)Y
7��_=��c���.�\���$�sH ���y���{kn�?>��&��W�k���`r����0��&������������/n�?� ��������{���_������◈��q��� �c��i}ys�VT/��!�[N�F��s"C�1���tdJ�J&��J��p1�J�AJ�Y��zS.@�@K���D��1�Z۴��$�(ؗΔ�{y7�+�U����675��5`��~c�w�%g��7�CU;�������ug�nY�u������~�mU�xT �c���t��@�W�}-���`R�H���6X�~k:��9H9�¦���<�w�Q	�%��~���ʾ��E�����m�S!��Ő["1�_e�u��8�����r�[�$G^�"�{�Jb��_��"0�~���!0�^U�@���o���C4ݷ��W�;�{�e��_
�uY���+J�C^Crw�3��Ni������k���gm���8<t��Cʋz;�����?v*o�����r�˫�''����{���6�$�%����q�H�����g;���: �+���E��5�P��øU�j{�.�H�ի��sq1�g��dp�nS�P���a��:4L/7-f#a�z�ٔ���Ɣ�ƇG��Hv]�d��pc"�C2_k�gbD��Lñ�w]-ҷ�k�Nt�iGu��U�ָji�����k�N'�Q�&{vp�ͣ'ϲͣ����֜��Ef���d\����,��x2�S���(���t���}f�腔Fx��"�!��	IܽEf���s!ڝ0�*��ौA)@hpմ#��.���"�XV\潉+/�-�l�hT�5���ǣ�)u9;����V��>XV�
"!�����i0�@tC~�B�f�5IA������8{�T����З�(�_�1le����^dC���e$�+�*����2����T�Ѡ��^_af�DЄt;;U��\���ERXT�i���s�F/G�ݡ���Pwv�~��	@r�Ѭ�G�`t6�����!�9��t�t-�2[FJX���;{��G36���?Ũ��H8!Z������<���G�$@�[��� ��i�f��$���W���dJZ���`�6f�Ev���ngݥ���ٸ+��hG�P(�3��xl5W�!_F˵8;Q�|t�ͨ|�=3E����{k2�ӍÀ�}X�����xD�_�U�a2ކo��V>閶q�%cj�¤��#pH5�[��cc|�lDo9�Tod���������7"U���� �R�l/'mu4ɻ�|8�f\�H���C���}]�����Ͳ�m���l`K6���2�m��"���׳�~�F�whgR3츽�"�p��^����
k�l�}�8�7n����jd��\����wI*Б����z&���?Lz�t�(x�RS_H~nzrw..����g$2�gޣgc+,��Q����aZ��x��΋qׂ�ۜU9��WuZa�=�`�����U�Dv�#��� ޖu�"�WJ�⤌��<��>yk�:��;ط������i����a/��a�T	 �zg_����Q��u�H�P�����H�f�����5Ӣdl�iW	�Vz�]��	o>��Q0�+v(?B`t���k�LBMۏJMj}���;8;d4G���f�?'�`+����r�Y�[�ۜb.JM8̓�aq��(��?huf������c�񣚳�)����6z���g[\�h�&��0�>�aM�<4ݲ�p����ź~�&�����G��%I���-tئ�I��P��W��r'R{��5�ea�p7�� ��zR�Xiw��X��a��h�+[�6�ָ�z.��7x��
NlR$b/��*���I���}�w�h(��D"�~
��T���]e��|ø����1f��Hxp��F���]jt��N5��O����{����^v
�,�ь1�J%Ya���d�Pbo��{K&]�e�SH�3�l:S��mڌ~ךv��|�z��G3�?�-�@�i8��A�����l���L��	&�o��r���%����b�p�����w#J�
_�Р��w�@��dB�uJ�S�H�8�?Z�d�GR�α� ��&�@m�U���	���9^Ǚ������H���M8��"G ���G	�.�K9����#b��c����aC�¬�y�緈!.֫?ޭ^.�W:�����.�al���IŲ��*Hqڮ�U�S���1ۥ���Z��J��=��0U��
�b2���Z4>bph"v�����3ʕi�V�;إ�+��k�6V)Et����,|3�U�>pb�7X7p�^#���V�h��QO���Z�#���P�=���Yw�h�8����x�hhx����,hU��J%^5�#�pxW��d9MEr[��r��H�'�fP����Y�(�'���逾��,��CYpr}�m�g�<w�s6�m7�N�����(>UU���*��8wOp�j�vʦl06���)r�u�X[M��,®���gQ���WD���ց�=�c�v<T��:�0+8��v��0ɻ~��;%UT��Q�8b~����V�ޜ�4�ȑ�0
�CkI܀�x��c坋:���i�E���Z
��w⠡�)qv-oƍx��0*���������)�u�yH�75���Ј�GN���5	Ǻ��A���t.���}�	֎#y]�(-��6��?i`�$�TFM-�M���g��R'ݍF)��S�Id��|h"͘<��g��R[��S�2��S! }'j��Z7���[4O8!ɖi����W{eD@C.�d�Uq7W��`x%�!z�c�eke�Jk}��Č��'�<�p�i�x��ߛ��!m��S��c���f��D��b�f�q�3�� ���7)����e�Y��vw#�����z�Ob!c������-�P`�Ei�=A�Dh3�}�<�t%���=@|z���#%8���r�6b�ۛl��Y��ӈ==��7;�[A6���<��o`"T��b���d���K�T�gũp|�=~���Fy����{	�����ł�x�� ��]S�Y�tUi����|G\ޙ[�xz��O+3vC�WO�¶	�j�9�i�	Mg�!��Txl��c��*m�~�����m��Ѡġ�n&��� �0�5>o�݃xʾ}�Gk��F�8N�wJ�/~�-�0O�Q�X�
$����3LW�y# Ц����������\K`'�Ք=3� �
w������˳&���&@�FX��&��o�^�7!��_�R�S���f����?��͛b٢ls�h�d@+{�6��~_����Z��ľĕ�u�N�#A�͈=�P��,Q�P�	���y��L�I�Q��PI�ٯG�! G��y%E4�������N�r@(��G�+h%|Aֳ�tT��?U��I2|x&o�`�h�'$��9"��{2T��#��=�k|vStI�e�'����7�c��mϹ�����j8A5�t��u�g��4¨���(����������t��	��J����Fi΄R(K�H������H���j�G��_'H�q���1���$�H`�4��X!�WNr�yQOg�Y���Wt�I?Y�@4Q>,i�r�j��cA�HU�	#��С=V#�U��N���-�F�5Ӧ5r}�*v@�����d�����`��H��3��+�Q����W��׆�T*�w��[�-Բ9��D���d��Wި�sb�SbKL������ %J*:ɘD�8M{�J���	���@����в�myA�>��[y<;�.�:q�S�8���C�or�%K�(��<D��/!��i��(4�\1��s�" 
3ɏ�)J��6zUq�z��������M��~����>e������! �~d�ps��A2,/DLL��Q�@S*b�r�:�]+�Y�c#�S�S���5�2^6�ȝ���������u%����)�$�h�b?��)\����<C4m�3��)�o��l�) {�wP{Qu������)�	��KP�.���ty.w�H���*�j!��R�����4�Na��}[T�=CEqmo5&(��$#����k!�r�'S=ӆ����������s<����U($>�m8�`�I��4�������mf��,��	Y@Q���At�u�?	��Q�cǣ���oXd�>am��H�R����:��_T�jr~ѻ� �)nbKr�w%%�ev ��w��uܻ�[kt�t���éop�{��[��F�W$>I��QA��^����E��l2�P̵O���r �ʈe��~��(.��m�	l�l�VB�H�l+zW�zȡn�taӒ�^�>��9�\cc�a	��s%�6�j�S��BSs>��d�N��hܦ���F�>&�W�s����O����U��??�����<���݇w���~��ڗ1�χ��>\]����������O[�w��y����՛��S���!�y�o��=K�u1��~r� �ȩ%"�L������/k'�v1�i,�&��>�-�$@˃I��d]�|.��)�~��VS�?��{����oK�/��
s���o3B~�] <s�g��W֭�S�����D��6��f�ai�.l�k�]87��S~'e]85H����8��(Bb�O�/?	h��h����-���¹$�.M1]�A�EK�l�@�2�(�ޗ`�n �Uޫ��j�X����T}:��ů\n9�mc)��Y/�����#>���7�:U��1~�����pvG@�ؾʱ�ꖗI)L� |!0��Ơ;�J��wE\[��c%��՝���"{"咾؊q��1 ����8T�\'ڐe7���7���a�6pD��v���@"��Z���_���"0�&���0vBM�q3ު/]q��m󖵂MEK�{u�s�P���Y~� �����]4:��Ym�g�jX��`���N]|&��a�p�-�7Dt3���o��wq�pF�����U�F��}���6�a$�W� ���\�P�s����E��5k;����N4bx�C��i�7֎r����e��ЛӉjC^�Р���xX�c�ʘ�|lp�F�(�x���O0������Yp���NE�	�ߕ( ���ݕ��+��t���u<�V�/}L��@�8�F�hg�[S��(�Q���	y�S��{�@����[��y)���ȃ'r�K�v�w9#7�d���nѪ��j�:��`�� n��d�d�Z�Ǩ Օ����hsf<��z�M-hM
������L>6زƴ���á�C�O�)���;f���"O���;������쌮�W
�$��l��}U=ǭ���)S�A��j0�Ler�g^��RKFg�ӹ���Z��l!��X/:ˑC���/�)���-4��:�YN����Tt��э�x���b�o�yif�N�����Ι����\t�u�h,��7�Ó��&�0���,; г��� dǻ�7)�Kd
�3ᙅ`�M^��dc�P��9�% a�&c�D�t�D@�#����0�j��m�h�ً�!�@�e"�/�Q���<�Z���P���mH'�4����T]��$�����0�����]q
��<��O&B��T�rN��4�OEila�s�A1�����.^m�a%7.����c\���jl"�D3�s���{�t�⮧�;�D��U�bx��zA�ĸ���&�+�L#`�5��`=�h��f�;�A�owC�ظ�9X��`�G�:���ԧ��8��uʴi���@K��c��0��L6$�Ny�4��tz
0q��D}M�;��/N���a�䝍#���j9�j��M,@������0���M�ejȪ4�H��o�AW�r$Fe��Y[���dbH�y�R�.��Ƌ��:;�[�rT�䌹O�U��\զ+�p��T���X_���6����	P
�_a�1�l�EaKR|�c{���6�x�X�]xK$�
G�+�
����|--���b�H0!՛��|���
�K|D�]��E�&{bGu�ȥȐHb��Qtŀ\���o�������.D�Du���&;x��gh��c��)�:��X��%�]�<i��p`:XH�,<čԄ��u�#��B�c�A�V!c��`7w1���z��ׅG9A�gԧW9��f�f�$���M�O� /�� /�^6��6����� ��E�^��m��ߞ@�.<��h��� ����O���=�ձJ]8�A�rksv�+��_��I�Δ:Z��d�	V�D�A�J��Q/��r�Ĵ�*Z���$����U���F����/�KH�y�%�n;����n�W��p�f�S��6WC}�>�fȱ@hSضG���99���=���A%V󽺽�� G�|��39I�,N�� �+�_��P�/>/;��1�b��K���ޘM65��13�f�L�PSm���rԦ�Wh�
'�E�ؘ_�s��
#�Ƃ�ո_A�bU�Q^�+�.�:�X�������y5X�K �g��8X�u"^�`�uņ��B�R�w��h�0�A]�6�κƓ��� 1�>Zt��p��x�9+F^��W�g���-ޟ٫I�k-!1�iH�@���Nj��ª�AY�_�:�]/C��'	mh�ңozl�_W��DΘZM�Mb���	��&�n΄vY�n]���X��1�׳�{	bER�_v���e!��,��ohd#٠��i�N'����D��{�����i��z�IRJ�w�X�5ݺ3r����Z-�����}�eo\	�{�s�&�����D��Rb���n�6w�s��b;�c�b�����������5N���X7<�\�[ڰ��	�]���׋"�wm�GZ5�=��.�����J�������}���u?��2��k�ݲ����ܛ��e��_Wm�q�@Q���+왔dgD��ߒ@ �_�& �0��H;= W����}���w�@p��	�	�E`�s���C6O�,�{���w[&��� o}��o:H7L�{���w&"��OM�lx��Oă��}@
o��@7��J����VRK���e�	Cw�୧u� f�~&��z�h��4��I�=�p�И)�Y��f�	b�E8��ܳ�~��M;QB17{�i�� C$j&���:*.�%2_�W��p �Є����;2�Vl�Ihn�b���7s��싕�;�����M�Y��>�r�m��@FJ�ʹ��J�8��������w����;R����$tRR�� �!F������t `	ve�A4%7�JE��%��mHMK^��{�����޹��i~7����_C���S���o�߻���M����ݽ���ŗ_<��� �/�����j����w��������'�%��\0�A ��cC>�u.� �~In��)䄴W5ܪ���AΔ����H�I���Z��Dù/9�ؘ)���ǳ%:���NDb�����3�^�Rs���3��� ^8�V�����	1�=���Dt:*�3�Dx�y��J�׊aL鎪Y@`Q ��̯�F��(aLr�;v<�'�Ӯ�搌C4�& <6�}Э;�Pq��?8�J���l��N�����F����w;��ӓç'�_����#�%���[5������s.�}=Cq'ͣ�{�����n��X�=��Ge�K�px�M g�!;Kve�w�hÄ�1M?7��/�-�j��5�}@��5;�j�4��d���򫬞���w����d������qRd�E&�Zt7��*�����:�_1bL]�dbK=���W:��8��>�:�[�c4��e<�͂�X�j[�-�,ޫ�X���r���pu���>u?[�����ٍͦx��G�8��B���¹Lrl��͉\"n-� ,�G\�`7�,0˒��ng��J[ሳ�"[�"�� ��3~n�wc����_{�����s�&2y��FE�%('�'��6���xR��;�n<@[%�ޏm�уS������ƅ�ݰ��GLy��'��M�[|�g��V��J�a��l/>?�]@Zf|+Ƃ�=�\�a��,���l΍$3	�/�n����3���q	��:&^dPQ���F	7aժAsa|�������Mƍ ���g-�l\��:\棲��>�:�^���k�}�!7��!@����x�>5g9ZRcT܃~mSr�[�ݵ��暆�4LN�#̝,�~���xy/�kA�L���=wm6.Ԯ�D�>	��o6�rJ��)[	^w��N��aNF.�:n�Z�G}r'5u�ۂ)(3�����RAtlB�)�ۑ�t�RV�;ˋ�������b��ђ�P����7�+����*�e	b�))a�_/r%�XH�
A�B�#cc¦]4���������t��w��O��9�aA���C]��uX�4��a��J�c���:\@O��z�=�ϩfK������"��[���aEZ�脻�dF���6��N>l��ULf��04���QR�w1�i����s�Fm��/t�bXvR��*���s��9��x�mS 7�������g����n��#�@xV_vAi_�jb�$��>�����Āel�`_Ygs�%g�V,_�}��♳�<
����ؼ��7t;C{həE_J�b��>-8�b������f�$h����d�`��:GT�9��a����qyg�d�l�U:uV��wj�ή2w�R�OI��t�����	<�C>�zh*�ї�7��^0�c�qSKl�������zЃ���P��X4���E�[IntID����=��?Q�����uC�|�Bk�j��|�Ļf������WX�d�K���6k��rlXe<��n4���9�3}f+\w1��X��vY��g��C[�'�|�Lp�f�9�*Zu�=9�'E~	����V2ǅ+�܏�\Ҡ��h"lW�"�;�U�2g�z���i��s�>S��S�pm6��6�+�������+�4�u��� 3S�H$��FٰA'H�Z?=z�C��f��گ�Y@[0[� Wq6��(�L�6(B���-�3�<�@/�F�gJ� &~���c��%s�1wY���.O�֠�́V�mv[�aj��e;�@[���!`TLf�=�K��X �}�Uo�P`���[tN��Dt���q]�Ň}��� �O����G�[��ST+�ZRz_^_p��!<*ɉ�vf6@��	��;/�q���T���ig-�/+ªc�`1v��`�)�-٬�w�����9$�°��R�b[�S�enS��2
<�foMu X/?w���h�:��8H�h-���b(l����#f�b!�Z��V��Ws ���.Ytc��E0���F����q���;T�!�`j|��bIǕ��+/.�E`�`x��kl�ӄ�j���S�D�Us*=~�����.հ��	Z����ˑ�UC���M�K8���|yo���3����]x5�G<7�?Ϛ�!;dۺ���;U���j갣��[�佣��(�c�`fk20�����`�0d�k�E�X�a/�3��������J
�%=AȯM����uc�&lc���n����7�=���7D���AQ����GM��<l�'޸������uԞf!$���u_ۋ�)@�x��6������C���>����}�O�?z5�㏞�k �p͎���1��
�ڪ�ԫ������O�������kDa�/?a��O`{�D A<�|362}��ѫ��0�e�����6~�=��߿>���`ĸ��Ux���>~o������E4���O��?�n66�W��~��CG��ϣ�!r��	��9)w������q�ïo�ꬉ:�e����Q����˰]Cv㞥�^Q�G�ſ�=pؓ�%{
�8lg�%ln6!��͂@}y�����f<�V�˝����^>6/7l�z/5$ʣ;;���^�4��!S�/?U}��s�r�b�8�E|��� )���:|z�f�����oSv����o6 �Բ�ca�a|Dr8����ژ-h�rO�J�W�qnl�� �C-�`56���q�%�y�j��<���<"EԾ�eV�rv�����x?x7�ǋb�n�x߁�W�2!��:��v��varz��=wBo���ţ2�V��Ό�պHZ-,,66���s\�0�hY���1 ����@�q\�6����g�������i_����4x+@�=y���w0�os�s�����e�T<w����5���|E����p�u��`�/M�#CC�l�Y���9���gC0�9�,43
ݺ�d6Iŵ�ٜx�(8�:���̥�)����f*_��*Ĥ�kw�`ҏ;fVWa^�����ؿH��M��b�O��{��ݛ��O���U��?��~��݇wWo�?�/�{��ջ�n�� �������߹��}�f���D�o�s:�ע���5>���ߎM�<7sԯ�}l�릭%Ȇ��= 2(��C>l��%t�Q�^DNXx��Yξ�኱��fT´��
i���<s2�ג*˫S��[y�k���ף�P��%�}�|��N���j:!����3����N�w����ո2w�"ٶLސ�;RS$��{�j2ƣ ��G�z�PP��.�-����e�dT/��8g�N��NC�j�j_���������e�����e"ܽ�/�(���Io\ُ�;0~;d��A�޿m����1p9��x!���G2|0__�,��"wV�ZR��\�+,��������5�ƕ�+G�!L2 7{�&�c	�c� ��Rd������\�&"���&c�|"���ܯ�^����{&H�+�b��/�������pK��0�'��#���W�IX��xm�?��x�/BFj�B�Eɥe���A��1�46Zg����uΌ�P��챧R��\+�ht���3� xC��J�W%�0�)i�"��v<ǿ����d�<��b�\�$������(�F��".a:�0Ј3���Q7i1��e��p�������V�DV�nqJY��
q�!����X;�i���^й��yWЇ&L�������Z&��g"���� ngW0��3nQ���޹���Dq�}?�[i˭jY���B[(P`Bi�m��6����\ϙ93��~�C왱�~9���j�0��5۾���;����@Kƈ�3ܤz��s���$}v�2y�Wt��x�^�����)P:B���d� �����f�^�2�SL8����3ɉC�-G�F�x=��u �qZ$Ac@�.�Es ;�9'���� ٱ�ux-��x\�TC��B\��3���<=%��UK`[���wG�G+*vv׌��qkf��CB���M<�0r
C]��2:�t���s|"k�ײ�x'N��ɜ�&��E2�{���)5�C2�Ľ��"	IE+G񖩛MoI�T�*�֫��o����G�N��4��NB�4_��N�|jZ?æ�.�M�_f�v�����|�7��e����NTf(қr�q6��һ9�� ���`�m��[�3$�7t���b�����K-e֜�%�l��29�MJ�_��lSI��l��k�Ni�i�o��Kf�
KC��n��ew"���¾�p �F
bEvY+����	��R%8[tv������ �y�Gm�C[�[��P�V�"�1�uBغ�"vB��4�m��U��f�*_㮲��v&+U��~��Ǘn_w��l��7����5/_�z-%�kv��l���	90뵯�Bu��w���m�(�0`���B����U^/aM�i낕�7��i=>'��$�J j��[LP�G�e�?+S}6��k?�%�F�Q�`�&�u5��h����>�#�iꄭx�D��96����*��Z&[A���M�R�rSG�iSl��Fkh�a���p#��lw�3��op��!�K<_[���t8P���^���ρ���H� ��,��1����[>޻2�`���}b��kخZ�3	9���aD�ak/�����R�Y�����uk���@%���^� �mn� T��c�-?�%�5�7#�Kmٗ�>�g����9H�}	H�y3ecz�L��:�0�	���{��O�Y`lo��!�LUR��!���b�����4]��.��(�=����.\ʊ=�����
n�K��{dg1�����!���6)'Npx�#ɝ;�.���k���[K)x�� l���qj������!!�C�ǑM`��Bv��j�h�|��u���u�\�'n s/�@<}ޑ*4��PB}��WtB��q���C������Bԝ�D#F���������j��_w�n�c�7c7�ŀ�(۽��1vs?�R�nv�Qк_	h���[O�$���,_�����z_q;w��W,R�JL0��0w�z��~1�9H�[HNr[zR������O� F�F¼�9���zMA-Ͳ�.%8��£2^�����:/�a�~�^Þ����#�4�B��0T�jH�x��}d�c�J��vi��E2r��|�g��3œ��ѓ\���%B���<�wy�6�8]�r�|��:���Ɖ�ZxN���r$�ExϱE˳�Vz�V����& ��~�r��ꯅ��H���%�^��,����Y��|# ���E�g�Z2����ĺÅO�y~�8���&��i,p�K����ϝ�Oְ�e�&��[˶�
�S�@�kXQ ����W}'��u;t�ϔ�WA�J�ܙ��*~�%䄮_W"P��0�W�RW���_e!�oNkE����e�^����2| 4!�/���ņ�����rxh#��8��:6�w�L���޺���n�#)�d�TבhSj�)]q��1���KK-�W������J��k���v�m���q��7��K�-�?�W���������o<�߫���_�U������@��wUJ ���+�p�KN�	��䛸���g|� r��	 �b�X�������*Ԯ@F�N6��g1���uen��P}*��2&%@U�' <���)'�Ygg�:%�'~&�l�.��eā+��:}ၢ
��>@jIEa��uh&͗A(�kS$ /д,A���	���ˡ��x��U[~���֓$o����ɀƄ�y�j#��?����(s@���A�u�j$j��+�Z�S�U=��C��y:��-PkA�V�J̗��C�Q4��@�3"��V�bO5&����\���l�%$v���
�n����=xQ�� }
Z:��r~c�K����\�-۴�ׂ���/���FD֥w���/�E��i4�ҍ5�ւ�Vk�˒*$�ZZ��뵋���V�
$�V���24g]��[���!Q��O�i�Q^���??-�~�*��@��C���i>�/��L����"�hmҥ)�}�^����i����9I	��3�+q3�@R��@M"x�[()AB��J�`U�K���Ta�N���̄?Q�Ck�֬
'Hē�N�r&Uz�Q��D��)"B�1J�G�Q��{V��ӓ�)H�V��U���Q��$����I�NE�,7]���O�X�����M���Y�9H����zdeU(z��j\�"fKR.����5i`P˜�{��a'�ɒ��&-I�qq��n��B�
�ߩ�TFϣ52NAZI���󫼑�GN&�>�z�G�����x5��4(��/���.ۋU&����B�s��tOGn�V߽G;��V���ګ��q��Ͷ �                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 