#!/bin/bash

# APPIQ Method - Terminal Integration Installer
# Installs global /appiq command for terminal use

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'

# Configuration
PROJECT_ROOT="$(pwd)"
APPIQ_DIR=".appiq"

echo -e "${CYAN}🔧 Installing APPIQ Method Terminal Integration...${NC}"

# Detect shell and home directory
detect_shell() {
    if [ -n "$ZSH_VERSION" ]; then
        echo "zsh"
    elif [ -n "$BASH_VERSION" ]; then
        echo "bash"
    else
        echo "unknown"
    fi
}

# Get shell config file
get_shell_config() {
    local shell_type=$(detect_shell)
    case $shell_type in
        "zsh")
            echo "$HOME/.zshrc"
            ;;
        "bash")
            if [ -f "$HOME/.bashrc" ]; then
                echo "$HOME/.bashrc"
            else
                echo "$HOME/.bash_profile"
            fi
            ;;
        *)
            echo "$HOME/.profile"
            ;;
    esac
}

# Create global appiq command script
echo -e "${BLUE}📝 Creating global /appiq command...${NC}"

# Create the main appiq script - use our improved version
cp "$(dirname "$0")/appiq-global.sh" "${APPIQ_DIR}/scripts/appiq-global" 2>/dev/null || cat > "${APPIQ_DIR}/scripts/appiq-global" << 'EOF'
#!/bin/bash

# APPIQ Method - Global Terminal Command
# Provides /appiq functionality in any terminal

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'

# Find project root with APPIQ installation
find_appiq_project() {
    local current_dir="$(pwd)"
    local search_dir="$current_dir"
    
    # Search up the directory tree for .appiq folder
    while [ "$search_dir" != "/" ]; do
        if [ -d "$search_dir/.appiq" ] && [ -f "$search_dir/.appiq/config/project.json" ]; then
            echo "$search_dir"
            return 0
        fi
        search_dir="$(dirname "$search_dir")"
    done
    
    return 1
}

# Interactive workflow launcher
launch_interactive_workflow() {
    local project_root="$1"
    
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════════════════════════════╗"
    echo "║                🚀 APPIQ METHOD - MOBILE DEVELOPMENT              ║"
    echo "║                                                                  ║"
    echo "║                    Interactive Workflow Launcher                ║"
    echo "╚══════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    echo -e "${BLUE}📍 Project: $(basename "$project_root")${NC}"
    echo ""
    
    # Step 1: Project Type Selection
    echo -e "${YELLOW}What type of mobile project are you working on?${NC}"
    echo ""
    echo "1. Greenfield - New mobile app development (Flutter or React Native)"
    echo "2. Brownfield - Enhancing existing mobile app"
    echo ""
    echo -n "Please respond with 1 or 2: "
    read -r project_type
    
    case $project_type in
        "1")
            project_type="greenfield"
            ;;
        "2") 
            project_type="brownfield"
            ;;
        *)
            echo -e "${RED}❌ Invalid response. Please run the command again and choose 1 or 2.${NC}"
            return 1
            ;;
    esac
    
    # Step 2: Platform Selection/Detection
    local platform=""
    
    if [ "$project_type" = "greenfield" ]; then
        echo ""
        echo -e "${YELLOW}📱 Platform Selection for New Mobile App:${NC}"
        echo ""
        echo "Which mobile platform do you want to target?"
        echo ""
        echo "1. Flutter - Cross-platform with Dart"
        echo "2. React Native - Cross-platform with React/JavaScript"
        echo "3. Let APPIQ Method recommend based on requirements"
        echo ""
        echo -n "Please respond with 1, 2, or 3: "
        read -r platform_choice
        
        case $platform_choice in
            "1")
                platform="flutter"
                ;;
            "2")
                platform="react-native"
                ;;
            "3")
                echo ""
                echo -e "${BLUE}🤔 Platform Recommendation Analysis:${NC}"
                echo ""
                
                # Simple recommendation logic
                if [ -f "$project_root/package.json" ]; then
                    echo "• Existing JavaScript/Node.js expertise detected"
                    echo "• Recommendation: React Native"
                    platform="react-native"
                else
                    echo "• No existing platform preference detected"
                    echo "• Recommendation: Flutter (better performance, single codebase)"
                    platform="flutter"
                fi
                
                echo ""
                echo -n "Do you want to proceed with $platform? (y/n): "
                read -r accept_recommendation
                
                if [ "$accept_recommendation" != "y" ] && [ "$accept_recommendation" != "Y" ]; then
                    echo "Please run the command again and choose manually."
                    return 1
                fi
                ;;
            *)
                echo -e "${RED}❌ Invalid response. Please run the command again and choose 1, 2, or 3.${NC}"
                return 1
                ;;
        esac
    else
        # Brownfield - detect existing platform
        echo ""
        echo -e "${YELLOW}📱 Existing Mobile App Platform Detection:${NC}"
        echo ""
        
        if [ -f "$project_root/pubspec.yaml" ]; then
            echo "🎯 Flutter project detected!"
            platform="flutter"
        elif [ -f "$project_root/package.json" ] && grep -q "react-native" "$project_root/package.json" 2>/dev/null; then
            echo "🎯 React Native project detected!"
            platform="react-native"
        else
            echo "❓ Platform not automatically detected."
            echo ""
            echo "What platform is your existing mobile app built with?"
            echo ""
            echo "1. Flutter - Dart-based cross-platform app"
            echo "2. React Native - React/JavaScript-based app"
            echo ""
            echo -n "Please respond with 1 or 2: "
            read -r platform_choice
            
            case $platform_choice in
                "1")
                    platform="flutter"
                    ;;
                "2")
                    platform="react-native"
                    ;;
                *)
                    echo -e "${RED}❌ Invalid response. Please run the command again.${NC}"
                    return 1
                    ;;
            esac
        fi
    fi
    
    # Step 3: PRD Validation
    echo ""
    echo -e "${YELLOW}📋 Checking for main_prd.md in your /docs/ folder...${NC}"
    
    if [ -f "$project_root/docs/main_prd.md" ]; then
        echo -e "${GREEN}✅ Found: docs/main_prd.md${NC}"
    else
        echo -e "${RED}❌ Missing: docs/main_prd.md${NC}"
        echo ""
        echo -e "${YELLOW}You need to create a main_prd.md file first:${NC}"
        echo ""
        echo "1. Create the docs directory: mkdir -p docs"
        echo "2. Create your PRD file: touch docs/main_prd.md"
        echo "3. Edit it with your project requirements"
        echo "4. Run /appiq again"
        echo ""
        echo -e "${BLUE}💡 You can use the PRD template from .appiq/templates/mobile-prd-tmpl.yaml${NC}"
        return 1
    fi
    
    # Step 4: Workflow Launch
    local workflow_file=""
    case "${project_type}-${platform}" in
        "greenfield-flutter")
            workflow_file="mobile-greenfield-flutter.yaml"
            ;;
        "greenfield-react-native")
            workflow_file="mobile-greenfield-react-native.yaml"
            ;;
        "brownfield-flutter")
            workflow_file="mobile-brownfield-flutter.yaml"
            ;;
        "brownfield-react-native")
            workflow_file="mobile-brownfield-react-native.yaml"
            ;;
    esac
    
    echo ""
    echo -e "${GREEN}✅ Perfect! Launching Mobile Development Workflow...${NC}"
    echo ""
    echo -e "${CYAN}🎯 Starting with: ${workflow_file}${NC}"
    echo -e "${CYAN}📍 First Agent: analyst${NC}"
    echo -e "${CYAN}📂 Expected Output: docs/project-brief.md${NC}"
    echo ""
    echo -e "${YELLOW}The mobile development workflow will now guide you through:${NC}"
    echo "1. Mobile-focused project brief"
    echo "2. Mobile-specific PRD creation" 
    echo "3. $(echo $platform | sed 's/-/ /g' | sed 's/\b\w/\U&/g') platform validation"
    echo "4. Mobile UX design system"
    echo "5. $(echo $platform | sed 's/-/ /g' | sed 's/\b\w/\U&/g') architecture planning"
    echo "6. Mobile security review"
    echo "7. Story creation and development"
    echo ""
    echo -e "${BLUE}════════════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "${GREEN}@analyst${NC} - Please begin with creating a mobile-focused project brief considering app store landscape, device capabilities, and mobile user behavior."
    echo ""
    echo -e "${YELLOW}💡 Continue the workflow in your IDE (Claude, Cursor, Windsurf) for full agent interaction${NC}"
}

# Main command logic
main() {
    case "${1:-}" in
        "")
            # Default: launch interactive workflow
            local project_root
            if project_root=$(find_appiq_project); then
                cd "$project_root"
                launch_interactive_workflow "$project_root"
            else
                echo -e "${RED}❌ No APPIQ Method installation found in current directory or parent directories.${NC}"
                echo ""
                echo -e "${YELLOW}To install APPIQ Method in this project:${NC}"
                echo "curl -fsSL https://raw.githubusercontent.com/Viktor-Hermann/APPIQ-METHOD/main/deployment/quick-install.sh | bash"
                return 1
            fi
            ;;
        "status")
            local project_root
            if project_root=$(find_appiq_project); then
                cd "$project_root"
                if [ -x ".appiq/scripts/appiq" ]; then
                    ./.appiq/scripts/appiq status
                else
                    echo -e "${BLUE}📊 APPIQ Project Status${NC}"
                    echo "Project: $(basename "$project_root")"
                    echo "Location: $project_root"
                    echo "Installation: APPIQ Method detected"
                fi
            else
                echo -e "${RED}❌ No APPIQ Method installation found${NC}"
                return 1
            fi
            ;;
        "validate")
            local project_root
            if project_root=$(find_appiq_project); then
                cd "$project_root"
                if [ -x ".appiq/scripts/appiq" ]; then
                    ./.appiq/scripts/appiq validate
                else
                    echo -e "${BLUE}🔍 Basic APPIQ Validation${NC}"
                    
                    local errors=0
                    
                    if [ ! -f "docs/main_prd.md" ]; then
                        echo -e "${RED}❌ Missing: docs/main_prd.md${NC}"
                        ((errors++))
                    else
                        echo -e "${GREEN}✅ Found: docs/main_prd.md${NC}"
                    fi
                    
                    if [ ! -d ".appiq" ]; then
                        echo -e "${RED}❌ Missing: .appiq directory${NC}"
                        ((errors++))
                    else
                        echo -e "${GREEN}✅ Found: .appiq directory${NC}"
                    fi
                    
                    if [ $errors -eq 0 ]; then
                        echo -e "${GREEN}✅ Basic validation passed!${NC}"
                    else
                        echo -e "${RED}❌ Found $errors issues${NC}"
                        return 1
                    fi
                fi
            else
                echo -e "${RED}❌ No APPIQ Method installation found${NC}"
                return 1
            fi
            ;;
        "help"|"--help"|"-h")
            echo -e "${CYAN}🚀 APPIQ Method - Global Terminal Command${NC}"
            echo ""
            echo -e "${YELLOW}Usage:${NC}"
            echo "  appiq                 Launch interactive mobile development workflow"
            echo "  appiq status          Show project status"
            echo "  appiq validate        Validate project setup"
            echo "  appiq help            Show this help"
            echo ""
            echo -e "${YELLOW}Examples:${NC}"
            echo "  appiq                 # Start mobile development workflow"
            echo "  appiq status          # Check current project status"
            echo "  appiq validate        # Validate APPIQ setup"
            echo ""
            echo -e "${YELLOW}Requirements:${NC}"
            echo "• Run in a directory with APPIQ Method installed"
            echo "• Have docs/main_prd.md with your project requirements"
            echo "• Mobile development environment (Flutter SDK or React Native)"
            ;;
        *)
            echo -e "${RED}❌ Unknown command: $1${NC}"
            echo "Use 'appiq help' for available commands"
            return 1
            ;;
    esac
}

# Run main function with all arguments
main "$@"
EOF

chmod +x "${APPIQ_DIR}/scripts/appiq-global"

# Create symlink for /appiq command (requires sudo)
echo -e "${BLUE}🔗 Setting up global command access...${NC}"

# Try to create symlink in user's local bin directory first
LOCAL_BIN="$HOME/.local/bin"
if [ ! -d "$LOCAL_BIN" ]; then
    mkdir -p "$LOCAL_BIN"
fi

# Create symlink
if [ -w "$LOCAL_BIN" ]; then
    ln -sf "$(realpath "${APPIQ_DIR}/scripts/appiq-global")" "$LOCAL_BIN/appiq"
    echo -e "${GREEN}✅ Created symlink: $LOCAL_BIN/appiq${NC}"
    
    # Add to PATH if not already there
    SHELL_CONFIG=$(get_shell_config)
    if [ -f "$SHELL_CONFIG" ]; then
        if ! grep -q '$HOME/.local/bin' "$SHELL_CONFIG"; then
            echo "" >> "$SHELL_CONFIG"
            echo "# APPIQ Method - Add local bin to PATH" >> "$SHELL_CONFIG"
            echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$SHELL_CONFIG"
            echo -e "${GREEN}✅ Added $LOCAL_BIN to PATH in $SHELL_CONFIG${NC}"
        fi
    fi
else
    echo -e "${YELLOW}⚠️ Cannot write to $LOCAL_BIN${NC}"
fi

# Alternative: Try system-wide installation (requires sudo)
if command -v sudo >/dev/null 2>&1 && [ ! -L "/usr/local/bin/appiq" ]; then
    echo ""
    echo -e "${YELLOW}📋 Optional: Install system-wide /appiq command? (requires sudo)${NC}"
    echo -n "Install globally? (y/n): "
    read -r install_global
    
    if [ "$install_global" = "y" ] || [ "$install_global" = "Y" ]; then
        if sudo ln -sf "$(realpath "${APPIQ_DIR}/scripts/appiq-global")" "/usr/local/bin/appiq" 2>/dev/null; then
            echo -e "${GREEN}✅ Created global symlink: /usr/local/bin/appiq${NC}"
        else
            echo -e "${YELLOW}⚠️ Could not create global symlink${NC}"
        fi
    fi
fi

# Create shell completion
echo -e "${BLUE}📚 Creating shell completion...${NC}"

# Bash completion
cat > "${APPIQ_DIR}/scripts/appiq-completion.bash" << 'EOF'
# APPIQ Method - Bash Completion

_appiq_completions() {
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    opts="status validate help"
    
    if [[ ${cur} == -* ]] ; then
        COMPREPLY=( $(compgen -W "--help -h" -- ${cur}) )
        return 0
    fi
    
    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
    return 0
}

complete -F _appiq_completions appiq
EOF

# Zsh completion
cat > "${APPIQ_DIR}/scripts/appiq-completion.zsh" << 'EOF'
#compdef appiq

# APPIQ Method - Zsh Completion

_appiq() {
    local context state line
    _arguments \
        '1: :->commands' \
        '*: :->args'
    
    case $state in
        commands)
            _arguments '1:Commands:(status validate help)'
            ;;
    esac
}

_appiq "$@"
EOF

# Add completion to shell config
SHELL_CONFIG=$(get_shell_config)
if [ -f "$SHELL_CONFIG" ]; then
    if ! grep -q "appiq-completion" "$SHELL_CONFIG"; then
        echo "" >> "$SHELL_CONFIG"
        echo "# APPIQ Method - Shell Completion" >> "$SHELL_CONFIG"
        
        shell_type=$(detect_shell)
        case $shell_type in
            "zsh")
                echo "[ -f \"$(realpath "${APPIQ_DIR}/scripts/appiq-completion.zsh")\" ] && source \"$(realpath "${APPIQ_DIR}/scripts/appiq-completion.zsh")\"" >> "$SHELL_CONFIG"
                ;;
            "bash")
                echo "[ -f \"$(realpath "${APPIQ_DIR}/scripts/appiq-completion.bash")\" ] && source \"$(realpath "${APPIQ_DIR}/scripts/appiq-completion.bash")\"" >> "$SHELL_CONFIG"
                ;;
        esac
        
        echo -e "${GREEN}✅ Added shell completion to $SHELL_CONFIG${NC}"
    fi
fi

echo -e "${GREEN}✅ Terminal integration installed successfully!${NC}"
echo ""
echo -e "${YELLOW}💡 How to use the global /appiq command:${NC}"
echo -e "${CYAN}1. Open terminal in any project directory${NC}"
echo -e "${CYAN}2. Run: appiq${NC}"
echo -e "${CYAN}3. Follow the interactive prompts${NC}"
echo ""
echo -e "${BLUE}📋 Available commands:${NC}"
echo "• appiq          - Launch interactive mobile development workflow"
echo "• appiq status   - Show project status"
echo "• appiq validate - Validate project setup"
echo "• appiq help     - Show help information"
echo ""
echo -e "${YELLOW}🔄 Please restart your terminal or run:${NC}"
echo -e "${CYAN}source $(get_shell_config)${NC}"
echo ""
echo -e "${GREEN}🎉 You can now use 'appiq' command anywhere!${NC}"