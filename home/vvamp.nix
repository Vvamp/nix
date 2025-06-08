{ config, pkgs, ... }:

{
  home.username = "vvamp";
  home.homeDirectory = "/home/vvamp";
  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    atuin
    eza
    procs
    yazi
    fzf
    tree
    kitty
    masterpdfeditor
    discord
    fastfetch
    stremio
    jetbrains.idea-ultimate
    qpwgraph
    hyperfine
  ];

  programs.git = {
    enable = true;
    userName = "Vvamp";
    userEmail = "your@email.com";
  };

  programs.fish = {
    enable = true;
    shellAliases = {
      ps = "procs";
      ls = "eza";
      find = "fd";
      du = "dust";
      cat = "bat";
    };
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.atuin.enable = true;
}
