# Architecture Philosophy

## Core Principle: Structure Around Semantic Boundaries

The fundamental architectural principle guiding this codebase:

**Structure code around what things *are* (their semantic meaning), not how they are *used* (consumption patterns).**

## The Pattern

When organizing code, prefer:
- **Domain-driven structure** over tool-driven structure
- **Axis of change** over axis of consumption
- **Semantic cohesion** over technical decomposition

## Example: Language Modules

### Anti-Pattern (organize by consumer)
```
formatter-configs/
  python-ruff.nix
  ruby-rubocop.nix

editor-configs/
  python-lsp.nix
  ruby-lsp.nix

packages/
  python-tools.nix
  ruby-tools.nix
```

Problem: Adding Python support requires touching 3+ files across different directories. Easy to miss pieces. Hard to see "what does Python support include?"

### This Pattern (organize by domain)
```
languages/
  python.nix    # formatter + editor + packages
  ruby.nix      # formatter + editor + packages
```

Benefit: One language = one file. Automatically integrated everywhere. Can't have half-configured support.

## Why This Matters

1. **Locality of behavior** - Everything related to a concept lives in one place
2. **Minimize blast radius** - Changes are contained to natural boundaries
3. **Make invalid states unrepresentable** - Atomic units prevent partial configuration
4. **Organize by axis of change** - Things that change together live together
5. **Self-documenting** - The structure itself communicates intent

## Generalization

This principle applies beyond language modules:

- Group by **feature** not by **layer** (avoid separate dirs for models/views/controllers)
- Group by **user journey** not by **technology** (avoid separate repos for frontend/backend)
- Group by **business domain** not by **infrastructure concern**

Let the conceptual model drive structure. Let technical systems adapt to that reality, not vice versa.

---

*This is Conway's Law inverted: structure your code to mirror the natural boundaries of your domain, and let the technical plumbing adapt.*
