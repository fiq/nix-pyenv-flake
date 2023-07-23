{
  pkgs ? import (fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/refs/tags/23.05.tar.gz";
    sha256 = "10wn0l08j9lgqcw8177nh2ljrnxdrpri7bp0g7nvrsn9rkawvlbf";
  }) {}
}:
let 
  pyenvRepo = builtins.fetchTarball{
    "url" =  "https://github.com/pyenv/pyenv/archive/refs/tags/v2.3.23.tar.gz";
    "sha256" = "0mr9q4bpc9906mc338cs58ksm0ld6bnkvvjp8752w45kz2gnxz42";
  };
in
  pkgs.stdenv.mkDerivation rec {
    pname = "pyenv";
    version = "2.3.23";
    src = pyenvRepo;    
    nativeBuildInputs = [pkgs.bats pkgs.git pkgs.zlib.dev];
    dontConfigure = true;
    dontBuild = true;
    installPhase = ''
       mkdir -p $out
       # Copy clone to $out
       cp -r ${pyenvRepo}/* $out
       
       # Remind the user to set PYENV_ROOT
       echo To be impure, please Run 'mkdir ~/.pyenv-nix' and add 'export PYENV_ROOT=$HOME/.pyenv-nix' to your profile
    '';
  }
