# Alternative Issue Tracking Platforms for Multi-Agent Workflows

**Last Updated**: 2025-10-08  
**Context**: Research on alternatives to GitHub/Gitea for multi-agent conversational issue tracking

---

## Problem Statement

We need a platform that supports:
1. **Issue tracking** with threaded discussions
2. **Multiple distinct bot/agent identities** posting comments
3. **Good API** for automation
4. **Self-hostable** (preferred) or trustworthy cloud service
5. **Conversational workflow** - agents can reply to each other and humans

**Current Limitation**: GitHub/Gitea require bot accounts (maintenance overhead) or show all agents as same user.

---

## Evaluated Platforms

### 🏆 **Option 1: Linear** - BEST FOR: Professional teams

**Website**: https://linear.app  
**Type**: Cloud service (paid), API-first  
**Agent Support**: ✅ **NATIVE AGENT SUPPORT** (launched 2025)

#### Why Linear Excels

Linear recently launched [**"Linear for Agents"**](https://linear.app/agents) - purpose-built for AI agent collaboration:

**Key Features**:
- 🤖 **Agents as first-class citizens** - appear as team members
- 👥 **Distinct identities** - each agent has own name, avatar, profile
- 💬 **@mention agents** in comments - `@engineer-agent`, `@code-reviewer`
- 📋 **Assign issues to agents** directly
- 🔄 **Agents can reply to each other** in comment threads
- 📊 **Human accountability** - human stays primary assignee, agent is contributor
- 🔍 **Transparent actions** - see reasoning behind agent decisions

#### Agent API

```typescript
// Linear's agent-specific APIs
- Agent session events via webhooks
- Post comments as specific agent identity
- Assign/unassign agent to issues
- Agent activity tracking
```

**Developer Experience**:
- TypeScript SDK with agent support
- Webhook events for @mentions and assignments
- OAuth for agent installation

**Examples in Production**:
- Cursor (code generation agent)
- Devin (eng

ineering agent)
- Sentry Seer (bug triage agent)
- ChatPRD (product requirements agent)

#### Pros
- ✅ **Best-in-class agent support** - purpose-built for this use case
- ✅ Distinct agent identities with no bot account management
- ✅ Beautiful UI, excellent developer experience
- ✅ Robust API with TypeScript SDK
- ✅ Agents can collaborate in threads naturally
- ✅ Production-ready examples to learn from

#### Cons
- ❌ **Cloud only** - not self-hostable
- ❌ **Paid service** ($8-19/user/month)
- ❌ Requires trusting Linear with your data
- ❌ Vendor lock-in

#### Setup Complexity
**Low** - Linear makes this easy with official agent APIs

#### Recommendation
**⭐⭐⭐⭐⭐ Highest recommendation** if you're okay with cloud services

---

### 🥈 **Option 2: Plane** - BEST FOR: Self-hosted alternative

**Website**: https://plane.so  
**Type**: Open source, self-hostable (MIT/AGPL)  
**Agent Support**: ⚠️ Via API (not native agent support)

#### Overview

Plane is an open-source project management tool, similar to Linear but self-hostable.

**Key Features**:
- 📋 Issue tracking with comments
- 🔗 Public API for automation
- 🐳 Docker/Kubernetes deployment
- 💰 Free and open source
- 🎨 Modern UI comparable to Linear

#### API Capabilities

```bash
# Plane API supports:
POST /api/v1/workspaces/{workspace}/projects/{project}/issues/{issue}/comments
  - Create comment (authenticated as API token owner)
  
# Multi-agent approach:
- Create separate user accounts for each agent
- Each gets own API token
- Comments show distinct user identities
```

**Agent Strategy**: User accounts per agent (similar to GitHub bot accounts)

#### Pros
- ✅ **Self-hostable** - full data control
- ✅ Open source (MIT/AGPL)
- ✅ Good API documentation
- ✅ Modern, fast UI
- ✅ Active development
- ✅ Free

#### Cons
- ⚠️ No native agent support (use user accounts)
- ⚠️ Requires managing multiple user accounts
- ⚠️ Self-hosting overhead (maintenance, updates, backups)
- ⚠️ Smaller community than established tools

#### Setup Complexity
**Medium** - Self-hosting + user account management

#### Recommendation
**⭐⭐⭐⭐ Strong choice** for self-hosting needs

---

### 🥉 **Option 3: Discord + Threads** - BEST FOR: Conversational workflow

**Website**: https://discord.com  
**Type**: Cloud service (free tier available)  
**Agent Support**: ✅ **Native bot support**

#### Why Discord Works

Discord isn't traditionally "issue tracking" but supports the **conversational workflow** extremely well:

**Key Features**:
- 🤖 **First-class bot support** - bots have distinct identities
- 🧵 **Threaded discussions** - each issue = thread
- 💬 **Real-time conversation** - agents can reply instantly
- 🆓 **Free tier** - generous limits
- 📱 **Great mobile/desktop apps**
- 🔔 **Rich notifications**

#### Agent Implementation

```python
# Discord Bot API
import discord

engineer_bot = discord.Client(intents=intents, name="Engineer Agent")
reviewer_bot = discord.Client(intents=intents, name="Code Reviewer")

# Each bot has:
- Distinct username
- Custom avatar
- Custom status
- Rich embed messages
```

**Workflow Mapping**:
- **Channel** = Project
- **Thread** = Issue
- **Messages** = Comments
- **Reactions** = Status/labels
- **Webhooks** = External integrations

#### Pros
- ✅ **Excellent bot identity support** - bots are first-class
- ✅ Free tier suitable for personal projects
- ✅ Mature bot API and libraries
- ✅ Real-time, conversational feel
- ✅ Great mobile/desktop experience
- ✅ Easy to set up bots

#### Cons
- ❌ **Not purpose-built for issue tracking** - need conventions
- ❌ Cloud only (not self-hostable)
- ❌ No formal issue states/workflows
- ❌ Searching/filtering less robust than dedicated tools
- ❌ Requires creative mapping to issue tracking concepts

#### Setup Complexity
**Low** - Discord bots are well-documented

#### Recommendation
**⭐⭐⭐⭐ Great for conversational feel** but requires adapting paradigm

---

### **Option 4: Zulip** - BEST FOR: Self-hosted conversation

**Website**: https://zulip.com  
**Type**: Open source, self-hostable  
**Agent Support**: ✅ **Native bot support**

#### Overview

Zulip is open-source team chat with threaded conversations (topics).

**Key Features**:
- 🔓 Open source (Apache 2.0)
- 🐳 Self-hostable
- 🧵 **Topics = threaded conversations**
- 🤖 **Bot framework** built-in
- 📜 Excellent message history/search

#### Agent Implementation

```python
# Zulip bot framework
import zulip

engineer_bot = zulip.Client(email="engineer@bot.example.com")
reviewer_bot = zulip.Client(email="reviewer@bot.example.com")

# Each bot:
- Distinct account and identity
- Can post to specific topics (threads)
- React to @mentions
- Rich message formatting
```

**Workflow Mapping**:
- **Stream** = Project
- **Topic** = Issue
- **Messages** = Comments
- **Emoji reactions** = Status

#### Pros
- ✅ **Self-hostable** with Docker
- ✅ Open source
- ✅ Native bot support
- ✅ Threaded conversations (topics)
- ✅ Good search and history
- ✅ Free

#### Cons
- ⚠️ Not purpose-built for issue tracking
- ⚠️ Bots require separate accounts
- ⚠️ Self-hosting overhead
- ⚠️ Smaller ecosystem than Discord

#### Setup Complexity
**Medium** - Self-hosting + bot account setup

#### Recommendation
**⭐⭐⭐ Good self-hosted conversational alternative**

---

### **Option 5: Notion** - BEST FOR: Existing Notion users

**Website**: https://notion.com  
**Type**: Cloud service  
**Agent Support**: ✅ **Notion Agents** (launched 2025)

#### Overview

Notion recently launched native AI agents similar to Linear.

**Key Features**:
- 🤖 **Notion Agents 3.0** - agents as team members
- 📊 Database-based issue tracking
- 💬 Comments and discussions
- 🔗 Robust API

#### Agent Implementation

Notion agents can:
- Create/update database entries (issues)
- Post comments
- Assign tasks
- Have memory and instructions

**Limitation**: Agents use Notion's native agent system - less flexibility for custom agents

#### Pros
- ✅ Native agent support
- ✅ Flexible database structure
- ✅ Rich content in issues
- ✅ Good API

#### Cons
- ❌ Cloud only
- ❌ Paid service
- ❌ Less control over custom agents
- ❌ API rate limits

#### Setup Complexity
**Low** - if already using Notion

#### Recommendation
**⭐⭐⭐ Good if already in Notion ecosystem**

---

### **Option 6: Custom Solution** - BEST FOR: Maximum control

#### Build Your Own

Use a messaging/collaboration platform as the base:

**Tech Stack Options**:

**Option A: Matrix (self-hosted)**
- Open protocol for federated chat
- Bot support via SDK
- Self-hostable (Synapse server)
- Bridges to other platforms

**Option B: Mattermost (self-hosted)**
- Open source Slack alternative
- Bot/webhook API
- Self-hostable
- Plugin system

**Option C: PostgreSQL + Custom API**
- Full control over data model
- Build exactly what you need
- Simple REST API
- Multiple API tokens = multiple identities

#### Pros
- ✅ Complete control
- ✅ Exactly fits your needs
- ✅ Self-hosted
- ✅ No vendor lock-in

#### Cons
- ❌ **Significant development time**
- ❌ Ongoing maintenance burden
- ❌ Need to build UI, API, auth, etc.
- ❌ Opportunity cost

#### Recommendation
**⭐⭐ Only if you have specific needs** not met by existing tools

---

## Comparison Matrix

| Platform | Agent Identities | Self-Hosted | Issue Tracking | Setup | Cost | Overall |
|----------|------------------|-------------|----------------|-------|------|---------|
| **Linear** | ⭐⭐⭐⭐⭐ Native | ❌ Cloud | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ Easy | 💰 Paid | **⭐⭐⭐⭐⭐** |
| **Plane** | ⭐⭐⭐ Via users | ✅ Yes | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ Medium | 🆓 Free | **⭐⭐⭐⭐** |
| **Discord** | ⭐⭐⭐⭐⭐ Native | ❌ Cloud | ⭐⭐ Adapt | ⭐⭐⭐⭐ Easy | 🆓 Free | **⭐⭐⭐⭐** |
| **Zulip** | ⭐⭐⭐⭐ Via users | ✅ Yes | ⭐⭐ Adapt | ⭐⭐⭐ Medium | 🆓 Free | **⭐⭐⭐** |
| **Notion** | ⭐⭐⭐⭐ Native | ❌ Cloud | ⭐⭐⭐⭐ | ⭐⭐⭐ Easy | 💰 Paid | **⭐⭐⭐** |
| **Custom** | ⭐⭐⭐⭐⭐ Full | ✅ Yes | ⭐⭐⭐⭐⭐ | ⭐ Hard | 🆓 Free | **⭐⭐** |

---

## Decision Framework

### If you value: **Best Agent Experience**
→ **Linear** (cloud, paid, but purpose-built)

### If you value: **Self-hosting + Issue Tracking**
→ **Plane** (open source, modern UI)

### If you value: **Conversational Feel**
→ **Discord** (free, great bot support) or **Zulip** (self-hosted)

### If you value: **Already in ecosystem**
→ **Notion** (if you're already using Notion)

### If you value: **Maximum control**
→ **Custom solution** (but only if you really need it)

---

## Recommended Approach

### Phase 1: Try Linear (2-4 weeks)

1. **Sign up for Linear trial**
2. **Create simple agent integration** using their TypeScript SDK
3. **Test multi-agent workflow**:
   - Engineer agent posts implementation reports
   - Code reviewer agent posts reviews
   - Agents reply to each other
4. **Evaluate**:
   - Does the workflow feel natural?
   - Is the cost justified?
   - Does vendor lock-in concern you?

**If Linear works**: Proceed with production setup  
**If concerns about cost/cloud**: Move to Phase 2

### Phase 2: Self-host Plane (if needed)

1. **Deploy Plane** with Docker Compose
2. **Create agent user accounts**
3. **Build simple integration** with Python/Go
4. **Migrate workflow** from Linear test

**Fallback**: If Plane doesn't meet needs, evaluate Discord/Zulip

---

## Implementation Guide: Linear

### 1. Setup

```bash
# Install Linear SDK
npm install @linear/sdk

# Or Python (unofficial)
pip install linear-sdk
```

### 2. Create Agent Application

1. Go to Linear Settings → API → Applications
2. Create new application: "AI Agents"
3. Enable **"Agent session events"** webhook
4. Note Client ID and Client Secret

### 3. Agent Code Structure

```typescript
// engineer-agent.ts
import { LinearClient } from "@linear/sdk";

const engineer = new LinearClient({
  apiKey: process.env.LINEAR_ENGINEER_TOKEN
});

// Listen for @mentions
webhook.on("agent.mention", async (event) => {
  if (event.mention.includes("@engineer-agent")) {
    // Fetch issue details
    const issue = await engineer.issue(event.issueId);
    
    // Do engineering work...
    const implementation = await implementFeature(issue);
    
    // Post comment as engineer agent
    await issue.createComment({
      body: `## 🛠️ Engineer Agent Report\n\n${implementation}`
    });
  }
});
```

### 4. Deploy

- Host on: Cloudflare Workers, AWS Lambda, or simple VPS
- Use webhook endpoint for real-time agent triggers
- Store secrets in environment variables

---

## Implementation Guide: Plane

### 1. Deploy Plane

```bash
# Clone Plane
git clone https://github.com/makeplane/plane
cd plane

# Deploy with Docker Compose
docker-compose up -d

# Access at http://localhost
```

### 2. Create Agent Accounts

1. Create user accounts:
   - `engineer@agents.local`
   - `reviewer@agents.local`
2. Generate API tokens for each
3. Store in secrets management

### 3. Agent Code Structure

```python
# engineer_agent.py
import requests

class PlaneEngineerAgent:
    def __init__(self, api_url, api_token):
        self.api_url = api_url
        self.headers = {
            "Authorization": f"Bearer {api_token}",
            "Content-Type": "application/json"
        }
    
    def post_comment(self, issue_id, content):
        url = f"{self.api_url}/api/v1/issues/{issue_id}/comments"
        data = {"comment": f"## 🛠️ Engineer Report\n\n{content}"}
        return requests.post(url, json=data, headers=self.headers)

engineer = PlaneEngineerAgent(
    api_url="http://localhost:8000",
    api_token=os.getenv("ENGINEER_TOKEN")
)
```

---

## Cost Analysis

### Linear
- **Free**: Trial (limited time)
- **Paid**: $8/user/month (billed annually)
- **For 3 agents + 1 human**: ~$32/month
- **Value**: Saves dev time, excellent UX

### Plane (Self-hosted)
- **Service**: Free (open source)
- **Infrastructure**: $5-20/month (small VPS)
- **Time**: ~4 hours setup + 1 hour/month maintenance
- **Total**: ~$15/month + time

### Discord
- **Free tier**: Sufficient for personal projects
- **Paid**: $9.99/month (Nitro, optional)
- **Bots**: Free
- **Total**: $0-10/month

---

## Migration Path from GitHub

If switching from GitHub to any platform:

1. **Export GitHub issues** to JSON/CSV
2. **Write migration script** to import to new platform
3. **Update agent commands** to use new platform API
4. **Update MCP configuration** (if building custom MCP server)
5. **Test workflow** with sample issues
6. **Gradual migration**: New projects use new platform first

---

## Conclusion

**TL;DR Recommendations**:

1. **Best overall**: **Linear** - if cloud/paid is acceptable
2. **Best self-hosted**: **Plane** - modern, purpose-built
3. **Best conversational**: **Discord** - natural multi-agent feel
4. **Most flexible**: **Custom** - only if really needed

**My recommendation for you**: 

Try **Linear** first (they likely have a trial). The native agent support is game-changing and will save significant development time. If cost or cloud concerns are dealbreakers, **Plane** is an excellent self-hosted alternative that's specifically built for issue tracking.

Avoid building custom unless Linear and Plane both don't meet your needs - the opportunity cost is high.

---

## Related Documentation

- `docs/GITHUB_AGENT_IDENTITY_OPTIONS.md` - GitHub-specific solutions
- `docs/AGENT_CONFIG_INCONSISTENCIES.md` - Current agent configuration issues
- `modules/home/opencode.nix` - MCP server configuration

---

## References

- [Linear for Agents](https://linear.app/agents)
- [Linear API Docs](https://developers.linear.app/)
- [Plane Documentation](https://developers.plane.so/)
- [Discord Bot Guide](https://discord.com/developers/docs)
- [Zulip Bot Framework](https://zulip.com/api/writing-bots)
- [Notion Agents 3.0](https://www.notion.com/releases/2025-09-18)
