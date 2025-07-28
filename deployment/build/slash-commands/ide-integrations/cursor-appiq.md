# Cursor IDE Integration - Universal APPIQ Method

## Implementation for Cursor AI Code Editor

Die APPIQ Method Commands in Cursor unterstützen alle Projekttypen: Web, Desktop, Mobile und Backend Development mit intelligenter Projekt-Erkennung.

## Verfügbare Commands

### `/start` - Universal Project Launcher (EMPFOHLEN)
```yaml
command: /start
description: Universal APPIQ Method Launcher mit intelligenter Projekt-Erkennung
category: Development
supported_projects: [web, desktop, mobile, backend]
```

### `/appiq` - Universal Project Launcher (Legacy-Support)
```yaml
command: /appiq
description: Universeller APPIQ Method Launcher (erweitert von Mobile-only)
category: Development
supported_projects: [web, desktop, mobile, backend]
legacy_support: true
```

## Integration Approaches

### Approach 1: Chat Command (Recommended)
Implementiere `/start` und `/appiq` als erkannte Chat Commands mit universeller Projekt-Unterstützung.

### Approach 2: Command Palette Integration
Hinzufügen der APPIQ Method Commands zur Cursor Command Palette für alle Projekttypen.

## Chat-Based Implementation

### Universal State Management
```typescript
interface CursorAppiqState {
  sessionId: string;
  projectType: 'greenfield' | 'brownfield' | null;
  applicationCategory: 'web' | 'desktop' | 'mobile' | 'backend' | 'auto-detect' | null;
  platform?: 'flutter' | 'react-native' | 'electron' | 'react' | 'vue' | 'angular';
  framework?: string;
  currentStep: AppiqStep;
  workspaceRoot: string;
  detectedProject?: ProjectDetection;
}

enum AppiqStep {
  PROJECT_STATUS = 'project-status',
  PROJECT_TYPE = 'project-type',
  AUTO_DETECTION = 'auto-detection',
  PLATFORM_SELECTION = 'platform-selection',
  WORKFLOW_LAUNCH = 'workflow-launch'
}

interface ProjectDetection {
  type: 'web' | 'desktop' | 'mobile' | 'backend' | 'unknown';
  framework: string;
  platform?: string;
  confidence: number;
  indicators: string[];
}
```

### Universal Workflow Handler
```typescript
class CursorUniversalAppiqHandler {
  private state: CursorAppiqState;
  private fileSystem: CursorFileSystem;
  private projectDetector: CursorProjectDetector;
  
  constructor(workspaceRoot: string) {
    this.state = {
      sessionId: generateSessionId(),
      projectType: null,
      applicationCategory: null,
      currentStep: AppiqStep.PROJECT_STATUS,
      workspaceRoot
    };
    this.fileSystem = new CursorFileSystem(workspaceRoot);
    this.projectDetector = new CursorProjectDetector(workspaceRoot);
  }
  
  handleMessage(message: string): string {
    switch (this.state.currentStep) {
      case AppiqStep.PROJECT_STATUS:
        return this.handleProjectStatusSelection(message);
      case AppiqStep.PROJECT_TYPE:
        return this.handleProjectTypeSelection(message);
      case AppiqStep.AUTO_DETECTION:
        return this.handleAutoDetection(message);
      case AppiqStep.PLATFORM_SELECTION:
        return this.handlePlatformSelection(message);
      default:
        return this.showProjectStatusSelection();
    }
  }
  
  private showProjectStatusSelection(): string {
    return `🚀 **APPIQ Method Universal Launcher**

Arbeiten wir an einem neuen oder bestehenden Projekt?

**1.** 🆕 Neues Projekt (Greenfield) - Wir bauen von Grund auf
**2.** 🔧 Bestehendes Projekt (Brownfield) - Wir erweitern/verbessern etwas

Antworte mit **1** oder **2**:`;
  }
  
  private showProjectTypeSelection(): string {
    return `📋 **Lass mich verstehen, was wir bauen...**

Was für eine Art von Anwendung ist das?

**1.** 🌐 Web-Anwendung (läuft im Browser)
**2.** 💻 Desktop-Anwendung (Electron, Windows/Mac App)
**3.** 📱 Mobile App (iOS/Android)
**4.** ⚙️ Backend/API Service (Server, Database)
**5.** 🤔 Bin mir nicht sicher - lass APPIQ entscheiden

Antworte mit **1**, **2**, **3**, **4** oder **5**:`;
  }
}
```

### Intelligent Project Detection
```typescript
class CursorProjectDetector {
  constructor(private workspaceRoot: string) {}
  
  async detectProject(): Promise<ProjectDetection> {
    const indicators: string[] = [];
    let type: ProjectDetection['type'] = 'unknown';
    let framework = '';
    let platform = '';
    let confidence = 0;
    
    // Flutter Detection
    if (await this.hasFile('pubspec.yaml')) {
      type = 'mobile';
      framework = 'Flutter';
      platform = 'flutter';
      confidence = 95;
      indicators.push('pubspec.yaml found');
    }
    
    // Package.json Analysis
    const packageJson = await this.readPackageJson();
    if (packageJson) {
      // Electron Detection
      if (packageJson.dependencies?.electron || packageJson.devDependencies?.electron) {
        type = 'desktop';
        framework = 'Electron';
        platform = 'electron';
        confidence = 90;
        indicators.push('electron dependency');
      }
      
      // React Native Detection
      else if (this.hasReactNativeDeps(packageJson)) {
        type = 'mobile';
        framework = 'React Native';
        platform = 'react-native';
        confidence = 90;
        indicators.push('react-native dependencies');
      }
      
      // Web Framework Detection
      else if (this.hasWebFramework(packageJson)) {
        type = 'web';
        const webFramework = this.detectWebFramework(packageJson);
        framework = webFramework.name;
        confidence = webFramework.confidence;
        indicators.push(`${framework} dependencies`);
      }
      
      // Backend Detection
      else if (this.hasBackendFramework(packageJson)) {
        type = 'backend';
        const backendFramework = this.detectBackendFramework(packageJson);
        framework = backendFramework.name;
        confidence = backendFramework.confidence;
        indicators.push(`${framework} dependencies`);
      }
    }
    
    // Python Backend Detection
    if (await this.hasFile('requirements.txt')) {
      const pythonFramework = await this.detectPythonFramework();
      if (pythonFramework) {
        type = 'backend';
        framework = pythonFramework;
        confidence = 85;
        indicators.push('Python requirements.txt');
      }
    }
    
    // Java Backend Detection
    if (await this.hasFile('pom.xml') || await this.hasFile('build.gradle')) {
      type = 'backend';
      framework = await this.hasFile('pom.xml') ? 'Maven/Spring' : 'Gradle/Spring';
      confidence = 80;
      indicators.push('Java build configuration');
    }
    
    return { type, framework, platform, confidence, indicators };
  }
  
  private hasReactNativeDeps(packageJson: any): boolean {
    return !!(packageJson.dependencies?.['react-native'] || 
              packageJson.devDependencies?.['react-native'] ||
              packageJson.dependencies?.['@react-native/metro-config']);
  }
  
  private hasWebFramework(packageJson: any): boolean {
    const webFrameworks = ['react', 'vue', 'angular', 'next', 'nuxt', 'svelte'];
    return webFrameworks.some(fw => 
      packageJson.dependencies?.[fw] || packageJson.devDependencies?.[fw]
    );
  }
  
  private detectWebFramework(packageJson: any): {name: string, confidence: number} {
    if (packageJson.dependencies?.next || packageJson.devDependencies?.next) {
      return { name: 'Next.js', confidence: 95 };
    }
    if (packageJson.dependencies?.react || packageJson.devDependencies?.react) {
      return { name: 'React', confidence: 90 };
    }
    if (packageJson.dependencies?.vue || packageJson.devDependencies?.vue) {
      return { name: 'Vue.js', confidence: 90 };
    }
    if (packageJson.dependencies?.['@angular/core']) {
      return { name: 'Angular', confidence: 90 };
    }
    return { name: 'Unknown Web Framework', confidence: 50 };
  }
  
  private hasBackendFramework(packageJson: any): boolean {
    const backendFrameworks = ['express', 'fastify', 'koa', 'hapi', 'nest'];
    return backendFrameworks.some(fw => 
      packageJson.dependencies?.[fw] || packageJson.devDependencies?.[fw]
    );
  }
  
  private detectBackendFramework(packageJson: any): {name: string, confidence: number} {
    if (packageJson.dependencies?.express) return { name: 'Express.js', confidence: 95 };
    if (packageJson.dependencies?.fastify) return { name: 'Fastify', confidence: 95 };
    if (packageJson.dependencies?.['@nestjs/core']) return { name: 'NestJS', confidence: 95 };
    if (packageJson.dependencies?.koa) return { name: 'Koa.js', confidence: 90 };
    return { name: 'Node.js Backend', confidence: 70 };
  }
}
```

### Universal Workflow Launcher
```typescript
class CursorUniversalWorkflowLauncher {
  constructor(private fileSystem: CursorFileSystem) {}
  
  async launchWorkflow(projectType: string, appCategory: string, platform?: string): Promise<string> {
    const workflowMapping = {
      // Greenfield Workflows
      'greenfield-web': 'greenfield-fullstack.yaml',
      'greenfield-desktop': 'greenfield-fullstack.yaml',
      'greenfield-mobile-flutter': 'mobile-greenfield-flutter.yaml',
      'greenfield-mobile-react-native': 'mobile-greenfield-react-native.yaml',
      'greenfield-backend': 'greenfield-service.yaml',
      
      // Brownfield Workflows
      'brownfield-web': 'brownfield-fullstack.yaml',
      'brownfield-desktop': 'brownfield-fullstack.yaml',
      'brownfield-mobile-flutter': 'mobile-brownfield-flutter.yaml',
      'brownfield-mobile-react-native': 'mobile-brownfield-react-native.yaml',
      'brownfield-backend': 'brownfield-service.yaml'
    };
    
    const workflowKey = platform ? 
      `${projectType}-${appCategory}-${platform}` : 
      `${projectType}-${appCategory}`;
    
    const workflowName = workflowMapping[workflowKey];
    const contextMessage = this.getContextMessage(appCategory, platform);
    
    return this.generateUniversalLaunchMessage(projectType, appCategory, platform, workflowName, contextMessage);
  }
  
  private getContextMessage(appCategory: string, platform?: string): string {
    const contextMap = {
      web: "Full-Stack Web-Anwendung mit Frontend und Backend Komponenten",
      desktop: "Electron Desktop-Anwendung mit plattformspezifischen Optimierungen",
      mobile: platform === 'flutter' ? 
        "Flutter Cross-Platform Mobile-Anwendung" : 
        "React Native Cross-Platform Mobile-Anwendung",
      backend: "API-Design und Datenarchitektur im Fokus"
    };
    
    return contextMap[appCategory] || "Universeller Entwicklungsworkflow";
  }
  
  private generateUniversalLaunchMessage(
    projectType: string, 
    appCategory: string, 
    platform: string | undefined, 
    workflowName: string, 
    context: string
  ): string {
    const typeDisplay = projectType.charAt(0).toUpperCase() + projectType.slice(1);
    const categoryDisplay = this.getCategoryDisplayName(appCategory, platform);
    
    return `✅ **Perfect! ${categoryDisplay} ${typeDisplay === 'Greenfield' ? 'Development' : 'Enhancement'} erkannt.**

🎯 **Starte ${typeDisplay} Workflow für ${categoryDisplay}...**
📍 **Fokus:** ${context}
📂 **Workflow:** \`${workflowName}\`
🎬 **Erster Agent:** analyst

**Der Workflow führt Sie durch:**
${this.getWorkflowSteps(appCategory, projectType)}

---

**@analyst** - ${this.getAnalystInstructions(appCategory, projectType)}`;
  }
  
  private getCategoryDisplayName(category: string, platform?: string): string {
    const displayMap = {
      web: "Web-Anwendung",
      desktop: "Desktop-Anwendung",
      mobile: platform === 'flutter' ? "Flutter Mobile App" : "React Native Mobile App",
      backend: "Backend Service"
    };
    
    return displayMap[category] || "Anwendung";
  }
  
  private getWorkflowSteps(category: string, projectType: string): string {
    const isNew = projectType === 'greenfield';
    
    const stepsMap = {
      web: isNew ? [
        "1. Projekt-Brief und Marktanalyse",
        "2. PRD für Web-Anwendung",
        "3. UX/UI Spezifikation",
        "4. Full-Stack Architektur",
        "5. Story-basierte Entwicklung"
      ] : [
        "1. Analyse der bestehenden Web-Anwendung",
        "2. Modernisierungs-Möglichkeiten identifizieren",
        "3. Sichere Integration planen",
        "4. Enhancement-Stories erstellen"
      ],
      
      desktop: isNew ? [
        "1. Desktop-App Konzeption",
        "2. Electron-spezifische Requirements",
        "3. Cross-Platform UI Design",
        "4. Desktop-Architektur",
        "5. Platform-spezifische Implementierung"
      ] : [
        "1. Analyse der Electron-Anwendung",
        "2. Performance-Optimierungen identifizieren",
        "3. Plattform-spezifische Verbesserungen",
        "4. Feature-Enhancement Planung"
      ],
      
      mobile: isNew ? [
        "1. Mobile-fokussierter Projekt-Brief",
        "2. Mobile-spezifische PRD",
        "3. Platform-Validierung",
        "4. Mobile UX Design",
        "5. Mobile Architektur-Planung"
      ] : [
        "1. Mobile App Analyse",
        "2. Platform-spezifische Optimierungen",
        "3. App Store Compliance Review",
        "4. Mobile Enhancement Stories"
      ],
      
      backend: isNew ? [
        "1. API und Service Konzeption",
        "2. Backend Requirements Definition",
        "3. Datenbank und Architektur Design",
        "4. API Spezifikation",
        "5. Service-orientierte Implementierung"
      ] : [
        "1. Backend Service Analyse",
        "2. API Evolution Planung",
        "3. Skalierungsoptimierungen",
        "4. Service Enhancement Stories"
      ]
    };
    
    return (stepsMap[category] || ["1. Allgemeine Projekt-Analyse"]).join("\n");
  }
  
  private getAnalystInstructions(category: string, projectType: string): string {
    const isNew = projectType === 'greenfield';
    
    const instructionsMap = {
      web: isNew ? 
        "Bitte erstelle einen Projekt-Brief für die Web-Anwendung mit Fokus auf Frontend/Backend Integration." :
        "Bitte analysiere die bestehende Web-Anwendung und identifiziere Modernisierungs-Möglichkeiten.",
      
      desktop: isNew ?
        "Bitte erstelle einen Projekt-Brief für die Desktop-Anwendung mit Electron-spezifischen Anforderungen." :
        "Bitte analysiere die bestehende Electron-Anwendung und identifiziere Verbesserungsmöglichkeiten.",
      
      mobile: isNew ?
        "Bitte erstelle einen mobile-fokussierten Projekt-Brief unter Berücksichtigung von App Store Landschaft und mobile User Behavior." :
        "Bitte analysiere die bestehende Mobile App und identifiziere platform-spezifische Optimierungen.",
      
      backend: isNew ?
        "Bitte erstelle einen Projekt-Brief für den Backend Service mit Fokus auf API Design und Skalierbarkeit." :
        "Bitte analysiere den bestehenden Backend Service und identifiziere Optimierungs-Möglichkeiten."
    };
    
    return instructionsMap[category] || "Bitte beginne mit der Projekt-Analyse.";
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
        "command": "appiq.start",
        "title": "APPIQ: Universal Project Launcher",
        "category": "APPIQ Method"
      },
      {
        "command": "appiq.appiq",
        "title": "APPIQ: Launch Project Workflow",
        "category": "APPIQ Method"
      },
      {
        "command": "appiq.greenfield.web",
        "title": "APPIQ: New Web Application",
        "category": "APPIQ Method"
      },
      {
        "command": "appiq.greenfield.desktop",
        "title": "APPIQ: New Desktop Application",
        "category": "APPIQ Method"
      },
      {
        "command": "appiq.greenfield.mobile",
        "title": "APPIQ: New Mobile Application",
        "category": "APPIQ Method"
      },
      {
        "command": "appiq.greenfield.backend",
        "title": "APPIQ: New Backend Service",
        "category": "APPIQ Method"
      },
      {
        "command": "appiq.brownfield.enhance",
        "title": "APPIQ: Enhance Existing Project",
        "category": "APPIQ Method"
      }
    ],
    "keybindings": [
      {
        "command": "appiq.start",
        "key": "ctrl+alt+s",
        "mac": "cmd+alt+s"
      },
      {
        "command": "appiq.appiq",
        "key": "ctrl+alt+a",
        "mac": "cmd+alt+a"
      }
    ]
  }
}
```

## Usage in Cursor

Users können mit der universellen APPIQ Method in verschiedenen Wegen interagieren:

1. **Chat Commands**: 
   - `/start` für den empfohlenen universellen Launcher
   - `/appiq` für den erweiterten Legacy-Launcher

2. **Command Palette**: `Ctrl+Shift+P` → "APPIQ: Universal Project Launcher"

3. **Keyboard Shortcuts**: 
   - `Ctrl+Alt+S` → `/start` Command
   - `Ctrl+Alt+A` → `/appiq` Command

4. **Direct Commands**: Spezifische Workflow-Commands für erfahrene Benutzer

## Best Practices für Cursor Integration

### Performance Optimierungen
```typescript
interface CursorPerformanceConfig {
  lazyLoading: boolean;        // Lade Workflows nur bei Bedarf
  cacheDetection: boolean;     // Cache Projekt-Erkennung
  batchOperations: boolean;    // Batch File-System-Operationen
  intelligentPreload: boolean; // Preload basierend auf Projekt-Patterns
}
```

### User Experience Enhancements
- **Progress Indicators**: Zeige Fortschritt bei Projekt-Erkennung
- **Smart Suggestions**: Basierend auf erkannten Patterns
- **Context Preservation**: Behalte Workflow-Kontext zwischen Sessions
- **Error Recovery**: Intelligent fallback bei Detection-Fehlern

Die Implementation bietet eine nahtlose Experience die sich in Cursor's bestehende Features integriert und alle Projekttypen mit intelligenter Erkennung unterstützt.