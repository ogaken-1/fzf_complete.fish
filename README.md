# fzf_complete.fish

Tab completion via fzf for fish shell.

Most of snippets are ported from https://github.com/yuki-yano/zeno.zsh

## Requirements

- [fzf](https://github.com/junegunn/fzf)

## Install

### Fisher

```fish
fisher install ogaken-1/fzf_complete.fish
```

### home-manager (Nix)

Add repo to `inputs` of flake.

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fish-fzf-complete = {
      url = "github:ogaken-1/fzf_complete.fish";
    };
  };
  outputs = { nixpkgs, home-manager, fish-fzf-complete, ...  }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
      };
      homeConfiguration = { pkgs, ... }: {
        # Add overlay to `nixpkgs.overlays`
        nixpkgs.overlays = [
          fish-fzf-complete.overlays.default
        ];
        programs.fish = {
          enable = true;
        };
        # Add package to `home.packages`.
        home.packages = [
          pkgs.fishPlugins.fzf-complete
        ];
      };
    in
    {
      homeConfigurations.alice = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          homeConfiguration
        ];
      };
    };

}
```

## Features

- **git**: Context-aware completion for subcommands (branches, commits, files, remotes, etc.) with preview
- **cd**: Directory completion with preview
- **kill**: Process completion

Press `?` to toggle preview in fzf.

## Configuration

Set `FZF_COMPLETE_NO_DEFAULT_BINDING` to disable the default Tab binding:

```fish
set -g FZF_COMPLETE_NO_DEFAULT_BINDING 1
```

## Acknowledgments

- [zeno.zsh](https://github.com/yuki-yano/zeno.zsh) by [@yuki-yano](https://github.com/yuki-yano) - Original implementation for zsh

## License

MIT
