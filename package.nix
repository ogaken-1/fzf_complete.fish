{
  buildFishPlugin,
  fzf,
  tree,
  lib,
}:
let
  fs = lib.fileset;
in
buildFishPlugin {
  pname = "fzf-complete";
  version = "0.4.0";

  inputs = [
    fzf
    tree
  ];

  src = fs.toSource {
    root = ./.;
    fileset = fs.unions [
      ./conf.d
      ./functions
    ];
  };

  meta = {
    description = "Tab completion via fzf for fish shell.";
    homepage = "https://github.com/ogaken-1/fzf_complete.fish";
    license = lib.licenses.mit;
  };
}
