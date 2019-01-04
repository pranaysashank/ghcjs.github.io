{ mkDerivation, atomic-primops, base, clock, containers, deepseq
, exceptions, gauge, ghc-prim, heaps, hspec, lockfree-queue
, monad-control, mtl, QuickCheck, random, stdenv, transformers
, transformers-base
}:
mkDerivation {
  pname = "streamly";
  version = "0.6.0";
  sha256 = "dafe09a4ef24627df2763b6b1583114bedd0f16ce5edc8ca7ee2d301eef7fc15";
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    atomic-primops base clock containers deepseq exceptions ghc-prim
    heaps lockfree-queue monad-control mtl transformers
    transformers-base
  ];
  testHaskellDepends = [
    base containers exceptions hspec mtl QuickCheck random transformers
  ];
  benchmarkHaskellDepends = [ base deepseq gauge random ];
  homepage = "https://github.com/composewell/streamly";
  description = "Beautiful Streaming, Concurrent and Reactive Composition";
  license = stdenv.lib.licenses.bsd3;
}
