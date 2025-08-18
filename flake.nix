{
  description = "Neovim Nightly with lsp and full config deployment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    neovim.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = { self, nixpkgs, neovim }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };

      lspPackages = with pkgs; [
        pyright
        nodePackages.typescript-language-server
        lua-language-server
        gopls
        vscode-langservers-extracted
        clang-tools
        bash-language-server
        vscode-json-languageserver
        nixd
      ];

      # Copy the entire nvim directory to .config/nvim
      nvimConfig = pkgs.stdenv.mkDerivation {
        name = "nvim-config";
        src = ./nvim;
        installPhase = ''
          mkdir -p $out/.config/nvim
          cp -r $src/* $out/.config/nvim/
        '';
      };

      nvimNightly = pkgs.writeShellScriptBin "nvim" ''
        # Deploy the config if it doesn't exist
        if [ ! -d "$HOME/.config/nvim" ]; then
          mkdir -p "$HOME/.config"
          cp -r ${nvimConfig}/.config/nvim "$HOME/.config/"
        fi
        
        PATH="${pkgs.lib.makeBinPath lspPackages}:$PATH" \
        exec ${neovim.packages.${system}.neovim}/bin/nvim "$@"
      '';
    in
    {
      packages.${system}.default = nvimNightly;

      apps.${system}.default = {
        type = "app";
        program = "${nvimNightly}/bin/nvim";
      };
    };
}
