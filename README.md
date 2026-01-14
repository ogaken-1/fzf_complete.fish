# fzf_complete.fish

Tab completion via fzf for fish shell.

Most of snippets are ported from https://github.com/yuki-yano/zeno.zsh

## Install

home-manager:

Add repo to `inputs` of flake.

```nix
{
  inputs = {
    fish-fzf-complete = {
      url = "github:ogaken-1/fzf_complete.fish"
    };
  };
}
```

Add overlay to home-manager configuration.

```nix
{
  nixpkgs.overlays = [
    inputs.fish-fzf-complete.overlays.default
  ];
}
```

Add package to `home.packages`.

```nix
{ pkgs }:
{
  home.packages = [
    pkgs.fishPlugins.fzf-complete
  ];
}
```
