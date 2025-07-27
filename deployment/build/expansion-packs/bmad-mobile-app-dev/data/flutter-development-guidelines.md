# Flutter Development Guidelines & Best Practices

## Core Development Principles

**THIS RULES ARE IMPORTANT AND YOU NEED FOLLOW THEM ALWAYS!!!!!**

🧹 **DRY-Prinzip befolgt** - Keine Code-Duplikation mehr  
📖 **Bessere Lesbarkeit** - Kleinere, fokussierte Methoden  
🔧 **Wartbarkeit** - Logische Gruppierung ähnlicher Funktionen  
⚡ **Performance** - Weniger redundante Repository-Calls  
🧪 **Testbarkeit** - Kleinere, testbare Methoden-Einheiten

Follow the best clean code rules and the best practices. Implement Code the same style as the architecture is built up - follow the folder and file structure.

## Architecture & Project Structure

### Clean Architecture Layers
All new features **MUST** follow the established Clean Architecture pattern:

```
lib/
├── core/              # Infrastructure & shared utilities
├── data/              # Data layer (repositories impl, data sources, models)
├── domain/            # Business logic (entities, repository interfaces, failures)
├── presentation/      # UI layer (screens, widgets, BLoC/Cubit, navigation)
└── l10n/              # Internationalization files
```

### Folder Organization Rules

#### 1. Feature-Based Organization
- Group related functionality by feature/domain
- Each feature should have its own subfolder structure
- Follow existing patterns in `presentation/ui/screens/`

#### 2. Core Services Location
- **ALWAYS** check existing services in `lib/core/services/` before creating new ones
- Services grouped by category: `auth/`, `network/`, `storage/`, `voice/`, etc.
- Use existing utilities in `lib/core/utils/`

#### 3. Mandatory Directory Structure for New Features
```
feature_name/
├── data/
│   ├── repositories/      # Repository implementations
│   ├── datasources/      # Local & remote data sources
│   └── models/           # Data models with JSON serialization
├── domain/
│   ├── entities/         # Business entities (immutable)
│   ├── repositories/     # Repository interfaces
│   └── failures/         # Feature-specific failures
└── presentation/
    ├── bloc/            # Cubit/BLoC state management
    ├── screens/         # Screen implementations
    └── widgets/         # Feature-specific widgets
```

## State Management Rules

### BaseCubitMixin Usage
**MANDATORY**: All Cubits **MUST** use `BaseCubitMixin` from `@lib/core/utils/base_cubit_mixin.dart`

```dart
class FeatureCubit extends Cubit<FeatureState> with BaseCubitMixin<FeatureState> {
  // Use executeRepositoryOperation for all repository calls
  Future<void> loadData() async {
    await executeRepositoryOperation<DataModel>(
      operation: () => repository.getData(),
      onSuccess: (data) => safeEmit(FeatureState.loaded(data)),
      operationName: 'loadData',
      loadingState: FeatureState.loading(),
      errorStateBuilder: (message) => FeatureState.error(message),
    );
  }
  
  @override
  void clearError() => safeEmit(FeatureState.initial());
  
  @override
  void resetToInitial() => safeEmit(FeatureState.initial());
}
```

### State Class Requirements
```dart
class FeatureState extends Equatable {
  final FeatureStatus status;
  final DataModel? data;
  final String? errorMessage;
  
  const FeatureState._({
    required this.status,
    this.data,
    this.errorMessage,
  });
  
  // Named constructors for each state
  const FeatureState.initial() : this._(status: FeatureStatus.initial);
  const FeatureState.loading() : this._(status: FeatureStatus.loading);
  const FeatureState.loaded(DataModel data) : this._(status: FeatureStatus.loaded, data: data);
  const FeatureState.error(String message) : this._(status: FeatureStatus.error, errorMessage: message);
  
  @override
  List<Object?> get props => [status, data, errorMessage];
}

enum FeatureStatus { initial, loading, loaded, error }
```

## Repository Pattern Rules

### Repository Interface (Domain Layer)
```dart
abstract class FeatureRepository {
  Future<Either<Failure, DataModel>> getData();
  Future<Either<Failure, void>> saveData(DataModel data);
}
```

### Repository Implementation (Data Layer)
```dart
class FeatureRepositoryImpl extends BaseRepository implements FeatureRepository {
  final FeatureRemoteDataSource remoteDataSource;
  final FeatureLocalDataSource localDataSource;
  
  FeatureRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });
  
  @override
  Future<Either<Failure, DataModel>> getData() async {
    return executeWithErrorHandling<DataModel>(
      () async => await remoteDataSource.getData(),
      operationName: 'getData',
      failureMessage: 'Failed to load data',
    );
  }
}
```

## Multi-Language Support Rules

### Localization Requirements
**MANDATORY**: All user-facing text **MUST** support multi-language (en, de, ru, tr, ar)

```dart
// ❌ Wrong - Hardcoded text
Text('Welcome to ProjectPilot')

// ✅ Correct - Using AppLocalizations
Text(AppLocalizations.of(context).welcomeMessage)
```

### Adding New Translations
1. Add key to `lib/l10n/app_en.arb`
2. Provide translations for all supported languages
3. Use semantic key names: `featureName_actionName_element`

```json
{
  "auth_login_welcomeTitle": "Welcome Back",
  "auth_login_emailLabel": "Email Address",
  "project_create_successMessage": "Project created successfully"
}
```

## Service Locator Rules

### Service Registration
**MANDATORY**: All services **MUST** be registered in `@lib/core/di/service_locator.dart`

```dart
// Check existing services BEFORE adding new ones
static Future<void> _registerFeatureServices() async {
  AppLogger.d('Registering feature services...', tag: 'DI');
  
  // Only register if not already exists
  _registerLazySingleton<FeatureService>(
    () => FeatureService(dependency: getIt<DependencyService>()),
    serviceName: 'FeatureService',
  );
}
```

### Service Access Pattern
```dart
class FeatureCubit extends Cubit<FeatureState> {
  final FeatureRepository repository;
  final FeatureService service;
  
  // Use dependency injection, NOT direct service locator calls
  FeatureCubit({
    required this.repository,
    required this.service,
  }) : super(FeatureState.initial());
}
```

## UI Development Rules

### Widget Organization
```dart
// Feature-specific widgets in feature directory
lib/presentation/ui/screens/feature/widgets/
├── feature_list_item.dart
├── feature_form.dart
└── feature_header.dart

// Shared widgets in core
lib/core/widgets/
├── loading_indicator.dart
├── error_display.dart
└── custom_button.dart
```

### Widget Structure
```dart
class FeatureWidget extends StatelessWidget {
  final FeatureModel data;
  final VoidCallback? onTap;
  
  const FeatureWidget({
    super.key,
    required this.data,
    this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    
    return Container(
      // Use theme colors and constants
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
      ),
      child: // Widget content
    );
  }
}
```

### Theme Usage
```dart
// ✅ Use theme colors
color: theme.colorScheme.primary
color: AppColors.primary  // For custom brand colors

// ✅ Use app constants
padding: EdgeInsets.all(AppConstants.defaultPadding)
borderRadius: BorderRadius.circular(AppConstants.defaultRadius)
```

## Code Style & Documentation

### Import Organization
```dart
// 1. Flutter/Dart imports
import 'dart:async';
import 'package:flutter/material.dart';
// 2. Package imports (alphabetical)
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// 3. Local imports (grouped by layer)
import 'package:projectpilot/core/constants/app_colors.dart';
import 'package:projectpilot/core/services/logger/app_logger.dart';
import 'package:projectpilot/domain/entities/feature_entity.dart';
import 'package:projectpilot/presentation/ui/widgets/custom_widget.dart';
```

### Documentation Requirements
```dart
/// Service responsible for managing feature operations
/// 
/// Provides CRUD operations for features with automatic caching,
/// error handling, and offline support.
/// 
/// Example usage:
/// ```dart
/// final service = sl<FeatureService>();
/// final result = await service.createFeature(data);
/// ```
class FeatureService {
  /// Creates a new feature with validation and persistence
  /// 
  /// [data] The feature data to create
  /// Returns [Either] with failure or created feature
  Future<Either<Failure, FeatureEntity>> createFeature(FeatureData data) async {
    // Implementation
  }
}
```

### Naming Conventions
- **Classes**: `PascalCase` (e.g., `FeatureService`, `ProjectEntity`)
- **Files**: `snake_case` (e.g., `feature_service.dart`, `project_entity.dart`)
- **Variables/Methods**: `camelCase` (e.g., `loadFeatures`, `isLoading`)
- **Constants**: `SCREAMING_SNAKE_CASE` (e.g., `DEFAULT_TIMEOUT`)
- **Private members**: Prefix with `_` (e.g., `_initializeService`)

## Development Workflow & Validation

### Pre-Implementation Checklist

#### Planning Phase
- [ ] **Analyze existing code** for similar patterns
- [ ] **Check core services** for reusable functionality
- [ ] **Verify multi-language** requirements
- [ ] **Design state management** structure
- [ ] **Plan repository interfaces** and implementations

#### Implementation Phase
- [ ] **Follow Clean Architecture** layers
- [ ] **Use BaseCubitMixin** for all Cubits
- [ ] **Implement proper error handling** with typed failures
- [ ] **Add comprehensive logging** with AppLogger
- [ ] **Use existing services** and utilities
- [ ] **Register new services** in ServiceLocator

#### Quality Assurance Phase
- [ ] **🧹 DRY Principle**: No code duplication
- [ ] **📖 Readability**: Small, focused methods with clear names
- [ ] **🔧 Maintainability**: Logical grouping and proper separation
- [ ] **⚡ Performance**: Efficient operations and minimal redundancy
- [ ] **🧪 Testability**: Small, testable method units

### Implementation Validation Checklist

```markdown
## Feature Implementation Review

### Architecture Compliance
- [ ] Follows Clean Architecture layers
- [ ] Proper dependency injection setup
- [ ] Repository pattern implemented correctly
- [ ] Entity design follows domain rules

### State Management
- [ ] BaseCubitMixin used and implemented properly
- [ ] State classes extend Equatable
- [ ] Error handling integrated
- [ ] Loading states managed correctly

### Code Quality
- [ ] No code duplication (DRY)
- [ ] Methods are small and focused
- [ ] Proper error handling throughout
- [ ] Comprehensive logging added
- [ ] Performance considerations addressed

### Multi-language Support
- [ ] All UI text uses AppLocalizations
- [ ] Keys added to all language files
- [ ] Semantic key naming used

### Service Integration
- [ ] Existing services reused where possible
- [ ] New services registered in ServiceLocator
- [ ] Dependencies properly injected

### Testing & Documentation
- [ ] Unit tests written for business logic
- [ ] Widget tests for UI components
- [ ] Code documented with examples
- [ ] Public API documented
```

## Anti-Patterns to Avoid

### ❌ What NOT to do

```dart
// ❌ Don't access service locator directly in widgets
Widget build(BuildContext context) {
  final service = sl<FeatureService>(); // WRONG
}

// ❌ Don't hardcode text
Text('Welcome User'); // WRONG

// ❌ Don't create cubits without BaseCubitMixin
class BadCubit extends Cubit<State> { // WRONG
  // Missing BaseCubitMixin
}

// ❌ Don't create services without registration
class NewService { // WRONG - Not registered in ServiceLocator
}

// ❌ Don't bypass repository pattern
class Cubit {
  void loadData() {
    apiClient.getData(); // WRONG - Direct API access
  }
}

// ❌ Don't ignore error handling
Future<void> operation() async {
  final result = await repository.getData(); // WRONG - No error handling
}
```

### ✅ Correct Patterns

```dart
// ✅ Use dependency injection
class FeatureWidget extends StatelessWidget {
  const FeatureWidget({super.key});
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeatureCubit, FeatureState>( // CORRECT
      builder: (context, state) => // Build UI
    );
  }
}

// ✅ Use localization
Text(AppLocalizations.of(context).welcomeMessage) // CORRECT

// ✅ Use BaseCubitMixin
class FeatureCubit extends Cubit<FeatureState> with BaseCubitMixin<FeatureState> // CORRECT

// ✅ Register services
_registerLazySingleton<FeatureService>(() => FeatureService()) // CORRECT

// ✅ Use repository pattern
await executeRepositoryOperation<Data>( // CORRECT
  operation: () => repository.getData(),
  onSuccess: (data) => handleSuccess(data),
  // ...
);
```

## Success Criteria

A feature is considered **complete and correct** when:

1. **Architecture**: Follows Clean Architecture with proper layer separation
2. **State Management**: Uses BaseCubitMixin with proper error/loading states
3. **Localization**: All text supports multi-language
4. **Services**: Reuses existing services or properly registers new ones
5. **Quality**: Passes all 5 quality criteria (DRY, Readable, Maintainable, Performant, Testable)
6. **Documentation**: Code is properly documented with examples
7. **Testing**: Unit and widget tests are implemented
8. **Consistency**: Code style matches existing patterns

## Support & Questions

When implementing new features:

1. **First**: Check existing code for similar patterns
2. **Second**: Review these coding rules
3. **Third**: Ensure all validation criteria are met
4. **Finally**: Implement with confidence following established patterns

> **Remember**: Consistency is key. When in doubt, follow existing patterns in the codebase.