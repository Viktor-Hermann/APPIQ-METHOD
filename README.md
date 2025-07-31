# 🚀 APPIQ SOLUTION: Universal AI Agent Framework

[![Version](https://img.shields.io/npm/v/appiq-solution?color=blue&label=version)](https://www.npmjs.com/package/appiq-solution)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Node.js Version](https://img.shields.io/badge/node-%3E%3D20.0.0-brightgreen)](https://nodejs.org)
[![Discord](https://img.shields.io/badge/Discord-Join%20Community-7289da?logo=discord&logoColor=white)](https://discord.gg/gk8jAdXWmj)

**🎉 NEW: One-Command Installation with Smart MCP Integration!**

APPIQ SOLUTION: Advanced Project Intelligence & Quality Solution - Built with ❤️ based on the amazing Bmad-Method. Transform any domain with specialized AI expertise: Flutter mobile development, modern web apps, fullstack solutions, and beyond.

**[Subscribe to BMadCode on YouTube](https://www.youtube.com/@BMadCode?sub_confirmation=1)**

**[Join our Discord Community](https://discord.gg/gk8jAdXWmj)** - A growing community for AI enthusiasts! Get help, share ideas, explore AI agents & frameworks, collaborate on tech projects, enjoy hobbies, and help each other succeed. Whether you're stuck on BMad, building your own agents, or just want to chat about the latest in AI - we're here for you! **Some mobile and VPN may have issue joining the discord, this is a discord issue - if the invite does not work, try from your own internet or another network, or non-VPN.**

⭐ **If you find this project helpful or useful, please give it a star in the upper right hand corner!** It helps others discover APPIQ-METHOD and you will be notified of updates!

## Overview

**APPIQ Method's Two Key Innovations:**

**1. Agentic Planning:** Dedicated agents (Analyst, PM, Architect) collaborate with you to create detailed, consistent PRDs and Architecture documents. Through advanced prompt engineering and human-in-the-loop refinement, these planning agents produce comprehensive specifications that go far beyond generic AI task generation.

**2. Context-Engineered Development:** The Scrum Master agent then transforms these detailed plans into hyper-detailed development stories that contain everything the Dev agent needs - full context, implementation details, and architectural guidance embedded directly in story files.

This two-phase approach eliminates both **planning inconsistency** and **context loss** - the biggest problems in AI-assisted development. Your Dev agent opens a story file with complete understanding of what to build, how to build it, and why.

**📖 [See the complete workflow in the User Guide](bmad-core/user-guide.md)** - Planning phase, development cycle, and all agent roles

## Quick Navigation

### Understanding the APPIQ Workflow

**Before diving in, review these critical workflow diagrams that explain how APPIQ works:**

1. **[Planning Workflow (Web UI)](bmad-core/user-guide.md#the-planning-workflow-web-ui)** - How to create PRD and Architecture documents
2. **[Core Development Cycle (IDE)](bmad-core/user-guide.md#the-core-development-cycle-ide)** - How SM, Dev, and QA agents collaborate through story files

> ⚠️ **These diagrams explain 90% of BMad Method Agentic Agile flow confusion** - Understanding the PRD+Architecture creation and the SM/Dev/QA workflow and how agents pass notes through story files is essential - and also explains why this is NOT taskmaster or just a simple task runner!

### What would you like to do?

- **[Install and Build software with Full Stack Agile AI Team](#quick-start)** → Quick Start Instruction
- **[Learn how to use BMad](bmad-core/user-guide.md)** → Complete user guide and walkthrough
- **[See available AI agents](/bmad-core/agents))** → Specialized roles for your team
- **[Explore non-technical uses](#-beyond-software-development---expansion-packs)** → Creative writing, business, wellness, education
- **[Create my own AI agents](#creating-your-own-expansion-pack)** → Build agents for your domain
- **[Browse ready-made expansion packs](expansion-packs/)** → Game dev, DevOps, infrastructure and get inspired with ideas and examples
- **[Understand the architecture](docs/core-architecture.md)** → Technical deep dive
- **[Join the community](https://discord.gg/gk8jAdXWmj)** → Get help and share ideas

## Important: Keep Your BMad Installation Updated

**Stay up-to-date effortlessly!** If you already have BMad-Method installed in your project, simply run:

```bash
npx bmad-method install
# OR
git pull
npm run install:bmad
```

This will:

- ✅ Automatically detect your existing v4 installation
- ✅ Update only the files that have changed and add new files
- ✅ Create `.bak` backup files for any custom modifications you've made
- ✅ Preserve your project-specific configurations

This makes it easy to benefit from the latest improvements, bug fixes, and new agents without losing your customizations!

## Quick Start

### 🚀 NEW: One-Command Installation (10 seconds setup)

**The simplest way to get started with APPIQ Solution:**

```bash
npx appiq-solution install
```

**That's it!** The Smart Installer will:
- ✅ **Multi-IDE Support**: Configure Cursor, Claude Code, Windsurf, VS Code + Cline, and more
- ✅ **Auto-detect Tech Stack**: Flutter, React, Vue, Next.js, Angular, Fullstack, API-only
- ✅ **Smart MCP Integration**: Agents know which MCP servers they can use (no auto-config)
- ✅ **Planning Workflow**: Project idea → Plan generation → Approval → Development
- ✅ **Full BMAD Flow**: Document sharding, agent orchestration, development cycle
- ✅ **Flutter Support**: Dart MCP Server integration, Clean Architecture, Cubit patterns
- ✅ **Modern Web**: shadcn/ui, v0.dev, Tailwind CSS integration
- ✅ **Security First**: No API keys stored or configured automatically

### 🎯 **What MCPs are Available?**

Your agents will know about these MCP servers (you configure them manually in your IDE):

- **🧠 Sequential Thinking**: Complex problem solving
- **🌐 Puppeteer**: Browser automation and testing  
- **🔗 Claude Continuity**: Enhanced thread continuity
- **💾 Extended Memory**: Enhanced AI memory capabilities
- **✨ 21st.dev Magic**: UI builder like v0 in your IDE
- **📱 Dart MCP**: Flutter/Dart development (auto-detected for Flutter projects)
- **🔥 Firebase**: Auth, Firestore, Functions integration
- **⚡ Supabase**: Database, auth, storage
- **📚 Context7**: Up-to-date library documentation
- **💳 Stripe**: Payment integration

Then in your IDE (Cursor, Claude, etc.):
```
@smart-launcher
```

**📖 [Complete Smart Workflow Guide](SMART_WORKFLOW_GUIDE.md)**

### Alternative: Traditional BMAD Installation

**For the original BMAD-METHOD experience:**

```bash
npx bmad-method install
# OR if you already have BMad installed:
git pull
npm run install:bmad
```

**Prerequisites**: [Node.js](https://nodejs.org) v20+ required

### 🔄 **Upgrading from BMAD-METHOD?**

APPIQ Solution is fully compatible! You can:
- ✅ **Keep existing projects** - APPIQ works alongside BMAD
- ✅ **Use both installers** - `npx bmad-method install` for traditional, `npx appiq-solution install` for modern
- ✅ **Migrate gradually** - Start new projects with APPIQ, keep existing with BMAD

### Fastest Start: Web UI Full Stack Team at your disposal (2 minutes)

1. **Get the bundle**: Save or clone the [full stack team file](dist/teams/team-fullstack.txt) or choose another team
2. **Create AI agent**: Create a new Gemini Gem or CustomGPT
3. **Upload & configure**: Upload the file and set instructions: "Your critical operating instructions are attached, do not break character as directed"
4. **Start Ideating and Planning**: Start chatting! Type `*help` to see available commands or pick an agent like `*analyst` to start right in on creating a brief.
5. **CRITICAL**: Talk to BMad Orchestrator in the web at ANY TIME (#bmad-orchestrator command) and ask it questions about how this all works!
6. **When to move to the IDE**: Once you have your PRD, Architecture, optional UX and Briefs - its time to switch over to the IDE to shard your docs, and start implementing the actual code! See the [User guide](bmad-core/user-guide.md) for more details

### Alternative: Clone and Build

```bash
git clone https://github.com/bmadcode/bmad-method.git
npm run install:bmad # build and install all to a destination folder
```

## 🌟 Beyond Software Development - Expansion Packs

Both APPIQ Solution and BMad's natural language framework work in ANY domain. Expansion packs provide specialized AI agents for:

- **📱 Flutter Mobile Development** - Clean Architecture, Cubit, Dart MCP integration
- **🎮 Game Development** - Unity 2D, Phaser.js game creation
- **🏗️ DevOps & Infrastructure** - Platform engineering, deployment automation
- **✍️ Creative Writing** - Story development, character creation
- **💼 Business Strategy** - Planning, analysis, decision-making
- **🏥 Health & Wellness** - Personal development, fitness planning
- **🎓 Education** - Learning paths, curriculum development

[See the Expansion Packs Guide](docs/expansion-packs.md) and learn to create your own!

## Codebase Flattener Tool

The BMad-Method includes a powerful codebase flattener tool designed to prepare your project files for AI model consumption. This tool aggregates your entire codebase into a single XML file, making it easy to share your project context with AI assistants for analysis, debugging, or development assistance.

### Features

- **AI-Optimized Output**: Generates clean XML format specifically designed for AI model consumption
- **Smart Filtering**: Automatically respects `.gitignore` patterns to exclude unnecessary files
- **Binary File Detection**: Intelligently identifies and excludes binary files, focusing on source code
- **Progress Tracking**: Real-time progress indicators and comprehensive completion statistics
- **Flexible Output**: Customizable output file location and naming

### Usage

```bash
# Basic usage - creates flattened-codebase.xml in current directory
npx bmad-method flatten

# Specify custom input directory
npx bmad-method flatten --input /path/to/source/directory
npx bmad-method flatten -i /path/to/source/directory

# Specify custom output file
npx bmad-method flatten --output my-project.xml
npx bmad-method flatten -o /path/to/output/codebase.xml

# Combine input and output options
npx bmad-method flatten --input /path/to/source --output /path/to/output/codebase.xml
```

### Example Output

The tool will display progress and provide a comprehensive summary:

```
📊 Completion Summary:
✅ Successfully processed 156 files into flattened-codebase.xml
📁 Output file: /path/to/your/project/flattened-codebase.xml
📏 Total source size: 2.3 MB
📄 Generated XML size: 2.1 MB
📝 Total lines of code: 15,847
🔢 Estimated tokens: 542,891
📊 File breakdown: 142 text, 14 binary, 0 errors
```

The generated XML file contains all your project's source code in a structured format that AI models can easily parse and understand, making it perfect for code reviews, architecture discussions, or getting AI assistance with your BMad-Method projects.

## Documentation & Resources

### Essential Guides

- 📖 **[User Guide](bmad-core/user-guide.md)** - Complete walkthrough from project inception to completion
- 🏗️ **[Core Architecture](docs/core-architecture.md)** - Technical deep dive and system design
- 🚀 **[Expansion Packs Guide](docs/expansion-packs.md)** - Extend BMad to any domain beyond software development

## Support

- 💬 [Discord Community](https://discord.gg/gk8jAdXWmj)
- 🐛 [Issue Tracker](https://github.com/bmadcode/bmad-method/issues)
- 💬 [Discussions](https://github.com/bmadcode/bmad-method/discussions)

## Contributing

**We're excited about contributions and welcome your ideas, improvements, and expansion packs!** 🎉

📋 **[Read CONTRIBUTING.md](CONTRIBUTING.md)** - Complete guide to contributing, including guidelines, process, and requirements

## License

MIT License - see [LICENSE](LICENSE) for details.

[![Contributors](https://contrib.rocks/image?repo=bmadcode/bmad-method)](https://github.com/bmadcode/bmad-method/graphs/contributors)

<sub>Built with ❤️ for the AI-assisted development community</sub>
