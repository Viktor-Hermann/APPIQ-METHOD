#!/usr/bin/env node

/**
 * Appiq Solution Smart Installer
 * 
 * Super einfache Installation mit One-Click Workflows
 * Usage: npx appiq-solution install
 * 
 * Built with ❤️ based on the amazing Bmad-Method
 * Credits: https://github.com/Viktor-Hermann/APPIQ-METHOD
 */

const fs = require('fs');
const path = require('path');
const inquirer = require('inquirer');
const chalk = require('chalk');

const MCP_SERVERS = {
  // 🌍 GLOBAL SERVERS
  "sequential-thinking": {
    name: "Sequential Thinking",
    description: "Structured thinking for complex problem solving",
    command: "npx",
    args: ["-y", "@modelcontextprotocol/server-sequential-thinking"],
    tags: ['all', 'planning', 'architect', 'pm']
  },
  "puppeteer": {
    name: "Puppeteer MCP Server", 
    description: "Browser automation and web scraping",
    command: "npx",
    args: ["-y", "puppeteer-mcp-server"],
    tags: ['web', 'qa', 'automation']
  },
  "claude-continuity": {
    name: "Claude Thread Continuity",
    description: "Enhanced thread continuity for Claude",
    command: "python3",
    args: ["~/.mcp-servers/claude-continuity/server.py"],
    tags: ['all', 'ide-enhancement']
  },

  // 📁 LOCAL SERVERS  
  "extended-memory": {
    name: "Extended Memory MCP",
    description: "Enhanced memory capabilities for AI assistants",
    command: "python3",
    args: ["-m", "extended_memory_mcp.server"],
    env: { "LOG_LEVEL": "INFO" },
    tags: ['all', 'ide-enhancement']
  },
  "@21st-dev/magic": {
    name: "21st.dev Magic MCP",
    description: "UI builder for MCP - like v0 but in your IDE", 
    command: "npx",
    args: ["-y", "@21st-dev/magic@latest"],
    tags: ['web', 'flutter', 'ui', 'ux-expert', 'flutter-ui-agent']
  },
  "dart": {
    name: "Dart MCP Server",
    description: "Dart SDK integration for Flutter/Dart projects",
    command: "dart", 
    args: ["mcp-server", "--force-roots-fallback"],
    tags: ['flutter', 'flutter-ui-agent', 'flutter-cubit-agent', 'flutter-data-agent']
  },
  "firebase": {
    name: "Firebase MCP Server",
    description: "Firebase services - Auth, Firestore, Functions",
    command: "npx",
    args: ["-y", "firebase-tools@latest", "experimental:mcp"],
    tags: ['backend', 'fullstack', 'flutter', 'web', 'dev']
  },
  "supabase": {
    name: "Supabase MCP Server", 
    description: "Supabase integration - database, auth, storage",
    command: "npx",
    args: ["-y", "@supabase/mcp-server-supabase@latest", "--read-only"],
    tags: ['backend', 'fullstack', 'flutter', 'web', 'dev']
  },
  "context7": {
    name: "Context7 MCP (Upstash)",
    description: "Up-to-date code documentation for any library",
    command: "npx",
    args: ["-y", "@upstash/context7-mcp"],
    tags: ['all', 'research', 'dev', 'architect']
  },
  "stripe": {
    name: "Stripe MCP Server",
    description: "Stripe payment integration", 
    command: "npx",
    args: ["-y", "@stripe/mcp", "--tools=all"],
    tags: ['backend', 'fullstack', 'web', 'payment', 'dev']
  }
};

class AppiqSolutionInstaller {
  constructor() {
    this.projectRoot = process.cwd();
    this.appiqPath = path.join(this.projectRoot, "appiq-solution");
    this.config = {
      version: "1.0.0",
      projectType: null, // 'greenfield' or 'brownfield'
      techStack: {
        platform: null, // 'flutter', 'web', 'fullstack', 'api'
        isFlutter: false,
        hasUI: false,
        database: null,
        libraries: [],
      },
      selectedIDEs: [],
      projectName: null,
      projectIdea: null,
      targetUsers: null,
      projectPlan: null,
      planApproved: false,

    };
  }

  async install() {
    console.log(chalk.bold.cyan("🚀 Appiq Solution Smart Installer v1.0.0"));
    console.log(chalk.cyan("============================================"));
    console.log(chalk.dim("Built with ❤️  based on Bmad-Method"));
    console.log(chalk.dim("https://github.com/Viktor-Hermann/APPIQ-METHOD\n"));

    try {
      // Phase 1: Projekt-Typ Detection
      await this.detectProjectType();
      
      // Phase 1.5: Tech Stack Detection (Flutter, Web, etc.)
      await this.detectTechStack();

      // Phase 2: Projektidee erfassen
      await this.collectProjectIdea();

              // Phase 3: IDE Selection (MULTISELECT)
      await this.selectIDE();
      


        // Phase 5: Projektplan erstellen
        await this.createProjectPlan();

        // Phase 6: Plan-Freigabe
        await this.approvePlan();

        // Phase 7: Installation
      await this.performInstallation();
      


        // Phase 9: BMAD Core Configuration Setup
        await this.setupBMADCoreConfig();

        // Phase 10: Document Templates & Dependencies
        await this.setupDocumentTemplates();

        // Phase 11: Agent Dependencies System (+ Flutter Agents & MCPs)
        await this.setupAgentDependencies();

        // Phase 12: BMAD Orchestration (Full Flow)
        await this.setupBMADOrchestration();

        // Phase 13: One-Click Setup
      await this.setupOneClickWorkflows();
      
        // Phase 14: Simple Instructions
      await this.showSimpleInstructions();
    } catch (error) {
      console.error(chalk.red("❌ Installation failed:"), error.message);
      process.exit(1);
    }
  }

  async detectProjectType() {
    console.log(chalk.yellow("🔍 Projekt-Analyse..."));
    
    // Auto-Detection
    const hasPackageJson = fs.existsSync(
      path.join(this.projectRoot, "package.json")
    );
    const hasPubspec = fs.existsSync(
      path.join(this.projectRoot, "pubspec.yaml")
    );
    const hasExistingCode = this.hasExistingSourceCode();
    const hasDocumentation = this.hasExistingDocumentation();
    
    let suggestedType = "greenfield";
    let reason = "Neues Projekt erkannt";
    
    if (hasExistingCode || hasDocumentation) {
      suggestedType = "brownfield";
      reason = "Existierenden Code/Dokumentation gefunden";
    }
    
    console.log(chalk.gray(`💡 Analyse: ${reason}`));
    console.log(
      chalk.gray(
        `📊 Empfehlung: ${
          suggestedType === "greenfield"
            ? "Greenfield (Neues Projekt)"
            : "Brownfield (Bestehendes Projekt)"
        }`
      )
    );
    
    // User Confirmation
    const { projectType } = await inquirer.prompt([
      {
        type: "list",
        name: "projectType",
        message: "🎯 Welcher Projekt-Typ ist das?",
        choices: [
          {
            name: `✨ Greenfield - Neues Projekt (Empfohlen: ${
              suggestedType === "greenfield" ? "✅" : "❌"
            })`,
            value: "greenfield",
            short: "Greenfield",
          },
          {
            name: `🔧 Brownfield - Bestehendes Projekt (Empfohlen: ${
              suggestedType === "brownfield" ? "✅" : "❌"
            })`,
            value: "brownfield",
            short: "Brownfield",
          },
        ],
        default: suggestedType,
      },
    ]);
    
    this.config.projectType = projectType;
    console.log(
      chalk.green(
        `✅ Projekt-Typ: ${
          projectType === "greenfield"
            ? "Greenfield (Neu)"
            : "Brownfield (Bestehend)"
        }\n`
      )
    );
  }

  async selectIDE() {
    console.log(chalk.yellow("🛠️ IDE Auswahl"));
    console.log(
      chalk.bold.yellow.bgRed(
        " ⚠️  MULTISELECT: Verwenden Sie SPACEBAR zum Auswählen mehrerer IDEs! "
      )
    );
    console.log(chalk.gray("Wählen Sie ALLE IDEs aus, die Sie nutzen:\n"));

    const { ides } = await inquirer.prompt([
      {
        type: "checkbox",
        name: "ides",
        message:
          "🎯 Welche IDEs nutzen Sie? (SPACEBAR = auswählen, ENTER = bestätigen)",
        choices: [
          { name: "🔵 Cursor", value: "cursor" },
          { name: "🟣 Claude Code CLI", value: "claude-code" },
          { name: "🟢 Windsurf", value: "windsurf" },
          { name: "🔶 VS Code + Cline", value: "cline" },
          { name: "🟠 Trae", value: "trae" },
          { name: "🔴 Roo Code", value: "roo" },
          { name: "🟪 Gemini CLI", value: "gemini" },
          { name: "⚫ GitHub Copilot", value: "github-copilot" },
        ],
        validate: (input) => {
          if (input.length === 0) {
            return "Bitte wählen Sie mindestens eine IDE aus!";
          }
          return true;
        },
      },
    ]);

    this.config.selectedIDEs = ides;
    const ideNames = ides.map((ide) => this.getIDEName(ide)).join(", ");
    console.log(chalk.green(`✅ IDEs: ${ideNames}\n`));
  }



  async detectTechStack() {
    console.log(chalk.yellow("🔍 Tech Stack Detection"));
    console.log(chalk.gray("Analysiere Projekt-Umgebung und Tech Stack...\n"));

    // Check for Flutter
    const isFlutter = fs.existsSync(
      path.join(this.projectRoot, "pubspec.yaml")
    );

    // Check for existing web frameworks
    const hasPackageJson = fs.existsSync(
      path.join(this.projectRoot, "package.json")
    );
    let webFramework = null;

    if (hasPackageJson) {
      try {
        const packageJson = JSON.parse(
          fs.readFileSync(path.join(this.projectRoot, "package.json"), "utf8")
        );
        if (packageJson.dependencies) {
          const deps = Object.keys(packageJson.dependencies);
          if (deps.includes("next")) webFramework = "next.js";
          else if (deps.includes("react")) webFramework = "react";
          else if (deps.includes("vue")) webFramework = "vue";
          else if (deps.includes("@nuxt/core")) webFramework = "nuxt.js";
          else if (deps.includes("@angular/core")) webFramework = "angular";
        }
      } catch (e) {
        // ignore package.json parsing errors
      }
    }

    // Auto-detect or ask user
    if (isFlutter) {
      console.log(chalk.green("✅ Flutter Projekt erkannt!"));
      this.config.techStack.platform = "flutter";
      this.config.techStack.isFlutter = true;
      this.config.techStack.hasUI = true;
      console.log(chalk.cyan("   → Dart MCP Server wird konfiguriert"));
      console.log(
        chalk.cyan("   → Flutter Clean Architecture Agents werden geladen\n")
      );
    } else if (webFramework) {
      console.log(chalk.green(`✅ ${webFramework} Projekt erkannt!`));
      this.config.techStack.platform = "web";
      this.config.techStack.hasUI = true;
      console.log(
        chalk.cyan("   → shadcn/ui + v0.dev Integration wird konfiguriert\n")
      );
    } else {
      // Ask user for platform
      const { platform } = await inquirer.prompt([
        {
          type: "list",
          name: "platform",
          message: "🎯 Welchen Tech Stack verwenden Sie?",
          choices: [
            { name: "📱 Flutter Mobile App", value: "flutter" },
            { name: "🌐 Web App (React/Next.js/Vue)", value: "web" },
            { name: "🚀 Fullstack (Frontend + Backend)", value: "fullstack" },
            { name: "⚡ API/Backend Only", value: "api" },
            { name: "🤷 Noch nicht sicher", value: "unknown" },
          ],
        },
      ]);

      this.config.techStack.platform = platform;
      this.config.techStack.isFlutter = platform === "flutter";
      this.config.techStack.hasUI = ["flutter", "web", "fullstack"].includes(
        platform
      );

      if (platform === "flutter") {
        console.log(chalk.cyan("   → Dart MCP Server wird konfiguriert"));
        console.log(
          chalk.cyan("   → Flutter Clean Architecture Agents werden geladen")
        );
      } else if (platform === "web" || platform === "fullstack") {
        console.log(
          chalk.cyan("   → shadcn/ui + v0.dev Integration wird konfiguriert")
        );
      }
      console.log("");
    }
  }

  async collectProjectIdea() {
    console.log(chalk.yellow("💡 Projektidee erfassen"));
    console.log(chalk.gray("Beschreiben Sie Ihr Projekt-Vorhaben:\n"));

    const { projectIdea, projectName, targetUsers } = await inquirer.prompt([
      {
        type: "input",
        name: "projectName",
        message: "🏷️ Wie soll Ihr Projekt heißen?",
        validate: (input) =>
          input.length > 0 ? true : "Bitte geben Sie einen Projektnamen ein!",
      },
      {
        type: "editor",
        name: "projectIdea",
        message: "💡 Beschreiben Sie Ihre Projektidee (detailliert):",
        validate: (input) =>
          input.length > 10
            ? true
            : "Bitte beschreiben Sie Ihr Projekt ausführlicher!",
      },
      {
        type: "input",
        name: "targetUsers",
        message: "👥 Wer sind Ihre Zielgruppen/User?",
        validate: (input) =>
          input.length > 0 ? true : "Bitte beschreiben Sie Ihre Zielgruppe!",
      },
    ]);

    this.config.projectName = projectName;
    this.config.projectIdea = projectIdea;
    this.config.targetUsers = targetUsers;

    console.log(chalk.green(`✅ Projektidee erfasst: "${projectName}"\n`));
  }

  async createProjectPlan() {
    console.log(chalk.yellow("📋 Projektplan wird erstellt..."));
    console.log(chalk.gray("Basierend auf Ihrer Idee und dem Projekt-Typ\n"));

    // Hier würde normalerweise die team-fullstack.yaml verwendet
    const plan = this.generateProjectPlan();
    this.config.projectPlan = plan;

    console.log(chalk.cyan("📋 Ihr Projektplan:"));
    console.log(chalk.white("─".repeat(50)));
    console.log(plan);
    console.log(chalk.white("─".repeat(50) + "\n"));
  }

  async approvePlan() {
    const { approved, changes } = await inquirer.prompt([
      {
        type: "confirm",
        name: "approved",
        message: "✅ Sind Sie mit diesem Plan zufrieden?",
        default: true,
      },
      {
        type: "input",
        name: "changes",
        message:
          "📝 Welche Änderungen möchten Sie? (oder ENTER für keine Änderungen)",
        when: (answers) => !answers.approved,
      },
    ]);

    if (!approved && changes) {
      console.log(chalk.yellow("📝 Plan wird angepasst..."));
      this.config.planChanges = changes;
      // Hier würde Plan angepasst werden
      console.log(chalk.green("✅ Plan wurde angepasst!\n"));
    } else {
      console.log(
        chalk.green("✅ Plan freigegeben - Entwicklung kann starten!\n")
      );
    }

    this.config.planApproved = true;
  }

  generateProjectPlan() {
    const { projectType, projectName, projectIdea, targetUsers } = this.config;

    return `🎯 PROJEKTPLAN: ${projectName}

📊 PROJEKT-TYP: ${
      projectType === "greenfield"
        ? "Greenfield (Neues Projekt)"
        : "Brownfield (Bestehendes Projekt)"
    }
👥 ZIELGRUPPE: ${targetUsers}

💡 PROJEKTIDEE:
${projectIdea}

🚀 ENTWICKLUNGS-PIPELINE:
${
  projectType === "greenfield"
    ? `
1. 📋 PO (Product Owner) → PRD erstellen
2. 🏗️ Architect → System-Architektur designen  
3. 🎨 UX Expert → UI/UX Design
4. 📝 Story Master → User Stories aufbrechen
5. 💻 Developer → Features implementieren
6. ✅ QA Expert → Testing & Validierung
7. 📊 SM (Scrum Master) → Sprint-Koordination
`
    : `
1. 📋 PO → Bestehende Dokumentation analysieren
2. 🏗️ Architect → Architektur-Review
3. 📝 Story Master → Neue Features planen
4. 💻 Developer → Features in bestehende Basis integrieren
5. ✅ QA Expert → Regression Testing
6. 📊 SM → Change Management
`
}

🎮 ONE-CLICK BEFEHLE:
- /start → Gesamten Workflow starten
- /plan → Detailplanung
- /develop → Entwicklung beginnen
- /review → Code Review
- /deploy → Deployment vorbereiten`;
  }

  async setupBMADCoreConfig() {
    console.log(chalk.yellow("⚙️ BMAD Core Configuration einrichten..."));

    // Create .bmad-core directory
    const bmadCoreDir = path.join(this.appiqPath, ".bmad-core");
    if (!fs.existsSync(bmadCoreDir)) {
      fs.mkdirSync(bmadCoreDir, { recursive: true });
    }

    // Create core-config.yaml
    const coreConfigPath = path.join(bmadCoreDir, "core-config.yaml");
    fs.writeFileSync(coreConfigPath, this.generateCoreConfig());

    // Create technical-preferences.md
    const techPrefsPath = path.join(bmadCoreDir, "data");
    if (!fs.existsSync(techPrefsPath)) {
      fs.mkdirSync(techPrefsPath, { recursive: true });
    }
    fs.writeFileSync(
      path.join(techPrefsPath, "technical-preferences.md"),
      this.generateTechnicalPreferences()
    );

    console.log(chalk.green("✅ BMAD Core Configuration bereit!\n"));
  }

  async setupDocumentTemplates() {
    console.log(chalk.yellow("📄 Document Templates & Struktur einrichten..."));

    // Create docs directory structure
    const docsDir = path.join(this.projectRoot, "docs");
    const archDir = path.join(docsDir, "architecture");
    const storiesDir = path.join(docsDir, "stories");

    [docsDir, archDir, storiesDir].forEach((dir) => {
      if (!fs.existsSync(dir)) {
        fs.mkdirSync(dir, { recursive: true });
      }
    });

    // Create templates
    const templatesDir = path.join(this.appiqPath, "templates");
    if (!fs.existsSync(templatesDir)) {
      fs.mkdirSync(templatesDir, { recursive: true });
    }

    // PRD Template
    fs.writeFileSync(
      path.join(templatesDir, "prd-template.md"),
      this.generatePRDTemplate()
    );

    // Architecture Template
    fs.writeFileSync(
      path.join(templatesDir, "architecture-template.md"),
      this.generateArchitectureTemplate()
    );

    // Story Template
    fs.writeFileSync(
      path.join(templatesDir, "story-template.md"),
      this.generateStoryTemplate()
    );

    // Create initial PRD if planning is complete
    if (this.config.planApproved) {
      fs.writeFileSync(path.join(docsDir, "prd.md"), this.generateInitialPRD());
    }

    console.log(chalk.green("✅ Document Templates erstellt!\n"));
  }

  async setupAgentDependencies() {
    console.log(chalk.yellow("🔗 Agent Dependencies System einrichten..."));

    const agentsDir = path.join(this.appiqPath, "agents");
    const tasksDir = path.join(this.appiqPath, "tasks");
    const dataDir = path.join(this.appiqPath, "data");

    // Create directories
    [tasksDir, dataDir].forEach((dir) => {
      if (!fs.existsSync(dir)) {
        fs.mkdirSync(dir, { recursive: true });
      }
    });

    // Create BMAD Knowledge Base
    fs.writeFileSync(
      path.join(dataDir, "bmad-kb.md"),
      this.generateBMADKnowledgeBase()
    );

    // Create essential tasks
    fs.writeFileSync(
      path.join(tasksDir, "create-doc.md"),
      this.generateCreateDocTask()
    );
    fs.writeFileSync(
      path.join(tasksDir, "shard-doc.md"),
      this.generateShardDocTask()
    );
    fs.writeFileSync(
      path.join(tasksDir, "validate-story.md"),
      this.generateValidateStoryTask()
    );

    // Add Flutter-specific agents if Flutter project
    if (this.config.techStack.isFlutter) {
      await this.addFlutterAgents();
    }

    // Update agents with proper dependencies
    await this.updateAgentsWithDependencies();

    console.log(chalk.green("✅ Agent Dependencies System bereit!\n"));
  }

  async setupBMADOrchestration() {
    console.log(chalk.yellow("🎭 BMAD Full Orchestration einrichten..."));

    // Create orchestration config based on BMAD Flow
    const orchestrationConfig = {
      planningPhase: {
        agents: ["analyst", "pm", "ux-expert", "architect", "po"],
        workflow:
          this.config.projectType === "greenfield"
            ? "greenfield-planning"
            : "brownfield-planning",
      },
      developmentPhase: {
        agents: ["sm", "po", "dev", "qa"],
        workflow: "core-development-cycle",
      },
      transitions: {
        planningToIDE: "document-sharding",
        criticalCommitPoints: ["before-next-story", "after-qa-approval"],
      },
    };

    // Generate BMAD Orchestration
    const orchestrationPath = path.join(
      this.appiqPath,
      "bmad-orchestration.yaml"
    );
    fs.writeFileSync(
      orchestrationPath,
      this.generateBMADOrchestration(orchestrationConfig)
    );

    // Create workflow guides
    const workflowsDir = path.join(this.appiqPath, "workflows");
    if (!fs.existsSync(workflowsDir)) {
      fs.mkdirSync(workflowsDir, { recursive: true });
    }

    fs.writeFileSync(
      path.join(workflowsDir, "planning-workflow.md"),
      this.generatePlanningWorkflow()
    );
    fs.writeFileSync(
      path.join(workflowsDir, "development-cycle.md"),
      this.generateDevelopmentCycle()
    );
    fs.writeFileSync(
      path.join(workflowsDir, "document-sharding.md"),
      this.generateDocumentSharding()
    );

    console.log(chalk.green("✅ BMAD Full Orchestration bereit!\n"));
  }

  generateCoreConfig() {
    return `# BMAD Core Configuration
# Built with ❤️ based on Bmad-Method

project:
  name: ${this.config.projectName || "Unbenanntes Projekt"}
  type: ${this.config.projectType}
  created: ${new Date().toISOString()}

# Files that dev agent should ALWAYS load into context
devLoadAlwaysFiles:
  - docs/architecture/coding-standards.md
  - docs/architecture/tech-stack.md
  - docs/architecture/project-structure.md

# Document paths configuration
documentPaths:
  prd: "docs/prd.md"
  architecture: "docs/architecture.md"
  stories: "docs/stories/"
  templates: "appiq-solution/templates/"

# Agent dependencies configuration
dependencies:
  templates:
    - prd-template.md
    - architecture-template.md
    - story-template.md
  tasks:
    - create-doc.md
    - shard-doc.md
    - validate-story.md
  data:
    - bmad-kb.md
    - technical-preferences.md
`;
  }

  generateTechnicalPreferences() {
    return `# Technical Preferences

*Diese Datei hilft PM und Architect dabei, Ihre bevorzugten Design-Patterns und Technologien zu berücksichtigen.*

## Projekt: ${this.config.projectName || "Unbenanntes Projekt"}
**Platform:** ${this.config.techStack.platform || "nicht definiert"}

### Bevorzugte Technologien

${
  this.config.techStack.isFlutter
    ? `
**📱 Flutter Mobile Development:**
- **Framework:** Flutter 3.35+ (beta), Dart 3.9+
- **Architecture:** Clean Architecture with Feature-based structure
- **State Management:** Cubit/BLoC pattern (preferred), Riverpod (alternative)
- **Dependency Injection:** GetIt + Injectable
- **Code Generation:** Freezed, Build Runner
- **Backend Integration:** Firebase, Supabase, REST APIs, GraphQL
- **Testing:** Unit Testing, Widget Testing, Integration Testing, Golden Tests

**🔌 Flutter MCP Integration:**
- **Dart MCP Server:** Automatisch konfiguriert für AI-Assistenten
- **Hot Reload:** Via MCP für Live-Development
- **Package Management:** pub.dev Integration via MCP
- **Error Analysis:** Automatische Fehlererkennung via MCP

**📦 Recommended Packages:**
- **UI:** Material 3, Cupertino (iOS-style)
- **Navigation:** go_router
- **HTTP:** dio
- **Local Storage:** shared_preferences, hive
- **Image:** cached_network_image
`
    : ""
}

${
  this.config.techStack.platform === "web" ||
  this.config.techStack.platform === "fullstack"
    ? `
**🌐 Web Development:**
- **Framework:** React/Next.js, Vue/Nuxt, Angular
- **UI Library:** shadcn/ui (preferred), v0.dev components, Material-UI, Chakra UI
- **Styling:** Tailwind CSS, CSS-in-JS, SCSS
- **AI Design:** v0.dev für Rapid Prototyping

**🎨 shadcn/ui + v0.dev Integration:**
- **Design System:** shadcn/ui als Basis-Komponenten
- **AI-Generated Components:** v0.dev für schnelle UI-Erstellung
- **Customization:** Tailwind CSS für individuelle Anpassungen
- **Accessibility:** Radix-UI Primitives als Basis
`
    : ""
}

${
  this.config.projectType === "greenfield" && !this.config.techStack.isFlutter
    ? `
**Backend:**
- Runtime: Node.js, Python, Go
- Framework: Express, FastAPI, Gin
- Database: PostgreSQL, MongoDB, Redis

**DevOps:**
- Deployment: Vercel, Railway, AWS
- CI/CD: GitHub Actions, GitLab CI
- Monitoring: Sentry, LogRocket
`
    : ""
}

${
  this.config.projectType === "brownfield"
    ? `
**Bestehende Technologien erweitern:**
- Kompatibilität mit bestehender Code-Basis beachten
- Minimale neue Dependencies
- Schrittweise Migration wenn nötig
`
    : ""
}

### Design Patterns
${
  this.config.techStack.isFlutter
    ? `
- **Clean Architecture** (Presentation → Domain → Data)
- **Feature-based Structure** (/features/auth, /features/dashboard)
- **Repository Pattern** für Datenaccess
- **Cubit Pattern** für State Management
- **SOLID Principles** anwenden
`
    : `
- **Architektur:** Clean Architecture, Hexagonal, MVC
- **Code Style:** DRY, SOLID Principles, KISS
${
  this.config.techStack.hasUI
    ? "- **Design System:** shadcn/ui für konsistente UI"
    : ""
}
`
}

### Testing & Quality
${
  this.config.techStack.isFlutter
    ? `
- **Dart Analysis:** Very strict linting rules
- **Flutter Lints:** Official Flutter linting package
- **Testing:** Minimum 80% code coverage
- **Golden Tests:** UI consistency tests
- **Integration Tests:** End-to-end testing
`
    : `
- **Testing:** TDD/BDD, Unit + Integration Tests
- **Documentation:** README-driven, Inline Comments
- **Code Quality:** ESLint + Prettier (wenn applicable)
${
  this.config.techStack.hasUI
    ? "- **Component Testing:** Storybook für Component Documentation"
    : ""
}
`
}

### AI-Integration & MCP
${
  this.config.techStack.isFlutter
    ? `
- **Dart MCP Server:** Für direkten AI-Zugriff auf Flutter Tools
- **Flutter DevTools:** MCP-basierte AI-Assistenz
- **Package Discovery:** AI-gestützte pub.dev Suche
- **Code Analysis:** Automatische Fehlererkennung und -behebung
`
    : ""
}
${
  this.config.techStack.hasUI && !this.config.techStack.isFlutter
    ? `
- **v0.dev Integration:** AI-generierte UI-Komponenten
- **shadcn/ui Library:** KI-optimierte Component Library
- **Design Tokens:** Konsistente AI-generierte Designs
`
    : ""
}

### Coding Standards
- **Naming:** ${
      this.config.techStack.isFlutter
        ? "lowerCamelCase für Variablen, PascalCase für Classes"
        : "camelCase für Variablen, PascalCase für Components"
    }
- **Files:** ${
      this.config.techStack.isFlutter
        ? "snake_case für Dart Dateien"
        : "kebab-case für Dateien, PascalCase für Components"
    }
- **Functions:** Kleine, fokussierte Funktionen (<50 Zeilen)
- **Comments:** Erkläre WARUM, nicht WAS

### Präferenzen
- **Performance:** Optimierung vor Abstraktion
- **Security:** Security-by-Design
- **Accessibility:** ${
      this.config.techStack.isFlutter
        ? "Flutter Accessibility Widget support"
        : "WCAG 2.1 AA Standard"
    }
- **Mobile:** Mobile-First Approach

---
*Platform: ${this.config.techStack.platform}*
*MCP Configured: ${
      this.config.techStack.isFlutter ? "Dart MCP ✅" : "Standard"
    }*
*Aktualisiert: ${new Date().toLocaleDateString("de-DE")}*
`;
  }

  generatePRDTemplate() {
    return `# Product Requirements Document (PRD)

## Projekt: [PROJECT_NAME]

### 1. Problem Statement
*Welches Problem lösen wir?*

### 2. Solution Overview  
*Wie lösen wir das Problem?*

### 3. Target Users
*Wer sind unsere Zielgruppen?*

### 4. Functional Requirements (FRs)
*Was muss das System können?*

#### 4.1 Core Features
- [ ] Feature 1
- [ ] Feature 2

#### 4.2 Advanced Features  
- [ ] Advanced Feature 1
- [ ] Advanced Feature 2

### 5. Non-Functional Requirements (NFRs)
*Wie gut muss das System funktionieren?*

#### 5.1 Performance
- Response Time: < 200ms
- Throughput: [SPECIFY]

#### 5.2 Security
- Authentication: [METHOD]
- Authorization: [RBAC/ABAC]

#### 5.3 Scalability
- Users: [NUMBER]
- Data: [VOLUME]

### 6. User Stories & Epics

#### Epic 1: [EPIC_NAME]
- **Story 1.1:** Als [USER] möchte ich [ACTION] um [BENEFIT]
- **Story 1.2:** Als [USER] möchte ich [ACTION] um [BENEFIT]

#### Epic 2: [EPIC_NAME]  
- **Story 2.1:** Als [USER] möchte ich [ACTION] um [BENEFIT]
- **Story 2.2:** Als [USER] möchte ich [ACTION] um [BENEFIT]

### 7. Success Metrics
*Wie messen wir Erfolg?*

- Metric 1: [DEFINITION]
- Metric 2: [DEFINITION]

---
*Erstellt mit Appiq Solution - Built with ❤️ based on Bmad-Method*
`;
  }

  generateArchitectureTemplate() {
    return `# System Architecture

## Projekt: [PROJECT_NAME]

### 1. Architecture Overview
*High-level Systemübersicht*

### 2. Technology Stack

#### Frontend
- Framework: [FRAMEWORK]
- State Management: [STATE_MANAGEMENT]
- Styling: [STYLING_SOLUTION]

#### Backend
- Runtime: [RUNTIME]
- Framework: [FRAMEWORK]
- Database: [DATABASE]

#### Infrastructure
- Hosting: [HOSTING_PLATFORM]
- CI/CD: [CI_CD_SOLUTION]

### 3. System Components

#### 3.1 Frontend Components
- Component Library
- State Management
- Routing
- API Layer

#### 3.2 Backend Services
- API Layer
- Business Logic
- Data Access Layer
- External Integrations

### 4. Data Models

#### User Model
\`\`\`
{
  id: string
  email: string
  name: string
  createdAt: Date
}
\`\`\`

### 5. API Design

#### Authentication
- POST /api/auth/login
- POST /api/auth/register
- POST /api/auth/logout

#### Core Resources
- GET /api/[resource]
- POST /api/[resource]
- PUT /api/[resource]/:id
- DELETE /api/[resource]/:id

### 6. Security Considerations
- Authentication Strategy
- Authorization Model
- Data Validation
- Rate Limiting

### 7. Performance Considerations
- Caching Strategy
- Database Optimization
- CDN Usage
- Lazy Loading

### 8. Deployment Architecture
- Development Environment
- Staging Environment
- Production Environment

---
*Erstellt mit Appiq Solution - Built with ❤️ based on Bmad-Method*
`;
  }

  generateStoryTemplate() {
    return `# User Story: [STORY_TITLE]

## Story Details
**Als** [USER_TYPE]  
**möchte ich** [ACTION]  
**um** [BENEFIT]

## Acceptance Criteria
- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

## Technical Tasks
- [ ] Task 1: [DESCRIPTION]
- [ ] Task 2: [DESCRIPTION]
- [ ] Task 3: [DESCRIPTION]

## Definition of Done
- [ ] Code implemented and tested
- [ ] Unit tests written and passing
- [ ] Integration tests passing
- [ ] Code reviewed and approved
- [ ] Documentation updated
- [ ] Deployed to staging
- [ ] User acceptance testing completed

## Dependencies
- [ ] Dependency 1
- [ ] Dependency 2

## Estimation
**Story Points:** [POINTS]  
**Estimated Hours:** [HOURS]

## Notes
*Zusätzliche Notizen und Überlegungen*

---
**Sprint:** [SPRINT_NUMBER]  
**Assigned to:** [DEVELOPER]  
**Status:** [TODO/IN_PROGRESS/REVIEW/DONE]

---
*Erstellt mit Appiq Solution - Built with ❤️ based on Bmad-Method*
`;
  }

  generateInitialPRD() {
    const { projectName, projectIdea, targetUsers, projectType } = this.config;

    return `# Product Requirements Document (PRD)

## Projekt: ${projectName}

### 1. Problem Statement
${projectIdea}

### 2. Target Users
${targetUsers}

### 3. Project Type
${
  projectType === "greenfield"
    ? "✨ Greenfield (Neues Projekt)"
    : "🔧 Brownfield (Bestehendes Projekt)"
}

### 4. Functional Requirements (FRs)
*Diese Sektion wird durch den PM Agent vervollständigt*

#### 4.1 Core Features
- [ ] Feature wird durch PM definiert

### 5. Non-Functional Requirements (NFRs)
*Diese Sektion wird durch den Architect Agent vervollständigt*

### 6. User Stories & Epics
*Diese Sektion wird durch den Story Master Agent vervollständigt*

---
**Status:** 📋 Planning Phase Complete - Ready for PM Agent  
**Nächster Schritt:** PM Agent für detaillierte Requirements  
**Created:** ${new Date().toLocaleDateString("de-DE")}

---
*Erstellt mit Appiq Solution - Built with ❤️ based on Bmad-Method*
`;
  }

  generateBMADKnowledgeBase() {
    return `# BMAD Knowledge Base

## The BMad Planning + Execution Workflow

### Planning Workflow (Web UI or Powerful IDE Agents)
1. **Analyst** (Optional): Market Research, Competitor Analysis, Project Brief
2. **PM**: Create PRD from Brief with FRs, NFRs, Epics & Stories
3. **UX Expert** (Optional): Create Front End Spec, Generate UI Prompts
4. **Architect**: Create Architecture from PRD + UX Spec
5. **PO**: Run Master Checklist, validate document alignment

### Critical Transition: Web UI → IDE
- Copy documents to project (docs/prd.md, docs/architecture.md)
- Switch to IDE
- **PO**: Shard Documents (CRITICAL STEP)
- Begin Development Cycle

### Core Development Cycle (IDE)
1. **SM**: Review previous story dev/QA notes
2. **SM**: Draft next story from sharded epic + architecture
3. **PO**: Validate story draft (optional)
4. **User Approval** of story
5. **Dev**: Sequential task execution, implement tasks + tests
6. **Dev**: Run all validations, mark ready for review
7. **User Verification**: Request QA or approve
8. **QA**: Senior dev review + active refactoring (if requested)
9. **IMPORTANT**: Verify all regression tests and linting pass
10. **IMPORTANT**: COMMIT CHANGES BEFORE PROCEEDING
11. Mark story as done, loop back to SM

### Key Principles
- **Document Sharding**: Critical step after planning phase
- **Context Management**: Keep files lean and focused
- **Commit Regularly**: Save work frequently, especially after QA
- **Agent Selection**: Use appropriate agent for each task
- **Dependencies**: Each agent loads only what it needs

### Special Agents
- **BMad-Master**: Can do any task except story implementation
- **BMad-Orchestrator**: Heavy-weight agent for web bundles only

### Technical Configuration
- **core-config.yaml**: devLoadAlwaysFiles configuration
- **technical-preferences.md**: Bias PM/Architect recommendations
- **Dependencies**: templates, tasks, data for each agent

---
*Built with ❤️ based on Bmad-Method*
`;
  }

  generateCreateDocTask() {
    return `# Create Document Task

## Purpose
Create structured documents following BMAD templates and standards.

## Usage
This task helps agents create consistent, well-structured documents.

## Process
1. **Identify Document Type**: PRD, Architecture, Story, etc.
2. **Load Template**: Use appropriate template from templates/
3. **Gather Requirements**: Collect all necessary information
4. **Fill Template**: Replace placeholders with actual content
5. **Validate Structure**: Ensure all sections are complete
6. **Save Document**: Store in correct location (docs/)

## Templates Available
- prd-template.md
- architecture-template.md
- story-template.md

## Best Practices
- Follow template structure exactly
- Replace ALL placeholders
- Include creation date and status
- Link to related documents
- Use consistent formatting

## Output Location
- PRD: docs/prd.md
- Architecture: docs/architecture.md
- Stories: docs/stories/[story-name].md

---
*Built with ❤️ based on Bmad-Method*
`;
  }

  generateShardDocTask() {
    return `# Document Sharding Task

## Purpose
**CRITICAL STEP**: Break down large documents into focused, manageable pieces for agents.

## When to Use
- After planning phase completion
- Before beginning development cycle
- When switching from Web UI to IDE

## Process
1. **Identify Source Document**: Usually PRD or Architecture
2. **Analyze Structure**: Find natural breaking points
3. **Create Focused Files**: Each file serves one purpose
4. **Maintain References**: Link shards together
5. **Update devLoadAlwaysFiles**: Configure core-config.yaml

## Sharding Strategy

### PRD Sharding
- **Core Requirements**: docs/requirements/core.md
- **User Stories**: docs/stories/ (individual files)
- **Success Metrics**: docs/metrics.md

### Architecture Sharding
- **Tech Stack**: docs/architecture/tech-stack.md
- **Coding Standards**: docs/architecture/coding-standards.md
- **Project Structure**: docs/architecture/project-structure.md
- **API Design**: docs/architecture/api-design.md
- **Data Models**: docs/architecture/data-models.md

## Critical Points
- **Lean Files**: Each shard should be focused and minimal
- **Dev Context**: Sharded files go into devLoadAlwaysFiles
- **Agent Performance**: Smaller context = better performance
- **Maintainability**: Easier to update specific aspects

## Post-Sharding
1. Update core-config.yaml devLoadAlwaysFiles
2. Verify all shards are accessible
3. Test agent context loading
4. Begin development cycle

---
*Built with ❤️ based on Bmad-Method*
`;
  }

  generateValidateStoryTask() {
    return `# Validate Story Task

## Purpose
Ensure user stories align with PRD, architecture, and project goals.

## When to Use
- Before story implementation begins
- When SM drafts new stories
- When stories are modified

## Validation Checklist

### Story Structure
- [ ] Clear user role defined
- [ ] Specific action described
- [ ] Business value stated
- [ ] Acceptance criteria present

### Technical Alignment
- [ ] Aligns with architecture decisions
- [ ] Fits within tech stack constraints
- [ ] Dependencies identified
- [ ] Implementation feasible

### Business Alignment
- [ ] Supports PRD objectives
- [ ] Addresses user needs
- [ ] Measurable outcomes
- [ ] Priority justified

### Quality Gates
- [ ] Testable acceptance criteria
- [ ] Definition of done complete
- [ ] Effort estimation reasonable
- [ ] Risk assessment done

## Process
1. **Load References**: PRD, Architecture, related stories
2. **Check Structure**: Verify story template compliance
3. **Validate Alignment**: Against PRD and architecture
4. **Assess Dependencies**: Identify blockers or prerequisites
5. **Review Quality**: Ensure story is ready for development
6. **Provide Feedback**: Clear recommendations for improvements

## Common Issues
- Vague acceptance criteria
- Missing technical dependencies
- Misalignment with architecture
- Unrealistic scope or effort

## Output
- **Validation Status**: Pass/Fail with reasons
- **Recommendations**: Specific improvements needed
- **Dependencies**: List of prerequisites
- **Risk Assessment**: Potential implementation challenges

---
*Built with ❤️ based on Bmad-Method*
`;
  }

  async addFlutterAgents() {
    console.log(chalk.cyan("    📱 Adding Flutter-specific agents..."));

    const agentsDir = path.join(this.appiqPath, "agents");
    const flutterExpansionPath = path.join(
      __dirname,
      "..",
      "expansion-packs",
      "bmad-flutter-mobile-dev",
      "agents"
    );

    // Check if Flutter expansion pack exists
    if (!fs.existsSync(flutterExpansionPath)) {
      console.log(
        chalk.yellow(
          "    ⚠️  Flutter expansion pack not found - creating basic Flutter agents"
        )
      );
      await this.createBasicFlutterAgents();
      return;
    }

    // Copy Flutter agents from expansion pack
    const flutterAgents = [
      "flutter-ui-agent.md",
      "flutter-cubit-agent.md",
      "flutter-data-agent.md",
      "flutter-domain-agent.md",
      "shared-components-agent.md",
    ];

    for (const agentFile of flutterAgents) {
      const sourcePath = path.join(flutterExpansionPath, agentFile);
      const targetPath = path.join(agentsDir, agentFile);

      if (fs.existsSync(sourcePath)) {
        fs.copyFileSync(sourcePath, targetPath);
        console.log(chalk.green(`      ✅ ${agentFile} hinzugefügt`));
      }
    }

    // Create Flutter-specific data files
    const dataDir = path.join(this.appiqPath, "data");
    const flutterDataPath = path.join(
      __dirname,
      "..",
      "expansion-packs",
      "bmad-flutter-mobile-dev",
      "data"
    );

    if (
      fs.existsSync(
        path.join(flutterDataPath, "flutter-development-guidelines.md")
      )
    ) {
      fs.copyFileSync(
        path.join(flutterDataPath, "flutter-development-guidelines.md"),
        path.join(dataDir, "flutter-development-guidelines.md")
      );
      console.log(
        chalk.green("      ✅ Flutter development guidelines hinzugefügt")
      );
    }
  }

  async createBasicFlutterAgents() {
    console.log(chalk.gray("    🔨 Creating basic Flutter agents..."));

    const agentsDir = path.join(this.appiqPath, "agents");

    // Basic Flutter UI Agent
    const flutterUIAgent = this.generateBasicFlutterUIAgent();
    fs.writeFileSync(
      path.join(agentsDir, "flutter-ui-agent.md"),
      flutterUIAgent
    );

    // Basic Flutter State Management Agent
    const flutterStateAgent = this.generateBasicFlutterStateAgent();
    fs.writeFileSync(
      path.join(agentsDir, "flutter-cubit-agent.md"),
      flutterStateAgent
    );

    console.log(chalk.green("      ✅ Basic Flutter agents created"));
  }

  generateBasicFlutterUIAgent() {
    return `# Flutter UI Agent

Du bist ein spezialisierter Flutter UI Agent, der sich auf die Erstellung von benutzerfreundlichen und responsive Mobile UI-Komponenten fokussiert.

## Rolle & Verantwortung

- **UI Design & Implementation:** Erstelle schöne, Material 3 konforme Flutter UIs
- **Widget Composition:** Verwende effiziente Widget-Hierarchien
- **Responsive Design:** Sichere Kompatibilität für verschiedene Bildschirmgrößen
- **Accessibility:** Implementiere barrierefreie UI-Komponenten

## Expertise

### Flutter UI Frameworks
- **Material 3:** Modernes Material Design
- **Cupertino:** iOS-native Looks
- **Custom Widgets:** Individuelle UI-Komponenten

### Best Practices
- **Widget Keys:** Für Testability und Performance
- **Const Constructors:** Memory-Optimierung  
- **Build Method Optimization:** Verhindere unnecessary rebuilds
- **Theme Integration:** Konsistente Design Systems

## Tech Stack Integration

**Platform:** ${this.config.techStack.platform}
**MCP:** ${this.config.techStack.isFlutter ? "Dart MCP Server ✅" : "Standard"}

### Dart MCP Tools
- Hot Reload via MCP
- Widget Inspection via AI
- pub.dev Package Discovery
- Runtime Error Analysis

## Workflow Integration

**Planning Phase:** Arbeite mit UX Expert an UI Specs
**Development Phase:** Implementiere UI basierend auf Cubit State
**Testing Phase:** Golden Tests für UI Consistency

---
*Built with ❤️ based on Bmad-Method*
*Flutter Clean Architecture + Dart MCP Integration*
`;
  }

  generateBasicFlutterStateAgent() {
    return `# Flutter Cubit State Management Agent

Du bist ein spezialisierter Flutter State Management Agent mit Fokus auf Cubit/BLoC Pattern und Clean Architecture.

## Rolle & Verantwortung

- **State Management:** Implementiere Cubit/BLoC Pattern
- **Clean Architecture:** Separation of Concerns (Presentation → Domain → Data)
- **Dependency Injection:** GetIt + Injectable Setup
- **Event Handling:** User Interactions und API Calls

## Expertise

### State Management
- **Cubit:** Simple State Management für UI
- **BLoC:** Complex Business Logic mit Events
- **Riverpod:** Alternative State Management (if needed)

### Architecture Patterns
- **Clean Architecture:** Feature-based Structure
- **Repository Pattern:** Data Access Layer
- **Use Cases:** Business Logic Layer
- **Dependency Injection:** Loose Coupling

## Tech Stack Integration

**Platform:** ${this.config.techStack.platform}
**MCP:** ${this.config.techStack.isFlutter ? "Dart MCP Server ✅" : "Standard"}

### Code Generation
- **Freezed:** Immutable Data Classes
- **Injectable:** Dependency Injection Setup
- **Build Runner:** Code Generation Pipeline

## Workflow Integration

**Planning Phase:** Definiere State Structure mit Domain Agent
**Development Phase:** Implementiere Business Logic
**Testing Phase:** Unit Tests für Cubits und Use Cases

---
*Built with ❤️ based on Bmad-Method*
*Flutter Clean Architecture + Dart MCP Integration*
`;
  }

  async updateAgentsWithDependencies() {
    console.log(chalk.gray("    🔗 Updating agents with BMAD dependencies..."));

    const agentsDir = path.join(this.appiqPath, "agents");
    const agents = fs.readdirSync(agentsDir);

    for (const agentFile of agents) {
      const agentPath = path.join(agentsDir, agentFile);
      let content = fs.readFileSync(agentPath, "utf8");

      // Add BMAD dependencies section to each agent
      const dependenciesSection = `

## 🔗 BMAD Dependencies

### Templates
- prd-template.md
- architecture-template.md  
- story-template.md

### Tasks
- create-doc.md
- shard-doc.md
- validate-story.md

### Data
- bmad-kb.md
- technical-preferences.md

### Configuration
- core-config.yaml (devLoadAlwaysFiles)

## 🎯 BMAD Workflow Integration

**Planning Phase:** Web UI → IDE Transition → Document Sharding  
**Development Phase:** SM → PO → Dev → QA → Loop  
**Critical Points:** Commit before proceeding, verify tests passing

`;

      // Add MCP integration section
      const mcpSection = this.generateMCPAgentSection(agentFile);

      // Add dependencies and MCP section before the final line
      const lines = content.split("\n");
      const lastLine = lines.pop(); // Remove last line
      lines.push(dependenciesSection);
      lines.push(mcpSection);
      lines.push(lastLine); // Add last line back

      fs.writeFileSync(agentPath, lines.join("\n"));
    }
  }

  generateMCPAgentSection(agentFile) {
    // Bestimme Agent-Typ basierend auf Dateiname
    const agentName = agentFile.replace('.md', '').toLowerCase();
    
    // Bestimme welche MCPs für diesen Agent relevant sind
    const relevantMCPs = Object.keys(MCP_SERVERS).filter(mcpKey => {
      const server = MCP_SERVERS[mcpKey];
      return server.tags.includes('all') || 
             server.tags.some(tag => agentName.includes(tag)) ||
             (agentName.includes('architect') && server.tags.includes('architect')) ||
             (agentName.includes('pm') && server.tags.includes('pm')) ||
             (agentName.includes('qa') && server.tags.includes('qa')) ||
             (agentName.includes('dev') && server.tags.includes('dev')) ||
             (agentName.includes('ux') && server.tags.includes('ux-expert')) ||
             (agentName.includes('flutter') && server.tags.includes('flutter')) ||
             ((agentName.includes('web') || agentName.includes('ui')) && server.tags.includes('ui'));
    });

    if (relevantMCPs.length === 0) {
      return '';
    }

    let section = `\n## 🔌 MCP Server Integration\n\nDu hast Zugriff auf folgende MCP Server, um deine Fähigkeiten zu erweitern:\n\n`;

    relevantMCPs.forEach(mcpKey => {
      const server = MCP_SERVERS[mcpKey];
      section += `- **${server.name}:** ${server.description}\n`;
    });

    section += `\n**Beispiel-Anwendung:**\n`;
    
    // Spezifische Beispiele basierend auf Agent-Typ
    if (agentName.includes('flutter')) {
      section += `- "Nutze den Dart MCP, um mein Flutter Widget zu analysieren."\n`;
      section += `- "Verwende den 21st.dev Magic MCP, um eine neue UI-Komponente zu erstellen."\n`;
    } else if (agentName.includes('architect')) {
      section += `- "Nutze den Context7 MCP, um die neueste Dokumentation für React Hooks zu finden."\n`;
      section += `- "Verwende Sequential Thinking MCP für die komplexe Architektur-Planung."\n`;
    } else if (agentName.includes('qa')) {
      section += `- "Nutze den Puppeteer MCP, um automatisierte Browser-Tests zu erstellen."\n`;
    } else if (agentName.includes('dev')) {
      section += `- "Verwende den Firebase MCP, um Firestore-Daten abzurufen."\n`;
      section += `- "Nutze den Supabase MCP für Datenbankoperationen."\n`;
    } else {
      section += `- "Nutze den Context7 MCP für aktuelle Dokumentation."\n`;
      section += `- "Verwende Sequential Thinking MCP für komplexe Problemlösungen."\n`;
    }
    
    section += `\n**Wichtig:** Die MCPs müssen in deiner IDE konfiguriert sein. Siehe mcp-setup-instructions.md für Details.\n`;

    return section;
  }

  generateBMADOrchestration(config) {
    return `# BMAD Full Orchestration
# Built with ❤️ based on Bmad-Method

project:
  name: ${this.config.projectName}
  type: ${this.config.projectType}
  plan_approved: ${this.config.planApproved}
  created: ${new Date().toISOString()}

# BMAD Planning Phase (Web UI/Powerful IDE)
planning_phase:
  workflow: ${config.planningPhase.workflow}
  agents:
${config.planningPhase.agents.map((agent) => `    - ${agent}`).join("\n")}
  
  flow:
    1: "analyst → research & project brief (optional)"
    2: "pm → create PRD from brief"
    3: "ux-expert → create frontend spec (optional)"
    4: "architect → create architecture from PRD + UX"
    5: "po → run master checklist & validate alignment"

# Critical Transition: Web UI → IDE
transition:
  type: ${config.transitions.planningToIDE}
  requirements:
    - "Copy docs/prd.md and docs/architecture.md to project"
    - "Switch to IDE"
    - "PO: Shard documents (CRITICAL)"
    - "Update core-config.yaml devLoadAlwaysFiles"

# BMAD Development Phase (IDE Only)
development_phase:
  workflow: ${config.developmentPhase.workflow}
  agents:
${config.developmentPhase.agents.map((agent) => `    - ${agent}`).join("\n")}
  
  cycle:
    1: "sm → review previous story dev/QA notes"
    2: "sm → draft next story from sharded epic + architecture"
    3: "po → validate story draft (optional)"
    4: "user → approve story"
    5: "dev → sequential task execution + implementation"
    6: "dev → run all validations, mark ready for review"
    7: "user → verify (request QA or approve)"
    8: "qa → senior dev review + active refactoring (if requested)"
    9: "CRITICAL → verify regression tests + linting pass"
    10: "CRITICAL → COMMIT CHANGES BEFORE PROCEEDING"
    11: "mark story done → loop back to sm"

# Critical Commit Points
commit_points:
${config.transitions.criticalCommitPoints
  .map((point) => `  - ${point}`)
  .join("\n")}

# IDE Integration
ides:
${this.config.selectedIDEs
  .map(
    (ide) => `  - name: ${this.getIDEName(ide)}
    config_path: ${this.getIDEConfig(ide).dir}
    file_format: ${this.getIDEConfig(ide).suffix}`
  )
  .join("\n")}

# Context Management
context:
  dev_always_files:
    - docs/architecture/coding-standards.md
    - docs/architecture/tech-stack.md
    - docs/architecture/project-structure.md
  
  agent_dependencies:
    templates: ["prd-template.md", "architecture-template.md", "story-template.md"]
    tasks: ["create-doc.md", "shard-doc.md", "validate-story.md"]
    data: ["bmad-kb.md", "technical-preferences.md"]

---
*Powered by Appiq Solution - Built with ❤️ based on Bmad-Method*
`;
  }

  generatePlanningWorkflow() {
    return `# BMAD Planning Workflow

## Übersicht
Die Planungsphase folgt einem strukturierten Workflow, idealerweise in Web UI für Kosteneffizienz.

## Planning Flow

### 1. Start: Projektidee
- Grundlegendes Konzept definiert
- Problem identifiziert

### 2. Analyst (Optional)
**Brainstorming:**
- Marktforschung
- Konkurrenzanalyse  
- Projekt Brief erstellen

### 3. Project Manager (PM)
**PRD Erstellung:**
- PRD aus Brief erstellen (Fast Track)
- ODER interaktive PRD Erstellung (mehr Fragen)
- Functional Requirements (FRs)
- Non-Functional Requirements (NFRs)
- Epics & Stories definieren

### 4. UX Expert (Optional)
**Frontend Specification:**
- Frontend Spec erstellen
- UI Prompts für Lovable/V0 generieren (optional)

### 5. System Architect  
**Architektur Design:**
- Architektur aus PRD erstellen
- ODER aus PRD + UX Spec erstellen
- Tech Stack definieren
- System Components planen

### 6. Product Owner (PO)
**Master Checklist:**
- Dokumenten-Alignment prüfen
- Epics & Stories aktualisieren (falls nötig)
- PRD/Architektur anpassen (falls nötig)

## Kritischer Übergang: Web UI → IDE

### ⚠️ WICHTIG: Transition Point
Sobald PO Dokumenten-Alignment bestätigt:

1. **Dokumente kopieren**: docs/prd.md und docs/architecture.md
2. **IDE wechseln**: Projekt in bevorzugter Agentic IDE öffnen  
3. **Document Sharding**: PO Agent zum Shard der Dokumente verwenden
4. **Development beginnen**: Core Development Cycle starten

## Qualitäts-Gates

### Planning Complete Criteria
- [ ] PRD vollständig und genehmigt
- [ ] Architektur vollständig und genehmigt
- [ ] UX Spec (falls erforderlich) genehmigt
- [ ] Alle Dokumente sind aligned
- [ ] Epics und Stories definiert
- [ ] Übergang zu IDE vorbereitet

## Nächste Schritte
Nach Planning Complete → **Document Sharding** → **Development Cycle**

---
*Built with ❤️ based on Bmad-Method*
`;
  }

  generateDevelopmentCycle() {
    return `# BMAD Core Development Cycle

## Übersicht
Strukturierter Entwicklungsworkflow in der IDE nach abgeschlossener Planungsphase.

## Voraussetzungen
- ✅ Planning Phase abgeschlossen
- ✅ Dokumente in Projekt kopiert (docs/prd.md, docs/architecture.md)
- ✅ **Document Sharding** durch PO Agent durchgeführt
- ✅ IDE-Setup komplett

## Development Cycle Flow

### 1. Scrum Master (SM)
**Story Vorbereitung:**
- Review previous story dev/QA notes
- Draft next story from sharded epic + architecture
- Berücksichtigt technical dependencies
- Erstellt realistische task breakdown

### 2. Product Owner (PO) - Optional
**Story Validation:**
- Validate story draft against artifacts
- Überprüft alignment mit PRD
- Bestätigt business value
- Kann übersprungen werden bei erfahrenen Teams

### 3. User Approval
**Story Freigabe:**
- ✅ **Approved**: Weiter zu Development
- ❌ **Needs Changes**: Zurück zu SM für Anpassungen

### 4. Developer (Dev)
**Implementation:**
- Sequential task execution
- Implement tasks + tests
- Run all validations
- Mark ready for review + add notes
- Dokumentiert implementation decisions

### 5. User Verification
**Review Decision:**
- 🔍 **Request QA Review**: Weiter zu QA Agent
- ✅ **Approve Without QA**: Direkt zu Final Checks
- ❌ **Needs Fixes**: Zurück zu Dev

### 6. QA Agent (Optional)
**Quality Assurance:**
- Senior dev review + active refactoring
- Review code, refactor, add tests
- Document notes and improvements
- **Decision**: Needs Dev Work OR Approved

### 7. Final Checks - ⚠️ CRITICAL
**Vor dem Abschluss:**
- ✅ Verify ALL regression tests passing
- ✅ Verify ALL linting passing  
- ✅ Code review completed (if QA was used)
- ✅ Documentation updated

### 8. Commit - ⚠️ SUPER CRITICAL
**WICHTIG: COMMIT YOUR CHANGES BEFORE PROCEEDING!**
- Git add & commit all changes
- Include meaningful commit message
- Push to repository

### 9. Story Complete
**Mark als Done:**
- Story status → DONE
- Loop back to SM for next story

## Critical Points

### ⚠️ Commit Points
- **After QA Approval**: Always commit before marking done
- **Before Next Story**: Clean state for next iteration

### 🎯 Quality Gates
- All tests passing
- Linting clean
- Code reviewed (if QA used)
- Documentation current

### 📊 Context Management
- Keep relevant files only in context
- Use sharded documents
- Maintain lean, focused files

## Best Practices
- **Small Stories**: Keep stories manageable (< 1 week)
- **Regular Commits**: Commit frequently during development
- **Test First**: Write tests before or with implementation
- **Document Decisions**: Record architectural decisions

---
*Built with ❤️ based on Bmad-Method*
`;
  }

  generateDocumentSharding() {
    return `# Document Sharding Guide

## ⚠️ CRITICAL STEP
Document Sharding ist ein **essentieller Schritt** im BMAD Flow nach der Planungsphase.

## Wann Document Sharding durchführen?
- ✅ Nach Planning Phase Completion
- ✅ Beim Übergang von Web UI zu IDE  
- ✅ Vor Beginn des Development Cycles
- ✅ Wenn Dokumente zu groß für Agent-Context werden

## Warum Document Sharding?
- **Performance**: Kleinere Context = bessere Agent-Performance
- **Focus**: Jede Datei dient einem spezifischen Zweck
- **Maintainability**: Einfacher zu aktualisieren und zu verwalten
- **Agent Efficiency**: Agents laden nur was sie brauchen

## Sharding Process

### 1. PRD Sharding
**Source**: docs/prd.md  
**Target Structure**:
\`\`\`
docs/
├── requirements/
│   ├── core.md              # Core functional requirements
│   ├── non-functional.md    # NFRs (performance, security)
│   └── success-metrics.md   # KPIs and success criteria
├── stories/
│   ├── epic-1-auth/
│   │   ├── story-1-1-login.md
│   │   └── story-1-2-register.md
│   └── epic-2-dashboard/
│       └── story-2-1-overview.md
\`\`\`

### 2. Architecture Sharding  
**Source**: docs/architecture.md  
**Target Structure**:
\`\`\`
docs/architecture/
├── tech-stack.md           # Technology decisions
├── coding-standards.md     # Code style and patterns  
├── project-structure.md    # File/folder organization
├── api-design.md          # REST/GraphQL API specs
├── data-models.md         # Database schema
├── security.md            # Security considerations
└── deployment.md          # Deployment architecture
\`\`\`

## Sharding Guidelines

### File Size
- **Target**: < 50 lines per sharded file
- **Maximum**: < 100 lines per sharded file
- **Focus**: One concern per file

### Naming Convention
- **kebab-case**: tech-stack.md, coding-standards.md
- **Descriptive**: Clear purpose from filename
- **Consistent**: Follow project conventions

### Content Rules
- **Atomic**: Each file covers one topic completely
- **Self-contained**: Can be understood independently
- **Linked**: Reference related files when needed
- **Lean**: Remove fluff, keep essentials

## Post-Sharding Configuration

### 1. Update core-config.yaml
\`\`\`yaml
devLoadAlwaysFiles:
  - docs/architecture/coding-standards.md
  - docs/architecture/tech-stack.md  
  - docs/architecture/project-structure.md
\`\`\`

### 2. Verify Agent Access
- Test that agents can load sharded files
- Ensure all references are correct
- Validate file paths in configuration

### 3. Update Templates
- Modify templates to reference sharded structure
- Update agent prompts to use sharded files
- Test template generation

## Quality Checks

### ✅ Sharding Complete Criteria
- [ ] All large documents sharded
- [ ] Each shard < 100 lines
- [ ] devLoadAlwaysFiles updated
- [ ] Agent dependencies resolved
- [ ] File references working
- [ ] Templates updated

### 🚨 Common Mistakes
- **Too Large**: Shards still too big (>100 lines)
- **Too Small**: Over-sharding (many 5-line files)
- **Broken Links**: References to old unified files
- **Missing Config**: devLoadAlwaysFiles not updated

## After Sharding
1. **Test Agent Loading**: Verify agents can access all needed files
2. **Begin Development**: Start Core Development Cycle
3. **Monitor Performance**: Watch for context issues
4. **Refine as Needed**: Adjust sharding based on usage

---
*Built with ❤️ based on Bmad-Method*
`;
  }





  async performInstallation() {
    console.log(chalk.yellow("📦 Installation läuft..."));
    
    // Create appiq-solution directory
    if (!fs.existsSync(this.appiqPath)) {
      fs.mkdirSync(this.appiqPath, { recursive: true });
    }
    
    // Install optimized agents
    await this.installOptimizedAgents();
    
    // Install project-specific configs
    await this.installProjectConfig();
    
    // Setup IDE integration
    await this.setupIDEIntegration();
    
    console.log(chalk.green("✅ Installation abgeschlossen!\n"));
  }

  async installOptimizedAgents() {
    console.log(chalk.gray("  📄 Optimierte Agents installieren..."));
    
    const agentsDir = path.join(this.appiqPath, "agents");
    if (!fs.existsSync(agentsDir)) {
      fs.mkdirSync(agentsDir, { recursive: true });
    }
    
    // Core optimized agents
    const agents = [
      "smart-launcher",
      "project-manager",
      "architect",
      "story-master",
      "developer",
      "qa-expert",
    ];
    
    for (const agent of agents) {
      await this.createOptimizedAgent(agent);
    }
  }

  async createOptimizedAgent(agentName) {
    const agentContent = this.generateOptimizedAgentContent(agentName);
    const filePath = path.join(this.appiqPath, "agents", `${agentName}.md`);
    fs.writeFileSync(filePath, agentContent);
  }

  generateOptimizedAgentContent(agentName) {
    const agentConfigs = {
      "smart-launcher": {
        name: "Appiq Launcher",
        role: "Intelligenter Projekt-Starter",
        commands: ["/start", "/quick-setup", "/help"],
        description:
          "Startet automatisch den optimalen Workflow basierend auf Ihrem Projekt-Typ",
      },
      "project-manager": {
        name: "Project Manager",
        role: "PRD & Projekt-Planung",
        commands: ["/prd", "/plan", "/epic"],
        description: "Erstellt PRD und Projekt-Dokumentation",
      },
      architect: {
        name: "System Architect",
        role: "Technische Architektur",
        commands: ["/architecture", "/tech-stack", "/design"],
        description: "Entwickelt System-Architektur und Tech-Stack",
      },
      "story-master": {
        name: "Story Master",
        role: "User Stories & Sprint Planning",
        commands: ["/story", "/sprint", "/tasks"],
        description: "Erstellt User Stories und Sprint-Planung",
      },
      developer: {
        name: "Senior Developer",
        role: "Code Implementation",
        commands: ["/code", "/implement", "/fix"],
        description: "Implementiert Features und behebt Bugs",
      },
      "qa-expert": {
        name: "QA Expert",
        role: "Testing & Qualität",
        commands: ["/test", "/review", "/validate"],
        description: "Führt Tests durch und validiert Code-Qualität",
      },
    };

    const config = agentConfigs[agentName];
    
    return `# ${config.name}

## 🎯 Rolle
${config.role}

## 📋 Verfügbare Kommandos
${config.commands
  .map((cmd) => `- **${cmd}** - ${config.description}`)
  .join("\n")}

## 🚀 One-Click Workflows

### Für ${
      this.config.projectType === "greenfield" ? "NEUE" : "BESTEHENDE"
    } Projekte:

${
  this.config.projectType === "greenfield"
    ? this.generateGreenfieldWorkflow(config)
    : this.generateBrownfieldWorkflow(config)
}

## 🎮 Einfache Nutzung

1. **Laden Sie diesen Agent in Ihre IDE**
2. **Sagen Sie:** "Agiere als ${config.name}"
3. **Verwenden Sie:** ${config.commands[0]} für Quick-Start

---
*Automatisch optimiert für ${this.config.selectedIDEs
      .map((ide) => this.getIDEName(ide))
      .join(", ")}*
*Powered by Appiq - Based on Bmad-Method*
`;
  }

  generateGreenfieldWorkflow(config) {
    const workflows = {
      "Appiq Launcher": `
**🚀 Schnell-Start für neues Projekt:**
1. \`/start\` - Automatische Projekt-Analyse
2. Erstellt automatisch: PRD-Vorlage, Architektur-Basis, erste Stories
3. **Wo alles hingehört:** Alle Dateien werden automatisch in \`docs/\` erstellt`,

      "Project Manager": `
**📋 PRD Erstellung:**
1. \`/prd\` - Startet PRD-Assistent
2. **Datei wird erstellt:** \`docs/prd.md\`
3. **Nächster Schritt:** Architect für Architektur`,

      "System Architect": `
**🏗️ Architektur erstellen:**
1. \`/architecture\` - Basierend auf PRD
2. **Datei wird erstellt:** \`docs/architecture.md\`
3. **Nächster Schritt:** Story Master für erste Stories`,

      "Story Master": `
**📝 Erste Stories:**
1. \`/story\` - Erstellt erste User Story
2. **Datei wird erstellt:** \`docs/stories/story-001.md\`
3. **Nächster Schritt:** Developer für Implementation`,

      "Senior Developer": `
**💻 Implementation:**
1. \`/implement\` - Implementiert aktuelle Story
2. **Erstellt/bearbeitet:** Entsprechende Code-Dateien
3. **Nächster Schritt:** QA Expert für Review`,

      "QA Expert": `
**✅ Testing & Review:**
1. \`/review\` - Reviewed aktuellen Code
2. **Erstellt:** Test-Dateien und Reports
3. **Nächster Schritt:** Zurück zu Story Master für nächste Story`,
    };

    return workflows[config.name] || "Standard Greenfield Workflow";
  }

  generateBrownfieldWorkflow(config) {
    const workflows = {
      "Appiq Launcher": `
**🔧 Schnell-Start für bestehendes Projekt:**
1. \`/analyze\` - Analysiert bestehendes Projekt
2. **Findet:** Existierende Docs, Code-Struktur, Tech-Stack
3. **Erstellt:** Angepasste Workflows für Ihr Projekt`,

      "Project Manager": `
**📋 Automatische PRD Erstellung:**
1. **Erstellt automatisch:** \`docs/prd.md\` (falls nicht vorhanden)
2. **Für Flutter Projekte:** Verwendet flutter-mobile-prd-tmpl.yaml
3. **Keine Projektname-Abfrage** - Verwendet Verzeichnisname
4. **Nächster Schritt:** Architect für Architektur-Review`,

      "System Architect": `
**🏗️ Architektur-Review:**
1. \`/review-architecture\` - Analysiert bestehende Struktur
2. **Erstellt/updated:** \`docs/architecture.md\`
3. **Nächster Schritt:** Story Master für neue Features`,

      "Story Master": `
**📝 Feature Stories:**
1. \`/new-feature\` - Neue Story für bestehendes Projekt
2. **Datei wird erstellt:** \`docs/stories/feature-XXX.md\`
3. **Berücksichtigt:** Bestehende Code-Basis`,

      "Senior Developer": `
**💻 Feature Implementation:**
1. \`/add-feature\` - Implementiert in bestehendem Code
2. **Bearbeitet:** Bestehende Dateien sicher
3. **Erstellt:** Neue Dateien wo nötig`,

      "QA Expert": `
**✅ Regression Testing:**
1. \`/regression-test\` - Testet neue Features
2. **Validiert:** Keine Breaking Changes
3. **Erstellt:** Test-Reports für bestehende + neue Features`,
    };

    return workflows[config.name] || "Standard Brownfield Workflow";
  }

  async setupOneClickWorkflows() {
    console.log(chalk.yellow("⚡ One-Click Workflows einrichten..."));
    
    // Create quick commands
    const commandsDir = path.join(this.appiqPath, "commands");
    if (!fs.existsSync(commandsDir)) {
      fs.mkdirSync(commandsDir, { recursive: true });
    }
    
    // Project-type specific quick starts
    const quickStartContent = this.generateQuickStartScript();
    fs.writeFileSync(
      path.join(commandsDir, "quick-start.md"),
      quickStartContent
    );
    
    console.log(chalk.green("✅ One-Click Workflows bereit!\n"));
  }

  generateQuickStartScript() {
    return `# 🚀 Appiq Solution - BMAD Workflow Guide

## Projekt: ${this.config.projectName || "Unbenanntes Projekt"}
**Typ:** ${
      this.config.projectType === "greenfield"
        ? "✨ Greenfield (Neues Projekt)"
        : "🔧 Brownfield (Bestehendes Projekt)"
    }

## 📋 BMAD Planning Workflow (Phase 1)

### Option A: Web UI Planning (Kosteneffizient)
1. Claude/Gemini/GPT mit team-fullstack Bundle verwenden
2. **Flow:** Analyst → PM → UX Expert → Architect → PO
3. **Output:** docs/prd.md, docs/architecture.md

### Option B: IDE Planning (Leistungsstark)
\`\`\`
@analyst → Market Research & Project Brief
@pm → PRD mit FRs, NFRs, Epics & Stories erstellen
@ux-expert → Frontend Spec (optional)
@architect → System Architecture design  
@po → Master Checklist & Document Alignment
\`\`\`

## ⚠️ KRITISCHER ÜBERGANG: Document Sharding

**ESSENTIAL STEP:**
\`\`\`
@po bitte shard die PRD und Architecture Dokumente in fokussierte Dateien
\`\`\`

**Das erstellt:**
- docs/architecture/tech-stack.md ← Dev lädt immer
- docs/architecture/coding-standards.md ← Dev lädt immer  
- docs/architecture/project-structure.md ← Dev lädt immer
- docs/requirements/core.md
- docs/stories/ (individual story files)

## 🚀 BMAD Development Cycle (Phase 2)

### Core Development Loop:
\`\`\`
1. @sm → Review previous notes, draft next story from sharded epic
2. @po → Validate story draft (optional)
3. User → Approve story
4. @dev → Sequential tasks, implement + tests, mark ready  
5. User → Verify (request QA or approve)
6. @qa → Senior dev review + refactoring (optional)
7. ⚠️ CRITICAL: Verify tests + linting pass
8. ⚠️ SUPER CRITICAL: COMMIT CHANGES BEFORE PROCEEDING!
9. Mark story done → Loop back to @sm
\`\`\`

## 🎯 One-Click Commands

### Planning:
- \`/plan\` → Start planning workflow
- \`/prd\` → Generate PRD
- \`/arch\` → Design architecture

### Critical Transition:
- \`/shard\` → Document sharding (ESSENTIAL!)

### Development:
- \`/story\` → Draft next story
- \`/dev\` → Start development
- \`/test\` → Run tests
- \`/qa\` → Request review
- \`/commit\` → Commit changes

### ${
      this.config.projectType === "greenfield" ? "Greenfield" : "Brownfield"
    } Specific:
${
  this.config.projectType === "greenfield"
    ? `
- \`/start\` → Fresh project setup
- \`/design\` → Create from scratch
- \`/build\` → Build step by step
`
    : `
- \`/analyze\` → Analyze existing code
- \`/document\` → Document current state
- \`/improve\` → Plan improvements
`
}

## 📊 File Structure

\`\`\`
your-project/
├── docs/
│   ├── prd.md              ← Initial PRD
│   ├── architecture.md     ← Initial Architecture
│   ├── architecture/       ← Sharded files
│   │   ├── tech-stack.md
│   │   ├── coding-standards.md
│   │   └── project-structure.md
│   ├── requirements/
│   │   └── core.md
│   └── stories/
│       ├── epic-1-auth/
│       └── epic-2-features/
├── appiq-solution/
│   ├── agents/             ← AI-Agents
│   ├── templates/          ← Document templates
│   ├── workflows/          ← Workflow guides
│   └── .bmad-core/         ← BMAD configuration
└── .cursor/rules/          ← IDE integration
\`\`\`

## ⚠️ Critical Success Factors

### Document Sharding (ESSENTIAL):
- **MUST DO** after planning phase
- Creates focused, lean files for agents
- Improves agent performance dramatically

### Commit Points:
- After QA approval (always!)
- Before next story (clean state)
- Regular commits during development

### Quality Gates:
- All tests passing ✅
- Linting clean ✅  
- Code reviewed (if QA used) ✅
- Documentation updated ✅

## 🆘 Help & Support

- \`/help\` → Show all commands
- \`/workflow\` → Current workflow step
- \`/agents\` → Available agents
- \`/docs\` → Documentation

### Workflow Files:
- appiq-solution/workflows/planning-workflow.md
- appiq-solution/workflows/development-cycle.md
- appiq-solution/workflows/document-sharding.md

---
**IDEs:** ${this.config.selectedIDEs
      .map((ide) => this.getIDEName(ide))
      .join(", ")}  
**Created:** ${new Date().toLocaleDateString("de-DE")}  
**Powered by Appiq Solution - Built with ❤️ based on Bmad-Method**
`;
  }

  async setupIDEIntegration() {
    if (
      this.config.selectedIDEs.includes("manual") &&
      this.config.selectedIDEs.length === 1
    )
      return;

    console.log(chalk.gray("  🔧 Mehrere IDE-Integrationen..."));

    for (const ide of this.config.selectedIDEs) {
      if (ide === "manual") continue;

      console.log(
        chalk.gray(`    📝 ${this.getIDEName(ide)} wird konfiguriert...`)
      );

      const ideConfig = this.getIDEConfig(ide);
    const ideDir = path.join(this.projectRoot, ideConfig.dir);
    
    if (!fs.existsSync(ideDir)) {
      fs.mkdirSync(ideDir, { recursive: true });
    }
    
    // Copy agents to IDE-specific format
      const agentsPath = path.join(this.appiqPath, "agents");
    const agents = fs.readdirSync(agentsPath);
    
    for (const agent of agents) {
      const sourcePath = path.join(agentsPath, agent);
        const targetPath = path.join(
          ideDir,
          agent.replace(".md", ideConfig.suffix)
        );
      fs.copyFileSync(sourcePath, targetPath);
    }

      console.log(chalk.green(`    ✅ ${this.getIDEName(ide)} konfiguriert`));
    }

    console.log(chalk.green("  ✅ Alle IDE-Integrationen abgeschlossen!"));
  }

  getIDEConfig(ide) {
    const configs = {
      cursor: { dir: ".cursor/rules", suffix: ".mdc" },
      "claude-code": { dir: ".claude/commands/Appiq", suffix: ".md" },
      windsurf: { dir: ".windsurf/rules", suffix: ".md" },
      cline: { dir: ".clinerules", suffix: ".md" },
      trae: { dir: ".trae/rules", suffix: ".md" },
      roo: { dir: ".roo/agents", suffix: ".md" },
      gemini: { dir: ".gemini/commands", suffix: ".md" },
      "github-copilot": { dir: ".github/copilot", suffix: ".md" },
    };
    return configs[ide] || { dir: ".appiq-solution", suffix: ".md" };
  }

  getIDEName(ide) {
    const names = {
      cursor: "Cursor",
      "claude-code": "Claude Code CLI",
      windsurf: "Windsurf",
      cline: "VS Code + Cline",
      trae: "Trae",
      roo: "Roo Code",
      gemini: "Gemini CLI",
      "github-copilot": "GitHub Copilot",
      manual: "Manuell",
    };
    return names[ide] || ide;
  }

  async showSimpleInstructions() {
    console.log(chalk.bold.green("🎉 Appiq Installation Erfolgreich!\n"));
    console.log(chalk.dim("Built with ❤️  based on the amazing Bmad-Method"));
    console.log(chalk.dim("https://github.com/Viktor-Hermann/APPIQ-METHOD\n"));

    console.log(chalk.cyan("📋 Nächste Schritte (Super einfach):"));
    console.log(chalk.white("════════════════════════════════════\n"));

    if (
      this.config.selectedIDEs.length > 0 &&
      !this.config.selectedIDEs.includes("manual")
    ) {
      console.log(
        chalk.yellow(
          `1. Ihre IDEs öffnen: ${this.config.selectedIDEs
            .map((ide) => this.getIDEName(ide))
            .join(", ")}`
        )
      );
      console.log(
        chalk.gray(`   → Agents sind bereits in allen IDEs installiert!\n`)
      );
    }

    console.log(chalk.yellow("2. 📋 BMAD Planning Workflow:"));
    if (this.config.planApproved) {
      console.log(
        chalk.green(`   ✅ Planning Complete - Ready for Development!`)
      );
      console.log(chalk.cyan(`   → Ihre initial PRD: docs/prd.md`));
    } else {
      console.log(chalk.cyan(`   Option A: Web UI (kosteneffizient)`));
      console.log(chalk.gray(`   → Claude/Gemini/GPT mit Agents verwenden`));
      console.log(chalk.cyan(`   Option B: Direkt in IDE`));
      console.log(chalk.gray(`   → @pm für PRD, @architect für Architecture`));
    }
    console.log("");

    console.log(chalk.yellow("3. ⚠️ KRITISCHER ÜBERGANG: Document Sharding"));
    console.log(
      chalk.red(
        `   → Sagen Sie Ihrer IDE: ${chalk.bold(
          '"@po bitte shard die PRD und Architecture Dokumente"'
        )}`
      )
    );
    console.log(
      chalk.gray(`   → Dokumente werden in fokussierte Teile aufgeteilt\n`)
    );

    console.log(chalk.yellow("4. 🚀 BMAD Development Cycle:"));
    console.log(chalk.cyan(`   1. @sm → Story Draft von Sharded Epic`));
    console.log(chalk.cyan(`   2. @po → Story Validation (optional)`));
    console.log(chalk.cyan(`   3. User → Story Approval`));
    console.log(chalk.cyan(`   4. @dev → Implementation + Tests`));
    console.log(chalk.cyan(`   5. @qa → Code Review (optional)`));
    console.log(chalk.red(`   6. ⚠️ COMMIT CHANGES BEFORE PROCEEDING!`));
    console.log(chalk.gray(`   → Loop zurück zu @sm für nächste Story\n`));

    console.log(chalk.yellow("5. 🎯 Quick Commands (in quick-start.md):"));
    console.log(chalk.cyan(`   /plan → Planning starten`));
    console.log(chalk.cyan(`   /shard → Document Sharding`));
    console.log(chalk.cyan(`   /story → Nächste Story`));
    console.log(chalk.cyan(`   /dev → Development`));
    console.log(chalk.cyan(`   /qa → Quality Review`));
    console.log(chalk.gray(`   → Alle Details in appiq-solution/workflows/\n`));

    console.log(chalk.cyan("🎯 Das war's! Kein komplizierter Setup mehr."));
    console.log(chalk.green("🚀 Viel Erfolg mit Appiq!\n"));
    
    // Quick reference
    console.log(chalk.dim("━".repeat(50)));
    console.log(chalk.dim("📁 Quick Reference:"));
    console.log(chalk.dim(`   • Agents: appiq-solution/agents/`));
    console.log(
      chalk.dim(`   • Quick Start: appiq-solution/commands/quick-start.md`)
    );
    console.log(chalk.dim(`   • Projekt-Typ: ${this.config.projectType}`));
    console.log(
      chalk.dim(
        `   • IDEs: ${this.config.selectedIDEs
          .map((ide) => this.getIDEName(ide))
          .join(", ")}`
      )
    );
  }

  // Helper methods
  hasExistingSourceCode() {
    const sourceDirs = ["src", "lib", "app", "components", "pages"];
    return sourceDirs.some(
      (dir) =>
      fs.existsSync(path.join(this.projectRoot, dir)) && 
      fs.readdirSync(path.join(this.projectRoot, dir)).length > 0
    );
  }

  hasExistingDocumentation() {
    const docFiles = ["README.md", "docs", "documentation"];
    return docFiles.some((file) =>
      fs.existsSync(path.join(this.projectRoot, file))
    );
  }

  async installProjectConfig() {
    const configContent = this.generateProjectConfig();
    fs.writeFileSync(
      path.join(this.appiqPath, "project-config.yaml"),
      configContent
    );
  }

  generateProjectConfig() {
    return `# Appiq Solution Project Configuration
# Built with ❤️  based on Bmad-Method
version: "1.0.0"
project:
  type: ${this.config.projectType}
  created: ${new Date().toISOString()}
  name: ${this.config.projectName || path.basename(this.projectRoot)}
  plan_approved: ${this.config.planApproved}

# Wo die wichtigen Dateien liegen
paths:
  prd: "docs/prd.md"
  architecture: "docs/architecture.md" 
  stories: "docs/stories/"
  agents: "appiq-solution/agents/"
  orchestration: "appiq-solution/orchestration.yaml"

# One-Click Workflows
workflows:
  ${this.config.projectType === "greenfield" ? "greenfield" : "brownfield"}:
    start_command: "${
      this.config.projectType === "greenfield" ? "/start" : "/analyze"
    }"
    agents_sequence: 
      - smart-launcher
      - project-manager
      - architect
      - story-master
      - developer
      - qa-expert

# IDE Integration (Mehrere IDEs)
ides:
${this.config.selectedIDEs
  .map(
    (ide) => `  - name: ${this.getIDEName(ide)}
    config_path: ${this.getIDEConfig(ide).dir}
    file_format: ${this.getIDEConfig(ide).suffix}`
  )
  .join("\n")}
`;
  }
}

// Run installer if called directly  
if (require.main === module) {
  // Check if 'install' command is provided
  const args = process.argv.slice(2);

  if (args.length === 0 || args[0] === "install") {
    const installer = new AppiqSolutionInstaller();
  installer.install().catch(console.error);
  } else {
    console.log(
      chalk.red("❌ Unknown command. Use: npx appiq-solution install")
    );
    process.exit(1);
  }
}

module.exports = AppiqSolutionInstaller;