# ╔══════════════════════════════════════════╗
# ║      Vvamp’s NixOS Configuration         ║
# ╚══════════════════════════════════════════╝

{
  config,
  pkgs,
  inputs,
  ...
}:

{
  home.username = "vvamp";
  home.homeDirectory = "/home/vvamp";
  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    inputs.firefox.packages.${pkgs.system}.firefox-nightly-bin
    chromium
    atuin
    eza
    procs
    yazi # terminal filemanager
    fzf
    tree
    kitty
    # masterpdfeditor # more updated when I do it myself
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
    flameshot
    bat
    dust
    fd
    btop
    nodePackages.web-ext
    kicad
    localsend
    fritzing
    httptoolkit
    binutils
    imhex
    rustdesk
    radeontop
    liquidctl
    amdgpu_top
    dig
    tcpdump
    # carla
    easyeffects
    yabridge
    yabridgectl
    wineWowPackages.stable
    qalculate-qt
    onlyoffice-desktopeditors
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
    interactiveShellInit = ''
      atuin init fish | source
      fastfetch
    '';
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.atuin.enable = true;

  services.easyeffects.enable = true;
  services.flameshot = {
    enable = true;
    settings = {
      General = {
        showHelp = false;
        startupLaunch = true;
      };
    };
  };

}
