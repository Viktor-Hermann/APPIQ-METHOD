# /start - Universal APPIQ Method Launcher

**Ein Befehl für alles:** `/start` - Intelligente Projekt-Erkennung und Workflow-Führung

## Konzept: Einfacher geführter Workflow

Statt 6+ verschiedene Workflows zu kennen, startest du einfach mit `/start` und wirst durch 3 einfache Fragen geleitet:

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

### Schritt 3: Automatische Workflow-Auswahl
Basierend auf den Antworten wird automatisch der richtige Workflow gestartet:

**Kombinationen → Workflows:**
- Neu + Web → `greenfield-fullstack.yaml`
- Neu + Desktop → `greenfield-fullstack.yaml` (mit Electron-Fokus)
- Neu + Mobile → Mobile Platform Selection → Flutter/React Native Workflow
- Neu + Backend → `greenfield-service.yaml`
- Bestehend + Web → `brownfield-fullstack.yaml`
- Bestehend + Desktop → `brownfield-fullstack.yaml` 
- Bestehend + Mobile → Mobile Platform Detection → entsprechender Brownfield Workflow
- Bestehend + Backend → `brownfield-service.yaml`

### Schritt 4: Smart Detection (Option 5)
Wenn unsicher, analysiert das System automatisch:

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
- requirements.txt? → Python Backend
- pubspec.yaml? → Flutter
- etc.

Basierend darauf empfehle ich den optimalen Workflow.
```

## Beispiel-Interaktion

```
User: /start

🚀 APPIQ Method Universal Launcher

Arbeiten wir an einem neuen oder bestehenden Projekt?

1. 🆕 Neues Projekt (Greenfield) - Wir bauen von Grund auf
2. 🔧 Bestehendes Projekt (Brownfield) - Wir erweitern/verbessern etwas

Antworte mit 1 oder 2:

User: 2

📋 Lass mich verstehen, was wir bauen...

Was für eine Art von Anwendung ist das?

1. 🌐 Web-Anwendung (läuft im Browser)
2. 💻 Desktop-Anwendung (Electron, Windows/Mac App)
3. 📱 Mobile App (iOS/Android)
4. ⚙️ Backend/API Service (Server, Database)
5. 🤔 Bin mir nicht sicher - lass APPIQ entscheiden

Antworte mit 1, 2, 3, 4 oder 5:

User: 2

🎯 Perfect! Electron Desktop App Enhancement erkannt.

✅ Starte Brownfield Full-Stack Workflow für Desktop-Anwendungen...

📍 Erster Agent: analyst (analysiert bestehende App-Struktur)
📂 Ziel: Verstehen der aktuellen Desktop-App Architektur

@analyst - Bitte analysiere die bestehende Electron-Anwendung und identifiziere Verbesserungsmöglichkeiten.
```

## Vereinfachung der Workflow-Namen

Intern bleiben die technischen Namen, aber User sehen einfache Beschreibungen:
- `greenfield-fullstack.yaml` → "Neue Web/Desktop App"
- `greenfield-service.yaml` → "Neuer Backend Service" 
- `brownfield-fullstack.yaml` → "Bestehende Web/Desktop App erweitern"
- etc.

## Vorteile

1. **Ein einziger Befehl** - keine Verwirrung
2. **Intelligente Führung** - System entscheidet mit
3. **Automatische Erkennung** - weniger denken, mehr machen
4. **Fehlerverzeihend** - "Nicht sicher" Option vorhanden
5. **Gleiche Power** - alle bestehenden Workflows verfügbar

Soll ich das implementieren?