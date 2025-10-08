# File-Based OSS Issue Tracking Solutions

**Last Updated**: 2025-10-08  
**Version**: 1.0  
**Scope**: Open-source, file-based alternatives for AI agent issue management

---

## Context

Your AI agent system needs an issue tracking solution that works well with **multiple autonomous agents** posting updates. GitHub has the limitation that all agents appear as the same user when using Personal Access Tokens.

You specifically requested **OSS (open-source) and file-based** solutions. This document evaluates options that:
1. ✅ Are fully open-source
2. ✅ Store issues as files in git (not databases)
3. ✅ Work offline-first
4. ✅ Can be scripted/automated for agent workflows
5. ✅ Don't require cloud services

---

## Quick Comparison Table

| Tool | Language | Activity | Agent-Friendly | Complexity | Recommendation |
|------|----------|----------|----------------|------------|----------------|
| **git-bug** | Go | ⭐⭐⭐⭐⭐ Active | ⭐⭐⭐⭐⭐ Excellent | Medium | **✅ TOP CHOICE** |
| **tissue** | Scheme | ⭐⭐⭐ Moderate | ⭐⭐⭐⭐ Good | High | ✅ If Scheme-friendly |
| **bug** (driusan) | Go | ⭐⭐⭐ Moderate | ⭐⭐⭐⭐ Good | Low | ✅ Simplest option |
| **issue** (marekjm) | Python | ⭐⭐ Low | ⭐⭐⭐ Fair | Low | ⚠️ Less active |
| **Fossil SCM** | C | ⭐⭐⭐⭐⭐ Very Active | ⭐⭐ Limited | High | ❌ Not git-based |
| **ditz** | Ruby | ⭐ Abandoned | ⭐⭐ Limited | Medium | ❌ Unmaintained |
| **ripissue** | Rust | ⭐ Stale | ⭐⭐ Limited | Medium | ❌ Incomplete |

---

## Detailed Evaluations

### 1. git-bug ⭐⭐⭐⭐⭐ (RECOMMENDED)

**Repository**: https://github.com/git-bug/git-bug  
**Stars**: 9.5k | **Language**: Go | **License**: GPL-3.0

#### Why This is Perfect for AI Agents

**Unique Approach**:
- Stores issues as **git objects** (not files!) in `refs/bugs/` namespace
- Each comment/change is a separate git object with full cryptographic identity
- True distributed architecture - push/pull issues like code
- **Native identity management** - each agent can have a distinct git identity

**Key Features**:
```bash
# Initialize in existing repo
git bug init

# Each agent can have their own identity
git config bug.user.name "engineer-agent"
git config bug.user.email "engineer@agents.local"

# Create issue
git bug add "Bug title" -m "Description"

# Comment (preserves identity)
git bug comment <id> "Agent analysis complete"

# List issues
git bug ls

# Web UI for viewing
git bug webui
```

**Agent Workflow Benefits**:
1. **Separate identities**: Each agent configures different `bug.user.name`
2. **Full audit trail**: Every change is a signed git commit
3. **Offline-first**: Agents can work independently, sync later
4. **Programmable**: CLI designed for scripting
5. **Rich metadata**: Labels, status, milestones built-in
6. **Bridge support**: Can sync with GitHub/GitLab if needed

**Storage Format**:
```
.git/
  refs/
    bugs/
      <bug-id>  # Each bug stored as git objects
```

**Pro**:
- ✅ Most active project (2025 releases)
- ✅ Production-ready with 9.5k stars
- ✅ Best agent identity support
- ✅ Web UI + TUI + CLI
- ✅ GraphQL API for advanced automation
- ✅ Nix package available (`pkgs.git-bug`)

**Con**:
- ⚠️ Not truly "file-based" (uses git objects, not markdown files)
- ⚠️ Requires learning new commands beyond `git`
- ⚠️ Medium complexity for simple use cases

**Setup for nix-config**:
```nix
# modules/home/packages.nix
home.packages = with pkgs; [
  git-bug
];

# Per-agent configuration script
# scripts/setup-agent-identity.sh
#!/usr/bin/env bash
AGENT_NAME=$1
cd "$PROJECT_DIR"
git config --local bug.user.name "$AGENT_NAME"
git config --local bug.user.email "$AGENT_NAME@agents.local"
```

---

### 2. tissue ⭐⭐⭐⭐

**Website**: https://tissue.systemreboot.net/  
**Language**: Guile Scheme | **License**: GPL-3+

#### Why Tissue is Interesting

**Philosophy**:
- Issues are **gemtext files** (one per issue)
- Designed for small free software projects
- Separates discussion (elsewhere) from documentation (in repo)

**Features**:
```bash
# Initialize
tissue init

# Create issue
tissue create "Issue title"

# Search with Xapian
tissue search "keywords"

# Generate static site
tissue web build

# Search web interface
tissue web
```

**File Format** (gemtext - extremely simple):
```
# Issue title

* author: agent-engineer
* created: 2025-10-08
* status: open
* tags: bug, memory

## Description

Memory leak detected in buffer pool

## Discussion

See commit abc123 for initial analysis
```

**Pro**:
- ✅ True file-based (gemtext/markdown)
- ✅ Powerful search (Xapian full-text)
- ✅ Static site generator
- ✅ All state in repo (no extra backups)
- ✅ Simple format - easy for agents to parse/generate

**Con**:
- ❌ Requires Guile Scheme runtime
- ❌ Less active (last release Jan 2023)
- ❌ Manual identity management (via file metadata)
- ❌ Not in nixpkgs (would need custom derivation)

**Agent Suitability**: ⭐⭐⭐⭐
- Great if you're comfortable with Scheme ecosystem
- Files are simple enough for agents to manipulate directly
- Would need wrapper scripts for agent identity injection

---

### 3. bug (by driusan) ⭐⭐⭐⭐

**Repository**: https://github.com/driusan/bug  
**Stars**: 210 | **Language**: Go | **License**: GPL-3.0

#### Simplest "Poorman's Issue Tracker" Implementation

**Philosophy**:
- Follow filesystem conventions a human would use
- `issues/` directory with subdirectories per issue
- Git for version control, tool for convenience

**Structure**:
```
issues/
  Need-better-help/
    Description
    Status
    Priority
    Milestone
    comments/
      2025-10-08-engineer.txt
      2025-10-08-reviewer.txt
```

**Commands**:
```bash
# Create
bug create "Issue title"

# List
bug list
bug list --open

# Comment (file-based!)
bug comment <id> "Comment text"

# Close
bug close <id>

# Tag
bug tag category <id>

# Commit to git
bug commit
```

**Pro**:
- ✅ Dead simple - just directories and text files
- ✅ Human-readable without tool
- ✅ Easy for agents to manipulate directly
- ✅ Active maintenance (2024 releases)
- ✅ Lightweight Go binary
- ✅ In nixpkgs as `pkgs.bug`

**Con**:
- ⚠️ Identity via filename only (`comments/YYYY-MM-DD-username.txt`)
- ⚠️ No built-in web UI
- ⚠️ Basic metadata (no milestones, limited queries)
- ⚠️ Manual sync (no push/pull commands)

**Agent Suitability**: ⭐⭐⭐⭐
- Perfect if you want **simple file manipulation**
- Agents can `mkdir` and `echo` to create issues
- Identity via comment filenames (`2025-10-08-engineer-agent.txt`)
- Easy to script wrapper for prettier output

**Nix Setup**:
```nix
# modules/home/packages.nix
home.packages = with pkgs; [
  bug
];

# Agent wrapper example
# scripts/agent-comment.sh
#!/usr/bin/env bash
AGENT_NAME=$1
ISSUE_ID=$2
COMMENT=$3
DATE=$(date +%Y-%m-%d-%H%M%S)

mkdir -p "issues/$ISSUE_ID/comments"
echo "$COMMENT" > "issues/$ISSUE_ID/comments/$DATE-$AGENT_NAME.txt"
echo "Comment added by $AGENT_NAME to issue $ISSUE_ID"
```

---

### 4. issue (by marekjm) ⭐⭐⭐

**Repository**: https://github.com/marekjm/issue  
**Stars**: 72 | **Language**: Python 3 | **License**: GPL-3.0

#### Python-Based CLI Tracker

**Philosophy**:
- Dead-simple interface
- No-bullshit approach
- Command-line first
- For programmers, not general users

**Storage**: `.issue/` directory (hidden, like `.git`)

**Features**:
```bash
# Setup
issue config --global set author.name "Agent Name"
issue config --global set author.email "agent@local"

# Initialize
issue init

# Create
issue open "Issue title"

# Comment
issue comment <id> "Comment text"

# Close with git commit reference
issue close -g HEAD <id>

# List with filters
issue ls --open
issue ls --since 2weeks "memory"

# Tags
issue tag new 'bug'
issue tag bug <id>

# Branch names from issues
git checkout -b $(issue slug <id>)
```

**Pro**:
- ✅ Designed for programmers
- ✅ Git commit linking
- ✅ Time-based filtering
- ✅ Branch name generation
- ✅ Simple Python (easy to modify)

**Con**:
- ❌ Not in nixpkgs (manual install)
- ❌ Less active (last update 2024)
- ❌ Hidden `.issue/` directory (not human-inspectable)
- ❌ JSON storage (not markdown)
- ❌ Single identity per repo (config-based)

**Agent Suitability**: ⭐⭐⭐
- Would need wrapper to switch identities
- Python makes it easy to extend
- Good CLI design for scripting
- But less ideal than git-bug or bug

---

### 5. Fossil SCM ⭐⭐⭐⭐⭐

**Website**: https://fossil-scm.org/  
**Language**: C | **License**: BSD-2-Clause

#### All-in-One Alternative to Git

**Note**: Not git-based, but worth mentioning as complete solution.

**Features**:
- Version control (like git)
- Issue tracker
- Wiki
- Forum
- Chat
- Web UI
- All in **single SQLite file**

**Pro**:
- ✅ Extremely active project
- ✅ Used by SQLite itself
- ✅ Built-in web UI
- ✅ All features integrated
- ✅ Simple distribution (one file)

**Con**:
- ❌ **Not git-based** (separate VCS)
- ❌ Would require migrating from git
- ❌ Different workflow than git
- ❌ SQLite storage (not plaintext)

**Agent Suitability**: ⭐⭐
- Would work but requires changing entire workflow
- Not suitable if you want to stay with git
- Mentioned for completeness only

---

### 6. Archived/Unmaintained Options

#### ditz (Ruby)
- **Status**: ❌ Unmaintained since 2011
- **Stars**: 15
- **Verdict**: Don't use

#### ripissue (Rust)
- **Status**: ❌ Incomplete/stale
- **Stars**: 1
- **Verdict**: Not production-ready

#### simple-issues-tracker (Perl)
- **Status**: ❌ Author stopped developing
- **Verdict**: Avoid

---

## Recommendations by Use Case

### For Your AI Agent System: git-bug

**Reasoning**:
1. **Best identity support**: Each agent can be a distinct git user
2. **Most active**: 2025 releases, 9.5k stars, growing community
3. **Production-ready**: Used in real projects
4. **Programmable**: GraphQL API + rich CLI
5. **Nix-friendly**: Package exists, works with flakes
6. **Future-proof**: Active development, bridge support

**Implementation Path**:
```bash
# 1. Install
nix profile install nixpkgs#git-bug

# 2. Initialize in a project
cd ~/my-project
git bug init

# 3. Configure agent identities (per clone or branch)
# Engineer agent
git config --local bug.user.name "engineer-agent"
git config --local bug.user.email "engineer@agents.local"

# 4. Agent workflow script
cat > ~/.local/bin/agent-issue << 'EOF'
#!/usr/bin/env bash
# Usage: agent-issue <agent-name> <command> [args...]
AGENT=$1; shift
ORIGINAL_NAME=$(git config bug.user.name)
ORIGINAL_EMAIL=$(git config bug.user.email)

git config bug.user.name "$AGENT"
git config bug.user.email "$AGENT@agents.local"

git bug "$@"

git config bug.user.name "$ORIGINAL_NAME"
git config bug.user.email "$ORIGINAL_EMAIL"
EOF
chmod +x ~/.local/bin/agent-issue

# 5. Usage
agent-issue engineer add "Memory leak detected"
agent-issue reviewer comment <id> "Confirmed, see commit abc123"
agent-issue code-architect label <id> architecture
```

---

### If You Want Ultra-Simple: bug (driusan)

**Reasoning**:
1. **Simplest implementation**: Just files and directories
2. **Human-readable**: Can edit with any text editor
3. **Easy agent manipulation**: `mkdir`, `echo`, done
4. **No magic**: Everything visible

**Trade-offs**:
- Less sophisticated identity management
- No web UI (but that might be fine)
- Manual sync workflow

**When to choose**:
- You value simplicity over features
- You want to inspect/edit issues with `cat` and `vim`
- You're comfortable scripting your own wrappers

---

### If You Like Scheme: tissue

**Reasoning**:
- Beautiful philosophy (separation of discussion/docs)
- Powerful search
- Static site generation
- Gemtext is delightfully simple

**Trade-offs**:
- Requires Guile ecosystem
- Not in nixpkgs
- Smaller community

**When to choose**:
- You're already in Guile/Scheme ecosystem
- You want powerful search
- You like gemtext/markdown simplicity

---

## Integration with Your nix-config

### Option A: git-bug for System-Wide Issues

**Use Case**: Track nix-config development itself

```nix
# modules/home/packages.nix
{
  home.packages = with pkgs; [
    git-bug
  ];

  # Optional: systemd service for web UI
  systemd.user.services.git-bug-webui = {
    Unit = {
      Description = "git-bug web interface";
    };
    Service = {
      ExecStart = "${pkgs.git-bug}/bin/git-bug webui --port 8080";
      WorkingDirectory = "~/.config/nix-config";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
```

### Option B: Per-Project Agent Scripts

```bash
# apps/ai-agents/commands/issue-create.md
---
title: Create Issue
description: Create issue with proper agent identity
---

#!/usr/bin/env bash

AGENT_NAME="$1"
TITLE="$2"
DESCRIPTION="$3"

# Save current identity
PREV_NAME=$(git config bug.user.name)
PREV_EMAIL=$(git config bug.user.email)

# Set agent identity
git config bug.user.name "$AGENT_NAME"
git config bug.user.email "$AGENT_NAME@agents.local"

# Create issue
ISSUE_ID=$(git bug add "$TITLE" -m "$DESCRIPTION" | grep -oP 'bug \K[a-f0-9]+')

# Restore identity
git config bug.user.name "$PREV_NAME"
git config bug.user.email "$PREV_EMAIL"

echo "$ISSUE_ID"
```

### Option C: MCP Server for git-bug

**Future Enhancement**: Create MCP server wrapper

```typescript
// Potential structure
// ~/.config/opencode/servers/git-bug-mcp/
{
  "servers": {
    "git-bug": {
      "command": "node",
      "args": ["/path/to/git-bug-mcp-server.js"],
      "env": {
        "GIT_BUG_REPO": "${PROJECT_DIR}",
        "AGENT_IDENTITY": "${AGENT_NAME}"
      }
    }
  }
}
```

**Tools**:
- `git_bug_create` - Create issue as specific agent
- `git_bug_list` - List issues with filters
- `git_bug_comment` - Add comment with agent identity
- `git_bug_show` - Show issue details
- `git_bug_label` - Manage labels
- `git_bug_close` - Close issue

---

## Migration Path from GitHub

If currently using GitHub issues:

### 1. Export from GitHub
```bash
# Using git-bug's bridge feature
git bug bridge configure --name github --target github
git bug bridge pull github
```

### 2. Work Locally
```bash
# All agents work against local git-bug repo
agent-issue engineer add "Local issue"
agent-issue reviewer comment <id> "Review comment"
```

### 3. Optional: Sync Back
```bash
# Push changes back to GitHub if desired
git bug bridge push github
```

### 4. Or: Full Migration
```bash
# Export all issues
git bug bridge pull github --import

# Remove bridge, work purely local
git bug bridge rm github
```

---

## Decision Matrix

| Requirement | git-bug | bug | tissue | issue |
|-------------|---------|-----|--------|-------|
| **Multi-agent identities** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐ |
| **File-based storage** | ⭐⭐ (git objects) | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐ (JSON) |
| **Offline-first** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **Active development** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐ |
| **Nix integration** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐ | ⭐ |
| **Learning curve** | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐ | ⭐⭐⭐⭐ |
| **Feature richness** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ |
| **Web UI** | ⭐⭐⭐⭐⭐ | ❌ | ⭐⭐⭐⭐ | ❌ |
| **Automation-friendly** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐ |

---

## Final Recommendation

### For Your Use Case: **git-bug** 🏆

**Install Now**:
```bash
# Add to modules/home/packages.nix
home.packages = with pkgs; [ git-bug ];

# Initialize in a test repo
cd ~/test-project
git bug init

# Set agent identity
git config bug.user.name "engineer-agent"
git config bug.user.email "engineer@agents.local"

# Create first issue
git bug add "Test issue from agent" -m "Testing multi-agent workflow"

# Check web UI
git bug webui
# Opens http://localhost:8080
```

**Why This Wins**:
1. ✅ Best multi-agent identity support (each agent = git user)
2. ✅ Active project with long-term viability
3. ✅ Rich features (web UI, labels, milestones, search)
4. ✅ Already in nixpkgs
5. ✅ GraphQL API for advanced automation
6. ✅ Can bridge to GitHub if you change your mind later
7. ✅ Professional-grade tool used in production

**Alternative If**:
- **You want ultra-simple**: Use **bug** (driusan) for plaintext files
- **You're in Scheme ecosystem**: Use **tissue** for gemtext elegance
- **You need gradual adoption**: Start with **bug**, migrate to **git-bug** later

---

## Quick Start Guide

### Setup git-bug in nix-config

```nix
# 1. Add to modules/home/packages.nix
{ pkgs, ... }: {
  home.packages = with pkgs; [
    git-bug
  ];
}

# 2. Create agent identity helper
# scripts/setup-git-bug-agent.sh
#!/usr/bin/env bash
AGENT_NAME="${1:-engineer-agent}"
REPO_DIR="${2:-.}"

cd "$REPO_DIR"

# Initialize if needed
if [ ! -d ".git/refs/bugs" ]; then
  git bug init
fi

# Set agent identity for this repo
git config --local bug.user.name "$AGENT_NAME"
git config --local bug.user.email "$AGENT_NAME@agents.local"

echo "✓ git-bug initialized with identity: $AGENT_NAME"

# 3. Add to PATH
# modules/home/shell.nix
programs.bash.shellAliases = {
  "agent-bug" = "~/scripts/setup-git-bug-agent.sh";
};

# 4. Usage
$ agent-bug engineer-agent ~/my-project
$ cd ~/my-project
$ git bug add "First issue"
$ git bug webui
```

---

## Resources

**git-bug**:
- Repo: https://github.com/git-bug/git-bug
- Docs: https://github.com/git-bug/git-bug/tree/trunk/doc
- Matrix: https://matrix.to/#/#git-bug:matrix.org

**bug (driusan)**:
- Repo: https://github.com/driusan/bug
- Format spec: https://github.com/driusan/PoormanIssueTracker

**tissue**:
- Website: https://tissue.systemreboot.net/
- Repo: https://git.systemreboot.net/tissue/

**issue (marekjm)**:
- Repo: https://github.com/marekjm/issue

---

## Related Documentation

- `docs/ALTERNATIVE_ISSUE_TRACKING_PLATFORMS.md` - Cloud/hosted options
- `docs/GITHUB_AGENT_IDENTITY_OPTIONS.md` - GitHub-specific solutions
- `docs/AGENT_CONFIG_INCONSISTENCIES.md` - Current agent setup

---

**Version History**:
- 1.0 (2025-10-08): Initial research and recommendations
