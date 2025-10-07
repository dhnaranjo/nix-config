{
  stdenv,
  apple-sdk,
  openpam,
  darwin,
}:

stdenv.mkDerivation {
  name = "pam_monitor";
  src = ./.;

  nativeBuildInputs = [ darwin.sigtool ];
  buildInputs = [
    apple-sdk
    openpam
  ];

  buildPhase = ''
    $CC -bundle -o pam_monitor.so pam_monitor.c \
      -framework IOKit \
      -framework CoreFoundation \
      -lpam
  '';

  installPhase = ''
    mkdir -p $out/lib/pam
    cp pam_monitor.so $out/lib/pam/
  '';
}
