#!/usr/bin/env node

/**
 * Appiq Smart Installer
 * 
 * Super einfache Installation mit One-Click Workflows
 * Usage: npx appiq.install
 * 
 * Built with ❤️ based on the amazing Bmad-Method
 * Credits: https://github.com/Viktor-Hermann/APPIQ-METHOD
 */

const fs = require('fs');
const path = require('path');
const inquirer = require('inquirer');
const chalk = require('chalk');

class AppiqInstaller {
  constructor() {
    this.projectRoot = process.cwd();
    this.appiqPath = path.join(this.projectRoot, 'appiq');
    this.config = {
      version: '1.0.0',
      projectType: null, // 'greenfield' or 'brownfield'
      techStack: {},
      selectedIDE: null
    };
  }

  async install() {
    console.log(chalk.bold.cyan('🚀 Appiq Smart Installer v1.0.0'));
    console.log(chalk.cyan('======================================='));
    console.log(chalk.dim('Built with ❤️  based on Bmad-Method'));
    console.log(chalk.dim('https://github.com/Viktor-Hermann/APPIQ-METHOD\n'));

    try {
      // Phase 1: Projekt-Typ Detection
      await this.detectProjectType();
      
      // Phase 2: IDE Selection
      await this.selectIDE();
      
      // Phase 3: Installation
      await this.performInstallation();
      
      // Phase 4: One-Click Setup
      await this.setupOneClickWorkflows();
      
      // Phase 5: Simple Instructions
      await this.showSimpleInstructions();
      
    } catch (error) {
      console.error(chalk.red('❌ Installation failed:'), error.message);
      process.exit(1);
    }
  }

  async detectProjectType() {
    console.log(chalk.yellow('🔍 Projekt-Analyse...'));
    
    // Auto-Detection
    const hasPackageJson = fs.existsSync(path.join(this.projectRoot, 'package.json'));
    const hasPubspec = fs.existsSync(path.join(this.projectRoot, 'pubspec.yaml'));
    const hasExistingCode = this.hasExistingSourceCode();
    const hasDocumentation = this.hasExistingDocumentation();
    
    let suggestedType = 'greenfield';
    let reason = 'Neues Projekt erkannt';
    
    if (hasExistingCode || hasDocumentation) {
      suggestedType = 'brownfield';
      reason = 'Existierenden Code/Dokumentation gefunden';
    }
    
    console.log(chalk.gray(`💡 Analyse: ${reason}`));
    console.log(chalk.gray(`📊 Empfehlung: ${suggestedType === 'greenfield' ? 'Greenfield (Neues Projekt)' : 'Brownfield (Bestehendes Projekt)'}`));
    
    // User Confirmation
    const { projectType } = await inquirer.prompt([
      {
        type: 'list',
        name: 'projectType',
        message: '🎯 Welcher Projekt-Typ ist das?',
        choices: [
          {
            name: `✨ Greenfield - Neues Projekt (Empfohlen: ${suggestedType === 'greenfield' ? '✅' : '❌'})`,
            value: 'greenfield',
            short: 'Greenfield'
          },
          {
            name: `🔧 Brownfield - Bestehendes Projekt (Empfohlen: ${suggestedType === 'brownfield' ? '✅' : '❌'})`,
            value: 'brownfield',
            short: 'Brownfield'
          }
        ],
        default: suggestedType
      }
    ]);
    
    this.config.projectType = projectType;
    console.log(chalk.green(`✅ Projekt-Typ: ${projectType === 'greenfield' ? 'Greenfield (Neu)' : 'Brownfield (Bestehend)'}\n`));
  }

  async selectIDE() {
    console.log(chalk.yellow('🛠️ IDE Auswahl'));
    console.log(chalk.gray('Wählen Sie Ihre Haupt-IDE für die Entwicklung:\n'));
    
    const { ide } = await inquirer.prompt([
      {
        type: 'list',
        name: 'ide',
        message: '🎯 Welche IDE nutzen Sie hauptsächlich?',
        choices: [
          { name: '🔵 Cursor', value: 'cursor' },
          { name: '🟣 Claude Code', value: 'claude-code' },
          { name: '🟢 Windsurf', value: 'windsurf' },
          { name: '🔶 VS Code + Cline', value: 'cline' },
          { name: '🟡 Andere/Später', value: 'manual' }
        ]
      }
    ]);
    
    this.config.selectedIDE = ide;
    console.log(chalk.green(`✅ IDE: ${this.getIDEName(ide)}\n`));
  }

  async performInstallation() {
    console.log(chalk.yellow('📦 Installation läuft...'));
    
    // Create appiq directory
    if (!fs.existsSync(this.appiqPath)) {
      fs.mkdirSync(this.appiqPath, { recursive: true });
    }
    
    // Install optimized agents
    await this.installOptimizedAgents();
    
    // Install project-specific configs
    await this.installProjectConfig();
    
    // Setup IDE integration
    await this.setupIDEIntegration();
    
    console.log(chalk.green('✅ Installation abgeschlossen!\n'));
  }

  async installOptimizedAgents() {
    console.log(chalk.gray('  📄 Optimierte Agents installieren...'));
    
    const agentsDir = path.join(this.appiqPath, 'agents');
    if (!fs.existsSync(agentsDir)) {
      fs.mkdirSync(agentsDir, { recursive: true });
    }
    
    // Core optimized agents
    const agents = [
      'smart-launcher',
      'project-manager', 
      'architect',
      'story-master',
      'developer',
      'qa-expert'
    ];
    
    for (const agent of agents) {
      await this.createOptimizedAgent(agent);
    }
  }

  async createOptimizedAgent(agentName) {
    const agentContent = this.generateOptimizedAgentContent(agentName);
    const filePath = path.join(this.appiqPath, 'agents', `${agentName}.md`);
    fs.writeFileSync(filePath, agentContent);
  }

  generateOptimizedAgentContent(agentName) {
    const agentConfigs = {
      'smart-launcher': {
        name: 'Appiq Launcher',
        role: 'Intelligenter Projekt-Starter',
        commands: ['/start', '/quick-setup', '/help'],
        description: 'Startet automatisch den optimalen Workflow basierend auf Ihrem Projekt-Typ'
      },
      'project-manager': {
        name: 'Project Manager',
        role: 'PRD & Projekt-Planung',
        commands: ['/prd', '/plan', '/epic'],
        description: 'Erstellt PRD und Projekt-Dokumentation'
      },
      'architect': {
        name: 'System Architect', 
        role: 'Technische Architektur',
        commands: ['/architecture', '/tech-stack', '/design'],
        description: 'Entwickelt System-Architektur und Tech-Stack'
      },
      'story-master': {
        name: 'Story Master',
        role: 'User Stories & Sprint Planning',
        commands: ['/story', '/sprint', '/tasks'],
        description: 'Erstellt User Stories und Sprint-Planung'
      },
      'developer': {
        name: 'Senior Developer',
        role: 'Code Implementation',
        commands: ['/code', '/implement', '/fix'],
        description: 'Implementiert Features und behebt Bugs'
      },
      'qa-expert': {
        name: 'QA Expert',
        role: 'Testing & Qualität',
        commands: ['/test', '/review', '/validate'],
        description: 'Führt Tests durch und validiert Code-Qualität'
      }
    };

    const config = agentConfigs[agentName];
    
    return `# ${config.name}

## 🎯 Rolle
${config.role}

## 📋 Verfügbare Kommandos
${config.commands.map(cmd => `- **${cmd}** - ${config.description}`).join('\n')}

## 🚀 One-Click Workflows

### Für ${this.config.projectType === 'greenfield' ? 'NEUE' : 'BESTEHENDE'} Projekte:

${this.config.projectType === 'greenfield' ? 
  this.generateGreenfieldWorkflow(config) : 
  this.generateBrownfieldWorkflow(config)}

## 🎮 Einfache Nutzung

1. **Laden Sie diesen Agent in Ihre IDE**
2. **Sagen Sie:** "Agiere als ${config.name}"
3. **Verwenden Sie:** ${config.commands[0]} für Quick-Start

---
*Automatisch optimiert für ${this.getIDEName(this.config.selectedIDE)}*
*Powered by Appiq - Based on Bmad-Method*
`;
  }

  generateGreenfieldWorkflow(config) {
    const workflows = {
      'Appiq Launcher': `
**🚀 Schnell-Start für neues Projekt:**
1. \`/start\` - Automatische Projekt-Analyse
2. Erstellt automatisch: PRD-Vorlage, Architektur-Basis, erste Stories
3. **Wo alles hingehört:** Alle Dateien werden automatisch in \`docs/\` erstellt`,

      'Project Manager': `
**📋 PRD Erstellung:**
1. \`/prd\` - Startet PRD-Assistent
2. **Datei wird erstellt:** \`docs/prd.md\`
3. **Nächster Schritt:** Architect für Architektur`,

      'System Architect': `
**🏗️ Architektur erstellen:**
1. \`/architecture\` - Basierend auf PRD
2. **Datei wird erstellt:** \`docs/architecture.md\`
3. **Nächster Schritt:** Story Master für erste Stories`,

      'Story Master': `
**📝 Erste Stories:**
1. \`/story\` - Erstellt erste User Story
2. **Datei wird erstellt:** \`docs/stories/story-001.md\`
3. **Nächster Schritt:** Developer für Implementation`,

      'Senior Developer': `
**💻 Implementation:**
1. \`/implement\` - Implementiert aktuelle Story
2. **Erstellt/bearbeitet:** Entsprechende Code-Dateien
3. **Nächster Schritt:** QA Expert für Review`,

      'QA Expert': `
**✅ Testing & Review:**
1. \`/review\` - Reviewed aktuellen Code
2. **Erstellt:** Test-Dateien und Reports
3. **Nächster Schritt:** Zurück zu Story Master für nächste Story`
    };

    return workflows[config.name] || 'Standard Greenfield Workflow';
  }

  generateBrownfieldWorkflow(config) {
    const workflows = {
      'Appiq Launcher': `
**🔧 Schnell-Start für bestehendes Projekt:**
1. \`/analyze\` - Analysiert bestehendes Projekt
2. **Findet:** Existierende Docs, Code-Struktur, Tech-Stack
3. **Erstellt:** Angepasste Workflows für Ihr Projekt`,

      'Project Manager': `
**📋 Bestehende Dokumentation:**
1. \`/analyze-docs\` - Scannt bestehende Dokumentation
2. **Legt PRD ab in:** \`docs/prd.md\` (falls nicht vorhanden)
3. **Nächster Schritt:** Architect für Architektur-Review`,

      'System Architect': `
**🏗️ Architektur-Review:**
1. \`/review-architecture\` - Analysiert bestehende Struktur
2. **Erstellt/updated:** \`docs/architecture.md\`
3. **Nächster Schritt:** Story Master für neue Features`,

      'Story Master': `
**📝 Feature Stories:**
1. \`/new-feature\` - Neue Story für bestehendes Projekt
2. **Datei wird erstellt:** \`docs/stories/feature-XXX.md\`
3. **Berücksichtigt:** Bestehende Code-Basis`,

      'Senior Developer': `
**💻 Feature Implementation:**
1. \`/add-feature\` - Implementiert in bestehendem Code
2. **Bearbeitet:** Bestehende Dateien sicher
3. **Erstellt:** Neue Dateien wo nötig`,

      'QA Expert': `
**✅ Regression Testing:**
1. \`/regression-test\` - Testet neue Features
2. **Validiert:** Keine Breaking Changes
3. **Erstellt:** Test-Reports für bestehende + neue Features`
    };

    return workflows[config.name] || 'Standard Brownfield Workflow';
  }

  async setupOneClickWorkflows() {
    console.log(chalk.yellow('⚡ One-Click Workflows einrichten...'));
    
    // Create quick commands
    const commandsDir = path.join(this.appiqPath, 'commands');
    if (!fs.existsSync(commandsDir)) {
      fs.mkdirSync(commandsDir, { recursive: true });
    }
    
    // Project-type specific quick starts
    const quickStartContent = this.generateQuickStartScript();
    fs.writeFileSync(path.join(commandsDir, 'quick-start.md'), quickStartContent);
    
    console.log(chalk.green('✅ One-Click Workflows bereit!\n'));
  }

  generateQuickStartScript() {
    return `# 🚀 Appiq Quick Start

## Für ${this.config.projectType === 'greenfield' ? 'NEUE' : 'BESTEHENDE'} Projekte

### ⚡ One-Command Start:

\`\`\`bash
# In Ihrer IDE, kopieren Sie einfach:
${this.config.projectType === 'greenfield' ? 
  '/start new-project' : 
  '/analyze existing-project'}
\`\`\`

### 📁 Wo gehört was hin?

${this.config.projectType === 'greenfield' ? `
**NEUE PROJEKTE:**
- ✅ **PRD:** \`docs/prd.md\` (wird automatisch erstellt)
- ✅ **Architektur:** \`docs/architecture.md\` (wird automatisch erstellt)  
- ✅ **Stories:** \`docs/stories/\` (wird automatisch erstellt)
- ✅ **Code:** Ihr gewähltes Projekt-Layout

*Erstellt mit Appiq - Basierend auf Bmad-Method*
` : `
**BESTEHENDE PROJEKTE:**
- ✅ **PRD:** Legen Sie bestehende PRD in \`docs/prd.md\`
- ✅ **Architektur:** Bestehende Architektur in \`docs/architecture.md\`
- ✅ **Stories:** Neue Features in \`docs/stories/\`
- ✅ **Code:** Arbeitet mit Ihrer bestehenden Struktur
`}

### 🎯 3-Schritt Erfolgsformel:

1. **Agent laden** → Agent-Datei in IDE kopieren
2. **Kommando ausführen** → \`${this.config.projectType === 'greenfield' ? '/start' : '/analyze'}\`
3. **Folgen Sie den automatischen Anweisungen** → System führt Sie durch alles

### 🆘 Hilfe:

- **\`/help\`** - Zeigt alle verfügbaren Kommandos
- **\`/status\`** - Aktueller Projekt-Status
- **\`/next\`** - Was ist der nächste Schritt?

---
*Optimiert für ${this.getIDEName(this.config.selectedIDE)} - ${new Date().toLocaleDateString('de-DE')}*
*Powered by Appiq - Built with ❤️  based on Bmad-Method*
`;
  }

  async setupIDEIntegration() {
    if (this.config.selectedIDE === 'manual') return;
    
    console.log(chalk.gray(`  🔧 ${this.getIDEName(this.config.selectedIDE)} Integration...`));
    
    const ideConfig = this.getIDEConfig(this.config.selectedIDE);
    const ideDir = path.join(this.projectRoot, ideConfig.dir);
    
    if (!fs.existsSync(ideDir)) {
      fs.mkdirSync(ideDir, { recursive: true });
    }
    
    // Copy agents to IDE-specific format
    const agentsPath = path.join(this.appiqPath, 'agents');
    const agents = fs.readdirSync(agentsPath);
    
    for (const agent of agents) {
      const sourcePath = path.join(agentsPath, agent);
      const targetPath = path.join(ideDir, agent.replace('.md', ideConfig.suffix));
      fs.copyFileSync(sourcePath, targetPath);
    }
  }

  getIDEConfig(ide) {
    const configs = {
      'cursor': { dir: '.cursor/rules', suffix: '.mdc' },
      'claude-code': { dir: '.claude/commands/Epic', suffix: '.md' },
      'windsurf': { dir: '.windsurf/rules', suffix: '.md' },
      'cline': { dir: '.clinerules', suffix: '.md' }
    };
    return configs[ide] || { dir: '.epic-solution', suffix: '.md' };
  }

  getIDEName(ide) {
    const names = {
      'cursor': 'Cursor',
      'claude-code': 'Claude Code',
      'windsurf': 'Windsurf', 
      'cline': 'VS Code + Cline',
      'manual': 'Manuell'
    };
    return names[ide] || ide;
  }

  async showSimpleInstructions() {
    console.log(chalk.bold.green('🎉 Appiq Installation Erfolgreich!\n'));
    console.log(chalk.dim('Built with ❤️  based on the amazing Bmad-Method'));
    console.log(chalk.dim('https://github.com/Viktor-Hermann/APPIQ-METHOD\n'));
    
    console.log(chalk.cyan('📋 Nächste Schritte (Super einfach):'));
    console.log(chalk.white('════════════════════════════════════\n'));
    
    if (this.config.selectedIDE !== 'manual') {
      console.log(chalk.yellow(`1. ${this.getIDEName(this.config.selectedIDE)} öffnen`));
      console.log(chalk.gray(`   → Agents sind bereits installiert!\n`));
    }
    
    console.log(chalk.yellow('2. Appiq Launcher laden:'));
    console.log(chalk.white(`   → Kopieren Sie: ${chalk.bold('appiq/agents/smart-launcher.md')}`));
    console.log(chalk.gray(`   → In Ihre IDE einfügen\n`));
    
    console.log(chalk.yellow('3. Sagen Sie Ihrer IDE:'));
    console.log(chalk.white(`   → ${chalk.bold('"Agiere als Appiq Launcher"')}\n`));
    
    console.log(chalk.yellow('4. One-Command Start:'));
    console.log(chalk.white(chalk.bold(`   → ${this.config.projectType === 'greenfield' ? '/start' : '/analyze'}`)));
    console.log(chalk.gray(`   → Das System führt Sie automatisch durch alles!\n`));
    
    console.log(chalk.cyan('🎯 Das war\'s! Kein komplizierter Setup mehr.'));
    console.log(chalk.green('🚀 Viel Erfolg mit Appiq!\n'));
    
    // Quick reference
    console.log(chalk.dim('━'.repeat(50)));
    console.log(chalk.dim('📁 Quick Reference:'));
    console.log(chalk.dim(`   • Agents: appiq/agents/`));
    console.log(chalk.dim(`   • Quick Start: appiq/commands/quick-start.md`));
    console.log(chalk.dim(`   • Projekt-Typ: ${this.config.projectType}`));
    console.log(chalk.dim(`   • IDE: ${this.getIDEName(this.config.selectedIDE)}`));
  }

  // Helper methods
  hasExistingSourceCode() {
    const sourceDirs = ['src', 'lib', 'app', 'components', 'pages'];
    return sourceDirs.some(dir => 
      fs.existsSync(path.join(this.projectRoot, dir)) && 
      fs.readdirSync(path.join(this.projectRoot, dir)).length > 0
    );
  }

  hasExistingDocumentation() {
    const docFiles = ['README.md', 'docs', 'documentation'];
    return docFiles.some(file => fs.existsSync(path.join(this.projectRoot, file)));
  }

  async installProjectConfig() {
    const configContent = this.generateProjectConfig();
    fs.writeFileSync(path.join(this.appiqPath, 'project-config.yaml'), configContent);
  }

  generateProjectConfig() {
    return `# Appiq Project Configuration
# Built with ❤️  based on Bmad-Method
version: "1.0.0"
project:
  type: ${this.config.projectType}
  created: ${new Date().toISOString()}
  ide: ${this.config.selectedIDE}

# Wo die wichtigen Dateien liegen
paths:
  prd: "docs/prd.md"
  architecture: "docs/architecture.md" 
  stories: "docs/stories/"
  agents: "appiq/agents/"

# One-Click Workflows
workflows:
  ${this.config.projectType === 'greenfield' ? 'greenfield' : 'brownfield'}:
    start_command: "${this.config.projectType === 'greenfield' ? '/start' : '/analyze'}"
    agents_sequence: 
      - smart-launcher
      - project-manager
      - architect
      - story-master
      - developer
      - qa-expert

# IDE Integration
ide:
  name: ${this.getIDEName(this.config.selectedIDE)}
  config_path: ${this.getIDEConfig(this.config.selectedIDE).dir}
  file_format: ${this.getIDEConfig(this.config.selectedIDE).suffix}
`;
  }
}

// Run installer if called directly  
if (require.main === module) {
  const installer = new AppiqInstaller();
  installer.install().catch(console.error);
}

module.exports = AppiqInstaller;