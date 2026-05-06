{ pkgs, ...}:

{
  home.packages = with pkgs; [
    # C#
    dotnet-sdk
    omnisharp-roslyn

    # C
    gdb
    clang-tools

    # python
    python3
    python3Packages.pip
    pyright
  ];
}
