#!/usr/bin/env node

/**
 * APPIQ IDE Commands Setup
 * 
 * Sets up slash commands for popular IDEs (Cursor, Claude, VS Code)
 * Creates the necessary command files and configurations
 */

const fs = require('fs');
const path = require('path');
const os = require('os');

class IDECommandsSetup {
  constructor() {
    this.projectRoot = process.cwd();
    this.homeDir = os.homedir();
    this.supportedIDEs = ['cursor', 'claude', 'vscode'];
  }

  async setup() {
    console.log('🔧 APPIQ IDE Commands Setup');
    console.log('==============================\n');

    try {
      // Detect available IDEs
      const availableIDEs = await this.detectIDEs();
      
      if (availableIDEs.length === 0) {
        console.log('ℹ️  No supported IDEs detected. Creating generic command files...');
        await this.createGenericCommands();
      } else {
        console.log(`✅ Detected IDEs: ${availableIDEs.join(', ')}`);
        
        for (const ide of availableIDEs) {
          await this.setupIDECommands(ide);
        }
      }
      
      // Create local command files in project
      await this.createProjectCommands();
      
      console.log('\n🎉 IDE Commands Setup Complete!');
      console.log('\n🚀 Available Commands:');
      console.log('   /appiq   - Start intelligent project creation');
      console.log('   /story   - Create a new development story');
      console.log('   /analyze - Analyze current project');
      console.log('   /help    - Get context-aware help');
      console.log('\n💡 How to use:');
      console.log('   1. Open your IDE (Cursor, Claude, etc.)');
      console.log('   2. Type any of the commands above');
      console.log('   3. Follow the intelligent workflow guidance');
      
    } catch (error) {
      console.error('❌ Setup failed:', error.message);
      process.exit(1);
    }
  }

  async detectIDEs() {
    const ides = [];
    
    // Check for Cursor
    if (fs.existsSync(path.join(this.homeDir, '.cursor')) || 
        fs.existsSync('/Applications/Cursor.app')) {
      ides.push('cursor');
    }
    
    // Check for VS Code
    if (fs.existsSync(path.join(this.homeDir, '.vscode')) ||
        fs.existsSync('/Applications/Visual Studio Code.app')) {
      ides.push('vscode');
    }
    
    // Claude is web-based, assume available
    ides.push('claude');
    
    return ides;
  }

  async setupIDECommands(ide) {
    console.log(`🔧 Setting up commands for ${ide.toUpperCase()}...`);
    
    switch (ide) {
      case 'cursor':
        await this.setupCursorCommands();
        break;
      case 'vscode':
        await this.setupVSCodeCommands();
        break;
      case 'claude':
        await this.setupClaudeCommands();
        break;
    }
    
    console.log(`✅ ${ide.toUpperCase()} commands configured`);
  }

  async setupCursorCommands() {
    const cursorDir = path.join(this.projectRoot, '.cursor');
    const commandsDir = path.join(cursorDir, 'commands');
    
    // Create directories
    if (!fs.existsSync(cursorDir)) {
      fs.mkdirSync(cursorDir, { recursive: true });
    }
    if (!fs.existsSync(commandsDir)) {
      fs.mkdirSync(commandsDir, { recursive: true });
    }
    
    // Create command files
    const commands = this.getCommandDefinitions();
    
    for (const [name, config] of Object.entries(commands)) {
      const commandFile = path.join(commandsDir, `${name}.md`);
      fs.writeFileSync(commandFile, this.generateCommandFile(name, config));
    }
    
    // Create cursor configuration
    const cursorConfig = {
      "appiq.commands": Object.keys(commands).map(name => `/${name}`)
    };
    
    fs.writeFileSync(
      path.join(cursorDir, 'settings.json'),
      JSON.stringify(cursorConfig, null, 2)
    );
  }

  async setupVSCodeCommands() {
    const vscodeDir = path.join(this.projectRoot, '.vscode');
    const commandsDir = path.join(vscodeDir, 'commands');
    
    // Create directories
    if (!fs.existsSync(vscodeDir)) {
      fs.mkdirSync(vscodeDir, { recursive: true });
    }
    if (!fs.existsSync(commandsDir)) {
      fs.mkdirSync(commandsDir, { recursive: true });
    }
    
    // Create command files
    const commands = this.getCommandDefinitions();
    
    for (const [name, config] of Object.entries(commands)) {
      const commandFile = path.join(commandsDir, `${name}.md`);
      fs.writeFileSync(commandFile, this.generateCommandFile(name, config));
    }
    
    // Create VS Code tasks
    const tasks = {
      "version": "2.0.0",
      "tasks": Object.keys(commands).map(name => ({
        "label": `APPIQ: ${name}`,
        "type": "shell",
        "command": "echo",
        "args": [`Executing /${name} command...`],
        "group": "build"
      }))
    };
    
    fs.writeFileSync(
      path.join(vscodeDir, 'tasks.json'),
      JSON.stringify(tasks, null, 2)
    );
  }

  async setupClaudeCommands() {
    const claudeDir = path.join(this.projectRoot, '.claude');
    const commandsDir = path.join(claudeDir, 'commands');
    
    // Create directories
    if (!fs.existsSync(claudeDir)) {
      fs.mkdirSync(claudeDir, { recursive: true });
    }
    if (!fs.existsSync(commandsDir)) {
      fs.mkdirSync(commandsDir, { recursive: true });
    }
    
    // Create command files
    const commands = this.getCommandDefinitions();
    
    for (const [name, config] of Object.entries(commands)) {
      const commandFile = path.join(commandsDir, `${name}.md`);
      fs.writeFileSync(commandFile, this.generateCommandFile(name, config));
    }
  }

  async createProjectCommands() {
    const commandsDir = path.join(this.projectRoot, 'commands');
    
    if (!fs.existsSync(commandsDir)) {
      fs.mkdirSync(commandsDir, { recursive: true });
    }
    
    const commands = this.getCommandDefinitions();
    
    for (const [name, config] of Object.entries(commands)) {
      const commandFile = path.join(commandsDir, `${name}.md`);
      fs.writeFileSync(commandFile, this.generateCommandFile(name, config));
    }
    
    // Create a commands index
    const indexContent = this.generateCommandsIndex(commands);
    fs.writeFileSync(path.join(commandsDir, 'README.md'), indexContent);
  }

  async createGenericCommands() {
    await this.createProjectCommands();
  }

  getCommandDefinitions() {
    return {
      'appiq': {
        description: 'Start intelligent project creation with automatic tech stack detection',
        agent: 'bmad-smart-launcher',
        workflow: 'appiq_launcher',
        examples: [
          'Analyzes your project automatically',
          'Guides through PRD creation',
          'Sets up optimal agent team',
          'Configures framework-specific workflows'
        ]
      },
      'story': {
        description: 'Create a new development story with context-aware template selection',
        agent: 'bmad-smart-launcher', 
        workflow: 'story_creator',
        examples: [
          'Context-aware story template selection',
          'Automatic task breakdown based on tech stack',
          'Integration with existing epics',
          'Smart dependency detection'
        ]
      },
      'analyze': {
        description: 'Analyze current project structure and recommend optimal workflow',
        agent: 'bmad-smart-launcher',
        workflow: 'project_analyzer',
        examples: [
          'Comprehensive project structure analysis',
          'Tech stack compatibility assessment', 
          'Workflow optimization recommendations',
          'Missing component identification'
        ]
      },
      'help': {
        description: 'Show all available commands with examples',
        agent: 'bmad-smart-launcher',
        workflow: 'help_system',
        examples: [
          'List all available commands',
          'Show command usage examples',
          'Provide context-aware assistance',
          'Guide through APPIQ workflows'
        ]
      }
    };
  }

  generateCommandFile(name, config) {
    return `# /${name}

## Description
${config.description}

## Agent
- **Agent**: ${config.agent}
- **Workflow**: ${config.workflow}

## What it does
${config.examples.map(example => `- ${example}`).join('\n')}

## Usage
Simply type \`/${name}\` in your IDE and the APPIQ Smart Launcher will:

1. **Analyze Context** - Understand your current project setup
2. **Configure Workflow** - Set up the optimal workflow for your needs
3. **Guide Process** - Provide step-by-step intelligent guidance
4. **Execute Tasks** - Coordinate the appropriate agents to complete the workflow

## Prerequisites
- APPIQ-METHOD installed in your project
- Node.js v20+ 
- Supported IDE (Cursor, Claude, VS Code)

## Related Commands
- \`/appiq\` - Main project creation workflow
- \`/story\` - Create development stories
- \`/analyze\` - Project analysis and recommendations
- \`/help\` - Show all available commands

---
*Generated by APPIQ-METHOD Smart Installer*
`;
  }

  generateCommandsIndex(commands) {
    return `# APPIQ Commands Reference

This directory contains the APPIQ slash commands for your IDE.

## Available Commands

${Object.entries(commands).map(([name, config]) => 
  `### \`/${name}\`
${config.description}

**Examples:**
${config.examples.map(example => `- ${example}`).join('\n')}
`).join('\n')}

## How to Use

1. **In your IDE**: Type any of the commands above (e.g., \`/appiq\`)
2. **Follow guidance**: The APPIQ Smart Launcher will guide you through the process
3. **Agent coordination**: The system will automatically coordinate the appropriate agents

## Setup

These commands were automatically created by the APPIQ Smart Installer. If you need to recreate them:

\`\`\`bash
node tools/setup-ide-commands.js
\`\`\`

## Support

- 📚 [Documentation](../bmad-core/user-guide.md)
- 💬 [Discord Community](https://discord.gg/gk8jAdXWmj)
- 🐙 [GitHub](https://github.com/Viktor-Hermann/APPIQ-METHOD)

---
*Generated by APPIQ-METHOD v4.0.0*
`;
  }
}

// Run the setup if called directly
if (require.main === module) {
  const setup = new IDECommandsSetup();
  setup.setup().catch(console.error);
}

module.exports = IDECommandsSetup;