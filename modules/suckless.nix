{pkgs, ...}:

{
  home.packages = with pkgs; [
    (pkgs.st.overrideAttrs (_: {
      src = ../config/st;
      patches = [ ];
    }))
    (pkgs.dmenu.overrideAttrs (_: {
      src = ../config/dmenu;
      patches = [ ];
    }))
    (pkgs.slstatus.overrideAttrs (_: {
      src = ../config/slstatus;
    }))
    (pkgs.tabbed.overrideAttrs (_: {
      src = ../config/tabbed;
    }))
    #(pkgs.scroll.overrideAttrs (_: {
    #  src = ../config/scroll;
    #}))
    slock
    #surf
  ];
}

