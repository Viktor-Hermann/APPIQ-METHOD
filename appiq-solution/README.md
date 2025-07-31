# 🚀 Appiq Solution - Super Einfache KI-Agent Installation

*Built with ❤️ based on the amazing Bmad-Method*

## ⚡ One-Command Installation

```bash
npx appiq-solution install
```

**Das war's!** 🎯 Kein komplizierter Setup mehr.

## 🎮 Was passiert automatisch?

### 1. **🔍 Intelligente Projekt-Erkennung**
- ✅ **Automatisch erkennt:** Greenfield vs. Brownfield
- ✅ **Analysiert:** Bestehenden Code, Dokumentation, Tech-Stack
- ✅ **Empfiehlt:** Optimalen Workflow für Ihr Projekt

### 2. **🛠️ IDE-Integration (One-Click)**
- ✅ **Cursor** → `.cursor/rules/` mit `.mdc` Dateien
- ✅ **Claude Code** → `.claude/commands/Appiq/` mit `.md` Dateien
- ✅ **Windsurf** → `.windsurf/rules/` mit `.md` Dateien
- ✅ **VS Code + Cline** → `.clinerules/` mit `.md` Dateien

### 3. **📁 Automatische Datei-Organisation**

**Neue Projekte (Greenfield):**
```
your-project/
├── docs/
│   ├── prd.md              ← PRD wird hier erstellt
│   ├── architecture.md     ← Architektur wird hier erstellt
│   └── stories/            ← User Stories werden hier erstellt
├── appiq-solution/
│   ├── agents/             ← Optimierte KI-Agents
│   └── commands/           ← One-Click Kommandos
└── .cursor/rules/          ← IDE-spezifische Integration
```

**Bestehende Projekte (Brownfield):**
```
your-existing-project/
├── docs/                   ← Bestehende Docs werden gescannt
│   ├── prd.md             ← PRD falls vorhanden, sonst erstellt
│   └── architecture.md     ← Architektur-Review
├── appiq-solution/         ← Neue Appiq Solution Installation
└── .cursor/rules/          ← IDE Integration (nicht-invasiv)
```

## 🚀 Super Einfache Nutzung

### Schritt 1: Installation
```bash
npx appiq-solution install
```

### Schritt 2: Agent laden (Cursor Beispiel)
```bash
# Appiq Launcher ist bereits in .cursor/rules/smart-launcher.mdc
# Einfach in Cursor sagen: "Agiere als Appiq Launcher"
```

### Schritt 3: One-Command Start
```bash
# Für NEUE Projekte:
/start

# Für BESTEHENDE Projekte:
/analyze
```

**Das war's!** 🎉 Das System führt Sie automatisch durch alles.

## 🎯 One-Click Workflows

### Greenfield (Neue Projekte)
```
/start → PRD → Architektur → Stories → Code → Tests
```

### Brownfield (Bestehende Projekte)  
```
/analyze → Review → Neue Features → Integration → Tests
```

## 🤖 Optimierte Agents

| Agent | Kommando | Funktion |
|-------|----------|----------|
| **Appiq Launcher** | `/start` | Intelligenter Projekt-Start |
| **Project Manager** | `/prd` | PRD & Dokumentation |
| **System Architect** | `/architecture` | Technische Architektur |
| **Story Master** | `/story` | User Stories & Sprints |
| **Senior Developer** | `/code` | Code Implementation |
| **QA Expert** | `/test` | Testing & Validierung |

## 💡 Warum Appiq Solution?

### ❌ **Vorher (Kompliziert):**
- ✗ Komplexer Web-Client Setup
- ✗ Unklare Anweisungen
- ✗ Viele manuelle Schritte
- ✗ Verwirrende Datei-Organisation

### ✅ **Jetzt (Super Einfach):**
- ✅ **Ein Kommando:** `npx appiq-solution install`
- ✅ **Automatische Erkennung:** Greenfield/Brownfield
- ✅ **Klare Anweisungen:** Wo gehört was hin
- ✅ **One-Click Workflows:** Alles automatisiert

## 🆘 Hilfe & Support

### Quick Commands
- **`/help`** - Alle verfügbaren Kommandos
- **`/status`** - Aktueller Projekt-Status
- **`/next`** - Nächster Schritt

### Troubleshooting
```bash
# Installation prüfen
ls appiq-solution/

# Agent-Liste anzeigen  
ls appiq-solution/agents/

# IDE-Integration prüfen
ls .cursor/rules/     # für Cursor
ls .claude/commands/  # für Claude Code
```

## 🎮 Beispiel-Session

```bash
# Installation
$ npx appiq-solution install
🔍 Projekt-Analyse... → Brownfield erkannt
🛠️ IDE: Cursor ausgewählt  
✅ Installation abgeschlossen!

# In Cursor IDE
> "Agiere als Appiq Launcher"
> /analyze

🔍 Analyzing existing project...
✅ Found: package.json (Node.js project)
✅ Found: src/ directory with React components
✅ Missing: PRD documentation
📋 Recommendation: Create PRD first, then add new features

> /prd

📝 Creating PRD for existing React project...
✅ PRD created: docs/prd.md
🎯 Next: /architecture to review technical setup
```

**So einfach ist das!** 🚀

---
*Appiq Solution - Entwicklung war nie einfacher.*
*Built with ❤️ based on Bmad-Method*