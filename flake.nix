{
  description = "A flake for a local impure pyenv";
  inputs.nixpkgs.url = github:NixOS/nixpkgs/nixos-24.11;

  outputs = {self, nixpkgs} @inputs: let
    system = "x86_64-linux";
    #pkgs = nixpkgs.legacyPackages.${system}.pkgs;
    pkgs  =  import self.inputs.nixpkgs {
      inherit system;
      overlays = [ (import ./pyenv-overlay.nix) ];
      config.allowUnfree = true;
      config.cudaSupport = true;
    };

 
  in rec {

      devShells.${system}.default = pkgs.mkShell rec  {
        name = "pyenv Cli Environment";
        nativeBuildInputs = with pkgs; [
          pkg-config zlib.dev zlib.dev 
          bzip2.dev expat.dev 
          xz.dev sqlite.dev readline.dev 
          openssl.dev tk tcl
          curl portaudio openblas
        ];
        buildInputs = with pkgs; [
          pyenv
          zlib tk tcl
          bzip2 expat xz libffi libxcrypt gdbm sqlite readline ncurses openssl libffi
          cudaPackages_12_2.cudatoolkit linuxPackages.nvidia_x11 cudaPackages_12_2.cuda_cudart openblas portaudio
        ];
        shellHook = ''
          export PKG_CONFIG_BIN=${pkgs.pkg-config}/bin/pkg-config;

          export LD_LIBRARY_PATH="$($PKG_CONFIG_BIN --variable=libdir tk tcl libffi openssl zlib bzip2 sqlite3 liblzma ncurses readline openblas64 portaudio-2.0|sed -e's/\s/:/g') $LDFLAGS";
          export LD_LIRBARY_PATH="${pkgs.stdenv.cc.cc.lib}/lib":$LD_LIBRARY_PATH;
          export LD_LIBRARY_PATH="${pkgs.gcc-unwrapped.lib}/lib":$LD_LIRBARY_PATH;
          export LD_LIBRARY_PATH="${pkgs.cudatoolkit.lib}/lib":$LD_LIRBARY_PATH;
          export LD_LIBRARY_PATH="${pkgs.linuxPackages.nvidia_x11}/lib":$LD_LIRBARY_PATH;
          export LDFLAGS="$($PKG_CONFIG_BIN --libs tk tcl libffi openssl zlib bzip2 sqlite3 liblzma ncurses readline openblas64 portaudio-2.0) $LDFLAGS";
          export CPPFLAGS="$($PKG_CONFIG_BIN --cflags tk tcl libffi openssl zlib bzip2 sqlite3 liblzma ncurses readline openblas64 portaudio-2.0) $CPPFLAGS";
          export CFLAGS="$($PKG_CONFIG_BIN --cflags tk tcl libffi openssl zlib bzip2 sqlite3 liblzma ncurses readline openblas64 portaudio-2.0) $CFLAGS";

          if [[ -z "$PYENV_ROOT" ]]; then
            PYENV_ROOT=$HOME/.pyenv
            echo "Using default PYENV_ROOT: $PYENV_ROOT";
          fi
          export PYENV_ROOT;
          export PATH=$PYENV_ROOT/shims:$PATH;
          mkdir -p $PYENV_ROOT;
        '';
      };
 
  };
}
