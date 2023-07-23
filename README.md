# pyenv Nix Overlay (👹IMPURE🐍)

Sometimes we need to be dirty and use our existing tool chain.

This is an (impure) nix flake and overlay so that you can use pyenv.

# Install

To use pyenv in nix:


`nix develop . --impure`

This will give you a new shell using the local derivation of pyenv.

In order to persist python versions, the flake will default your PYENV_ROOT (where python versions are stored)
to $HOME/.pyenv 

You may create an alternate pyenv by setting it before invoking the flake.

```
mkdir -p ~/.pyenv-other
export PYENV_ROOT=$HOME/.pyenv-other
nix develop . --impure

```

Change as appropriate.

Now go forth and be an impure pythonista.
