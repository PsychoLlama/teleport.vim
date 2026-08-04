{
  description = "teleport.vim: navigate faster with frecency";

  inputs = {
    systems.url = "github:nix-systems/default";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    {
      self,
      nixpkgs,
      systems,
    }:

    let
      inherit (nixpkgs) lib;

      eachSystem = lib.flip lib.mapAttrs (
        lib.genAttrs (import systems) (system: import nixpkgs { inherit system; })
      );
    in

    {
      packages = eachSystem (
        _: pkgs:

        let
          fs = lib.fileset;
        in

        rec {
          default = teleport-vim;

          teleport-vim = pkgs.vimUtils.buildVimPlugin {
            pname = "teleport.vim";
            version = self.shortRev or "dirty";
            src = fs.toSource {
              root = ./.;
              fileset = fs.unions [
                (fs.fileFilter (f: !f.hasExt "vader") ./autoload)
                ./plugin
                ./doc
              ];
            };

            meta = {
              homepage = "https://github.com/PsychoLlama/teleport.vim";
              license = lib.licenses.mit;
            };
          };
        }
      );

      devShells = eachSystem (
        _: pkgs: {
          default = pkgs.mkShell {
            packages = [
              pkgs.nixfmt
              pkgs.treefmt
            ];
          };
        }
      );
    };
}
