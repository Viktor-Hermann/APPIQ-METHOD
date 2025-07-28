# /start - Universal APPIQ Method Launcher

**Ein Befehl für alle Projekttypen:** `/start` - Intelligente Projekt-Erkennung und Workflow-Führung

## 🚀 Überblick

Der `/start` Command ist der einfachste Weg, mit der APPIQ Method zu beginnen. Statt komplexe Workflow-Namen zu kennen, führt Sie dieser Command durch 2-3 einfache Fragen und startet automatisch den richtigen Workflow.

## ✨ Unterstützte Projekttypen

- 🌐 **Web-Anwendungen** (React, Vue, Angular, Next.js)
- 💻 **Desktop-Anwendungen** (Electron, Windows/Mac Apps)  
- 📱 **Mobile Apps** (Flutter, React Native)
- ⚙️ **Backend Services** (Node.js, Python, Java, API Services)

## 🎯 Verwendung

```
/start
```

## 📋 Interaktiver Ablauf

### Schritt 1: Projekt-Status
```
🚀 APPIQ Method Universal Launcher

Arbeiten wir an einem neuen oder bestehenden Projekt?

1. 🆕 Neues Projekt (Greenfield) - Wir bauen von Grund auf
2. 🔧 Bestehendes Projekt (Brownfield) - Wir erweitern/verbessern etwas

Antworte mit 1 oder 2:
```

### Schritt 2: Projekt-Typ
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

### Schritt 3: Smart Detection (bei Option 5)

**Für neue Projekte:**
```
🔍 Lass uns gemeinsam herausfinden, was das beste für dein Projekt ist...

Beschreibe kurz dein Projekt in 1-2 Sätzen:
(z.B. "Eine Ecommerce-Website mit Admin-Panel" oder "Eine Todo-App für Windows")
```

**Für bestehende Projekte:**
```
🔍 Analysiere dein bestehendes Projekt...

Ich schaue mir deine Projekt-Struktur an:
- package.json vorhanden? → Web/Desktop/Mobile
- pubspec.yaml? → Flutter
- requirements.txt? → Python Backend
- etc.

Basierend darauf empfehle ich den optimalen Workflow.
```

## 🔄 Automatische Workflow-Auswahl

Basierend auf Ihren Antworten wird automatisch der richtige Workflow gestartet:

### Greenfield (Neue Projekte)
- **Web-App** → `greenfield-fullstack.yaml` (mit Web-Fokus)
- **Desktop-App** → `greenfield-fullstack.yaml` (mit Electron-Fokus)
- **Mobile App** → Mobile Platform Selection → Flutter/React Native Workflow
- **Backend Service** → `greenfield-service.yaml`

### Brownfield (Bestehende Projekte)
- **Web-App** → `brownfield-fullstack.yaml` (mit Web-Fokus)
- **Desktop-App** → `brownfield-fullstack.yaml` (mit Electron-Fokus)
- **Mobile App** → Platform Detection → entsprechender Brownfield Workflow
- **Backend Service** → `brownfield-service.yaml`

## 🧠 Smart Detection Features

### Automatische Projekt-Erkennung
- **Electron Apps**: `package.json` mit `electron` dependency
- **Web Apps**: `package.json` mit `react`, `vue`, `angular`, `next`
- **Flutter Apps**: `pubspec.yaml` vorhanden
- **React Native**: `package.json` mit `react-native` dependencies
- **Backend Services**: `package.json` mit `express`, `fastify` oder Python/Java Patterns

### Keyword-Erkennung für neue Projekte
- **Web**: "website", "web", "browser", "online", "webapp", "ecommerce"
- **Desktop**: "desktop", "electron", "windows", "mac", "app", "gui"
- **Mobile**: "mobile", "ios", "android", "app store", "phone", "tablet"
- **Backend**: "api", "server", "backend", "database", "service", "microservice"

## 📝 Beispiel-Interaktionen

### Beispiel 1: Bestehende Electron App
```
User: /start

🚀 APPIQ Method Universal Launcher

Arbeiten wir an einem neuen oder bestehenden Projekt?
1. 🆕 Neues Projekt (Greenfield)
2. 🔧 Bestehendes Projekt (Brownfield)

User: 2

📋 Lass mich verstehen, was wir bauen...
Was für eine Art von Anwendung ist das?
1. 🌐 Web-Anwendung
2. 💻 Desktop-Anwendung
3. 📱 Mobile App
4. ⚙️ Backend/API Service
5. 🤔 Bin mir nicht sicher - lass APPIQ entscheiden

User: 2

🎯 Perfect! Desktop-Anwendung Enhancement erkannt.

✅ Starte Brownfield Full-Stack Workflow für Desktop-Anwendungen...
📍 Fokus: Electron Desktop-Anwendung mit plattformspezifischen Optimierungen
📂 Erster Agent: analyst (analysiert bestehende App-Struktur)

Der Workflow führt Sie durch:
1. Analyse der bestehenden Desktop-App
2. Identifikation von Verbesserungsmöglichkeiten
3. Architektur-Planung für Electron-spezifische Features
4. Story-Erstellung und Implementierung

@analyst - Bitte analysiere die bestehende Electron-Anwendung...
```

### Beispiel 2: Neue Web-App mit Auto-Detection
```
User: /start

User: 1 (Neues Projekt)

User: 5 (Nicht sicher)

🔍 Lass uns gemeinsam herausfinden, was das beste für dein Projekt ist...

Beschreibe kurz dein Projekt in 1-2 Sätzen:

User: "Eine E-Commerce Website mit Admin Dashboard und Benutzer-Registrierung"

🎯 Erkannt: Web-Anwendung (Keywords: "Website", "Dashboard", "Benutzer-Registrierung")

✅ Starte Greenfield Full-Stack Workflow für Web-Anwendungen...
📍 Fokus: Full-Stack Web-Anwendung mit Frontend und Backend Komponenten

@analyst - Bitte erstelle einen Projekt-Brief für die E-Commerce Website...
```

## 🔧 Technische Implementation

Der `/start` Command integriert mit dem bmad-orchestrator `*start` Command und verwendet dieselbe Logic:

```yaml
workflow-mapping:
  new_project:
    web_app: "greenfield-fullstack.yaml"
    desktop_app: "greenfield-fullstack.yaml" # with Electron context
    mobile_app: "mobile-platform-selection"
    backend_service: "greenfield-service.yaml"
  existing_project:
    web_app: "brownfield-fullstack.yaml"
    desktop_app: "brownfield-fullstack.yaml" # with Electron context
    mobile_app: "mobile-platform-detection"
    backend_service: "brownfield-service.yaml"
```

## ✅ Vorteile

1. **Ein einziger Befehl** - keine Verwirrung über verschiedene Workflows
2. **Intelligente Führung** - System entscheidet mit Ihnen zusammen
3. **Automatische Erkennung** - weniger denken, mehr machen
4. **Fehlerverzeihend** - "Nicht sicher" Option für unklare Fälle
5. **Vollständige Abdeckung** - alle Projekttypen unterstützt
6. **Gleiche Power** - Zugang zu allen bestehenden Workflows

## 🆚 Unterschied zu anderen Commands

- **`/start`** - Universeller Entry-Point für alle Projekttypen (EMPFOHLEN)
- **`/appiq`** - Ebenfalls universell, aber behält den ursprünglichen Namen
- **`*start`** - bmad-orchestrator Command (für Experten)
- **Direct Workflows** - Für Benutzer die genau wissen welchen Workflow sie brauchen

## 🔄 Integration mit bestehenden Workflows

Der `/start` Command ersetzt nicht die bestehenden Workflows, sondern:
- **Abstraktionsschicht** - vereinfacht den Zugang
- **Intelligenter Router** - leitet zu richtigen Workflows weiter  
- **Context Provider** - gibt spezifische Hinweise und Fokus-Bereiche mit

Alle bestehenden Workflows (`greenfield-fullstack.yaml`, etc.) bleiben unverändert und können weiterhin direkt verwendet werden.

---

**💡 Tipp:** Für Anfänger ist `/start` der perfekte Einstieg. Experten können weiterhin direkte Workflow-Namen oder bmad-orchestrator Commands verwenden.