# Agent Configuration Inconsistencies

**Last Updated**: 2025-10-08  
**Version**: 2.0  
**Scope**: System-wide AI agent configuration managed by nix-config

---

## Context

This nix-config repository defines a **system-wide AI agent configuration** that will be applied to **all coding projects** across your system. The agents in `apps/ai-agents/` are not specific to nix-config itself, but are general-purpose agents for any project type (Go, Rust, JavaScript, Rails, React, Nix, etc.).

This document tracks inconsistencies between:
1. What the agents **expect** to be available (tools, MCP servers, commands)
2. What is **actually configured** in your system via `modules/home/opencode.nix`

---

## Critical Inconsistencies

### 1. ✅ RESOLVED - Adapted to GitHub

**Previously**: Agents referenced Gitea MCP servers that weren't configured  
**Resolution**: Updated all agent commands to use `github` MCP server  
**Status**: ✅ **FIXED**

**Files Updated**:
- `apps/ai-agents/commands/engineer.md` - Now uses `github` MCP server
- `apps/ai-agents/commands/issue-engineer.md` - All Gitea references replaced with GitHub

**Verification Needed**:
- [ ] Test GitHub issue fetching with updated commands
- [ ] Verify GitHub comment posting works
- [ ] Confirm multi-comment synthesis works with GitHub API

---

### 2. ✅ RESOLVED - Nix Command Mismatch Fixed

**Previously**: Agents referenced `just format` which doesn't exist  
**Resolution**: Updated validation commands to use actual justfile commands  
**Status**: ✅ **FIXED**

**Changes Made**:
- `commit-and-push.md`: Updated Nix section to use `just lint`, `just check`, `deadnix`
- `issue-engineer.md`: Updated QUALITY_CHECKS for Nix projects
- Removed non-existent `just format` command
- Added `just check` for flake validation

**Verification Needed**:
- [ ] Run commit-and-push on nix-config changes
- [ ] Verify all three commands execute successfully
- [ ] Confirm validation loop works correctly

---

### 3. ✅ RESOLVED - Screenshot Path Fixed

**Previously**: Screenshot path pointed to `~/Screenshots/` (wrong for macOS)  
**Resolution**: Updated to check `~/Desktop/` first (macOS default), then `~/Screenshots/`  
**Status**: ✅ **FIXED**

**Change Made**:
```markdown
- When asked to look at screenshots without a specific path, check ~/Desktop/ 
  first (macOS default), then ~/Screenshots/
```

---

### 4. Screenshot Path Incorrect for macOS



## Medium Priority Inconsistencies

### 4. Documentation Auto-Triggers Too Broad

**Severity**: 🟡 **MEDIUM** - Creates unnecessary files  
**Location**: `apps/ai-agents/AGENTS.md` lines 12-57

**Issue**: The documentation structure is heavily API/application-focused:
```markdown
Create `./docs/` folder and maintain these files:
- ROADMAP.md
- API_REFERENCE.md      # ← Only relevant for API projects
- DATA_FLOW.md
- SCHEMAS.md            # ← Only relevant for database projects
- BUG_REFERENCE.md
- VERSION_LOG.md        # ← Only relevant for versioned releases
```

**Reality**: 
- ✅ Good for application projects (Go APIs, Rails apps, React apps)
- ❌ Overkill for: libraries, CLIs, config repos, scripts
- ⚠️ Will create unused files in wrong project types

**Impact**: 
- Minor clutter in non-application projects
- Wasted effort maintaining irrelevant docs

**Resolution**: Make documentation conditional:

```markdown
### Documentation Files & Purpose
Create `./docs/` folder and maintain these files **as appropriate for project type**:

**All Projects:**
- BUG_REFERENCE.md - Known issues, root causes, solutions

**API/Web Applications:**
- API_REFERENCE.md - Endpoints, schemas, examples
- DATA_FLOW.md - Architecture, component interactions

**Database-Driven Projects:**
- SCHEMAS.md - Database schemas, models, migrations

**Versioned Products:**
- ROADMAP.md - Features, architecture, plans
- VERSION_LOG.md - Release history, change summaries

**Note**: Create only relevant documentation for the project type.
```

---

### 5. Project Type Detection Edge Cases

**Severity**: 🟢 **LOW** - Good defaults exist  
**Location**: 
- `apps/ai-agents/commands/commit-and-push.md` lines 6-11
- `apps/ai-agents/commands/issue-engineer.md` lines 15-21

**Detection Logic**:
```bash
Go: go.mod
Rust: Cargo.toml  
JavaScript/TypeScript: package.json
Playwright: package.json + @playwright/test
Nix: flake.nix or default.nix
```

**Missing Project Types**:
- Python: `pyproject.toml`, `setup.py`, `requirements.txt`
- Ruby: `Gemfile`, `.ruby-version`
- PHP: `composer.json`
- Java/Kotlin: `pom.xml`, `build.gradle`
- C/C++: `CMakeLists.txt`, `Makefile`

**Impact**: 
- Fallback behavior is acceptable (generic project)
- But missing project-specific quality checks

**Resolution** (Optional Enhancement):

```bash
case $PROJECT_TYPE in
  # Existing cases...
  
  "python")
    QUALITY_CHECKS=(
      "black ."
      "ruff check ."
      "mypy ."
      "pytest"
    )
    ;;
    
  "ruby")
    QUALITY_CHECKS=(
      "bundle exec rubocop"
      "bundle exec rspec"
    )
    ;;
    
  # etc...
esac
```

---

## Low Priority / Informational

### 6. Claude-Specific References

**Severity**: 🟢 **LOW** - Cosmetic  
**Location**: `apps/ai-agents/AGENTS.md` line 21

**Reference**: 
```markdown
memory-archive/ - Historical AGENTS.md content (auto-created by /prune)
```

**Reality**: `/prune` command is Claude Code-specific, may not exist in OpenCode/Cursor/Windsurf

**Impact**: Harmless - directory just won't auto-create

**Resolution**: None needed, or add note:
```markdown
memory-archive/ - Historical AGENTS.md content (auto-created by /prune if supported)
```

---

### 7. Team Configurator's Framework Detection

**Severity**: 🟢 **LOW** - Works as designed  
**Location**: `apps/ai-agents/agents/orchestrators/team-configurator.md` lines 76-103

**Detection Files**:
```bash
package.json     # JS/TS
composer.json    # PHP/Laravel
requirements.txt # Python/Django
Gemfile          # Ruby/Rails
go.mod           # Go
```

**Reality**: Falls back gracefully to universal agents when framework-specific ones don't apply

**Impact**: None - working as intended

---

## Recommendations Summary

### Immediate Actions (Critical)

1. **🔴 Resolve Gitea vs GitHub**
   - **Decision Point**: Do you use Gitea or GitHub for issue tracking?
   - **If Gitea**: Add MCP servers to `modules/home/opencode.nix`
   - **If GitHub**: Update agent commands to use GitHub API
   - **If Neither**: Disable/document issue workflow commands

2. **🟠 Fix Nix Project Commands**
   - Update `commit-and-push.md` Nix section
   - Add `just format` alias to `justfile`, OR
   - Document that `just lint` is the format command

### Medium Priority

3. **🟡 Make Documentation Context-Aware**
   - Add conditional logic to doc creation
   - Document which files apply to which project types

4. **🟡 Fix Screenshot Path**
   - Change to `~/Desktop/` or check both locations

### Optional Enhancements

5. **Add More Project Type Detection**
   - Python, Ruby, PHP, Java projects
   - Project-specific quality checks

6. **Test Multi-Agent Workflows**
   - Verify OpenCode supports sub-agent calling
   - Test issue-engineer workflow if Gitea configured
   - Validate team-configurator behavior

---

## Testing Checklist

### When Working on Go/Rust/JS Projects:
- [ ] Run `commit-and-push` command
- [ ] Verify correct quality checks run
- [ ] Test validation loop iterations

### When Working on This Nix-Config:
- [ ] Run `commit-and-push` command  
- [ ] Verify nix fmt and checks run
- [ ] Ensure `just format` doesn't break workflow

### For Issue Workflows (if Gitea configured):
- [ ] Test fetching issue from Gitea
- [ ] Verify engineer can post comments
- [ ] Test multi-comment synthesis

### For GitHub Projects:
- [ ] Test if GitHub MCP server works as replacement
- [ ] Verify issue fetching and commenting

---

## Related Files

**System Configuration:**
- `modules/home/opencode.nix` - MCP server config, agent paths
- `apps/ai-agents/AGENTS.md` - Global rules for all projects

**Agent Workflows:**
- `apps/ai-agents/commands/commit-and-push.md` - Validation and commit
- `apps/ai-agents/commands/issue-engineer.md` - Issue-driven development
- `apps/ai-agents/commands/engineer.md` - Engineer workflow

**Orchestrators:**
- `apps/ai-agents/agents/orchestrators/team-configurator.md` - Auto team setup
- `apps/ai-agents/agents/orchestrators/tech-lead-orchestrator.md` - Planning

**This Repository:**
- `justfile` - Available commands for nix-config
- `flake.nix` - Nix flake definition

**Additional Documentation:**
- `docs/GITHUB_AGENT_IDENTITY_OPTIONS.md` - Research on agent identity solutions

---

## Priority Matrix

| Issue | Severity | Status | Notes |
|-------|----------|--------|-------|
| Gitea MCP Missing | 🔴 Critical | ✅ **FIXED** | Adapted to GitHub |
| Nix Commands Wrong | 🟠 High | ✅ **FIXED** | Updated validation commands |
| Screenshot Path | 🟡 Medium | ✅ **FIXED** | Now checks ~/Desktop/ first |
| Docs Too Broad | 🟡 Medium | ⚠️ **ACCEPTABLE** | Good for app projects |
| Project Detection | 🟢 Low | ⚠️ **ACCEPTABLE** | Falls back gracefully |
| Claude References | 🟢 Low | ⚠️ **ACCEPTABLE** | Harmless cosmetic |

**Status Summary**: 
- ✅ All critical and high-priority issues resolved
- ⚠️ Medium/low priority issues are acceptable as-is
- No blocking issues remain
