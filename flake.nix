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
          pkg-config zlib.dev zlib.dev 
          bzip2.dev expat.dev 
          xz.dev sqlite.dev readline.dev 
          openssl.dev
        ];
        buildInputs = with pkgs; [
          pyenv
          zlib
          bzip2 expat xz libffi libxcrypt gdbm sqlite readline ncurses openssl
 
        ];
        shellHook = ''
          export LD_LIBRARY_PATH=${pkgs.zlib}/lib;
          export LDFLAGS="-L${pkgs.zlib}/lib $LDFLAGS";
          export CPPFLAGS="-I${pkgs.zlib.dev}/include $CPPFLAGS";
          export CFLAGS="-I${pkgs.zlib.dev}/include $CFLAGS";
          export CFLAGS="-I${pkgs.xz.dev}/include $CFLAGS";
          export CFLAGS="-I${pkgs.sqlite.dev}/include $CFLAGS";
          mkdir -p ~/.pyenv
          export PYENV_ROOT=$HOME/.pyenv
        '';
      };
 
  };
}
