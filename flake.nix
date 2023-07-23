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
          openssl.dev tk
        ];
        buildInputs = with pkgs; [
          pyenv
          zlib tk
          bzip2 expat xz libffi libxcrypt gdbm sqlite readline ncurses openssl
        ];
        shellHook = ''
          export PKG_CONFIG_BIN=${pkgs.pkg-config}/bin/pkg-config;

          export LD_LIBRARY_PATH="$($PKG_CONFIG_BIN --variable=libdir tk libffi openssl zlib bzip2 sqlite3 liblzma ncurses readline|sed -e's/\s/:/g') $LDFLAGS";
          export LDFLAGS="$($PKG_CONFIG_BIN --libs tk libffi openssl zlib bzip2 sqlite3 liblzma ncurses readline) $LDFLAGS";
          export CPPFLAGS="$($PKG_CONFIG_BIN --cflags tk libffi openssl zlib bzip2 sqlite3 liblzma ncurses readline) $CPPFLAGS";
          export CFLAGS="$($PKG_CONFIG_BIN --cflags tk libffi openssl zlib bzip2 sqlite3 liblzma ncurses readline) $CFLAGS";

          mkdir -p ~/.pyenv
          export PYENV_ROOT=$HOME/.pyenv
        '';
      };
 
  };
}
