{ config, pkgs, ...}:

{
  virtualisation.libvirtd.enable = true;
  users.users.user.extraGroups = [ "libvirtd" "kvm" ];
  programs.virt-manager.enable = true;

  environment.systemPackages = with pkgs; [
    qemu
    libvirt
    pkg-config
    virt-viewer
    virt-manager
  ];
}
