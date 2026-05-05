{ config, pkgs, lib, ...}:

{

  home.packages = with pkgs; [
    ripgrep
    fd
    fzf

    lua-language-server
    nil
    nixpkgs-fmt

    nodejs
  ];

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };
}
