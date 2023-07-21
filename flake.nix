{
  description = "A flake for a local impure pyenv";
  inputs.nixpkgs.url = github:NixOS/nixpkgs/nixos-23.05;

  outputs = {self, nixpkgs} @inputs: let
    pyenvRepo = builtins.fetchGit{
      "url" =  "https://github.com/pyenv/pyenv";
      "rev" = "b81204c08bf8ef8ab2ea0daeb721ee08020a26a0";
#      "sha256" = "12h96h2fz805r02z4nal4hbasjf8cbbdq7bawbxcvl5pf1g9rwhk";
    };
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system}.pkgs;
  in {

    defaultPackage.x86_64-linux = 
      with import nixpkgs { system = "${system}"; };
      pyenv = stdenv.mkDerivation {
        pname = "pyenv";
        version = "2.3.22";
        src = pyenvRepo;    
        nativeBuildInputs = [pkgs.bats pkgs.git];
        dontConfigure = true;
        dontBuild = true;
        installPhase = ''
           mkdir -p $out
           # Copy clone to $out
           cp -r ${pyenvRepo.outPath}/* $out
           
           # Remind the user to set PYENV_ROOT
           echo To be impure, please Run 'mkdir ~/.pyenv-nix' and add 'export PYENV_ROOT=$HOME/.pyenv-nix' to your profile
        '';
      };

      devShells.${system}.default = pkgs.mkShell {
        name = "pyenv Cli Environment";
        buildInputs = [pyenv];
      };
 
  };
}
