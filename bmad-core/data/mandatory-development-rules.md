# MANDATORY DEVELOPMENT RULES
## THESE RULES MUST ALWAYS BE FOLLOWED - NO EXCEPTIONS!

This file provides mandatory guidance that MUST be followed by ALL agents when working with code in ANY repository.

## 🚨 CRITICAL: Standard Workflow (ALWAYS FOLLOW!)

### MANDATORY 8-Step Process:
1. **THINK**: First think through the problem, read the codebase for relevant files
2. **PLAN**: Write a detailed plan to `tasks/todo.md` with checkable items
3. **VERIFY**: Check in with user - get plan approval before starting
4. **WORK**: Work on todo items, marking them complete as you go
5. **EXPLAIN**: Give high-level explanation of changes at every step
6. **SIMPLE**: Make every change as simple as possible - impact minimal code
7. **REVIEW**: Add review section to `todo.md` with summary of changes
8. **COMMIT**: After every fully finished task - make git commit with proper message

### MANDATORY Workflow Rules:
- ✅ **NEVER start coding without a verified plan**
- ✅ **ALWAYS check existing code before creating new code**
- ✅ **ALWAYS extend existing code instead of duplicating**
- ✅ **ALWAYS use existing patterns and folder structure**
- ✅ **ALWAYS check if functionality already exists**
- ✅ **ALWAYS make git commits after completed tasks**

## 🎯 MANDATORY Quality Criteria (ALL 5 MUST PASS!)

### 1. 🧹 DRY (Don't Repeat Yourself)
- ✅ **NO code duplication allowed**
- ✅ **ALWAYS reuse existing functions/classes/components**
- ✅ **ALWAYS extract common functionality into shared utilities**
- ✅ **ALWAYS check if similar code exists before writing new code**

### 2. 📖 Readable
- ✅ **Code MUST be self-documenting with clear naming**
- ✅ **Methods MUST be small and focused (max 20 lines)**
- ✅ **Classes MUST have single responsibility**
- ✅ **Comments MUST explain WHY, not WHAT**

### 3. 🔧 Maintainable
- ✅ **MUST follow Clean Architecture with proper layer separation**
- ✅ **MUST use dependency injection**
- ✅ **MUST have modular design**
- ✅ **MUST follow existing folder/file structure**

### 4. ⚡ Performant
- ✅ **MUST avoid redundant API calls**
- ✅ **MUST use efficient algorithms**
- ✅ **MUST optimize resource usage**
- ✅ **MUST follow existing performance patterns**

### 5. 🧪 Testable
- ✅ **ALL business logic MUST be unit tested**
- ✅ **ALL UI components MUST be widget tested**
- ✅ **MUST use dependency injection for testability**
- ✅ **MUST follow existing testing patterns**

## 📱 MANDATORY Flutter-Specific Rules

### Architecture Compliance (ALWAYS!)
- ✅ **MUST follow Clean Architecture (Presentation → Domain ← Data)**
- ✅ **MUST use Cubit for state management**
- ✅ **MUST implement Repository pattern**
- ✅ **MUST use GetIt for dependency injection**

### Localization (ALWAYS!)
- ✅ **NO static text allowed - EVER!**
- ✅ **ALL user-facing text MUST use AppLocalizations**
- ✅ **ALL localization keys MUST be descriptive**
- ✅ **MUST add keys to ALL supported ARB files**

### Code Structure (ALWAYS!)
- ✅ **MUST follow existing folder structure**
- ✅ **MUST use snake_case for files**
- ✅ **MUST use PascalCase for classes**
- ✅ **MUST use camelCase for methods/variables**

### Integration Rules (ALWAYS!)
- ✅ **BEFORE creating new files**: Check if similar exists
- ✅ **BEFORE new widgets**: Review `lib/shared/widgets/`
- ✅ **BEFORE new services**: Check `lib/shared/services/`
- ✅ **BEFORE new utilities**: Review `lib/shared/utils/`

## 🛠️ MANDATORY MCP Tool Usage

### When to Use MCPs (ALWAYS check these!):
- ✅ **sequential-thinking**: For complex problem analysis
- ✅ **context7**: For up-to-date library documentation
- ✅ **memory**: For storing important decisions/patterns
- ✅ **puppeteer**: For web scraping/testing needs
- ✅ **fetcher**: For external API data retrieval

## 🔍 MANDATORY Pre-Development Checklist

### Before ANY coding (ALWAYS!):
- [ ] **Read existing codebase** for similar functionality
- [ ] **Check shared components** for reusable parts
- [ ] **Review existing patterns** in similar features
- [ ] **Verify architecture compliance** with existing structure
- [ ] **Plan minimal impact changes** - avoid massive refactors
- [ ] **Ensure localization keys** are planned
- [ ] **Identify testing requirements** early

### During Development (ALWAYS!):
- [ ] **Follow existing naming conventions** exactly
- [ ] **Use existing error handling patterns**
- [ ] **Reuse existing validation logic**
- [ ] **Follow existing state management patterns**
- [ ] **Use existing navigation patterns**
- [ ] **Follow existing styling/theming**

### After Development (ALWAYS!):
- [ ] **Run all tests** and ensure they pass
- [ ] **Check code coverage** meets minimum requirements
- [ ] **Verify localization** works for all languages
- [ ] **Test on different screen sizes**
- [ ] **Review code** against all 5 quality criteria
- [ ] **Make proper git commit** with descriptive message

## 🚨 CRITICAL VALIDATION RULES

### Code Review Criteria (ALL MUST PASS!):
1. ✅ **Architecture**: Follows Clean Architecture with proper layer separation
2. ✅ **Localization**: All text supports multi-language
3. ✅ **Quality**: Passes all 5 quality criteria (DRY, Readable, Maintainable, Performant, Testable)
4. ✅ **Documentation**: Code is properly documented with examples
5. ✅ **Consistency**: Code style matches existing patterns

### Failure Conditions (NEVER ALLOWED!):
- ❌ **Static text in UI** - Immediate failure
- ❌ **Code duplication** - Immediate failure
- ❌ **Breaking existing patterns** - Immediate failure
- ❌ **Missing tests** - Immediate failure
- ❌ **Poor performance** - Immediate failure

## 📋 MANDATORY Commit Message Format

```
type(scope): brief description

- Detailed explanation of changes
- Why the changes were made
- What patterns were followed
- What tests were added

Quality Checklist:
✅ DRY: No code duplication
✅ Readable: Clear naming and structure
✅ Maintainable: Modular design
✅ Performant: Optimized implementation
✅ Testable: Comprehensive test coverage
```

## 🎯 REMEMBER: Consistency is King!

> **When in doubt, ALWAYS follow existing patterns in the codebase.**
> **NEVER create new patterns without explicit approval.**
> **ALWAYS prefer extending existing code over creating new code.**

---

## ⚠️ ENFORCEMENT NOTICE

**These rules are MANDATORY and MUST be followed by:**
- ✅ All BMAD agents (dev, flutter-ui-agent, flutter-cubit-agent, etc.)
- ✅ All development workflows
- ✅ All IDE integrations (Cursor, Claude Code, etc.)
- ✅ All automated processes

**NO EXCEPTIONS! NO SHORTCUTS! NO COMPROMISES!**