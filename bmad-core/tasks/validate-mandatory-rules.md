# Validate Mandatory Development Rules Task

## Purpose
Automatically validate that ALL mandatory development rules are being followed during development. This task MUST be run before any code is considered complete.

## Usage
```bash
@dev validate-mandatory-rules
@qa validate-mandatory-rules
```

## MANDATORY Validation Checklist

### 🚨 CRITICAL: Standard Workflow Validation
- [ ] **Plan Created**: `tasks/todo.md` exists with detailed, checkable items
- [ ] **Plan Verified**: User has approved the plan before coding started
- [ ] **Existing Code Checked**: Similar functionality was analyzed FIRST
- [ ] **Todo Items Tracked**: Items are being marked complete as work progresses
- [ ] **Explanations Provided**: High-level explanations given at each step
- [ ] **Simple Changes**: Minimal code impact - no massive refactors
- [ ] **Review Section Added**: Summary of changes in `todo.md`
- [ ] **Git Commits Made**: Proper commits after each completed task

### 🎯 MANDATORY: Quality Gates Validation (ALL 5 MUST PASS!)

#### 1. 🧹 DRY (Don't Repeat Yourself)
```bash
# Check for code duplication
find lib/ -name "*.dart" -exec grep -l "similar_pattern" {} \;

# Validate no duplicate widgets
find lib/shared/widgets/ -name "*.dart"
find lib/features/*/presentation/widgets/ -name "*similar*"

# Check for duplicate services
find lib/shared/services/ -name "*.dart"
find lib/features/*/data/datasources/ -name "*similar*"
```

**Validation Rules:**
- [ ] **No duplicate widgets** when shared widget exists
- [ ] **No duplicate services** when shared service exists
- [ ] **No duplicate utilities** when shared utility exists
- [ ] **No duplicate business logic** across features
- [ ] **Common functionality extracted** to shared components

#### 2. 📖 Readable
```bash
# Check for clear naming
grep -r "data\|info\|manager\|handler" lib/ --include="*.dart"

# Check method length (max 20 lines)
find lib/ -name "*.dart" -exec awk '/^[[:space:]]*[a-zA-Z].*{/{flag=1; count=0} flag{count++} /^[[:space:]]*}$/{if(flag && count>20) print FILENAME":"NR-count+1"-"NR; flag=0}' {} \;

# Check for comments explaining WHY
grep -r "// TODO\|// FIXME\|// HACK" lib/ --include="*.dart"
```

**Validation Rules:**
- [ ] **Method names** are descriptive and clear
- [ ] **Class names** follow single responsibility principle
- [ ] **Variable names** are self-documenting
- [ ] **Methods are small** (max 20 lines)
- [ ] **Comments explain WHY**, not WHAT

#### 3. 🔧 Maintainable
```bash
# Check Clean Architecture compliance
find lib/features/ -type d -name "data"
find lib/features/ -type d -name "domain" 
find lib/features/ -type d -name "presentation"

# Check dependency injection usage
grep -r "@injectable\|GetIt" lib/ --include="*.dart"

# Check proper imports (no cross-layer dependencies)
grep -r "import.*data.*" lib/features/*/domain/ --include="*.dart"
grep -r "import.*presentation.*" lib/features/*/domain/ --include="*.dart"
```

**Validation Rules:**
- [ ] **Clean Architecture layers** properly separated
- [ ] **No cross-layer dependencies** (domain doesn't import data/presentation)
- [ ] **Dependency injection** used consistently
- [ ] **Modular design** with clear boundaries
- [ ] **Single responsibility** principle followed

#### 4. ⚡ Performant
```bash
# Check for redundant API calls
grep -r "http\|api" lib/ --include="*.dart" | grep -v "test"

# Check for proper const constructors
grep -r "const.*(" lib/features/*/presentation/widgets/ --include="*.dart"

# Check for efficient list operations
grep -r "\.map(\|\.where(\|\.forEach(" lib/ --include="*.dart"
```

**Validation Rules:**
- [ ] **No redundant API calls** in repositories
- [ ] **Const constructors** used in widgets
- [ ] **Efficient algorithms** implemented
- [ ] **Proper caching** strategies used
- [ ] **Resource optimization** applied

#### 5. 🧪 Testable
```bash
# Check for unit tests
find test/ -name "*_test.dart" | wc -l
find lib/features/*/domain/usecases/ -name "*.dart" | wc -l

# Check for widget tests
find test/ -name "*_widget_test.dart" | wc -l
find lib/features/*/presentation/widgets/ -name "*.dart" | wc -l

# Check test coverage
flutter test --coverage
```

**Validation Rules:**
- [ ] **Unit tests** exist for all use cases
- [ ] **Widget tests** exist for all custom widgets
- [ ] **Repository tests** with proper mocking
- [ ] **Cubit tests** for all state management
- [ ] **Test coverage** meets minimum requirements (80%+)

### 📱 MANDATORY: Flutter-Specific Validation

#### Clean Architecture Compliance
```bash
# Validate folder structure
ls -la lib/features/*/data/datasources/
ls -la lib/features/*/data/models/
ls -la lib/features/*/data/repositories/
ls -la lib/features/*/domain/entities/
ls -la lib/features/*/domain/repositories/
ls -la lib/features/*/domain/usecases/
ls -la lib/features/*/presentation/cubit/
ls -la lib/features/*/presentation/pages/
ls -la lib/features/*/presentation/widgets/
```

**Validation Rules:**
- [ ] **Proper folder structure** following Clean Architecture
- [ ] **Entity classes** in domain layer
- [ ] **Model classes** in data layer with JSON serialization
- [ ] **Repository interfaces** in domain, implementations in data
- [ ] **Use cases** contain business logic
- [ ] **Cubits** handle state management
- [ ] **Pages and widgets** in presentation layer

#### Localization Compliance
```bash
# Check for static text (INSTANT FAILURE!)
grep -r "Text(\|text:\|title:\|label:" lib/features/ --include="*.dart" | grep -v "AppLocalizations\|context.l10n\|S.of"

# Check for localization usage
grep -r "AppLocalizations.of\|context.l10n\|S.of" lib/ --include="*.dart"

# Validate ARB files
find lib/l10n/ -name "*.arb"
```

**Validation Rules:**
- [ ] **NO static text** in any widget (INSTANT FAILURE if found!)
- [ ] **All text uses AppLocalizations** or equivalent
- [ ] **ARB files** contain all required keys
- [ ] **Localization keys** are descriptive and hierarchical
- [ ] **Placeholders** used for dynamic content

#### State Management Compliance
```bash
# Check Cubit usage
find lib/features/*/presentation/cubit/ -name "*_cubit.dart"
find lib/features/*/presentation/cubit/ -name "*_state.dart"

# Check for proper state classes
grep -r "extends Equatable" lib/features/*/presentation/cubit/ --include="*.dart"
grep -r "copyWith" lib/features/*/presentation/cubit/ --include="*.dart"
```

**Validation Rules:**
- [ ] **Cubit pattern** used for state management
- [ ] **State classes** extend Equatable
- [ ] **CopyWith methods** implemented
- [ ] **Proper state transitions** defined
- [ ] **Error handling** in state management

### 🔍 MANDATORY: Code Integration Validation

#### Existing Component Check
```bash
# Before creating new widgets
echo "Checking existing widgets..."
find lib/shared/widgets/ -name "*.dart" | sort

# Before creating new services  
echo "Checking existing services..."
find lib/shared/services/ -name "*.dart" | sort

# Before creating new utilities
echo "Checking existing utilities..."
find lib/shared/utils/ -name "*.dart" | sort
```

**Validation Rules:**
- [ ] **Existing widgets checked** before creating new ones
- [ ] **Existing services checked** before creating new ones
- [ ] **Existing utilities checked** before creating new ones
- [ ] **Similar features analyzed** for reusable patterns
- [ ] **Integration points identified** and utilized

#### Pattern Consistency Check
```bash
# Check naming conventions
find lib/ -name "*.dart" | grep -v "snake_case"
find lib/ -name "*.dart" -exec basename {} \; | grep -E "[A-Z]"

# Check class naming
grep -r "^class [a-z]" lib/ --include="*.dart"
grep -r "^class.*[_-]" lib/ --include="*.dart"
```

**Validation Rules:**
- [ ] **File names** use snake_case
- [ ] **Class names** use PascalCase  
- [ ] **Method names** use camelCase
- [ ] **Variable names** use camelCase
- [ ] **Constants** use SCREAMING_SNAKE_CASE

### 🚨 FAILURE CONDITIONS (INSTANT FAILURE!)

#### Critical Failures (Development STOPS immediately!)
```bash
# Check for static text (INSTANT FAILURE!)
if grep -r "Text('\|Text(\"\|title: '\|title: \"" lib/features/ --include="*.dart" | grep -v "AppLocalizations\|context.l10n\|S.of"; then
    echo "❌ INSTANT FAILURE: Static text found in UI!"
    exit 1
fi

# Check for code duplication (INSTANT FAILURE!)
if find lib/features/ -name "*.dart" -exec grep -l "duplicate_pattern" {} \; 2>/dev/null; then
    echo "❌ INSTANT FAILURE: Code duplication detected!"
    exit 1
fi

# Check for architecture violations (INSTANT FAILURE!)
if grep -r "import.*data.*" lib/features/*/domain/ --include="*.dart" 2>/dev/null; then
    echo "❌ INSTANT FAILURE: Domain layer importing data layer!"
    exit 1
fi

# Check for missing tests (INSTANT FAILURE!)
if [ $(find test/ -name "*_test.dart" | wc -l) -eq 0 ]; then
    echo "❌ INSTANT FAILURE: No tests found!"
    exit 1
fi
```

## Validation Report Generation

### Success Report
```markdown
✅ MANDATORY RULES VALIDATION PASSED!

Standard Workflow: ✅ PASSED
- Plan created and verified
- Existing code checked first
- Simple changes implemented
- Review section completed

Quality Gates: ✅ ALL 5 PASSED
- 🧹 DRY: No code duplication
- 📖 Readable: Clear, self-documenting code
- 🔧 Maintainable: Clean Architecture followed
- ⚡ Performant: Optimized implementation
- 🧪 Testable: Comprehensive test coverage

Flutter Compliance: ✅ PASSED
- Clean Architecture structure
- No static text found
- Proper Cubit state management
- Localization fully implemented

Code Integration: ✅ PASSED
- Existing components reused
- Patterns followed consistently
- No unnecessary duplication

🎉 READY FOR PRODUCTION!
```

### Failure Report
```markdown
❌ MANDATORY RULES VALIDATION FAILED!

Critical Failures:
❌ Static text found in lib/features/livestream/presentation/pages/stream_page.dart:45
❌ Code duplication detected in lib/features/livestream/presentation/widgets/
❌ Missing tests for StreamUseCase

DEVELOPMENT MUST STOP UNTIL FIXED!

Required Actions:
1. Replace all static text with AppLocalizations
2. Remove duplicate code and reuse existing components
3. Add comprehensive unit tests
4. Re-run validation

DO NOT PROCEED UNTIL ALL FAILURES ARE RESOLVED!
```

## Integration with Development Workflow

This validation MUST be run:
- [ ] **Before any code review**
- [ ] **Before any git commit**
- [ ] **Before marking any story as complete**
- [ ] **Before any deployment**

**NO EXCEPTIONS! NO SHORTCUTS! NO COMPROMISES!**