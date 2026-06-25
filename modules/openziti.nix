{ config, pkgs, ... }:

{
  # Ziti Edge Tunnel – Client für OpenZiti (Äquivalent zur Mobile/Desktop Edge App)
  programs.ziti-edge-tunnel = {
    enable = true;
    service.enable = true;
  };
}
