{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "range-v3";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "ericniebler";
    repo = "range-v3";
    rev = version;
    hash = "sha256-bRSX91+ROqG1C3nB9HSQaKgLzOHEFy9mrD2WW3PRBWU=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DRANGE_V3_TESTS=OFF"
    "-DRANGE_V3_EXAMPLES=OFF"
    "-DRANGE_V3_PERF=OFF"
  ];

  meta = with lib; {
    description = "Range library for C++14/17/20, basis for C++20's std::ranges";
    homepage = "https://github.com/ericniebler/range-v3";
    license = licenses.boost;
    platforms = platforms.darwin;
    maintainers = [ ];
  };
}
