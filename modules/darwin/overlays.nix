{ ... }:
{
  nixpkgs.overlays = [
    (final: prev: {
      claude-code = prev.claude-code.overrideAttrs (old: rec {
        version = "2.0.1";
        src = prev.fetchzip {
          url = "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-${version}.tgz";
          hash = "sha256-LUbDPFa0lY74MBU4hvmYVntt6hVZy6UUZFN0iB4Eno8=";
        };
      });
    })
  ];
}
