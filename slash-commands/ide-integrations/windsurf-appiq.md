# Windsurf IDE Integration for /appiq Command

## Implementation for Windsurf IDE

The `/appiq` command in Windsurf should be implemented as a chat-based interactive command that integrates with Windsurf's AI assistant and project management features.

## Integration Strategy

### Chat-Based Implementation
Windsurf's primary interaction model is through its AI chat interface, making it ideal for the interactive `/appiq` command flow.

### Project Context Integration
Leverage Windsurf's project understanding capabilities to automatically detect existing mobile codebases and provide contextual recommendations.

## Chat Command Implementation

### Command Recognition Pattern
```typescript
// Windsurf chat command detection
const APPIQ_COMMAND_PATTERN = /^\/appiq(?:\s+(.*))?$/i;

function handleChatMessage(message: string, context: WindsurfContext): WindsurfResponse {
  const match = message.match(APPIQ_COMMAND_PATTERN);
  if (match) {
    return initializeAppiqWorkflow(context);
  }
  return null;
}
```

### Interactive State Management
```typescript
interface WindsurfAppiqSession {
  sessionId: string;
  projectPath: string;
  projectContext: WindsurfProjectContext;
  state: {
    projectType: 'greenfield' | 'brownfield' | null;
    platform: 'flutter' | 'react-native' | null;
    hasPrd: boolean | null;
    currentStep: AppiqStep;
    detectedPlatform?: string;
  };
  chatHistory: ChatMessage[];
}

enum AppiqStep {
  WELCOME = 'welcome',
  PROJECT_TYPE = 'project-type',
  PLATFORM_SELECTION = 'platform-selection',
  PLATFORM_DETECTION = 'platform-detection', 
  PRD_VERIFICATION = 'prd-verification',
  WORKFLOW_LAUNCH = 'workflow-launch'
}
```

### Step-by-Step Implementation

#### Welcome and Project Analysis
```typescript
class WindsurfAppiqHandler {
  constructor(private context: WindsurfContext) {}
  
  async initializeWorkflow(): Promise<WindsurfResponse> {
    // Analyze current project structure
    const projectAnalysis = await this.analyzeProject();
    
    const welcomeMessage = this.createWelcomeMessage(projectAnalysis);
    
    return {
      message: welcomeMessage,
      actions: [
        { type: 'highlight-files', files: this.getRelevantFiles(projectAnalysis) },
        { type: 'set-context', context: { appiq_active: true } }
      ]
    };
  }
  
  private createWelcomeMessage(analysis: ProjectAnalysis): string {
    let message = `🚀 **Welcome to APPIQ Method Mobile Development!**\n\n`;
    
    if (analysis.existingMobileApp) {
      message += `🔍 **Project Analysis Results:**\n`;
      message += `- Detected: ${analysis.detectedPlatform} mobile app\n`;
      message += `- Structure: ${analysis.projectStructure}\n\n`;
    }
    
    message += `**What type of mobile project are you working on?**\n\n`;
    message += `**1.** Greenfield - New mobile app development (Flutter or React Native)\n`;
    message += `**2.** Brownfield - Enhancing existing mobile app\n\n`;
    
    if (analysis.recommendation) {
      message += `💡 **Recommendation:** ${analysis.recommendation}\n\n`;
    }
    
    message += `Please respond with **1** or **2**:`;
    
    return message;
  }
}
```

#### Project Analysis Integration
```typescript
interface ProjectAnalysis {
  existingMobileApp: boolean;
  detectedPlatform?: 'flutter' | 'react-native' | 'native-ios' | 'native-android';
  projectStructure: string;
  recommendation?: string;
  confidence: number;
}

class WindsurfProjectAnalyzer {
  async analyzeProject(projectPath: string): Promise<ProjectAnalysis> {
    const files = await this.scanProjectFiles(projectPath);
    
    // Check for Flutter
    if (files.includes('pubspec.yaml')) {
      return {
        existingMobileApp: true,
        detectedPlatform: 'flutter',
        projectStructure: 'Flutter project with Dart',
        recommendation: 'Continue with Flutter enhancement workflow',
        confidence: 0.95
      };
    }
    
    // Check for React Native
    if (files.includes('package.json')) {
      const packageJson = await this.readPackageJson(projectPath);
      if (this.hasReactNativeDependencies(packageJson)) {
        return {
          existingMobileApp: true,
          detectedPlatform: 'react-native',
          projectStructure: 'React Native project with JavaScript/TypeScript',
          recommendation: 'Continue with React Native enhancement workflow',
          confidence: 0.9
        };
      }
    }
    
    // No mobile app detected
    return {
      existingMobileApp: false,
      projectStructure: 'No mobile app structure detected',
      recommendation: 'Start with Greenfield mobile development',
      confidence: 0.8
    };
  }
}
```

#### Enhanced Platform Selection
```typescript
private async handlePlatformSelection(input: string, session: WindsurfAppiqSession): Promise<WindsurfResponse> {
  if (input === '1') {
    session.state.platform = 'flutter';
    return this.proceedToPrdCheck(session);
  } else if (input === '2') {
    session.state.platform = 'react-native';
    return this.proceedToPrdCheck(session);
  } else if (input === '3') {
    return this.showPlatformRecommendation(session);
  }
  
  return this.showInvalidResponse(this.createPlatformSelectionMessage());
}

private async showPlatformRecommendation(session: WindsurfAppiqSession): Promise<WindsurfResponse> {
  const analysis = await this.analyzePlatformRequirements(session.projectContext);
  
  return {
    message: `🤔 **Platform Recommendation Analysis**\n\n${analysis.reasoning}\n\n**Recommended Platform:** ${analysis.recommendedPlatform}\n\n**Do you want to proceed with ${analysis.recommendedPlatform}?** (yes/no)`,
    actions: [
      { type: 'highlight-reasoning', reasoning: analysis.factors }
    ]
  };
}
```

### File System Integration

```typescript
class WindsurfFileSystemHandler {
  constructor(private windsurf: WindsurfAPI) {}
  
  async checkPrdExists(projectPath: string): Promise<boolean> {
    try {
      const prdPath = path.join(projectPath, 'docs', 'main_prd.md');
      await this.windsurf.fs.access(prdPath);
      return true;
    } catch {
      return false;
    }
  }
  
  async createDocsStructure(projectPath: string): Promise<void> {
    const docsPath = path.join(projectPath, 'docs');
    await this.windsurf.fs.mkdir(docsPath, { recursive: true });
  }
  
  async showPrdTemplate(projectPath: string): Promise<WindsurfResponse> {
    const templatePath = path.join(projectPath, 'docs', 'main_prd_template.md');
    
    const template = this.generatePrdTemplate();
    await this.windsurf.fs.writeFile(templatePath, template);
    
    return {
      message: `📋 **PRD Template Created**\n\nI've created a template at \`docs/main_prd_template.md\`.\n\nPlease:\n1. Review and customize the template\n2. Save it as \`docs/main_prd.md\`\n3. Run \`/appiq\` again`,
      actions: [
        { type: 'open-file', path: templatePath },
        { type: 'focus-file', path: templatePath }
      ]
    };
  }
}
```

### Workflow Launch with Windsurf Features

```typescript
class WindsurfWorkflowLauncher {
  async launchWorkflow(session: WindsurfAppiqSession): Promise<WindsurfResponse> {
    const { projectType, platform } = session.state;
    
    const workflowConfig = this.getWorkflowConfig(projectType, platform);
    const launchMessage = this.generateLaunchMessage(workflowConfig);
    
    // Set up Windsurf project context
    await this.setupWindsurfContext(session, workflowConfig);
    
    return {
      message: launchMessage,
      actions: [
        { type: 'set-workflow', workflow: workflowConfig.id },
        { type: 'create-task-list', tasks: workflowConfig.steps },
        { type: 'highlight-next-action', action: workflowConfig.firstStep },
        { type: 'open-relevant-files', files: workflowConfig.relevantFiles }
      ]
    };
  }
  
  private generateLaunchMessage(config: WorkflowConfig): string {
    return `✅ **Perfect! Launching ${config.displayName}...**

🎯 **Workflow:** \`${config.id}\`
📍 **First Agent:** ${config.firstAgent}
📂 **Expected Output:** \`${config.firstOutput}\`

**📋 Workflow Overview:**
${config.steps.map((step, i) => `${i + 1}. ${step}`).join('\n')}

---

**🤖 Starting Agent: @${config.firstAgent}**

${config.firstAgentPrompt}`;
  }
  
  private async setupWindsurfContext(session: WindsurfAppiqSession, config: WorkflowConfig): Promise<void> {
    // Set Windsurf workspace context
    await this.windsurf.workspace.setContext({
      appiq_workflow: config.id,
      mobile_platform: session.state.platform,
      project_type: session.state.projectType,
      workflow_step: 1,
      expected_outputs: config.expectedOutputs
    });
    
    // Create task tracking
    await this.windsurf.tasks.create({
      title: `APPIQ Mobile Development - ${config.displayName}`,
      steps: config.steps.map(step => ({ description: step, completed: false })),
      dueDate: this.calculateEstimatedCompletion(config)
    });
  }
}
```

### Windsurf-Specific Features

#### Smart File Navigation
```typescript
class WindsurfNavigationHelper {
  async highlightRelevantFiles(workflowType: string, platform: string): Promise<string[]> {
    const relevantFiles = [];
    
    if (platform === 'flutter') {
      relevantFiles.push(
        'pubspec.yaml',
        'lib/main.dart',
        'lib/**/*.dart',
        'test/**/*.dart'
      );
    } else if (platform === 'react-native') {
      relevantFiles.push(
        'package.json',
        'src/**/*.tsx',
        'src/**/*.ts',
        '__tests__/**/*.test.ts'
      );
    }
    
    relevantFiles.push(
      'docs/main_prd.md',
      'docs/**/*.md',
      'README.md'
    );
    
    return relevantFiles;
  }
}
```

#### Progress Tracking Integration
```typescript
class WindsurfProgressTracker {
  async updateWorkflowProgress(step: string, completed: boolean): Promise<void> {
    await this.windsurf.progress.update({
      workflowId: 'appiq-mobile-development',
      currentStep: step,
      completed,
      nextActions: this.getNextActions(step)
    });
  }
  
  async showProgressSidebar(): Promise<void> {
    await this.windsurf.sidebar.show('appiq-progress', {
      title: 'APPIQ Mobile Development Progress',
      content: this.generateProgressHTML()
    });
  }
}
```

## Usage in Windsurf

### Chat-Based Interaction
```
User: /appiq

🚀 Welcome to APPIQ Method Mobile Development!

🔍 Project Analysis Results:
- Detected: React Native mobile app
- Structure: React Native project with TypeScript

What type of mobile project are you working on?

1. Greenfield - New mobile app development (Flutter or React Native)
2. Brownfield - Enhancing existing mobile app

💡 Recommendation: Continue with React Native enhancement workflow

Please respond with 1 or 2:

User: 2

✅ Perfect! Launching Brownfield React Native Mobile Enhancement Workflow...

🎯 Workflow: mobile-brownfield-react-native
📍 First Agent: analyst
📂 Expected Output: docs/enhancement-analysis.md

[Windsurf opens relevant files and creates task tracking]
```

### Integration with Windsurf Features

1. **Smart File Navigation**: Automatically highlights relevant files
2. **Task Tracking**: Creates project tasks for workflow steps
3. **Progress Monitoring**: Shows workflow progress in sidebar
4. **Context Awareness**: Maintains project context across sessions
5. **File Templates**: Generates and opens relevant templates

### Advanced Features

#### Auto-Detection Enhancement
```typescript
// Enhanced project detection for Windsurf
async detectProjectDetails(): Promise<ProjectDetails> {
  const analysis = await this.windsurf.ai.analyzeProject({
    includeFiles: ['package.json', 'pubspec.yaml', 'android/', 'ios/'],
    analysisType: 'mobile-platform-detection'
  });
  
  return {
    platform: analysis.detectedPlatform,
    confidence: analysis.confidence,
    recommendations: analysis.recommendations,
    nextSteps: analysis.suggestedNextSteps
  };
}
```

#### Intelligent Workflow Suggestions
```typescript
// Use Windsurf's AI to suggest optimal workflows
async suggestWorkflow(projectContext: ProjectContext): Promise<WorkflowSuggestion> {
  const suggestion = await this.windsurf.ai.suggest({
    context: projectContext,
    domain: 'mobile-development',
    goal: 'optimize-development-workflow'
  });
  
  return {
    recommendedWorkflow: suggestion.workflow,
    reasoning: suggestion.reasoning,
    alternativeOptions: suggestion.alternatives
  };
}
```

This implementation provides a seamless integration with Windsurf's AI-powered development environment while maintaining the interactive workflow selection that makes the `/appiq` command effective across different IDEs.