# /start Command - Implementierungslogik

## Decision Tree für automatische Workflow-Auswahl

### Schritt 1: Projekt-Status → Variable: `project_status`
- `1` → `new` (Greenfield)
- `2` → `existing` (Brownfield)

### Schritt 2: Projekt-Typ → Variable: `project_type`
- `1` → `web`
- `2` → `desktop` 
- `3` → `mobile`
- `4` → `backend`
- `5` → `auto_detect`

### Schritt 3: Workflow-Mapping

```javascript
const workflowMapping = {
  // Greenfield (Neue Projekte)
  'new_web': 'greenfield-fullstack.yaml',
  'new_desktop': 'greenfield-fullstack.yaml', // mit Electron-Context
  'new_mobile': 'mobile-platform-selection', // → Flutter/React Native
  'new_backend': 'greenfield-service.yaml',
  
  // Brownfield (Bestehende Projekte)  
  'existing_web': 'brownfield-fullstack.yaml',
  'existing_desktop': 'brownfield-fullstack.yaml', // mit Electron-Context
  'existing_mobile': 'mobile-platform-detection', // → Platform → entsprechender Brownfield
  'existing_backend': 'brownfield-service.yaml'
}
```

### Schritt 4: Auto-Detection Logic

#### Für neue Projekte (`auto_detect` + `new`):
```
Frage: "Beschreibe dein Projekt in 1-2 Sätzen:"

Keyword-Detection:
- "website", "web", "browser", "online" → web
- "desktop", "electron", "windows", "mac", "app" → desktop  
- "mobile", "ios", "android", "app store" → mobile
- "api", "server", "backend", "database", "service" → backend

Fallback: Weitere Fragen stellen
```

#### Für bestehende Projekte (`auto_detect` + `existing`):
```
File-System-Analysis:
1. package.json checken:
   - "electron" dependency → desktop
   - "react-native" / "@react-native" → mobile (React Native)
   - "next", "react", "vue", "angular" → web
   - "express", "fastify", "koa" → backend

2. pubspec.yaml vorhanden → mobile (Flutter)

3. requirements.txt + app.py/main.py → backend (Python)

4. Gemfile + Rails patterns → backend (Ruby)

5. pom.xml / build.gradle → backend (Java)

Fallback: User-Eingabe anfordern
```

## Implementierung als bmad-orchestrator Extension

```yaml
# Ergänzung zu bmad-orchestrator.md
commands:
  start: Universal project launcher with smart detection
  
start-behavior:
  - Present project status question (new/existing)
  - Present project type question (web/desktop/mobile/backend/auto)
  - If auto_detect: run detection logic
  - Map to appropriate workflow
  - Launch workflow with context

context-passing:
  desktop-context: "Focus on Electron desktop application patterns"
  mobile-context: "Determine platform (Flutter/React Native) first"
  backend-context: "Focus on API design and data architecture"
  web-context: "Consider both frontend and backend components"
```

## User Experience Flow

### Erfolgreicher Standard-Flow:
```
/start → Status-Frage → Typ-Frage → Workflow-Start (3 Schritte)
```

### Mit Auto-Detection:
```
/start → Status-Frage → "Auto" → Detection → Workflow-Start (3+ Schritte)
```

### Error Handling:
- Ungültige Eingabe → Wiederholung der Frage
- Detection fehlgeschlagen → Manual fallback
- Workflow nicht gefunden → Standardworkflow mit Hinweis

## Integration mit bestehenden Workflows

Der `/start` Command ersetzt nicht die bestehenden Workflows, sondern:
1. **Abstraktionsschicht** - vereinfacht den Zugang
2. **Intelligenter Router** - leitet zu richtigen Workflows
3. **Context Provider** - gibt spezifische Hinweise mit

Bestehende Workflows bleiben unverändert und können weiterhin direkt verwendet werden.

## Next Steps für Implementierung

1. **bmad-orchestrator.md erweitern** um start-Command
2. **Detection-Logic implementieren** (File-System-Analysis)
3. **Context-Passing definieren** (Desktop=Electron etc.)
4. **Error-Handling ausbauen**
5. **Testing mit verschiedenen Projekttypen**