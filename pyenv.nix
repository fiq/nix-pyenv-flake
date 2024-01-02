{
  pkgs ? import (fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/refs/tags/23.05.tar.gz";
    sha256 = "10wn0l08j9lgqcw8177nh2ljrnxdrpri7bp0g7nvrsn9rkawvlbf";
  }) {}
}:
let 
  pyenvRepo = builtins.fetchTarball{
    "url" =  "https://github.com/pyenv/pyenv/archive/refs/tags/v2.3.35.tar.gz";
    "sha256" = "1vkcc52sy4w6b1iraz894104ch45q7g6qz2br10yj2fq5i2wgm5l";
  };
in
  pkgs.stdenv.mkDerivation rec {
    pname = "pyenv";
    version = "2.3.35";
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
