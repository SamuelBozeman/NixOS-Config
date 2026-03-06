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

  # Bootloader
  boot.loader.systemd-boot.enable = true;
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
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.latest;
  };

  # Asus & Power Management
  services.supergfxd.enable = true;
  services.asusd.enable = true;
  services.upower.enable = true;

  # ============================================================================
  # NETWORKING & LOCALIZATION
  # ============================================================================

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  services.zerotierone.enable = true;
  services.mullvad-vpn.enable = true;

  # Trust ZeroTier interfaces so traffic inside the VPN isn't blocked
  # (The UDP port 9993 for the tunnel itself is opened automatically)
  networking.firewall.trustedInterfaces = [ "zt*" ];
  networking.firewall.checkReversePath = "loose";

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
    extraGroups = [ "networkmanager" "wheel" "video" ]; # Added video for brightnessctl
    packages = with pkgs; [];
  };

  # Shell Configuration
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;
  
  programs.fish.shellAliases = {
    rebuild = "sudo nixos-rebuild switch --flake /etc/nixos";
  };

  # ============================================================================
  # DESKTOP ENVIRONMENT
  # ============================================================================

  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = [ 
      pkgs.xdg-desktop-portal-gtk 
      pkgs.xdg-desktop-portal-hyprland
    ];
  };

  programs.hyprland.enable = true;

  environment.sessionVariables = {
    CAELESTIA_WALLPAPERS_DIR = "/home/meterra/Pictures/Wallpapers";
  };
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  # ============================================================================
  # GAMING
  # ============================================================================

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  # ============================================================================
  # VIRTUALIZATION
  # ============================================================================

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  # ============================================================================
  # SYSTEM PACKAGES
  # ============================================================================

  # flatpak
  services.flatpak.enable = true;
  
  environment.systemPackages = with pkgs; [
    distrobox
    # --- Desktop / Window Manager ---
    hyprpicker
    hypridle
    xdg-desktop-portal-hyprland
    xdg-desktop-portal-gtk
    wl-clipboard
    cliphist
    nwg-displays
    nwg-look
    grim
    slurp

    # --- Terminal & Shell ---
    kitty
    foot
    fish
    starship
    fastfetch
    btop
    jq
    socat
    yt-dlp

    # --- Development ---
    git
    vscodium
    jetbrains.idea-oss
    gemini-cli-bin
    matugen
    inotify-tools
    app2unit
    python3

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

    # --- File Management & Utilities ---
    nautilus
    trash-cli
    xdg-utils
    wget
    curl
    imagemagick
    ffmpeg
    flac
    lmstudio

    # --- Media & System Utilities ---
    spotify
    wireplumber
    bluez
    bluez-tools
    upower
    brightnessctl
    jellyfin-desktop

    # --- Gaming ---
    protonplus

    # --- Theming & Fonts ---
    adw-gtk3
    papirus-icon-theme
    kdePackages.qt6ct
    libsForQt5.qt5ct
    nerd-fonts.jetbrains-mono
    inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default
  ];

}
