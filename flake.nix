{
  description = "A flake for a local impure pyenv";
  inputs.nixpkgs.url = github:NixOS/nixpkgs/nixos-23.05;

  outputs = {self, nixpkgs} @inputs: let
    system = "x86_64-linux";
    #pkgs = nixpkgs.legacyPackages.${system}.pkgs;
    pkgs  =  import self.inputs.nixpkgs {
      inherit system;
      overlays = [ (import ./pyenv-overlay.nix) ];
      config.allowUnfree = true;
    };

 
  in rec {

      devShells.${system}.default = pkgs.mkShell rec  {
        name = "pyenv Cli Environment";
        nativeBuildInputs = with pkgs; [
          pkg-config
        ];
        buildInputs = with pkgs; [
          bzip2 expat xz libffi libxcrypt gdbm sqlite readline ncurses openssl
          pyenv
        ];
        shellHook = ''
          export LD_LIBRARY_PATH=${pkgs.zlib}/lib;
        '';
      };
 
  };
}
