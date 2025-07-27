# 🚀 APPIQ Method - Complete Deployment Guide

## Overview

The APPIQ Method deployment system allows you to package and distribute the complete mobile development workflow system as a single, self-contained installer.

## 📦 Deployment Files Created

### Core Installation Scripts

1. **`appiq_installer.sh`** - Single-file installer with embedded components
   - Self-contained with all necessary files
   - No external dependencies
   - Works offline after download
   - Size: ~1MB

2. **`init_appiq.sh`** - Development installer (requires git/network)
   - Downloads latest files from repository
   - Development version with full features
   - Requires internet connection

3. **`quick-install.sh`** - One-command installer
   - Downloads and runs installer automatically
   - Simplest user experience
   - Requires curl/wget

### Build Scripts

4. **`package.sh`** - Creates the single-file installer
5. **`build-release.sh`** - Creates complete release package
6. **`test-install.sh`** - Tests installation in temporary directory

## 🎯 Usage Scenarios

### For End Users (Project Setup)

#### Scenario 1: One-Command Install (Recommended)
```bash
# Navigate to your project folder
cd my-mobile-app

# Install APPIQ Method
curl -fsSL https://raw.githubusercontent.com/Viktor-Hermann/APPIQ-METHOD/main/deployment/quick-install.sh | bash

# Customize PRD and start development
nano docs/main_prd.md
# Then use /appiq in your IDE
```

#### Scenario 2: Download and Run
```bash
# Download the installer
wget https://github.com/Viktor-Hermann/APPIQ-METHOD/releases/latest/download/appiq_installer.sh

# Run in your project
cd my-project
bash appiq_installer.sh
```

#### Scenario 3: Offline Installation
```bash
# Copy appiq_installer.sh to project folder (via USB, network share, etc.)
cp /path/to/appiq_installer.sh ./
bash appiq_installer.sh
```

### For Developers (Creating Packages)

#### Build Single-File Installer
```bash
cd deployment
bash package.sh

# Output: dist/appiq_installer.sh (ready to distribute)
```

#### Build Complete Release
```bash
cd deployment  
bash build-release.sh

# Output: Complete release package with documentation
```

#### Test Installation
```bash
# Create test directory
mkdir /tmp/test-appiq && cd /tmp/test-appiq

# Test installation
bash /path/to/appiq_installer.sh

# Validate installation
./.appiq/scripts/appiq validate
```

## 📁 What Gets Installed

### Directory Structure Created
```
your-project/
├── .appiq/                           # APPIQ Method core
│   ├── agents/                       # Mobile development agents
│   │   ├── mobile-pm.md
│   │   ├── mobile-architect.md
│   │   ├── mobile-developer.md
│   │   ├── mobile-qa.md
│   │   ├── mobile-security.md
│   │   ├── mobile-analytics.md
│   │   └── mobile-ux-expert.md
│   ├── workflows/                    # Mobile workflows
│   │   ├── mobile-greenfield-flutter.yaml
│   │   ├── mobile-greenfield-react-native.yaml
│   │   ├── mobile-brownfield-flutter.yaml
│   │   └── mobile-brownfield-react-native.yaml
│   ├── templates/                    # Document templates
│   │   ├── mobile-prd-tmpl.yaml
│   │   ├── mobile-architecture-tmpl.yaml
│   │   └── mobile-story-tmpl.yaml
│   ├── checklists/                   # Validation checklists
│   │   └── mobile-development-checklist.md
│   ├── teams/                        # Team configurations
│   │   ├── mobile-team-flutter.yaml
│   │   ├── mobile-team-react-native.yaml
│   │   └── mobile-team-cross-platform.yaml
│   ├── config/                       # IDE configurations
│   │   ├── project.json
│   │   ├── claude.json
│   │   ├── cursor.json
│   │   └── windsurf.json
│   ├── scripts/                      # Helper utilities
│   │   └── appiq                     # Status/validation tool
│   └── README.md                     # Local documentation
├── docs/                             # Project documentation
│   └── main_prd.md                   # PRD template (customize!)
└── README.md                         # Updated with APPIQ section
```

### Key Components Installed
- **8 Mobile Agents**: Specialized for mobile development
- **4 Workflows**: Greenfield/Brownfield × Flutter/React Native
- **Multiple Templates**: PRD, Architecture, Story templates
- **Comprehensive Checklist**: Mobile development validation
- **Team Configurations**: Pre-configured mobile teams
- **IDE Integration**: Claude, Cursor, Windsurf configurations
- **Helper Scripts**: Project status and validation tools

## 🔧 Post-Installation

### 1. Customize Your PRD
The installer creates `docs/main_prd.md` with a template. Customize it:

```markdown
# Main Product Requirements Document

## Project Overview
**Project Name:** Your Actual App Name
**Platform:** [x] iOS [x] Android [ ] Cross-platform

## Core Features
### Epic 1: Authentication
- [ ] User registration with email
- [ ] Social login (Google, Apple)
- [ ] Password reset functionality

### Epic 2: Core Features
- [ ] [Your main feature]
- [ ] [Secondary feature]
- [ ] [Additional feature]

## Technical Requirements
- **Framework:** Flutter  # or React Native
- **State Management:** BLoC  # or Riverpod, Redux, etc.
- **Backend:** Firebase  # or your backend
- **Performance:** App launch < 3 seconds
```

### 2. Start Development Workflow
Open your IDE and use the `/appiq` command:

**Claude Code:**
```
/appiq
```

**Cursor:**
```
/appiq
# or press Ctrl+Alt+A (Cmd+Alt+A on Mac)
```

**Windsurf:**
```
/appiq
```

### 3. Follow Interactive Flow
The system guides you through:
1. **Project Type**: Greenfield (new) or Brownfield (existing)
2. **Platform**: Flutter or React Native  
3. **PRD Validation**: Checks your customized PRD
4. **Workflow Launch**: Automatically starts appropriate workflow

### 4. Validate Installation
```bash
# Check status
./.appiq/scripts/appiq status

# Validate setup
./.appiq/scripts/appiq validate

# View help
./.appiq/scripts/appiq help
```

## 🎨 IDE Integration Details

### Claude Code
- **Native Support**: `/appiq` command recognized natively
- **Context Aware**: Understands project structure automatically
- **File Integration**: Can read/write project files directly

### Cursor
- **Chat Command**: Use `/appiq` in chat interface
- **Command Palette**: "APPIQ: Launch Mobile Workflow"
- **Keyboard Shortcut**: `Ctrl+Alt+A` (customizable)
- **Workspace Settings**: Automatic .vscode/settings.json configuration

### Windsurf
- **AI Analysis**: Automatically analyzes project structure
- **Smart Detection**: Detects Flutter/React Native automatically
- **Task Integration**: Creates task tracking for workflow steps
- **Project Context**: Maintains context across sessions

### Universal (Any IDE)
- **Chat Interface**: Works with any IDE supporting chat
- **Fallback Mode**: Asks user for information when auto-detection fails
- **Manual Guidance**: Provides step-by-step instructions

## 🔄 Updates and Maintenance

### Update APPIQ Method
```bash
# Using helper script
./.appiq/scripts/appiq update

# Or re-run installer
bash appiq_installer.sh --update

# Or manual download
curl -fsSL https://raw.githubusercontent.com/Viktor-Hermann/APPIQ-METHOD/main/deployment/quick-install.sh | bash
```

### Check for Updates
```bash
# Compare versions
./.appiq/scripts/appiq status
cat .appiq/config/project.json | grep appiq_version
```

### Backup Configuration
```bash
# Backup your customizations
cp docs/main_prd.md docs/main_prd.backup.md
cp -r .appiq/config .appiq/config.backup
```

## 🚨 Troubleshooting

### Common Issues and Solutions

#### Issue: "Command /appiq not recognized"
```bash
# Check installation
./.appiq/scripts/appiq validate

# Verify IDE configuration
ls .appiq/config/

# Restart IDE and try again
```

#### Issue: "main_prd.md not found"
```bash
# Create the file
touch docs/main_prd.md

# Or re-run installer to recreate template
bash appiq_installer.sh
```

#### Issue: "Platform detection failed"
```bash
# Check project structure
ls -la

# For Flutter: Look for pubspec.yaml
# For React Native: Look for package.json with react-native dependency

# Manually specify platform when prompted
```

#### Issue: "Workflow launch failed"
```bash
# Validate all components
./.appiq/scripts/appiq validate

# Check workflow files
ls .appiq/workflows/

# Re-run installer if files are missing
bash appiq_installer.sh --update
```

### Debug Mode
```bash
# Enable verbose logging
export APPIQ_DEBUG=true

# Run status check with debug info
./.appiq/scripts/appiq status

# Check installation details
cat .appiq/config/project.json
```

### Reset Installation
```bash
# Complete reset (removes all APPIQ files)
rm -rf .appiq docs/main_prd.md

# Reinstall
bash appiq_installer.sh
```

## 📊 System Requirements

### Minimum Requirements
- **OS**: Linux, macOS, or Windows with WSL
- **Disk Space**: 10MB for installation
- **Dependencies**: Bash shell
- **Optional**: Git (for enhanced features)

### Recommended Setup
- **Mobile SDK**: Flutter SDK or React Native environment
- **IDE**: Claude Code, Cursor, or Windsurf
- **Project**: Git repository
- **Network**: Internet connection for initial download

### Supported Project Types
- ✅ Flutter projects (pubspec.yaml)
- ✅ React Native projects (package.json + react-native)
- ✅ New mobile projects (any directory)
- ✅ Existing mobile projects
- ⚠️ Other project types (basic support)

## 🎯 Success Metrics

### Installation Success Indicators
- ✅ `.appiq/` directory created with all components
- ✅ `docs/main_prd.md` exists (customizable template)
- ✅ Helper script works: `./.appiq/scripts/appiq status`
- ✅ Validation passes: `./.appiq/scripts/appiq validate`
- ✅ IDE recognizes `/appiq` command

### Development Workflow Success
- ✅ `/appiq` command starts interactive flow
- ✅ Platform detection works correctly
- ✅ PRD validation passes
- ✅ Appropriate workflow launches automatically
- ✅ First agent (@analyst) starts project brief creation

### Quality Indicators
- ✅ All agents respond correctly to @mentions
- ✅ Generated documents save to docs/ folder
- ✅ Workflow progression follows expected sequence
- ✅ Mobile-specific templates and checklists used
- ✅ Platform-specific guidance provided

## 📈 Distribution Strategy

### Release Process
1. **Build Package**: `bash build-release.sh`
2. **Test Installation**: Test in clean environment
3. **Create GitHub Release**: Upload to releases
4. **Update URLs**: Update download links in quick-install.sh
5. **Documentation**: Update README and installation guides

### Distribution Channels
- **GitHub Releases**: Primary distribution method
- **Direct Download**: For offline environments
- **Package Managers**: Future NPM/Homebrew packages
- **Documentation Sites**: Embedded installation guides

### Versioning
- **Semantic Versioning**: MAJOR.MINOR.PATCH
- **Release Notes**: Detailed changelog for each version
- **Compatibility**: Backward compatibility for configurations
- **Migration Guides**: When breaking changes occur

---

## 🎉 Conclusion

The APPIQ Method deployment system provides a complete, self-contained mobile development workflow that can be installed in any project with a single command. The system includes:

- **Complete Mobile Development Stack**: Agents, workflows, templates, checklists
- **Universal IDE Integration**: Works with Claude, Cursor, Windsurf, and others
- **Interactive Setup**: `/appiq` command for guided workflow selection  
- **Offline Capability**: Self-contained installer works without internet
- **Validation Tools**: Built-in status checking and problem diagnosis
- **Update Mechanism**: Easy updates while preserving customizations

### Quick Start Summary
```bash
# 1. Install in your project
curl -fsSL https://raw.githubusercontent.com/Viktor-Hermann/APPIQ-METHOD/main/deployment/quick-install.sh | bash

# 2. Customize your requirements
nano docs/main_prd.md

# 3. Start development
# Open IDE and use: /appiq
```

The system is now ready for production use and can be distributed to development teams for immediate mobile development workflow automation!