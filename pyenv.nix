{
  pkgs ? import (fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/refs/tags/23.05.tar.gz";
    sha256 = "10wn0l08j9lgqcw8177nh2ljrnxdrpri7bp0g7nvrsn9rkawvlbf";
  }) {}
}:
let 
  pyenvRepo = builtins.fetchGit{
    "url" =  "https://github.com/pyenv/pyenv";
    "rev" = "b81204c08bf8ef8ab2ea0daeb721ee08020a26a0";
#    "sha256" = "12h96h2fz805r02z4nal4hbasjf8cbbdq7bawbxcvl5pf1g9rwhk";
  };
in
  pkgs.stdenv.mkDerivation rec {
    pname = "pyenv";
    version = "2.3.22";
    src = pyenvRepo;    
    nativeBuildInputs = [pkgs.bats pkgs.git zlib];
    dontConfigure = true;
    dontBuild = true;
    installPhase = ''
       mkdir -p $out
       # Copy clone to $out
       cp -r ${pyenvRepo.outPath}/* $out
       
       # Remind the user to set PYENV_ROOT
       echo To be impure, please Run 'mkdir ~/.pyenv-nix' and add 'export PYENV_ROOT=$HOME/.pyenv-nix' to your profile
    '';
  }
