#!/usr/bin/env node

/**
 * APPIQ Activation Script
 * 
 * This script should be loaded in your IDE to enable APPIQ slash commands.
 * 
 * Usage in IDE:
 * 1. Load this file in your IDE
 * 2. Use commands like /appiq, /story, /analyze, /help
 */

const fs = require('fs');
const path = require('path');

// Check if APPIQ is installed
const bmadPath = path.join(process.cwd(), 'bmad-core');
if (!fs.existsSync(bmadPath)) {
  console.log('❌ APPIQ-METHOD not found in current directory');
  console.log('📥 Install with: curl -fsSL https://raw.githubusercontent.com/Viktor-Hermann/APPIQ-METHOD/main/install-appiq.sh | bash');
  process.exit(1);
}

console.log('🚀 APPIQ-METHOD Activated!');
console.log('========================\n');

console.log('✅ APPIQ installation detected');
console.log('📁 Location:', bmadPath);

// Load smart launcher agent
const smartLauncherPath = path.join(bmadPath, 'agents', 'bmad-smart-launcher.md');
if (fs.existsSync(smartLauncherPath)) {
  console.log('🤖 Smart Launcher Agent available');
} else {
  console.log('⚠️  Smart Launcher Agent not found');
}

console.log('\n💡 Available Commands:');
console.log('   /appiq   - Start intelligent project creation');
console.log('   /story   - Create a new development story');
console.log('   /analyze - Analyze current project');
console.log('   /help    - Get context-aware help');

console.log('\n🎯 How to use:');
console.log('1. Copy and paste the agent file content into your IDE');
console.log('2. Type any of the commands above');
console.log('3. Follow the intelligent workflow guidance');

console.log('\n📚 Agent Files:');
console.log(`   Smart Launcher: ${smartLauncherPath}`);

// Check for Flutter expansion pack
const flutterExpansionPath = path.join(process.cwd(), 'expansion-packs', 'bmad-flutter-mobile-dev');
if (fs.existsSync(flutterExpansionPath)) {
  console.log('\n📱 Flutter Expansion Pack detected');
  console.log('   Additional Flutter agents available');
}

console.log('\n🔧 Manual Setup (if commands don\'t work):');
console.log('1. Load the Smart Launcher agent in your IDE:');
console.log(`   File: ${smartLauncherPath}`);
console.log('2. Tell your IDE: "Act as the agent defined in this file"');
console.log('3. Use the commands: /appiq, /story, /analyze, /help');

console.log('\n💬 Need Help?');
console.log('   - GitHub: https://github.com/Viktor-Hermann/APPIQ-METHOD');
console.log('   - Discord: https://discord.gg/gk8jAdXWmj');

// Display agent content for easy copying
if (fs.existsSync(smartLauncherPath)) {
  console.log('\n' + '='.repeat(80));
  console.log('📋 SMART LAUNCHER AGENT (Copy this to your IDE):');
  console.log('='.repeat(80));
  
  const agentContent = fs.readFileSync(smartLauncherPath, 'utf8');
  console.log(agentContent);
  
  console.log('\n' + '='.repeat(80));
  console.log('📋 END OF AGENT CONTENT');
  console.log('='.repeat(80));
}