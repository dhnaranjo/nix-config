{
  lib,
  stdenv,
  stb,
}:

stdenv.mkDerivation {
  pname = "stb-with-cmake";
  inherit (stb) version;

  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    
    mkdir -p $out/include
    # Copy stb headers to root include dir so they can be found as <stb_image.h>
    cp ${stb}/include/stb/* $out/include/
    
    mkdir -p $out/lib/cmake/stb
    cat > $out/lib/cmake/stb/stbConfig.cmake << EOF
    get_filename_component(stb_CMAKE_DIR "\''${CMAKE_CURRENT_LIST_FILE}" PATH)
    set(stb_INCLUDE_DIRS "$out/include")
    
    if(NOT TARGET stb::stb)
      add_library(stb::stb INTERFACE IMPORTED)
      set_target_properties(stb::stb PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES "$out/include"
      )
    endif()
    EOF
    
    runHook postInstall
  '';

  meta = stb.meta // {
    description = "${stb.meta.description} (with CMake config)";
  };
}
