# Universal IDE Integration for /appiq Command

## Overview

This document provides a universal implementation approach for the `/appiq` command that can be adapted to work with any IDE or AI assistant that supports chat-based interactions.

## Universal Implementation Strategy

### Core Principles

1. **Chat-Based Interface**: Works through standard chat/conversation interfaces
2. **Session State Management**: Maintains conversation state across multiple messages
3. **File System Agnostic**: Adapts to different file system access methods
4. **Platform Detection**: Universal platform detection methods
5. **Fallback Support**: Graceful degradation when advanced features aren't available

### Universal Message Protocol

#### Command Recognition
```
Pattern: /appiq [optional-args]
Triggers: Interactive mobile development workflow launcher
Context: Any chat interface supporting text interaction
```

#### State Management Format
```json
{
  "session_id": "uuid",
  "workflow": "appiq-mobile",
  "state": {
    "step": "project-type|platform-selection|prd-check|launch",
    "project_type": "greenfield|brownfield|null",
    "platform": "flutter|react-native|null", 
    "has_prd": "true|false|null",
    "detected_platform": "flutter|react-native|native|unknown"
  },
  "context": {
    "project_path": "/path/to/project",
    "ide": "claude|cursor|windsurf|generic",
    "capabilities": ["file_access", "project_analysis", "task_creation"]
  }
}
```

### Universal Interaction Flow

#### Step 1: Welcome and Project Analysis
```markdown
🚀 **Welcome to APPIQ Method Mobile Development!**

[Optional: Project analysis results if capabilities allow]

**What type of mobile project are you working on?**

**1.** Greenfield - New mobile app development (Flutter or React Native)
**2.** Brownfield - Enhancing existing mobile app

Please respond with **1** or **2**:
```

#### Step 2: Platform Selection Logic
```
IF project_type == "greenfield":
    SHOW platform_selection_for_new_project
ELSE IF project_type == "brownfield":
    IF can_detect_platform:
        SHOW detected_platform_confirmation
    ELSE:
        SHOW platform_selection_for_existing_project
```

#### Step 3: PRD Validation
```markdown
📋 **Checking for main_prd.md in your /docs/ folder...**

Do you have a main_prd.md file in your /docs/ folder?
(You should create this manually and place it there before proceeding)

Please respond with **yes** or **no**:
```

#### Step 4: Workflow Launch
```markdown
✅ **Perfect! Launching [Workflow Name]...**

🎯 **Starting with:** `workflow-file.yaml`
📍 **First Agent:** agent-name
📂 **Expected Output:** `expected-file.md`

**The workflow will guide you through:**
1. Step one
2. Step two
3. Step three...

---

**@agent-name** - [Agent-specific starting prompt]
```

## Universal Implementation Code

### Base Handler Class
```typescript
abstract class UniversalAppiqHandler {
  protected sessionState: AppiqSession;
  
  constructor(protected context: IDEContext) {
    this.sessionState = this.initializeSession();
  }
  
  // Abstract methods to be implemented by specific IDEs
  abstract checkFileExists(path: string): Promise<boolean>;
  abstract detectPlatform(): Promise<PlatformDetection>;
  abstract launchWorkflow(config: WorkflowConfig): Promise<void>;
  
  // Universal message handling
  public async handleMessage(message: string): Promise<string> {
    const normalizedMessage = message.trim().toLowerCase();
    
    switch (this.sessionState.currentStep) {
      case 'project-type':
        return this.handleProjectTypeSelection(normalizedMessage);
      case 'platform-selection':
        return this.handlePlatformSelection(normalizedMessage);
      case 'platform-detection':
        return this.handlePlatformDetection(normalizedMessage);
      case 'prd-check':
        return this.handlePrdCheck(normalizedMessage);
      default:
        return this.showWelcome();
    }
  }
  
  // Universal step handlers
  protected handleProjectTypeSelection(input: string): string {
    if (input === '1') {
      this.sessionState.projectType = 'greenfield';
      this.sessionState.currentStep = 'platform-selection';
      return this.showPlatformSelection();
    } else if (input === '2') {
      this.sessionState.projectType = 'brownfield';
      this.sessionState.currentStep = 'platform-detection';
      return this.showPlatformDetection();
    }
    return this.showInvalidResponse(this.showWelcome());
  }
  
  protected async handlePlatformSelection(input: string): Promise<string> {
    const platformMap = { '1': 'flutter', '2': 'react-native', '3': 'recommend' };
    const platform = platformMap[input];
    
    if (!platform) {
      return this.showInvalidResponse(this.showPlatformSelection());
    }
    
    if (platform === 'recommend') {
      return this.showPlatformRecommendation();
    }
    
    this.sessionState.platform = platform as Platform;
    this.sessionState.currentStep = 'prd-check';
    return this.showPrdCheck();
  }
  
  protected async handlePrdCheck(input: string): Promise<string> {
    if (input === 'yes') {
      const prdExists = await this.checkFileExists('docs/main_prd.md');
      if (prdExists) {
        return this.launchSelectedWorkflow();
      } else {
        return this.showPrdNotFoundError();
      }
    } else if (input === 'no') {
      return this.showPrdCreationGuidance();
    }
    return this.showInvalidResponse(this.showPrdCheck());
  }
}
```

### Platform Detection Utilities
```typescript
class UniversalPlatformDetector {
  static async detectFromFileSystem(fileChecker: FileChecker): Promise<PlatformDetection> {
    // Check for Flutter indicators
    if (await fileChecker.exists('pubspec.yaml')) {
      const pubspecContent = await fileChecker.read('pubspec.yaml');
      if (pubspecContent.includes('flutter:')) {
        return {
          platform: 'flutter',
          confidence: 0.95,
          indicators: ['pubspec.yaml with flutter dependency']
        };
      }
    }
    
    // Check for React Native indicators
    if (await fileChecker.exists('package.json')) {
      const packageContent = await fileChecker.read('package.json');
      const packageJson = JSON.parse(packageContent);
      
      if (packageJson.dependencies?.['react-native'] || 
          packageJson.devDependencies?.['react-native']) {
        return {
          platform: 'react-native',
          confidence: 0.9,
          indicators: ['package.json with react-native dependency']
        };
      }
    }
    
    // Check for additional indicators
    const indicators = [];
    if (await fileChecker.exists('android/app/build.gradle')) indicators.push('Android project structure');
    if (await fileChecker.exists('ios/Podfile')) indicators.push('iOS project structure');
    if (await fileChecker.exists('metro.config.js')) indicators.push('Metro bundler config');
    
    return {
      platform: 'unknown',
      confidence: 0.3,
      indicators
    };
  }
}
```

### Message Templates
```typescript
class UniversalMessageTemplates {
  static welcome(projectAnalysis?: ProjectAnalysis): string {
    let message = `🚀 **Welcome to APPIQ Method Mobile Development!**\n\n`;
    
    if (projectAnalysis?.detected) {
      message += `🔍 **Project Analysis:**\n`;
      message += `- Detected: ${projectAnalysis.platform} mobile app\n`;
      message += `- Confidence: ${Math.round(projectAnalysis.confidence * 100)}%\n\n`;
    }
    
    message += `**What type of mobile project are you working on?**\n\n`;
    message += `**1.** Greenfield - New mobile app development (Flutter or React Native)\n`;
    message += `**2.** Brownfield - Enhancing existing mobile app\n\n`;
    message += `Please respond with **1** or **2**:`;
    
    return message;
  }
  
  static platformSelection(): string {
    return `📱 **Platform Selection for New Mobile App:**

Which mobile platform do you want to target?

**1.** Flutter - Cross-platform with Dart
**2.** React Native - Cross-platform with React/JavaScript
**3.** Let APPIQ Method recommend based on requirements

Please respond with **1**, **2**, or **3**:`;
  }
  
  static platformDetection(detectedPlatform?: string): string {
    let message = `📱 **Existing Mobile App Platform Detection:**\n\n`;
    
    if (detectedPlatform) {
      message += `🔍 **Auto-detected:** ${detectedPlatform}\n\n`;
      message += `Is this correct, or would you like to specify manually?\n\n`;
      message += `**1.** Yes, continue with ${detectedPlatform}\n`;
      message += `**2.** No, let me specify manually\n\n`;
      message += `Please respond with **1** or **2**:`;
    } else {
      message += `What platform is your existing mobile app built with?\n\n`;
      message += `**1.** Flutter - Dart-based cross-platform app\n`;
      message += `**2.** React Native - React/JavaScript-based app\n`;
      message += `**3.** Not sure - Let APPIQ Method analyze the codebase\n\n`;
      message += `Please respond with **1**, **2**, or **3**:`;
    }
    
    return message;
  }
  
  static prdCheck(): string {
    return `📋 **Checking for main_prd.md in your /docs/ folder...**

Do you have a main_prd.md file in your /docs/ folder?
(You should create this manually and place it there before proceeding)

Please respond with **yes** or **no**:`;
  }
  
  static workflowLaunch(config: WorkflowConfig): string {
    return `✅ **Perfect! Launching ${config.displayName}...**

🎯 **Starting with:** \`${config.filename}\`
📍 **First Agent:** ${config.firstAgent}
📂 **Expected Output:** \`${config.firstOutput}\`

**The mobile development workflow will now guide you through:**
${config.steps.map((step, i) => `${i + 1}. ${step}`).join('\n')}

---

**@${config.firstAgent}** - ${config.firstAgentPrompt}`;
  }
}
```

## IDE-Specific Adapters

### Generic Chat Interface Adapter
```typescript
class GenericChatAppiqHandler extends UniversalAppiqHandler {
  async checkFileExists(path: string): Promise<boolean> {
    // Fallback: Ask user to confirm file existence
    return new Promise((resolve) => {
      this.askUser(`Does the file ${path} exist in your project? (yes/no)`)
        .then(response => resolve(response.toLowerCase() === 'yes'));
    });
  }
  
  async detectPlatform(): Promise<PlatformDetection> {
    // Fallback: Ask user to specify platform
    const response = await this.askUser(
      `What type of mobile app do you have? (flutter/react-native/other)`
    );
    
    return {
      platform: response.toLowerCase() as Platform,
      confidence: 0.8,
      indicators: ['user-specified']
    };
  }
  
  async launchWorkflow(config: WorkflowConfig): Promise<void> {
    // Generic workflow launch - just show instructions
    console.log(`Launching workflow: ${config.id}`);
    console.log(`Next steps: ${config.steps.join(', ')}`);
  }
}
```

### VS Code Adapter
```typescript
class VSCodeAppiqHandler extends UniversalAppiqHandler {
  async checkFileExists(path: string): Promise<boolean> {
    try {
      await vscode.workspace.fs.stat(vscode.Uri.file(path));
      return true;
    } catch {
      return false;
    }
  }
  
  async detectPlatform(): Promise<PlatformDetection> {
    const workspaceRoot = vscode.workspace.workspaceFolders?.[0]?.uri.fsPath;
    if (!workspaceRoot) return { platform: 'unknown', confidence: 0, indicators: [] };
    
    return UniversalPlatformDetector.detectFromFileSystem({
      exists: (path) => this.checkFileExists(`${workspaceRoot}/${path}`),
      read: async (path) => {
        const content = await vscode.workspace.fs.readFile(
          vscode.Uri.file(`${workspaceRoot}/${path}`)
        );
        return Buffer.from(content).toString();
      }
    });
  }
}
```

## Universal Configuration

### Workflow Configuration
```typescript
interface UniversalWorkflowConfig {
  greenfield: {
    flutter: WorkflowDefinition;
    'react-native': WorkflowDefinition;
  };
  brownfield: {
    flutter: WorkflowDefinition;
    'react-native': WorkflowDefinition;
  };
}

interface WorkflowDefinition {
  id: string;
  filename: string;
  displayName: string;
  firstAgent: string;
  firstOutput: string;
  firstAgentPrompt: string;
  steps: string[];
  expectedOutputs: string[];
}
```

### Usage Examples

#### Basic Chat Interface
```
User: /appiq
Bot: [Shows welcome message with project type selection]
User: 1
Bot: [Shows platform selection for greenfield]
User: 1
Bot: [Shows PRD check]
User: yes
Bot: [Launches Flutter greenfield workflow]
```

#### Advanced IDE Integration
```
User: /appiq
IDE: [Analyzes project, detects React Native]
IDE: [Shows welcome with auto-detection results]
User: 2
IDE: [Confirms detected platform]
User: 1
IDE: [Checks file system for PRD]
IDE: [Launches React Native brownfield workflow with file highlights]
```

This universal implementation ensures the `/appiq` command works consistently across different IDEs while adapting to their specific capabilities and constraints.