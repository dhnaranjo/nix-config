# GitHub Agent Identity Options

**Last Updated**: 2025-10-08  
**Status**: Research Complete

---

## Problem Statement

Current AI agent workflows expect multiple agents (`engineer`, `code-reviewer`, etc.) to post comments to GitHub issues with distinct identities. However, using a **Personal Access Token** (PAT) means all actions appear to come from the same user account (dazmin).

**Question**: How can we make agents appear as separate identities on GitHub?

---

## Research Findings

### Current Limitation: Personal Access Tokens

**What We Have Now**:
```nix
# modules/home/opencode.nix
github = {
  type = "local";
  command = [ "${pkgs.github-mcp-server}/bin/github-mcp-server" ];
  environment = {
    GITHUB_PERSONAL_ACCESS_TOKEN = "{file:${config.sops.secrets.github-token.path}}";
  };
};
```

**Result**: All comments appear as:
- 👤 **dazmin** commented
- No visual distinction between engineer and code-reviewer
- All actions attributed to your personal account

---

## Option 1: Comment Body Signatures ✅ SIMPLEST

### Implementation

Add clear visual markers in comment content:

```markdown
## 🛠️ Engineer Agent - Implementation Report

Phase 2 implementation complete...
```

```markdown
## 🔍 Code Reviewer Agent - Review Report

Code quality assessment...
```

### Pros
- ✅ **Zero configuration required**
- ✅ Works with existing PAT setup
- ✅ No additional GitHub accounts needed
- ✅ Clear visual distinction in comments
- ✅ Can use emojis for quick identification

### Cons
- ⚠️ Comments still show same user avatar
- ⚠️ GitHub timeline doesn't distinguish agents
- ⚠️ Not "true" separate identities

### Effort
**Trivial** - Just update agent comment templates

---

## Option 2: GitHub Bot Accounts 🤖 MODERATE

### Implementation

Create separate GitHub accounts for each agent:

1. **Create bot accounts** (free GitHub accounts):
   - `dazmin-engineer-bot`
   - `dazmin-code-reviewer-bot`
   
2. **Generate PATs for each bot**:
   - Each bot needs its own Personal Access Token
   - Store in sops secrets: `engineer-bot-token`, `reviewer-bot-token`

3. **Configure multiple GitHub MCP servers**:
```nix
# modules/home/opencode.nix
github-engineer = {
  type = "local";
  command = [ "${pkgs.github-mcp-server}/bin/github-mcp-server" ];
  environment = {
    GITHUB_PERSONAL_ACCESS_TOKEN = "{file:${config.sops.secrets.engineer-bot-token.path}}";
  };
};

github-reviewer = {
  type = "local";
  command = [ "${pkgs.github-mcp-server}/bin/github-mcp-server" ];
  environment = {
    GITHUB_PERSONAL_ACCESS_TOKEN = "{file:${config.sops.secrets.reviewer-bot-token.path}}";
  };
};
```

4. **Update agent commands** to use specific MCP servers:
   - `engineer` agent uses `github-engineer` MCP server
   - `code-reviewer` agent uses `github-reviewer` MCP server

### Pros
- ✅ True separate identities on GitHub
- ✅ Each bot has distinct avatar
- ✅ GitHub timeline clearly shows which bot acted
- ✅ Can customize bot profiles (bios, avatars)
- ✅ Free (GitHub allows multiple accounts)

### Cons
- ⚠️ Requires managing multiple GitHub accounts
- ⚠️ Need to add bots as collaborators to repos
- ⚠️ More secrets to manage
- ⚠️ Multiple MCP server configurations
- ⚠️ Against GitHub ToS if used to circumvent restrictions

### Effort
**Moderate** - 1-2 hours setup, ongoing maintenance

### GitHub Terms of Service Consideration
GitHub ToS states: *"One person or legal entity may maintain no more than one free Account"* for the purpose of circumventing restrictions. Bot accounts for automation are generally acceptable for open source/personal projects but consult GitHub's guidelines.

---

## Option 3: GitHub Apps 🏢 PROFESSIONAL

### Implementation

Create **one GitHub App** with installation-based authentication:

1. **Create GitHub App** at https://github.com/settings/apps/new:
   - Name: "Dazmin AI Agents"
   - Permissions: Issues (Read & Write), Pull Requests (Read & Write)
   - Generate private key

2. **Install app** to your repositories

3. **Configure GitHub MCP with App credentials**:

**Current GitHub MCP Server Status**:
- ⚠️ **GitHub MCP server has limited GitHub App support** (as of 2025)
- Issue #696 confirms installation tokens have authentication challenges
- Primary auth method is still Personal Access Tokens

**If/When GitHub MCP supports Apps**:
```nix
github = {
  type = "local";
  command = [ "${pkgs.github-mcp-server}/bin/github-mcp-server" ];
  environment = {
    GITHUB_APP_ID = "123456";
    GITHUB_APP_PRIVATE_KEY = "{file:${config.sops.secrets.github-app-key.path}}";
    GITHUB_APP_INSTALLATION_ID = "987654";
  };
};
```

4. **Agent comments would appear as**:
   - 🤖 **dazmin-ai-agents[bot]** commented
   - GitHub automatically adds `[bot]` badge

### Pros
- ✅ Official GitHub-supported identity
- ✅ Clear `[bot]` badge on all comments
- ✅ Single app, multiple installations possible
- ✅ Fine-grained permissions per installation
- ✅ No ToS concerns (official automation method)
- ✅ Can distinguish agents in comment body

### Cons
- ❌ **GitHub MCP Server doesn't fully support App auth yet**
- ⚠️ More complex setup (JWT tokens, installation IDs)
- ⚠️ Still one identity (the App) - not separate per agent
- ⚠️ Would need comment signatures to distinguish engineer vs reviewer

### Effort
**High** - Complex setup, **blocked by MCP limitations**

### Reference
- Issue: https://github.com/github/github-mcp-server/issues/696
- Status: Installation tokens fail with current MCP server

---

## Recommendation Matrix

| Approach | Separate Identities | Effort | Works Now | Best For |
|----------|-------------------|--------|-----------|----------|
| **Comment Signatures** | Visual only | ⭐ Trivial | ✅ Yes | Quick solution, minimal overhead |
| **Bot Accounts** | ✅ True | ⭐⭐ Moderate | ✅ Yes | Clear agent distinction needed |
| **GitHub Apps** | Partial | ⭐⭐⭐ High | ❌ No | Future-proof, when MCP supports it |

---

## Recommended Approach

### Immediate: **Option 1 - Comment Signatures**

**Why**: 
- Works immediately with zero config changes
- Clear enough for personal projects
- No maintenance overhead
- Can upgrade to Option 2 later if needed

**Implementation**:
1. Update `apps/ai-agents/commands/issue-engineer.md` to include signature templates
2. Update `apps/ai-agents/commands/engineer.md` to include signature templates
3. Add emoji/header conventions for each agent type

### Future: **Option 3 - GitHub Apps (when MCP supports it)**

**Why**:
- Official GitHub method
- Proper automation identity
- Professional appearance

**Monitor**:
- Watch https://github.com/github/github-mcp-server for App auth support
- Check MCP server releases for installation token authentication

---

## Implementation Steps for Option 1 (Recommended)

### 1. Define Agent Signatures

```markdown
# Engineer Agent
## 🛠️ Engineer Agent Report
**Agent**: Implementation Engineer  
**Phase**: {PHASE_NUMBER}  
**Status**: Complete

{report content}

---
*Posted by AI Agent System - Engineer*
```

```markdown
# Code Reviewer Agent
## 🔍 Code Review Report
**Agent**: Quality Assurance Reviewer  
**Phase**: {PHASE_NUMBER}  
**Status**: {APPROVED|CHANGES_REQUESTED}

{review content}

---
*Posted by AI Agent System - Code Reviewer*
```

### 2. Update Agent Commands

**Files to Modify**:
- `apps/ai-agents/commands/issue-engineer.md` (lines 240-275)
- `apps/ai-agents/commands/engineer.md` (line 18-22)

**Add Template Sections**:
```markdown
### Comment Template for Engineer
When posting implementation report, use this format:
[signature template above]

### Comment Template for Reviewer
When posting review report, use this format:
[signature template above]
```

### 3. Test in Real Issue

1. Create test issue in personal repo
2. Run issue workflow
3. Verify comments have clear signatures
4. Iterate on formatting if needed

---

## Future Considerations

### When to Upgrade to Option 2 (Bot Accounts)

Consider if:
- Working on team projects where clarity matters
- Agents post frequently and signatures aren't enough
- Want professional appearance in public repos
- Need distinct permissions per agent

### When Option 3 Becomes Available

Monitor for:
- GitHub MCP server changelog mentions "GitHub App authentication"
- Closed issues related to installation tokens
- Community adoption of App-based auth

**Then**:
1. Create GitHub App
2. Update opencode.nix configuration
3. Migrate from PAT to App authentication
4. Keep comment signatures for agent distinction

---

## Related Files

- Current config: `modules/home/opencode.nix`
- Secrets: `modules/home/secrets.nix`, `secrets/secrets.enc.yaml`
- Agent workflows: `apps/ai-agents/commands/issue-engineer.md`
- Agent definitions: `apps/ai-agents/commands/engineer.md`

---

## References

- [GitHub Apps vs PAT](https://docs.github.com/en/apps/creating-github-apps/about-creating-github-apps/about-creating-github-apps)
- [GitHub App Installation Auth](https://docs.github.com/en/apps/creating-github-apps/authenticating-with-a-github-app/authenticating-as-a-github-app-installation)
- [GitHub MCP Server Issue #696](https://github.com/github/github-mcp-server/issues/696)
- [Creating Bot Accounts](https://kishanjasani.in/how-to-create-github-bot-account/)
