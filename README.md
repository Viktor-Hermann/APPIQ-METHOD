# 📱 APPIQ SOLUTION: Flutter Mobile Development Extension

[![Version](https://img.shields.io/npm/v/appiq-solution?color=blue&label=version)](https://www.npmjs.com/package/appiq-solution)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Node.js Version](https://img.shields.io/badge/node-%3E%3D20.0.0-brightgreen)](https://nodejs.org)

**Eine spezialisierte Erweiterung der BMAD Method für Flutter Mobile App Entwicklung**

APPIQ SOLUTION erweitert die bewährte BMAD Method um **erstklassige Flutter-Unterstützung** mit Clean Architecture, Cubit patterns, BLoC state management, dependency injection und modernen Mobile Development Best Practices.

## 🚀 Installation

**Einfach und schnell:**

```bash
npx appiq-solution install
```

**Der Smart Installer konfiguriert:**
- ✅ **Multi-IDE Support**: Cursor, Claude Code, Windsurf, VS Code + Cline, und mehr
- ✅ **Auto-detect Tech Stack**: Flutter, React, Vue, Next.js, Angular, Fullstack, API-only
- ✅ **Smart MCP Integration**: Agents wissen welche MCP Server sie nutzen können (keine Auto-Config)
- ✅ **Planning Workflow**: Projektidee → Plan-Generierung → Freigabe → Entwicklung
- ✅ **Full BMAD Flow**: Document sharding, Agent orchestration, Entwicklungszyklus
- ✅ **🎯 Advanced Flutter Support**: Dart MCP Server integration, Clean Architecture, Cubit patterns, BLoC state management, dependency injection mit GetIt, proper testing strategies
- ✅ **Modern Web**: shadcn/ui, v0.dev, Tailwind CSS integration
- ✅ **Security First**: Keine API Keys werden gespeichert oder automatisch konfiguriert

### 🎯 **Verfügbare MCP Server**

Deine Agents kennen diese MCP Server (du konfigurierst sie manuell in deiner IDE):

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

**In deiner IDE (Cursor, Claude, etc.):**
```
@smart-launcher
```

## 📱 Flutter Features

- **🏗️ Clean Architecture**: Domain-driven Design, saubere Layer-Trennung
- **🔄 State Management**: Cubit patterns, BLoC integration
- **🛠️ Best Practices**: GetIt dependency injection, null safety
- **🎨 Material 3**: Moderne UI components, theming
- **🧪 Testing**: Unit-, Widget- und Integration-Tests
- **📦 Package Management**: Kuratierte Package-Empfehlungen

## 🗂️ Codebase Context Management

**Automatischer Context Export nach jedem Feature/Milestone:**

```bash
# Manuell ausführen
npx bmad-method flatten

# Mit custom Output (für AI-Agents)
npx bmad-method flatten --output context/current-codebase.xml

# Automatisch in package.json scripts:
{
  "scripts": {
    "flatten": "npx bmad-method flatten --output context/milestone-$(date +%Y%m%d).xml",
    "posttest": "npm run flatten",
    "postbuild": "npm run flatten"
  }
}
```

**Wo wird es gespeichert:**
- **Standard**: `flattened-codebase.xml` im aktuellen Verzeichnis
- **Custom**: Beliebiger Pfad mit `--output` Parameter
- **Empfehlung**: `context/` Ordner für bessere Organisation

**Nutzen für Flutter-Entwicklung:**
- ✅ AI Agents haben immer aktuellen Codebase-Context
- ✅ Perfekt für Code Reviews und Architektur-Diskussionen
- ✅ Einfacher Knowledge Transfer zwischen Team-Mitgliedern

## 📚 Dokumentation

- 📖 **[User Guide](bmad-core/user-guide.md)** - Komplette Anleitung zur Flutter-Entwicklung mit AI Agents
- 📱 **[Flutter Expansion Pack](expansion-packs/bmad-flutter-mobile-dev/)** - Spezialisierte Flutter Agents und Templates

## Support

- 💬 [Discord Community](https://discord.gg/gk8jAdXWmj)
- 🐛 [Issue Tracker](https://github.com/bmadcode/bmad-method/issues)
- 💬 [Discussions](https://github.com/bmadcode/bmad-method/discussions)
- 💖 [![Support the Project via PayPal](https://becomingdeutsch.wordpress.com/wp-content/uploads/2019/08/buy-me-a-coffee-with-paypal.png)](https://www.paypal.com/paypalme/vhermann)

## License

MIT License - see [LICENSE](LICENSE) for details.

<sub>Built with ❤️ for Flutter developers and the AI-assisted development community</sub>
