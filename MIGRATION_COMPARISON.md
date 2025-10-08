# Configuration Approaches Comparison

## Current: nixos-unified

**Pros:**
- Minimal flake.nix (5 lines)
- Auto-wires configurations from directory structure
- Built-in activation tools
- Unified `flake` specialArgs

**Cons:**
- External documentation required (nixos-unified.org)
- "Magic" directory-to-output mapping
- Additional dependency outside flake-parts ecosystem
- Less control over configuration structure

**Documentation needed:**
- nixos-unified.org for autowiring rules
- nixos-unified.org for specialArgs
- nixos-unified.org for activation

---

## Option 1: Pure flake-parts (Manual)

**Pros:**
- Complete transparency
- No magic, all explicit
- No external dependencies (except flake-parts itself)
- Full control

**Cons:**
- ~100+ lines of boilerplate in flake.nix
- Every new host requires manual wiring
- Must manually manage specialArgs
- More maintenance burden

**Documentation needed:**
- flake-parts.org for basic API
- nix-darwin docs for darwinSystem
- home-manager docs for homeManagerConfiguration

**Files:**
- `flake.nix.explicit` - Example implementation

---

## Option 2: flake-parts Ecosystem Modules (RECOMMENDED)

**Pros:**
- ✅ All documentation at flake.parts/options/
- ✅ Standard flake-parts patterns
- ✅ Explicit configuration (no directory magic)
- ✅ Less boilerplate than manual
- ✅ Still modular and extensible
- ✅ Part of flake-parts ecosystem

**Cons:**
- Slightly more verbose than nixos-unified
- Must explicitly declare each host (but that's good for clarity!)
- Two different modules (easy-hosts + home-manager)

**Documentation needed:**
- https://flake.parts/options/easy-hosts.html
- https://flake.parts/options/home-manager.html
- Both on the same site, standard flake-parts patterns

**Files:**
- `flake.nix.flake-parts` - Example implementation

---

## Configuration Comparison

### Adding a new Darwin host

**nixos-unified:**
```bash
# Just create the file - auto-discovered
touch configurations/darwin/macbook.nix
```

**flake-parts modules:**
```nix
# In flake.nix, add to easy-hosts.hosts:
macbook = {
  class = "darwin";
  arch = "aarch64";
  modules = [ ./configurations/darwin/macbook.nix ];
};
```

**Manual flake-parts:**
```nix
# In modules/flake/configurations.nix, add full darwinSystem config (~15 lines)
darwinConfigurations.macbook = nix-darwin.lib.darwinSystem { ... };
```

---

### Adding a new home-manager config

**nixos-unified:**
```bash
# Just create the file - auto-discovered
touch configurations/home/jane.nix
```

**flake-parts modules:**
```nix
# In flake.nix, add to flake.homeConfigurations:
jane = inputs.home-manager.lib.homeManagerConfiguration {
  pkgs = inputs.nixpkgs.legacyPackages.aarch64-darwin;
  extraSpecialArgs = { flake = { inherit inputs; inherit (inputs) self; }; };
  modules = [ ./modules/home ./configurations/home/jane.nix ];
};
```

**Manual flake-parts:**
Same as above (no helper module available)

---

### Accessing flake inputs in modules

**All approaches:** Same syntax
```nix
{ flake, ... }:
{
  imports = [ flake.inputs.sops-nix.darwinModules.sops ];
}
```

---

## Recommendation

**Use Option 2: flake-parts Ecosystem Modules**

Reasoning:
1. **Self-documenting**: All options at flake.parts/options/
2. **Explicit but not verbose**: Clear what's happening without boilerplate
3. **Standard patterns**: Uses normal flake-parts conventions
4. **Best of both worlds**: Transparency + convenience

## Migration Steps

```bash
# 1. Backup current setup
cp flake.nix flake.nix.nixos-unified

# 2. Use new flake
cp flake.nix.flake-parts flake.nix

# 3. Update lock file
nix flake lock

# 4. Test build
nix build .#darwinConfigurations.flatbutt.system
nix build .#homeConfigurations.dazmin.activationPackage

# 5. Activate
nix run .#activate-darwin
# or
nix run .#activate-home
```

## What Changes in Daily Use

**Before:**
- Check nixos-unified.org for config options
- Auto-discovery of new configs
- `nix run .#activate` (universal)

**After:**
- Check flake.parts/options/ for config options
- Explicitly add new configs to flake.nix
- `nix run .#activate-darwin` or `nix run .#activate-home` (separate)

**Trade-off:** 
Slightly more manual work when adding configs, but everything is explicit and documented in one place.
