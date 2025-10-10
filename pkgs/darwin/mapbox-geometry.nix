{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "mapbox-geometry";
  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "mapbox";
    repo = "geometry.hpp";
    rev = "v${version}";
    hash = "sha256-hUme4I0iBmCOOQXbwBnpHrazuc7dQlCKqEmKcWP37ho=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/include
    cp -r include/mapbox $out/include/

    mkdir -p $out/lib/cmake/mapbox-geometry
    cat > $out/lib/cmake/mapbox-geometry/mapbox-geometryConfig.cmake << EOF
    get_filename_component(mapbox-geometry_CMAKE_DIR "\''${CMAKE_CURRENT_LIST_FILE}" PATH)
    set(mapbox-geometry_INCLUDE_DIRS "$out/include")

    if(NOT TARGET mapbox-geometry::mapbox-geometry)
      add_library(mapbox-geometry::mapbox-geometry INTERFACE IMPORTED)
      set_target_properties(mapbox-geometry::mapbox-geometry PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES "$out/include"
      )
    endif()
    EOF

    runHook postInstall
  '';

  meta = with lib; {
    description = "Header-only C++ geometry types";
    homepage = "https://github.com/mapbox/geometry.hpp";
    license = licenses.isc;
    platforms = platforms.darwin;
    maintainers = [ ];
  };
}
