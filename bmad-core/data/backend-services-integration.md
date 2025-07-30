# Backend Services Integration Guide

## 📋 Overview

This guide provides comprehensive integration instructions for modern backend services including Firebase, Supabase, and traditional backend solutions with MCP tool integration for enhanced development workflows.

## 🔥 Firebase Integration

### Firebase Services Overview

Firebase provides a comprehensive suite of backend services:
- **Authentication**: Multi-provider authentication system
- **Firestore**: NoSQL document database with real-time updates
- **Realtime Database**: Real-time synchronized database
- **Storage**: File storage and management
- **Functions**: Serverless backend logic
- **Hosting**: Web application hosting
- **Analytics**: User behavior analytics
- **Crashlytics**: Crash reporting and analysis

### Firebase Setup

#### 1. Project Configuration
```javascript
// firebase.config.js
import { initializeApp } from 'firebase/app';
import { getAuth } from 'firebase/auth';
import { getFirestore } from 'firebase/firestore';
import { getStorage } from 'firebase/storage';
import { getFunctions } from 'firebase/functions';

const firebaseConfig = {
  apiKey: process.env.NEXT_PUBLIC_FIREBASE_API_KEY,
  authDomain: process.env.NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN,
  projectId: process.env.NEXT_PUBLIC_FIREBASE_PROJECT_ID,
  storageBucket: process.env.NEXT_PUBLIC_FIREBASE_STORAGE_BUCKET,
  messagingSenderId: process.env.NEXT_PUBLIC_FIREBASE_MESSAGING_SENDER_ID,
  appId: process.env.NEXT_PUBLIC_FIREBASE_APP_ID
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);

// Initialize Firebase services
export const auth = getAuth(app);
export const db = getFirestore(app);
export const storage = getStorage(app);
export const functions = getFunctions(app);

export default app;
```

#### 2. Authentication Service
```typescript
// services/firebase-auth.service.ts
import { 
  signInWithEmailAndPassword,
  createUserWithEmailAndPassword,
  signOut,
  onAuthStateChanged,
  GoogleAuthProvider,
  signInWithPopup
} from 'firebase/auth';
import { auth } from '../config/firebase.config';

export class FirebaseAuthService {
  // Email/Password Authentication
  async signInWithEmail(email: string, password: string) {
    try {
      const userCredential = await signInWithEmailAndPassword(auth, email, password);
      return { user: userCredential.user, error: null };
    } catch (error) {
      return { user: null, error: error.message };
    }
  }

  async signUpWithEmail(email: string, password: string) {
    try {
      const userCredential = await createUserWithEmailAndPassword(auth, email, password);
      return { user: userCredential.user, error: null };
    } catch (error) {
      return { user: null, error: error.message };
    }
  }

  // Google Authentication
  async signInWithGoogle() {
    try {
      const provider = new GoogleAuthProvider();
      const userCredential = await signInWithPopup(auth, provider);
      return { user: userCredential.user, error: null };
    } catch (error) {
      return { user: null, error: error.message };
    }
  }

  // Sign Out
  async signOut() {
    try {
      await signOut(auth);
      return { success: true, error: null };
    } catch (error) {
      return { success: false, error: error.message };
    }
  }

  // Auth State Observer
  onAuthStateChange(callback: (user: any) => void) {
    return onAuthStateChanged(auth, callback);
  }
}
```

#### 3. Firestore Database Service
```typescript
// services/firebase-firestore.service.ts
import {
  collection,
  doc,
  getDocs,
  getDoc,
  addDoc,
  updateDoc,
  deleteDoc,
  query,
  where,
  orderBy,
  limit,
  onSnapshot
} from 'firebase/firestore';
import { db } from '../config/firebase.config';

export class FirestoreService<T> {
  constructor(private collectionName: string) {}

  // Create document
  async create(data: Omit<T, 'id'>): Promise<string> {
    try {
      const docRef = await addDoc(collection(db, this.collectionName), data);
      return docRef.id;
    } catch (error) {
      throw new Error(`Failed to create document: ${error.message}`);
    }
  }

  // Get all documents
  async getAll(): Promise<T[]> {
    try {
      const querySnapshot = await getDocs(collection(db, this.collectionName));
      return querySnapshot.docs.map(doc => ({
        id: doc.id,
        ...doc.data()
      } as T));
    } catch (error) {
      throw new Error(`Failed to get documents: ${error.message}`);
    }
  }

  // Get document by ID
  async getById(id: string): Promise<T | null> {
    try {
      const docRef = doc(db, this.collectionName, id);
      const docSnap = await getDoc(docRef);
      
      if (docSnap.exists()) {
        return { id: docSnap.id, ...docSnap.data() } as T;
      }
      return null;
    } catch (error) {
      throw new Error(`Failed to get document: ${error.message}`);
    }
  }

  // Update document
  async update(id: string, data: Partial<T>): Promise<void> {
    try {
      const docRef = doc(db, this.collectionName, id);
      await updateDoc(docRef, data);
    } catch (error) {
      throw new Error(`Failed to update document: ${error.message}`);
    }
  }

  // Delete document
  async delete(id: string): Promise<void> {
    try {
      const docRef = doc(db, this.collectionName, id);
      await deleteDoc(docRef);
    } catch (error) {
      throw new Error(`Failed to delete document: ${error.message}`);
    }
  }

  // Real-time listener
  onSnapshot(callback: (data: T[]) => void) {
    const q = collection(db, this.collectionName);
    return onSnapshot(q, (querySnapshot) => {
      const data = querySnapshot.docs.map(doc => ({
        id: doc.id,
        ...doc.data()
      } as T));
      callback(data);
    });
  }

  // Query with filters
  async query(filters: { field: string; operator: any; value: any }[]): Promise<T[]> {
    try {
      let q = collection(db, this.collectionName);
      
      filters.forEach(filter => {
        q = query(q, where(filter.field, filter.operator, filter.value));
      });

      const querySnapshot = await getDocs(q);
      return querySnapshot.docs.map(doc => ({
        id: doc.id,
        ...doc.data()
      } as T));
    } catch (error) {
      throw new Error(`Failed to query documents: ${error.message}`);
    }
  }
}
```

### Firebase MCP Integration

```typescript
// MCP Firebase integration
interface FirebaseMCPIntegration {
  // Firebase project management
  createProject(config: FirebaseConfig): Promise<ProjectResult>;
  deployFunctions(functions: CloudFunction[]): Promise<DeploymentResult>;
  configureFirestore(rules: FirestoreRules): Promise<ConfigResult>;
  setupAuthentication(providers: AuthProvider[]): Promise<AuthSetupResult>;
  
  // Development helpers
  generateFirebaseConfig(): Promise<ConfigCode>;
  createServiceBoilerplate(service: FirebaseService): Promise<ServiceCode>;
  optimizeFirestoreQueries(queries: FirestoreQuery[]): Promise<OptimizationSuggestions>;
}
```

## 🚀 Supabase Integration

### Supabase Services Overview

Supabase provides an open-source Firebase alternative:
- **Database**: PostgreSQL with Row Level Security (RLS)
- **Authentication**: Multi-provider auth with JWT tokens
- **Storage**: File storage with CDN
- **Edge Functions**: Deno-based serverless functions
- **Real-time**: Real-time subscriptions
- **API**: Auto-generated REST and GraphQL APIs

### Supabase Setup

#### 1. Project Configuration
```typescript
// supabase.config.ts
import { createClient } from '@supabase/supabase-js';

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL!;
const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!;

export const supabase = createClient(supabaseUrl, supabaseAnonKey, {
  auth: {
    autoRefreshToken: true,
    persistSession: true,
    detectSessionInUrl: true
  }
});

// Type-safe database interface
export type Database = {
  public: {
    Tables: {
      users: {
        Row: {
          id: string;
          email: string;
          name: string;
          created_at: string;
          updated_at: string;
        };
        Insert: {
          id?: string;
          email: string;
          name: string;
          created_at?: string;
          updated_at?: string;
        };
        Update: {
          id?: string;
          email?: string;
          name?: string;
          updated_at?: string;
        };
      };
    };
  };
};
```

#### 2. Authentication Service
```typescript
// services/supabase-auth.service.ts
import { supabase } from '../config/supabase.config';

export class SupabaseAuthService {
  // Email/Password Authentication
  async signInWithEmail(email: string, password: string) {
    try {
      const { data, error } = await supabase.auth.signInWithPassword({
        email,
        password
      });
      return { user: data.user, session: data.session, error };
    } catch (error) {
      return { user: null, session: null, error: error.message };
    }
  }

  async signUpWithEmail(email: string, password: string) {
    try {
      const { data, error } = await supabase.auth.signUp({
        email,
        password
      });
      return { user: data.user, session: data.session, error };
    } catch (error) {
      return { user: null, session: null, error: error.message };
    }
  }

  // OAuth Authentication
  async signInWithProvider(provider: 'google' | 'github' | 'discord') {
    try {
      const { data, error } = await supabase.auth.signInWithOAuth({
        provider,
        options: {
          redirectTo: `${window.location.origin}/auth/callback`
        }
      });
      return { data, error };
    } catch (error) {
      return { data: null, error: error.message };
    }
  }

  // Sign Out
  async signOut() {
    try {
      const { error } = await supabase.auth.signOut();
      return { success: !error, error };
    } catch (error) {
      return { success: false, error: error.message };
    }
  }

  // Get current session
  async getSession() {
    try {
      const { data: { session }, error } = await supabase.auth.getSession();
      return { session, error };
    } catch (error) {
      return { session: null, error: error.message };
    }
  }

  // Auth state change listener
  onAuthStateChange(callback: (event: string, session: any) => void) {
    return supabase.auth.onAuthStateChange(callback);
  }
}
```

#### 3. Database Service
```typescript
// services/supabase-database.service.ts
import { supabase } from '../config/supabase.config';
import type { Database } from '../config/supabase.config';

type Tables = Database['public']['Tables'];

export class SupabaseService<T extends keyof Tables> {
  constructor(private tableName: T) {}

  // Create record
  async create(data: Tables[T]['Insert']) {
    try {
      const { data: result, error } = await supabase
        .from(this.tableName)
        .insert(data)
        .select()
        .single();
      
      if (error) throw error;
      return { data: result, error: null };
    } catch (error) {
      return { data: null, error: error.message };
    }
  }

  // Get all records
  async getAll() {
    try {
      const { data, error } = await supabase
        .from(this.tableName)
        .select('*');
      
      if (error) throw error;
      return { data, error: null };
    } catch (error) {
      return { data: null, error: error.message };
    }
  }

  // Get record by ID
  async getById(id: string) {
    try {
      const { data, error } = await supabase
        .from(this.tableName)
        .select('*')
        .eq('id', id)
        .single();
      
      if (error) throw error;
      return { data, error: null };
    } catch (error) {
      return { data: null, error: error.message };
    }
  }

  // Update record
  async update(id: string, data: Tables[T]['Update']) {
    try {
      const { data: result, error } = await supabase
        .from(this.tableName)
        .update(data)
        .eq('id', id)
        .select()
        .single();
      
      if (error) throw error;
      return { data: result, error: null };
    } catch (error) {
      return { data: null, error: error.message };
    }
  }

  // Delete record
  async delete(id: string) {
    try {
      const { error } = await supabase
        .from(this.tableName)
        .delete()
        .eq('id', id);
      
      if (error) throw error;
      return { success: true, error: null };
    } catch (error) {
      return { success: false, error: error.message };
    }
  }

  // Real-time subscription
  subscribe(callback: (payload: any) => void) {
    return supabase
      .channel(`public:${this.tableName}`)
      .on('postgres_changes', 
        { event: '*', schema: 'public', table: this.tableName },
        callback
      )
      .subscribe();
  }

  // Query with filters
  async query(filters: { column: string; operator: string; value: any }[]) {
    try {
      let query = supabase.from(this.tableName).select('*');
      
      filters.forEach(filter => {
        query = query.filter(filter.column, filter.operator, filter.value);
      });

      const { data, error } = await query;
      if (error) throw error;
      return { data, error: null };
    } catch (error) {
      return { data: null, error: error.message };
    }
  }
}
```

### Supabase MCP Integration

```typescript
// MCP Supabase integration
interface SupabaseMCPIntegration {
  // Project management
  createProject(config: SupabaseConfig): Promise<ProjectResult>;
  generateTypes(databaseUrl: string): Promise<TypeDefinitions>;
  setupRLS(policies: RLSPolicy[]): Promise<PolicyResult>;
  deployEdgeFunctions(functions: EdgeFunction[]): Promise<DeploymentResult>;
  
  // Development helpers
  generateSupabaseClient(): Promise<ClientCode>;
  createServiceBoilerplate(table: string): Promise<ServiceCode>;
  optimizeQueries(queries: SupabaseQuery[]): Promise<OptimizationSuggestions>;
}
```

## 🏗️ Traditional Backend Integration

### Node.js + Express Setup

```typescript
// server.ts
import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import rateLimit from 'express-rate-limit';
import { authRouter } from './routes/auth.routes';
import { userRouter } from './routes/user.routes';

const app = express();

// Security middleware
app.use(helmet());
app.use(cors({
  origin: process.env.FRONTEND_URL,
  credentials: true
}));

// Rate limiting
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100 // limit each IP to 100 requests per windowMs
});
app.use(limiter);

// Body parsing
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true }));

// Routes
app.use('/api/auth', authRouter);
app.use('/api/users', userRouter);

// Error handling middleware
app.use((err: any, req: any, res: any, next: any) => {
  console.error(err.stack);
  res.status(500).json({ error: 'Something went wrong!' });
});

const PORT = process.env.PORT || 3001;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
```

### Database Integration (PostgreSQL)

```typescript
// database/connection.ts
import { Pool } from 'pg';

const pool = new Pool({
  user: process.env.DB_USER,
  host: process.env.DB_HOST,
  database: process.env.DB_NAME,
  password: process.env.DB_PASSWORD,
  port: parseInt(process.env.DB_PORT || '5432'),
  ssl: process.env.NODE_ENV === 'production' ? { rejectUnauthorized: false } : false
});

export class DatabaseService {
  async query(text: string, params?: any[]) {
    const client = await pool.connect();
    try {
      const result = await client.query(text, params);
      return result;
    } finally {
      client.release();
    }
  }

  async transaction(queries: { text: string; params?: any[] }[]) {
    const client = await pool.connect();
    try {
      await client.query('BEGIN');
      const results = [];
      
      for (const query of queries) {
        const result = await client.query(query.text, query.params);
        results.push(result);
      }
      
      await client.query('COMMIT');
      return results;
    } catch (error) {
      await client.query('ROLLBACK');
      throw error;
    } finally {
      client.release();
    }
  }
}
```

## 🔧 MCP Tool Integration

### Backend Service Selection

```typescript
// MCP integration for backend service selection
interface BackendServiceMCP {
  analyzeRequirements(requirements: ProjectRequirements): Promise<ServiceRecommendation>;
  compareServices(services: BackendService[]): Promise<ComparisonMatrix>;
  generateIntegration(service: BackendService): Promise<IntegrationCode>;
  optimizeConfiguration(config: ServiceConfig): Promise<OptimizedConfig>;
}

// Usage example
const mcp = new BackendServiceMCP();

const recommendation = await mcp.analyzeRequirements({
  scalability: 'high',
  realtime: true,
  authentication: 'multi-provider',
  database: 'relational',
  budget: 'medium'
});

// Recommendation might suggest Supabase for this combination
```

### Code Generation

```typescript
// Automated service integration code generation
interface CodeGenerationMCP {
  generateAuthService(provider: AuthProvider): Promise<ServiceCode>;
  generateDatabaseService(schema: DatabaseSchema): Promise<ServiceCode>;
  generateAPIRoutes(endpoints: APIEndpoint[]): Promise<RouteCode>;
  generateMigrations(changes: SchemaChange[]): Promise<MigrationCode>;
}
```

## 📋 Best Practices

### Security
- **Environment Variables**: Store sensitive data in environment variables
- **Authentication**: Implement proper JWT token management
- **Authorization**: Use Row Level Security (RLS) for database access
- **Input Validation**: Validate all inputs on both client and server
- **Rate Limiting**: Implement rate limiting to prevent abuse
- **HTTPS**: Always use HTTPS in production
- **CORS**: Configure CORS properly for your domain

### Performance
- **Caching**: Implement caching strategies for frequently accessed data
- **Database Indexing**: Create proper database indexes
- **Connection Pooling**: Use connection pooling for database connections
- **CDN**: Use CDN for static assets
- **Compression**: Enable gzip compression
- **Monitoring**: Implement proper monitoring and logging

### Development Workflow
- **Type Safety**: Use TypeScript for type safety
- **Error Handling**: Implement comprehensive error handling
- **Testing**: Write unit and integration tests
- **Documentation**: Document APIs with OpenAPI/Swagger
- **Version Control**: Use semantic versioning for APIs
- **CI/CD**: Implement automated testing and deployment

### Cost Optimization
- **Resource Monitoring**: Monitor resource usage and costs
- **Auto-scaling**: Implement auto-scaling for variable loads
- **Cleanup**: Regular cleanup of unused resources
- **Optimization**: Regular performance and cost optimization reviews

This comprehensive guide ensures proper integration of modern backend services with the BMAD framework, providing developers with the tools and knowledge needed to build scalable, secure, and maintainable applications.