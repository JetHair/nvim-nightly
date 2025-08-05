{
  description = "Neovim Nightly with lsp and embedded config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    neovim.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs =
    {
      self,
      nixpkgs,
      neovim,
    }:
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
        gcc
      ];

      nvimConfig = pkgs.lib.cleanSource ./nvim;
      nvimConfigPath =
        pkgs.runCommand "nvim-config"
          {
          }
          ''
            mkdir -p $out
            cp -r ${nvimConfig}/* $out/
          '';

      nvimNightly = pkgs.writeShellScriptBin "nvim" ''
        PATH="${pkgs.lib.makeBinPath lspPackages}:$PATH" \
        exec ${neovim.packages.${system}.neovim}/bin/nvim -u ${nvimConfigPath}/init.lua "$@"
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
