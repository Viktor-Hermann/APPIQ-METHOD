# Livestream Feature PRD

## Overview
Implementierung einer Live-Streaming-Funktionalität in die bestehende Flutter-App mit intelligenter Integration in vorhandene Komponenten.

## Implementation Paths
> Spezifische Pfade für optimale Integration

### Suggested File Structure
```
lib/
├── features/
│   └── livestream/                    # ← Neues Feature
│       ├── data/
│       │   ├── datasources/
│       │   │   ├── livestream_remote_datasource.dart
│       │   │   └── livestream_local_datasource.dart
│       │   ├── models/
│       │   │   ├── stream_model.dart
│       │   │   └── stream_chat_model.dart
│       │   └── repositories/
│       │       └── livestream_repository_impl.dart
│       ├── domain/
│       │   ├── entities/
│       │   │   ├── stream_entity.dart
│       │   │   └── stream_message_entity.dart
│       │   ├── repositories/
│       │   │   └── livestream_repository.dart
│       │   └── usecases/
│       │       ├── start_stream_usecase.dart
│       │       ├── join_stream_usecase.dart
│       │       └── send_chat_message_usecase.dart
│       └── presentation/
│           ├── cubit/
│           │   ├── livestream_cubit.dart
│           │   ├── livestream_state.dart
│           │   ├── stream_chat_cubit.dart
│           │   └── stream_chat_state.dart
│           ├── pages/
│           │   ├── stream_list_page.dart
│           │   ├── stream_viewer_page.dart
│           │   └── stream_creator_page.dart
│           └── widgets/
│               ├── stream_player_widget.dart
│               ├── stream_controls_widget.dart
│               └── stream_chat_widget.dart
```

### Integration Points
> Bestehende Dateien/Klassen für Integration:

- **Main Navigation**: `lib/features/home/presentation/pages/home_page.dart`
  - Füge "Go Live" Button in AppBar hinzu
  - Integriere Stream-Liste in Home-Feed

- **Existing API Service**: `lib/shared/services/api_service.dart`
  - Erweitere für WebRTC-Endpoints
  - Nutze bestehende Auth-Header

- **Video Player Base**: `lib/features/media/presentation/widgets/video_player_widget.dart`
  - Erweitere für Live-Stream-Funktionalität
  - Nutze bestehende Player-Controls

- **Chat System**: `lib/features/chat/presentation/widgets/chat_widget.dart`
  - Adaptiere für Live-Stream-Chat
  - Nutze bestehende Message-Patterns

- **User Profile Integration**: `lib/features/user/presentation/pages/profile_page.dart`
  - Füge "My Streams" Sektion hinzu
  - Zeige Stream-History

### Code Reuse Analysis
> Bestehende Komponenten prüfen und wiederverwenden:

#### Existing Similar Features (PRÜFEN ZUERST!)
- [ ] **Video Feature**: `lib/features/video/` - Für Player-Logik
- [ ] **Chat Feature**: `lib/features/chat/` - Für Chat-Implementation
- [ ] **Camera Feature**: `lib/features/camera/` - Für Stream-Aufnahme
- [ ] **Notification Feature**: `lib/features/notifications/` - Für Stream-Alerts

#### Shared Components to Reuse (VERWENDEN STATT NEU ERSTELLEN!)
- [ ] `lib/shared/widgets/loading_widget.dart` - Für Stream-Loading
- [ ] `lib/shared/widgets/error_widget.dart` - Für Stream-Errors
- [ ] `lib/shared/widgets/custom_button.dart` - Für Stream-Controls
- [ ] `lib/shared/widgets/user_avatar.dart` - Für Streamer-Avatar
- [ ] `lib/shared/widgets/bottom_sheet_widget.dart` - Für Stream-Settings
- [ ] `lib/shared/services/navigation_service.dart` - Für Stream-Navigation
- [ ] `lib/shared/services/websocket_service.dart` - Für Real-time Chat
- [ ] `lib/shared/utils/validators.dart` - Für Stream-Input-Validation
- [ ] `lib/shared/utils/permission_handler.dart` - Für Camera/Mic-Permissions

#### Common Patterns to Follow (BESTEHENDE PATTERNS BEFOLGEN!)
- [ ] **Cubit Naming**: `LivestreamCubit`, `LivestreamState` (wie `AuthCubit`)
- [ ] **Error Handling**: `StreamFailure` extends `Failure` (wie `AuthFailure`)
- [ ] **API Patterns**: `ApiResponse<StreamModel>` (wie bestehende APIs)
- [ ] **Repository Pattern**: Folge `UserRepository` Struktur
- [ ] **DI Pattern**: Registrierung wie in `injection_container.dart`

## UI References
> Mockups und Referenz-Bilder für Development

### Design Assets Location
```
assets/
├── images/
│   └── livestream/
│       ├── mockup_stream_list.png          # ← Haupt-Stream-Liste
│       ├── mockup_stream_viewer.png        # ← Stream-Viewer mit Chat
│       ├── mockup_stream_creator.png       # ← Stream-Erstellung
│       ├── wireframe_stream_flow.png       # ← User-Flow Diagramm
│       └── ui_components_reference.png     # ← UI-Komponenten Guide
└── icons/
    └── livestream/
        ├── stream_icon.svg                 # ← Live-Stream Icon
        ├── camera_icon.svg                 # ← Kamera Icon
        ├── chat_icon.svg                   # ← Chat Icon
        └── viewer_count_icon.svg           # ← Viewer-Anzahl Icon
```

### UI Reference Links
- **Figma Design**: https://figma.com/livestream-feature-v2
- **Design System**: `lib/shared/theme/app_theme.dart` - Folge bestehende Patterns
- **Similar UI Reference**: 
  - `lib/features/video/presentation/pages/video_player_page.dart` - Für Player-Layout
  - `lib/features/chat/presentation/widgets/chat_list_widget.dart` - Für Chat-UI

### Visual Guidelines (BESTEHENDE PATTERNS VERWENDEN!)
- **Theme**: Erweitere `lib/shared/theme/app_theme.dart`
  - Füge `livestreamColors` zu `AppColors` hinzu
  - Nutze bestehende `primaryColor` für Live-Indicator
- **Typography**: Verwende `AppTextStyles.headline1` für Stream-Titel
- **Spacing**: Nutze `AppSpacing.medium` für konsistente Abstände
- **Components**: Erweitere `lib/shared/widgets/` statt neue zu erstellen

## Features
- **Live Stream Starten**: Integration mit bestehender Camera-Feature
- **Stream Discovery**: Erweitere Home-Feed um Stream-Liste  
- **Real-time Chat**: Nutze bestehende Chat-Infrastruktur
- **Stream Controls**: Erweitere bestehende Video-Controls
- **Viewer Analytics**: Integration in bestehende Analytics

## Acceptance Criteria

### Live Stream Starten
- [ ] **Reuse Camera Permission**: Nutze `lib/shared/utils/permission_handler.dart`
- [ ] **Extend Navigation**: Füge zu `lib/core/routing/app_router.dart` hinzu
- [ ] **Follow Button Pattern**: Nutze `lib/shared/widgets/custom_button.dart`

### Stream Viewer  
- [ ] **Extend Video Player**: Erweitere `lib/features/video/presentation/widgets/video_player_widget.dart`
- [ ] **Reuse Loading States**: Nutze `lib/shared/widgets/loading_widget.dart`
- [ ] **Follow Page Structure**: Wie `lib/features/video/presentation/pages/video_player_page.dart`

### Chat Integration
- [ ] **Extend Chat Widget**: Adaptiere `lib/features/chat/presentation/widgets/chat_widget.dart`
- [ ] **Reuse WebSocket**: Nutze `lib/shared/services/websocket_service.dart`
- [ ] **Follow Message Pattern**: Wie `lib/features/chat/domain/entities/message_entity.dart`

## Technical Requirements

### Architecture Compliance (BESTEHENDE PATTERNS BEFOLGEN!)
- [ ] **Clean Architecture**: Folge `lib/features/user/` Struktur
- [ ] **Cubit State Management**: Wie `lib/features/auth/presentation/cubit/auth_cubit.dart`
- [ ] **Repository Pattern**: Wie `lib/features/user/data/repositories/user_repository_impl.dart`
- [ ] **Dependency Injection**: Registrierung in `lib/core/di/injection_container.dart`

### Code Integration Requirements (ZUERST PRÜFEN!)
- [ ] **Before New API Client**: Erweitere `lib/shared/services/api_service.dart`
- [ ] **Before New WebSocket**: Prüfe `lib/shared/services/websocket_service.dart`
- [ ] **Before New Widgets**: Prüfe `lib/shared/widgets/` für ähnliche Komponenten
- [ ] **Before New Utils**: Prüfe `lib/shared/utils/` für Helper-Functions
- [ ] **Before New Services**: Prüfe `lib/shared/services/` für ähnliche Services

### Performance Requirements (BESTEHENDE OPTIMIERUNGEN NUTZEN!)
- [ ] **Image Caching**: Nutze bestehende `lib/shared/services/image_cache_service.dart`
- [ ] **Network Optimization**: Folge bestehende API-Caching-Patterns
- [ ] **Memory Management**: Wie in `lib/features/video/` implementiert

## Auto-Analysis Instructions
> Für das smart-auto-detect System

### Code Analysis Tasks
1. **Scan Similar Features**:
   ```bash
   # Prüfe Video-Feature für Player-Patterns
   find lib/features/video/ -name "*.dart" | head -10
   
   # Prüfe Chat-Feature für Message-Patterns  
   find lib/features/chat/ -name "*.dart" | head -10
   
   # Prüfe Camera-Feature für Aufnahme-Patterns
   find lib/features/camera/ -name "*.dart" | head -10
   ```

2. **Shared Component Analysis**:
   ```bash
   # Prüfe verfügbare Widgets
   ls -la lib/shared/widgets/ | grep -E "(video|chat|button|loading)"
   
   # Prüfe verfügbare Services
   ls -la lib/shared/services/ | grep -E "(api|websocket|navigation)"
   
   # Prüfe verfügbare Utils
   ls -la lib/shared/utils/ | grep -E "(validator|permission|formatter)"
   ```

### Architect Fallback Rules
> Wenn Pfade nicht spezifiziert sind:

1. **Feature Complexity**: HOCH → Eigenes Feature-Verzeichnis
2. **Dependencies**: Video + Chat + Camera → Nutze bestehende Integration-Patterns
3. **UI Complexity**: Multiple Screens → Folge `lib/features/video/` Struktur

## User Stories

### Epic: Live Streaming Infrastructure
- Als Entwickler möchte ich bestehende Video-Player-Komponenten erweitern, damit ich keine redundante Player-Logik erstelle
- Als Entwickler möchte ich bestehende Chat-Infrastruktur nutzen, damit Real-time-Messaging bereits funktioniert
- Als Entwickler möchte ich bestehende Camera-Services verwenden, damit Permissions bereits verwaltet sind

### Epic: Stream Creation & Management  
- Als Content Creator möchte ich den vertrauten Camera-Button verwenden, damit die Stream-Erstellung intuitiv ist
- Als Content Creator möchte ich bestehende Navigation-Patterns nutzen, damit die App konsistent bleibt
- Als Content Creator möchte ich bekannte UI-Komponenten sehen, damit die Bedienung vertraut ist

### Epic: Stream Consumption
- Als Viewer möchte ich den gewohnten Video-Player sehen, damit die Bedienung vertraut ist
- Als Viewer möchte ich das bekannte Chat-Interface nutzen, damit ich sofort weiß, wie ich interagiere
- Als Viewer möchte ich konsistente Loading-States sehen, damit die App professionell wirkt

## Dependencies

### Existing Code Dependencies (WIEDERVERWENDEN!)
- `lib/features/video/` - Video Player Base-Funktionalität
- `lib/features/chat/` - Real-time Chat Infrastructure
- `lib/features/camera/` - Camera Access & Permissions
- `lib/shared/services/api_service.dart` - HTTP Client für Stream-APIs
- `lib/shared/services/websocket_service.dart` - Real-time Communication
- `lib/shared/widgets/` - UI Components (Button, Loading, Error)

### New External Dependencies
- `webrtc_interface: ^1.0.0` - Für Live-Streaming
- `agora_rtc_engine: ^6.0.0` - Stream Infrastructure (falls nicht WebRTC)

### Backend Dependencies
- WebRTC Signaling Server
- Stream Media Server (RTMP/HLS)
- Chat WebSocket Endpoints (erweitere bestehende)

## Migration/Integration Notes

### Existing Feature Integration
- [ ] **Video Feature**: Erweitere Player für Live-Streams
- [ ] **Chat Feature**: Adaptiere für Stream-spezifische Messages
- [ ] **Home Feature**: Integriere Stream-Liste in Feed
- [ ] **Profile Feature**: Füge Stream-History hinzu

### Navigation Integration
- [ ] Erweitere `lib/core/routing/app_router.dart`:
  ```dart
  GoRoute(
    path: '/livestream',
    builder: (context, state) => const StreamListPage(),
  ),
  GoRoute(
    path: '/livestream/:streamId',
    builder: (context, state) => StreamViewerPage(
      streamId: state.params['streamId']!,
    ),
  ),
  ```

### State Management Integration
- [ ] Erweitere globale App-State falls nötig
- [ ] Integration mit bestehenden User-State für Streamer-Info
- [ ] Benachrichtigungs-State für Stream-Alerts

Das ist ein intelligentes PRD, das maximale Code-Wiederverwendung sicherstellt! 🧠✨