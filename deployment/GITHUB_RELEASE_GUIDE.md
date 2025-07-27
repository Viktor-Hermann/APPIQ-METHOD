# 🚀 GitHub Release Creation Guide

## Step-by-Step Instructions

### 1. Prepare Your Repository

First, ensure your code is committed and pushed to GitHub:

```bash
# Add all files to git
git add .

# Commit the changes
git commit -m "feat: Complete APPIQ Method mobile development system v1.0.0

- Add mobile expansion pack with Flutter/React Native support
- Implement /appiq interactive slash command system
- Create deployment system with single-file installer
- Add IDE integration for Claude, Cursor, Windsurf
- Include comprehensive mobile development workflows"

# Push to GitHub
git push origin main
```

### 2. Create a Git Tag

Create and push a version tag:

```bash
# Create a tag for version 1.0.0
git tag -a v1.0.0 -m "APPIQ Method v1.0.0 - Mobile Development Release

🚀 What's New:
- Complete mobile development workflow system
- Interactive /appiq command for all IDEs
- Single-file installer for easy deployment
- Flutter and React Native support
- 7 specialized mobile agents
- 4 complete mobile workflows
- Comprehensive mobile development checklist

📦 Installation:
curl -fsSL https://raw.githubusercontent.com/Viktor-Hermann/APPIQ-METHOD/main/deployment/quick-install.sh | bash

💡 Usage:
Use /appiq command in your IDE to start mobile development"

# Push the tag to GitHub
git push origin v1.0.0
```

### 3. Create GitHub Release via Web Interface

1. **Go to your repository on GitHub:**
   ```
   https://github.com/Viktor-Hermann/APPIQ-METHOD
   ```

2. **Navigate to Releases:**
   - Click on "Releases" (usually in the right sidebar)
   - Or go directly to: `https://github.com/Viktor-Hermann/APPIQ-METHOD/releases`

3. **Create New Release:**
   - Click "Create a new release"
   - Or click "Draft a new release"

4. **Fill in Release Details:**

   **Tag version:** `v1.0.0` (select the tag you created)
   
   **Release title:** `APPIQ Method v1.0.0 - Mobile Development System`
   
   **Description:** Copy this content:
   ```markdown
   # 🚀 APPIQ Method v1.0.0 - Mobile Development System

   ## Quick Start
   ```bash
   # One-command installation in any project folder
   curl -fsSL https://raw.githubusercontent.com/Viktor-Hermann/APPIQ-METHOD/main/deployment/quick-install.sh | bash
   
   # Then customize your PRD and use /appiq in your IDE
   ```

   ## 📱 What's New

   ### Complete Mobile Development Workflow
   - **Interactive Setup**: Use `/appiq` command in any IDE
   - **Platform Support**: Full Flutter and React Native workflows
   - **Smart Detection**: Automatic project type and platform detection
   - **IDE Integration**: Native support for Claude, Cursor, Windsurf

   ### Mobile Development Components
   - **7 Specialized Agents**: Mobile PM, Architect, Developer, QA, Security, Analytics, UX Expert
   - **4 Complete Workflows**: Greenfield/Brownfield × Flutter/React Native
   - **Comprehensive Checklist**: 485+ validation points for mobile development
   - **Mobile Templates**: PRD, Architecture, Story templates optimized for mobile
   - **Team Configurations**: Pre-configured mobile development teams

   ### Deployment System
   - **Single-File Installer**: `appiq_installer.sh` - complete system in one file
   - **One-Command Install**: `curl | bash` installation
   - **Offline Capable**: Works without internet after download
   - **Auto-Configuration**: Automatic IDE and project setup

   ## 🎯 Usage

   ### 1. Install in Your Project
   ```bash
   cd your-mobile-project
   curl -fsSL https://raw.githubusercontent.com/Viktor-Hermann/APPIQ-METHOD/main/deployment/quick-install.sh | bash
   ```

   ### 2. Customize Your Requirements
   ```bash
   nano docs/main_prd.md
   ```

   ### 3. Start Development
   Open your IDE (Claude, Cursor, Windsurf) and use:
   ```
   /appiq
   ```

   The system will interactively guide you through:
   1. Project type selection (Greenfield/Brownfield)
   2. Platform selection (Flutter/React Native)
   3. PRD validation
   4. Automatic workflow launch

   ## 📦 Files in This Release

   - **`appiq_installer.sh`** - Main installer (self-contained, ~60KB)
   - **`quick-install.sh`** - One-command downloader/installer
   - **`README.md`** - Complete documentation and setup guide
   - **`INSTALL_EXAMPLES.md`** - Installation examples for different scenarios
   - **`RELEASE_NOTES.md`** - Detailed release notes
   - **`VERSION`** - Version information and build details
   - **`CHECKSUMS.sha256`** - File integrity checksums

   ## 🔧 System Requirements

   - Unix-like system (Linux, macOS, WSL)
   - Bash shell
   - Git (optional)
   - Mobile development environment (Flutter SDK or React Native)

   ## 💡 IDE Support

   - ✅ **Claude Code**: Native `/appiq` command
   - ✅ **Cursor**: `/appiq` + Command Palette + `Ctrl+Alt+A`
   - ✅ **Windsurf**: `/appiq` with AI project analysis  
   - ✅ **Universal**: Any IDE with chat support

   ## 🛠️ What Gets Installed

   ```
   your-project/
   ├── .appiq/                    # Complete APPIQ system
   │   ├── agents/               # 7 mobile development agents
   │   ├── workflows/            # 4 mobile workflows
   │   ├── templates/            # Mobile-optimized templates
   │   ├── config/              # IDE configurations
   │   └── scripts/appiq        # Helper tool
   ├── docs/
   │   └── main_prd.md          # PRD template (customize!)
   └── README.md                # Updated with APPIQ section
   ```

   ## 🎉 Success Examples

   Typical workflow after installation:
   ```
   User: /appiq

   🚀 Welcome to APPIQ Method Mobile Development!
   What type of mobile project are you working on?
   1. Greenfield - New mobile app development
   2. Brownfield - Enhancing existing mobile app

   User: 1

   📱 Platform Selection:
   1. Flutter - Cross-platform with Dart
   2. React Native - Cross-platform with React/JavaScript

   User: 1

   ✅ Perfect! Launching Greenfield Flutter Mobile Development Workflow...
   @analyst - Please begin with mobile project brief creation...
   ```

   ## 🚨 Support

   - **Validate Setup**: `./.appiq/scripts/appiq validate`
   - **Check Status**: `./.appiq/scripts/appiq status`
   - **Get Help**: [Submit an Issue](https://github.com/Viktor-Hermann/APPIQ-METHOD/issues)
   - **Documentation**: See README.md in release files

   ## 🔄 Updates

   ```bash
   # Update to latest version
   ./.appiq/scripts/appiq update
   
   # Or re-run installer
   curl -fsSL https://raw.githubusercontent.com/Viktor-Hermann/APPIQ-METHOD/main/deployment/quick-install.sh | bash
   ```

   ---

   **Ready to revolutionize your mobile development workflow? Install now and use `/appiq` to get started!** 🚀
   ```

5. **Upload Release Files:**
   
   Drag and drop or click "Attach binaries" to upload these files from `deployment/dist/`:
   
   - ✅ **`appiq_installer.sh`** (Main installer - REQUIRED)
   - ✅ **`quick-install.sh`** (One-command installer)
   - ✅ **`README.md`** (Documentation)
   - ✅ **`INSTALL_EXAMPLES.md`** (Installation examples)
   - ✅ **`RELEASE_NOTES.md`** (Detailed release notes)
   - ✅ **`VERSION`** (Version info)
   - ✅ **`CHECKSUMS.sha256`** (File integrity)

6. **Release Settings:**
   - ☑️ **Set as the latest release** (checked)
   - ☐ **This is a pre-release** (unchecked)
   - ☐ **Create a discussion for this release** (optional)

7. **Publish Release:**
   - Click "Publish release"

### 4. Verify Release URLs

After publishing, these URLs should work:

```bash
# Main installer
https://github.com/Viktor-Hermann/APPIQ-METHOD/releases/latest/download/appiq_installer.sh

# Quick installer
https://github.com/Viktor-Hermann/APPIQ-METHOD/releases/latest/download/quick-install.sh

# Documentation
https://github.com/Viktor-Hermann/APPIQ-METHOD/releases/latest/download/README.md
```

### 5. Test the Installation

Test the complete flow:

```bash
# Test one-command install
curl -fsSL https://raw.githubusercontent.com/Viktor-Hermann/APPIQ-METHOD/main/deployment/quick-install.sh | bash

# Test direct download
wget https://github.com/Viktor-Hermann/APPIQ-METHOD/releases/latest/download/appiq_installer.sh
bash appiq_installer.sh
```

### 6. Alternative: Using GitHub CLI

If you have GitHub CLI installed:

```bash
# Create release with GitHub CLI
gh release create v1.0.0 \
  deployment/dist/appiq_installer.sh \
  deployment/dist/quick-install.sh \
  deployment/dist/README.md \
  deployment/dist/INSTALL_EXAMPLES.md \
  deployment/dist/RELEASE_NOTES.md \
  deployment/dist/VERSION \
  deployment/dist/CHECKSUMS.sha256 \
  --title "APPIQ Method v1.0.0 - Mobile Development System" \
  --notes-file deployment/dist/RELEASE_NOTES.md \
  --latest
```

## 🎯 Post-Release Checklist

After creating the release:

### 1. Update Documentation
- ✅ Verify installation URLs work
- ✅ Update any hardcoded version numbers
- ✅ Test the quick-install.sh script

### 2. Share the Release
- 📢 Share installation command:
  ```bash
  curl -fsSL https://raw.githubusercontent.com/Viktor-Hermann/APPIQ-METHOD/main/deployment/quick-install.sh | bash
  ```
- 📖 Share documentation link
- 🎯 Share usage instructions: "Use `/appiq` in your IDE"

### 3. Monitor and Support
- 👀 Watch for issues and questions
- 📊 Monitor download statistics
- 🐛 Be ready to create patch releases if needed

## 🚀 Your URLs Will Be:

Once the release is created, users can:

**Download installer directly:**
```bash
wget https://github.com/Viktor-Hermann/APPIQ-METHOD/releases/latest/download/appiq_installer.sh
bash appiq_installer.sh
```

**Use one-command install:**
```bash
curl -fsSL https://raw.githubusercontent.com/Viktor-Hermann/APPIQ-METHOD/main/deployment/quick-install.sh | bash
```

**Then start development:**
```
# In their IDE
/appiq
```

That's it! Your APPIQ Method will be ready for global distribution! 🎉