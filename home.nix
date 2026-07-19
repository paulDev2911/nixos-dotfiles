{ config, pkgs, lib, ... }:

let
  dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
  configs = {
    nvim = "nvim";
  };

  direnvMap = {
    "htb" = "pentest";
#    "code/opentofu-IaC" = "iac";
#    "code/ansible-opnsense" = "iac";
#    "code/k8s-IaC" = "iac";
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
