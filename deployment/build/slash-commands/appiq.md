# /appiq - APPIQ Method Mobile Development Launcher

**Quick Start**: `/appiq` - Interactive mobile development workflow launcher

## Overview

The `/appiq` command provides an interactive way to launch the APPIQ Method mobile development workflow. It guides users through project type selection and automatically triggers the appropriate mobile development workflow based on their responses.

## Command Usage

```
/appiq
```

## Interactive Flow

### Step 1: Project Type Selection
The command will ask:
```
🚀 Welcome to APPIQ Method Mobile Development!

What type of mobile project are you working on?

1. Greenfield - New mobile app development (Flutter or React Native)
2. Brownfield - Enhancing existing mobile app

Please respond with 1 or 2:
```

### Step 2: PRD Location Check
After selection, it will check:
```
📋 Checking for main_prd.md in your /docs/ folder...

Do you have a main_prd.md file in your /docs/ folder?
(You should create this manually and place it there before proceeding)

Please respond with yes or no:
```

### Step 3: Platform Selection (Greenfield only)
For new projects, additional platform selection:
```
📱 Platform Selection for New Mobile App:

Which mobile platform do you want to target?

1. Flutter - Cross-platform with Dart
2. React Native - Cross-platform with React/JavaScript
3. Let APPIQ Method recommend based on requirements

Please respond with 1, 2, or 3:
```

### Step 4: Workflow Activation
Based on responses, automatically triggers the appropriate workflow:

**Greenfield Projects:**
- `mobile-greenfield-flutter.yaml` - New Flutter app
- `mobile-greenfield-react-native.yaml` - New React Native app

**Brownfield Projects:**
- `mobile-brownfield-flutter.yaml` - Existing Flutter app enhancement
- `mobile-brownfield-react-native.yaml` - Existing React Native app enhancement

## Automatic Workflow Triggering

The command will automatically:

1. **Validate prerequisites** - Check for main_prd.md existence
2. **Set up mobile environment** - Initialize mobile-specific configurations
3. **Load appropriate workflow** - Based on project type and platform selection
4. **Start agent orchestration** - Begin with the first agent in the selected workflow
5. **Provide guidance** - Show next steps and expected outputs

## Example Interaction

```
User: /appiq

🚀 Welcome to APPIQ Method Mobile Development!

What type of mobile project are you working on?

1. Greenfield - New mobile app development (Flutter or React Native)
2. Brownfield - Enhancing existing mobile app

Please respond with 1 or 2:

User: 1

📱 Platform Selection for New Mobile App:

Which mobile platform do you want to target?

1. Flutter - Cross-platform with Dart
2. React Native - Cross-platform with React/JavaScript
3. Let APPIQ Method recommend based on requirements

Please respond with 1, 2, or 3:

User: 1

📋 Checking for main_prd.md in your /docs/ folder...

Do you have a main_prd.md file in your /docs/ folder?
(You should create this manually and place it there before proceeding)

Please respond with yes or no:

User: yes

✅ Perfect! Launching Greenfield Flutter Mobile Development Workflow...

🎯 Starting with: mobile-greenfield-flutter.yaml
📍 First Agent: analyst (creating project-brief.md)
📂 Expected Output: docs/project-brief.md

The mobile development workflow will now guide you through:
1. Mobile-focused project brief
2. Mobile-specific PRD creation 
3. Flutter platform validation
4. Mobile UX design system
5. Flutter architecture planning
6. Mobile security review
7. Story creation and development

@analyst - Please begin with creating a mobile-focused project brief considering app store landscape, device capabilities, and mobile user behavior.
```

## Prerequisites

Before running `/appiq`, ensure you have:

1. **Project Structure**: A docs/ folder in your project root
2. **main_prd.md**: Your main Product Requirements Document in docs/main_prd.md
3. **APPIQ Method**: This tool installed and configured
4. **Mobile Tools**: Flutter SDK or React Native environment set up

## File Structure After Setup

```
your-project/
├── docs/
│   ├── main_prd.md (manually created)
│   ├── project-brief.md (generated)
│   ├── mobile-prd.md (generated)
│   ├── mobile-architecture.md (generated)
│   └── ... (other workflow outputs)
├── src/ or lib/ (your code)
└── ... (project files)
```

## Workflow Integration

The `/appiq` command integrates with the complete APPIQ Method ecosystem:

- **Agents**: All mobile-specific agents (mobile-pm, mobile-architect, mobile-developer, etc.)
- **Templates**: Mobile-optimized templates for all document types
- **Checklists**: Mobile development validation checklists
- **Teams**: Pre-configured mobile development team structures
- **Tasks**: Mobile-specific development tasks and utilities

## Error Handling

The command will provide helpful guidance for common issues:

- **Missing main_prd.md**: Guides user to create the file first
- **Invalid responses**: Re-prompts with valid options
- **Workflow conflicts**: Checks for existing workflows and handles gracefully
- **Missing dependencies**: Validates Flutter/React Native environment

## Next Steps After Launch

Once the workflow is triggered:

1. **Follow Agent Sequence**: Each agent will create specific deliverables
2. **Save Outputs**: Copy generated documents to your docs/ folder as instructed
3. **Review and Validate**: Use PO agent for document validation
4. **Begin Development**: Start story implementation with mobile-developer agent
5. **Quality Assurance**: Use mobile-qa agent for testing and review

## Support and Troubleshooting

For issues with the `/appiq` command:
- Check that main_prd.md exists in docs/ folder
- Verify APPIQ Method installation and configuration
- Ensure mobile development environment is set up
- Review workflow documentation for specific platform requirements

---

**Related Commands:**
- `/help` - General APPIQ Method help
- View available workflows in `expansion-packs/bmad-mobile-app-dev/workflows/`
- View mobile agents in `expansion-packs/bmad-mobile-app-dev/agents/`