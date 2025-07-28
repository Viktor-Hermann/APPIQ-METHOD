# Universal IDE Integration for APPIQ Method Commands

## Overview

This document provides a universal implementation approach for the APPIQ Method commands (`/start` and `/appiq`) that can be adapted to work with any IDE or AI assistant that supports chat-based interactions. Supports all project types: Web, Desktop, Mobile, and Backend.

## Universal Implementation Strategy

### Core Principles

1. **Chat-Based Interface**: Works through standard chat/conversation interfaces
2. **Session State Management**: Maintains conversation state across multiple messages
3. **File System Agnostic**: Adapts to different file system access methods
4. **Universal Project Detection**: Supports Web, Desktop, Mobile, and Backend projects
5. **Fallback Support**: Graceful degradation when advanced features aren't available

### Universal Message Protocol

#### Command Recognition
```
Pattern: /start [optional-args] | /appiq [optional-args]
Triggers: Interactive universal development workflow launcher
Context: Any chat interface supporting text interaction
Supported: Web, Desktop, Mobile, Backend projects
```

#### State Management Format
```json
{
  "session_id": "uuid",
  "workflow": "appiq-universal",
  "state": {
    "step": "project-status|project-type|auto-detection|platform-selection|workflow-launch",
    "project_type": "greenfield|brownfield|null",
    "application_category": "web|desktop|mobile|backend|auto-detect|null",
    "platform": "react|vue|angular|electron|flutter|react-native|nodejs|python|java|null",
    "framework": "string|null",
    "detected_project": "ProjectDetection|null"
  },
  "context": {
    "project_path": "/path/to/project",
    "ide": "claude|cursor|windsurf|generic",
    "capabilities": ["file_access", "project_analysis", "task_creation"]
  }
}
```

### Universal Interaction Flow

#### Step 1: Project Status Selection
```markdown
🚀 **APPIQ Method Universal Launcher**

[Optional: Project analysis results if capabilities allow]

Arbeiten wir an einem neuen oder bestehenden Projekt?

**1.** 🆕 Neues Projekt (Greenfield) - Wir bauen von Grund auf
**2.** 🔧 Bestehendes Projekt (Brownfield) - Wir erweitern/verbessern etwas

Antworte mit **1** oder **2**:
```

#### Step 2: Project Type Selection
```markdown
📋 **Lass mich verstehen, was wir bauen...**

Was für eine Art von Anwendung ist das?

**1.** 🌐 Web-Anwendung (läuft im Browser)
**2.** 💻 Desktop-Anwendung (Electron, Windows/Mac App)  
**3.** 📱 Mobile App (iOS/Android)
**4.** ⚙️ Backend/API Service (Server, Database)
**5.** 🤔 Bin mir nicht sicher - lass APPIQ entscheiden

Antworte mit **1**, **2**, **3**, **4** oder **5**:
```

#### Step 3: Auto-Detection Logic
```
IF application_category == "auto-detect":
    IF project_type == "brownfield":
        ANALYZE_EXISTING_PROJECT()
        SHOW detected_project_confirmation
    ELSE:
        REQUEST_PROJECT_DESCRIPTION()
        ANALYZE_DESCRIPTION()
        SHOW recommended_project_type
ELSE IF application_category == "mobile":
    SHOW mobile_platform_selection
ELSE:
    PROCEED_TO_workflow_launch
```

#### Step 4: Universal Workflow Launch
```markdown
✅ **Perfect! [Project Category] [Development Type] erkannt.**

🎯 **Starte [Project Type] Workflow für [Project Category]...**
📍 **Fokus:** [Context Message]
📂 **Workflow:** `workflow-file.yaml`
🎬 **Erster Agent:** analyst

**Der Workflow führt Sie durch:**
1. [Context-specific step 1]
2. [Context-specific step 2]
3. [Context-specific step 3]...

---

**@analyst** - [Context-specific analyst instruction]
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
  static welcome(projectAnalysis?: UniversalProjectAnalysis): string {
    let message = `🚀 **APPIQ Method Universal Launcher**\n\n`;
    
    if (projectAnalysis?.detectedProject) {
      message += `🔍 **Project Analysis:**\n`;
      message += `- Detected: ${projectAnalysis.detectedProject.type} ${projectAnalysis.detectedProject.framework}\n`;
      message += `- Confidence: ${Math.round(projectAnalysis.detectedProject.confidence * 100)}%\n`;
      message += `- Indicators: ${projectAnalysis.detectedProject.indicators.join(', ')}\n\n`;
    }
    
    message += `Arbeiten wir an einem neuen oder bestehenden Projekt?\n\n`;
    message += `**1.** 🆕 Neues Projekt (Greenfield) - Wir bauen von Grund auf\n`;
    message += `**2.** 🔧 Bestehendes Projekt (Brownfield) - Wir erweitern/verbessern etwas\n\n`;
    message += `Antworte mit **1** oder **2**:`;
    
    return message;
  }
  
  static projectTypeSelection(): string {
    return `📋 **Lass mich verstehen, was wir bauen...**

Was für eine Art von Anwendung ist das?

**1.** 🌐 Web-Anwendung (läuft im Browser)
**2.** 💻 Desktop-Anwendung (Electron, Windows/Mac App)
**3.** 📱 Mobile App (iOS/Android)
**4.** ⚙️ Backend/API Service (Server, Database)
**5.** 🤔 Bin mir nicht sicher - lass APPIQ entscheiden

Antworte mit **1**, **2**, **3**, **4** oder **5**:`;
  }

  static mobilePlatformSelection(): string {
    return `📱 **Mobile Platform Selection:**

**1.** Flutter - Cross-platform with Dart
**2.** React Native - Cross-platform with React/JavaScript

Antworte mit **1** oder **2**:`;
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
  
  static workflowLaunch(config: UniversalWorkflowConfig): string {
    return `✅ **Perfect! ${config.displayName} erkannt.**

🎯 **Starte ${config.displayName}...**
📍 **Fokus:** ${config.contextMessage}
📂 **Workflow:** \`${config.filename}\`
🎬 **Erster Agent:** ${config.firstAgent}

**Der Workflow führt Sie durch:**
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