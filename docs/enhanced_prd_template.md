# {Feature Name} PRD

## Overview
Brief description of the feature

## Implementation Paths
> Specify where this feature should be implemented. If not specified, Architect will determine optimal location.

### Suggested File Structure
```
lib/
├── features/
│   └── {feature_name}/           # ← Main feature folder
│       ├── data/
│       │   ├── datasources/
│       │   │   └── {feature}_remote_datasource.dart
│       │   ├── models/
│       │   │   └── {feature}_model.dart
│       │   └── repositories/
│       │       └── {feature}_repository_impl.dart
│       ├── domain/
│       │   ├── entities/
│       │   │   └── {feature}_entity.dart
│       │   ├── repositories/
│       │   │   └── {feature}_repository.dart
│       │   └── usecases/
│       │       ├── get_{feature}_usecase.dart
│       │       └── create_{feature}_usecase.dart
│       └── presentation/
│           ├── cubit/
│           │   ├── {feature}_cubit.dart
│           │   └── {feature}_state.dart
│           ├── pages/
│           │   └── {feature}_page.dart
│           └── widgets/
│               └── {feature}_widget.dart
```

### Integration Points
> Specify existing files/classes to integrate with:

- **Existing Pages**: `lib/features/home/presentation/pages/home_page.dart`
- **Shared Services**: `lib/shared/services/api_service.dart`
- **Common Widgets**: `lib/shared/widgets/custom_button.dart`
- **Routing**: `lib/core/routing/app_router.dart`
- **DI Container**: `lib/core/di/injection_container.dart`

### Code Reuse Analysis
> List existing components that should be checked/reused:

#### Existing Similar Features
- [ ] Check `lib/features/user_profile/` for similar patterns
- [ ] Review `lib/features/authentication/` for auth integration
- [ ] Analyze `lib/shared/widgets/` for reusable UI components

#### Shared Components to Reuse
- [ ] `lib/shared/widgets/loading_widget.dart` - For loading states
- [ ] `lib/shared/widgets/error_widget.dart` - For error handling
- [ ] `lib/shared/services/navigation_service.dart` - For navigation
- [ ] `lib/shared/utils/validators.dart` - For input validation

#### Common Patterns to Follow
- [ ] Follow existing Cubit naming: `{Feature}Cubit`, `{Feature}State`
- [ ] Use existing error handling: `Failure` classes in `lib/core/error/`
- [ ] Follow existing API patterns: `ApiResponse<T>` wrapper
- [ ] Use existing dependency injection patterns

## UI References
> Include mockups, wireframes, or reference images

### Design Assets Location
```
assets/
├── images/
│   └── {feature_name}/
│       ├── mockup_main_screen.png
│       ├── wireframe_flow.png
│       └── ui_components_reference.png
└── icons/
    └── {feature_name}/
        ├── feature_icon.svg
        └── action_icons/
```

### UI Reference Links
- **Figma Design**: [Link to Figma prototype]
- **Design System**: [Link to design system/style guide]
- **Similar UI Patterns**: `lib/features/existing_feature/presentation/pages/` for reference

### Visual Guidelines
- **Theme**: Follow existing `lib/shared/theme/app_theme.dart`
- **Colors**: Use existing color palette from `AppColors`
- **Typography**: Follow `AppTextStyles` definitions
- **Spacing**: Use `AppSpacing` constants
- **Components**: Extend existing `lib/shared/widgets/` where possible

## Features
- Feature 1: Description
- Feature 2: Description  
- Feature 3: Description

## Acceptance Criteria
### Feature 1
- [ ] Criteria 1
- [ ] Criteria 2

## Technical Requirements

### Architecture Compliance
- [ ] Follow Clean Architecture pattern
- [ ] Use existing Cubit state management patterns
- [ ] Implement Repository pattern following existing conventions
- [ ] Use GetIt dependency injection like other features

### Code Integration Requirements
- [ ] **Before creating new files**: Check if similar functionality exists
- [ ] **Before new widgets**: Review `lib/shared/widgets/` for reusable components
- [ ] **Before new services**: Check `lib/shared/services/` for existing solutions
- [ ] **Before new utilities**: Review `lib/shared/utils/` for helper functions

### Performance Requirements
- [ ] Reuse existing cached data where applicable
- [ ] Follow existing image loading/caching patterns
- [ ] Use existing performance monitoring setup

## Auto-Analysis Instructions
> Instructions for the auto-detect system

### Code Analysis Tasks
1. **Scan Existing Codebase**:
   ```bash
   # Analyze similar features
   find lib/features/ -name "*{similar_keyword}*" -type f
   
   # Check shared components
   ls -la lib/shared/widgets/ | grep -i {relevant_widgets}
   
   # Review existing services
   find lib/shared/services/ -name "*{service_type}*"
   ```

2. **Dependency Analysis**:
   - Check `pubspec.yaml` for existing packages that could be reused
   - Review `lib/core/di/injection_container.dart` for existing service registrations
   - Analyze existing API endpoints in data sources

3. **Pattern Analysis**:
   - Review existing Cubit implementations for state management patterns
   - Check existing repository implementations for data access patterns
   - Analyze existing widget compositions for UI patterns

### Architect Fallback Rules
> If implementation paths are not specified:

1. **Analyze Feature Complexity**:
   - Simple feature → Integrate into existing feature folder
   - Complex feature → Create new feature folder
   - Cross-cutting concern → Add to shared/

2. **Check Dependencies**:
   - Heavy external dependencies → Separate feature
   - Uses existing services → Integrate with existing structure
   - New infrastructure needed → Consult with data layer architecture

3. **UI Complexity Assessment**:
   - Single screen → Add to existing feature
   - Multiple screens with navigation → New feature folder
   - Shared UI components → Extract to shared/widgets/

## User Stories
### Epic: {Epic Name}
- As a user I want to... so that...
- As a user I want to... so that...

## Dependencies
- Backend API endpoints
- Third-party integrations  
- Design assets
- Existing code dependencies

## Migration/Integration Notes
> Special considerations for integrating with existing codebase

### Database Changes
- [ ] Check if existing database schema can be extended
- [ ] Review existing migration patterns
- [ ] Consider data migration requirements

### API Changes  
- [ ] Review existing API client setup
- [ ] Check if new endpoints fit existing patterns
- [ ] Consider backwards compatibility

### Navigation Changes
- [ ] Review existing routing structure
- [ ] Check if new routes fit existing patterns
- [ ] Consider deep linking requirements

### State Management Integration
- [ ] Review existing global state management
- [ ] Check if feature state needs to be shared
- [ ] Consider state persistence requirements