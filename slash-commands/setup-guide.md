# APPIQ Command Setup Guide

## Overview

This guide explains how to set up and configure the `/appiq` slash command system for mobile development across different IDEs and AI assistants.

## System Requirements

### Prerequisites
- APPIQ Method installation
- Mobile development environment (Flutter SDK or React Native)
- Git repository for your project
- docs/ folder structure in your project

### Supported IDEs
- ✅ Claude Code (recommended)
- ✅ Cursor AI Code Editor
- ✅ Windsurf IDE
- ✅ Any IDE with chat/AI assistant support

## Installation Steps

### 1. Verify APPIQ Method Installation

Ensure you have the complete APPIQ Method installation with the mobile expansion pack:

```bash
# Check APPIQ Method structure
ls -la expansion-packs/bmad-mobile-app-dev/

# Expected structure:
# ├── agents/
# ├── checklists/
# ├── templates/
# ├── workflows/
# └── teams/
```

### 2. Set Up Project Structure

Create the required project structure:

```bash
# In your project root
mkdir -p docs
touch docs/main_prd.md

# Your project should look like:
your-project/
├── docs/
│   └── main_prd.md (create this manually)
├── src/ or lib/ (your code)
└── README.md
```

### 3. Create main_prd.md

Create your Product Requirements Document in `docs/main_prd.md`:

```markdown
# Main Product Requirements Document

## Project Overview
[Describe your mobile app project]

## Target Platforms
- [ ] iOS
- [ ] Android
- [ ] Cross-platform (Flutter/React Native)

## Core Features
1. Feature 1
2. Feature 2
3. Feature 3

## Technical Requirements
- Platform: [Flutter/React Native/Native]
- Performance requirements
- Device compatibility
- Third-party integrations

## User Stories
### Epic 1: [Epic Name]
- User story 1
- User story 2

### Epic 2: [Epic Name]
- User story 3
- User story 4

## Success Criteria
- Metric 1
- Metric 2
- Metric 3
```

## IDE-Specific Setup

### Claude Code Setup

1. **Install APPIQ Method in Claude Code**
   ```bash
   # If not already installed, clone the APPIQ Method
   git clone [APPIQ-METHOD-REPO] ~/.claude-code/appiq-method
   ```

2. **Configure Slash Commands**
   
   Add to your Claude Code configuration:
   ```json
   {
     "slash_commands": {
       "/appiq": {
         "description": "Interactive APPIQ Method mobile development launcher",
         "handler": "appiq-handler",
         "expansion_pack": "bmad-mobile-app-dev"
       }
     }
   }
   ```

3. **Usage**
   ```
   # In any Claude Code chat
   /appiq
   ```

### Cursor AI Setup

1. **Install as Extension** (if available)
   - Open Command Palette (`Ctrl+Shift+P`)
   - Search for "APPIQ Method"
   - Install the extension

2. **Manual Setup** (alternative)
   
   Create a Cursor workspace setting:
   ```json
   {
     "appiq.enabled": true,
     "appiq.mobile_expansion": true,
     "appiq.workflow_path": "./expansion-packs/bmad-mobile-app-dev/workflows/"
   }
   ```

3. **Usage**
   ```
   # In Cursor chat
   /appiq
   
   # Or via Command Palette
   Ctrl+Shift+P → "APPIQ: Launch Mobile Workflow"
   
   # Or keyboard shortcut
   Ctrl+Alt+A (Windows/Linux)
   Cmd+Alt+A (Mac)
   ```

### Windsurf IDE Setup

1. **Enable APPIQ Integration**
   
   In Windsurf settings:
   ```json
   {
     "extensions": {
       "appiq-method": {
         "enabled": true,
         "mobile_workflows": true,
         "auto_detection": true
       }
     }
   }
   ```

2. **Configure Project Context**
   
   Windsurf will automatically detect mobile projects and offer APPIQ workflows.

3. **Usage**
   ```
   # In Windsurf chat
   /appiq
   
   # Windsurf will auto-analyze your project and provide context
   ```

### Generic AI Assistant Setup

For other IDEs or AI assistants:

1. **Copy Universal Implementation**
   ```bash
   # Copy the universal handler to your IDE's plugin directory
   cp slash-commands/ide-integrations/universal-appiq.md \
      ~/.your-ide/plugins/appiq-handler.md
   ```

2. **Configure Chat Commands**
   
   Add command recognition for `/appiq` in your AI assistant's configuration.

3. **Usage**
   ```
   # In any chat interface
   /appiq
   ```

## Configuration Options

### Global Configuration

Create `~/.appiq/config.json`:

```json
{
  "default_platform": "flutter",
  "auto_detect_projects": true,
  "workflow_templates": {
    "mobile": "bmad-mobile-app-dev"
  },
  "preferred_ide": "claude",
  "prd_template": "mobile-prd-tmpl.yaml"
}
```

### Project-Specific Configuration

Create `.appiq/config.json` in your project root:

```json
{
  "project_type": "mobile",
  "platform": "flutter",
  "workflow_preference": "greenfield",
  "auto_launch": false,
  "required_files": [
    "docs/main_prd.md"
  ],
  "output_directory": "docs/"
}
```

## Troubleshooting

### Common Issues

#### Issue: "/appiq command not recognized"
**Solution:**
1. Verify APPIQ Method installation
2. Check slash command configuration in your IDE
3. Restart your IDE/assistant
4. Try the full command: "Launch APPIQ mobile development workflow"

#### Issue: "main_prd.md not found"
**Solution:**
1. Create `docs/` folder in project root
2. Create `docs/main_prd.md` with project requirements
3. Verify file path is correct
4. Check file permissions

#### Issue: "Platform detection failed"
**Solution:**
1. Manually specify platform when prompted
2. Check for Flutter (`pubspec.yaml`) or React Native (`package.json`) files
3. Ensure project structure is correct
4. Use option 3 for manual platform selection

#### Issue: "Workflow launch failed"
**Solution:**
1. Verify expansion pack installation
2. Check workflow file existence
3. Ensure all required templates are available
4. Review IDE error logs

### Debug Mode

Enable debug mode for detailed logging:

```bash
# Set environment variable
export APPIQ_DEBUG=true

# Or in IDE configuration
{
  "appiq.debug": true,
  "appiq.verbose_logging": true
}
```

### Validation Commands

Test your setup:

```bash
# Check APPIQ Method installation
appiq --version

# Validate project structure
appiq validate-project

# Test workflow files
appiq test-workflows mobile

# Check IDE integration
appiq test-ide-integration
```

## Advanced Configuration

### Custom Workflow Paths

Override default workflow locations:

```json
{
  "appiq": {
    "workflow_paths": [
      "./custom-workflows/",
      "./expansion-packs/bmad-mobile-app-dev/workflows/",
      "~/.appiq/workflows/"
    ]
  }
}
```

### IDE-Specific Optimizations

#### Claude Code Optimizations
```json
{
  "claude": {
    "context_awareness": true,
    "file_tree_integration": true,
    "agent_suggestions": true
  }
}
```

#### Cursor Optimizations
```json
{
  "cursor": {
    "command_palette_integration": true,
    "sidebar_progress": true,
    "file_navigation": true
  }
}
```

#### Windsurf Optimizations
```json
{
  "windsurf": {
    "ai_analysis": true,
    "task_tracking": true,
    "smart_recommendations": true
  }
}
```

## Usage Examples

### Complete Flow Example

```
1. User: /appiq

2. APPIQ: 🚀 Welcome to APPIQ Method Mobile Development!
   What type of mobile project are you working on?
   1. Greenfield - New mobile app development
   2. Brownfield - Enhancing existing mobile app
   Please respond with 1 or 2:

3. User: 1

4. APPIQ: 📱 Platform Selection for New Mobile App:
   Which mobile platform do you want to target?
   1. Flutter - Cross-platform with Dart
   2. React Native - Cross-platform with React/JavaScript
   3. Let APPIQ Method recommend based on requirements
   Please respond with 1, 2, or 3:

5. User: 1

6. APPIQ: 📋 Checking for main_prd.md in your /docs/ folder...
   Do you have a main_prd.md file in your /docs/ folder?
   Please respond with yes or no:

7. User: yes

8. APPIQ: ✅ Perfect! Launching Greenfield Flutter Mobile Development Workflow...
   🎯 Starting with: mobile-greenfield-flutter.yaml
   📍 First Agent: analyst (creating project-brief.md)
   
   @analyst - Please begin with creating a mobile-focused project brief...
```

## Support and Updates

### Getting Help
- Check troubleshooting section above
- Review IDE-specific integration guides
- Submit issues to APPIQ Method repository
- Join community discussions

### Updates
The `/appiq` command system is updated with the APPIQ Method. To get the latest features:

```bash
# Update APPIQ Method
git pull origin main

# Update expansion packs
cd expansion-packs/bmad-mobile-app-dev
git pull origin main

# Restart your IDE to load new configurations
```

### Feature Requests
To request new features for the `/appiq` command:
1. Open an issue in the APPIQ Method repository
2. Tag it with `enhancement` and `mobile-development`
3. Describe your use case and proposed solution

---

With this setup complete, you can now use `/appiq` to launch interactive mobile development workflows in any supported IDE or AI assistant.