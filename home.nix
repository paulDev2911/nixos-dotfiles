{ config, pkgs, lib, ... }:

let
  dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
  configs = {
    nvim = "nvim";
  };

  direnvMap = {
    "htb" = "pentest";
    # "code/opentofu-IaC" = "iac";
    # "code/ansible-opnsense" = "iac";
    # "code/k8s-IaC" = "iac";
  };
in

{
  imports = [
    ./modules/neovim.nix
    ./modules/suckless.nix
    ./modules/git.nix
    ./modules/bash.nix
    ./modules/dev.nix
  ];

  home.username = "user";
  home.homeDirectory = "/home/user";
  programs.git.enable = true;
  home.stateVersion = "25.05";
  programs.bash = {
    enable = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableBashIntegration = true;
  };

  home.file = lib.mapAttrs' (dir: shell:
    lib.nameValuePair "${dir}/.envrc" {
      text = "use flake ~/nixos-dotfiles#${shell}\n";
    }
  ) direnvMap;

  home.activation.direnvAllow = lib.hm.dag.entryAfter ["writeBoundary"] ''
    DOTFILES="$HOME/nixos-dotfiles"
    HASHFILE="$HOME/.cache/direnv-shells.sha256"
    mkdir -p "$HOME/.cache"

    CURRENT_HASH=$(${pkgs.coreutils}/bin/cat "$DOTFILES"/shells/*.nix 2>/dev/null | ${pkgs.coreutils}/bin/sha256sum | ${pkgs.coreutils}/bin/cut -d' ' -f1)
    STORED_HASH=""
    [ -f "$HASHFILE" ] && STORED_HASH=$(${pkgs.coreutils}/bin/cat "$HASHFILE")

    if [ "$CURRENT_HASH" = "$STORED_HASH" ]; then
      ${lib.concatMapStringsSep "\n" (dir:
        ''$DRY_RUN_CMD ${pkgs.direnv}/bin/direnv allow "$HOME/${dir}" 2>/dev/null || true''
      ) (builtins.attrNames direnvMap)}
    else
      echo ""
      echo "shells/*.nix haben sich seit dem letzten Review geändert!"
      echo "Prüfe den Diff, dann bestätige manuell mit:"
      echo "echo -n \"$CURRENT_HASH\" > $HASHFILE"
      echo "und führe 'direnv allow' in den betroffenen Verzeichnissen aus."
      echo ""
    fi
  '';

  xsession = {
    enable = true;
    initExtra = ''
      ${pkgs.slstatus.override { conf = builtins.readFile ./config/slstatus/config.h; }}/bin/slstatus &
    '';
  };

  xdg.configFile = builtins.mapAttrs 
    (name: subpath: {
      source = create_symlink "${dotfiles}/${subpath}";
      recursive = true;
    })
    configs;

  home.packages = with pkgs; [
    gcc
  ];
}
