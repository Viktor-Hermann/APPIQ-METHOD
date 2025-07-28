#!/bin/bash

# APPIQ Method - Global Terminal Command
# This script provides the global 'appiq' command for system-wide access

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Find APPIQ installation directory
find_appiq_dir() {
    # Check common locations
    local locations=(
        "$HOME/.appiq"
        "$(pwd)/.appiq"
        "/usr/local/share/appiq"
        "/opt/appiq"
    )
    
    for dir in "${locations[@]}"; do
        if [ -d "$dir" ] && [ -f "$dir/bmad-core/agents/bmad-orchestrator.md" ]; then
            echo "$dir"
            return 0
        fi
    done
    
    return 1
}

# Main function
main() {
    local appiq_dir
    appiq_dir=$(find_appiq_dir)
    
    if [ -z "$appiq_dir" ]; then
        echo -e "${RED}❌ APPIQ Method installation not found!${NC}"
        echo -e "${YELLOW}💡 Install APPIQ Method first with:${NC}"
        echo "curl -fsSL https://github.com/Viktor-Hermann/APPIQ-METHOD/releases/latest/download/appiq_installer.sh | bash"
        exit 1
    fi
    
    # Handle commands
    case "${1:-help}" in
        "start")
            echo -e "${BLUE}🚀 APPIQ Method Universal Launcher${NC}"
            echo -e "${YELLOW}📋 To use the /start command, please use your IDE:${NC}"
            echo "1. Open your IDE (Claude, Cursor, Windsurf, etc.)"
            echo "2. Type: /start"
            echo "3. Follow the guided workflow selection"
            echo ""
            echo -e "${YELLOW}💡 Alternative: Use bmad-orchestrator directly${NC}"
            echo "Copy this to your IDE chat:"
            echo ""
            echo -e "${GREEN}@bmad-orchestrator${NC}"
            echo -e "${GREEN}*start${NC}"
            ;;
            
        "status")
            echo -e "${GREEN}✅ APPIQ Method Status${NC}"
            echo "Installation directory: $appiq_dir"
            echo "Version: $(cat "$appiq_dir/VERSION" 2>/dev/null || echo "Unknown")"
            echo ""
            echo "Available IDE integrations:"
            [ -f "$appiq_dir/slash-commands/claude-appiq.md" ] && echo "  ✅ Claude"
            [ -f "$appiq_dir/slash-commands/cursor-appiq.md" ] && echo "  ✅ Cursor"
            [ -f "$appiq_dir/slash-commands/windsurf-appiq.md" ] && echo "  ✅ Windsurf"
            ;;
            
        "help"|*)
            echo -e "${BLUE}🎯 APPIQ Method - Global Commands${NC}"
            echo ""
            echo "Available commands:"
            echo "  appiq start    - Launch universal project workflow (use in IDE)"
            echo "  appiq status   - Show APPIQ Method installation status"
            echo "  appiq help     - Show this help message"
            echo ""
            echo -e "${YELLOW}💡 Main Usage: Use /start in your IDE for guided workflow selection${NC}"
            echo ""
            echo "Supported IDEs:"
            echo "  • Claude Code"
            echo "  • Cursor"
            echo "  • Windsurf"
            echo "  • Any IDE with slash command support"
            ;;
    esac
}

main "$@"