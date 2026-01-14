{
  description = "Tab completion via fzf for fish shell.";
  outputs =
    { ... }:
    {
      overlays.default = final: prev: {
        fishPlugins.fzf-complete = prev.callPackage ./package.nix {
          buildFishPlugin = prev.fishPlugins.buildFishPlugin;
        };
      };
    };
}
