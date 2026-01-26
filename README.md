# What is this?
This is my personal neovim config. Feel free to take bits of it to build your own or run it yourself.

# How to use

## Running directly
Clone the repo and run the following from the directory:
```
nix run
```
or
```
nix run github:johnalotoski/neovim-flake
```

## Using as a library

### In your flake

```nix
{
  inputs.neovim-flake.url = "github:johnalotoski/neovim-flake";

  outputs = { self, nixpkgs, neovim-flake }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default =
        neovim-flake.neovimBuilder.${system} {
          inherit pkgs;
          config = {
            config.vim = {
              theme.nord.enable = true;
              theme.gruvbox.enable = false;
              lsp.rust = true;
            };
          };
        };
    };
}
```

### Via overlay in NixOS configuration

```nix
{
  inputs.neovim-flake.url = "github:johnalotoski/neovim-flake";

  outputs = { self, nixpkgs, neovim-flake }: {
    nixosConfigurations.myhost = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ({ pkgs, ... }: {
          nixpkgs.overlays = [ neovim-flake.overlay.x86_64-linux ];

          environment.systemPackages = [
            (pkgs.neovimBuilder {
              inherit pkgs;
              config = {
                config.vim = {
                  theme.nord.enable = true;
                  theme.gruvbox.enable = false;
                  lsp.rust = true;
                };
              };
            })
          ];
        })
      ];
    };
  };
}
```

### Advanced configuration options

The `neovimBuilder` function accepts the following parameters:

- `pkgs`: The nixpkgs package set (required)
- `config`: Module configuration (default: `{}`)
- `neovimPackage`: The neovim package to wrap (default: `pkgs.neovim-nightly`)
- `includeDefaults`: Whether to include default configuration (default: `true`)
- `extraSpecialArgs`: Additional special arguments to pass to the module system (default: `{}`)
- `pluginOverlay`: Plugin overlay (automatically provided by the flake, rarely needs to be customized)
- `extraOverlay`: Additional overlay applied after `pluginOverlay` for overriding packages (default: `(final: prev: {})`)

**Notes**:
- The plugin overlay is automatically applied internally, so it doesn't need to be applied to pkgs before calling neovimBuilder.
- The default `neovimPackage` is `pkgs.neovim-nightly`, which is provided by the flake's overlay. If not using the overlay, you can use `neovim-flake.packages.${system}.neovim-nightly` or `pkgs.neovim-unwrapped` from nixpkgs.
- If the default `neovimPackage` is used without the overlay, the default package becomes `neovim-flake.packages.${system}.neovim-nightly`.

Example with advanced options:

```nix
{
  inputs.neovim-flake.url = "github:johnalotoski/neovim-flake";

  outputs = { self, nixpkgs, neovim-flake }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = neovim-flake.neovimBuilder.${system} {
        inherit pkgs;
        config = {
          config.vim = {
            # Your configuration here
          };
        };

        # Option 1: Use neovim-nightly from the flake's packages (no overlay needed)
        neovimPackage = neovim-flake.packages.${system}.neovim-nightly;

        # Option 2: Use stable neovim from nixpkgs (requires -unwrapped suffix)
        # neovimPackage = pkgs.neovim-unwrapped;

        # Start with minimal config
        includeDefaults = false;

        extraSpecialArgs = {
          myCustomArg = "value";
        };
      };
    };
}
```

### Overriding packages

There are three strategies for overriding packages (language servers, plugins, etc.) provided by the flake:

#### Strategy 1: Pre-overlay your pkgs (simplest)

Apply your customizations to pkgs before passing it to neovimBuilder. The flake's overlay respects existing packages:

```nix
let
  pkgs = import nixpkgs {
    system = "x86_64-linux";
    overlays = [
      (final: prev: {
        # Override with your custom version
        nil = myCustomNil;
        rust-analyzer = myCustomRustAnalyzer;
      })
    ];
  };
in
  neovimBuilder {
    inherit pkgs;
    config = { config.vim.lsp.nix = true; };
  }
```

#### Strategy 2: Use extraOverlay parameter (most flexible)

Pass an `extraOverlay` that gets applied after the flake's overlay:

```nix
neovimBuilder {
  inherit pkgs;
  config = { config.vim.lsp.nix = true; };
  extraOverlay = final: prev: {
    # Override language servers
    nil = myCustomNil;

    # Override a plugin
    nvim-tree-lua = prev.vimUtils.buildVimPlugin {
      pname = "nvim-tree-lua";
      version = "my-fork";
      src = fetchFromGitHub { ... };
    };

    # Add a custom package
    myCustomTool = final.callPackage ./my-tool.nix {};
  };
}
```

#### Strategy 3: Use neovimPackage parameter (for neovim package only)

For just overriding the neovim package itself, use the `neovimPackage` parameter:

```nix
{
  inputs.neovim-flake.url = "github:johnalotoski/neovim-flake";

  outputs = { self, nixpkgs, neovim-flake }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = neovim-flake.neovimBuilder.${system} {
        inherit pkgs;
        config = { config.vim.lsp.rust = true; };

        # Use neovim-nightly from the flake's packages (no overlay needed)
        neovimPackage = neovim-flake.packages.${system}.neovim-nightly;

        # Or use stable neovim from nixpkgs
        # neovimPackage = pkgs.neovim-unwrapped;
      };
    };
}
```

**Note**: The overlay respects your customizations by checking `prev.packageName` before providing defaults, so Strategy 1 works seamlessly.

### Accessing individual packages

All plugins and neovim-nightly are exported individually via `packages`:

```nix
{
  inputs.neovim-flake.url = "github:johnalotoski/neovim-flake";

  outputs = { self, nixpkgs, neovim-flake }: {
    # Access individual plugins
    packages.x86_64-linux.myPlugin =
      neovim-flake.packages.x86_64-linux.nvim-tree-lua;

    # Access neovim-nightly
    packages.x86_64-linux.nvim-nightly =
      neovim-flake.packages.x86_64-linux.neovim-nightly;
  };
}
```
