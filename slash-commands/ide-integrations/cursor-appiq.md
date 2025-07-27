# Cursor IDE Integration for /appiq Command

## Implementation for Cursor AI Code Editor

The `/appiq` command in Cursor should be implemented as a chat-based command that provides interactive mobile development workflow selection.

## Integration Approaches

### Approach 1: Chat Command (Recommended)
Implement `/appiq` as a recognized chat command that triggers the interactive flow.

### Approach 2: Command Palette Integration
Add APPIQ Method commands to Cursor's command palette for quick access.

## Chat-Based Implementation

### Command Recognition
```typescript
// Cursor chat command recognition
if (message.startsWith('/appiq')) {
  return initializeAppiqFlow();
}
```

### Interactive Flow Implementation

#### State Management
```typescript
interface CursorAppiqState {
  sessionId: string;
  projectType: 'greenfield' | 'brownfield' | null;
  platform: 'flutter' | 'react-native' | null;
  hasPrd: boolean | null;
  currentStep: AppiqStep;
  workspaceRoot: string;
}

enum AppiqStep {
  PROJECT_TYPE = 'project-type',
  PLATFORM_SELECTION = 'platform-selection', 
  PLATFORM_DETECTION = 'platform-detection',
  PRD_CHECK = 'prd-check',
  WORKFLOW_LAUNCH = 'workflow-launch'
}
```

#### Step Implementation
```typescript
class CursorAppiqHandler {
  private state: CursorAppiqState;
  
  constructor(workspaceRoot: string) {
    this.state = {
      sessionId: generateSessionId(),
      projectType: null,
      platform: null,
      hasPrd: null,
      currentStep: AppiqStep.PROJECT_TYPE,
      workspaceRoot
    };
  }
  
  handleMessage(message: string): string {
    switch (this.state.currentStep) {
      case AppiqStep.PROJECT_TYPE:
        return this.handleProjectTypeSelection(message);
      case AppiqStep.PLATFORM_SELECTION:
        return this.handlePlatformSelection(message);
      case AppiqStep.PLATFORM_DETECTION:
        return this.handlePlatformDetection(message);
      case AppiqStep.PRD_CHECK:
        return this.handlePrdCheck(message);
      default:
        return this.showProjectTypeSelection();
    }
  }
  
  private handleProjectTypeSelection(input: string): string {
    if (input === '1') {
      this.state.projectType = 'greenfield';
      this.state.currentStep = AppiqStep.PLATFORM_SELECTION;
      return this.showPlatformSelection();
    } else if (input === '2') {
      this.state.projectType = 'brownfield';
      this.state.currentStep = AppiqStep.PLATFORM_DETECTION;
      return this.showPlatformDetection();
    }
    return this.showInvalidResponseError(this.showProjectTypeSelection());
  }
  
  private showProjectTypeSelection(): string {
    return `🚀 **Welcome to APPIQ Method Mobile Development!**

What type of mobile project are you working on?

**1.** Greenfield - New mobile app development (Flutter or React Native)
**2.** Brownfield - Enhancing existing mobile app

Please respond with **1** or **2**:`;
  }
  
  private showPlatformSelection(): string {
    return `📱 **Platform Selection for New Mobile App:**

Which mobile platform do you want to target?

**1.** Flutter - Cross-platform with Dart
**2.** React Native - Cross-platform with React/JavaScript
**3.** Let APPIQ Method recommend based on requirements

Please respond with **1**, **2**, or **3**:`;
  }
  
  private showPlatformDetection(): string {
    return `📱 **Existing Mobile App Platform Detection:**

What platform is your existing mobile app built with?

**1.** Flutter - Dart-based cross-platform app
**2.** React Native - React/JavaScript-based app
**3.** Not sure - Let APPIQ Method analyze the codebase

Please respond with **1**, **2**, or **3**:`;
  }
}
```

### File System Integration

```typescript
// Cursor workspace file system integration
class CursorFileSystem {
  constructor(private workspaceRoot: string) {}
  
  async checkMainPrdExists(): Promise<boolean> {
    const prdPath = path.join(this.workspaceRoot, 'docs', 'main_prd.md');
    try {
      await vscode.workspace.fs.stat(vscode.Uri.file(prdPath));
      return true;
    } catch {
      return false;
    }
  }
  
  async createDocsFolder(): Promise<void> {
    const docsPath = path.join(this.workspaceRoot, 'docs');
    const docsUri = vscode.Uri.file(docsPath);
    try {
      await vscode.workspace.fs.createDirectory(docsUri);
    } catch {
      // Folder might already exist
    }
  }
  
  async detectPlatform(): Promise<'flutter' | 'react-native' | 'unknown'> {
    // Check for pubspec.yaml (Flutter)
    const pubspecPath = path.join(this.workspaceRoot, 'pubspec.yaml');
    try {
      await vscode.workspace.fs.stat(vscode.Uri.file(pubspecPath));
      return 'flutter';
    } catch {}
    
    // Check for package.json with React Native dependencies
    const packageJsonPath = path.join(this.workspaceRoot, 'package.json');
    try {
      const packageJsonUri = vscode.Uri.file(packageJsonPath);
      const content = await vscode.workspace.fs.readFile(packageJsonUri);
      const packageJson = JSON.parse(content.toString());
      
      if (packageJson.dependencies?.['react-native'] || 
          packageJson.devDependencies?.['react-native']) {
        return 'react-native';
      }
    } catch {}
    
    return 'unknown';
  }
}
```

### Workflow Launch Integration

```typescript
class CursorWorkflowLauncher {
  constructor(private fileSystem: CursorFileSystem) {}
  
  async launchWorkflow(projectType: string, platform: string): Promise<string> {
    const workflowMap = {
      'greenfield-flutter': 'mobile-greenfield-flutter',
      'greenfield-react-native': 'mobile-greenfield-react-native',
      'brownfield-flutter': 'mobile-brownfield-flutter',
      'brownfield-react-native': 'mobile-brownfield-react-native'
    };
    
    const workflowKey = `${projectType}-${platform}`;
    const workflowName = workflowMap[workflowKey];
    
    // Generate launch message
    const launchMessage = this.generateLaunchMessage(projectType, platform, workflowName);
    
    // Set up workspace context
    await this.setupWorkspaceContext(projectType, platform);
    
    return launchMessage;
  }
  
  private generateLaunchMessage(projectType: string, platform: string, workflowName: string): string {
    const platformDisplay = platform === 'react-native' ? 'React Native' : 'Flutter';
    const typeDisplay = projectType.charAt(0).toUpperCase() + projectType.slice(1);
    
    return `✅ **Perfect! Launching ${typeDisplay} ${platformDisplay} Mobile Development Workflow...**

🎯 **Starting with:** \`${workflowName}.yaml\`
📍 **First Agent:** analyst
📂 **Expected Output:** \`docs/project-brief.md\`

**The mobile development workflow will now guide you through:**
1. Mobile-focused project brief
2. Mobile-specific PRD creation 
3. ${platformDisplay} platform validation
4. Mobile UX design system
5. ${platformDisplay} architecture planning
6. Mobile security review
7. Story creation and development

---

**@analyst** - Please begin with creating a mobile-focused project brief considering app store landscape, device capabilities, and mobile user behavior.`;
  }
  
  private async setupWorkspaceContext(projectType: string, platform: string): Promise<void> {
    // Set workspace settings for the active workflow
    const config = vscode.workspace.getConfiguration('appiq');
    await config.update('activeWorkflow', `mobile-${projectType}-${platform}`, vscode.ConfigurationTarget.Workspace);
    await config.update('mobilePlatform', platform, vscode.ConfigurationTarget.Workspace);
    await config.update('projectType', projectType, vscode.ConfigurationTarget.Workspace);
  }
}
```

## Command Palette Integration

### Extension Manifest (package.json)
```json
{
  "contributes": {
    "commands": [
      {
        "command": "appiq.launchMobileWorkflow",
        "title": "APPIQ: Launch Mobile Development Workflow",
        "category": "APPIQ Method"
      },
      {
        "command": "appiq.greenfieldFlutter",
        "title": "APPIQ: New Flutter App",
        "category": "APPIQ Method"
      },
      {
        "command": "appiq.greenfieldReactNative",
        "title": "APPIQ: New React Native App", 
        "category": "APPIQ Method"
      },
      {
        "command": "appiq.brownfieldFlutter",
        "title": "APPIQ: Enhance Flutter App",
        "category": "APPIQ Method"
      },
      {
        "command": "appiq.brownfieldReactNative",
        "title": "APPIQ: Enhance React Native App",
        "category": "APPIQ Method"
      }
    ],
    "keybindings": [
      {
        "command": "appiq.launchMobileWorkflow",
        "key": "ctrl+alt+a",
        "mac": "cmd+alt+a"
      }
    ]
  }
}
```

### Command Implementations
```typescript
export function activate(context: vscode.ExtensionContext) {
  // Main interactive launcher
  const launchCommand = vscode.commands.registerCommand('appiq.launchMobileWorkflow', () => {
    const panel = vscode.window.createWebviewPanel(
      'appiqLauncher',
      'APPIQ Mobile Development Launcher',
      vscode.ViewColumn.One,
      { enableScripts: true }
    );
    
    panel.webview.html = createLauncherWebview();
    setupWebviewMessageHandling(panel);
  });
  
  // Direct workflow commands
  const greenfieldFlutterCommand = vscode.commands.registerCommand('appiq.greenfieldFlutter', () => {
    return launchDirectWorkflow('greenfield', 'flutter');
  });
  
  const greenfieldReactNativeCommand = vscode.commands.registerCommand('appiq.greenfieldReactNative', () => {
    return launchDirectWorkflow('greenfield', 'react-native');
  });
  
  context.subscriptions.push(
    launchCommand,
    greenfieldFlutterCommand,
    greenfieldReactNativeCommand
  );
}
```

## Chat Integration Best Practices

### Message Formatting
- Use **bold** for emphasis and options
- Use emojis for visual clarity
- Structure responses with clear sections
- Provide numbered options for easy selection

### Error Handling
```typescript
private showInvalidResponseError(originalPrompt: string): string {
  return `❌ **Invalid response.** Please respond with one of the specified options.

${originalPrompt}`;
}

private showPrdMissingError(): string {
  return `❌ **main_prd.md not found** in /docs/ folder.

**Please create your main Product Requirements Document first:**

1. Create a \`/docs/\` folder in your project root
2. Create a \`main_prd.md\` file with your project requirements  
3. Place it at: \`/docs/main_prd.md\`
4. Run \`/appiq\` again

**Would you like guidance on creating a main_prd.md file?** (yes/no)`;
}
```

### Progress Tracking
```typescript
private showProgress(currentStep: number, totalSteps: number, stepName: string): string {
  return `**Progress:** ${currentStep}/${totalSteps} - ${stepName}`;
}
```

## Usage in Cursor

Users can interact with the `/appiq` command in several ways:

1. **Chat Command**: Type `/appiq` in the Cursor chat
2. **Command Palette**: `Ctrl+Shift+P` → "APPIQ: Launch Mobile Development Workflow"
3. **Keyboard Shortcut**: `Ctrl+Alt+A` (or `Cmd+Alt+A` on Mac)
4. **Direct Commands**: Use specific workflow commands from the command palette

The implementation provides a seamless experience that integrates with Cursor's existing features while maintaining the interactive workflow selection process.