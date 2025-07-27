# Claude IDE Integration for /appiq Command

## Implementation for Claude Code

The `/appiq` command in Claude Code should be implemented as a native slash command that provides interactive mobile development workflow selection.

## Command Definition

```yaml
command: /appiq
description: Interactive APPIQ Method mobile development workflow launcher
category: Mobile Development
expansion_pack: bmad-mobile-app-dev
```

## Interactive Implementation

### State Variables
```typescript
interface AppiqState {
  projectType: 'greenfield' | 'brownfield' | null;
  platform: 'flutter' | 'react-native' | null;
  hasPrd: boolean | null;
  step: 'project-type' | 'platform-selection' | 'platform-detection' | 'prd-check' | 'launch';
}
```

### Step-by-Step Flow

#### Step 1: Project Type Selection
```typescript
function showProjectTypeSelection() {
  return `🚀 Welcome to APPIQ Method Mobile Development!

What type of mobile project are you working on?

1. Greenfield - New mobile app development (Flutter or React Native)
2. Brownfield - Enhancing existing mobile app

Please respond with 1 or 2:`;
}

function handleProjectTypeResponse(input: string, state: AppiqState) {
  if (input === '1') {
    state.projectType = 'greenfield';
    state.step = 'platform-selection';
    return showPlatformSelection();
  } else if (input === '2') {
    state.projectType = 'brownfield';
    state.step = 'platform-detection';
    return showPlatformDetection();
  } else {
    return `❌ Invalid response. Please respond with 1 or 2:\n\n${showProjectTypeSelection()}`;
  }
}
```

#### Step 2: Platform Selection (Greenfield)
```typescript
function showPlatformSelection() {
  return `📱 Platform Selection for New Mobile App:

Which mobile platform do you want to target?

1. Flutter - Cross-platform with Dart
2. React Native - Cross-platform with React/JavaScript
3. Let APPIQ Method recommend based on requirements

Please respond with 1, 2, or 3:`;
}

function handlePlatformSelection(input: string, state: AppiqState) {
  if (input === '1') {
    state.platform = 'flutter';
    state.step = 'prd-check';
    return showPrdCheck();
  } else if (input === '2') {
    state.platform = 'react-native';
    state.step = 'prd-check';
    return showPrdCheck();
  } else if (input === '3') {
    return showPlatformRecommendation();
  } else {
    return `❌ Invalid response. Please respond with 1, 2, or 3:\n\n${showPlatformSelection()}`;
  }
}
```

#### Step 3: Platform Detection (Brownfield)
```typescript
function showPlatformDetection() {
  return `📱 Existing Mobile App Platform Detection:

What platform is your existing mobile app built with?

1. Flutter - Dart-based cross-platform app
2. React Native - React/JavaScript-based app
3. Not sure - Let APPIQ Method analyze the codebase

Please respond with 1, 2, or 3:`;
}

function handlePlatformDetection(input: string, state: AppiqState) {
  if (input === '1') {
    state.platform = 'flutter';
    state.step = 'prd-check';
    return showPrdCheck();
  } else if (input === '2') {
    state.platform = 'react-native';
    state.step = 'prd-check';
    return showPrdCheck();
  } else if (input === '3') {
    // Trigger codebase analysis
    return analyzeCodebaseForPlatform();
  } else {
    return `❌ Invalid response. Please respond with 1, 2, or 3:\n\n${showPlatformDetection()}`;
  }
}
```

#### Step 4: PRD Validation
```typescript
function showPrdCheck() {
  return `📋 Checking for main_prd.md in your /docs/ folder...

Do you have a main_prd.md file in your /docs/ folder?
(You should create this manually and place it there before proceeding)

Please respond with yes or no:`;
}

async function handlePrdCheck(input: string, state: AppiqState) {
  if (input.toLowerCase() === 'yes') {
    // Verify file exists
    const prdExists = await checkFileExists('/docs/main_prd.md');
    if (prdExists) {
      state.hasPrd = true;
      state.step = 'launch';
      return launchWorkflow(state);
    } else {
      return `❌ main_prd.md not found in /docs/ folder. Please create it first and try again.`;
    }
  } else if (input.toLowerCase() === 'no') {
    return showPrdGuidance();
  } else {
    return `❌ Invalid response. Please respond with yes or no:\n\n${showPrdCheck()}`;
  }
}
```

#### Step 5: Workflow Launch
```typescript
function launchWorkflow(state: AppiqState) {
  const workflowMap = {
    'greenfield-flutter': 'mobile-greenfield-flutter.yaml',
    'greenfield-react-native': 'mobile-greenfield-react-native.yaml',
    'brownfield-flutter': 'mobile-brownfield-flutter.yaml',
    'brownfield-react-native': 'mobile-brownfield-react-native.yaml'
  };
  
  const workflowKey = `${state.projectType}-${state.platform}`;
  const workflowFile = workflowMap[workflowKey];
  
  // Launch the appropriate workflow
  return generateWorkflowLaunchMessage(state.projectType, state.platform, workflowFile);
}
```

## Integration with Claude Code Features

### File System Integration
```typescript
// Check if docs/main_prd.md exists
async function checkFileExists(path: string): Promise<boolean> {
  try {
    await claude.filesystem.read(path);
    return true;
  } catch (error) {
    return false;
  }
}

// Create docs folder if it doesn't exist
async function ensureDocsFolder(): Promise<void> {
  try {
    await claude.filesystem.createDirectory('/docs');
  } catch (error) {
    // Folder might already exist
  }
}
```

### Agent Integration
```typescript
// Launch the first agent in the workflow
function startWorkflowAgent(workflowType: string, platform: string) {
  if (workflowType === 'greenfield') {
    return `@analyst - Please begin with creating a mobile-focused project brief considering app store landscape, device capabilities, and mobile user behavior.`;
  } else {
    return `@analyst - Please classify the mobile enhancement scope. Can you describe the ${platform} app enhancement? Is this a small fix, a feature addition, or a major enhancement requiring architectural changes?`;
  }
}
```

### Context Management
```typescript
// Set workflow context for subsequent interactions
function setWorkflowContext(projectType: string, platform: string) {
  claude.context.set('active_workflow', `mobile-${projectType}-${platform}`);
  claude.context.set('mobile_platform', platform);
  claude.context.set('project_type', projectType);
}
```

## Usage in Claude Code

Users can simply type `/appiq` in any Claude Code chat session and the interactive flow will begin. The command will:

1. Present clear options with emojis for visual clarity
2. Validate responses and provide helpful error messages
3. Check file system for required files
4. Launch the appropriate workflow automatically
5. Start the first agent with proper context

## Error Handling

The implementation includes comprehensive error handling:
- Invalid response validation
- File existence checking
- Graceful fallbacks for missing requirements
- Clear guidance for setup steps

## Future Enhancements

The Claude integration can be extended to support:
- Auto-detection of project structure
- Integration with Claude's project management features
- Workflow progress tracking
- Custom workflow configurations