# Smart Auto-Detect PRDs Task

## Purpose
Intelligently detect PRD files, analyze existing codebase, and determine optimal implementation paths while maximizing code reuse.

## Usage
```bash
@po smart-auto-detect-prds
```

## Enhanced Process

### Step 1: PRD Discovery & Analysis
1. **Scan for PRD Files** matching patterns:
   - `*_prd.md`
   - `*_requirements.md` 
   - `*_feature.md`

2. **Parse PRD Content**:
   - Extract feature name
   - Parse implementation paths (if specified)
   - Identify UI reference assets
   - Extract integration points
   - Parse code reuse requirements

### Step 2: Codebase Analysis
For each detected PRD:

#### A. Existing Code Scan
```bash
# 1. Find similar features
find lib/features/ -type d -name "*{feature_keyword}*"

# 2. Scan shared components  
find lib/shared/ -name "*.dart" | xargs grep -l "{relevant_keywords}"

# 3. Check existing services
find lib/shared/services/ lib/core/services/ -name "*.dart"

# 4. Analyze existing patterns
find lib/features/ -name "*_cubit.dart" -o -name "*_repository.dart" -o -name "*_usecase.dart"
```

#### B. Dependency Analysis
```bash
# Check pubspec.yaml for existing packages
grep -E "(http|dio|cached_network_image|shared_preferences)" pubspec.yaml

# Analyze DI container
grep -n "registerLazySingleton\|registerFactory" lib/core/di/injection_container.dart

# Check existing API endpoints
find lib/features/*/data/datasources/ -name "*_remote_datasource.dart" -exec grep -l "http" {} \;
```

#### C. UI Component Analysis
```bash
# Find reusable widgets
find lib/shared/widgets/ -name "*.dart" | sort

# Check existing page structures
find lib/features/*/presentation/pages/ -name "*.dart"

# Analyze existing themes and styles
find lib/shared/theme/ lib/core/theme/ -name "*.dart"
```

### Step 3: Smart Path Resolution

#### If Implementation Paths Specified in PRD:
1. **Validate Specified Paths**:
   - Check if directories exist
   - Verify no conflicts with existing files
   - Ensure paths follow project conventions

2. **Integration Point Validation**:
   - Verify specified existing files exist
   - Check if integration points are compatible
   - Validate shared component references

#### If No Paths Specified - Architect Mode:
1. **Feature Complexity Analysis**:
   ```markdown
   Analyzing feature: {feature_name}
   
   Complexity Factors:
   - [ ] Number of screens: {count}
   - [ ] External dependencies: {list}
   - [ ] Database changes needed: {yes/no}
   - [ ] New API endpoints: {count}
   - [ ] Shared state requirements: {yes/no}
   
   Recommendation: {simple_integration|new_feature|shared_component}
   ```

2. **Automatic Path Generation**:
   ```bash
   # For new features
   mkdir -p lib/features/{feature_name}/{data,domain,presentation}
   
   # For simple integrations
   # Add to existing feature folder
   
   # For shared components
   mkdir -p lib/shared/{widgets,services,utils}/{feature_name}
   ```

### Step 4: Code Reuse Optimization

#### Existing Component Mapping:
```markdown
Found Reusable Components for {feature_name}:

UI Components:
✅ lib/shared/widgets/custom_button.dart - Can be used for {action_buttons}
✅ lib/shared/widgets/loading_widget.dart - For loading states
❌ Need new: {specific_widget} - No existing equivalent found

Services:
✅ lib/shared/services/api_service.dart - Can be extended for {api_calls}
✅ lib/shared/services/navigation_service.dart - For navigation
❌ Need new: {specific_service} - No existing equivalent found

Utilities:
✅ lib/shared/utils/validators.dart - For input validation
✅ lib/shared/utils/formatters.dart - For data formatting
❌ Need new: {specific_utility} - No existing equivalent found
```

#### Integration Strategy:
```markdown
Integration Plan for {feature_name}:

1. Extend Existing:
   - {existing_cubit} → Add {new_states}
   - {existing_repository} → Add {new_methods}
   - {existing_service} → Add {new_functionality}

2. Create New:
   - {new_entity} → lib/features/{feature}/domain/entities/
   - {new_usecase} → lib/features/{feature}/domain/usecases/
   - {new_widget} → lib/features/{feature}/presentation/widgets/

3. Shared Enhancements:
   - Add {new_shared_widget} → lib/shared/widgets/
   - Extend {existing_theme} → lib/shared/theme/
```

### Step 5: UI Reference Processing

#### Asset Organization:
```bash
# Create asset directories if specified
mkdir -p assets/images/{feature_name}
mkdir -p assets/icons/{feature_name}

# Validate referenced assets exist
for asset in {ui_reference_assets}; do
  if [[ -f "$asset" ]]; then
    echo "✅ Found: $asset"
  else
    echo "❌ Missing: $asset - Please add this asset"
  fi
done
```

#### UI Pattern Analysis:
```markdown
UI Pattern Analysis for {feature_name}:

Similar Existing Patterns:
✅ {existing_feature}/presentation/pages/{page}.dart - Similar layout structure
✅ {existing_feature}/presentation/widgets/{widget}.dart - Similar component pattern

Recommended UI Approach:
- Base Layout: Extend {existing_scaffold_pattern}
- Components: Reuse {existing_widget_pattern}
- Styling: Follow {existing_theme_pattern}
- Navigation: Use {existing_navigation_pattern}
```

### Step 6: Enhanced Story Generation

#### Context-Aware Stories:
```markdown
Generated Stories for {feature_name}:

Story 1: Setup Infrastructure
- Extend {existing_repository} with {new_methods}
- Add {new_entity} following {existing_pattern}
- Register dependencies in {existing_di_container}

Story 2: UI Implementation  
- Create {new_page} extending {existing_base_page}
- Reuse {existing_shared_widgets}
- Follow {existing_theme_patterns}

Story 3: Integration
- Connect to {existing_navigation}
- Integrate with {existing_services}
- Add to {existing_routing}
```

### Step 7: Architect Consultation

#### When Architect Input Needed:
```bash
@architect analyze-implementation-strategy {feature_name}
```

**Triggers for Architect Consultation**:
- Complex cross-feature dependencies detected
- No clear existing patterns found
- Conflicting implementation approaches possible
- Major architectural changes suggested

#### Architect Analysis Output:
```markdown
Architect Analysis for {feature_name}:

Current Architecture Assessment:
- Existing patterns: {list}
- Architectural constraints: {list}
- Integration challenges: {list}

Recommended Approach:
1. Implementation Strategy: {detailed_strategy}
2. File Structure: {recommended_structure}
3. Integration Points: {specific_integration_points}
4. Risk Mitigation: {potential_issues_and_solutions}

Code Reuse Opportunities:
- {existing_component} can be extended for {new_functionality}
- {existing_pattern} should be followed for consistency
- {existing_service} can be enhanced with {new_methods}
```

## Example Enhanced Workflow

### Input: `livestream_prd.md` with Implementation Paths
```markdown
## Implementation Paths
### Suggested File Structure
lib/features/livestream/...

### Integration Points  
- Existing Pages: lib/features/home/presentation/pages/home_page.dart
- Shared Services: lib/shared/services/api_service.dart

### UI References
assets/images/livestream/mockup_main_screen.png
```

### Auto-Analysis Output:
```markdown
🔍 Analyzing livestream_prd.md...

📁 Path Analysis:
✅ lib/features/livestream/ - Path available
✅ Integration with home_page.dart - Compatible
✅ api_service.dart - Can be extended

🔍 Codebase Scan Results:
Found Similar Features:
- lib/features/video_player/ - 67% similarity
- lib/features/chat/ - 45% similarity

Reusable Components:
✅ lib/shared/widgets/video_controller.dart - Perfect for stream controls
✅ lib/shared/services/websocket_service.dart - Can handle chat
❌ Need new: Stream management service

📱 UI Analysis:
✅ Found: assets/images/livestream/mockup_main_screen.png
✅ Existing video player patterns can be extended
✅ Chat UI patterns exist in lib/features/chat/

🚀 Generated Implementation Plan:
1. Extend existing video_player patterns
2. Reuse chat UI components  
3. Create new stream management service
4. Integrate with existing navigation

Ready for development! 
```

## Configuration

Enable in `core-config.yaml`:
```yaml
smartAnalysis:
  enabled: true
  codebaseAnalysis: true
  architectConsultation: true
  uiReferenceProcessing: true
  reuseOptimization: true
```

This creates an intelligent system that maximizes code reuse and ensures optimal implementation paths! 🧠✨