# Claude IDE Integration - Universal APPIQ Method

## Implementation für Claude Code

Die APPIQ Method Commands in Claude Code unterstützen alle Projekttypen: Web, Desktop, Mobile und Backend Development mit intelligenter Projekt-Erkennung.

## Verfügbare Commands

### `/start` - Universal Project Launcher (EMPFOHLEN)
```yaml
command: /start
description: Universal APPIQ Method Launcher mit intelligenter Projekt-Erkennung
category: Development
supported_projects: [web, desktop, mobile, backend]
```

**Verwendung:**
```
/start
```

**Features:**
- 🌐 Web-Anwendungen (React, Vue, Angular, Next.js)
- 💻 Desktop-Apps (Electron, Cross-Platform)
- 📱 Mobile Apps (Flutter, React Native)
- ⚙️ Backend Services (Node.js, Python, Java)
- 🧠 Automatische Projekt-Erkennung
- 📋 Geführte Workflow-Auswahl

### `/appiq` - Universal Project Launcher (Legacy-Support)
```yaml
command: /appiq
description: Universeller APPIQ Method Launcher (erweitert von Mobile-only)
category: Development
supported_projects: [web, desktop, mobile, backend]
legacy_support: true
```

**Verwendung:**
```
/appiq
```

**Features:**
- Identische Funktionalität wie `/start`
- Vollständige Rückwärtskompatibilität
- Unterstützt alle bestehenden Mobile Workflows
- Expansion Pack Integration

## Interaktiver Workflow

### Schritt 1: Projekt-Status
```
🚀 APPIQ Method Universal Launcher

Arbeiten wir an einem neuen oder bestehenden Projekt?

1. 🆕 Neues Projekt (Greenfield) - Wir bauen von Grund auf
2. 🔧 Bestehendes Projekt (Brownfield) - Wir erweitern/verbessern etwas

Antworte mit 1 oder 2:
```

### Schritt 2: Projekt-Typ Erkennung
```
📋 Lass mich verstehen, was wir bauen...

Was für eine Art von Anwendung ist das?

1. 🌐 Web-Anwendung (läuft im Browser)
2. 💻 Desktop-Anwendung (Electron, Windows/Mac App)
3. 📱 Mobile App (iOS/Android)
4. ⚙️ Backend/API Service (Server, Database)
5. 🤔 Bin mir nicht sicher - lass APPIQ entscheiden

Antworte mit 1, 2, 3, 4 oder 5:
```

### Schritt 3: Smart Detection (Option 5)
Automatische Analyse des Projekts basierend auf:
- File-Struktur (package.json, pubspec.yaml, etc.)
- Dependencies (React, Flutter, Express, etc.)
- Projekt-Beschreibung (bei neuen Projekten)

## Workflow-Zuordnung

### Greenfield (Neue Projekte)
| Input | Workflow | Agent-Sequenz |
|-------|----------|---------------|
| Web-Anwendung | `greenfield-fullstack.yaml` | analyst → pm → ux-expert → architect → dev |
| Desktop-App | `greenfield-fullstack.yaml` + Electron Context | analyst → pm → ux-expert → architect → dev |
| Mobile App | Mobile Platform Selection → Flutter/RN Workflow | mobile-analyst → mobile-pm → mobile-architect → mobile-dev |
| Backend Service | `greenfield-service.yaml` | analyst → pm → architect → dev |

### Brownfield (Bestehende Projekte)
| Input | Workflow | Agent-Sequenz |
|-------|----------|---------------|
| Web-Anwendung | `brownfield-fullstack.yaml` | analyst → architect → pm → dev |
| Desktop-App | `brownfield-fullstack.yaml` + Electron Context | analyst → architect → pm → dev |
| Mobile App | Platform Detection → Brownfield Mobile Workflow | mobile-analyst → mobile-architect → mobile-dev |
| Backend Service | `brownfield-service.yaml` | analyst → architect → pm → dev |

## Automatische Projekt-Erkennung

### File-basierte Erkennung (Brownfield)
Claude Code analysiert automatisch:

```javascript
// Erkennungslogik
if (hasFile("pubspec.yaml")) return "mobile-flutter";
if (hasPackageDep("react-native")) return "mobile-react-native";
if (hasPackageDep("electron")) return "desktop-electron";
if (hasPackageDep(["react", "vue", "angular", "next"])) return "web-frontend";
if (hasPackageDep(["express", "fastify", "koa"])) return "backend-nodejs";
if (hasFile("requirements.txt") && hasPattern("flask|django|fastapi")) return "backend-python";
if (hasFile(["pom.xml", "build.gradle"])) return "backend-java";
```

### Keyword-basierte Erkennung (Greenfield)
Bei Projekt-Beschreibungen werden Keywords erkannt:

```javascript
const keywordMapping = {
  web: ["website", "web", "browser", "online", "webapp", "ecommerce", "portal"],
  desktop: ["desktop", "electron", "windows", "mac", "app", "gui", "standalone"],
  mobile: ["mobile", "ios", "android", "app store", "phone", "tablet"],
  backend: ["api", "server", "backend", "database", "service", "microservice"]
};
```

## Context-spezifische Anpassungen

### Desktop/Electron Context
```yaml
context_messages:
  desktop: |
    Fokus auf Electron Desktop-Anwendung:
    - Plattformspezifische Optimierungen (Windows/Mac/Linux)
    - Native APIs und System-Integration
    - Performance-Optimierung für Desktop
    - Auto-Update und Packaging-Strategien
```

### Web Application Context
```yaml
context_messages:
  web: |
    Fokus auf Full-Stack Web-Anwendung:
    - Frontend Framework Integration (React/Vue/Angular)
    - Backend API Design und Implementation
    - Responsive Design und Mobile-First
    - SEO und Performance-Optimierung
```

### Mobile Application Context
```yaml
context_messages:
  mobile: |
    Fokus auf Cross-Platform Mobile Development:
    - Platform-spezifische UI/UX Guidelines
    - App Store Optimization und Deployment
    - Device-spezifische Features (Kamera, GPS, etc.)
    - Performance auf verschiedenen Geräten
```

### Backend Service Context
```yaml
context_messages:
  backend: |
    Fokus auf API und Backend Development:
    - RESTful API Design und Documentation
    - Database Design und Optimization
    - Scalability und Performance
    - Security Best Practices
```

## Expansion Pack Integration

### Automatische Erkennung
Claude Code erkennt automatisch installierte Expansion Packs:

```yaml
expansion_packs:
  bmad-mobile-app-dev:
    agents: [mobile-pm, mobile-architect, mobile-developer, mobile-qa]
    workflows: [mobile-greenfield-flutter, mobile-brownfield-react-native]
    
  bmad-2d-game-dev:
    agents: [game-designer, game-developer, game-architect]
    workflows: [game-dev-greenfield, game-prototype]
    
  bmad-infrastructure-devops:
    agents: [infra-devops-platform]
    workflows: [infrastructure-deployment]
```

### Expansion Pack Commands
Zusätzliche Commands werden bei verfügbaren Expansion Packs aktiviert:

```yaml
conditional_commands:
  - if: expansion_pack_installed("bmad-mobile-app-dev")
    command: /mobile
    description: Direct Mobile Development Launcher
    
  - if: expansion_pack_installed("bmad-2d-game-dev")
    command: /game
    description: Game Development Workflow Launcher
```

## Error Handling & Fallbacks

### Unbekannte Projekttypen
```yaml
fallback_behavior:
  unknown_project: |
    🤔 Projekttyp nicht automatisch erkennbar.
    
    Lass uns das gemeinsam herausfinden:
    1. Beschreibe kurz dein Projekt
    2. Ich führe dich durch gezielte Fragen
    3. Wir finden den passenden Workflow
```

### Missing Dependencies
```yaml
missing_dependencies:
  message: |
    ⚠️ Benötigte APPIQ Method Komponenten nicht gefunden.
    
    Installiere die APPIQ Method mit:
    curl -fsSL https://github.com/Viktor-Hermann/APPIQ-METHOD/releases/latest/download/appiq_installer.sh | bash
```

## Best Practices für Claude Code

### Performance Optimierungen
```yaml
performance:
  lazy_loading: true  # Lade Workflows nur bei Bedarf
  cache_detection: true  # Cache Projekt-Erkennung
  batch_operations: true  # Batch File-System-Operationen
```

### User Experience
```yaml
ux_enhancements:
  progress_indicators: true  # Zeige Fortschritt bei langen Operationen
  clear_error_messages: true  # Verständliche Fehlermeldungen
  context_preservation: true  # Behalte Kontext zwischen Schritten
```

### Integration mit Claude Features
```yaml
claude_integration:
  file_analysis: true  # Nutze Claude's File-Analysis
  code_understanding: true  # Leverag Code-Verständnis
  natural_language: true  # Nutze NLP für Projekt-Beschreibungen
```

## Command Examples

### Schneller Start für Experten
```
/start → 2 → 2 → Desktop Brownfield Workflow
/appiq → 1 → 1 → Web Greenfield Workflow
```

### Mit Auto-Detection
```
/start → 2 → 5 → [Auto-Erkennung] → Passender Workflow
```

### Direkte Mobile Development (mit Expansion Pack)
```
/mobile → Flutter/React Native Selection → Mobile Workflow
```

## Testing & Validation

### Test-Szenarien
```yaml
test_scenarios:
  - new_react_web_app
  - existing_electron_desktop
  - flutter_mobile_project
  - nodejs_backend_api
  - unknown_project_type
  - missing_appiq_installation
```

---

**💡 Tipp für Claude Code Users:** Verwende `/start` für den einfachsten Einstieg oder `/appiq` falls du bereits mit der APPIQ Method vertraut bist. Beide Commands bieten identische, universelle Funktionalität für alle Projekttypen.