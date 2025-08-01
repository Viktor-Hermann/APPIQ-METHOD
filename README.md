# 📱 APPIQ SOLUTION: Flutter Mobile Development Extension

[![Version](https://img.shields.io/npm/v/appiq-solution?color=blue&label=version)](https://www.npmjs.com/package/appiq-solution)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Node.js Version](https://img.shields.io/badge/node-%3E%3D20.0.0-brightgreen)](https://nodejs.org)

**A specialized extension of the BMAD Method for Flutter Mobile App Development**

APPIQ SOLUTION extends the proven BMAD Method with first-class Flutter support featuring Clean Architecture, Cubit patterns, BLoC state management, dependency injection, and modern Mobile Development Best Practices.

## 🚀 Quick Start

**Simple and fast:**

```bash
npx appiq-solution
```

The Smart Installer configures:

✅ **Multi-IDE Support**: Cursor, Claude Code, Windsurf, VS Code + Cline, and more  
✅ **Auto-detect Tech Stack**: Flutter, React, Vue, Next.js, Angular, Fullstack, API-only  
✅ **Smart MCP Integration**: Agents know which MCP servers they can use (no auto-config)  
✅ **Planning Workflow**: Project idea → Plan generation → Approval → Development  
✅ **Full BMAD Flow**: Document sharding, Agent orchestration, Development cycle  
✅ **🎯 Advanced Flutter Support**: Dart MCP Server integration, Clean Architecture, Cubit patterns, BLoC state management, dependency injection with GetIt, proper testing strategies  
✅ **Modern Web**: shadcn/ui, v0.dev, Tailwind CSS integration  
✅ **Security First**: No API Keys stored or auto-configured

## What is BMAD Method?

APPIQ SOLUTION is built on the **BMAD Method** - a proven AI-driven development framework that uses specialized AI agents to handle the complete software development lifecycle.

**BMAD Method's Two Key Innovations:**

**1. Agentic Planning:** Dedicated agents (Analyst, PM, Architect) collaborate with you to create detailed, consistent PRDs and Architecture documents. Through advanced prompt engineering and human-in-the-loop refinement, these planning agents produce comprehensive specifications that go far beyond generic AI task generation.

**2. Context-Engineered Development:** The Scrum Master agent then transforms these detailed plans into hyper-detailed development stories that contain everything the Dev agent needs - full context, implementation details, and architectural guidance embedded directly in story files.

This two-phase approach eliminates both **planning inconsistency** and **context loss** - the biggest problems in AI-assisted development.

## 🎯 Available MCP Servers

Your agents know these MCP servers (you configure them manually in your IDE):

🧠 **Sequential Thinking**: Complex problem solving  
🌐 **Puppeteer**: Browser automation and testing  
🔗 **Claude Continuity**: Enhanced thread continuity  
💾 **Extended Memory**: Enhanced AI memory capabilities  
✨ **21st.dev Magic**: UI builder like v0 in your IDE  
📱 **Dart MCP**: Flutter/Dart development (auto-detected for Flutter projects)  
🔥 **Firebase**: Auth, Firestore, Functions integration  
⚡ **Supabase**: Database, auth, storage  
📚 **Context7**: Up-to-date library documentation  
💳 **Stripe**: Payment integration

## 📱 Flutter Features

🏗️ **Clean Architecture**: Domain-driven Design, clean layer separation  
🔄 **State Management**: Cubit patterns, BLoC integration  
🛠️ **Best Practices**: GetIt dependency injection, null safety  
🎨 **Material 3**: Modern UI components, theming  
🧪 **Testing**: Unit, Widget, and Integration tests  
📦 **Package Management**: Curated package recommendations

## 🎯 Step-by-Step Guide for Your Brownfield Flutter Project

### 1. Install BMAD Method in Your Existing Project

```bash
npx appiq-solution
```

**Important selections during installation:**
- Choose the `appiq-flutter-mobile-dev` Expansion Pack
- Provide the path to your existing Architecture MD file
- The system will install Flutter agents in `.bmad-core/`

### 2. Analyze Existing Architecture

Since you already have documented architecture, this is the perfect starting point:

```bash
@architect
```

**What happens here:**
- The Architect agent reads your architecture document
- Analyzes your existing code
- Creates a "Brownfield Analysis" with recommendations
- Defines how new features fit into your existing structure

### 3. Plan Livestream Feature

Now the Scrum Master comes into play:

```bash
@sm
```

**The SM will ask you:**
- Which specific livestream functions are needed
- Which UI components are required
- How the feature integrates into existing navigation
- Which backend endpoints are needed

### 4. Automatic Flutter Workflow Starts

Once the story is defined, the `flutter-ui-first-development` workflow automatically starts:

**Phase 1: UI Design (Maya - flutter-ui-agent)**
```
"How should the livestream UI look?"
"Which widgets do we need (Player, Chat, Controls)?"
"Where in existing navigation will it be integrated?"
```

Maya creates:
- Livestream pages (`livestream_page.dart`, `livestream_detail_page.dart`)
- Custom widgets (`livestream_player_widget.dart`, `chat_widget.dart`)
- Localization keys for all texts
- Integration into your existing navigation

**Phase 2: State Management (Alex - flutter-cubit-agent)**

Alex implements:
- `LivestreamCubit` with States (initial, loading, streaming, error)
- `LivestreamState` class with all required data
- Error handling for connection drops
- Integration with your existing state patterns

**Phase 3: Business Logic (Jordan - flutter-domain-agent)**

Jordan creates:
- `LivestreamEntity` (Stream-ID, URL, Viewer-Count, etc.)
- `StartLivestreamUseCase`, `StopLivestreamUseCase`
- `LivestreamRepository` Interface
- Business validation (e.g., permission checks)

**Phase 4: Data Layer (Sam - flutter-data-agent)**

Sam implements:
- `LivestreamRepositoryImpl`
- `LivestreamRemoteDataSource` (API calls)
- `LivestreamLocalDataSource` (caching)
- `LivestreamModel` with JSON serialization
- WebSocket integration for real-time chat

### 5. Backend Integration

Since you also need backend functions:
```bash
@backend-dev
```

### 6. Automatic Quality Control

After each phase runs automatically:
- Code review against your existing patterns
- Consistency check with documented architecture
- Testing (Unit, Widget, Integration tests)
- Security validation

## 🔄 Your Concrete Workflow

**One-time setup:**
```bash
npx appiq-solution  # Choose appiq-flutter-mobile-dev
@architect          # Analyze existing architecture
```

**For each new feature:**
```bash
@sm  # "Create story for [Feature-Name]"
```
- System runs automatically through all agents
- You provide input/feedback at respective handoff points
- At the end you have a fully implemented feature

**In your IDE (Cursor, Claude, etc.):**
```
@smart-launcher
```

## 🗂️ Codebase Context Management

Automatic context export after every feature/milestone:

```bash
# Manual execution
npx bmad-method flatten

# With custom output (for AI agents)
npx bmad-method flatten --output context/current-codebase.xml

# Automatically in package.json scripts:
{
  "scripts": {
    "flatten": "npx bmad-method flatten --output context/milestone-$(date +%Y%m%d).xml",
    "posttest": "npm run flatten",
    "postbuild": "npm run flatten"
  }
}
```

**Where it's saved:**
- **Standard**: `flattened-codebase.xml` in current directory
- **Custom**: Any path with `--output` parameter
- **Recommendation**: `context/` folder for better organization

**Benefits for Flutter development:**
✅ AI agents always have current codebase context  
✅ Perfect for code reviews and architecture discussions  
✅ Easy knowledge transfer between team members

## 📚 Documentation

📖 **[User Guide](bmad-core/user-guide.md)** - Complete guide to Flutter development with AI agents  
📱 **[Flutter Expansion Pack](expansion-packs/appiq-flutter-mobile-dev/)** - Specialized Flutter agents and templates  
🏗️ **[BMAD Core Architecture](docs/core-architecture.md)** - Technical deep dive into the framework

## Support

💬 [Discord Community](https://discord.gg/gk8jAdXWmj)  
🐛 [Issue Tracker](https://github.com/your-repo/appiq-solution/issues)  
💬 [Discussions](https://github.com/your-repo/appiq-solution/discussions)  
💖 [Support the Project via PayPal](https://paypal.me/yourusername)

## License

MIT © Viktor Hermann
