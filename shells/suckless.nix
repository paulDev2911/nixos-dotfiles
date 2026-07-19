{ pkgs, pkgs-unstable }:

pkgs.mkShell {
  packages = with pkgs; [
    pkg-config
    xorg.libX11
    xorg.libXft
    xorg.libXinerama
    fontconfig
    freetype
    harfbuzz
    gcc
    gnumake
  ];
}
