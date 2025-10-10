{
  lib,
  stdenv,
  fetchFromGitHub,
  callPackage,
}:

let
  mapbox-geometry = callPackage ./mapbox-geometry.nix { };
in
stdenv.mkDerivation rec {
  pname = "mapbox-wagyu";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "mapbox";
    repo = "wagyu";
    rev = version;
    hash = "sha256-IoG09Fea9HNfueJkyf7k6fCKkM8N/pllKARyXdJhTaE=";
  };

  propagatedBuildInputs = [ mapbox-geometry ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/include
    cp -r include/mapbox $out/include/

    mkdir -p $out/lib/cmake/mapbox-wagyu
    cat > $out/lib/cmake/mapbox-wagyu/mapbox-wagyuConfig.cmake << EOF
    get_filename_component(mapbox-wagyu_CMAKE_DIR "\''${CMAKE_CURRENT_LIST_FILE}" PATH)
    set(mapbox-wagyu_INCLUDE_DIRS "$out/include")

    if(NOT TARGET mapbox-wagyu::mapbox-wagyu)
      add_library(mapbox-wagyu::mapbox-wagyu INTERFACE IMPORTED)
      set_target_properties(mapbox-wagyu::mapbox-wagyu PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES "$out/include"
      )
    endif()
    EOF

    runHook postInstall
  '';

  meta = with lib; {
    description = "General library for geometry operations (union, intersection, difference, XOR)";
    homepage = "https://github.com/mapbox/wagyu";
    license = licenses.isc;
    platforms = platforms.darwin;
    maintainers = [ ];
  };
}
