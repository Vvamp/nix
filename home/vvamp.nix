# ╔══════════════════════════════════════════╗
# ║      Vvamp’s NixOS Configuration         ║
# ╚══════════════════════════════════════════╝

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
    speedtest-cli
    mpv
    vscode
    arduino-ide
    firefox
  ];

  programs.git = {
    enable = true;
    userName = "Vvamp";
    userEmail = "vvampus@gmail.com";
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
