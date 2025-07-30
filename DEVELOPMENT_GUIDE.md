# Flutter Clean Architecture Development Guide

## 📋 Project Overview

**NX SourceCode** ist eine umfassende Flutter-Anwendung, die Clean Architecture Prinzipien implementiert und als soziale Plattform mit vielfältigen Features fungiert. Das Projekt demonstriert professionelle Flutter-Entwicklung mit skalierbarer, testbarer und wartbarer Code-Architektur.

## 🏗️ Architecture Overview

### Clean Architecture Layers

```
lib/
├── core/                    # Shared Core Functionality
│   ├── constants/          # API endpoints, app constants
│   ├── di/                # Dependency injection setup
│   ├── error/             # Error handling (failures, exceptions)
│   ├── network/           # Networking setup (API client, network info)
│   └── local_storage/     # Hive service for local storage
├── features/              # Feature-based modules (17 Features)
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
│   └── widgets/          # Reusable widgets (BaseScaffold, etc.)
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

extension UserEntityExtension on UserEntity {
  UserModel toModel() {
    return UserModel(
      id: id,
      name: name,
      email: email,
      bio: bio,
      avatarUrl: avatarUrl,
      createdAt: createdAt?.toIso8601String(),
      updatedAt: updatedAt?.toIso8601String(),
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

**Implementation (Data Layer):**
```dart
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';

@LazySingleton(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  const UserRepositoryImpl(
    this._remoteDataSource,
    this._networkInfo,
  );

  final UserRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  @override
  Future<Either<Failure, List<UserEntity>>> getUsers() async {
    if (await _networkInfo.isConnected) {
      try {
        final users = await _remoteDataSource.getUsers();
        return Right(users.map((model) => model.toEntity()).toList());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } catch (e) {
        return Left(UnknownFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }
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

### 5. State Management Pattern

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
    this._getUserByIdUseCase,
    this._createUserUseCase,
    this._updateUserUseCase,
    this._deleteUserUseCase,
    this._searchUsersUseCase,
  ) : super(const UserState());

  final GetUsersUseCase _getUsersUseCase;
  final GetUserByIdUseCase _getUserByIdUseCase;
  final CreateUserUseCase _createUserUseCase;
  final UpdateUserUseCase _updateUserUseCase;
  final DeleteUserUseCase _deleteUserUseCase;
  final SearchUsersUseCase _searchUsersUseCase;

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

### 6. DataSource Pattern

**Abstract Class:**
```dart
abstract class UserRemoteDataSource {
  Future<List<UserModel>> getUsers();
  Future<UserModel> getUserById(String id);
  Future<UserModel> createUser(UserModel user);
  Future<UserModel> updateUser(UserModel user);
  Future<void> deleteUser(String id);
  Future<List<UserModel>> searchUsers(String query);
}
```

**Implementation:**
```dart
import 'package:injectable/injectable.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/user_model.dart';

@LazySingleton(as: UserRemoteDataSource)
class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  const UserRemoteDataSourceImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<List<UserModel>> getUsers() async {
    final response = await _apiClient.get(ApiConstants.users);
    final List<dynamic> usersJson = response.data['data'] ?? response.data;
    return usersJson.map((json) => UserModel.fromJson(json)).toList();
  }

  @override
  Future<UserModel> getUserById(String id) async {
    final response = await _apiClient.get('${ApiConstants.users}/$id');
    return UserModel.fromJson(response.data['data'] ?? response.data);
  }

  @override
  Future<UserModel> createUser(UserModel user) async {
    final response = await _apiClient.post(
      ApiConstants.users,
      data: user.toJson(),
    );
    return UserModel.fromJson(response.data['data'] ?? response.data);
  }
}
```

### 7. UI Page Pattern

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../shared/widgets/base_scaffold.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../cubit/user_cubit.dart';
import '../cubit/user_state.dart';
import '../widgets/user_list_item.dart';

class UserListPage extends StatelessWidget {
  const UserListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<UserCubit>()..getUsers(),
      child: const UserListView(),
    );
  }
}

class UserListView extends StatelessWidget {
  const UserListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Users',
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateUserDialog(context),
        child: const Icon(Icons.add),
      ),
      body: BlocConsumer<UserCubit, UserState>(
        listener: (context, state) {
          if (state.status == UserStatus.failure && state.message != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message!),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        },
        builder: (context, state) {
          return switch (state.status) {
            UserStatus.loading => const LoadingWidget(),
            UserStatus.failure => CustomErrorWidget(
                message: state.message ?? 'Unknown error occurred',
                onRetry: () => context.read<UserCubit>().getUsers(),
              ),
            UserStatus.success => RefreshIndicator(
                onRefresh: () => context.read<UserCubit>().getUsers(),
                child: ListView.builder(
                  itemCount: state.users.length,
                  itemBuilder: (context, index) {
                    return UserListItem(
                      user: state.users[index],
                      onTap: () => _navigateToUserDetail(context, state.users[index]),
                    );
                  },
                ),
              ),
            _ => const SizedBox.shrink(),
          };
        },
      ),
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

### Dev Dependencies
- **Build Runner**: `build_runner` ^2.4.13
- **Code Generation**: `injectable_generator` ^2.6.2
- **Testing**: `bloc_test` ^9.1.7 + `mocktail` ^1.0.4

## 🌐 Networking Layer

### API Client Implementation
```dart
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../constants/api_constants.dart';
import '../error/exceptions.dart';

@LazySingleton()
class ApiClient {
  late final Dio _dio;

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) {
          final exception = _handleDioError(error);
          handler.reject(DioException(
            requestOptions: error.requestOptions,
            error: exception,
          ));
        },
      ),
    );
  }

  Exception _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkException('Connection timeout');
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        switch (statusCode) {
          case 400:
            return ValidationException(
              error.response?.data?['message'] ?? 'Bad request',
            );
          case 401:
            return const AuthenticationException('Unauthorized');
          case 403:
            return const AuthorizationException('Forbidden');
          case 404:
            return const NotFoundException('Resource not found');
          case 500:
          default:
            return ServerException(
              error.response?.data?['message'] ?? 'Server error',
            );
        }
      case DioExceptionType.connectionError:
        return const NetworkException('No internet connection');
      default:
        return ServerException(error.message);
    }
  }
}
```

## 🚨 Error Handling System

### Failure Types
```dart
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure([this.message]);
  final String? message;

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure([super.message]);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message]);
}

class ValidationFailure extends Failure {
  const ValidationFailure([super.message]);
}

class AuthenticationFailure extends Failure {
  const AuthenticationFailure([super.message]);
}

// ... weitere Failure Types
```

### Exception Types
```dart
class ServerException implements Exception {
  const ServerException([this.message]);
  final String? message;

  @override
  String toString() => 'ServerException: ${message ?? 'Unknown server error'}';
}

class NetworkException implements Exception {
  const NetworkException([this.message]);
  final String? message;

  @override
  String toString() => 'NetworkException: ${message ?? 'Network error'}';
}

// ... weitere Exception Types
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

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isTablet = mediaQuery.size.width >= 768;
    final isDesktop = mediaQuery.size.width >= 1024;
    
    Widget bodyWidget = body;
    
    // Responsive constraints
    if (isDesktop) {
      bodyWidget = Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: bodyWidget,
        ),
      );
    } else if (isTablet) {
      bodyWidget = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: bodyWidget,
      );
    }
    
    return Scaffold(
      appBar: title != null ? AppBar(title: Text(title!)) : null,
      body: safeArea ? SafeArea(child: bodyWidget) : bodyWidget,
      floatingActionButton: floatingActionButton,
    );
  }
}
```

### Theme System
```dart
enum ThemeType { light, dark, custom }

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeState());

  void changeTheme(ThemeType themeType) {
    emit(state.copyWith(themeType: themeType));
    // Save to local storage
  }

  void toggleTheme() {
    final newTheme = switch (state.themeType) {
      ThemeType.light => ThemeType.dark,
      ThemeType.dark => ThemeType.custom,
      ThemeType.custom => ThemeType.light,
    };
    changeTheme(newTheme);
  }
}
```

## 📁 Feature Template Structure

### Für jedes neue Feature:

```
feature_name/
├── data/
│   ├── datasources/
│   │   └── feature_remote_datasource.dart
│   ├── models/
│   │   └── feature_model.dart
│   └── repositories/
│       └── feature_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── feature_entity.dart
│   ├── repositories/
│   │   └── feature_repository.dart
│   └── usecases/
│       ├── get_features_usecase.dart
│       ├── get_feature_by_id_usecase.dart
│       ├── create_feature_usecase.dart
│       ├── update_feature_usecase.dart
│       ├── delete_feature_usecase.dart
│       └── search_features_usecase.dart
└── presentation/
    ├── cubit/
    │   ├── feature_cubit.dart
    │   └── feature_state.dart
    ├── pages/
    │   ├── feature_list_page.dart
    │   └── feature_detail_page.dart
    └── widgets/
        └── feature_list_item.dart
```

## 🔧 Development Commands

### Code Generation
```bash
# Generate all code (models, DI, etc.)
flutter packages pub run build_runner build --delete-conflicting-outputs

# Generate localization files
flutter gen-l10n

# Clean ARB files
dart run scripts/clean_arb_files.dart
```

### Testing
```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage
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

### Code Quality Checks
- **Linting**: `flutter_lints` für Code-Qualität
- **Type Safety**: Null Safety aktiviert
- **Build Runner**: Regelmäßige Code-Generierung
- **Testing**: Unit Tests für Business Logic

## 📚 Implemented Features

### Core Features (17 Total)
1. **user** - User Management
2. **auth** - Authentication & Authorization  
3. **profile** - User Profiles & Settings
4. **chat** - Real-time Messaging
5. **forum** - Discussion Forums
6. **livestream** - Live Streaming
7. **media** - Photo/Video Management
8. **learning_hub** - Educational Content
9. **shop** - Product Catalog
10. **sponsorship** - Sponsorship Requests
11. **coin_system** - Virtual Currency
12. **support** - Customer Support
13. **partners** - Partner Management
14. **membership** - Membership System
15. **legal_settings** - Legal Compliance
16. **admin_panel** - Administration
17. **admin_panel** - Admin Interface

## 🚀 Getting Started Template

### Neues Feature erstellen:

1. **Feature Ordner erstellen:**
```bash
mkdir -p lib/features/new_feature/{data/{datasources,models,repositories},domain/{entities,repositories,usecases},presentation/{cubit,pages,widgets}}
```

2. **Entity definieren** (Domain Layer)
3. **Repository Interface erstellen** (Domain Layer)  
4. **Use Cases implementieren** (Domain Layer)
5. **Model mit Freezed erstellen** (Data Layer)
6. **DataSource implementieren** (Data Layer)
7. **Repository implementieren** (Data Layer)
8. **State und Cubit erstellen** (Presentation Layer)
9. **Pages und Widgets erstellen** (Presentation Layer)
10. **Dependency Injection registrieren**
11. **Build Runner ausführen**

Diese Anleitung dient als umfassende Referenz für die Entwicklung neuer Features und das Training von AI-Agenten auf Basis der etablierten Architektur und Patterns.