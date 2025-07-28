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

# Universal interactive workflow launcher
launch_interactive_workflow() {
    local project_root="$1"
    
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════════════════════════════╗"
    echo "║                🚀 APPIQ METHOD - UNIVERSAL LAUNCHER              ║"
    echo "║                                                                  ║"
    echo "║                    Interactive Workflow Launcher                ║"
    echo "╚══════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    echo -e "${BLUE}📍 Project: $(basename "$project_root")${NC}"
    echo ""
    
    # Step 1: Project Status Selection
    echo -e "${YELLOW}🚀 APPIQ Method Universal Launcher${NC}"
    echo ""
    echo "Arbeiten wir an einem neuen oder bestehenden Projekt?"
    echo ""
    echo "1. 🆕 Neues Projekt (Greenfield) - Wir bauen von Grund auf"
    echo "2. 🔧 Bestehendes Projekt (Brownfield) - Wir erweitern/verbessern etwas"
    echo ""
    echo -n "Antworte mit 1 oder 2: "
    read -r project_status
    
    case $project_status in
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
    
    # Step 2: Universal Project Type Selection
    local app_category=""
    local platform=""
    
    echo ""
    echo -e "${YELLOW}📋 Lass mich verstehen, was wir bauen...${NC}"
    echo ""
    echo "Was für eine Art von Anwendung ist das?"
    echo ""
    echo "1. 🌐 Web-Anwendung (läuft im Browser)"
    echo "2. 💻 Desktop-Anwendung (Electron, Windows/Mac App)"
    echo "3. 📱 Mobile App (iOS/Android)"
    echo "4. ⚙️ Backend/API Service (Server, Database)"
    echo "5. 🤔 Bin mir nicht sicher - lass APPIQ entscheiden"
    echo ""
    echo -n "Antworte mit 1, 2, 3, 4 oder 5: "
    read -r app_type_choice
    
    case $app_type_choice in
        "1")
            app_category="web"
            platform="web"
            ;;
        "2")
            app_category="desktop"
            platform="electron"
            ;;
        "3")
            app_category="mobile"
            # Handle mobile platform selection
            if [ "$project_type" = "greenfield" ]; then
                echo ""
                echo -e "${YELLOW}📱 Mobile Platform Selection:${NC}"
                echo ""
                echo "1. Flutter - Cross-platform with Dart"
                echo "2. React Native - Cross-platform with React/JavaScript"
                echo ""
                echo -n "Antworte mit 1 oder 2: "
                read -r mobile_platform_choice
                
                case $mobile_platform_choice in
                    "1")
                        platform="flutter"
                        ;;
                    "2")
                        platform="react-native"
                        ;;
                    *)
                        echo -e "${RED}❌ Invalid response.${NC}"
                        return 1
                        ;;
                esac
            else
                # Brownfield mobile detection
                if [ -f "$project_root/pubspec.yaml" ]; then
                    echo "🎯 Flutter project detected!"
                    platform="flutter"
                elif [ -f "$project_root/package.json" ] && grep -q "react-native" "$project_root/package.json" 2>/dev/null; then
                    echo "🎯 React Native project detected!"
                    platform="react-native"
                else
                    echo "❓ Platform not detected. Assuming Flutter."
                    platform="flutter"
                fi
            fi
            ;;
        "4")
            app_category="backend"
            platform="backend"
            ;;
        "5")
            # Auto-detection logic
            if [ "$project_type" = "brownfield" ]; then
                echo ""
                echo -e "${BLUE}🔍 Analysiere dein bestehendes Projekt...${NC}"
                echo ""
                
                if [ -f "$project_root/pubspec.yaml" ]; then
                    echo "🎯 Flutter Mobile App erkannt!"
                    app_category="mobile"
                    platform="flutter"
                elif [ -f "$project_root/package.json" ]; then
                    if grep -q "electron" "$project_root/package.json" 2>/dev/null; then
                        echo "🎯 Electron Desktop App erkannt!"
                        app_category="desktop"
                        platform="electron"
                    elif grep -q "react-native" "$project_root/package.json" 2>/dev/null; then
                        echo "🎯 React Native Mobile App erkannt!"
                        app_category="mobile"
                        platform="react-native"
                    elif grep -q -E "(react|vue|angular|next)" "$project_root/package.json" 2>/dev/null; then
                        echo "🎯 Web-Anwendung erkannt!"
                        app_category="web"
                        platform="web"
                    elif grep -q -E "(express|fastify|koa)" "$project_root/package.json" 2>/dev/null; then
                        echo "🎯 Backend Service erkannt!"
                        app_category="backend"
                        platform="backend"
                    else
                        echo "🎯 Node.js Backend Service erkannt!"
                        app_category="backend"
                        platform="backend"
                    fi
                elif [ -f "$project_root/requirements.txt" ]; then
                    echo "🎯 Python Backend Service erkannt!"
                    app_category="backend"
                    platform="backend"
                else
                    echo "❓ Projekttyp nicht erkannt. Verwende Web-Anwendung."
                    app_category="web"
                    platform="web"
                fi
            else
                echo "❓ Für neue Projekte bitte Projekttyp manuell wählen."
                return 1
            fi
            ;;
        *)
            echo -e "${RED}❌ Invalid response. Please run the command again.${NC}"
            return 1
            ;;
    esac
    
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
    
    # Step 4: Universal Workflow Launch
    local workflow_file=""
    local context_message=""
    local workflow_steps=""
    local analyst_instruction=""
    
    # Determine workflow file based on project type and category
    case "${project_type}-${app_category}" in
        "greenfield-web")
            workflow_file="greenfield-fullstack.yaml"
            context_message="Full-Stack Web-Anwendung mit Frontend und Backend Komponenten"
            workflow_steps="1. Projekt-Brief und Marktanalyse
2. PRD für Web-Anwendung
3. UX/UI Spezifikation
4. Full-Stack Architektur
5. Story-basierte Entwicklung"
            analyst_instruction="Bitte erstelle einen Projekt-Brief für die Web-Anwendung mit Fokus auf Frontend/Backend Integration."
            ;;
        "brownfield-web")
            workflow_file="brownfield-fullstack.yaml"
            context_message="Full-Stack Web-Anwendung mit Frontend und Backend Komponenten"
            workflow_steps="1. Analyse der bestehenden Web-Anwendung
2. Modernisierungs-Möglichkeiten identifizieren
3. Sichere Integration planen
4. Enhancement-Stories erstellen"
            analyst_instruction="Bitte analysiere die bestehende Web-Anwendung und identifiziere Modernisierungs-Möglichkeiten."
            ;;
        "greenfield-desktop")
            workflow_file="greenfield-fullstack.yaml"
            context_message="Electron Desktop-Anwendung mit plattformspezifischen Optimierungen"
            workflow_steps="1. Desktop-App Konzeption
2. Electron-spezifische Requirements
3. Cross-Platform UI Design
4. Desktop-Architektur
5. Platform-spezifische Implementierung"
            analyst_instruction="Bitte erstelle einen Projekt-Brief für die Desktop-Anwendung mit Electron-spezifischen Anforderungen."
            ;;
        "brownfield-desktop")
            workflow_file="brownfield-fullstack.yaml"
            context_message="Electron Desktop-Anwendung mit plattformspezifischen Optimierungen"
            workflow_steps="1. Analyse der bestehenden Electron-Anwendung
2. Performance-Optimierungen identifizieren
3. Plattform-spezifische Verbesserungen
4. Feature-Enhancement Planung"
            analyst_instruction="Bitte analysiere die bestehende Electron-Anwendung und identifiziere Verbesserungsmöglichkeiten."
            ;;
        "greenfield-mobile")
            if [ "$platform" = "flutter" ]; then
                workflow_file="mobile-greenfield-flutter.yaml"
            else
                workflow_file="mobile-greenfield-react-native.yaml"
            fi
            context_message="$(echo $platform | sed 's/-/ /g' | sed 's/\b\w/\U&/g') Cross-Platform Mobile-Anwendung"
            workflow_steps="1. Mobile-fokussierter Projekt-Brief
2. Mobile-spezifische PRD
3. Platform-Validierung
4. Mobile UX Design
5. Mobile Architektur-Planung"
            analyst_instruction="Bitte erstelle einen mobile-fokussierten Projekt-Brief unter Berücksichtigung von App Store Landschaft und mobile User Behavior."
            ;;
        "brownfield-mobile")
            if [ "$platform" = "flutter" ]; then
                workflow_file="mobile-brownfield-flutter.yaml"
            else
                workflow_file="mobile-brownfield-react-native.yaml"
            fi
            context_message="$(echo $platform | sed 's/-/ /g' | sed 's/\b\w/\U&/g') Cross-Platform Mobile-Anwendung"
            workflow_steps="1. Mobile App Analyse
2. Platform-spezifische Optimierungen
3. App Store Compliance Review
4. Mobile Enhancement Stories"
            analyst_instruction="Bitte analysiere die bestehende Mobile App und identifiziere platform-spezifische Optimierungen."
            ;;
        "greenfield-backend")
            workflow_file="greenfield-service.yaml"
            context_message="API-Design und Datenarchitektur im Fokus"
            workflow_steps="1. API und Service Konzeption
2. Backend Requirements Definition
3. Datenbank und Architektur Design
4. API Spezifikation
5. Service-orientierte Implementierung"
            analyst_instruction="Bitte erstelle einen Projekt-Brief für den Backend Service mit Fokus auf API Design und Skalierbarkeit."
            ;;
        "brownfield-backend")
            workflow_file="brownfield-service.yaml"
            context_message="API-Design und Datenarchitektur im Fokus"
            workflow_steps="1. Backend Service Analyse
2. API Evolution Planung
3. Skalierungsoptimierungen
4. Service Enhancement Stories"
            analyst_instruction="Bitte analysiere den bestehenden Backend Service und identifiziere Optimierungs-Möglichkeiten."
            ;;
    esac
    
    # Display category name
    local category_display=""
    case $app_category in
        "web") category_display="Web-Anwendung" ;;
        "desktop") category_display="Desktop-Anwendung" ;;
        "mobile") 
            if [ "$platform" = "flutter" ]; then
                category_display="Flutter Mobile App"
            else
                category_display="React Native Mobile App"
            fi
            ;;
        "backend") category_display="Backend Service" ;;
    esac
    
    local type_display=""
    if [ "$project_type" = "greenfield" ]; then
        type_display="Development"
    else
        type_display="Enhancement"
    fi
    
    echo ""
    echo -e "${GREEN}✅ Perfect! ${category_display} ${type_display} erkannt.${NC}"
    echo ""
    echo -e "${CYAN}🎯 Starte ${project_type} Workflow für ${category_display}...${NC}"
    echo -e "${CYAN}📍 Fokus: ${context_message}${NC}"
    echo -e "${CYAN}📂 Workflow: ${workflow_file}${NC}"
    echo -e "${CYAN}🎬 Erster Agent: analyst${NC}"
    echo ""
    echo -e "${YELLOW}Der Workflow führt Sie durch:${NC}"
    echo "$workflow_steps"
    echo ""
    echo -e "${BLUE}════════════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "${GREEN}@analyst${NC} - ${analyst_instruction}"
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
            echo -e "${CYAN}🚀 APPIQ Method - Universal Global Terminal Command${NC}"
            echo ""
            echo -e "${YELLOW}Usage:${NC}"
            echo "  appiq                 Launch interactive universal development workflow"
            echo "  appiq status          Show project status"
            echo "  appiq validate        Validate project setup"
            echo "  appiq help            Show this help"
            echo ""
            echo -e "${YELLOW}Examples:${NC}"
            echo "  appiq                 # Start universal development workflow"
            echo "  appiq status          # Check current project status"
            echo "  appiq validate        # Validate APPIQ setup"
            echo ""
            echo -e "${YELLOW}Supported Project Types:${NC}"
            echo "• 🌐 Web Applications (React, Vue, Angular, Next.js)"
            echo "• 💻 Desktop Applications (Electron, Cross-Platform)"
            echo "• 📱 Mobile Apps (Flutter, React Native)"
            echo "• ⚙️ Backend Services (Node.js, Python, Java)"
            echo ""
            echo -e "${YELLOW}Requirements:${NC}"
            echo "• Run in a directory with APPIQ Method installed"
            echo "• Have docs/main_prd.md with your project requirements"
            echo "• Development environment for your project type"
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