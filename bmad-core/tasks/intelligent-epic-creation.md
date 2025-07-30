# Intelligent AppIQ Project Creation Task

## 📋 Overview
This task provides an intelligent, guided approach to project creation that automatically detects project context and guides users through the optimal workflow.

## 🎯 Task Objectives
- Automatically detect project type (Greenfield vs Brownfield)
- Analyze existing tech stack and project structure
- Guide user through PRD creation or validation
- Launch appropriate architecture workflow
- Set up optimal development environment

## 🤖 Execution Workflow

### Phase 1: Project Context Detection

#### Step 1: Analyze Current Environment
```bash
# Check for existing project indicators
- package.json (Node.js/React/Vue/Angular)
- pubspec.yaml (Flutter)
- requirements.txt (Python)
- Cargo.toml (Rust)
- go.mod (Go)
- composer.json (PHP)
```

#### Step 2: Detect Project Type
**Ask user to confirm detection:**

> 🔍 **Project Analysis Complete**
> 
> I've detected the following about your project:
> - **Project Type**: [Greenfield/Brownfield]
> - **Tech Stack**: [Detected frameworks and tools]
> - **Structure**: [Monorepo/Multi-repo/Single app]
> 
> Is this correct? (Y/n)

### Phase 2: PRD Workflow Selection

#### For Greenfield Projects:
1. **Check for existing PRD**:
   - Look for `docs/prd.md`
   - Look for `docs/requirements.md`
   - Look for any `.md` files with PRD content

2. **If no PRD exists**:
   > 📝 **PRD Creation Required**
   > 
   > I don't see a PRD (Product Requirements Document) in your project.
   > 
   > Options:
   > 1. **Quick Start**: I'll guide you through creating a PRD interactively
   > 2. **Upload Existing**: You have a PRD file to upload
   > 3. **Skip for Now**: Start with basic architecture (not recommended)
   > 
   > What would you like to do? (1/2/3)

3. **If PRD exists**:
   > ✅ **PRD Found**
   > 
   > I found your PRD at `docs/prd.md`. Let me validate it meets BMAD requirements...
   > 
   > [Analysis results]
   > 
   > Would you like to:
   > 1. **Continue with existing PRD**
   > 2. **Update/enhance the PRD**
   > 3. **Create a new PRD**

#### For Brownfield Projects:
1. **Analyze existing codebase**:
   - Detect current architecture patterns
   - Identify existing components and services
   - Analyze database schemas and API endpoints
   - Check for existing documentation

2. **Generate brownfield analysis**:
   > 🔍 **Brownfield Analysis Complete**
   > 
   > **Detected Architecture**: [Clean Architecture/MVC/Layered/etc.]
   > **Key Components**: [List of major components]
   > **Database**: [Detected database type and schema]
   > **API Style**: [REST/GraphQL/tRPC]
   > 
   > I'll help you create a PRD that aligns with your existing architecture.

### Phase 3: Architecture Workflow

#### Step 1: Architecture Agent Selection
Based on detected tech stack, automatically select the appropriate architecture agent:

- **Flutter Projects** → `flutter-mobile-architecture-tmpl.yaml`
- **React/Vue/Angular** → `front-end-architecture-tmpl.yaml`
- **Full Stack** → `fullstack-architecture-tmpl.yaml`
- **Backend Only** → `architecture-tmpl.yaml`
- **Brownfield** → `brownfield-architecture-tmpl.yaml`

#### Step 2: Launch Architecture Creation
> 🏗️ **Architecture Setup**
> 
> Based on your tech stack, I'm launching the **[Architecture Type]** workflow.
> 
> This will create a comprehensive architecture document that includes:
> - Technology stack decisions
> - Component architecture
> - Database design
> - API specifications
> - Development workflow
> 
> Ready to proceed? (Y/n)

### Phase 4: Development Environment Setup

#### Step 1: Agent Team Configuration
Automatically configure the optimal agent team based on project type:

**For Flutter Projects**:
```yaml
agents:
  - bmad-orchestrator
  - analyst (if needed)
  - pm
  - architect
  - po
  - flutter-ui-agent
  - flutter-cubit-agent
  - flutter-domain-agent
  - flutter-data-agent
  - shared-components-agent
  - qa
  - sm
```

**For Web Projects**:
```yaml
agents:
  - bmad-orchestrator
  - analyst (if needed)
  - pm
  - architect
  - po
  - dev
  - qa
  - sm
```

#### Step 2: Workflow Initialization
> ⚙️ **Development Environment Setup**
> 
> I'm configuring your development environment:
> 
> ✅ Agent team configured for [Project Type]
> ✅ Workflow templates selected
> ✅ Quality gates established
> ✅ Security validation enabled
> 
> **Next Steps**:
> 1. PRD creation/validation
> 2. Architecture document generation
> 3. Epic and story creation
> 4. Development workflow initiation

### Phase 5: Smart Guidance

#### Provide Context-Aware Next Steps
> 🎯 **Ready to Start Development**
> 
> Your BMAD environment is configured! Here's what happens next:
> 
> **Immediate Actions**:
> 1. **PRD Review**: [If needed] Review and approve your PRD
> 2. **Architecture Creation**: Generate your architecture document
> 3. **Epic Planning**: Break down your PRD into actionable epics
> 
> **Development Workflow**:
> 1. **Story Creation**: SM agent will create detailed development stories
> 2. **Development**: Dev agents will implement features following Clean Architecture
> 3. **Quality Assurance**: QA agent will validate all implementations
> 
> **Commands Available**:
> - `/story` - Create a new development story
> - `/analyze` - Analyze current project status
> - `/help` - Get context-aware help
> 
> Would you like me to start with PRD creation? (Y/n)

## 🔧 Implementation Details

### Tech Stack Detection Logic
```typescript
interface ProjectContext {
  type: 'greenfield' | 'brownfield';
  techStack: {
    frontend?: 'react' | 'vue' | 'angular' | 'flutter' | 'vanilla';
    backend?: 'node' | 'python' | 'go' | 'rust' | 'php' | 'firebase' | 'supabase';
    database?: 'postgresql' | 'mysql' | 'mongodb' | 'sqlite' | 'firestore';
    stateManagement?: 'redux' | 'zustand' | 'cubit' | 'bloc' | 'vuex' | 'pinia';
  };
  structure: 'monorepo' | 'multi-repo' | 'single-app';
  hasExistingDocs: boolean;
  hasBMAD: boolean;
}
```

### Intelligent Defaults
- **Flutter Projects**: Enable Clean Architecture, Cubit state management, multi-language support
- **React Projects**: Enable TypeScript, modern hooks, component-based architecture
- **Full Stack**: Enable shared types, API-first design, comprehensive testing
- **Brownfield**: Respect existing patterns while introducing BMAD workflows

### Error Prevention
- Validate PRD completeness before architecture creation
- Check for conflicting dependencies
- Ensure proper folder structure
- Validate agent compatibility with tech stack

## 📋 Success Criteria
- [ ] Project type correctly detected
- [ ] Tech stack accurately identified
- [ ] Appropriate workflow selected and configured
- [ ] User guided through each step with clear options
- [ ] Development environment properly initialized
- [ ] Clear next steps provided
- [ ] All quality gates established
- [ ] Security validation enabled

## 🎯 User Experience Goals
- **Zero Configuration**: Works out of the box with intelligent defaults
- **Progressive Disclosure**: Only shows relevant options based on context
- **Error Prevention**: Validates inputs and prevents common mistakes
- **Clear Guidance**: Provides clear next steps at every stage
- **Flexibility**: Allows overrides of automatic detection when needed