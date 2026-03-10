# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  # ============================================================================
  # SYSTEM CORE
  # ============================================================================
  
  imports = [ 
    ./hardware-configuration.nix
  ];

  boot.loader.limine = {
    enable = true;
    style.wallpapers = [ ];

    extraConfig = ''
      term_palette: 191724;eb6f92;9ccfd8;f6c177;31748f;c4a7e7;ebbcba;e0def4;26233a;eb6f92;9ccfd8;f6c177;31748f;c4a7e7;ebbcba;e0def4
      term_background: 191724
      term_foreground: e0def4
      backdrop: 191724
      
      # Optional: Set this to 0 if you want the terminal text to stretch edge-to-edge
      # term_margin: 0 
    '';
  };
  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.plymouth.enable = true;
  boot.consoleLogLevel = 0;
  boot.initrd.verbose = false;
  boot.kernelParams = [ "quiet" "splash" "boot.shell_on_fail" "loglevel=3" "rd.systemd.show_status=false" "rd.udev.log_level=3" "udev.log_priority=3" ];

  # Kernel
  boot.kernelPackages = pkgs.linuxPackages_6_18;

  # Nix Settings
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  # State Version (DO NOT CHANGE)
  system.stateVersion = "25.11";

  # ============================================================================
  # HARDWARE & DRIVERS
  # ============================================================================

  # Graphics / NVIDIA
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };

  # Asus & Power Management
  services.logind.lidSwitch = "suspend";
  services.supergfxd.enable = true;
  services.asusd.enable = true;
  services.udev.extraRules = ''
    KERNEL=="card*", KERNELS=="0000:01:00.0", SUBSYSTEM=="drm", SUBSYSTEMS=="pci", SYMLINK+="dri/nvidia-gpu"
    KERNEL=="card*", KERNELS=="0000:65:00.0", SUBSYSTEM=="drm", SUBSYSTEMS=="pci", SYMLINK+="dri/amd-igpu"
  '';
  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;
  hardware.i2c.enable = true;

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  hardware.bluetooth.settings = {
    General = {
      Experimental = true; # Often helps with modern BLE devices
    };
  };
  services.blueman.enable = true;

  # ============================================================================
  # NETWORKING & LOCALIZATION
  # ============================================================================

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];
  services.geoclue2.enable = true;
  services.zerotierone.enable = true;
  services.mullvad-vpn.enable = true;

  # Trust ZeroTier interfaces so traffic inside the VPN isn't blocked
  networking.firewall.enable = true;
  networking.firewall.trustedInterfaces = [ "zt*" ];
  networking.firewall.checkReversePath = "loose";
  networking.firewall.allowedUDPPortRanges = [
    { from = 50000; to = 65535; }
  ];

  time.timeZone = "America/Chicago";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # ============================================================================
  # USER ACCOUNTS & SHELL
  # ============================================================================

  users.users.meterra = {
    isNormalUser = true;
    description = "meterra";
    extraGroups = [ "networkmanager" "wheel" "video" "i2c" ];
    packages = with pkgs; [];
  };

  # PAM Configuration for Caelestia Shell
  security.pam.services.caelestia-shell = {};
  security.polkit.enable = true;

  # Shell Configuration
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;
  
  programs.fish.shellAliases = {
    rebuild = "sudo nixos-rebuild switch --flake ~/nixos-config";
  };

  # ============================================================================
  # DESKTOP ENVIRONMENT
  # ============================================================================

  services.gvfs.enable = true;
  services.udisks2.enable = true;
  services.dbus.enable = true;
  programs.dconf.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = [ 
      pkgs.xdg-desktop-portal-gtk 
      pkgs.xdg-desktop-portal-hyprland
    ];
    config.common.default = "*";
  };

  programs.hyprland.enable = true;
  services.hypridle.enable = true;

  programs.java = {
    enable = true;
    package = pkgs.jdk21;
  };

  # Sound
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  environment.sessionVariables = {
    CAELESTIA_WALLPAPERS_DIR = "/home/meterra/Pictures/Wallpapers";
    NIXOS_OZONE_WL = "1";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    LIBVA_DRIVER_NAME = "nvidia";
  };

  # ============================================================================
  # GAMING
  # ============================================================================

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  # ============================================================================
  # VIRTUALIZATION
  # ============================================================================

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  # ============================================================================
  # FONTS
  # ============================================================================

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.caskaydia-cove
    material-symbols
  ];

  # ============================================================================
  # SYSTEM PACKAGES
  # ============================================================================

  # kde connect
  programs.kdeconnect.enable = true;
  
  # flatpak
  services.flatpak.enable = true;
  
  environment.systemPackages = with pkgs; [
    distrobox
    # --- Desktop / Window Manager ---
    hyprpicker
    hypridle
    hyprpolkitagent
    xdg-desktop-portal-hyprland
    xdg-desktop-portal-gtk
    wl-clipboard
    cliphist
    nwg-displays
    nwg-look
    grim
    slurp
    quickshell
    qt6.qtbase
    qt6.qtdeclarative
    kdePackages.qtwayland
    libsForQt5.qtwayland
    wireplumber
    libpulseaudio
    gobject-introspection
    upower

    # --- Terminal & Shell ---
    kitty
    foot
    fish
    starship
    fastfetch
    btop
    nvtopPackages.full
    jq
    socat
    yt-dlp
    cmake
    ninja
    pkg-config

    # --- Development ---
    git
    vscodium
    jetbrains.idea-oss
    jdk21
    gemini-cli-bin
    matugen
    inotify-tools
    app2unit
    python3
    swappy

    # --- Cybersecurity ---
    ghidra-bin
    exiftool
    hashcat
    cudaPackages.cudatoolkit
    nmap
    wireshark
    burpsuite
    metasploit
    john
    sqlmap
    thc-hydra
    aircrack-ng
    binwalk
    gobuster

    # --- Internet & Communication ---
    firefox
    vesktop
    obsidian
    mullvad-vpn
    libreoffice-qt

    # --- File Management & Utilities ---
    nautilus
    trash-cli
    xdg-utils
    wget
    udisks
    ntfs3g
    dosfstools
    curl
    imagemagick
    ffmpeg
    flac
    lmstudio
    libqalculate

    # --- Media & System Utilities ---
    vlc
    feishin
    kdePackages.gwenview
    spotify
    bluez
    bluez-tools
    brightnessctl
    ddcutil
    pipewire
    lm_sensors
    cava
    aubio
    jellyfin-desktop
    sshfs
    qbittorrent
    spotdl
    spotify

    # --- Gaming ---
    eden
    protonplus
    mangohud
    lutris
    heroic

    # --- Theming & Fonts ---
    adw-gtk3
    papirus-icon-theme
    kdePackages.qt6ct
    libsForQt5.qt5ct
    inputs.rose-pine-hyprcursor.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];


}
