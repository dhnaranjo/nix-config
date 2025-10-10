{
  lib,
  stdenv,
  fetchzip,
  cmakeMinimal,
}:

stdenv.mkDerivation rec {
  pname = "clipper";
  version = "6.4.2";

  src = fetchzip {
    url = "https://sourceforge.net/projects/polyclipping/files/clipper_ver${version}.zip";
    hash = "sha256-WS076Us7dLUf1eLc1d3Cn+55e0gxLaxDysG2mePHwvU=";
    stripRoot = false;
  };

  setSourceRoot = ''
    sourceRoot=$(echo */cpp)
  '';

  nativeBuildInputs = [ cmakeMinimal ];

  cmakeFlags = [
    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
  ];

  postInstall = ''
    mkdir -p $out/lib/cmake/clipper
    cat > $out/lib/cmake/clipper/clipperConfig.cmake << EOF
    get_filename_component(clipper_CMAKE_DIR "\''${CMAKE_CURRENT_LIST_FILE}" PATH)
    set(clipper_INCLUDE_DIRS "$out/include/polyclipping")
    set(clipper_LIBRARIES "$out/lib/libpolyclipping.dylib")

    if(NOT TARGET clipper::clipper)
      add_library(clipper::clipper SHARED IMPORTED)
      set_target_properties(clipper::clipper PROPERTIES
        IMPORTED_LOCATION "$out/lib/libpolyclipping.dylib"
        INTERFACE_INCLUDE_DIRECTORIES "$out/include/polyclipping"
      )
    endif()
    EOF
  '';

  meta = with lib; {
    description = "Polygon clipping and offsetting library";
    homepage = "http://www.angusj.com/delphi/clipper.php";
    license = licenses.boost;
    platforms = platforms.darwin;
    maintainers = [ ];
  };
}
