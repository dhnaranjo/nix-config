{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  callPackage,
  protobuf3_21,
  boost,
  rapidjson,
  spdlog,
  fmt,
}:

let
  libarcus = callPackage ./libarcus.nix { };
  mapbox-geometry = callPackage ./mapbox-geometry.nix { };
  mapbox-wagyu = callPackage ./mapbox-wagyu.nix { };
  clipper = callPackage ./clipper.nix { };
  range-v3 = callPackage ./range-v3.nix { };
  scripta = callPackage ./scripta.nix { };
  stb = callPackage ./stb-with-cmake.nix { };
in
stdenv.mkDerivation rec {
  pname = "curaengine";
  version = "5.10.3";

  src = fetchFromGitHub {
    owner = "Ultimaker";
    repo = "CuraEngine";
    rev = "f8d71838b1b975484e931c7782544625599b7f83";
    hash = "sha256-pq0h2H3+TT1GTW2zZvPwlxCZO+8ShFx3tSNYkhm6Jc8=";
  };

  nativeBuildInputs = [
    cmake
    stdenv.cc.bintools.bintools
  ];

  buildInputs = [
    libarcus
    protobuf3_21
    boost
    stb
    rapidjson
    spdlog
    fmt
    mapbox-geometry
    mapbox-wagyu
    clipper
    range-v3
    scripta
  ];

  cmakeFlags = [
    "-DCURA_ENGINE_VERSION=${version}"
    "-DENABLE_ARCUS=ON"
    "-DENABLE_PLUGINS=OFF"
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "find_package(standardprojectsettings REQUIRED)" "" \
      --replace-fail "AssureOutOfSourceBuilds()" "" \
      --replace-fail "set_project_warnings(_CuraEngine)" "" \
      --replace-fail "enable_sanitizers(_CuraEngine)" "" \
      --replace-fail "use_threads(_CuraEngine)" "" \
      --replace-fail "use_threads(CuraEngine)" "" \
      --replace-fail "boost::boost" "Boost::headers"
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp CuraEngine $out/bin/
    install_name_tool -add_rpath ${libarcus}/lib $out/bin/CuraEngine

    runHook postInstall
  '';

  meta = with lib; {
    description = "Powerful, fast and robust engine for processing 3D models into 3D printing instruction";
    homepage = "https://github.com/Ultimaker/CuraEngine";
    license = licenses.agpl3Only;
    platforms = platforms.darwin;
    maintainers = [ ];
    mainProgram = "CuraEngine";
  };
}
