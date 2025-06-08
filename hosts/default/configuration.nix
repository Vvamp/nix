# ╔══════════════════════════════════════════╗
# ║      Vvamp’s NixOS Configuration         ║
# ╚══════════════════════════════════════════╝
{ config, pkgs, lib, ... }:

{
  imports = [
    ../../hardware/hardware-configuration.nix
  ];

  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # Bootloader & Kernel
  boot = {
    # Use the GRUB 2 boot loader.
    loader.grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
      darkmatter-theme = {
        enable = true;
        style = "nixos";
        icon = "color";
        resolution = "1080p";
      };
    };
    loader.efi.canTouchEfiVariables = true;
    loader.efi.efiSysMountPoint = "/boot"; 
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = ["quiet" "splash" "udev.log_level=3"];
    # Quiet boot
    consoleLogLevel = 0;
    initrd.verbose = false;
};


  # System-wide packages
  environment.systemPackages = with pkgs; [
    git
    vim
    neovim
    wget
    jq# JSON Parser (used mainly in pipeconfig bash scripts)
    mangohud
    libnotify # notify-send etc
    pciutils # Lspci etc
    python3
    python3Packages.pynvim
    lua
    luarocks
    nodejs
    wayland-utils
    wl-clipboard
    tealdeer
    mesa-demos # GLXGears etc
    ffmpeg-full
    ghidra
    jdk21
    ltrace
    libgcc
    file
    unp
    gnumake
    pandoc
    screen
    ncdu
    p7zip
    unrar
    ripgrep
  ];

  # User setup
  users.users.vvamp = {
    isNormalUser = true;
    description = "Vvamp";
    shell = pkgs.fish;
    extraGroups = [ "networkmanager" "wheel" "dialout" ];
  };
  programs.fish.enable = true;

  # Hostname, Networking & Locale
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
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

  # Keyboard layout
  services.xserver.xkb = {
    layout = "us";
    options = "eurosign:e,caps:escape";
  };

  # X11 / Wayland & Desktop
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  # services.displayManager.autoLogin = {
  #   enable = true;
  #   user = "vvamp";
  # };
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    konsole
    elisa
    spectacle
  ];

  # Audio (PipeWire)
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  security.rtkit.enable = true;

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # Printing
  services.printing.enable = true;

  # Flatpak
  services.flatpak.enable = true;

  # Steam & Gamescope
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
  programs.gamescope.enable = true;
  programs.gamescope.capSysNice = true;

  # SSH
  services.openssh = {
    enable = true;
    ports = [ 1616 ];
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };


  # Environment variables
  environment.sessionVariables = {
    GDK_BACKEND = "wayland,x11";
    QT_QPA_PLATFORM = "wayland;xcb";
    CLUTTER_BACKEND = "wayland";
    XDG_SESSION_TYPE = "wayland";
    WLR_NO_HARDWARE_CURSORS = "1";
    ENABLE_VKBASALT = "1";
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
    XDG_DATA_DIRS = lib.mkBefore [
      "/var/lib/flatpak/exports/share"
      "/home/vvamp/.local/share/flatpak/exports/share"
    ];
  };

  # Security
  security.sudo.wheelNeedsPassword = false;
  security.pam.services.login.enableKwallet = true;
  security.pam.services.sddm.enableKwallet = true;

  # Nix-ld support
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    cups freetype sane-backends pkcs11helper qt5.qtsvg qt5.qtbase
    qt5.qtdeclarative qt5.qtquickcontrols qt5.qttools
    mesa libglvnd xorg.libxcb xorg.libX11 libxkbcommon qt5.qtbase.dev
  ];

  # GPU
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # System state version
  system.stateVersion = "25.05";
}
