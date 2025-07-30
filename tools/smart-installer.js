#!/usr/bin/env node

/**
 * APPIQ Smart Installer
 * 
 * Intelligent installation script that can be run directly from GitHub:
 * curl -fsSL https://raw.githubusercontent.com/Viktor-Hermann/APPIQ-METHOD/main/tools/smart-installer.js | node
 * 
 * Or locally:
 * node tools/smart-installer.js
 */

const fs = require('fs');
const path = require('path');
const os = require('os');
const { execSync } = require('child_process');

class APPIQSmartInstaller {
  constructor() {
    this.projectRoot = process.cwd();
    this.bmadPath = path.join(this.projectRoot, 'bmad-core');
    this.config = {
      version: '4.0.0',
      projectType: null,
      techStack: {},
      installationMode: 'smart'
    };
  }

  async install() {
    console.log('🚀 APPIQ Smart Installer v4.0.0');
    console.log('=====================================\n');

    try {
      // Phase 1: Environment Analysis
      await this.analyzeEnvironment();
      
      // Phase 2: Project Detection
      await this.detectProjectContext();
      
      // Phase 3: Installation
      await this.performInstallation();
      
      // Phase 4: Configuration
      await this.configureProject();
      
      // Phase 5: Setup Complete
      await this.completionGuide();
      
    } catch (error) {
      console.error('❌ Installation failed:', error.message);
      process.exit(1);
    }
  }

  async analyzeEnvironment() {
    console.log('🔍 Analyzing environment...');
    
    // Check Node.js version
    const nodeVersion = process.version;
    const majorVersion = parseInt(nodeVersion.slice(1).split('.')[0]);
    
    if (majorVersion < 20) {
      throw new Error(`Node.js v20+ required. Current version: ${nodeVersion}`);
    }
    
    console.log(`✅ Node.js ${nodeVersion} detected`);
    
    // Check if we're in a git repository
    try {
      execSync('git rev-parse --git-dir', { stdio: 'ignore' });
      this.config.hasGit = true;
      console.log('✅ Git repository detected');
    } catch {
      this.config.hasGit = false;
      console.log('ℹ️  Not in a git repository');
    }
    
    // Check for existing APPIQ installation
    if (fs.existsSync(this.bmadPath)) {
      this.config.existingInstallation = true;
      console.log('🔄 Existing APPIQ installation detected');
    } else {
      this.config.existingInstallation = false;
      console.log('🆕 New APPIQ installation');
    }
    
    console.log('');
  }

  async detectProjectContext() {
    console.log('🔍 Detecting project context...');
    
    const projectFiles = fs.readdirSync(this.projectRoot);
    
    // Detect tech stack based on configuration files
    const techStack = {
      frontend: null,
      backend: null,
      mobile: null,
      database: null,
      stateManagement: null
    };

    // Package.json analysis (Node.js/Web projects)
    if (projectFiles.includes('package.json')) {
      const packageJson = JSON.parse(fs.readFileSync('package.json', 'utf8'));
      const deps = { ...packageJson.dependencies, ...packageJson.devDependencies };
      
      // Frontend framework detection
      if (deps.react) techStack.frontend = 'react';
      else if (deps.vue) techStack.frontend = 'vue';
      else if (deps['@angular/core']) techStack.frontend = 'angular';
      else if (deps.svelte) techStack.frontend = 'svelte';
      
      // Backend detection
      if (deps.express || deps.fastify) techStack.backend = 'node';
      if (deps.firebase) techStack.backend = 'firebase';
      if (deps['@supabase/supabase-js']) techStack.backend = 'supabase';
      
      // State management
      if (deps['@reduxjs/toolkit']) techStack.stateManagement = 'redux-toolkit';
      else if (deps.zustand) techStack.stateManagement = 'zustand';
      else if (deps.valtio) techStack.stateManagement = 'valtio';
      
      console.log('📦 Node.js project detected');
    }

    // Flutter project detection
    if (projectFiles.includes('pubspec.yaml')) {
      const pubspec = fs.readFileSync('pubspec.yaml', 'utf8');
      techStack.mobile = 'flutter';
      
      if (pubspec.includes('flutter_bloc')) techStack.stateManagement = 'cubit';
      if (pubspec.includes('riverpod')) techStack.stateManagement = 'riverpod';
      
      console.log('📱 Flutter project detected');
    }

    // Python project detection
    if (projectFiles.includes('requirements.txt') || projectFiles.includes('pyproject.toml')) {
      techStack.backend = 'python';
      console.log('🐍 Python project detected');
    }

    // Go project detection
    if (projectFiles.includes('go.mod')) {
      techStack.backend = 'go';
      console.log('🐹 Go project detected');
    }

    // Rust project detection
    if (projectFiles.includes('Cargo.toml')) {
      techStack.backend = 'rust';
      console.log('🦀 Rust project detected');
    }

    // Determine project type
    const hasSourceCode = projectFiles.some(file => 
      file === 'src' || file === 'lib' || file === 'app' || file === 'components'
    );

    this.config.projectType = hasSourceCode ? 'brownfield' : 'greenfield';
    this.config.techStack = techStack;

    // Display detection results
    console.log('\n📊 Project Analysis Results:');
    console.log(`   Type: ${this.config.projectType}`);
    if (techStack.frontend) console.log(`   Frontend: ${techStack.frontend}`);
    if (techStack.mobile) console.log(`   Mobile: ${techStack.mobile}`);
    if (techStack.backend) console.log(`   Backend: ${techStack.backend}`);
    if (techStack.stateManagement) console.log(`   State Management: ${techStack.stateManagement}`);
    
    console.log('');
  }

  async performInstallation() {
    console.log('📥 Installing APPIQ framework...');
    
    if (this.config.existingInstallation) {
      console.log('🔄 Updating existing installation...');
      // Backup existing configuration
      if (fs.existsSync(path.join(this.bmadPath, 'core-config.yaml'))) {
        fs.copyFileSync(
          path.join(this.bmadPath, 'core-config.yaml'),
          path.join(this.bmadPath, 'core-config.yaml.bak')
        );
        console.log('💾 Existing configuration backed up');
      }
    } else {
      console.log('🆕 Installing fresh APPIQ installation...');
    }

    // Download or copy BMAD files
    try {
      if (fs.existsSync(path.join(__dirname, '..', 'bmad-core'))) {
        // Local installation (development)
        this.copyLocalFiles();
      } else {
        // Remote installation (from GitHub)
        await this.downloadFromGitHub();
      }
      
      console.log('✅ APPIQ core files installed');
    } catch (error) {
      throw new Error(`Failed to install APPIQ files: ${error.message}`);
    }

    // Install expansion packs based on detected tech stack
    await this.installExpansionPacks();
    
    console.log('');
  }

  copyLocalFiles() {
    const sourcePath = path.join(__dirname, '..', 'bmad-core');
    const targetPath = this.bmadPath;
    
    if (!fs.existsSync(targetPath)) {
      fs.mkdirSync(targetPath, { recursive: true });
    }
    
    this.copyDirectory(sourcePath, targetPath);
    
    // Copy expansion packs if applicable
    const expansionPacksSource = path.join(__dirname, '..', 'expansion-packs');
    const expansionPacksTarget = path.join(this.projectRoot, 'expansion-packs');
    
    if (fs.existsSync(expansionPacksSource)) {
      this.copyDirectory(expansionPacksSource, expansionPacksTarget);
    }
  }

  copyDirectory(source, target) {
    if (!fs.existsSync(target)) {
      fs.mkdirSync(target, { recursive: true });
    }
    
    const files = fs.readdirSync(source);
    
    for (const file of files) {
      const sourcePath = path.join(source, file);
      const targetPath = path.join(target, file);
      
      if (fs.statSync(sourcePath).isDirectory()) {
        this.copyDirectory(sourcePath, targetPath);
      } else {
        fs.copyFileSync(sourcePath, targetPath);
      }
    }
  }

  async downloadFromGitHub() {
    console.log('🌐 Downloading APPIQ files from GitHub...');
    
    try {
      // Create temporary directory for download
      const tempDir = path.join(os.tmpdir(), 'appiq-download');
      if (fs.existsSync(tempDir)) {
        fs.rmSync(tempDir, { recursive: true });
      }
      fs.mkdirSync(tempDir, { recursive: true });
      
      // Download and extract repository
      const repoUrl = 'https://github.com/Viktor-Hermann/APPIQ-METHOD/archive/refs/heads/main.zip';
      
      console.log('📥 Downloading repository archive...');
      execSync(`curl -L "${repoUrl}" -o "${path.join(tempDir, 'repo.zip')}"`, { stdio: 'ignore' });
      
      console.log('📦 Extracting files...');
      execSync(`cd "${tempDir}" && unzip -q repo.zip`, { stdio: 'ignore' });
      
      // Copy files from extracted directory
      const extractedDir = path.join(tempDir, 'APPIQ-METHOD-main');
      
      // Copy bmad-core
      const sourceBmadCore = path.join(extractedDir, 'bmad-core');
      if (fs.existsSync(sourceBmadCore)) {
        this.copyDirectory(sourceBmadCore, this.bmadPath);
      }
      
      // Copy expansion-packs
      const sourceExpansionPacks = path.join(extractedDir, 'expansion-packs');
      const targetExpansionPacks = path.join(this.projectRoot, 'expansion-packs');
      if (fs.existsSync(sourceExpansionPacks)) {
        this.copyDirectory(sourceExpansionPacks, targetExpansionPacks);
      }
      
      // Copy common
      const sourceCommon = path.join(extractedDir, 'common');
      const targetCommon = path.join(this.projectRoot, 'common');
      if (fs.existsSync(sourceCommon)) {
        this.copyDirectory(sourceCommon, targetCommon);
      }
      
      // Cleanup
      fs.rmSync(tempDir, { recursive: true });
      
      console.log('✅ Files downloaded and extracted successfully');
      
    } catch (error) {
      console.log('⚠️  GitHub download failed, falling back to local files...');
      console.log(`Error: ${error.message}`);
      
      // Fallback: Try to use local files if available
      if (fs.existsSync(path.join(__dirname, '..', 'bmad-core'))) {
        this.copyLocalFiles();
      } else {
        throw new Error('Unable to download APPIQ files from GitHub and no local files available');
      }
    }
  }

  async installExpansionPacks() {
    const expansionPacks = [];
    
    // Determine which expansion packs to install based on tech stack
    if (this.config.techStack.mobile === 'flutter') {
      expansionPacks.push('bmad-flutter-mobile-dev');
      console.log('📱 Installing Flutter expansion pack...');
    }
    
    if (this.config.techStack.frontend && ['react', 'vue', 'angular'].includes(this.config.techStack.frontend)) {
      // Web development is covered by core
      console.log('🌐 Web development supported by core framework');
    }
    
    if (expansionPacks.length > 0) {
      console.log(`✅ Installed ${expansionPacks.length} expansion pack(s)`);
    }
  }

  async configureProject() {
    console.log('⚙️  Configuring project...');
    
    // Create docs directory if it doesn't exist
    const docsPath = path.join(this.projectRoot, 'docs');
    if (!fs.existsSync(docsPath)) {
      fs.mkdirSync(docsPath);
      console.log('📁 Created docs directory');
    }
    
    // Create project-specific configuration
    const projectConfig = {
      version: this.config.version,
      projectType: this.config.projectType,
      techStack: this.config.techStack,
      installedAt: new Date().toISOString(),
      expansionPacks: []
    };
    
    if (this.config.techStack.mobile === 'flutter') {
      projectConfig.expansionPacks.push('bmad-flutter-mobile-dev');
    }
    
    fs.writeFileSync(
      path.join(this.projectRoot, '.bmad-config.json'),
      JSON.stringify(projectConfig, null, 2)
    );
    
    console.log('✅ Project configuration created');
    console.log('');
  }

  async completionGuide() {
    console.log('🎉 APPIQ Installation Complete!');
    console.log('=====================================\n');
    
    console.log('🚀 Quick Start Guide:');
    console.log('');
    
    if (this.config.projectType === 'greenfield') {
      console.log('📝 For new projects:');
          console.log('   1. Start with: /appiq');
    console.log('   2. Follow the guided setup');
    console.log('   3. Create your PRD and architecture');
    console.log('');
    } else {
      console.log('🔍 For existing projects:');
      console.log('   1. Run: /analyze');
      console.log('   2. Review recommendations');
      console.log('   3. Start with: /appiq');
      console.log('');
    }
    
    console.log('💡 Available Commands:');
    console.log('   /appiq   - Start intelligent project creation');
    console.log('   /story   - Create a new development story');
    console.log('   /analyze - Analyze current project');
    console.log('   /help    - Get context-aware help');
    console.log('');
    
    if (this.config.techStack.mobile === 'flutter') {
      console.log('📱 Flutter-Specific Features:');
      console.log('   - Clean Architecture workflow');
      console.log('   - UI → Cubit → Domain → Data layer development');
      console.log('   - Multi-language support with ARB files');
      console.log('   - Comprehensive testing framework');
      console.log('');
    }
    
    if (this.config.techStack.frontend) {
      console.log('🌐 Web Development Features:');
      console.log('   - Modern framework support');
      console.log('   - Component-based architecture');
      console.log('   - State management integration');
      console.log('   - shadcn/ui component generation');
      console.log('');
    }
    
    console.log('📚 Documentation:');
    console.log('   - User Guide: bmad-core/user-guide.md');
    console.log('   - Agent Reference: bmad-core/agents/');
    console.log('   - Templates: bmad-core/templates/');
    console.log('');
    
    console.log('🎯 Next Steps:');
    console.log('   1. Open your IDE (Cursor, Claude, etc.)');
    console.log('   2. Type /appiq to start your first project');
    console.log('   3. Follow the intelligent guided workflow');
    console.log('');
    
    console.log('💬 Need Help?');
    console.log('   - Discord: https://discord.gg/gk8jAdXWmj');
    console.log('   - GitHub: https://github.com/Viktor-Hermann/APPIQ-METHOD');
    console.log('   - YouTube: https://www.youtube.com/@BMadCode');
    console.log('');
    
    console.log('Happy coding with APPIQ! 🚀');
  }
}

// Run the installer if called directly
if (require.main === module) {
  const installer = new APPIQSmartInstaller();
  installer.install().catch(console.error);
}

module.exports = APPIQSmartInstaller;