 🚀 Installation und Setup

  1. System Installation

  # Im Projekt-Verzeichnis
  npx bmad-method install

  # ODER falls bereits installiert
  git pull
  npm run install:bmad

  2. Mobile Expansion Pack aktivieren

  Das Mobile App Development Expansion Pack ist automatisch verfügbar nach der Installation.

  📱 Mobile App Entwicklung starten

  Option A: Web UI (Empfohlen für Planning)

  1. Team Bundle laden

  # Navigiere zu dist/teams/
  cp dist/teams/team-fullstack.txt

  2. AI Platform konfigurieren

  - Claude (Sonnet 4): Neues Projekt erstellen
  - Gemini (2.5 Pro): Neuen Gem erstellen
  - ChatGPT: Custom GPT erstellen

  3. Bundle hochladen

  - Datei team-fullstack.txt hochladen
  - Instructions: "Your critical operating instructions are attached, do not break character as directed"

  4. Mobile Entwicklung starten

  Typ einfach: "Ich möchte eine mobile App entwickeln"

  Das System fragt automatisch:
  1. ✅ "Ist das eine neue App oder eine existierende App?"
  2. ✅ "Welche Platform: Flutter oder React Native?"
  3. ✅ "Wie komplex ist die App?" (für State Management)

  Option B: IDE (Für Development)

  1. IDE mit BMad öffnen

  - Cursor: @mobile-architect verwenden
  - Claude Code: /mobile-architect verwenden
  - Windsurf: @mobile-architect verwenden

  2. Workflow starten

  @mobile-architect Ich möchte eine mobile App entwickeln

  🔄 Workflow-Übersicht

  Für NEUE Mobile Apps:

  graph LR
      A[Start] --> B[Platform Selection]
      B --> C[State Management]
      C --> D[Architecture Design]
      D --> E[Development Setup]
      E --> F[Team Training]
      F --> G[Development Start]

  Konkrete Schritte:
  1. Platform Selection: Flutter vs React Native Analyse
  2. Requirements: Mobile-spezifische PRD erstellen
  3. Architecture: Clean Architecture mit gewählter Platform
  4. Setup: Projekt-Struktur und Guidelines
  5. Development: Story-basierte Entwicklung

  Für EXISTIERENDE Mobile Apps:

  graph LR
      A[Start] --> B[Code Analysis]
      B --> C[Assessment Report]
      C --> D[Strategy Planning]
      D --> E[Architecture Evolution]
      E --> F[Implementation]

  Konkrete Schritte:
  1. Code Analysis: Umfassende App-Analyse
  2. Assessment: Technische Schulden und Verbesserungen
  3. Strategy: Incremental vs Complete Rewrite
  4. Evolution: Architektur-Modernisierung
  5. Implementation: Schrittweise Verbesserung

  🎯 Praktische Anwendungsbeispiele

  Beispiel 1: Neue Flutter App

  User: "Ich möchte eine neue E-Commerce App mit Flutter entwickeln"

  System:
  ✅ Erkennt: NEUE MOBILE APP
  ✅ Startet: Platform Selection Workflow
  ✅ Fragt: Team-Expertise, Performance-Anforderungen, Timeline
  ✅ Empfiehlt: Flutter + BLoC/Cubit (für Enterprise) oder GetX (für MVP)
  ✅ Erstellt: Komplette Architektur mit Ihren Coding Guidelines

  Beispiel 2: Existierende React Native App verbessern

  User: "Meine React Native App ist langsam und hat viele Bugs"

  System:
  ✅ Erkennt: EXISTIERENDE MOBILE APP
  ✅ Startet: Existing App Analysis
  ✅ Analysiert: Code Quality, Performance, Architecture
  ✅ Erstellt: Detaillierten Verbesserungsplan
  ✅ Priorisiert: Critical Fixes → Quality → Features → Modernization

  Beispiel 3: Platform Migration

  User: "Ich will von nativen iOS/Android Apps zu Flutter migrieren"

  System:
  ✅ Erkennt: PLATFORM MIGRATION
  ✅ Analysiert: Bestehende Apps und Features
  ✅ Plant: Schritt-für-Schritt Migration
  ✅ Berücksichtigt: Data Migration, Feature Parity, Timeline

  📋 Verfügbare Commands

  In Web UI:

  *help                    - Zeigt alle Commands
  *analyst                 - Startet Requirements Analysis
  *mobile-architect        - Platform Selection & Architecture
  *pm                      - Mobile PRD Creation
  *dev                     - Mobile Development
  *bmad-orchestrator       - System Help & Guidance

  In IDE:

  @mobile-architect        - Platform & Architecture Guidance
  @mobile-pm              - Mobile Requirements & Planning
  @mobile-developer       - Implementation & Development
  @po                     - Document Sharding & Validation
  @sm                     - Story Creation
  @qa                     - Quality Assurance & Review

  🛠️ Spezifische Workflows

  1. Platform Selection Workflow

  @mobile-architect *platform-select

  Führt durch:
  - Requirements Analysis
  - Team Assessment  
  - Technical Constraints
  - Platform Comparison Matrix
  - State Management Selection
  - Final Recommendation

  2. Existing App Analysis

  @mobile-architect *analyze-existing

  Analysiert:
  - Current Architecture
  - Code Quality Metrics
  - Performance Issues
  - Security Vulnerabilities
  - Technical Debt
  - Improvement Roadmap

  3. State Management Guidance

  @mobile-architect *state-management

  Für Flutter:
  - BLoC/Cubit: Enterprise/Complex Apps
  - Riverpod: Modern/Medium Apps  
  - GetX: Rapid Development
  - Provider: Learning/Simple Apps

  Für React Native:
  - Redux Toolkit: Enterprise/Complex
  - Zustand: Performance/Medium
  - Context API: Simple Global State

  📚 Integration mit bestehendem Workflow

  Nach Platform Selection:

  1. PRD Creation: @pm → Mobile-spezifische Requirements
  2. Architecture: @architect → Clean Architecture Design
  3. Story Creation: @sm → Mobile-optimierte Stories
  4. Development: @dev → Mit Ihren Flutter Guidelines
  5. QA: @qa → Mobile Testing & Performance

  Automatische Guidelines Integration:

  - Flutter: Ihre spezifischen Coding Rules werden automatisch angewandt
  - React Native: Best Practices für TypeScript + Performance
  - Clean Architecture: Immer mit DI, Repository Pattern, Testing

  ⚡ Quick Start Checkliste

  Für neue Mobile Apps:

  - npx bmad-method install
  - Web UI oder IDE starten
  - "Ich möchte eine mobile App entwickeln" eingeben
  - Platform Selection durchführen
  - Automatisch generierte Architektur verwenden
  - Mit Story Creation beginnen

  Für existierende Apps:

  - Codebase-Zugang sicherstellen
  - @mobile-architect *analyze-existing starten
  - Analysis Report durchgehen
  - Enhancement Strategy auswählen
  - Schrittweise Implementation planen

  🎯 Erfolgsfaktoren

  Das System hilft Ihnen bei:

  ✅ Richtige Platform-Wahl basierend auf objektiven Kriterien✅ Optimales State Management für Ihre App-Komplexität✅ Clean Architecture mit bewährten Patterns✅ Ihre Flutter Guidelines automatisch integriert✅ Systematische Code-Analyse für existierende Apps✅ Prioritisierte Verbesserungs-Roadmaps✅ Team-Training und Onboarding

  Qualitäts-Garantie:

  Alle Empfehlungen basieren auf 2024 Best Practices und Ihrer spezifischen Coding-Standards.

  Ready to go! 🚀 Starten Sie einfach mit "Ich möchte eine mobile App entwickeln" und das System führt Sie durch den optimalen Workflow.