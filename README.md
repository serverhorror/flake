# nix

<div style="border: 5px solid red;">
ARCHIVED
</div>

* <https://nixos.org/manual/nixpkgs/unstable/>

## Configuration

Enable the `nix` command and `flakes` (e.g. `nix flake show`)

* `~/.config/nix/nix.conf`
* `/etc/nix/nix.conf`

    ```bash
    echo "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf
    ```

> ### If on WSL
>
> put the following in `/etc/wsl.conf`
>
> ```text
> [boot]
> systemd = true
>
> # ...(more lines here)...
> ```

## Bootstrap Nix

```text
sudo dnf install --assumeyes --quiet git
sh <(curl -L https://nixos.org/nix/install) --daemon
mkdir --parent ~/.config/nix
echo "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf
exec bash
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install
source $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh
home-manager --version
home-manager switch -b "bak$((RANDOM))" --flake .
```

### Update the flake

```text
nix flake update --flake .
home-manager switch -b '' --flake .
```

## Other Info

* Create a new flake

    ```bash
    nix --extra-experimental-features 'nix-command flakes' flake init
    ```
* "Develop"
  Enters a new shell based on `devShells.x86_64-linux.default`

    ```bash
    nix  --extra-experimental-features 'nix-command flakes' develop
    ```


* Do it!
  This requires a program/package to be runable

    ```bash
    nix  --extra-experimental-features 'nix-command flakes' run
    ```

### Random commands

```bash
nix --extra-experimental-features 'nix-command flakes' flake check
nix --extra-experimental-features 'nix-command flakes' flake
nix --extra-experimental-features 'nix-command flakes' flake info
nix --extra-experimental-features 'nix-command flakes' develop
nix --extra-experimental-features 'nix-command flakes' run
nix --extra-experimental-features 'nix-command flakes' build
nix --extra-experimental-features 'nix-command flakes' shell
```
