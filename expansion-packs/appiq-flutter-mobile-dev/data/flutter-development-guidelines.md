# Flutter Clean Architecture Development Guidelines

## 📋 Project Overview

This guide establishes comprehensive Flutter development standards following Clean Architecture principles, ensuring scalable, testable, and maintainable mobile applications.

## 🏗️ Architecture Overview

### Clean Architecture Layers

```
lib/
├── core/                    # Shared Core Functionality
│   ├── constants/          # API endpoints, app constants
│   ├── di/                # Dependency injection setup
│   ├── error/             # Error handling (failures, exceptions)
│   ├── network/           # Networking setup (API client, network info)
│   ├── local_storage/     # Hive/SharedPrefs service for local storage
│   └── utils/             # Core utilities and helpers
├── features/              # Feature-based modules
│   └── [feature_name]/    # Individual features
│       ├── data/          # Data layer
│       │   ├── datasources/   # Remote/Local data sources
│       │   ├── models/        # Data models with JSON serialization
│       │   └── repositories/  # Repository implementations
│       ├── domain/        # Domain layer (Business Logic)
│       │   ├── entities/      # Business entities
│       │   ├── repositories/  # Repository interfaces
│       │   └── usecases/     # Business use cases
│       └── presentation/  # Presentation layer (UI)
│           ├── cubit/        # State management (Cubit + State)
│           ├── pages/        # UI pages/screens
│           └── widgets/      # Feature-specific widgets
├── shared/                # Shared UI components and utilities
│   ├── theme/            # Theme management
│   ├── widgets/          # Reusable widgets (BaseScaffold, etc.)
│   ├── constants/        # UI constants
│   └── utils/            # Shared utilities
└── l10n/                 # Localization files (.arb)
```

## 🎯 Development Patterns & Style Guide

### 1. Entity Pattern (Domain Layer)

**Struktur:**
- Extends `Equatable` für Value Equality
- Immutable mit `const` Konstruktoren
- `copyWith` Methoden für Updates
- Alle Properties in `props` Liste

```dart
class UserEntity extends Equatable {
  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.bio,
    this.avatarUrl,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String name;
  final String email;
  final String? bio;
  final String? avatarUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  @override
  List<Object?> get props => [
    id, name, email, bio, avatarUrl, createdAt, updatedAt,
  ];

  UserEntity copyWith({
    String? id,
    String? name,
    String? email,
    String? bio,
    String? avatarUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      bio: bio ?? this.bio,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
```

### 2. Model Pattern (Data Layer)

**Struktur:**
- `@freezed` Annotation für Immutability
- JSON Serialization mit `json_serializable`
- `@JsonKey` für API Field Mapping
- Extension Methods für Entity Conversion

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user_entity.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String name,
    required String email,
    String? bio,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

extension UserModelExtension on UserModel {
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      name: name,
      email: email,
      bio: bio,
      avatarUrl: avatarUrl,
      createdAt: createdAt != null ? DateTime.tryParse(createdAt!) : null,
      updatedAt: updatedAt != null ? DateTime.tryParse(updatedAt!) : null,
    );
  }
}
```

### 3. Repository Pattern

**Interface (Domain Layer):**
```dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';

abstract class UserRepository {
  Future<Either<Failure, List<UserEntity>>> getUsers();
  Future<Either<Failure, UserEntity>> getUserById(String id);
  Future<Either<Failure, UserEntity>> createUser(UserEntity user);
  Future<Either<Failure, UserEntity>> updateUser(UserEntity user);
  Future<Either<Failure, void>> deleteUser(String id);
  Future<Either<Failure, List<UserEntity>>> searchUsers(String query);
}
```

### 4. UseCase Pattern

**Struktur:**
- `@injectable` für Dependency Injection
- `call` Methode als Main Entry Point
- Business Logic & Validation
- `Either<Failure, Success>` Return Type

```dart
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

@injectable
class CreateUserUseCase {
  const CreateUserUseCase(this._repository);

  final UserRepository _repository;

  Future<Either<Failure, UserEntity>> call(UserEntity user) async {
    // Validate user data
    final validationResult = _validateUser(user);
    if (validationResult != null) {
      return Left(ValidationFailure(validationResult));
    }

    return await _repository.createUser(user);
  }

  String? _validateUser(UserEntity user) {
    if (user.name.trim().isEmpty) {
      return 'Name is required';
    }
    
    if (user.email.trim().isEmpty) {
      return 'Email is required';
    }
    
    if (!_isValidEmail(user.email)) {
      return 'Please enter a valid email address';
    }
    
    return null;
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
```

### 5. State Management Pattern (Cubit)

**State Class:**
```dart
import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';

enum UserStatus {
  initial,
  loading,
  success,
  failure,
}

class UserState extends Equatable {
  const UserState({
    this.status = UserStatus.initial,
    this.users = const [],
    this.selectedUser,
    this.message,
  });

  final UserStatus status;
  final List<UserEntity> users;
  final UserEntity? selectedUser;
  final String? message;

  UserState copyWith({
    UserStatus? status,
    List<UserEntity>? users,
    UserEntity? selectedUser,
    String? message,
  }) {
    return UserState(
      status: status ?? this.status,
      users: users ?? this.users,
      selectedUser: selectedUser ?? this.selectedUser,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, users, selectedUser, message];
}
```

**Cubit Implementation:**
```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/get_users_usecase.dart';
import 'user_state.dart';

@injectable
class UserCubit extends Cubit<UserState> {
  UserCubit(
    this._getUsersUseCase,
    this._createUserUseCase,
    this._updateUserUseCase,
    this._deleteUserUseCase,
  ) : super(const UserState());

  final GetUsersUseCase _getUsersUseCase;
  final CreateUserUseCase _createUserUseCase;
  final UpdateUserUseCase _updateUserUseCase;
  final DeleteUserUseCase _deleteUserUseCase;

  Future<void> getUsers() async {
    emit(state.copyWith(status: UserStatus.loading));

    final result = await _getUsersUseCase();
    result.fold(
      (failure) => emit(state.copyWith(
        status: UserStatus.failure,
        message: failure.message ?? 'Failed to load users',
      )),
      (users) => emit(state.copyWith(
        status: UserStatus.success,
        users: users,
      )),
    );
  }

  Future<void> createUser(UserEntity user) async {
    emit(state.copyWith(status: UserStatus.loading));

    final result = await _createUserUseCase(user);
    result.fold(
      (failure) => emit(state.copyWith(
        status: UserStatus.failure,
        message: failure.message ?? 'Failed to create user',
      )),
      (createdUser) {
        final updatedUsers = [...state.users, createdUser];
        emit(state.copyWith(
          status: UserStatus.success,
          users: updatedUsers,
        ));
      },
    );
  }
}
```

## 🛠️ Technology Stack

### Core Dependencies
- **State Management**: `flutter_bloc` ^8.1.6
- **Dependency Injection**: `get_it` ^8.0.2 + `injectable` ^2.5.0
- **Code Generation**: `freezed` ^2.5.7 + `json_serializable` ^6.8.0
- **Networking**: `dio` ^5.7.0
- **Local Storage**: `hive` ^2.2.3
- **Error Handling**: `dartz` ^0.10.1
- **Value Equality**: `equatable` ^2.0.7
- **Routing**: `go_router` ^14.0.0
- **Localization**: `flutter_localizations` + `intl` ^0.19.0

### Dev Dependencies
- **Build Runner**: `build_runner` ^2.4.13
- **Code Generation**: `injectable_generator` ^2.6.2
- **Testing**: `bloc_test` ^9.1.7 + `mocktail` ^1.0.4

## 🌐 Multi-Language Support

### Localization Setup
```dart
// l10n.yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
output-class: AppLocalizations
```

### ARB File Structure
```json
// app_en.arb
{
  "@@locale": "en",
  "appTitle": "My App",
  "@appTitle": {
    "description": "The title of the application"
  },
  "welcomeMessage": "Welcome, {userName}!",
  "@welcomeMessage": {
    "description": "Welcome message with user name",
    "placeholders": {
      "userName": {
        "type": "String",
        "example": "John"
      }
    }
  }
}
```

### Usage in Widgets
```dart
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Text(l10n.welcomeMessage('John'));
  }
}
```

## 🎨 UI/UX Patterns

### Shared Components

**BaseScaffold - Responsive Layout:**
```dart
class BaseScaffold extends StatelessWidget {
  const BaseScaffold({
    super.key,
    required this.body,
    this.title,
    this.actions,
    this.floatingActionButton,
    this.safeArea = true,
  });

  final Widget body;
  final String? title;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final bool safeArea;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final mediaQuery = MediaQuery.of(context);
    final isTablet = mediaQuery.size.width >= 768;
    
    Widget bodyWidget = body;
    
    // Responsive constraints
    if (isTablet) {
      bodyWidget = Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: bodyWidget,
        ),
      );
    }
    
    return Scaffold(
      appBar: title != null 
        ? AppBar(
            title: Text(title!),
            actions: actions,
          ) 
        : null,
      body: safeArea ? SafeArea(child: bodyWidget) : bodyWidget,
      floatingActionButton: floatingActionButton,
    );
  }
}
```

## 🔧 Development Commands

### Code Generation
```bash
# Generate all code (models, DI, etc.)
flutter packages pub run build_runner build --delete-conflicting-outputs

# Generate localization files
flutter gen-l10n

# Clean and rebuild
flutter clean && flutter pub get && flutter packages pub run build_runner build --delete-conflicting-outputs
```

### Testing
```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run integration tests
flutter test integration_test/
```

## 📋 Naming Conventions

### Files & Directories
- **Files**: `snake_case.dart`
- **Directories**: `snake_case/`
- **Assets**: `snake_case.png`

### Code
- **Classes**: `PascalCase`
- **Variables & Methods**: `camelCase`
- **Constants**: `SCREAMING_SNAKE_CASE` in static classes
- **Private Members**: `_leadingUnderscore`

### Feature Naming Pattern
- **Entity**: `FeatureEntity`
- **Model**: `FeatureModel`
- **Repository Interface**: `FeatureRepository`
- **Repository Implementation**: `FeatureRepositoryImpl`
- **DataSource Interface**: `FeatureRemoteDataSource`
- **DataSource Implementation**: `FeatureRemoteDataSourceImpl`
- **UseCase**: `GetFeatureUseCase`, `CreateFeatureUseCase`, etc.
- **Cubit**: `FeatureCubit`
- **State**: `FeatureState`
- **Page**: `FeatureListPage`, `FeatureDetailPage`

## 🎯 Development Guidelines

### Best Practices
1. **Immutability**: Alle Data Classes sind immutable
2. **Single Responsibility**: Jede Klasse hat eine einzige Verantwortung
3. **Dependency Injection**: Alle Dependencies werden injected
4. **Error Handling**: Consistent Either<Failure, Success> Pattern
5. **Testing**: Jeder Use Case und Repository wird getestet
6. **Documentation**: Alle Public APIs sind dokumentiert
7. **Localization**: Keine statischen Texte, immer l10n verwenden
8. **Security**: Input validation und sichere Datenspeicherung

### Code Quality Checks
- **Linting**: `flutter_lints` für Code-Qualität
- **Type Safety**: Null Safety aktiviert
- **Build Runner**: Regelmäßige Code-Generierung
- **Testing**: Unit Tests für Business Logic
- **Security**: Regelmäßige Sicherheitsprüfungen

## 🚀 Standard Workflow

### Development Process
1. **Think through the problem** - Analyze requirements and read codebase
2. **Write a plan** to tasks/todo.md with checkable items
3. **Get plan verified** before beginning work
4. **Work on todo items** marking them complete as you go
5. **Provide high-level explanations** of changes made
6. **Keep changes simple** - impact as little code as possible
7. **Add review section** to todo.md with summary
8. **Make git commits** after each fully finished task

### Quality Criteria
- **Architecture**: Follows Clean Architecture with proper layer separation
- **Localization**: All text supports multi-language
- **Quality**: Passes all 5 quality criteria (DRY, Readable, Maintainable, Performant, Testable)
- **Documentation**: Code is properly documented with examples
- **Consistency**: Code style matches existing patterns

## 🔒 Security Guidelines

### Input Validation
- Validate all user inputs at UI and business logic level
- Use proper form validation with error messages
- Sanitize data before API calls

### Data Storage
- Use secure storage for sensitive data (flutter_secure_storage)
- Never store passwords in plain text
- Encrypt sensitive local data

### Network Security
- Use HTTPS for all API calls
- Implement certificate pinning for production
- Validate SSL certificates

### Authentication
- Implement proper token management
- Use secure token storage
- Handle token refresh properly

This guide ensures consistent, high-quality Flutter development that meets professional standards and security requirements.