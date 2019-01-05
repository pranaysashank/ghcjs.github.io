# pranaysashank.github.io
GHCJS experiments

1) Clone this folder
2) `nix-build`, index is symlinked to result/bin/ghcjs-demo.jsexe/index.html
3) For incremental builds:
   `nix-shell -A ghcjs-demo.env`
   `cabal new-build all`
