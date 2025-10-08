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
| **git-bug** | Go | ⭐⭐⭐⭐⭐ Active | ⭐⭐⭐⭐⭐ Excellent | Medium | **✅ ISSUE TRACKING** |
| **git-appraise** | Go | ⭐⭐⭐ Moderate | ⭐⭐⭐⭐⭐ Excellent | Medium | **✅ CODE REVIEW** |
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

### 2. git-appraise ⭐⭐⭐⭐⭐ (RECOMMENDED FOR CODE REVIEW)

**Repository**: https://github.com/google/git-appraise  
**Stars**: 5.3k | **Language**: Go | **License**: Apache-2.0 | **By**: Google

#### Why This is Perfect for PR-Like Workflows

**Philosophy**:
- **Distributed code review system** - like GitHub PRs but stored in git
- Reviews stored as git-notes in `refs/notes/devtools/` namespace
- Each review annotates commits with structured JSON metadata
- **Complements git-bug** - use git-bug for issues, git-appraise for PRs

**Key Difference from git-bug**:
- git-bug = Issue tracking (bugs, features, tasks)
- git-appraise = Code review (PR workflow, review comments, approvals)

**Storage Strategy**:
```
.git/
  refs/
    notes/
      devtools/
        reviews   # Code review requests
        discuss   # Human review comments
        ci        # CI/CD build results
        analyses  # Static analysis (robot comments)
```

**Commands**:
```bash
# Request code review
git appraise request

# List pending reviews
git appraise list

# Show review with comments
git appraise show

# Comment on code
git appraise comment -m "LGTM" -f file.go -l 42

# Accept changes
git appraise accept -m "Approved"

# Submit (merge) after approval
git appraise submit --merge

# Push/pull reviews
git appraise push
git appraise pull
```

**Agent Workflow for Code Review**:
```bash
# Engineer agent creates PR
git config user.name "engineer-agent"
git appraise request -m "Fix memory leak in buffer pool"

# Code-reviewer agent reviews
git config user.name "code-reviewer-agent"
git appraise comment -m "Memory management looks good" -f buffer.go -l 123
git appraise comment -m "Consider adding null check" -f buffer.go -l 156

# Code-architect agent architectural review
git config user.name "code-architect-agent"  
git appraise comment -m "Design follows RAII pattern correctly"

# Security agent reviews
git config user.name "security-agent"
git appraise accept -m "No security issues detected"

# Engineer agent submits after approval
git config user.name "engineer-agent"
git appraise submit --merge
```

**Pro**:
- ✅ **Perfect for PR workflows** - designed for code review
- ✅ **Google-backed** - used internally at Google
- ✅ **5.3k stars** - production-ready
- ✅ **Multi-agent friendly** - each reviewer is a git user
- ✅ **File-level comments** - comment on specific lines
- ✅ **CI integration** - track build/test results
- ✅ **Robot comments** - static analysis results
- ✅ **Web UI available** - [git-appraise-web](https://github.com/google/git-appraise-web)
- ✅ **In nixpkgs** - `pkgs.git-appraise`
- ✅ **Complements git-bug** - use both together

**Con**:
- ⚠️ Less active than git-bug (last release 2021)
- ⚠️ Requires separate web UI repo
- ⚠️ JSON format (not markdown)
- ⚠️ Learning curve for git-notes workflow

**Use Case**:
```
git-bug       → Track issues, bugs, features
git-appraise  → Review code changes, PRs, approvals
Together      → Complete development workflow
```

**Example Combined Workflow**:
```bash
# 1. Create issue (git-bug)
git bug add "Memory leak in buffer pool" -m "Detected via profiling"
ISSUE_ID=$(git bug ls | head -1 | awk '{print $1}')

# 2. Create feature branch
git checkout -b fix/memory-leak-$ISSUE_ID

# 3. Make changes
vim buffer.go
git commit -m "Fix memory leak

Closes: $ISSUE_ID"

# 4. Request review (git-appraise)
git appraise request -m "Fixes issue $ISSUE_ID"

# 5. Code review happens
# ... multiple agents review and comment ...

# 6. Submit after approval
git appraise submit --merge

# 7. Close issue (git-bug)
git bug close $ISSUE_ID
```

**Nix Setup**:
```nix
# modules/home/packages.nix
home.packages = with pkgs; [
  git-bug       # Issue tracking
  git-appraise  # Code review
];

# Agent script for combined workflow
# scripts/agent-pr-workflow.sh
#!/usr/bin/env bash
AGENT=$1
ACTION=$2

case "$ACTION" in
  "create-issue")
    git config bug.user.name "$AGENT"
    git bug add "$3" -m "$4"
    ;;
  "request-review")
    git config user.name "$AGENT"
    git appraise request -m "$3"
    ;;
  "review")
    git config user.name "$AGENT"
    git appraise comment -m "$3"
    ;;
  "approve")
    git config user.name "$AGENT"
    git appraise accept -m "$3"
    ;;
esac
```

**Integration with AI Agents**:

The combination of git-bug + git-appraise provides:
1. **Issue tracking** - bugs, features, tasks (git-bug)
2. **Code review** - PR workflow, approvals (git-appraise)
3. **Identity separation** - each agent has distinct identity in both
4. **Offline-first** - both work fully offline
5. **Distributed** - push/pull to share with team

**Mirrors/Integrations**:
- [GitHub PR Mirror](https://github.com/google/git-pull-request-mirror) - Sync with GitHub PRs
- [Phabricator Mirror](https://github.com/google/git-phabricator-mirror) - Sync with Phabricator
- [Jenkins Plugin](https://github.com/jenkinsci/google-git-notes-publisher-plugin) - CI integration

**Schema Documentation**:
- Request: `refs/notes/devtools/reviews` - Review requests
- Comments: `refs/notes/devtools/discuss` - Human review comments
- CI Status: `refs/notes/devtools/ci` - Build/test results
- Analysis: `refs/notes/devtools/analyses` - Static analysis results

**Agent Suitability**: ⭐⭐⭐⭐⭐
- Perfect for multi-agent code review workflows
- Each agent can review, comment, approve independently
- Full audit trail of who reviewed what
- Works alongside git-bug for complete workflow

---

### 3. tissue ⭐⭐⭐⭐

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

### 4. bug (by driusan) ⭐⭐⭐⭐

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

### 5. issue (by marekjm) ⭐⭐⭐

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

### 6. Fossil SCM ⭐⭐⭐⭐⭐

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

### 7. Archived/Unmaintained Options

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

### For Your AI Agent System: git-bug + git-appraise (DUAL SETUP)

**Recommended Architecture**:
```
git-bug       → Issue/bug/feature tracking
git-appraise  → Code review (PR workflow)
Both together → Complete development lifecycle
```

**Why Use Both**:
1. **Separation of concerns**: Issues ≠ Code Reviews
2. **Different workflows**: Issues are long-lived, PRs are transient
3. **Both agent-friendly**: Each tool supports multi-agent identities
4. **Complementary**: git-bug tracks *what*, git-appraise tracks *how*
5. **Both in nixpkgs**: Easy to install and maintain

**Reasoning for git-bug**:
1. **Best identity support**: Each agent can be a distinct git user
2. **Most active**: 2025 releases, 9.5k stars, growing community
3. **Production-ready**: Used in real projects
4. **Programmable**: GraphQL API + rich CLI
5. **Nix-friendly**: Package exists, works with flakes
6. **Future-proof**: Active development, bridge support

**Reasoning for git-appraise**:
1. **PR-focused**: Designed specifically for code review workflow
2. **Google-proven**: Used at Google scale
3. **File-level comments**: Review specific lines of code
4. **CI integration**: Track build/test results
5. **Complements git-bug**: Different use case, same philosophy

**Implementation Path**:
```bash
# 1. Install both tools
nix profile install nixpkgs#git-bug nixpkgs#git-appraise

# 2. Initialize in a project
cd ~/my-project
git bug init
# git-appraise doesn't need init, uses git-notes automatically

# 3. Configure agent identities (per clone or branch)
# For git-bug
git config --local bug.user.name "engineer-agent"
git config --local bug.user.email "engineer@agents.local"

# For git-appraise (uses standard git config)
git config --local user.name "engineer-agent"
git config --local user.email "engineer@agents.local"

# 4. Combined agent workflow script
cat > ~/.local/bin/agent-workflow << 'EOF'
#!/usr/bin/env bash
# Usage: agent-workflow <agent-name> <tool> <command> [args...]
AGENT=$1; shift
TOOL=$1; shift

# Save original identities
ORIG_BUG_NAME=$(git config bug.user.name)
ORIG_BUG_EMAIL=$(git config bug.user.email)
ORIG_GIT_NAME=$(git config user.name)
ORIG_GIT_EMAIL=$(git config user.email)

# Set agent identities
git config bug.user.name "$AGENT"
git config bug.user.email "$AGENT@agents.local"
git config user.name "$AGENT"
git config user.email "$AGENT@agents.local"

# Run command
case "$TOOL" in
  bug|issue)
    git bug "$@"
    ;;
  appraise|review|pr)
    git appraise "$@"
    ;;
  *)
    echo "Unknown tool: $TOOL (use 'bug' or 'appraise')"
    exit 1
    ;;
esac

# Restore original identities
git config bug.user.name "$ORIG_BUG_NAME"
git config bug.user.email "$ORIG_BUG_EMAIL"
git config user.name "$ORIG_GIT_NAME"
git config user.email "$ORIG_GIT_EMAIL"
EOF
chmod +x ~/.local/bin/agent-workflow

# 5. Usage examples
# Issue tracking
agent-workflow engineer bug add "Memory leak detected"
agent-workflow reviewer bug comment <id> "Confirmed"
agent-workflow code-architect bug label <id> architecture

# Code review
agent-workflow engineer appraise request -m "Fix memory leak"
agent-workflow reviewer appraise comment -m "LGTM" -f buffer.go -l 42
agent-workflow security appraise accept -m "No security issues"
```

**Example Complete Workflow**:
```bash
# 1. Engineer creates issue
agent-workflow engineer-agent bug add "Memory leak in buffer pool"

# 2. Engineer creates fix branch
git checkout -b fix/memory-leak-abc123

# 3. Engineer makes changes
vim buffer.go
git commit -m "Fix memory leak in buffer pool"

# 4. Engineer requests review
agent-workflow engineer-agent appraise request -m "Fixes memory leak issue"

# 5. Reviewer reviews code
agent-workflow code-reviewer-agent appraise comment \
  -m "Memory management looks correct" \
  -f buffer.go -l 156

# 6. Architect reviews design
agent-workflow code-architect-agent appraise comment \
  -m "Follows RAII pattern correctly"

# 7. Security reviews
agent-workflow security-agent appraise accept \
  -m "No security vulnerabilities detected"

# 8. Engineer merges
agent-workflow engineer-agent appraise submit --merge

# 9. Close original issue
agent-workflow engineer-agent bug close abc123 \
  -m "Fixed in commit def456"
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

| Requirement | git-bug | git-appraise | bug | tissue | issue |
|-------------|---------|--------------|-----|--------|-------|
| **Use Case** | Issues | Code Review | Issues | Issues | Issues |
| **Multi-agent identities** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐ |
| **File-based storage** | ⭐⭐ (git objects) | ⭐⭐ (git-notes) | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐ (JSON) |
| **Offline-first** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **Active development** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐ |
| **Nix integration** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐ | ⭐ |
| **Learning curve** | ⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐ | ⭐⭐⭐⭐ |
| **Feature richness** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ |
| **Web UI** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ (separate) | ❌ | ⭐⭐⭐⭐ | ❌ |
| **Automation-friendly** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐ |
| **Code-level comments** | ❌ | ⭐⭐⭐⭐⭐ | ❌ | ❌ | ❌ |
| **PR workflow** | ❌ | ⭐⭐⭐⭐⭐ | ❌ | ❌ | ❌ |

---

## Final Recommendation

### For Your Use Case: **git-bug + git-appraise** 🏆

**The Winning Combination**:
```
git-bug (9.5k ⭐)     → Issue tracking, bugs, features
git-appraise (5.3k ⭐) → Code review, PR workflow
```

**Install Now**:
```bash
# Add to modules/home/packages.nix
home.packages = with pkgs; [ 
  git-bug
  git-appraise
];

# Initialize in a test repo
cd ~/test-project

# Setup git-bug
git bug init
git config bug.user.name "engineer-agent"
git config bug.user.email "engineer@agents.local"

# git-appraise works immediately (uses git-notes)
git config user.name "engineer-agent"
git config user.email "engineer@agents.local"

# Create test issue
git bug add "Test issue from agent" -m "Testing multi-agent workflow"

# Create test review
git appraise request -m "Test code review"

# Check git-bug web UI
git bug webui
# Opens http://localhost:8080
```

**Why This Combo Wins**:

**git-bug (Issues)**:
1. ✅ Best multi-agent identity support (each agent = git user)
2. ✅ Most active project (2025 releases, 9.5k stars)
3. ✅ Rich features (web UI, labels, milestones, search)
4. ✅ GraphQL API for advanced automation
5. ✅ Can bridge to GitHub if needed

**git-appraise (Code Review)**:
1. ✅ Perfect PR workflow (designed for code review)
2. ✅ File-level comments (review specific lines)
3. ✅ Google-proven (used at scale)
4. ✅ CI integration support
5. ✅ Complements git-bug perfectly

**Together**:
1. ✅ Complete development lifecycle
2. ✅ Both in nixpkgs (easy installation)
3. ✅ Both agent-friendly (distinct identities)
4. ✅ Both offline-first
5. ✅ Separates concerns (issues ≠ reviews)

**Use Cases**:
- **Issues only**: Use git-bug alone
- **Code review only**: Use git-appraise alone
- **Full workflow**: Use both together (recommended)

**Alternative If**:
- **You want ultra-simple**: Use **bug** (driusan) for plaintext files
- **You're in Scheme ecosystem**: Use **tissue** for gemtext elegance
- **You need gradual adoption**: Start with **bug**, add git-bug/git-appraise later
- **You only need issues**: git-bug alone is perfect
- **You only need code review**: git-appraise alone is perfect

---

## Quick Start Guide

### Setup git-bug + git-appraise in nix-config

```nix
# 1. Add to modules/home/packages.nix
{ pkgs, ... }: {
  home.packages = with pkgs; [
    git-bug
    git-appraise
  ];
}

# 2. Create combined agent identity helper
# scripts/setup-agent-identity.sh
#!/usr/bin/env bash
AGENT_NAME="${1:-engineer-agent}"
REPO_DIR="${2:-.}"
TOOL="${3:-both}"  # both, bug, appraise

cd "$REPO_DIR"

# Initialize git-bug if needed
if [ "$TOOL" = "bug" ] || [ "$TOOL" = "both" ]; then
  if [ ! -d ".git/refs/bugs" ]; then
    git bug init
  fi
  git config --local bug.user.name "$AGENT_NAME"
  git config --local bug.user.email "$AGENT_NAME@agents.local"
  echo "✓ git-bug configured with identity: $AGENT_NAME"
fi

# Configure git-appraise (uses standard git config)
if [ "$TOOL" = "appraise" ] || [ "$TOOL" = "both" ]; then
  git config --local user.name "$AGENT_NAME"
  git config --local user.email "$AGENT_NAME@agents.local"
  echo "✓ git-appraise configured with identity: $AGENT_NAME"
fi

# 3. Create agent workflow wrapper
# scripts/agent-dev.sh
#!/usr/bin/env bash
# Usage: agent-dev <agent> <tool> <action> [args...]
# Examples:
#   agent-dev engineer bug add "Fix memory leak"
#   agent-dev reviewer appraise comment -m "LGTM"

AGENT=$1; shift
TOOL=$1; shift

# Save current identity
PREV_BUG_NAME=$(git config bug.user.name 2>/dev/null)
PREV_BUG_EMAIL=$(git config bug.user.email 2>/dev/null)
PREV_GIT_NAME=$(git config user.name 2>/dev/null)
PREV_GIT_EMAIL=$(git config user.email 2>/dev/null)

# Trap to restore on exit
cleanup() {
  [ -n "$PREV_BUG_NAME" ] && git config bug.user.name "$PREV_BUG_NAME"
  [ -n "$PREV_BUG_EMAIL" ] && git config bug.user.email "$PREV_BUG_EMAIL"
  [ -n "$PREV_GIT_NAME" ] && git config user.name "$PREV_GIT_NAME"
  [ -n "$PREV_GIT_EMAIL" ] && git config user.email "$PREV_GIT_EMAIL"
}
trap cleanup EXIT

# Set agent identity
git config bug.user.name "$AGENT"
git config bug.user.email "$AGENT@agents.local"
git config user.name "$AGENT"
git config user.email "$AGENT@agents.local"

# Execute command
case "$TOOL" in
  bug) git bug "$@" ;;
  appraise) git appraise "$@" ;;
  *) echo "Unknown tool: $TOOL"; exit 1 ;;
esac

# 4. Add to PATH
# modules/home/shell.nix
programs.bash.shellAliases = {
  "agent-setup" = "~/scripts/setup-agent-identity.sh";
  "agent-dev" = "~/scripts/agent-dev.sh";
};

# 5. Usage examples
$ agent-setup engineer-agent ~/my-project
$ cd ~/my-project

# Issue tracking
$ agent-dev engineer bug add "First issue"
$ agent-dev reviewer bug comment abc123 "Confirmed"

# Code review
$ agent-dev engineer appraise request -m "Please review"
$ agent-dev reviewer appraise comment -m "LGTM"
$ agent-dev reviewer appraise accept

# View in browser
$ git bug webui  # http://localhost:8080
```

---

## Resources

**git-bug**:
- Repo: https://github.com/git-bug/git-bug (9.5k ⭐)
- Docs: https://github.com/git-bug/git-bug/tree/trunk/doc
- Matrix: https://matrix.to/#/#git-bug:matrix.org
- Nix: `pkgs.git-bug`

**git-appraise**:
- Repo: https://github.com/google/git-appraise (5.3k ⭐)
- Web UI: https://github.com/google/git-appraise-web
- Docs: https://github.com/google/git-appraise/tree/master/docs
- Nix: `pkgs.git-appraise`

**bug (driusan)**:
- Repo: https://github.com/driusan/bug (210 ⭐)
- Format spec: https://github.com/driusan/PoormanIssueTracker
- Nix: `pkgs.bug`

**tissue**:
- Website: https://tissue.systemreboot.net/
- Repo: https://git.systemreboot.net/tissue/
- Manual: https://tissue.systemreboot.net/manual/dev/en/

**issue (marekjm)**:
- Repo: https://github.com/marekjm/issue (72 ⭐)

---

## Related Documentation

- `docs/ALTERNATIVE_ISSUE_TRACKING_PLATFORMS.md` - Cloud/hosted options
- `docs/GITHUB_AGENT_IDENTITY_OPTIONS.md` - GitHub-specific solutions
- `docs/AGENT_CONFIG_INCONSISTENCIES.md` - Current agent setup

---

**Version History**:
- 1.0 (2025-10-08): Initial research and recommendations
