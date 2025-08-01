# Auto-Detect PRDs Task

## Purpose
Automatically detect PRD files based on pattern matching and trigger the complete BMAD workflow without manual Planning Phase.

## Usage
```bash
@po auto-detect-prds
```

## Process

### Step 1: Scan for PRD Files
1. **Scan configured directories** from core-config.yaml `autoWorkflow.scanDirectories`
2. **Look for files matching patterns**:
   - `*_prd.md` (e.g., `livestream_prd.md`, `payment_prd.md`)
   - `*_requirements.md`
   - `*_feature.md`
3. **List found files** and ask user for confirmation

### Step 2: Process Each PRD File
For each detected PRD file:

1. **Validate PRD Structure**:
   - Check for required sections (Features, Acceptance Criteria, etc.)
   - Ensure proper markdown formatting
   - Validate completeness

2. **Auto-Shard Document**:
   ```bash
   md-tree explode {prd_file} docs/prd/{feature_name}
   ```

3. **Create Feature Directory Structure**:
   ```
   docs/
   ├── prd/
   │   └── {feature_name}/
   │       ├── overview.md
   │       ├── features.md
   │       ├── acceptance-criteria.md
   │       └── technical-requirements.md
   └── stories/
       └── {feature_name}/
   ```

### Step 3: Auto-Generate Stories
1. **Extract Epics** from sharded PRD sections
2. **Generate User Stories** from each epic
3. **Create Story Files** in `docs/stories/{feature_name}/`
4. **Apply Flutter-specific patterns** if Flutter extension detected

### Step 4: Trigger Development Workflow
1. **Notify SM** that stories are ready
2. **Auto-start Flutter UI-First Workflow** if configured
3. **Create initial todo.md** for development tracking

## Example Workflow

### Input Files:
```
docs/
├── livestream_prd.md
├── payment_prd.md
└── user_profile_prd.md
```

### Command:
```bash
@po auto-detect-prds
```

### Output:
```
Found 3 PRD files:
1. livestream_prd.md → Livestream Feature
2. payment_prd.md → Payment Integration  
3. user_profile_prd.md → User Profile Management

Processing livestream_prd.md...
✅ Sharded to docs/prd/livestream/
✅ Generated 4 stories in docs/stories/livestream/
✅ Ready for development

Processing payment_prd.md...
✅ Sharded to docs/prd/payment/
✅ Generated 6 stories in docs/stories/payment/
✅ Ready for development

Processing user_profile_prd.md...
✅ Sharded to docs/prd/user_profile/
✅ Generated 3 stories in docs/stories/user_profile/
✅ Ready for development

🚀 All PRDs processed! Ready to start development with:
@sm start-next-story
```

## PRD File Requirements

Your `*_prd.md` files should contain:

```markdown
# Feature Name PRD

## Overview
Brief description of the feature

## Features
- Feature 1: Description
- Feature 2: Description
- Feature 3: Description

## Acceptance Criteria
### Feature 1
- [ ] Criteria 1
- [ ] Criteria 2

### Feature 2
- [ ] Criteria 1
- [ ] Criteria 2

## Technical Requirements
- Flutter Clean Architecture
- Cubit State Management
- Repository Pattern
- Unit Tests Required

## User Stories
### Epic: Feature Implementation
- As a user I want to... so that...
- As a user I want to... so that...

## Dependencies
- Backend API endpoints
- Third-party integrations
- Design assets
```

## Configuration

Enable in `core-config.yaml`:
```yaml
autoWorkflow:
  enabled: true
  scanDirectories: 
    - "docs/"
    - "features/"
  triggerPatterns:
    - "*_prd.md"
    - "*_requirements.md"
```

## Flutter-Specific Integration

When Flutter extension is detected, automatically:
1. **Apply Flutter story templates**
2. **Set up UI-First workflow**  
3. **Configure Clean Architecture patterns**
4. **Prepare Cubit state management structure**

This task bridges the gap between existing documentation and BMAD's development workflow, perfect for Brownfield projects!