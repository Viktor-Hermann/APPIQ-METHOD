#!/bin/bash

# APPIQ Method - Claude Code Integration Installer
# Installs /appiq slash command properly in Claude Code

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

# Configuration
PROJECT_ROOT="$(pwd)"
CLAUDE_DIR=".claude"
COMMANDS_DIR="${CLAUDE_DIR}/commands"

echo -e "${CYAN}🔧 Installing APPIQ Method for Claude Code...${NC}"

# Create Claude directories
echo -e "${BLUE}📁 Creating Claude directories...${NC}"
mkdir -p "${COMMANDS_DIR}"

# Create the /appiq slash command for Claude
echo -e "${BLUE}📝 Creating /appiq slash command...${NC}"
cat > "${COMMANDS_DIR}/appiq.md" << 'EOF'
# /appiq - APPIQ Method Universal Development Launcher

**Quick Start**: `/appiq` - Interactive universal development workflow launcher

## Overview

The `/appiq` command provides an interactive way to launch the APPIQ Method universal development workflow. It guides users through project type selection and automatically triggers the appropriate development workflow for Web, Desktop, Mobile, or Backend projects based on their responses.

## Usage

```
/appiq
```

## Interactive Flow

When you use `/appiq`, the system will interactively guide you through:

### Step 1: Project Status Selection
```
🚀 APPIQ Method Universal Launcher

Arbeiten wir an einem neuen oder bestehenden Projekt?

1. 🆕 Neues Projekt (Greenfield) - Wir bauen von Grund auf
2. 🔧 Bestehendes Projekt (Brownfield) - Wir erweitern/verbessern etwas

Antworte mit 1 oder 2:
```

### Step 2: Project Type Selection
```
📋 Lass mich verstehen, was wir bauen...

Was für eine Art von Anwendung ist das?

1. 🌐 Web-Anwendung (läuft im Browser)
2. 💻 Desktop-Anwendung (Electron, Windows/Mac App)
3. 📱 Mobile App (iOS/Android)
4. ⚙️ Backend/API Service (Server, Database)
5. 🤔 Bin mir nicht sicher - lass APPIQ entscheiden

Antworte mit 1, 2, 3, 4 oder 5:
```

### Step 3: Auto-Detection or Platform Selection

**For Mobile Projects (Option 3):**
```
📱 Mobile Platform Selection:

1. Flutter - Cross-platform with Dart
2. React Native - Cross-platform with React/JavaScript

Antworte mit 1 oder 2:
```

**For Auto-Detection (Option 5):**
- Brownfield projects: Analyzes existing project structure automatically
- Greenfield projects: Requests project description for intelligent categorization

### Step 4: Universal Workflow Launch

Based on your responses, the system automatically launches the appropriate workflow:

**Web Application Workflows:**
- `greenfield-fullstack.yaml` - New web application development
- `brownfield-fullstack.yaml` - Existing web application enhancement

**Desktop Application Workflows:**
- `greenfield-fullstack.yaml` - New desktop application development (Electron context)
- `brownfield-fullstack.yaml` - Existing desktop application enhancement (Electron context)

**Mobile Application Workflows:**
- `mobile-greenfield-flutter.yaml` - New Flutter app development
- `mobile-greenfield-react-native.yaml` - New React Native app development
- `mobile-brownfield-flutter.yaml` - Existing Flutter app enhancement
- `mobile-brownfield-react-native.yaml` - Existing React Native app enhancement

**Backend Service Workflows:**
- `greenfield-service.yaml` - New backend service development
- `brownfield-service.yaml` - Existing backend service enhancement

## Implementation

When `/appiq` is executed, it performs the following logic:

```javascript
// Project status detection
let projectType = await askUser("Project Status? (1) Greenfield (2) Brownfield");

// Application category detection
let appCategory = await askUser("App Type? (1) Web (2) Desktop (3) Mobile (4) Backend (5) Auto-detect");

let platform = null;
if (appCategory === "3") {
    // Mobile - ask for platform
    platform = await askUser("Mobile Platform? (1) Flutter (2) React Native");
} else if (appCategory === "5") {
    // Auto-detection logic
    if (projectType === "2") {
        // Brownfield - analyze existing project
        let detection = await analyzeProject();
        appCategory = detection.type;
        platform = detection.platform;
    } else {
        // Greenfield - request description
        let description = await askUser("Describe your project briefly:");
        let detection = await analyzeDescription(description);
        appCategory = detection.type;
        platform = detection.platform;
    }
}

// Launch appropriate workflow
let workflowFile = getUniversalWorkflowFile(projectType, appCategory, platform);
await launchWorkflow(workflowFile);
```

## Universal Workflow Mapping

The command maps user selections to specific workflow files:

| Project Type | App Category | Platform | Workflow File |
|--------------|-------------|----------|---------------|
| Greenfield | Web | - | `greenfield-fullstack.yaml` |
| Greenfield | Desktop | - | `greenfield-fullstack.yaml` (Electron context) |
| Greenfield | Mobile | Flutter | `mobile-greenfield-flutter.yaml` |
| Greenfield | Mobile | React Native | `mobile-greenfield-react-native.yaml` |  
| Greenfield | Backend | - | `greenfield-service.yaml` |
| Brownfield | Web | - | `brownfield-fullstack.yaml` |
| Brownfield | Desktop | - | `brownfield-fullstack.yaml` (Electron context) |
| Brownfield | Mobile | Flutter | `mobile-brownfield-flutter.yaml` |
| Brownfield | Mobile | React Native | `mobile-brownfield-react-native.yaml` |
| Brownfield | Backend | - | `brownfield-service.yaml` |

## Expected Workflow Launch

After successful selection, the system launches with:

```
✅ Perfect! Launching [Workflow Name]...

🎯 Starting with: workflow-file.yaml
📍 First Agent: analyst (creating project-brief.md)
📂 Expected Output: docs/project-brief.md

The mobile development workflow will now guide you through:
1. Mobile-focused project brief
2. Mobile-specific PRD creation 
3. Platform validation (Flutter/React Native)
4. Mobile UX design system
5. Mobile architecture planning
6. Mobile security review
7. Story creation and development

@analyst - Please begin with creating a mobile-focused project brief considering app store landscape, device capabilities, and mobile user behavior.
```

## File Requirements

For `/appiq` to work properly, ensure:

1. **docs/main_prd.md exists** - Your Product Requirements Document
2. **.appiq/ directory** - APPIQ Method installation directory
3. **Workflow files** - Available in `.appiq/workflows/`
4. **Agent files** - Available in `.appiq/agents/`

## Error Handling

The command provides helpful guidance for common issues:

- **Missing main_prd.md**: Guides user to create the file first
- **Invalid responses**: Re-prompts with valid options
- **Platform detection failure**: Falls back to manual selection
- **Workflow launch failure**: Validates installation and provides fix suggestions

## Next Steps After Launch

Once the workflow is triggered:

1. **Follow Agent Sequence**: Each agent will create specific deliverables
2. **Save Outputs**: Copy generated documents to your docs/ folder as instructed  
3. **Review and Validate**: Use PO agent for document validation
4. **Begin Development**: Start story implementation with mobile-developer agent
5. **Quality Assurance**: Use mobile-qa agent for testing and review

---

**Related Files:**
- Agent definitions in `.appiq/agents/`
- Workflow files in `.appiq/workflows/`
- Templates in `.appiq/templates/`
- Project configuration in `.appiq/config/`
EOF

# Update Claude settings to include appiq command permissions
echo -e "${BLUE}⚙️ Updating Claude settings...${NC}"

SETTINGS_FILE="${CLAUDE_DIR}/settings.local.json"

# Create settings file if it doesn't exist
if [ ! -f "${SETTINGS_FILE}" ]; then
    cat > "${SETTINGS_FILE}" << 'EOF'
{
  "permissions": {
    "allow": [
      "Bash(ls:*)",
      "Bash(curl:*)",
      "Bash(git add:*)",
      "Bash(git commit:*)",
      "Bash(git push:*)"
    ],
    "deny": []
  },
  "appiq": {
    "enabled": true,
    "mobile_workflows": true,
    "auto_detection": true
  }
}
EOF
else
    # Merge with existing settings
    echo -e "${YELLOW}📝 Merging with existing Claude settings...${NC}"
    
    # Backup existing settings
    cp "${SETTINGS_FILE}" "${SETTINGS_FILE}.backup"
    
    # Add APPIQ configuration (simple append for now)
    if ! grep -q '"appiq"' "${SETTINGS_FILE}"; then
        # Remove closing brace and add APPIQ config
        sed -i.tmp '$ s/}//' "${SETTINGS_FILE}"
        cat >> "${SETTINGS_FILE}" << 'EOF'
  "appiq": {
    "enabled": true,
    "mobile_workflows": true,
    "auto_detection": true
  }
}
EOF
        rm -f "${SETTINGS_FILE}.tmp"
    fi
fi

echo -e "${GREEN}✅ Claude Code integration installed successfully!${NC}"
echo -e "${YELLOW}💡 You can now use ${CYAN}/appiq${YELLOW} in Claude Code to start mobile development${NC}"
echo ""
echo -e "${BLUE}📋 Files created:${NC}"
echo "• ${COMMANDS_DIR}/appiq.md - Slash command definition"
echo "• ${SETTINGS_FILE} - Updated settings with APPIQ support"
echo ""
echo -e "${YELLOW}🔄 Please restart Claude Code to activate the new command${NC}"