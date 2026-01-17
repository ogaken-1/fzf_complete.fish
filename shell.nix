{
  pkgs ? import <nixpkgs> { },
}:
let
  fishWithPlugins = pkgs.wrapFish {
    pluginPkgs = [
      pkgs.fishPlugins.fishtape_3
    ];
  };
in
pkgs.mkShell {
  buildInputs = [
    fishWithPlugins
    pkgs.fzf
    pkgs.tree
    pkgs.just
  ];
}
