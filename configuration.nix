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
  boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest;

  # Nix Settings
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.substituters = [ "https://cache.nixos.org/" "https://attic.xuyh0120.win/lantian" ];
  nix.settings.trusted-public-keys = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc=" ];
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    inputs.nix-cachyos-kernel.overlays.pinned
    (final: prev: {
      app2unit = prev.app2unit.overrideAttrs (oldAttrs: {
        version = "1.0.3";
        src = prev.fetchFromGitHub {
          owner = "Vladimir-csp";
          repo = "app2unit";
          rev = "v1.0.3";
          hash = "sha256-7eEVjgs+8k+/NLteSBKgn4gPaPLHC+3Uzlmz6XB0930=";
        };
        postFixup = ''
          substituteInPlace $out/bin/app2unit \
            --replace-fail '#!/bin/sh' '#!${final.lib.getExe final.dash}'
          substituteInPlace $out/bin/app2unit \
            --replace-fail 'TERMINAL_HANDLER=xdg-terminal-exec' \
                           'TERMINAL_HANDLER=${final.lib.getExe final.xdg-terminal-exec}'
        '';
      });
    })
  ];

  # State Version (DO NOT CHANGE)
  system.stateVersion = "25.11";

  # ============================================================================
  # HARDWARE & DRIVERS
  # ============================================================================

  # Graphics / NVIDIA
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;
  services.xserver.videoDrivers = [ "nvidia" "amdgpu" ];
  
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };

  # Asus & Power Management
  services.logind.settings.Login.HandleLidSwitch = "suspend";
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

  # ============================================================================
  # DESKTOP ENVIRONMENT
  # ============================================================================

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  services.gvfs.enable = true;
  services.udisks2.enable = true;
  services.dbus.enable = true;
  programs.dconf.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [ 
      pkgs.xdg-desktop-portal-gtk 
    ];
    config.common.default = "*";
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
  };

  # ============================================================================
  # SPECIALISATIONS
  # ============================================================================

  specialisation = {
    Hyprland.configuration = {
      system.nixos.tags = [ "Hyprland" ];
      programs.hyprland = {
        enable = true;
        package = inputs.hyprland.packages.x86_64-linux.hyprland;
        portalPackage = inputs.hyprland.packages.x86_64-linux.xdg-desktop-portal-hyprland;
      };
      programs.gamescope.enable = true;
      programs.gamescope.capSysNice = true;
      services.hypridle.enable = true;
      environment.systemPackages = [
        pkgs.hyprpolkitagent
      ];
    };

    KDE.configuration = {
      system.nixos.tags = [ "KDE" ];
      services.xserver.enable = true;
      services.desktopManager.plasma6.enable = true;
      services.displayManager.defaultSession = "plasma";
      programs.gamescope.enable = true;
      programs.gamescope.capSysNice = true;
      
      # PRIME settings for hybrid graphics
      hardware.nvidia.prime = {
        offload.enable = pkgs.lib.mkForce true;
        offload.enableOffloadCmd = pkgs.lib.mkForce true;
        amdgpuBusId = "PCI:101:0:0"; # 0x65 is 101
        nvidiaBusId = "PCI:1:0:0";
      };
    };
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
    xdg-desktop-portal-gtk
    qt6.qtbase
    qt6.qtdeclarative
    kdePackages.qtwayland
    libsForQt5.qtwayland
    wireplumber
    gobject-introspection
    upower
    udisks
    pipewire
  ];


}
