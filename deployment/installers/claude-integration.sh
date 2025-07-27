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
# /appiq - APPIQ Method Mobile Development Launcher

**Quick Start**: `/appiq` - Interactive mobile development workflow launcher

## Overview

The `/appiq` command provides an interactive way to launch the APPIQ Method mobile development workflow. It guides users through project type selection and automatically triggers the appropriate mobile development workflow based on their responses.

## Usage

```
/appiq
```

## Interactive Flow

When you use `/appiq`, the system will interactively guide you through:

### Step 1: Project Type Selection
```
🚀 Welcome to APPIQ Method Mobile Development!

What type of mobile project are you working on?

1. Greenfield - New mobile app development (Flutter or React Native)
2. Brownfield - Enhancing existing mobile app

Please respond with 1 or 2:
```

### Step 2: Platform Selection (Greenfield) or Detection (Brownfield)

**For Greenfield (New Projects):**
```
📱 Platform Selection for New Mobile App:

Which mobile platform do you want to target?

1. Flutter - Cross-platform with Dart
2. React Native - Cross-platform with React/JavaScript
3. Let APPIQ Method recommend based on requirements

Please respond with 1, 2, or 3:
```

**For Brownfield (Existing Projects):**
```
📱 Existing Mobile App Platform Detection:

What platform is your existing mobile app built with?

1. Flutter - Dart-based cross-platform app
2. React Native - React/JavaScript-based app
3. Not sure - Let APPIQ Method analyze the codebase

Please respond with 1, 2, or 3:
```

### Step 3: PRD Validation
```
📋 Checking for main_prd.md in your /docs/ folder...

Do you have a main_prd.md file in your /docs/ folder?
(You should create this manually and place it there before proceeding)

Please respond with yes or no:
```

### Step 4: Workflow Launch

Based on your responses, the system automatically launches the appropriate workflow:

**Greenfield Workflows:**
- `mobile-greenfield-flutter.yaml` - New Flutter app development
- `mobile-greenfield-react-native.yaml` - New React Native app development

**Brownfield Workflows:**
- `mobile-brownfield-flutter.yaml` - Existing Flutter app enhancement
- `mobile-brownfield-react-native.yaml` - Existing React Native app enhancement

## Implementation

When `/appiq` is executed, it performs the following logic:

```javascript
// Project type detection
let projectType = await askUser("What type of mobile project? (1) Greenfield (2) Brownfield");

let platform;
if (projectType === "1") {
    // Greenfield - ask for platform choice
    platform = await askUser("Platform? (1) Flutter (2) React Native (3) Recommend");
    if (platform === "3") {
        platform = await recommendPlatform();
    }
} else {
    // Brownfield - detect or ask for platform
    platform = await detectPlatform() || await askUser("Platform? (1) Flutter (2) React Native (3) Analyze");
}

// PRD validation
let hasPrd = await checkFileExists("docs/main_prd.md");
if (!hasPrd) {
    await showPrdGuidance();
    return;
}

// Launch appropriate workflow
let workflowFile = getWorkflowFile(projectType, platform);
await launchWorkflow(workflowFile);
```

## Workflow Mapping

The command maps user selections to specific workflow files:

| Project Type | Platform | Workflow File |
|--------------|----------|---------------|
| Greenfield | Flutter | `mobile-greenfield-flutter.yaml` |
| Greenfield | React Native | `mobile-greenfield-react-native.yaml` |
| Brownfield | Flutter | `mobile-brownfield-flutter.yaml` |
| Brownfield | React Native | `mobile-brownfield-react-native.yaml` |

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