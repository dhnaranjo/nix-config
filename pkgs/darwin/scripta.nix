{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "scripta";
  version = "1.1.0-alpha.0";

  src = fetchFromGitHub {
    owner = "Ultimaker";
    repo = "Scripta_public";
    rev = "main";
    hash = "sha256-9TKJLmuJFXUYkcO8wiCdwm1c2yf4wlvSEBD5HJkJwQ0=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DENABLE_TESTS=OFF"
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "find_package(standardprojectsettings REQUIRED)" "" \
      --replace-fail "set_project_warnings(scripta)" "" \
      --replace-fail "enable_sanitizers(scripta)" ""
  '';

  # Header-only library
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/include
    cp -r ../include/scripta $out/include/

    mkdir -p $out/lib/cmake/scripta
    cat > $out/lib/cmake/scripta/scriptaConfig.cmake << EOF
    get_filename_component(scripta_CMAKE_DIR "\''${CMAKE_CURRENT_LIST_FILE}" PATH)
    set(scripta_INCLUDE_DIRS "$out/include")

    if(NOT TARGET scripta::scripta)
      add_library(scripta::scripta INTERFACE IMPORTED)
      set_target_properties(scripta::scripta PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES "$out/include"
        INTERFACE_COMPILE_FEATURES "cxx_std_20"
      )
    endif()
    EOF

    runHook postInstall
  '';

  meta = with lib; {
    description = "Visual debugger for CuraEngine (header-only stub library)";
    homepage = "https://github.com/Ultimaker/Scripta_public";
    license = licenses.unfree; # No license specified in repo
    platforms = platforms.darwin;
    maintainers = [ ];
  };
}
