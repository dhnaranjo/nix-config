{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.mcp-servers.serena;

  serena = pkgs.python3Packages.buildPythonApplication rec {
    pname = "serena";
    version = "0.1.4-unstable-2025-10-07";
    pyproject = true;

    src = pkgs.fetchFromGitHub {
      owner = "oraios";
      repo = "serena";
      rev = "77213e18d0925e559447defbc41a514c7816c5d6";
      hash = "sha256-zTTNRTjes6WyZCoUeSWMMvpnU09gaE2+5U8dNyW2DOo=";
    };

    build-system = [ pkgs.python3Packages.hatchling ];

    pythonRelaxDeps = true;

    pythonRemoveDeps = [
      "pyright"
      "dotenv"
    ];

    dependencies = with pkgs.python3Packages; [
      anthropic
      docstring-parser
      flask
      jinja2
      joblib
      mcp
      overrides
      pathspec
      psutil
      pydantic
      python-dotenv
      pyyaml
      requests
      ruamel-yaml
      sensai-utils
      tiktoken
      tqdm
      types-pyyaml
    ];

    makeWrapperArgs = [
      "--prefix"
      "PATH"
      ":"
      (lib.makeBinPath [
        pkgs.nodejs
        pkgs.pyright
      ])
    ];

    pythonImportsCheck = [ "serena" ];

    nativeCheckInputs = with pkgs.python3Packages; [
      pytest-xdist
      pytestCheckHook
      syrupy
      tkinter
      pkgs.writableTmpDirAsHomeHook
    ];

    disabledTests = [
      "test_serena_agent.py"
      "test_symbol_editing.py"
    ];

    pytestFlags = [ "test/serena" ];

    meta = {
      description = "Powerful coding agent toolkit providing semantic retrieval and editing capabilities";
      homepage = "https://github.com/oraios/serena";
      license = lib.licenses.mit;
      mainProgram = "serena";
    };
  };
in
{
  options.mcp-servers.serena = {
    enable = lib.mkEnableOption "Serena MCP server for semantic code understanding";
  };

  config = lib.mkIf cfg.enable {
    programs.opencode.settings.mcp.serena = {
      type = "local";
      command = [
        "${serena}/bin/serena"
        "start-mcp-server"
        "--enable-web-dashboard"
        "false"
        "--enable-gui-log-window"
        "false"
      ];
      enabled = true;
    };
  };
}
