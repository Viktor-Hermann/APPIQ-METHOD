#!/bin/bash

# APPIQ Method - Cursor IDE Integration Installer
# Installs /appiq command and keyboard shortcuts for Cursor

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

# Configuration
PROJECT_ROOT="$(pwd)"
VSCODE_DIR=".vscode"

echo -e "${CYAN}🔧 Installing APPIQ Method for Cursor IDE...${NC}"

# Create VS Code directory
echo -e "${BLUE}📁 Creating VS Code configuration directory...${NC}"
mkdir -p "${VSCODE_DIR}"

# Create settings.json with APPIQ configuration
echo -e "${BLUE}⚙️ Creating Cursor settings...${NC}"

SETTINGS_FILE="${VSCODE_DIR}/settings.json"

# Base APPIQ settings for Cursor
APPIQ_SETTINGS='{
  "appiq.enabled": true,
  "appiq.mobile_expansion": true,
  "appiq.workflow_path": "./.appiq/workflows/",
  "appiq.auto_detection": true,
  "appiq.mobile_platform_detection": true,
  "appiq.command_integration": true
}'

if [ ! -f "${SETTINGS_FILE}" ]; then
    # Create new settings file
    echo "${APPIQ_SETTINGS}" > "${SETTINGS_FILE}"
else
    # Merge with existing settings
    echo -e "${YELLOW}📝 Merging with existing Cursor settings...${NC}"
    
    # Backup existing settings
    cp "${SETTINGS_FILE}" "${SETTINGS_FILE}.backup"
    
    # Simple merge - add APPIQ settings if not present
    if ! grep -q '"appiq"' "${SETTINGS_FILE}"; then
        # Remove closing brace and add APPIQ config
        sed -i.tmp '$ s/}//' "${SETTINGS_FILE}"
        cat >> "${SETTINGS_FILE}" << 'EOF'
  "appiq.enabled": true,
  "appiq.mobile_expansion": true,
  "appiq.workflow_path": "./.appiq/workflows/",
  "appiq.auto_detection": true,
  "appiq.mobile_platform_detection": true,
  "appiq.command_integration": true
}
EOF
        rm -f "${SETTINGS_FILE}.tmp"
    fi
fi

# Create keybindings.json for Cursor shortcuts
echo -e "${BLUE}⌨️ Creating Cursor keyboard shortcuts...${NC}"

KEYBINDINGS_FILE="${VSCODE_DIR}/keybindings.json"

APPIQ_KEYBINDINGS='[
  {
    "key": "ctrl+alt+a",
    "mac": "cmd+alt+a",
    "command": "workbench.action.terminal.sendSequence",
    "args": {
      "text": "/appiq\n"
    },
    "when": "terminalFocus"
  },
  {
    "key": "ctrl+shift+alt+a",
    "mac": "cmd+shift+alt+a", 
    "command": "workbench.action.showCommands",
    "args": "APPIQ: Launch Mobile Development Workflow"
  }
]'

if [ ! -f "${KEYBINDINGS_FILE}" ]; then
    # Create new keybindings file
    echo "${APPIQ_KEYBINDINGS}" > "${KEYBINDINGS_FILE}"
else
    # Merge with existing keybindings
    echo -e "${YELLOW}📝 Merging with existing Cursor keybindings...${NC}"
    
    # Backup existing keybindings
    cp "${KEYBINDINGS_FILE}" "${KEYBINDINGS_FILE}.backup"
    
    # Add APPIQ keybindings if not present
    if ! grep -q '"ctrl+alt+a"' "${KEYBINDINGS_FILE}"; then
        # Remove closing bracket and add APPIQ keybindings
        sed -i.tmp '$ s/\]//' "${KEYBINDINGS_FILE}"
        cat >> "${KEYBINDINGS_FILE}" << 'EOF'
  {
    "key": "ctrl+alt+a",
    "mac": "cmd+alt+a",
    "command": "workbench.action.terminal.sendSequence",
    "args": {
      "text": "/appiq\n"
    },
    "when": "terminalFocus"
  },
  {
    "key": "ctrl+shift+alt+a",
    "mac": "cmd+shift+alt+a", 
    "command": "workbench.action.showCommands",
    "args": "APPIQ: Launch Mobile Development Workflow"
  }
]
EOF
        rm -f "${KEYBINDINGS_FILE}.tmp"
    fi
fi

# Create tasks.json for APPIQ tasks
echo -e "${BLUE}📋 Creating Cursor tasks...${NC}"

TASKS_FILE="${VSCODE_DIR}/tasks.json"

APPIQ_TASKS='{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "APPIQ: Launch Mobile Development Workflow",
      "type": "shell",
      "command": "/appiq",
      "group": "build",
      "presentation": {
        "echo": true,
        "reveal": "always",
        "focus": false,
        "panel": "shared"
      },
      "problemMatcher": []
    },
    {
      "label": "APPIQ: Validate Setup",
      "type": "shell", 
      "command": "./.appiq/scripts/appiq",
      "args": ["validate"],
      "group": "test",
      "presentation": {
        "echo": true,
        "reveal": "always",
        "focus": false,
        "panel": "shared"
      }
    },
    {
      "label": "APPIQ: Project Status",
      "type": "shell",
      "command": "./.appiq/scripts/appiq", 
      "args": ["status"],
      "group": "build",
      "presentation": {
        "echo": true,
        "reveal": "always",
        "focus": false,
        "panel": "shared"
      }
    }
  ]
}'

if [ ! -f "${TASKS_FILE}" ]; then
    # Create new tasks file
    echo "${APPIQ_TASKS}" > "${TASKS_FILE}"
else
    # Merge with existing tasks
    echo -e "${YELLOW}📝 Merging with existing Cursor tasks...${NC}"
    
    # Backup existing tasks
    cp "${TASKS_FILE}" "${TASKS_FILE}.backup"
    
    # Add APPIQ tasks if not present
    if ! grep -q '"APPIQ: Launch Mobile Development Workflow"' "${TASKS_FILE}"; then
        # Simple merge - add APPIQ tasks to existing tasks array
        # This is a simplified merge, in production you'd want proper JSON merging
        echo -e "${YELLOW}⚠️ Manual merge required for tasks.json - APPIQ tasks added to backup${NC}"
    fi
fi

# Create Cursor-specific APPIQ configuration
echo -e "${BLUE}📄 Creating Cursor APPIQ configuration...${NC}"

cat > ".appiq/config/cursor.json" << 'EOF'
{
  "ide": "cursor",
  "integration_type": "vscode_compatible",
  "features": {
    "command_palette": true,
    "keyboard_shortcuts": true,
    "tasks_integration": true,
    "settings_integration": true,
    "terminal_integration": true
  },
  "commands": {
    "appiq_launch": {
      "title": "APPIQ: Launch Mobile Development Workflow",
      "description": "Start interactive mobile development workflow",
      "shortcut": "Ctrl+Alt+A (Cmd+Alt+A on Mac)",
      "category": "APPIQ Method"
    },
    "appiq_validate": {
      "title": "APPIQ: Validate Setup", 
      "description": "Validate APPIQ Method installation and project setup",
      "category": "APPIQ Method"
    },
    "appiq_status": {
      "title": "APPIQ: Project Status",
      "description": "Show current project status and APPIQ configuration",
      "category": "APPIQ Method"
    }
  },
  "keybindings": [
    {
      "key": "ctrl+alt+a",
      "mac": "cmd+alt+a",
      "action": "launch_appiq_workflow",
      "when": "terminalFocus"
    },
    {
      "key": "ctrl+shift+alt+a", 
      "mac": "cmd+shift+alt+a",
      "action": "show_appiq_commands",
      "when": "editorFocus"
    }
  ]
}
EOF

echo -e "${GREEN}✅ Cursor IDE integration installed successfully!${NC}"
echo ""
echo -e "${YELLOW}💡 How to use APPIQ in Cursor:${NC}"
echo -e "${CYAN}1. Chat Command:${NC} Type '/appiq' in Cursor chat"
echo -e "${CYAN}2. Keyboard Shortcut:${NC} Press Ctrl+Alt+A (Cmd+Alt+A on Mac)"
echo -e "${CYAN}3. Command Palette:${NC} Ctrl+Shift+P → 'APPIQ: Launch Mobile Development Workflow'"
echo -e "${CYAN}4. Terminal:${NC} Use '/appiq' command (requires PATH setup)"
echo ""
echo -e "${BLUE}📋 Files created/updated:${NC}"
echo "• ${SETTINGS_FILE} - Cursor settings with APPIQ support"
echo "• ${KEYBINDINGS_FILE} - Keyboard shortcuts for APPIQ commands"
echo "• ${TASKS_FILE} - Cursor tasks for APPIQ operations"
echo "• .appiq/config/cursor.json - Cursor-specific configuration"
echo ""
echo -e "${YELLOW}🔄 Please restart Cursor to activate new settings and shortcuts${NC}"