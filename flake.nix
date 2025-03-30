{
  description = "Bonsai Blocks";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        notify =
          if pkgs.stdenv.isDarwin
          then pkgs.fswatch
          else pkgs.inotify-tools;
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            aider-chat
            elixir
            erlang
            lexical

            # Optional but recommended development tools
            notify
          ];

          # Shell hook for additional environment setup
          shellHook = ''
            echo "Elixir development environment loaded!"
            echo "Elixir version: $(elixir --version)"
            echo "File watching tool: ${notify.name}"
          '';
        };
      }
    );
}
