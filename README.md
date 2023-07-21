# pyenv Nix Overlay (IMPURE)

Sometimes we need to be dirty and use our existing tool chain.

This is an (impure) nix flake and overlay so that you can use pyenv.

# Install

To use pyenv in nix:


`nix develop . --impure`

This will give you a new shell using the local derivation of pyenv.

In order to persist python versions, you must set the following environmentals in your shell.

```
mkdir -p ~/.pyenv
export PYENV_ROOT=$HOME/.pyenv

```

Change as appropriate.

Now go forth and be an impure pythonista.
