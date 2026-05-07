{ pkgs, ...}:

{
  programs.git = {
    enable = true;
    settings = {
      user.Name = "paulDev2911";
      user.Email = "ph24311@tutamail.com";
    };
  };
}
