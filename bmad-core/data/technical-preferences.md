# User-Defined Preferred Patterns and Preferences

## Frontend Frameworks

### Web Development
- **React**: Latest stable version with TypeScript
- **Next.js**: Full-stack React framework with App Router
- **Vue 3**: Composition API with TypeScript
- **Angular**: Latest LTS version with standalone components
- **Svelte/SvelteKit**: Modern reactive framework

### UI Component Libraries
- **shadcn/ui**: Modern React components with Tailwind CSS
- **Material UI**: React components following Material Design
- **Ant Design**: Enterprise-class UI design language
- **Chakra UI**: Modular and accessible component library
- **Headless UI**: Unstyled, accessible UI components

### CSS Frameworks
- **Tailwind CSS**: Utility-first CSS framework
- **CSS Modules**: Localized CSS
- **Styled Components**: CSS-in-JS library
- **Emotion**: Performant and flexible CSS-in-JS

## Mobile Development

### Flutter
- **Framework**: Flutter 3.24+ with Dart 3.5+
- **State Management**: Cubit/BLoC pattern with flutter_bloc
- **Architecture**: Clean Architecture with dependency injection
- **Code Generation**: Freezed + json_serializable + injectable
- **Networking**: Dio HTTP client
- **Local Storage**: Hive for complex data, SharedPreferences for simple data
- **Routing**: GoRouter for declarative routing
- **Localization**: flutter_localizations with ARB files
- **Testing**: flutter_test + bloc_test + mocktail

## Backend Services

### Firebase
- **Authentication**: Firebase Auth with multi-provider support
- **Database**: Firestore for NoSQL, Realtime Database for real-time features
- **Storage**: Firebase Storage for file uploads
- **Functions**: Cloud Functions for serverless backend logic
- **Hosting**: Firebase Hosting for web deployment
- **Analytics**: Firebase Analytics and Crashlytics

### Supabase
- **Database**: PostgreSQL with Row Level Security (RLS)
- **Authentication**: Supabase Auth with social providers
- **Storage**: Supabase Storage for file management
- **Real-time**: Real-time subscriptions
- **Edge Functions**: Deno-based serverless functions
- **API**: Auto-generated REST and GraphQL APIs

### Traditional Backend
- **Node.js**: Express.js or Fastify with TypeScript
- **Python**: FastAPI or Django with type hints
- **Database**: PostgreSQL for relational, MongoDB for document-based
- **API**: REST with OpenAPI documentation or GraphQL

## Development Tools

### Build Tools
- **Vite**: Fast build tool for modern web development
- **Webpack**: Module bundler for complex configurations
- **Turbo**: High-performance build system for monorepos
- **esbuild**: Extremely fast JavaScript bundler

### State Management
- **Web**: Redux Toolkit, Zustand, or Valtio
- **Mobile**: Cubit/BLoC for Flutter, Redux for React Native

### Testing
- **Unit Testing**: Jest, Vitest, or Flutter Test
- **Integration Testing**: Cypress, Playwright, or Flutter Integration Tests
- **E2E Testing**: Playwright or Detox for mobile

### Code Quality
- **Linting**: ESLint for JavaScript/TypeScript, flutter_lints for Flutter
- **Formatting**: Prettier for web, dart format for Flutter
- **Type Checking**: TypeScript strict mode, Dart null safety

## Architecture Patterns

### Clean Architecture
- **Presentation Layer**: UI components and state management
- **Domain Layer**: Business logic and entities
- **Data Layer**: Data sources and repository implementations
- **Infrastructure**: External services and frameworks

### Design Patterns
- **Repository Pattern**: Abstract data access
- **Dependency Injection**: Inversion of control
- **Observer Pattern**: State management and reactive programming
- **Factory Pattern**: Object creation
- **Singleton Pattern**: Shared services and utilities

## Security Preferences

### Authentication
- **Multi-factor Authentication**: Always enabled for production
- **OAuth 2.0**: Preferred for third-party authentication
- **JWT Tokens**: With proper expiration and refresh mechanisms
- **Biometric Authentication**: For mobile applications where applicable

### Data Protection
- **Encryption at Rest**: All sensitive data encrypted
- **Encryption in Transit**: HTTPS/TLS for all communication
- **Input Validation**: Server-side validation for all inputs
- **SQL Injection Prevention**: Parameterized queries or ORM

### API Security
- **Rate Limiting**: Prevent abuse and DoS attacks
- **CORS Configuration**: Proper cross-origin resource sharing
- **API Keys**: Secure API key management
- **Certificate Pinning**: For mobile applications

## Performance Preferences

### Web Performance
- **Core Web Vitals**: Optimize for LCP, FID, and CLS
- **Code Splitting**: Lazy loading for better performance
- **Image Optimization**: WebP format with fallbacks
- **Caching Strategy**: Service workers and CDN caching

### Mobile Performance
- **60 FPS**: Maintain smooth animations and scrolling
- **Memory Management**: Efficient memory usage and garbage collection
- **Battery Optimization**: Minimize battery drain
- **Offline Support**: Graceful offline functionality

## Localization Preferences

### Multi-language Support
- **Internationalization**: Built-in from project start
- **Translation Keys**: Descriptive and hierarchical
- **RTL Support**: Right-to-left language support
- **Date/Time Formatting**: Locale-specific formatting
- **Number Formatting**: Currency and number localization

## MCP Tool Integrations

### Available MCP Tools
- **@21st-dev/magic**: For shadcn/ui component generation and management
- **supabase-mcp**: For Supabase backend integration and management
- **firebase-mcp**: For Firebase services integration
- **sequential-thinking**: For complex problem analysis and decision making
- **dart-mcp**: For Dart code analysis and Flutter development assistance
