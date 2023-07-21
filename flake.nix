{
  description = "Pyenv (Impure) Development Environment";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/23.05";
    pyenv.url = "path:./";
  };

  outputs = { self, nixpkgs }:
    let 
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system}.pkgs;
      lib = nixpkgs.lib;
    in {
      devShells.${system}.default = pkgs.mkShell {
        name = "Pyenv shell";
        buildInputs =  [ pyenv ];  
      };
  };
}
