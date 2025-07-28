# APPIQ Method - Deployment System

## Overview

This deployment system provides multiple ways to install APPIQ Method in any project folder with a single command.

## 🚀 Quick Installation Options

### Option 1: One-Command Install (Recommended)
```bash
# Download and install in one command
curl -fsSL https://raw.githubusercontent.com/Viktor-Hermann/APPIQ-METHOD/main/deployment/quick-install.sh | bash
```

### Option 2: Download and Run
```bash
# Download the installer
wget https://github.com/Viktor-Hermann/APPIQ-METHOD/releases/latest/download/appiq_installer.sh

# Run in your project folder
bash appiq_installer.sh
```

### Option 3: Manual Copy
1. Download `appiq_installer.sh` from releases
2. Copy to your project folder
3. Run: `bash appiq_installer.sh`

## 📦 What Gets Installed

### Directory Structure
```
your-project/
├── .appiq/                     # APPIQ Method core files
│   ├── bmad-core/              # Core agents and workflows
│   │   ├── agents/             # Universal development agents
│   │   │   ├── analyst.md
│   │   │   ├── architect.md
│   │   │   ├── dev.md
│   │   │   ├── pm.md
│   │   │   └── ux-expert.md
│   │   ├── workflows/          # Universal development workflows
│   │   │   ├── greenfield-fullstack.yaml    # Web/Desktop projects
│   │   │   ├── brownfield-fullstack.yaml    # Web/Desktop projects
│   │   │   ├── greenfield-service.yaml      # Backend projects
│   │   │   └── brownfield-service.yaml      # Backend projects
│   │   ├── templates/          # Document templates
│   │   │   ├── prd-tmpl.yaml
│   │   │   ├── architecture-tmpl.yaml
│   │   │   └── project-brief-tmpl.yaml
│   ├── expansion-packs/        # Specialized development packs
│   │   └── bmad-mobile-app-dev/   # Mobile development expansion
│   │       ├── agents/         # Mobile-specific agents
│   │       ├── workflows/      # Mobile workflows (Flutter/React Native)
│   │       └── templates/      # Mobile templates
│   ├── config/                 # IDE configurations
│   │   ├── project.json
│   │   ├── claude.json
│   │   ├── cursor.json
│   │   └── windsurf.json
│   ├── scripts/                # Helper scripts
│   │   └── appiq               # Project status/validation tool
│   └── README.md               # Local documentation
├── docs/                       # Project documentation
│   └── main_prd.md            # Product Requirements Document (template)
└── README.md                   # Updated with APPIQ section
```

### Key Files Created
- **`.appiq/`** - Complete APPIQ Method installation
- **`docs/main_prd.md`** - PRD template (customize for your project)
- **Helper script** - `.appiq/scripts/appiq` for status and validation
- **IDE configs** - Ready-to-use configurations for Claude, Cursor, Windsurf

## 🎯 Usage After Installation

### 1. Customize Your PRD
Edit `docs/main_prd.md` with your project requirements:
```markdown
# Main Product Requirements Document

## Project Overview
**Project Name:** Your Mobile App
**Platform:** [ ] iOS [ ] Android [ ] Cross-platform

## Core Features
- Feature 1
- Feature 2
- Feature 3

## Technical Requirements
- Framework: Flutter/React Native
- Performance requirements
- Security requirements
```

### 2. Start Development Workflow
Use `/appiq` command in your IDE:

**Claude Code:**
```
/appiq
```

**Cursor:**
```
/appiq
# or Ctrl+Alt+A (Cmd+Alt+A on Mac)
```

**Windsurf:**
```
/appiq
```

**Any IDE with chat:**
```
/appiq
```

### 3. Follow Interactive Flow
The system will guide you through:
1. **Project Type**: Greenfield (new) or Brownfield (existing)
2. **Platform**: Flutter or React Native
3. **PRD Check**: Validates your `docs/main_prd.md`
4. **Workflow Launch**: Automatically starts appropriate development workflow

## 🔧 Helper Commands

### Project Status
```bash
./.appiq/scripts/appiq status
```
Shows:
- Project name and type
- PRD file status
- APPIQ version

### Validate Setup
```bash
./.appiq/scripts/appiq validate
```
Checks:
- Required files exist
- Directory structure is correct
- Configuration is valid

## 📱 Available Workflows

### Greenfield (New Apps)
- **Flutter Greenfield**: Complete Flutter app development from concept to deployment
- **React Native Greenfield**: Complete React Native app development

### Brownfield (Existing Apps)
- **Flutter Brownfield**: Add features to existing Flutter apps
- **React Native Brownfield**: Add features to existing React Native apps

## 🎨 IDE Integration

### Claude Code
- Native `/appiq` command support
- Automatic context awareness
- File system integration

### Cursor
- Chat command `/appiq`
- Command palette integration
- Keyboard shortcut: `Ctrl+Alt+A`
- VS Code-style workspace settings

### Windsurf
- AI-powered project analysis
- Smart platform detection
- Integrated task tracking

### Universal Support
Works with any IDE that supports chat interactions.

## 🛠️ Customization

### Project Configuration
Edit `.appiq/config/project.json`:
```json
{
  "project_name": "Your App",
  "project_type": "flutter",
  "mobile_platform": "flutter",
  "workflow_preference": "greenfield",
  "auto_detect": true
}
```

### IDE-Specific Settings
- **Claude**: `.appiq/config/claude.json`
- **Cursor**: `.appiq/config/cursor.json`
- **Windsurf**: `.appiq/config/windsurf.json`

## 🔄 Updates

### Update APPIQ Method
```bash
./.appiq/scripts/appiq update
```

Or re-run the installer:
```bash
bash appiq_installer.sh --update
```

## 🚨 Troubleshooting

### Common Issues

#### "Command /appiq not recognized"
- Verify APPIQ installation: `./.appiq/scripts/appiq validate`
- Check IDE configuration files in `.appiq/config/`
- Restart your IDE

#### "main_prd.md not found"
- Create the file: `touch docs/main_prd.md`
- Customize with your project requirements
- Run validation: `./.appiq/scripts/appiq validate`

#### "Platform detection failed"
- Manually specify platform in interactive flow
- Check for `pubspec.yaml` (Flutter) or `package.json` (React Native)
- Use option 3 for manual platform selection

### Debug Mode
Enable verbose logging:
```bash
export APPIQ_DEBUG=true
./.appiq/scripts/appiq status
```

### Reset Installation
Remove and reinstall:
```bash
rm -rf .appiq docs/main_prd.md
bash appiq_installer.sh
```

## 📚 Documentation

### Local Documentation
- `.appiq/README.md` - Local setup guide
- `docs/main_prd.md` - Your project requirements
- Project README updated with APPIQ section

### Online Resources
- [APPIQ Method Documentation](https://your-docs-url.com)
- [Mobile Development Guide](https://your-docs-url.com/mobile)
- [Workflow Reference](https://your-docs-url.com/workflows)

## 🤝 Support

### Get Help
1. Run validation: `./.appiq/scripts/appiq validate`
2. Check status: `./.appiq/scripts/appiq status`
3. Review local docs: `.appiq/README.md`
4. Submit issues: [GitHub Issues](https://github.com/Viktor-Hermann/APPIQ-METHOD/issues)

### Feature Requests
Open an issue with:
- Use case description
- Proposed solution
- Example workflow

## 🔒 Security

### What's Installed
- Local files only (no external dependencies)
- No network access required after installation
- No sensitive data collected
- Open source and auditable

### File Permissions
- Scripts are executable by user only
- Configuration files are user-readable
- No system-wide changes

## 📄 License

APPIQ Method is released under [Your License] license.

---

## 🎉 Success Examples

### Complete Installation Flow
```bash
# 1. Navigate to your project
cd my-mobile-app

# 2. Install APPIQ Method
curl -fsSL https://raw.githubusercontent.com/Viktor-Hermann/APPIQ-METHOD/main/deployment/quick-install.sh | bash

# 3. Customize PRD
nano docs/main_prd.md

# 4. Start development
# Open IDE and use: /appiq
```

### Typical Usage Session
```
User: /appiq

🚀 Welcome to APPIQ Method Mobile Development!

What type of mobile project are you working on?
1. Greenfield - New mobile app development
2. Brownfield - Enhancing existing mobile app

User: 1

📱 Platform Selection for New Mobile App:
1. Flutter - Cross-platform with Dart
2. React Native - Cross-platform with React/JavaScript

User: 1

📋 Checking for main_prd.md in your /docs/ folder...
✅ Found: docs/main_prd.md

✅ Perfect! Launching Greenfield Flutter Mobile Development Workflow...

@analyst - Please begin with creating a mobile-focused project brief...
```

With this deployment system, users can install APPIQ Method in any project with a single command and immediately start using the `/appiq` interactive workflow!