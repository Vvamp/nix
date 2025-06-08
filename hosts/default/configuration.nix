##############################
#			     #
# Vvamp NixOs Configuration  #
#			     #
##############################
{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # NixOS Settings
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = ["nix-command" "flakes"];

  programs.nix-ld.enable = true;
   programs.nix-ld.libraries = [
    pkgs.cups
        pkgs.freetype
	    pkgs.sane-backends
	        pkgs.pkcs11helper
		    pkgs.qt5.qtsvg
		        pkgs.qt5.qtbase
  pkgs.qt5.qtdeclarative  # includes QtQml
  pkgs.qt5.qtquickcontrols
  pkgs.qt5.qttools
  pkgs.mesa
  pkgs.libglvnd
  pkgs.xorg.libxcb
  pkgs.xorg.libX11
  pkgs.libxkbcommon
	pkgs.qt5.qtbase.dev
  ];
  ## GPU
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;  # Use latest kernel.

  # Networking
  networking.hostName = "nixos";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;

  ## Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true; 


  # Locale
  time.timeZone = "Europe/Amsterdam";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "nl_NL.UTF-8";
    LC_IDENTIFICATION = "nl_NL.UTF-8";
    LC_MEASUREMENT = "nl_NL.UTF-8";
    LC_MONETARY = "nl_NL.UTF-8";
    LC_NAME = "nl_NL.UTF-8";
    LC_NUMERIC = "nl_NL.UTF-8";
    LC_PAPER = "nl_NL.UTF-8";
    LC_TELEPHONE = "nl_NL.UTF-8";
    LC_TIME = "nl_NL.UTF-8";
  };

  # Keymaps
  services.xserver.xkb = {
    layout = "us";
    variant = "";
    options = "eurosign:e,caps:escape";
  };

  # Users
  users.users.vvamp = {
    isNormalUser = true;
    shell = pkgs.fish;
    description = "Vvamp";
    extraGroups = [ "networkmanager" "wheel" "dialout" ];
    packages = with pkgs; [
      tree
      kitty
      masterpdfeditor
      discord
      btop
      fastfetch
      stremio
      jetbrains.idea-ultimate
      qpwgraph
      hyperfine # Benchmark tool
    ];
   
  };

  ## Enable automatic login for the user.
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "vvamp";


  # System Packages
  ## List packages installed in system profile. To search, run:
  ## $ nix search wget
  environment.systemPackages = with pkgs; [
    git
  	neovim
    vim
  	wget
	  vscode
    jq # JSON Parser (used mainly in pipeconfig bash scripts)
    mangohud
    bat 
    libnotify # notify-send etc
    pciutils # Lspci etc
    lact # GPU Control software
    speedtest-cli
    python3
    python3Packages.pynvim
    lua
    luarocks
    nodejs
    wayland-utils # Wayland utilities
    wl-clipboard # Command-line copy/paste utilities for Wayland
    tealdeer
    mesa-demos # GLXGears etc
    ffmpeg-full
    mpv
    ghidra
    arduino-ide
    jdk21
    ltrace
    libgcc 
    file
    unp
    gnumake
    fzf
    pandoc
    screen
    ncdu
    fd
    dust
    p7zip
    unrar
    eza
    procs
    atuin
    yazi
    ripgrep

  ];

  ## DE/Windowing
  services.xserver.enable = true; # As fallback

  # Enable the KDE Plasma
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    konsole
    elisa
    spectacle
  ];

  ## Misc
  programs.firefox.enable = true;
  programs.dconf.enable = true; # Fix for gtk themes for wayland (nixos.wiki/wiki/KDE)
  programs.zoxide.enable = true;
  programs.zoxide.enableFishIntegration= true;

  programs.fish = {
  	enable = true;
	shellAliases = {
		ps = "procs";
		ls = "eza";
		find  = "fd";
		du = "dust";
		cat = "bat";

	};

  };

  ## Steam
  programs.steam = {
	  enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    gamescopeSession.enable = false;
    package = pkgs.steam.override {
      extraPkgs = pkgs: with pkgs; [
        xorg.libXcursor
        xorg.libXi
        xorg.libXinerama
        xorg.libXScrnSaver
        libpng
        libpulseaudio
        libvorbis
        stdenv.cc.cc.lib
        libkrb5
        keyutils
      ];
    };
  };
  programs.gamemode.enable = true;

  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  ## Printing
  services.printing.enable = true;

  ## Sound
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

  };

  ## Flatpak
  services.flatpak.enable = true;

  # Environment
 environment.sessionVariables = {
    GDK_BACKEND = "wayland,x11";
    QT_QPA_PLATFORM = "wayland;xcb";
    #SDL_VIDEODRIVER = "x11";
    CLUTTER_BACKEND = "wayland";
    XDG_SESSION_TYPE = "wayland";
    WLR_NO_HARDWARE_CURSORS = "1";
    XDG_DATA_DIRS = lib.mkBefore [
      "/var/lib/flatpak/exports/share"
      "/home/vvamp/.local/share/flatpak/exports/share"
    ];
    XDG_CACHE_HOME  = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME   = "$HOME/.local/share";
    XDG_STATE_HOME  = "$HOME/.local/state";
    ENABLE_VKBASALT = 1;

  };



  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Services
   services.openssh = {
    enable = true;
    ports = [ 1616 ];
    settings.PermitRootLogin = "no"; # optional but recommended
    settings.PasswordAuthentication = false; # disables password login
  };

  ## Systemd
  systemd.packages = with pkgs; [ lact ];
  systemd.services.lactd.wantedBy = ["multi-user.target"];

  # Firewall
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;


  # Security
  security.sudo.wheelNeedsPassword = false;
  security.pam.services.login.enableKwallet = true;
  security.pam.services.sddm.enableKwallet = true;



  system.stateVersion = "25.05"; # @VVAMP DO NOT CHANGE!
}
