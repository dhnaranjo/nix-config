{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  protobuf3_21,
}:

stdenv.mkDerivation rec {
  pname = "libarcus";
  version = "5.11.0";

  src = fetchFromGitHub {
    owner = "Ultimaker";
    repo = "libArcus";
    rev = "51982a1b6a0cbafa5c532cde3ab2eb303c0cc84d";
    hash = "sha256-0mlD9Wd3QfrLOTaCTKXxb1XOZHwA15XRVMdL96BEswo=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ protobuf3_21 ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DENABLE_SENTRY=OFF"
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "find_package(standardprojectsettings REQUIRED)" "" \
      --replace-fail "set_project_warnings(Arcus)" "" \
      --replace-fail "enable_sanitizers(Arcus)" "" \
      --replace-fail "use_threads(Arcus)" "find_package(Threads REQUIRED)" \
      --replace-fail "target_link_libraries(Arcus PUBLIC protobuf::libprotobuf)" "target_link_libraries(Arcus PUBLIC protobuf::libprotobuf Threads::Threads)"
  '';

  installPhase = ''
    runHook preInstall
    
    mkdir -p $out/lib
    mkdir -p $out/include/Arcus
    mkdir -p $out/lib/cmake/arcus
    
    cp libArcus.dylib $out/lib/
    cp -r ../include/Arcus/* $out/include/Arcus/
    
    # Create CMake config file
    cat > $out/lib/cmake/arcus/arcusConfig.cmake << EOF
    get_filename_component(arcus_CMAKE_DIR "\''${CMAKE_CURRENT_LIST_FILE}" PATH)
    set(arcus_INCLUDE_DIRS "$out/include")
    set(arcus_LIBRARIES "$out/lib/libArcus.dylib")
    
    if(NOT TARGET arcus::arcus)
      add_library(arcus::arcus SHARED IMPORTED)
      set_target_properties(arcus::arcus PROPERTIES
        IMPORTED_LOCATION "$out/lib/libArcus.dylib"
        INTERFACE_INCLUDE_DIRECTORIES "$out/include"
      )
    endif()
    
    # Also create Arcus target for compatibility
    if(NOT TARGET Arcus)
      add_library(Arcus ALIAS arcus::arcus)
    endif()
    EOF
    
    runHook postInstall
  '';

  meta = with lib; {
    description = "Communication library between internal components for Ultimaker software";
    homepage = "https://github.com/Ultimaker/libArcus";
    license = licenses.lgpl3Plus;
    platforms = platforms.darwin;
    maintainers = [ ];
  };
}
