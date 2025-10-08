# Agent Applications Guide
**Last Updated:** 2025-10-08  
**Version:** 1.0

## Table of Contents
- [Overview](#overview)
- [Project Types & Scales](#project-types--scales)
- [Agent Combinations by Scenario](#agent-combinations-by-scenario)
- [Workflow Patterns](#workflow-patterns)
- [Best Practices](#best-practices)

---

## Overview

This guide documents practical applications of AI agents across different project 
types, team scenarios, and scales. It provides concrete examples of which agents to 
use, when to use them, and how to combine them effectively.

### Agent Categories
- **Orchestrators**: High-level coordination and planning
- **Core**: Fundamental development capabilities
- **Specialized**: Framework/technology-specific expertise
- **Universal**: Technology-agnostic development support

---

## Project Types & Scales

### 1. Configuration Repositories (e.g., Nix Config)

**Characteristics:**
- Declarative configuration files
- Infrastructure as code
- Limited test automation
- High impact of errors
- Version-controlled system state

**Recommended Agent Stack:**

#### Initial Analysis
```
team-configurator → Detects Nix/NixOS project structure
  ↓
project-analyst → Identifies module patterns, flake structure
```

#### Daily Development Workflow
```
Primary: engineer
Support: documentation-specialist, code-reviewer
```

**Example Use Cases:**

**Adding New Module:**
```bash
# Command: /engineer
User: "Add a new home-manager module for tmux configuration"

Flow:
1. engineer analyzes existing modules/home/ structure
2. Creates new modules/home/tmux.nix following patterns
3. Updates modules/home/default.nix imports
4. documentation-specialist updates relevant docs
5. code-reviewer validates Nix syntax and conventions
```

**Refactoring Existing Config:**
```bash
# Command: /code-review
User: "Review my darwin homebrew configuration for improvements"

Flow:
1. code-reviewer examines modules/darwin/homebrew.nix
2. Identifies opportunities (DRY violations, outdated patterns)
3. Suggests improvements with rationale
4. engineer implements approved changes
```

**Troubleshooting Build Issues:**
```bash
# No specific command needed
User: "My flake won't build, errors about missing inputs"

Flow:
1. engineer reads error output
2. Analyzes flake.nix and flake.lock
3. Identifies missing or misconfigured inputs
4. Implements fix and validates build
```

**Why This Stack Works:**
- Configuration repos need precision over speed
- Limited test automation means manual review is critical
- Changes can break entire system, requiring careful validation
- Documentation prevents future confusion about "why" decisions were made

---

### 2. Rails Applications

**Characteristics:**
- Full-stack web framework
- Convention over configuration
- Database-heavy operations
- Rich test ecosystem
- Multiple architectural layers (MVC + jobs, channels, etc.)

**Recommended Agent Stack:**

#### Greenfield Project (New Rails App)
```
team-configurator → Detects Rails + React/Hotwire
  ↓
project-analyst → Maps Rails version, gems, frontend choice
  ↓
tech-lead-orchestrator → Plans initial architecture
  ↓
Specialized agents execute in parallel:
  - rails-backend-expert → Models, controllers, business logic
  - rails-api-developer → API endpoints if needed
  - rails-activerecord-expert → Database schema, migrations
  - react-component-architect → Frontend if using React
```

#### Joining Existing Rails Team
```
code-archaeologist → Explores codebase structure
  ↓
project-analyst → Documents patterns, conventions, dependencies
  ↓
documentation-specialist → Creates onboarding guide
  ↓
Work begins with specialized agents based on tasks
```

#### Solo Developer Adding Features
```
product-owner-analyst → Clarifies vague feature requests
  ↓
tech-lead-orchestrator → Breaks down into tasks
  ↓
Specialized agents execute:
  - rails-backend-expert → Business logic
  - rails-api-developer → API layer
  - coverage-test-writer → Test coverage
  - code-reviewer → Quality assurance
```

**Example Use Cases:**

**Feature: User Authentication System**
```bash
# Command: /issue-product-owner
User: "We need user authentication"

Flow:
1. product-owner-analyst asks clarifying questions:
   - OAuth/email-password/both?
   - Password reset flow?
   - Session management strategy?
   - Multi-factor authentication?
   - Role-based access control?

2. User provides answers

3. product-owner-analyst creates user stories

4. tech-lead-orchestrator assigns:
   - TASK: Devise gem setup → AGENT: rails-backend-expert
   - TASK: User model & migration → AGENT: rails-activerecord-expert
   - TASK: Authentication controllers → AGENT: rails-backend-expert
   - TASK: API token auth → AGENT: rails-api-developer
   - TASK: Login UI components → AGENT: react-component-architect

5. Each specialist executes their task

6. coverage-test-writer adds comprehensive tests

7. code-reviewer validates entire implementation
```

**Performance Optimization Task:**
```bash
# Command: /coverage (for performance analysis)
User: "Dashboard is loading slowly"

Flow:
1. performance-optimizer profiles the application
2. Identifies N+1 queries, missing indexes
3. Delegates to rails-activerecord-expert:
   - Add eager loading
   - Create database indexes
   - Implement query optimization
4. coverage-analyzer validates performance improvements
5. code-reviewer ensures no regressions
```

**API Development:**
```bash
# Direct task to specialist
User: "Build REST API for products with CRUD operations"

Flow:
1. rails-api-developer creates:
   - API::V1::ProductsController
   - Serializers for JSON responses
   - API versioning structure
   - Rate limiting
   - Authentication via tokens

2. rails-activerecord-expert optimizes:
   - Product model queries
   - Database indexes for common API queries

3. coverage-test-writer adds:
   - Request specs for all endpoints
   - Edge case testing
   - Authentication testing

4. documentation-specialist creates:
   - API documentation with examples
   - Authentication guide
```

**Why This Stack Works:**
- Rails conventions mean specialists can make framework-specific optimizations
- Complex business logic benefits from orchestrated task breakdown
- Strong testing culture in Rails pairs well with coverage agents
- API development is common, requiring dedicated specialist

---

### 3. React Applications

**Characteristics:**
- Component-based architecture
- State management complexity
- Build tooling (Webpack/Vite)
- Testing (Jest, React Testing Library)
- May include SSR/SSG (Next.js)

**Recommended Agent Stack:**

#### Standalone React SPA
```
Primary:
  - react-component-architect → UI components, hooks, context
  - react-state-manager → Redux/Zustand/MobX setup
  - tailwind-frontend-expert → Styling and responsive design

Support:
  - api-architect → API client layer design
  - playwright-test-writer → E2E testing
  - coverage-test-writer → Unit/integration tests
```

#### Next.js Full-Stack App
```
Primary:
  - react-nextjs-expert → SSR/SSG/ISR patterns, routing
  - react-component-architect → Component design
  - react-state-manager → Global state
  - api-architect → API routes design

Support:
  - performance-optimizer → Bundle size, loading speed
  - playwright-analyzer → E2E test debugging
```

**Example Use Cases:**

**Feature: Shopping Cart with State Management**
```bash
User: "Implement shopping cart that persists across sessions"

Flow:
1. tech-lead-orchestrator breaks down:
   - TASK: State management setup → AGENT: react-state-manager
   - TASK: Cart UI components → AGENT: react-component-architect
   - TASK: Local storage persistence → AGENT: react-component-architect
   - TASK: API integration → AGENT: api-architect
   - TASK: Responsive design → AGENT: tailwind-frontend-expert

2. react-state-manager creates:
   - Zustand store for cart state
   - Actions: add, remove, update quantity
   - Selectors for computed values (total, count)
   - Persistence middleware

3. react-component-architect builds:
   - CartItem component
   - CartSummary component
   - AddToCartButton component
   - Custom hooks (useCart, useCartItem)

4. tailwind-frontend-expert styles:
   - Mobile-first responsive design
   - Loading states
   - Empty cart state
   - Animations for add/remove

5. playwright-test-writer creates E2E tests:
   - Add items to cart flow
   - Update quantity
   - Remove items
   - Persistence across refresh
```

**Next.js Blog with SSG:**
```bash
User: "Build a blog with markdown posts and static generation"

Flow:
1. react-nextjs-expert implements:
   - getStaticPaths for blog routes
   - getStaticProps for post data
   - Incremental static regeneration
   - Dynamic routing structure

2. react-component-architect creates:
   - BlogPost layout component
   - PostCard preview component
   - TableOfContents component
   - CodeBlock syntax highlighting

3. performance-optimizer ensures:
   - Image optimization
   - Font loading strategy
   - Bundle splitting
   - Lazy loading for comments

4. documentation-specialist documents:
   - How to add new blog posts
   - Frontmatter schema
   - Build and deployment process
```

**Performance Issue Resolution:**
```bash
User: "App is slow and bundle size is huge"

Flow:
1. performance-optimizer analyzes:
   - Bundle size breakdown
   - Component re-render patterns
   - Network waterfall

2. Delegates tasks:
   - To react-component-architect:
     * Implement React.memo where needed
     * Optimize useEffect dependencies
     * Code splitting at route level
   
   - To react-state-manager:
     * Optimize selector computations
     * Implement state normalization
     * Reduce unnecessary updates

3. playwright-analyzer:
   - Validates no functional regressions
   - Tests loading performance

4. Results: Bundle reduced 40%, initial load 2x faster
```

**Why This Stack Works:**
- React patterns require deep framework knowledge
- State management is complex enough to warrant dedicated specialist
- Performance is critical for user experience
- E2E testing catches integration issues that unit tests miss

---

### 4. One-Off Scripts & Utilities

**Characteristics:**
- Single-purpose tools
- Minimal dependencies
- Quick iteration needed
- Often no test suite
- May grow into larger projects

**Recommended Agent Stack:**

```
Primary: engineer (universal capabilities)
Optional: code-reviewer (for production scripts)
```

**Example Use Cases:**

**Data Migration Script:**
```bash
User: "Write Python script to migrate SQLite to PostgreSQL"

Flow:
1. engineer implements:
   - Connection handling for both databases
   - Schema mapping logic
   - Batch processing for large tables
   - Error handling and logging
   - Progress reporting

2. code-reviewer validates (if critical):
   - Data integrity checks
   - Edge case handling
   - Rollback strategy
```

**Why Minimal Stack Works:**
- Overhead of orchestration exceeds benefit
- Scripts are often exploratory/throwaway
- Single engineer agent has sufficient breadth
- Can escalate to specialists if script grows

**When to Escalate:**
If script grows in complexity:
```
Script becomes CLI tool
  ↓
code-architect reviews design
  ↓
documentation-specialist adds usage guide
  ↓
coverage-test-writer adds tests if it's critical
```

---

### 5. Microservices Architecture

**Characteristics:**
- Multiple services in different languages
- API contracts between services
- Deployment complexity
- Distributed system challenges
- Polyglot development

**Recommended Agent Stack:**

```
Per-Service:
  - Project-specific specialists (rails-*, react-*, etc.)
  - api-architect → Ensures consistent API design

Cross-Cutting:
  - tech-lead-orchestrator → Coordinates multi-service changes
  - documentation-specialist → Maintains architecture docs
  - code-archaeologist → Maps service dependencies

Quality:
  - performance-optimizer → Latency and throughput
  - code-reviewer → Consistency across services
```

**Example Use Cases:**

**Feature Spanning Multiple Services:**
```bash
User: "Add user notifications across services"

Flow:
1. tech-lead-orchestrator analyzes:
   - User service: Store notification preferences
   - Notification service: Send notifications
   - Email service: Email delivery
   - API gateway: Route notification requests

2. Assigns tasks:
   - TASK: User preferences API → AGENT: rails-api-developer
   - TASK: Notification queue → AGENT: backend-developer
   - TASK: Email templates → AGENT: frontend-developer
   - TASK: Gateway routing → AGENT: api-architect

3. api-architect ensures:
   - Consistent API contracts
   - Error handling across services
   - Versioning strategy

4. documentation-specialist creates:
   - Service interaction diagram
   - API documentation
   - Deployment sequence
```

**Service Dependency Analysis:**
```bash
User: "Which services will break if we change User API?"

Flow:
1. code-archaeologist scans all services:
   - API client code
   - Environment configurations
   - Contract tests

2. Generates dependency graph

3. documentation-specialist updates architecture docs

4. Reports: "Services affected: Notification, Order, Analytics"
```

---

## Agent Combinations by Scenario

### Starting a New Solo Project

**Day 1: Project Setup**
```
1. team-configurator → Sets up agent mappings
2. code-architect → Plans initial architecture
3. documentation-specialist → Creates README and docs structure
4. Specialized agents → Implement scaffolding
```

**Week 1-4: Core Development**
```
Primary workflow:
  - tech-lead-orchestrator → Weekly planning
  - Specialized agents → Feature implementation
  - coverage-test-writer → Test coverage
  - code-reviewer → Quality gates
```

**Month 2+: Maintenance & Growth**
```
As needed:
  - performance-optimizer → Periodic optimization
  - code-archaeologist → Document implicit knowledge
  - documentation-specialist → Keep docs current
```

---

### Joining an Existing Team

**Phase 1: Onboarding (Week 1)**
```
1. code-archaeologist → Explores codebase thoroughly
   - Technology stack detection
   - Pattern identification
   - Dependency mapping
   - Convention documentation

2. project-analyst → Analyzes architecture
   - Framework versions
   - Architectural patterns
   - State management approach

3. documentation-specialist → Creates onboarding guide
   - Project overview
   - Development setup
   - Common workflows
   - Team conventions
```

**Phase 2: First Contributions (Week 2-3)**
```
1. Start with bug fixes using:
   - engineer → Implements fixes
   - code-reviewer → Ensures team standards

2. Small features using:
   - tech-lead-orchestrator → Understands task breakdown
   - Specialized agents → Follows existing patterns
```

**Phase 3: Full Speed (Month 2+)**
```
Same workflow as team uses:
  - Match team's agent usage patterns
  - Contribute to documentation
  - Help onboard next team member
```

---

### Inherited Legacy Codebase

**Initial Assessment**
```
1. code-archaeologist → Deep dive exploration
   - Map all components and dependencies
   - Identify technical debt
   - Document undocumented patterns
   - Find obsolete code

2. code-architect → Architectural review
   - Identify architectural issues
   - Propose refactoring strategy
   - Plan modernization roadmap

3. documentation-specialist → Knowledge capture
   - Document current architecture
   - Create migration plan docs
   - Technical debt register
```

**Incremental Modernization**
```
For each area to improve:

1. code-architect → Designs modern approach

2. tech-lead-orchestrator → Creates migration plan
   - TASK: Extract module → AGENT: specialized-agent
   - TASK: Write tests → AGENT: coverage-test-writer
   - TASK: Refactor → AGENT: specialized-agent
   - TASK: Validate → AGENT: code-reviewer

3. performance-optimizer → Measures improvements

4. documentation-specialist → Updates architecture docs
```

---

### Emergency Bug Fixes

**Critical Production Issue**
```
Minimal agents for speed:

1. engineer → Diagnoses and fixes
   - Read error logs
   - Identify root cause
   - Implement fix
   - Verify locally

2. code-reviewer → Quick validation (optional)
   - Ensure fix doesn't introduce new issues
   - Check for similar bugs elsewhere

3. documentation-specialist → Post-mortem
   - Document the bug
   - Update BUG_REFERENCE.md
   - Add to runbook
```

**Non-Critical Bug Fix**
```
Full workflow:

1. coverage-test-writer → Writes failing test first

2. engineer → Implements fix

3. code-reviewer → Reviews thoroughly

4. documentation-specialist → Updates bug reference

5. Commit with full quality checks
```

---

### Adding Major Feature

**Product Ideation Phase**
```
1. product-owner-analyst → Requirements gathering
   - Ask clarifying questions
   - Create user stories
   - Define acceptance criteria
   - Identify edge cases

2. code-architect → Technical design
   - Evaluate approaches
   - Consider trade-offs
   - Plan architecture
   - Identify risks
```

**Implementation Phase**
```
1. tech-lead-orchestrator → Task breakdown
   - Assign to specialized agents
   - Identify dependencies
   - Plan execution order

2. Specialized agents → Execute tasks
   - Follow architectural plan
   - Implement incrementally
   - Create tests alongside

3. coverage-test-writer → Comprehensive testing
   - Unit tests
   - Integration tests
   - E2E scenarios

4. code-reviewer → Quality validation
   - Code quality
   - Requirements compliance
   - Best practices
```

**Launch Phase**
```
1. performance-optimizer → Pre-launch optimization

2. playwright-analyzer → E2E validation

3. documentation-specialist → User and dev docs

4. Final review by code-reviewer
```

---

## Workflow Patterns

### GitHub Issue-Driven Development

Uses the `/issue-engineer` command workflow:

**Multi-Phase Implementation:**
```
Issue with phases defined in comments

For each phase:
  1. code-architect fetches issue comment(s)
     - Performs "ultrathinking" analysis
     - Creates implementation plan
     - Identifies risks and alternatives

  2. engineer implements
     - Reviews architectural guidance
     - Plans implementation strategy
     - Writes code and tests

  3. coverage-analyzer validates
     - Runs all quality checks (format, lint, test)
     - If failures → back to engineer
     - Flags regressions as high priority

  4. code-reviewer examines
     - Checks against requirements
     - Validates code quality
     - If concerns → back to engineer

  5. Final validation
     - All checks pass
     - Both agents report to GitHub issue

Safety: Max 20 iterations before manual intervention
```

**Example Issue Workflow:**
```yaml
Issue #42: "Implement user search with filters"

Comment #18 (Phase 1):
  - Basic search endpoint
  - Search by username/email
  - Pagination

Comment #50 (Phase 2):
  - Advanced filters (role, created_date)
  - Sort options
  - Search performance optimization

Execution:
$ custom-command/issue-engineer 18 1    # Phase 1
$ custom-command/issue-engineer 50 2    # Phase 2
```

---

### Test-Driven Development

**Red-Green-Refactor Cycle:**
```
1. coverage-test-writer → Writes failing test
   - Clear test cases for requirements
   - Edge cases identified
   - Test data prepared

2. engineer → Makes test pass
   - Minimal implementation first
   - Ensure test passes

3. code-architect → Refactors if needed
   - Improve design
   - Maintain test pass

4. code-reviewer → Validates quality
```

**Example:**
```bash
User: "Add email validation to User model"

Flow:
1. coverage-test-writer creates tests:
   - Valid email formats pass
   - Invalid formats fail
   - Null/empty email handling
   - Duplicate email handling

2. engineer implements:
   - Email regex validation
   - Uniqueness constraint
   - Error messages

3. Tests pass → Feature complete
```

---

### Continuous Refactoring

**Scheduled Refactoring Sessions:**
```
Monthly/Quarterly:

1. code-archaeologist → Identifies technical debt
   - Duplicate code
   - Complex methods
   - Outdated patterns
   - Unused code

2. code-architect → Prioritizes and plans
   - Impact vs effort analysis
   - Refactoring strategy
   - Risk mitigation

3. Specialized agents → Execute refactoring
   - Incremental changes
   - Tests remain green
   - No feature changes

4. performance-optimizer → Measures improvements
   - Code complexity metrics
   - Performance benchmarks
   - Maintainability scores

5. documentation-specialist → Updates docs
   - Architecture changes
   - Pattern updates
```

---

### Documentation-First Development

**For Public Libraries/APIs:**
```
1. documentation-specialist → Writes API docs first
   - Expected interfaces
   - Usage examples
   - Return types

2. coverage-test-writer → Creates tests from docs
   - Example code becomes tests
   - Ensures docs stay accurate

3. Specialized agents → Implement to match docs

4. code-reviewer → Validates docs match implementation
```

**Example:**
```bash
User: "Create a new public API client library"

Flow:
1. documentation-specialist writes:
   - README with quick start
   - API reference documentation
   - Code examples for each method

2. coverage-test-writer converts examples to tests

3. api-architect implements:
   - Client class matching documented interface
   - Error handling as documented
   - Return types matching examples

4. All tests pass → Documentation verified
```

---

## Best Practices

### 1. Right-Sizing Your Agent Team

**Too Many Agents (Over-Engineering)**
Signs:
- Simple script gets full orchestration
- More time planning than coding
- Agent coordination overhead > benefit

Solution: Use engineer for simple tasks

**Too Few Agents (Under-Engineering)**
Signs:
- Quality issues slip through
- Inconsistent patterns across features
- Technical debt accumulating
- Missing documentation

Solution: Add code-reviewer and documentation-specialist

**Just Right:**
- Small tasks: engineer + code-reviewer
- Medium features: tech-lead-orchestrator + specialists + reviewer
- Large projects: Full stack with orchestration

---

### 2. Agent Handoff Clarity

**Effective Handoff Pattern:**
```
Orchestrator delegates:
  "TASK: Build user authentication → AGENT: rails-backend-expert
   CONTEXT: Rails 7.1 app, using Devise gem
   REQUIREMENTS: Email auth, password reset, session management
   CONSTRAINTS: Must integrate with existing User model
   SUCCESS: All tests pass, documented in API_REFERENCE.md"
```

**Ineffective Handoff:**
```
"Make auth work → some agent"  # Too vague
```

---

### 3. Documentation Cadence

**Always Document:**
- Architectural decisions (in DATA_FLOW.md)
- API changes (in API_REFERENCE.md)
- Bug fixes (in BUG_REFERENCE.md)
- Feature completions (in ROADMAP.md)

**Document Periodically:**
- Performance optimizations
- Refactoring outcomes
- Security updates

**Never Document:**
- Trivial bug fixes (typos, minor formatting)
- Experimental code that was reverted
- Temporary debugging changes

---

### 4. Quality Gates by Project Type

**Configuration Repos (Nix, Ansible, etc.):**
```
Required:
  - Syntax validation
  - Build/evaluation passes
  - Manual code review

Optional:
  - Integration tests
```

**Web Applications:**
```
Required:
  - Unit tests pass
  - Linting passes
  - Code review
  - Integration tests pass

Recommended:
  - E2E tests for critical flows
  - Performance benchmarks
  - Security scanning
```

**Libraries/SDKs:**
```
Required:
  - All tests pass
  - Documentation complete
  - Examples work
  - API compatibility check
  - Code review

Recommended:
  - Performance regression tests
  - Multiple version testing
```

---

### 5. Scaling Agent Usage

**Solo Developer:**
- Day-to-day: engineer + code-reviewer
- Weekly: documentation-specialist updates
- Monthly: code-archaeologist reviews technical debt

**Small Team (2-5 developers):**
- Per feature: tech-lead-orchestrator + specialists
- Shared: code-reviewer for all PRs
- Continuous: documentation-specialist maintains docs

**Large Team (5+ developers):**
- Per squad: Full agent stack
- Cross-cutting: api-architect ensures consistency
- Platform: code-archaeologist maintains system knowledge

---

### 6. Learning New Codebase

**First Hour:**
```
1. Read README and docs/
2. Run code-archaeologist for structure overview
3. Skim project-analyst output for tech stack
```

**First Day:**
```
1. code-archaeologist deep dive
2. Find main entry points
3. Understand data models
4. Identify common patterns
```

**First Week:**
```
1. Small bug fixes with engineer
2. Read code reviews by code-reviewer
3. Understand testing strategy
4. Make first feature contribution
```

**First Month:**
```
1. Contribute to documentation
2. Refactor small areas
3. Help onboard next person
```

---

### 7. Context Preservation

**Between Sessions:**
```
1. documentation-specialist captures:
   - What was implemented
   - Why decisions were made
   - What's left to do

2. Memory tools store:
   - Project-specific patterns
   - Team conventions
   - Known issues

3. Version control records:
   - Code changes
   - Review comments
```

**Returning After Break:**
```
1. Read recent documentation updates
2. Review git history
3. Check BUG_REFERENCE for known issues
4. Resume with context restored
```

---

### 8. Multi-Repository Workflows

**Monorepo:**
```
One agent team per logical domain:
  - Frontend team: React specialists
  - Backend team: Rails/Go specialists
  - Shared: API architect ensures consistency
```

**Polyrepo:**
```
Per repository:
  - Independent agent teams
  - Separate documentation
  
Cross-repo:
  - api-architect ensures API compatibility
  - documentation-specialist maintains integration docs
```

---

### 9. Emergency Response

**Production Down:**
```
Speed is critical:

1. engineer diagnoses and fixes
2. Skip code review (fix first)
3. Post-incident:
   - documentation-specialist writes post-mortem
   - coverage-test-writer adds regression tests
   - code-reviewer examines fix for long-term correctness
```

**Security Vulnerability:**
```
Speed + thoroughness:

1. engineer patches immediately
2. code-reviewer validates patch
3. coverage-test-writer adds security tests
4. documentation-specialist updates security docs
```

---

### 10. Knowledge Transfer

**Developer Leaving:**
```
1. code-archaeologist documents their code areas
2. documentation-specialist captures tribal knowledge
3. Create handoff document
4. Pair with replacement using agents
```

**New Developer Joining:**
```
1. Share generated onboarding docs
2. Assign small tasks with agent assistance
3. Review agent interactions to learn patterns
4. Gradually increase complexity
```

---

## Conclusion

The key to effective agent usage is **matching the agent team to the problem scale**:

- **Simple tasks**: Single engineer agent
- **Features**: Orchestrator + specialists + reviewer
- **Projects**: Full stack with continuous quality agents
- **Emergency**: Minimal agents for speed, full review post-incident

Remember: Agents are tools to amplify your effectiveness, not replacements for 
understanding your codebase. Use them to handle grunt work, enforce quality, and 
preserve knowledge while you focus on creative problem-solving and architecture.
