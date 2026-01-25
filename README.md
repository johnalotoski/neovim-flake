# What is this?
This is my personal neovim config. Feel free to take bits of it to build your own or run it yourself.

As this is my personal config I am bound to change it a lot so I recommend forking rather then pointing to
this config.

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

### In your flake (using neovimBuilder)

```nix
{
  inputs.neovim-flake.url = "github:johnalotoski/neovim-flake";

  outputs = { self, nixpkgs, neovim-flake }: {
    packages.x86_64-linux.default =
      neovim-flake.neovimBuilder.${system} {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        config = {
          config.vim = {
            theme.nord.enable = true;
            theme.gruvbox.enable = false;
            lsp.rust = true;
            lsp.python = true;
          };
        };
      };
  };
}
```

### In your flake (using buildNeovim helper)

The `buildNeovim` helper provides a simpler API for common use cases:

```nix
{
  inputs.neovim-flake.url = "github:johnalotoski/neovim-flake";

  outputs = { self, nixpkgs, neovim-flake }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default =
        neovim-flake.lib.${system}.buildNeovim {
          inherit pkgs;
          config = {
            config.vim = {
              theme.nord.enable = true;
              theme.gruvbox.enable = false;
              lsp.haskellTools = true;
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
            (pkgs.buildNeovim {
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
- `neovimPackage`: The neovim package to wrap (default: `pkgs.neovim-unwrapped`)
- `includeDefaults`: Whether to include default configuration (default: `true`)
- `extraSpecialArgs`: Additional special arguments to pass to the module system (default: `{}`)
- `pluginOverlay`: Plugin overlay (automatically provided by the flake, rarely needs to be customized)
- `extraOverlay`: Additional overlay applied after `pluginOverlay` for overriding packages (default: `(final: prev: {})`)

**Note**: The plugin overlay is automatically applied internally, so it doesn't need to be applied to pkgs before calling neovimBuilder.

Example with advanced options:

```nix
neovimBuilder {
  inherit pkgs;
  config = {
    config.vim = {
      # Your configuration here
    };
  };

  # Use nightly neovim.  Notice the nightly does not require the `-unwrapped`
  # suffix, but use of the regular neovim package does.
  neovimPackage = pkgs.neovim-nightly;

  # Start with minimal config
  includeDefaults = false;

  extraSpecialArgs = {
    myCustomArg = "value";
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

#### Strategy 3: Override via config.vim (for neovim package only)

For just overriding the neovim package itself, use the `neovimPackage` parameter:

```nix
neovimBuilder {
  inherit pkgs;
  # Use nightly neovim instead of stable
  neovimPackage = pkgs.neovim-nightly;
  config = { config.vim.lsp.rust = true; };
}
```

**Note**: The overlay respects your customizations by checking `prev.packageName` before providing defaults, so Strategy 1 works seamlessly.

### Accessing individual plugins

All plugins are also exported individually via `packages`:

```nix
{
  inputs.neovim-flake.url = "github:johnalotoski/neovim-flake";

  outputs = { self, nixpkgs, neovim-flake }: {
    packages.x86_64-linux.myPlugin =
      neovim-flake.packages.x86_64-linux.nvim-tree-lua;
  };
}
```
