# pyenv Nix Overlay (👹IMPURE🐍)

Setups up _all the things_ for you to do python dev, particularly for ML, and just use `pip` directly on nixos.

# When would I need this?

- For when you need to get stuff done and don't want to be faffing with your `default.nix` or `flake.nix` on a NixOS system
- This flake allows you to directly `pip intall` a whole bunch of python deps in nixos like a, filthy and impure, flakey monster.
- Typical runtime native dependencies for python ml projects get pulled in when you run `nix develop github:fiq/nix-pyenv-flake --impure`
- You can use `pyenv` without having to worry about identifying which `python3xxPackages.*` nix packages to install. 

Sometimes we need to be dirty and use our existing tool chain.

This is an (impure) nix flake and overlay so that you can use pyenv.

# Install

To use pyenv in nix:

```
nix develop github:fiq/nix-pyenv-flake --impure
```

Or clone and run `nix develop . --impure`

This will give you a new shell using the local derivation of pyenv.

Now go forth and be an impure pythonista.

# Python Downloads Folder (PYENV_ROOT)

In order to persist python versions, the flake will default your PYENV_ROOT (where python versions are stored)
to $HOME/.pyenv 

You may create an alternate pyenv by setting it before invoking the flake.

```
mkdir -p ~/.pyenv-other
export PYENV_ROOT=$HOME/.pyenv-other
nix develop . --impure

```

Change as appropriate.

