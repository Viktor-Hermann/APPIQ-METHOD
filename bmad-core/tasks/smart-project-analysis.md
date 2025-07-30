# Smart Project Analysis Task

## 📋 Overview
This task provides intelligent analysis of existing projects to understand their structure, tech stack, and optimal BMAD integration approach.

## 🎯 Task Objectives
- Analyze project structure and detect tech stack
- Identify existing architecture patterns
- Assess BMAD integration opportunities
- Recommend optimal workflow and agent configuration
- Generate actionable improvement suggestions

## 🔍 Analysis Framework

### Phase 1: Project Structure Analysis

#### File System Scanning
```bash
# Analyze project root structure
- Check for configuration files (package.json, pubspec.yaml, etc.)
- Identify source code organization
- Detect build and deployment configurations
- Analyze documentation structure
- Check for existing BMAD installation
```

#### Configuration Detection
```typescript
interface ProjectConfig {
  // Package managers and dependencies
  packageManager: 'npm' | 'yarn' | 'pnpm' | 'pub' | 'pip' | 'cargo' | 'go mod';
  dependencies: string[];
  devDependencies: string[];
  
  // Build and development tools
  buildTool: 'vite' | 'webpack' | 'rollup' | 'flutter build' | 'cargo' | 'go build';
  linting: 'eslint' | 'tslint' | 'dart analyze' | 'clippy';
  formatting: 'prettier' | 'dart format' | 'rustfmt';
  
  // Testing frameworks
  testing: 'jest' | 'vitest' | 'cypress' | 'playwright' | 'flutter test';
}
```

### Phase 2: Tech Stack Detection

#### Frontend Framework Detection
```typescript
const detectFrontendFramework = (dependencies: string[]) => {
  if (dependencies.includes('flutter')) return 'flutter';
  if (dependencies.includes('react')) return 'react';
  if (dependencies.includes('vue')) return 'vue';
  if (dependencies.includes('@angular/core')) return 'angular';
  if (dependencies.includes('svelte')) return 'svelte';
  return 'vanilla';
};
```

#### Backend Service Detection
```typescript
const detectBackendServices = (dependencies: string[], files: string[]) => {
  const services = [];
  
  // Firebase detection
  if (dependencies.includes('firebase') || files.includes('firebase.json')) {
    services.push('firebase');
  }
  
  // Supabase detection
  if (dependencies.includes('@supabase/supabase-js')) {
    services.push('supabase');
  }
  
  // Traditional backend
  if (dependencies.includes('express') || dependencies.includes('fastify')) {
    services.push('node-backend');
  }
  
  return services;
};
```

#### State Management Detection
```typescript
const detectStateManagement = (dependencies: string[], framework: string) => {
  switch (framework) {
    case 'flutter':
      if (dependencies.includes('flutter_bloc')) return 'cubit/bloc';
      if (dependencies.includes('riverpod')) return 'riverpod';
      break;
    case 'react':
      if (dependencies.includes('@reduxjs/toolkit')) return 'redux-toolkit';
      if (dependencies.includes('zustand')) return 'zustand';
      if (dependencies.includes('valtio')) return 'valtio';
      break;
    case 'vue':
      if (dependencies.includes('vuex')) return 'vuex';
      if (dependencies.includes('pinia')) return 'pinia';
      break;
  }
  return 'default';
};
```

### Phase 3: Architecture Pattern Analysis

#### Code Structure Analysis
```typescript
interface ArchitectureAnalysis {
  pattern: 'clean-architecture' | 'mvc' | 'layered' | 'component-based' | 'mixed';
  layerSeparation: 'strict' | 'loose' | 'none';
  dependencyDirection: 'correct' | 'violated' | 'unclear';
  testCoverage: 'high' | 'medium' | 'low' | 'none';
  documentation: 'comprehensive' | 'partial' | 'minimal' | 'none';
}
```

#### Flutter-Specific Analysis
```dart
// Analyze Flutter project structure
final flutterAnalysis = {
  'architecture': detectCleanArchitecture(),
  'stateManagement': detectStatePattern(),
  'localization': hasLocalization(),
  'responsiveDesign': hasResponsiveDesign(),
  'testing': analyzeTestStructure(),
};
```

### Phase 4: BMAD Integration Assessment

#### Current BMAD Status
```typescript
interface BMADStatus {
  installed: boolean;
  version: string | null;
  configuration: 'complete' | 'partial' | 'none';
  agents: string[];
  workflows: string[];
  expansionPacks: string[];
}
```

#### Integration Opportunities
```typescript
interface IntegrationOpportunities {
  // Missing BMAD components
  missingAgents: string[];
  missingWorkflows: string[];
  missingTemplates: string[];
  
  // Improvement opportunities
  architectureUpgrades: string[];
  qualityImprovements: string[];
  securityEnhancements: string[];
  performanceOptimizations: string[];
}
```

## 📊 Analysis Output

### Comprehensive Project Report
```markdown
# Project Analysis Report

## 📋 Project Overview
- **Name**: [Project Name]
- **Type**: [Greenfield/Brownfield]
- **Structure**: [Monorepo/Multi-repo/Single-app]
- **Size**: [Small/Medium/Large] ([LOC count])

## 🛠️ Tech Stack Analysis
- **Frontend**: [Framework] ([Version])
- **Backend**: [Service/Framework] ([Version])
- **Database**: [Type] ([Version])
- **State Management**: [Pattern/Library]
- **Testing**: [Frameworks and coverage]
- **Build Tools**: [Tools and configuration]

## 🏗️ Architecture Assessment
- **Pattern**: [Architecture pattern]
- **Quality Score**: [Score/10]
- **Maintainability**: [High/Medium/Low]
- **Scalability**: [High/Medium/Low]
- **Test Coverage**: [Percentage]

## 🎯 BMAD Integration Status
- **Current Status**: [Not installed/Partially configured/Fully configured]
- **Compatible Agents**: [List of applicable agents]
- **Recommended Workflow**: [Workflow type]
- **Expansion Packs**: [Recommended packs]

## 🚀 Recommendations

### Immediate Actions
1. [Priority 1 recommendation]
2. [Priority 2 recommendation]
3. [Priority 3 recommendation]

### Architecture Improvements
- [Architecture improvement 1]
- [Architecture improvement 2]

### Quality Enhancements
- [Quality enhancement 1]
- [Quality enhancement 2]

### Security Considerations
- [Security recommendation 1]
- [Security recommendation 2]

## 📋 Next Steps
1. **BMAD Setup**: [Setup instructions if needed]
2. **Agent Configuration**: [Agent setup recommendations]
3. **Workflow Selection**: [Recommended workflow]
4. **Documentation**: [Documentation tasks]
```

## 🤖 Execution Steps

### Step 1: Initialize Analysis
> 🔍 **Starting Project Analysis**
> 
> I'm analyzing your project to understand its structure and recommend the best BMAD integration approach.
> 
> This will take a moment...

### Step 2: Present Findings
> 📊 **Analysis Complete**
> 
> **Project Type**: [Detected type]
> **Tech Stack**: [Primary technologies]
> **Architecture**: [Current pattern]
> **BMAD Status**: [Current status]
> 
> **Quality Score**: [Score]/10
> 
> Would you like to see the detailed report? (Y/n)

### Step 3: Provide Recommendations
> 🎯 **Recommendations**
> 
> Based on my analysis, here are my top recommendations:
> 
> **Priority 1**: [Most important recommendation]
> **Priority 2**: [Second priority]
> **Priority 3**: [Third priority]
> 
> **Optimal BMAD Configuration**:
> - **Agents**: [Recommended agents]
> - **Workflow**: [Recommended workflow]
> - **Expansion Packs**: [If applicable]
> 
> Would you like me to:
> 1. **Set up BMAD** with recommended configuration
> 2. **Create improvement plan** with detailed steps
> 3. **Generate documentation** for current architecture
> 4. **Start with specific recommendation**
> 
> What would you prefer? (1/2/3/4)

### Step 4: Action Execution
Based on user choice, execute the selected action with intelligent guidance and validation.

## 🔧 Implementation Details

### Analysis Algorithms
- **Dependency Graph Analysis**: Understand component relationships
- **Code Complexity Metrics**: Assess maintainability and scalability
- **Pattern Recognition**: Identify architectural patterns and anti-patterns
- **Quality Metrics**: Calculate code quality scores
- **Security Scanning**: Identify potential security issues

### Intelligence Features
- **Context Awareness**: Understand project domain and requirements
- **Best Practice Validation**: Check against industry standards
- **Performance Analysis**: Identify performance bottlenecks
- **Scalability Assessment**: Evaluate scaling potential
- **Maintainability Review**: Assess long-term maintainability

## 📋 Success Criteria
- [ ] Complete project structure analyzed
- [ ] Tech stack accurately detected
- [ ] Architecture pattern identified
- [ ] Quality metrics calculated
- [ ] BMAD integration opportunities identified
- [ ] Actionable recommendations provided
- [ ] Clear next steps outlined
- [ ] User guided to optimal solution