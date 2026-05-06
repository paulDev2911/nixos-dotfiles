{ config, pkgs, ... }:

let
  dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
  configs = {
    nvim = "nvim";
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
