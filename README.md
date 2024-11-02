# nix

* <https://nixos.org/manual/nixpkgs/unstable/>

## Configuration

Enable the `nix` command and `flakes` (e.g. `nix flake show`)

* `~/.config/nix/nix.conf`
* `/etc/nix/nix.conf`

    ```text
    experimental-features = nix-command flakes
    ```

## Installation

* Create a new flake

    ```bash
    nix --extra-experimental-features 'nix-command flakes' flake init
    ```

* Do it!

    ```bash
    nix  --extra-experimental-features 'nix-command flakes' run
    ```

## Random commands

```bash
nix --extra-experimental-features 'nix-command flakes' flake check
nix --extra-experimental-features 'nix-command flakes' flake
nix --extra-experimental-features 'nix-command flakes' flake info
nix --extra-experimental-features 'nix-command flakes' develop
nix --extra-experimental-features 'nix-command flakes' run
nix --extra-experimental-features 'nix-command flakes' build
nix --extra-experimental-features 'nix-command flakes' shell
```
