# AGENTS.md - AI Assistant Rules File
# This file contains persistent instructions that guide AI behavior

## Core Coding Principles
1. **No artifacts** - Direct code only
2. **Less is more** - Rewrite existing components vs adding new
3. **No fallbacks** - They hide real failures
4. **Full code output** - Never say "[X] remains unchanged"
5. **Clean codebase** - Flag obsolete files for removal
6. **Think first** - Clear thinking prevents bugs

## Tool Usage Hierarchy
**Always prefer MCP-provided tools over raw shell calls**

### Preference Order
1. **File operations**: Serena tools > Bash (last resort only)
2. **Code search**: Serena symbols/pattern search > Bash
3. **File finding**: Serena/Glob > Bash
4. **Documentation search**:
   - `ref_ref_search_documentation` for specific known docs
   - `exa_*` for general search (discussions, blogs, discovery)
5. **Web content**:
   - `ref_ref_read_url` when reading from ref search results
   - `webfetch` otherwise
6. **Bash** or **Shell**: Last resort only when no MCP tool available

### Nix-Specific Rules
- When examining Nix flake inputs in current environment, look at `/nix/store` paths rather than GitHub repos (more accurate, faster)
- Use `just inputPath <NAME>` to get store path for a flake input
- Then read files directly from the store path

### MCP Server: readNixStore
The `readNixStore` MCP server provides filesystem access to your home directory and `/nix/store`.

**Valid Tools (Read-Only Operations)**:
- `read_text_file` - Read complete file contents as text
- `read_media_file` - Read image/audio files (returns base64)
- `read_multiple_files` - Read multiple files simultaneously
- `list_directory` - List directory contents with [FILE]/[DIR] prefixes
- `list_directory_with_sizes` - List directory with file sizes and statistics
- `search_files` - Recursively search for files/directories by pattern
- `directory_tree` - Get recursive JSON tree structure of directory
- `get_file_info` - Get detailed file/directory metadata (size, times, permissions)
- `list_allowed_directories` - Show which directories this server can access

**Invalid Tools (Write Operations - DO NOT USE)**:
- `write_file` - BLOCKED: /nix/store is read-only
- `edit_file` - BLOCKED: /nix/store is read-only
- `create_directory` - BLOCKED: /nix/store is read-only
- `move_file` - BLOCKED: /nix/store is read-only
- `copy_file` - BLOCKED: Attempting to copy from /nix/store will fail

**Important**: `/nix/store` is read-only at the filesystem level. Any write operations will fail with permission errors.

## User Interaction Protocol
- **Questions require answers**: When user asks a question, gather info and answer. Wait for response/permission before editing.
- **No preemptive action**: Don't start editing in response to questions

## Documentation Structure
### Documentation Files & Purpose
Create `./docs/` folder and maintain these files throughout development:
- `ROADMAP.md` - Overview, features, architecture, future plans
- `API_REFERENCE.md` - All endpoints, request/response schemas, examples
- `DATA_FLOW.md` - System architecture, data patterns, component interactions
- `SCHEMAS.md` - Database schemas, data models, validation rules
- `BUG_REFERENCE.md` - Known issues, root causes, solutions, workarounds
- `VERSION_LOG.md` - Release history, version numbers, change summaries
- `memory-archive/` - Historical AGENTS.md content (auto-created by /prune)

### Documentation Standards
**Format Requirements**:
- Use clear hierarchical headers (##, ###, ####)
- Include "Last Updated" date and version at top
- Keep line length ≤ 100 chars for readability
- Use code blocks with language hints
- Include practical examples, not just theory

**Content Guidelines**:
- Write for future developers (including yourself in 6 months)
- Focus on "why" not just "what"
- Link between related docs (use relative paths)
- Keep each doc focused on its purpose
- Update version numbers when content changes significantly

### Auto-Documentation Triggers
**ALWAYS document when**:
- Fixing bugs → Update `./docs/BUG_REFERENCE.md` with:
  - Bug description, root cause, solution, prevention strategy
- Adding features → Update `./docs/ROADMAP.md` with:
  - Feature description, architecture changes, API additions
- Changing APIs → Update `./docs/API_REFERENCE.md` with:
  - New/modified endpoints, breaking changes flagged, migration notes
- Architecture changes → Update `./docs/DATA_FLOW.md`
- Database changes → Update `./docs/SCHEMAS.md`
- Before ANY commit → Check if docs need updates

### Documentation Review Checklist
When running `/changes`, verify:
- [ ] All modified APIs documented in API_REFERENCE.md
- [ ] New bugs added to BUG_REFERENCE.md with solutions
- [ ] ROADMAP.md reflects completed/planned features
- [ ] VERSION_LOG.md has entry for current session
- [ ] Cross-references between docs are valid
- [ ] Examples still work with current code

## Proactive Behaviors
- **Bug fixes**: Always document in BUG_REFERENCE.md
- **Code changes**: Judge if documentable → Just do it
- **Project work**: Track with TodoWrite, document at end
- **Personal conversations**: Offer "Would you like this as a note?"

## Critical Reminders
- Do exactly what's asked - nothing more, nothing less
- NEVER create files unless absolutely necessary
- ALWAYS prefer editing existing files over creating new ones
- NEVER create documentation unless working on a coding project
- Commit AGENTS.md to preserve AI assistant configuration on new machines
- When coding, keep the project as modular as possible
- When asked to look at screenshots without a specific path, check ~/Desktop/ first (macOS default), then ~/Screenshots/
