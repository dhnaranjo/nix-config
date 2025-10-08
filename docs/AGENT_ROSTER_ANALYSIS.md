# Agent Roster Analysis: Gaps and Overlaps
**Last Updated:** 2025-10-08  
**Version:** 1.0

## Executive Summary

Analysis of 24 agents across 4 categories (Orchestrators, Core, Specialized, Universal) 
reveals a generally well-designed roster with some notable gaps and a few areas of 
potential confusion due to overlapping responsibilities.

**Key Findings:**
- ✅ Strong coverage for web application development (Rails, React)
- ⚠️ Overlapping responsibilities between architect roles
- ❌ Missing critical specialists for common development scenarios
- ⚠️ Ambiguous delegation paths in some workflows

---

## Current Agent Inventory

### Orchestrators (3 agents)
1. **tech-lead-orchestrator** - Task breakdown and agent assignment
2. **team-configurator** - Agent team setup based on project detection
3. **project-analyst** - Technology stack detection and analysis

### Core (4 agents)
4. **code-archaeologist** - Codebase exploration and understanding
5. **code-reviewer** - Quality assurance and code review
6. **documentation-specialist** - Technical documentation creation
7. **performance-optimizer** - Performance analysis and optimization

### Top-Level Specialists (7 agents)
8. **code-architect** - Architectural design and strategic guidance
9. **coverage-analyzer** - Test execution and quality validation
10. **coverage-test-writer** - Test creation for coverage improvement
11. **engineer** - General-purpose senior engineer
12. **playwright-analyzer** - E2E test analysis and debugging
13. **playwright-test-writer** - E2E test creation
14. **product-owner-analyst** - Requirements gathering and user stories

### Specialized Agents (10 agents)

**Rails (3)**
15. **rails-activerecord-expert** - Database and ActiveRecord
16. **rails-api-developer** - Rails API endpoints
17. **rails-backend-expert** - Rails business logic and features

**React (3)**
18. **react-component-architect** - React components and hooks
19. **react-nextjs-expert** - Next.js SSR/SSG/ISR
20. **react-state-manager** - State management solutions

**Universal (4)**
21. **api-architect** - Technology-agnostic API design
22. **backend-developer** - Universal backend development
23. **frontend-developer** - Universal frontend development
24. **tailwind-frontend-expert** - Tailwind CSS and styling

---

## Identified Gaps

### 1. Database Specialists (Critical Gap)

**Missing Agents:**
- **database-architect** - Database schema design, normalization, relationships
- **database-optimizer** - Query optimization, indexing strategies
- **migration-specialist** - Schema migrations, data migrations

**Impact:**
- Multiple agents reference "database-architect" in their delegation rules but it 
  doesn't exist
- Code-archaeologist delegates to "database-architect"
- API-architect delegates to "database-architect"
- Backend-developer delegates to "database-architect"
- Rails-activerecord-expert partially fills this role but only for Rails

**Current Workaround:**
- Rails projects use rails-activerecord-expert
- Other stacks fall back to backend-developer (not ideal)

**Recommendation:**
Create `database-architect` agent with expertise in:
- Schema design across all database types (PostgreSQL, MySQL, MongoDB, etc.)
- Query optimization and explain plan analysis
- Index strategies and performance tuning
- Data modeling and normalization
- Migration planning and execution
- Replication and sharding strategies

### 2. Security Specialist (Critical Gap)

**Missing Agent:**
- **security-guardian** or **security-auditor**

**Impact:**
- Code-reviewer, code-archaeologist, and api-architect all delegate to 
  "security-guardian" but it doesn't exist
- Security concerns mentioned in 8+ agent delegation rules
- No dedicated agent for security audits, vulnerability scanning, or threat modeling

**Current Workaround:**
- Code-reviewer handles basic security in code reviews
- No specialized security analysis available

**Recommendation:**
Create `security-guardian` agent with expertise in:
- OWASP Top 10 vulnerabilities
- Authentication and authorization patterns
- Cryptography best practices
- Security headers and CORS configuration
- Dependency vulnerability scanning
- Penetration testing guidance
- Compliance (GDPR, HIPAA, SOC2)

### 3. DevOps/Infrastructure (High Priority Gap)

**Missing Agents:**
- **devops-engineer** - CI/CD, containerization, deployment
- **infrastructure-architect** - Cloud architecture, scaling

**Impact:**
- Performance-optimizer delegates to "devops-engineer" but it doesn't exist
- No agent for Docker, Kubernetes, AWS/GCP/Azure configuration
- No CI/CD pipeline expertise
- No deployment strategy guidance

**Current Workaround:**
- Engineer agent handles basic DevOps (not specialized)
- Team must handle infrastructure manually

**Recommendation:**
Create `devops-engineer` agent with expertise in:
- Docker and container orchestration
- Kubernetes deployment and management
- CI/CD pipeline configuration (GitHub Actions, GitLab CI, Jenkins)
- Cloud provider services (AWS, GCP, Azure)
- Infrastructure as Code (Terraform, Pulumi, CloudFormation)
- Monitoring and observability (Prometheus, Grafana, DataDog)
- Secret management and security

### 4. Refactoring Specialist (Medium Priority Gap)

**Missing Agent:**
- **refactoring-expert** or **legacy-modernizer**

**Impact:**
- Code-reviewer delegates to "refactoring-expert" but it doesn't exist
- Performance-optimizer delegates to "refactoring-expert" but it doesn't exist
- No dedicated agent for systematic refactoring

**Current Workaround:**
- Code-architect provides refactoring guidance
- Engineer implements refactorings
- Lacks systematic approach to large-scale refactoring

**Recommendation:**
Create `refactoring-expert` agent with expertise in:
- Systematic refactoring techniques
- Legacy code modernization strategies
- Strangler fig pattern implementation
- Breaking down monoliths
- Technical debt reduction
- Safe refactoring with test coverage

### 5. Accessibility Specialist (Medium Priority Gap)

**Missing Agent:**
- **accessibility-expert** or **a11y-specialist**

**Impact:**
- Frontend-developer delegates to "accessibility-expert" but it doesn't exist
- No WCAG compliance validation
- No screen reader testing guidance
- No accessibility audit capabilities

**Current Workaround:**
- Frontend-developer has basic accessibility knowledge
- Code-reviewer may catch obvious issues
- No comprehensive accessibility testing

**Recommendation:**
Create `accessibility-expert` agent with expertise in:
- WCAG 2.1/2.2 guidelines (A, AA, AAA)
- ARIA roles and attributes
- Keyboard navigation patterns
- Screen reader compatibility
- Color contrast and visual accessibility
- Accessibility testing tools
- Accessibility documentation

### 6. Additional Framework Specialists (Low Priority Gaps)

**Missing Popular Frameworks:**
- **python-fastapi-expert** - FastAPI/Python APIs
- **django-backend-expert** - Django web framework
- **golang-backend-expert** - Go microservices
- **vue-component-architect** - Vue.js applications
- **angular-component-architect** - Angular applications
- **flutter-developer** - Mobile app development
- **swift-ios-developer** - iOS native apps
- **kotlin-android-developer** - Android native apps

**Impact:**
- Teams using these frameworks fall back to universal agents
- Lose framework-specific optimizations and best practices
- Longer development time without specialized knowledge

**Current Workaround:**
- Use universal backend-developer, frontend-developer, api-architect
- Works but not optimal

**Recommendation:**
- Add based on team needs
- Python/Django is common enough to warrant dedicated agents
- Go microservices becoming increasingly popular
- Mobile development (Flutter, Swift, Kotlin) only if needed

### 7. Data Science/ML Specialists (Context-Dependent Gap)

**Missing Agents (if team does ML/Data work):**
- **data-scientist** - Analysis, modeling, visualization
- **ml-engineer** - Model training, deployment, MLOps
- **data-engineer** - ETL, data pipelines, warehousing

**Impact:**
- No support for data science workflows
- No ML model development or deployment guidance

**Recommendation:**
- Only add if project involves data science/ML work
- Not needed for typical web application development

---

## Overlapping Responsibilities

### 1. Architecture Roles (Ambiguity Issue)

**Overlapping Agents:**
- **code-architect** - Strategic architectural guidance, design patterns, SOLID
- **api-architect** - API design, RESTful/GraphQL patterns
- Project-specific architects (rails-*, react-*)

**Overlap:**
- API design could be handled by code-architect OR api-architect
- Architectural decisions could involve multiple architects
- Unclear which architect to use for API-heavy projects

**Confusion Points:**
```
User: "Design the authentication system for my app"
  Could use: code-architect (strategic guidance)
  Could use: api-architect (API endpoints)
  Could use: rails-backend-expert (Rails implementation)
  Could use: backend-developer (generic implementation)
```

**Resolution:**
Clear hierarchy needed:
1. **code-architect** - High-level architecture, patterns, system design
2. **api-architect** - API surface design (contracts, versioning, documentation)
3. **Framework specialists** - Implementation within specific framework
4. **backend-developer** - Implementation when no framework specialist exists

**Recommendation:**
Update agent descriptions with clear boundaries:
- code-architect: "When to use me: System architecture, design patterns, 
  architectural trade-offs. Delegate to api-architect for API-specific design."
- api-architect: "When to use me: API contract design, endpoint structure, 
  versioning. Delegate to framework specialists for implementation."

### 2. Developer Roles (Capability Overlap)

**Overlapping Agents:**
- **engineer** - General senior engineer with broad capabilities
- **backend-developer** - Universal backend specialist
- **frontend-developer** - Universal frontend specialist
- Framework specialists (rails-*, react-*, etc.)

**Overlap:**
- Engineer can do what backend-developer does
- Engineer can do what frontend-developer does
- All can implement features, but at different specificity levels

**Confusion Points:**
```
User: "Build a user registration feature"
  Could use: engineer (full-stack approach)
  Could use: backend-developer + frontend-developer (split approach)
  Could use: rails-backend-expert + react-component-architect (specialized)
```

**Current Implicit Hierarchy:**
1. Framework specialists (most specific)
2. Universal specialists (language/domain specific)
3. Engineer (generalist fallback)

**Resolution:**
This overlap is actually healthy - provides flexibility for different project scales:
- Small projects: Use engineer alone
- Medium projects: Use universal specialists
- Large projects: Use framework specialists

**Recommendation:**
Document this hierarchy explicitly in team-configurator and tech-lead-orchestrator:
```markdown
Agent Selection Priority:
1. Framework specialist (if exists and detected)
2. Universal specialist (if task is clearly backend/frontend/API)
3. Engineer (for small tasks, unclear stack, or rapid prototyping)
```

### 3. Testing Roles (Scope Overlap)

**Overlapping Agents:**
- **coverage-analyzer** - Runs tests, analyzes failures
- **coverage-test-writer** - Writes tests for coverage
- **playwright-analyzer** - Analyzes E2E test failures
- **playwright-test-writer** - Writes E2E tests
- **code-reviewer** - Reviews test quality

**Overlap:**
- Both coverage-analyzer and playwright-analyzer run and analyze tests
- Test writing split between coverage-test-writer and playwright-test-writer
- Code-reviewer also evaluates test quality

**Confusion Points:**
```
User: "My tests are failing"
  Could use: coverage-analyzer (unit/integration tests)
  Could use: playwright-analyzer (E2E tests)
  Could use: engineer (fix the tests)
```

**Resolution:**
Clear test type boundaries:
- **coverage-analyzer** - Unit tests, integration tests (fast tests)
- **playwright-analyzer** - E2E tests, browser tests (slow tests)
- **coverage-test-writer** - Write new unit/integration tests
- **playwright-test-writer** - Write new E2E tests
- **code-reviewer** - Review all test code for quality

**Recommendation:**
This separation is appropriate. Document clearly:
- Use coverage-* for fast tests (milliseconds to seconds)
- Use playwright-* for slow tests (seconds to minutes)
- Use code-reviewer for test quality assurance

### 4. Documentation Overlap

**Overlapping Agents:**
- **documentation-specialist** - Creates all documentation
- **code-archaeologist** - Documents code exploration findings
- **project-analyst** - Documents technology stack analysis

**Overlap:**
- All three agents produce documentation
- Code-archaeologist and project-analyst document their findings
- Documentation-specialist creates comprehensive docs

**Resolution:**
Actually complementary, not conflicting:
- code-archaeologist: Produces analysis reports
- project-analyst: Produces technology analysis
- documentation-specialist: Turns analyses into polished docs

**Recommendation:**
Define clear handoff pattern:
```
code-archaeologist/project-analyst → documentation-specialist
  "Analysis complete. Create formal documentation from these findings."
```

---

## Delegation Chain Issues

### 1. Broken References

**Agents That Don't Exist But Are Referenced:**
```
Missing: database-architect
  Referenced by: code-archaeologist, api-architect, backend-developer

Missing: security-guardian
  Referenced by: code-archaeologist, code-reviewer, api-architect

Missing: devops-engineer
  Referenced by: performance-optimizer

Missing: refactoring-expert
  Referenced by: code-reviewer, performance-optimizer

Missing: legacy-modernizer
  Referenced by: code-archaeologist

Missing: accessibility-expert
  Referenced by: frontend-developer
```

**Impact:**
- Delegation chains break
- Agents don't know where to hand off
- Main agent must manually route

**Recommendation:**
1. Create missing agents (as documented in Gaps section)
2. OR update existing agents to remove invalid delegations
3. OR update delegations to use existing fallback agents

### 2. Circular Delegation Potential

**Potential Circles:**
```
code-architect → performance-optimizer → refactoring-expert → code-architect
  (All involved in refactoring decisions)

engineer → code-reviewer → engineer
  (Engineer implements, reviewer finds issues, back to engineer)
```

**Resolution:**
- Second circle is intentional (implementation loop)
- First circle is theoretical (refactoring-expert doesn't exist yet)

**Recommendation:**
- Document intentional loops (like issue-engineer workflow)
- Ensure new agents don't create unintentional circles

### 3. Missing Direct Paths

**Scenarios Without Clear Agent:**
```
"Set up CI/CD pipeline"
  → No devops-engineer
  → Falls to engineer (suboptimal)

"Audit security vulnerabilities"
  → No security-guardian
  → Falls to code-reviewer (limited security scope)

"Optimize database queries"
  → Rails: rails-activerecord-expert ✓
  → Other: backend-developer (limited DB expertise)
```

**Recommendation:**
Add missing specialists to provide direct paths

---

## Ambiguous Routing Scenarios

### Scenario 1: "Build a REST API"

**Multiple Valid Paths:**
```
Path A (Orchestrated):
  tech-lead-orchestrator
    → api-architect (design)
    → rails-api-developer OR backend-developer (implement)
    → coverage-test-writer (tests)
    → code-reviewer (review)

Path B (Direct Framework):
  rails-api-developer (all-in-one)

Path C (Generalist):
  engineer (full implementation)
```

**When to Use Each:**
- Path A: Large project, team environment, quality critical
- Path B: Medium Rails project, speed matters
- Path C: Small project, prototype, solo developer

**Recommendation:**
Document in team-configurator's agent selection logic

### Scenario 2: "Performance is slow"

**Multiple Valid Paths:**
```
Path A (Specialist Chain):
  performance-optimizer (analyze)
    → database-architect (DB optimization) [MISSING]
    → refactoring-expert (code refactoring) [MISSING]
    → devops-engineer (infrastructure) [MISSING]

Path B (Framework Specific):
  rails-activerecord-expert (Rails DB issues)
  react-component-architect (React render issues)

Path C (Generalist):
  engineer (investigate and fix)
```

**Issue:**
- Path A has missing agents
- No clear guidance on which path to choose

**Recommendation:**
1. Create missing specialists
2. Add performance triage logic to tech-lead-orchestrator:
   ```
   IF performance issue:
     1. performance-optimizer identifies bottleneck type
     2. Delegates to specialist based on type:
        - DB queries → database-architect
        - Code complexity → refactoring-expert
        - Infrastructure → devops-engineer
        - Framework-specific → framework specialist
   ```

### Scenario 3: "Review this pull request"

**Multiple Valid Paths:**
```
Path A (Comprehensive):
  code-reviewer (overall quality)
    → security-guardian (security audit) [MISSING]
    → performance-optimizer (performance check)
    → code-architect (architecture review)

Path B (Quick Review):
  code-reviewer (all concerns)

Path C (Framework Review):
  rails-backend-expert (Rails conventions)
  react-component-architect (React patterns)
```

**Recommendation:**
Define review levels:
- **Quick Review**: code-reviewer only
- **Standard Review**: code-reviewer + framework specialist
- **Comprehensive Review**: code-reviewer → specialized audits
- **Pre-Production Review**: All quality agents

---

## Agent Role Clarity Issues

### 1. Engineer vs. Specialized Agents

**Issue:**
The `engineer` agent is described as having "10+ years of experience across multiple 
languages, frameworks, and architectural patterns" - this makes it seem capable of 
doing everything, raising the question: "When should I use a specialist instead?"

**Recommendation:**
Clarify engineer's role:
```markdown
## Engineer Agent - When to Use

Use engineer when:
- Project type is unclear or mixed
- Quick prototyping needed
- Small one-off tasks
- No specialist available for the technology
- Full-stack coordination needed

Use specialists instead when:
- Project uses a specific framework (Rails, React, etc.)
- Deep framework expertise needed
- Large feature development
- Framework-specific optimization required
- Best practices critical
```

### 2. Coverage Agents - Analyzer vs. Writer

**Issue:**
Names suggest:
- coverage-analyzer: Analyzes test coverage
- coverage-test-writer: Writes tests

But actual roles:
- coverage-analyzer: RUNS tests and reports failures
- coverage-test-writer: Writes NEW tests for uncovered code

**Recommendation:**
Rename for clarity:
- coverage-analyzer → **test-runner** or **quality-validator**
- coverage-test-writer → **test-coverage-specialist**

OR update descriptions to be crystal clear about actual responsibilities.

### 3. Product Owner Analyst - Scope Confusion

**Issue:**
- Name suggests product management role
- Actually does requirements gathering and user story creation
- May be confused with project management

**Recommendation:**
Either:
1. Rename to **requirements-analyst** or **user-story-specialist**
2. Or expand role to include product roadmap and prioritization

Current scope seems narrow for "product owner" title.

---

## Recommendations Summary

### Immediate Actions (Critical)

1. **Create Missing Core Agents:**
   - database-architect (referenced by 3+ agents)
   - security-guardian (referenced by 3+ agents)
   - devops-engineer (referenced by 1 agent, critical gap)

2. **Fix Broken Delegation References:**
   - Update all delegation chains to point to existing OR planned agents
   - Document fallback agents when specialist doesn't exist

3. **Clarify Agent Selection Logic:**
   - Document hierarchy in team-configurator
   - Add "When to use" sections to all agent descriptions

### Short-Term Actions (High Priority)

4. **Add Refactoring Specialist:**
   - refactoring-expert (referenced by 2 agents)
   - Critical for technical debt management

5. **Add Accessibility Specialist:**
   - accessibility-expert (referenced by frontend-developer)
   - Important for compliance and UX

6. **Update Agent Descriptions:**
   - Add clear boundaries between overlapping agents
   - Document delegation priorities

### Medium-Term Actions (As Needed)

7. **Framework Expansion:**
   - Add Python (Django/FastAPI) specialists if team uses Python
   - Add Go specialists if team uses Go
   - Add mobile specialists (Flutter/Swift/Kotlin) if team does mobile

8. **Role Naming Review:**
   - Consider renaming coverage-analyzer
   - Consider renaming product-owner-analyst
   - Ensure all names clearly indicate function

### Long-Term Actions (Strategic)

9. **Agent Composition Patterns:**
   - Document common agent combinations for different scenarios
   - Create "agent team templates" for common project types
   - Build decision tree for agent selection

10. **Metrics and Feedback:**
    - Track which agents are used most/least
    - Identify agents that are never invoked
    - Gather user feedback on agent confusion points

---

## Proposed Agent Roster (After Addressing Gaps)

### Orchestrators (3)
- tech-lead-orchestrator
- team-configurator
- project-analyst

### Core (7) [+3 NEW]
- code-archaeologist
- code-reviewer
- documentation-specialist
- performance-optimizer
- **database-architect** ⭐ NEW
- **security-guardian** ⭐ NEW
- **devops-engineer** ⭐ NEW

### Specialists (14) [+2 NEW]
- code-architect
- coverage-analyzer
- coverage-test-writer
- engineer
- playwright-analyzer
- playwright-test-writer
- product-owner-analyst
- **refactoring-expert** ⭐ NEW
- **accessibility-expert** ⭐ NEW
- Rails: rails-activerecord-expert, rails-api-developer, rails-backend-expert
- React: react-component-architect, react-nextjs-expert, react-state-manager

### Universal (4)
- api-architect
- backend-developer
- frontend-developer
- tailwind-frontend-expert

**Total: 28 agents (+5 new)**

### Optional Framework Expansion (Add As Needed)
- Python: django-backend-expert, fastapi-api-developer, django-orm-expert
- Go: golang-backend-expert, golang-api-developer
- Vue: vue-component-architect, vue-state-manager
- Mobile: flutter-developer, swift-ios-developer, kotlin-android-developer
- Data: data-scientist, ml-engineer, data-engineer

---

## Conclusion

The current agent roster provides solid coverage for web application development, 
particularly for Rails and React stacks. However, critical infrastructure agents 
(database, security, DevOps) are missing despite being referenced in multiple 
delegation chains.

The overlap between architect roles and developer roles is generally healthy and 
provides flexibility, but needs clearer documentation to prevent confusion.

**Priority for immediate action:**
1. Create database-architect
2. Create security-guardian
3. Create devops-engineer
4. Document agent selection hierarchy
5. Fix all broken delegation references

These additions would transform the roster from "good for web apps" to 
"comprehensive for modern software development."
