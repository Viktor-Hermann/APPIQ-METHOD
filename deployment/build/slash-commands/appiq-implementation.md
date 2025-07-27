# APPIQ Command Implementation Logic

This document provides the technical implementation details for the `/appiq` slash command interactive system.

## Implementation Flow

### Phase 1: Initial Greeting and Project Type Selection

```
🚀 Welcome to APPIQ Method Mobile Development!

What type of mobile project are you working on?

1. Greenfield - New mobile app development (Flutter or React Native)
2. Brownfield - Enhancing existing mobile app

Please respond with 1 or 2:
```

**Expected Responses:** `1` or `2`
**Error Handling:** If invalid response, re-prompt with valid options

### Phase 2: Platform Selection (Greenfield Only)

**Trigger:** Only if user selected `1` (Greenfield)

```
📱 Platform Selection for New Mobile App:

Which mobile platform do you want to target?

1. Flutter - Cross-platform with Dart
2. React Native - Cross-platform with React/JavaScript  
3. Let APPIQ Method recommend based on requirements

Please respond with 1, 2, or 3:
```

**Expected Responses:** `1`, `2`, or `3`
**Logic:**
- `1` → Flutter workflows
- `2` → React Native workflows  
- `3` → Platform recommendation prompt → then selection

### Phase 3: Existing App Platform Detection (Brownfield Only)

**Trigger:** Only if user selected `2` (Brownfield)

```
📱 Existing Mobile App Platform Detection:

What platform is your existing mobile app built with?

1. Flutter - Dart-based cross-platform app
2. React Native - React/JavaScript-based app
3. Not sure - Let APPIQ Method analyze the codebase

Please respond with 1, 2, or 3:
```

**Expected Responses:** `1`, `2`, or `3`
**Logic:**
- `1` → Flutter brownfield workflow
- `2` → React Native brownfield workflow
- `3` → Codebase analysis → platform detection → appropriate workflow

### Phase 4: PRD Validation

```
📋 Checking for main_prd.md in your /docs/ folder...

Do you have a main_prd.md file in your /docs/ folder?
(You should create this manually and place it there before proceeding)

Please respond with yes or no:
```

**Expected Responses:** `yes` or `no`
**Logic:**
- `yes` → Continue to workflow launch
- `no` → Provide guidance for creating main_prd.md, then wait for confirmation

### Phase 5: Workflow Selection and Launch

Based on collected information, select appropriate workflow:

**Greenfield Workflows:**
- Greenfield + Flutter → `mobile-greenfield-flutter.yaml`
- Greenfield + React Native → `mobile-greenfield-react-native.yaml`

**Brownfield Workflows:**
- Brownfield + Flutter → `mobile-brownfield-flutter.yaml`
- Brownfield + React Native → `mobile-brownfield-react-native.yaml`

## Workflow Launch Messages

### Greenfield Flutter Launch
```
✅ Perfect! Launching Greenfield Flutter Mobile Development Workflow...

🎯 Starting with: mobile-greenfield-flutter.yaml
📍 First Agent: analyst (creating project-brief.md)
📂 Expected Output: docs/project-brief.md

The mobile development workflow will now guide you through:
1. Mobile-focused project brief
2. Mobile-specific PRD creation 
3. Flutter platform validation
4. Mobile UX design system
5. Flutter architecture planning
6. Mobile security review
7. Story creation and development

@analyst - Please begin with creating a mobile-focused project brief considering app store landscape, device capabilities, and mobile user behavior.
```

### Greenfield React Native Launch
```
✅ Perfect! Launching Greenfield React Native Mobile Development Workflow...

🎯 Starting with: mobile-greenfield-react-native.yaml
📍 First Agent: analyst (creating project-brief.md)
📂 Expected Output: docs/project-brief.md

The mobile development workflow will now guide you through:
1. Mobile-focused project brief
2. Mobile-specific PRD creation 
3. React Native platform validation
4. Mobile UX design system
5. React Native architecture planning
6. Mobile security review
7. Story creation and development

@analyst - Please begin with creating a mobile-focused project brief considering app store landscape, device capabilities, and mobile user behavior.
```

### Brownfield Flutter Launch
```
✅ Perfect! Launching Brownfield Flutter Mobile Enhancement Workflow...

🎯 Starting with: mobile-brownfield-flutter.yaml
📍 First Agent: analyst (classifying mobile enhancement scope)
📂 Expected Analysis: Flutter app analysis and enhancement classification

The mobile enhancement workflow will now guide you through:
1. Enhancement scope classification
2. Existing Flutter app analysis
3. Mobile PRD creation for enhancements
4. Flutter architecture updates (if needed)
5. Mobile security review
6. Story creation and development

@analyst - Please classify the mobile enhancement scope. Can you describe the Flutter app enhancement? Is this a small fix, a feature addition, or a major enhancement requiring architectural changes?
```

### Brownfield React Native Launch
```
✅ Perfect! Launching Brownfield React Native Mobile Enhancement Workflow...

🎯 Starting with: mobile-brownfield-react-native.yaml
📍 First Agent: analyst (classifying mobile enhancement scope)
📂 Expected Analysis: React Native app analysis and enhancement classification

The mobile enhancement workflow will now guide you through:
1. Enhancement scope classification
2. Existing React Native app analysis
3. Mobile PRD creation for enhancements
4. React Native architecture updates (if needed)
5. Mobile security review
6. Story creation and development

@analyst - Please classify the mobile enhancement scope. Can you describe the React Native app enhancement? Is this a small fix, a feature addition, or a major enhancement requiring architectural changes?
```

## Error States and Recovery

### Missing main_prd.md
```
❌ main_prd.md not found in /docs/ folder.

Please create your main Product Requirements Document first:

1. Create a /docs/ folder in your project root
2. Create a main_prd.md file with your project requirements
3. Place it at: /docs/main_prd.md
4. Run /appiq again

Would you like guidance on creating a main_prd.md file? (yes/no)
```

### Invalid Response
```
❌ Invalid response. Please respond with one of the specified options.

[Re-display current question]
```

### Platform Recommendation (Option 3)
```
🤔 Let APPIQ Method recommend the best platform for your project.

Based on your requirements in main_prd.md, please answer these questions:

1. Do you have an existing React/JavaScript web application? (yes/no)
2. Do you need maximum performance for graphics/animations? (yes/no)
3. Do you have existing React/JavaScript team expertise? (yes/no)
4. Do you need extensive native platform integrations? (yes/no)

[Collect responses and provide recommendation]

📊 Recommendation: [Flutter/React Native] based on your answers
Reasoning: [Specific reasoning based on responses]

Do you want to proceed with [recommended platform]? (yes/no)
```

## Integration Points

### With Existing Workflows
- Seamlessly integrates with existing APPIQ Method workflow system
- Uses established agent orchestration patterns
- Leverages existing templates and checklists

### With IDEs
- Claude: Native slash command support
- Cursor: Can be triggered via command palette or chat
- Windsurf: Integration via chat interface
- Other IDEs: Universal chat-based implementation

### With File System
- Automatically checks for /docs/ folder structure
- Validates main_prd.md existence
- Sets up expected file outputs for workflow

## State Management

The command maintains state through the interactive session:

1. **Project Type**: Greenfield or Brownfield
2. **Platform Choice**: Flutter, React Native, or Recommendation needed
3. **PRD Status**: Exists or needs creation
4. **Workflow Selection**: Final workflow to execute

This state is used to determine the exact workflow launch and initial agent prompt.

## Extensibility

The implementation is designed to be extensible for:
- Additional mobile platforms (native iOS/Android)
- Integration with other APPIQ Method expansion packs
- Custom workflow variations
- IDE-specific optimizations