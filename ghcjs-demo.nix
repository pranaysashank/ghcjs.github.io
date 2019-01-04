{ mkDerivation, base, ghcjs-dom, lucid, deepseq,
  streamly, mtl, stdenv }:
mkDerivation {
  pname = "ghcjs-demo";
  version = "0.1";
  src = ghcjs-demo/.;
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [ base ghcjs-dom lucid deepseq streamly mtl ];
  executableHaskellDepends = [ base ];
  license = "unknown";
  hydraPlatforms = stdenv.lib.platforms.none;
}
