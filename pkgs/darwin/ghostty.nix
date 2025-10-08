{
  lib,
  stdenvNoCC,
  _7zz,
  fetchurl,
  makeBinaryWrapper,
  version,
  hash,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "ghostty";
  inherit version;

  src = fetchurl {
    url = "https://release.files.ghostty.org/${finalAttrs.version}/Ghostty.dmg";
    inherit hash;
  };

  sourceRoot = ".";

  nativeBuildInputs = [
    _7zz
    makeBinaryWrapper
  ];

  unpackPhase = ''
    7zz x -snld $src
  '';

  postInstall = ''
    mkdir -p $out/Applications
    cp -a Ghostty.app $out/Applications/
    makeWrapper $out/Applications/Ghostty.app/Contents/MacOS/ghostty $out/bin/ghostty
  '';

  postFixup = ''
    mkdir -p $out/share
    ln -s $out/Applications/Ghostty.app/Contents/Resources/{bash-completion,bat,fish,man,nvim,terminfo,vim,zsh} $out/share
  '';

  meta = {
    sourceProvenance = [lib.sourceTypes.binaryNativeCode];

    description = "Fast, native, feature-rich terminal emulator pushing modern features";
    longDescription = ''
      Ghostty is a terminal emulator that differentiates itself by being
      fast, feature-rich, and native. While there are many excellent terminal
      emulators available, they all force you to choose between speed,
      features, or native UIs. Ghostty provides all three.
    '';
    homepage = "https://ghostty.org/";
    downloadPage = "https://ghostty.org/download";
    changelog = "https://ghostty.org/docs/install/release-notes/${
      builtins.replaceStrings ["."] ["-"] finalAttrs.version
    }";
    license = lib.licenses.mit;
    mainProgram = "ghostty";
    platforms = lib.platforms.darwin;
  };

  preferLocalBuild = true;
})
