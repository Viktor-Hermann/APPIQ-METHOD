# /appiq - Universal APPIQ Method Launcher

**Quick Start**: `/appiq` - Intelligenter universeller Projekt-Launcher für alle Entwicklungsarten

## 🚀 Überblick

Der `/appiq` Command ist Ihr universeller Einstiegspunkt in die APPIQ Method. Egal ob Sie an Web-Anwendungen, Desktop-Apps, Mobile Apps oder Backend Services arbeiten - dieser Command führt Sie durch einen einfachen, geführten Prozess zur Auswahl des richtigen Workflows für Ihr Projekt.

## ✨ Unterstützte Projekttypen

- 🌐 **Web-Anwendungen** (React, Vue, Angular, Next.js, Full-Stack)
- 💻 **Desktop-Anwendungen** (Electron, Cross-Platform Desktop Apps)  
- 📱 **Mobile Apps** (Flutter, React Native, Cross-Platform Mobile)
- ⚙️ **Backend Services** (Node.js, Python, Java, API Development)
- 🔄 **Legacy/Brownfield** (Modernisierung bestehender Systeme)

## 🎯 Verwendung

```
/appiq
```

## 📋 Interaktiver Workflow-Auswahl-Prozess

### Schritt 1: Projekt-Status bestimmen
```
🚀 APPIQ Method Universal Launcher

Arbeiten wir an einem neuen oder bestehenden Projekt?

1. 🆕 Neues Projekt (Greenfield) - Wir bauen von Grund auf
2. 🔧 Bestehendes Projekt (Brownfield) - Wir erweitern/verbessern etwas

Antworte mit 1 oder 2:
```

### Schritt 2: Projekttyp identifizieren
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

### Schritt 3: Intelligente Projekt-Erkennung (Option 5)

**Für neue Projekte (Greenfield):**
```
🔍 Lass uns gemeinsam herausfinden, was das beste für dein Projekt ist...

Beschreibe kurz dein Projekt in 1-2 Sätzen:
(z.B. "Eine Ecommerce-Website mit Admin-Panel" oder "Eine Todo-App für Windows")

Basierend auf deiner Beschreibung erkenne ich automatisch den Projekttyp.
```

**Für bestehende Projekte (Brownfield):**
```
🔍 Analysiere dein bestehendes Projekt...

Ich schaue mir deine Projekt-Struktur an:
✓ Suche nach package.json, pubspec.yaml, requirements.txt
✓ Erkenne Framework-Dependencies (React, Flutter, Express, etc.)
✓ Analysiere Ordner-Struktur (android/, ios/, public/, src/)

Basierend darauf empfehle ich den optimalen Workflow.
```

## 🧠 Intelligente Workflow-Zuordnung

### Greenfield Projekte (Neu)
| Projekttyp | Workflow | Fokus-Bereich |
|------------|----------|---------------|
| 🌐 Web-App | `greenfield-fullstack.yaml` | Frontend + Backend Integration |
| 💻 Desktop | `greenfield-fullstack.yaml` | Electron-spezifische Patterns |
| 📱 Mobile | Mobile Platform Selection | Flutter/React Native Auswahl |
| ⚙️ Backend | `greenfield-service.yaml` | API Design & Datenarchitektur |

### Brownfield Projekte (Bestehend)
| Projekttyp | Workflow | Fokus-Bereich |
|------------|----------|---------------|
| 🌐 Web-App | `brownfield-fullstack.yaml` | Sichere Integration & Modernisierung |
| 💻 Desktop | `brownfield-fullstack.yaml` | Electron Upgrades & Features |
| 📱 Mobile | Platform-spezifische Workflows | Flutter/React Native Enhancement |
| ⚙️ Backend | `brownfield-service.yaml` | API Evolution & Skalierung |

## 🔍 Automatische Projekt-Erkennung

### File-basierte Erkennung (Brownfield)
```javascript
Erkennungslogik:
├── package.json + "electron" → Desktop (Electron)
├── package.json + "react-native" → Mobile (React Native)  
├── pubspec.yaml → Mobile (Flutter)
├── package.json + ("react"|"vue"|"angular"|"next") → Web
├── package.json + ("express"|"fastify"|"koa") → Backend (Node.js)
├── requirements.txt + Flask/Django patterns → Backend (Python)
├── pom.xml oder build.gradle → Backend (Java)
└── Fallback → Benutzer-geführte Auswahl
```

### Keyword-Erkennung (Greenfield)
```javascript
Keyword-Mapping:
Web: ["website", "web", "browser", "online", "webapp", "ecommerce", "portal"]
Desktop: ["desktop", "electron", "windows", "mac", "app", "gui", "standalone"]  
Mobile: ["mobile", "ios", "android", "app store", "phone", "tablet", "cross-platform"]
Backend: ["api", "server", "backend", "database", "service", "microservice", "rest"]
```

## 📱 Mobile-Spezifische Workflows (Legacy-Support)

Für Mobile-Projekte wird eine zusätzliche Platform-Auswahl gestartet:

### Greenfield Mobile
```
📱 Platform Selection für neue Mobile App:

Welche mobile Plattform möchtest du verwenden?

1. Flutter - Cross-platform mit Dart
2. React Native - Cross-platform mit React/JavaScript
3. Lass APPIQ Method basierend auf Requirements empfehlen

Antworte mit 1, 2, oder 3:
```

### Brownfield Mobile
```
📱 Bestehende Mobile App Platform Detection:

Erkannte Plattform: [Flutter/React Native]
Verfügbare Enhancement-Workflows:
- mobile-brownfield-flutter.yaml
- mobile-brownfield-react-native.yaml

Automatische Workflow-Auswahl basierend auf erkannter Plattform.
```

## 📝 Vollständige Beispiel-Interaktion

### Beispiel 1: Neue E-Commerce Website
```
User: /appiq

🚀 APPIQ Method Universal Launcher
Arbeiten wir an einem neuen oder bestehenden Projekt?
1. 🆕 Neues Projekt (Greenfield)
2. 🔧 Bestehendes Projekt (Brownfield)

User: 1

📋 Lass mich verstehen, was wir bauen...
Was für eine Art von Anwendung ist das?
1. 🌐 Web-Anwendung
2. 💻 Desktop-Anwendung  
3. 📱 Mobile App
4. ⚙️ Backend/API Service
5. 🤔 Bin mir nicht sicher - lass APPIQ entscheiden

User: 1

🎯 Web-Anwendung ausgewählt!

✅ Starte Greenfield Full-Stack Workflow für Web-Anwendungen...
📍 Fokus: Full-Stack Web-Anwendung mit Frontend und Backend Komponenten
📂 Erster Agent: analyst (erstellt Projekt-Brief)

Der Workflow führt Sie durch:
1. Projekt-Brief und Marktanalyse
2. PRD (Product Requirements Document) Erstellung
3. UX/UI Spezifikation für Web-Interface
4. Full-Stack Architektur (Frontend + Backend)
5. Story-basierte Entwicklung

@analyst - Bitte beginne mit der Erstellung eines Projekt-Briefs für die Web-Anwendung...
```

### Beispiel 2: Bestehende Electron Desktop App
```
User: /appiq

User: 2 (Bestehend)

🔍 Analysiere dein bestehendes Projekt...

Gefundene Indikatoren:
✓ package.json mit "electron": "^25.0.0"
✓ src/ Verzeichnis mit Electron-Main-Prozess
✓ renderer/ Verzeichnis erkannt

🎯 Erkannt: Desktop-Anwendung (Electron)

✅ Starte Brownfield Full-Stack Workflow für Desktop-Anwendungen...
📍 Fokus: Electron Desktop-Anwendung mit plattformspezifischen Optimierungen
📂 Erster Agent: analyst (analysiert bestehende Desktop-App Struktur)

Der Workflow führt Sie durch:
1. Analyse der bestehenden Electron-Architektur
2. Identifikation von Modernisierungs-Möglichkeiten
3. Sicherheits- und Performance-Verbesserungen
4. Feature-Enhancement Planung
5. Story-basierte Implementierung

@analyst - Bitte analysiere die bestehende Electron-Anwendung und identifiziere Verbesserungsmöglichkeiten...
```

## 🔄 Integration mit APPIQ Method Ecosystem

### Agent-Integration
Nach der Workflow-Auswahl werden die passenden Agents aktiviert:
- **analyst** - Projekt-Analyse und Brief-Erstellung
- **pm** - PRD und Requirements Management
- **architect** - System-Architektur Design  
- **ux-expert** - UI/UX Design (bei Web/Desktop/Mobile)
- **dev** - Code-Implementierung
- **qa** - Quality Assurance und Testing
- **sm** - Story Management und Workflow-Orchestration

### Expansion Pack Support
Der `/appiq` Command erkennt automatisch installierte Expansion Packs:
- **bmad-mobile-app-dev** - Mobile Development Specialists
- **bmad-2d-game-dev** - Game Development (Unity/Phaser)
- **bmad-infrastructure-devops** - Infrastructure & DevOps
- Weitere Expansion Packs werden automatisch erkannt

## ⚡ Performance & Effizienz

### Schnelle Auswahl für Experten
```
/appiq → 2 → 2 → ✅ Brownfield Desktop Workflow (3 Klicks)
```

### Intelligente Defaults
- Häufig verwendete Kombinationen werden erkannt
- Context aus vorherigen Sessions wird berücksichtigt
- Projekt-Patterns werden gelernt und vorgeschlagen

## 🆚 Command-Vergleich

| Command | Zweck | Zielgruppe |
|---------|-------|------------|
| `/appiq` | Universal Entry-Point | Alle Benutzer (Legacy-Name) |
| `/start` | Universal Entry-Point | Neue Benutzer (Preferred) |
| `*start` | bmad-orchestrator Direct | Power-User |
| Direct Workflows | Spezifische Workflows | Experten |

## 🔧 Backward Compatibility

Der `/appiq` Command behält vollständige Rückwärtskompatibilität zu Mobile-only Workflows:
- Alle bestehenden Mobile-Workflows funktionieren weiterhin
- Mobile-spezifische Documentation bleibt erhalten
- Expansion Pack `bmad-mobile-app-dev` wird vollständig unterstützt

## ✅ Vorteile der Universal-Version

1. **Ein Befehl für alles** - Web, Desktop, Mobile, Backend
2. **Intelligente Erkennung** - Automatische Projekt-Typ Detection
3. **Geführter Prozess** - Keine komplexen Workflow-Namen lernen
4. **Vollständige Abdeckung** - Alle APPIQ Method Capabilities
5. **Legacy-Support** - Bestehende Mobile Workflows bleiben verfügbar
6. **Erweiterbar** - Expansion Packs werden automatisch integriert

---

**💡 Tipp:** `/appiq` ist der bewährte, universelle Entry-Point für alle APPIQ Method Funktionen. Für völlig neue Benutzer wird `/start` empfohlen, aber beide Commands bieten identische Funktionalität.