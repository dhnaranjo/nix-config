# Documentation Index
**Last Updated:** 2025-10-08

## Overview

This directory contains comprehensive documentation for the AI agent system used in 
this repository. The documentation covers agent applications, analysis of the agent 
roster, and various research into supporting infrastructure.

---

## Agent Documentation

### Core Agent Guides

**[AGENT_APPLICATIONS.md](./AGENT_APPLICATIONS.md)**  
Comprehensive guide on how to apply AI agents across different project types and scenarios.

**Topics Covered:**
- Project types & scales (Nix configs, Rails apps, React apps, scripts, microservices)
- Agent combinations for different scenarios (new projects, joining teams, legacy code)
- Workflow patterns (GitHub issues, TDD, refactoring, documentation-first)
- Best practices for agent team sizing and coordination

**Use this when:** You need to understand which agents to use for a specific task or 
project type.

---

**[AGENT_ROSTER_ANALYSIS.md](./AGENT_ROSTER_ANALYSIS.md)**  
Deep analysis of the current agent roster identifying gaps, overlaps, and ambiguities.

**Topics Covered:**
- Current agent inventory (24 agents across 4 categories)
- Critical gaps (missing database, security, DevOps specialists)
- Overlapping responsibilities between agents
- Broken delegation chains
- Recommendations for improvement

**Use this when:** You're designing the agent team, identifying missing capabilities, 
or resolving confusion about which agent to use.

**Key Findings:**
- 6 missing agents that are referenced but don't exist
- Healthy overlap between architect roles (just needs documentation)
- 5 critical agents needed immediately (database, security, DevOps, refactoring, accessibility)

---

### Configuration & Infrastructure

**[AGENT_CONFIG_INCONSISTENCIES.md](./AGENT_CONFIG_INCONSISTENCIES.md)**  
Analysis of inconsistencies in agent configuration files.

**Use this when:** Debugging agent behavior or standardizing agent configurations.

---

**[GITHUB_AGENT_IDENTITY_OPTIONS.md](./GITHUB_AGENT_IDENTITY_OPTIONS.md)**  
Research on how to handle agent identity when interacting with GitHub.

**Use this when:** Setting up agents to interact with GitHub (commenting on issues, 
creating PRs, etc.) and deciding on identity/authentication strategy.

---

### Issue Tracking Research

**[ALTERNATIVE_ISSUE_TRACKING_PLATFORMS.md](./ALTERNATIVE_ISSUE_TRACKING_PLATFORMS.md)**  
Survey of issue tracking platforms beyond GitHub Issues.

**Use this when:** Evaluating issue tracking options for your project.

---

**[FILE_BASED_OSS_ISSUE_TRACKERS.md](./FILE_BASED_OSS_ISSUE_TRACKERS.md)**  
Deep dive into file-based, version-controlled issue tracking systems.

**Topics Covered:**
- Plain text issue trackers (git-bug, sit, Ditz, etc.)
- Static site generators for issues
- Email-based workflows
- Comparison matrix

**Use this when:** Considering a git-native, file-based issue tracking system instead 
of web-based platforms.

---

## Quick Reference

### Common Scenarios

| Scenario | Primary Documentation | Key Agents |
|----------|----------------------|------------|
| Starting new Rails project | [AGENT_APPLICATIONS.md](./AGENT_APPLICATIONS.md#2-rails-applications) | team-configurator, rails-backend-expert, rails-api-developer |
| Starting new React project | [AGENT_APPLICATIONS.md](./AGENT_APPLICATIONS.md#3-react-applications) | team-configurator, react-component-architect, react-state-manager |
| Joining existing team | [AGENT_APPLICATIONS.md](./AGENT_APPLICATIONS.md#joining-an-existing-team) | code-archaeologist, project-analyst, documentation-specialist |
| Legacy codebase | [AGENT_APPLICATIONS.md](./AGENT_APPLICATIONS.md#inherited-legacy-codebase) | code-archaeologist, code-architect, refactoring-expert* |
| Emergency bug fix | [AGENT_APPLICATIONS.md](./AGENT_APPLICATIONS.md#emergency-bug-fixes) | engineer, code-reviewer |
| Configuration management (Nix) | [AGENT_APPLICATIONS.md](./AGENT_APPLICATIONS.md#1-configuration-repositories-eg-nix-config) | engineer, documentation-specialist, code-reviewer |

*Agent does not exist yet - see [AGENT_ROSTER_ANALYSIS.md](./AGENT_ROSTER_ANALYSIS.md#4-refactoring-specialist-medium-priority-gap)

### Agent Categories

| Category | Count | Documentation |
|----------|-------|---------------|
| Orchestrators | 3 | [AGENT_ROSTER_ANALYSIS.md](./AGENT_ROSTER_ANALYSIS.md#orchestrators-3-agents) |
| Core | 4 | [AGENT_ROSTER_ANALYSIS.md](./AGENT_ROSTER_ANALYSIS.md#core-4-agents) |
| Specialists | 10 | [AGENT_ROSTER_ANALYSIS.md](./AGENT_ROSTER_ANALYSIS.md#top-level-specialists-7-agents) |
| Universal | 4 | [AGENT_ROSTER_ANALYSIS.md](./AGENT_ROSTER_ANALYSIS.md#specialized-agents-10-agents) |
| **Total** | **24** | - |
| Missing (Critical) | 5 | [AGENT_ROSTER_ANALYSIS.md](./AGENT_ROSTER_ANALYSIS.md#identified-gaps) |

### Known Issues

**Critical Gaps (from [AGENT_ROSTER_ANALYSIS.md](./AGENT_ROSTER_ANALYSIS.md)):**
1. ❌ **database-architect** - Referenced by 3+ agents but doesn't exist
2. ❌ **security-guardian** - Referenced by 3+ agents but doesn't exist  
3. ❌ **devops-engineer** - Referenced by performance-optimizer but doesn't exist
4. ❌ **refactoring-expert** - Referenced by 2 agents but doesn't exist
5. ❌ **accessibility-expert** - Referenced by frontend-developer but doesn't exist

**Overlap Ambiguities:**
- code-architect vs api-architect (needs boundary documentation)
- engineer vs specialized developers (healthy flexibility, needs priority docs)
- coverage-analyzer vs playwright-analyzer (clear separation by test type)

See [AGENT_ROSTER_ANALYSIS.md - Overlapping Responsibilities](./AGENT_ROSTER_ANALYSIS.md#overlapping-responsibilities) 
for details.

---

## How to Use This Documentation

### For New Users

1. **Start here:** [AGENT_APPLICATIONS.md - Overview](./AGENT_APPLICATIONS.md#overview)
2. **Find your scenario:** Browse [Agent Combinations by Scenario](./AGENT_APPLICATIONS.md#agent-combinations-by-scenario)
3. **Understand the agents:** Review [AGENT_ROSTER_ANALYSIS.md - Current Agent Inventory](./AGENT_ROSTER_ANALYSIS.md#current-agent-inventory)

### For Experienced Users

1. **Quick reference:** Use the tables above to find agents for common scenarios
2. **Troubleshooting:** Check [Known Issues](#known-issues) if agents aren't behaving as expected
3. **Advanced workflows:** See [Workflow Patterns](./AGENT_APPLICATIONS.md#workflow-patterns)

### For Agent System Designers

1. **Gap analysis:** [AGENT_ROSTER_ANALYSIS.md - Identified Gaps](./AGENT_ROSTER_ANALYSIS.md#identified-gaps)
2. **Overlap resolution:** [AGENT_ROSTER_ANALYSIS.md - Overlapping Responsibilities](./AGENT_ROSTER_ANALYSIS.md#overlapping-responsibilities)
3. **Recommendations:** [AGENT_ROSTER_ANALYSIS.md - Recommendations Summary](./AGENT_ROSTER_ANALYSIS.md#recommendations-summary)

---

## Contributing to Documentation

When adding new documentation:

1. **Follow the template:**
   - Include "Last Updated" and "Version" at the top
   - Add Table of Contents for documents >100 lines
   - Use clear hierarchical headers (##, ###, ####)

2. **Cross-reference:**
   - Link to related documentation
   - Use relative paths (e.g., `[text](./FILE.md#section)`)

3. **Update this index:**
   - Add new documents to the appropriate section
   - Update the Quick Reference tables if relevant

4. **Keep it current:**
   - Update "Last Updated" when making significant changes
   - Increment version for major rewrites
   - Archive old versions if needed

---

## Document Status

| Document | Status | Last Updated | Priority |
|----------|--------|--------------|----------|
| AGENT_APPLICATIONS.md | ✅ Current | 2025-10-08 | High |
| AGENT_ROSTER_ANALYSIS.md | ✅ Current | 2025-10-08 | High |
| AGENT_CONFIG_INCONSISTENCIES.md | ✅ Current | 2025-10-08 | Medium |
| GITHUB_AGENT_IDENTITY_OPTIONS.md | ✅ Current | 2025-10-08 | Medium |
| ALTERNATIVE_ISSUE_TRACKING_PLATFORMS.md | ✅ Current | 2025-10-08 | Low |
| FILE_BASED_OSS_ISSUE_TRACKERS.md | ✅ Current | 2025-10-08 | Low |

---

## External Resources

### Agent Definitions
- Agent source files: `../apps/ai-agents/agents/`
- Command definitions: `../apps/ai-agents/commands/`
- Main agent README: `../apps/ai-agents/AGENTS.md`

### Related Configuration
- Project configuration: `../configurations/`
- Nix modules: `../modules/`
- Main README: `../README.md` (if exists)

---

## Feedback & Updates

This documentation is a living resource. If you find:
- **Gaps in coverage:** Request new documentation
- **Outdated information:** Submit updates
- **Unclear explanations:** Request clarification
- **Broken links:** Report for fixing

Keep this documentation aligned with the actual agent implementations in 
`../apps/ai-agents/agents/`.
