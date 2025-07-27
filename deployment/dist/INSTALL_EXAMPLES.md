# APPIQ Method - Installation Examples

## Quick Start (Recommended)

### One-Command Install
```bash
curl -fsSL https://raw.githubusercontent.com/Viktor-Hermann/APPIQ-METHOD/main/deployment/quick-install.sh | bash
```

## Alternative Methods

### Download and Run
```bash
# Download
wget https://github.com/Viktor-Hermann/APPIQ-METHOD/releases/latest/download/appiq_installer.sh

# Install in your project
cd my-mobile-project
bash appiq_installer.sh
```

### Manual Copy
1. Download `appiq_installer.sh` 
2. Copy to project folder
3. Run: `bash appiq_installer.sh`

## Post-Installation

### 1. Customize PRD
```bash
nano docs/main_prd.md
```

### 2. Start Development
Open your IDE and use:
```
/appiq
```

### 3. Validate Setup
```bash
./.appiq/scripts/appiq validate
```

## IDE Usage

### Claude Code
```
/appiq
```

### Cursor  
```
/appiq
# or Ctrl+Alt+A
```

### Windsurf
```
/appiq
```

## Project Types Supported

- ✅ Flutter mobile apps
- ✅ React Native mobile apps  
- ✅ New app development (Greenfield)
- ✅ Existing app enhancement (Brownfield)

## What You Get

- Complete mobile development workflow
- Interactive project setup
- Platform-specific guidance
- Automated document generation
- Agent-based development process
- Quality assurance integration
- IDE integration for Claude, Cursor, Windsurf

## Support

- Validate: `./.appiq/scripts/appiq validate`
- Status: `./.appiq/scripts/appiq status`
- Update: `./.appiq/scripts/appiq update`
