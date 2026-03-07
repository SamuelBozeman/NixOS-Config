{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hyprland.nix
  ];

  home.username = "meterra";
  home.homeDirectory = "/home/meterra";

  # State version for Home Manager
  home.stateVersion = "25.11";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # ----------------------------------------------------------------------------
  # PROGRAMS
  # ----------------------------------------------------------------------------

  programs.home-manager.enable = true;

  # Terminal & Shell
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set -g fish_greeting ""
      cat ~/.local/state/caelestia/sequences.txt 2> /dev/null
    '';
    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake ~/nixos-config";
    };
  };

  programs.starship = {
    enable = true;
    # Using default settings since you mentioned it's not configured yet
  };

  programs.kitty = {
    enable = true;
    # Add basic config or keep defaults
    settings = {
      confirm_os_window_close = 0;
      dynamic_background_opacity = true;
      enable_audio_bell = false;
      mouse_hide_wait = "-1.0";
      window_padding_width = 10;
    };
  };

  programs.btop = {
    enable = true;
    settings = {
      color_theme = "tokyo-night";
      theme_background = false;
      vim_keys = true;
    };
  };

  programs.ssh = {
    enable = true;
    matchBlocks = {
      "river-server" = {
        hostname = "10.99.186.147";
        user = "meterra";
        port = 1215;
        identityFile = "~/.ssh/id_ed25519";
      };
    };
  };

  programs.fastfetch = {
    enable = true;
    settings = {
      "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json";
      logo = {
        type = "auto";
        width = 8;
        height = 1;
      };
      display = {
        separator = "  ";
      };
      modules = [
        "break"
        "break"
        {
          key = "╭───────────╮";
          keyColor = "white";
          type = "custom";
        }
        {
          key = "│ {#31} user    {#white}│";
          keyColor = "white";
          type = "title";
          format = "{user-name}";
        }
        {
          key = "│ {#32}󰇅 hname   {#white}│";
          keyColor = "white";
          type = "title";
          format = "{host-name}";
        }
        {
          key = "│ {#33}󰅐 uptime  {#white}│";
          keyColor = "white";
          type = "uptime";
        }
        {
          key = "│ {#34}{icon} distro  {#white}│";
          keyColor = "white";
          type = "os";
        }
        {
          key = "│ {#35} kernel  {#white}│";
          keyColor = "white";
          type = "kernel";
        }
        {
          key = "│ {#36}󰇄 desktop {#white}│";
          keyColor = "white";
          type = "de";
        }
        {
          key = "│ {#37}󰖲 wm      {#white}│";
          keyColor = "white";
          type = "wm";
        }
        {
          key = "│ {#31} term    {#white}│";
          keyColor = "white";
          type = "terminal";
        }
        {
          key = "│ {#32} shell   {#white}│";
          keyColor = "white";
          type = "shell";
        }
        {
          key = "│ {#33}󰍛 cpu     {#white}│";
          keyColor = "white";
          type = "cpu";
          showPeCoreCount = true;
        }
        {
          key = "│ {#34}󰉉 disk    {#white}│";
          keyColor = "white";
          type = "disk";
          folders = "/";
        }
        {
          key = "│ {#35} memory  {#white}│";
          keyColor = "white";
          type = "memory";
        }
        {
          key = "├───────────┤";
          keyColor = "white";
          type = "custom";
        }
        {
          key = "│ {#39} colors  │";
          keyColor = "white";
          type = "colors";
          symbol = "circle";
        }
        {
          key = "╰───────────╯";
          keyColor = "white";
          type = "custom";
        }
      ];
    };
  };

  # ----------------------------------------------------------------------------
  # XDG CONFIG FILES (Direct migration)
  # ----------------------------------------------------------------------------

  xdg.configFile."caelestia/shell.json".text = builtins.toJSON {
    appearance = {
      rounding.scale = 0.7511773871119474;
      spacing.scale = 0.3341695819614299;
      padding.scale = 0.7304779368532455;
      font = {
        family = {
          sans = "Rubik";
          mono = "CaskaydiaCove NF";
          material = "Material Symbols Rounded";
          clock = "Rubik";
        };
        size.scale = 1;
      };
      anim = {
        mediaGifSpeedAdjustment = 300;
        sessionGifSpeed = 0.7;
        durations.scale = 1;
      };
      transparency = {
        enabled = true;
        base = 0.85;
        layers = 0.4;
      };
    };
    general = {
      logo = "";
      apps = {
        terminal = [ "foot" ];
        audio = [ "pavucontrol" ];
        playback = [ "mpv" ];
        explorer = [ "thunar" ];
      };
      idle = {
        lockBeforeSleep = true;
        inhibitWhenAudio = true;
        timeouts = [
          { idleAction = "lock"; timeout = 180; }
          { idleAction = "dpms off"; returnAction = "dpms on"; timeout = 300; }
          { idleAction = [ "systemctl" "suspend-then-hibernate" ]; timeout = 600; }
        ];
      };
      battery = {
        warnLevels = [
          { icon = "battery_android_frame_2"; level = 20; message = "You might want to plug in a charger"; title = "Low battery"; }
          { icon = "battery_android_frame_1"; level = 10; message = "You should probably plug in a charger <b>now</b>"; title = "Did you see the previous message?"; }
          { critical = true; icon = "battery_android_alert"; level = 5; message = "PLUG THE CHARGER RIGHT NOW!!"; title = "Critical battery level"; }
        ];
        criticalLevel = 3;
      };
    };
    background = {
      enabled = true;
      wallpaperEnabled = true;
      desktopClock = {
        enabled = false;
        scale = 1;
        position = "bottom-right";
        invertColors = false;
        background = { enabled = false; opacity = 0.7; blur = true; };
        shadow = { enabled = true; opacity = 0.7; blur = 0.4; };
      };
      visualiser = { enabled = false; autoHide = true; blur = false; rounding = 1; spacing = 1; };
    };
    bar = {
      persistent = true;
      showOnHover = true;
      dragThreshold = 20;
      scrollActions = { workspaces = true; volume = true; brightness = true; };
      popouts = { activeWindow = true; tray = true; statusIcons = true; };
      workspaces = {
        shown = 5;
        activeIndicator = true;
        occupiedBg = false;
        showWindows = true;
        showWindowsOnSpecialWorkspaces = true;
        activeTrail = false;
        perMonitorWorkspaces = true;
        label = "  ";
        occupiedLabel = "󰮯";
        activeLabel = "󰮯";
        capitalisation = "preserve";
        specialWorkspaceIcons = [];
      };
      tray = { background = false; recolour = false; compact = false; iconSubs = []; };
      status = { showAudio = false; showMicrophone = false; showKbLayout = false; showNetwork = true; showWifi = true; showBluetooth = true; showBattery = true; showLockStatus = true; };
      clock.showIcon = true;
      sizes = { innerWidth = 40; windowPreviewSize = 400; trayMenuWidth = 300; batteryWidth = 250; networkWidth = 320; };
      entries = [
        { enabled = true; id = "logo"; }
        { enabled = true; id = "workspaces"; }
        { enabled = true; id = "spacer"; }
        { enabled = true; id = "activeWindow"; }
        { enabled = true; id = "spacer"; }
        { enabled = true; id = "tray"; }
        { enabled = true; id = "clock"; }
        { enabled = true; id = "statusIcons"; }
        { enabled = true; id = "power"; }
      ];
      excludedScreens = [];
    };
    border = { thickness = 3; rounding = 4; };
    dashboard = {
      enabled = true;
      showOnHover = true;
      dragThreshold = 50;
      performance = { showBattery = true; showGpu = true; showCpu = true; showMemory = true; showStorage = true; showNetwork = true; };
      sizes = {
        tabIndicatorHeight = 3;
        tabIndicatorSpacing = 5;
        infoWidth = 200;
        infoIconSize = 25;
        dateTimeWidth = 110;
        mediaWidth = 200;
        mediaProgressSweep = 180;
        mediaProgressThickness = 8;
        resourceProgessThickness = 10;
        weatherWidth = 250;
        mediaCoverArtSize = 150;
        mediaVisualiserSize = 80;
        resourceSize = 200;
      };
    };
    controlCenter.sizes = { heightMult = 0.7; ratio = 1.7777777777777777; };
    launcher = {
      enabled = true;
      showOnHover = false;
      maxShown = 7;
      maxWallpapers = 9;
      specialPrefix = "@";
      actionPrefix = ">";
      enableDangerousActions = false;
      dragThreshold = 50;
      vimKeybinds = false;
      favouriteApps = [];
      hiddenApps = [];
      useFuzzy = { apps = false; actions = false; schemes = false; variants = false; wallpapers = false; };
      sizes = { itemWidth = 600; itemHeight = 57; wallpaperWidth = 280; wallpaperHeight = 200; };
      actions = [
        { command = [ "autocomplete" "calc" ]; dangerous = false; description = "Do simple math equations (powered by Qalc)"; enabled = true; icon = "calculate"; name = "Calculator"; }
        { command = [ "autocomplete" "scheme" ]; dangerous = false; description = "Change the current colour scheme"; enabled = true; icon = "palette"; name = "Scheme"; }
        { command = [ "autocomplete" "wallpaper" ]; dangerous = false; description = "Change the current wallpaper"; enabled = true; icon = "image"; name = "Wallpaper"; }
        { command = [ "autocomplete" "variant" ]; dangerous = false; description = "Change the current scheme variant"; enabled = true; icon = "colors"; name = "Variant"; }
        { command = [ "autocomplete" "transparency" ]; dangerous = false; description = "Change shell transparency"; enabled = false; icon = "opacity"; name = "Transparency"; }
        { command = [ "caelestia" "wallpaper" "-r" ]; dangerous = false; description = "Switch to a random wallpaper"; enabled = true; icon = "casino"; name = "Random"; }
        { command = [ "setMode" "light" ]; dangerous = false; description = "Change the scheme to light mode"; enabled = true; icon = "light_mode"; name = "Light"; }
        { command = [ "setMode" "dark" ]; dangerous = false; description = "Change the scheme to dark mode"; enabled = true; icon = "dark_mode"; name = "Dark"; }
        { command = [ "systemctl" "poweroff" ]; dangerous = true; description = "Shutdown the system"; enabled = true; icon = "power_settings_new"; name = "Shutdown"; }
        { command = [ "systemctl" "reboot" ]; dangerous = true; description = "Reboot the system"; enabled = true; icon = "cached"; name = "Reboot"; }
        { command = [ "loginctl" "terminate-user" "" ]; dangerous = true; description = "Log out of the current session"; enabled = true; icon = "exit_to_app"; name = "Logout"; }
        { command = [ "loginctl" "lock-session" ]; dangerous = false; description = "Lock the current session"; enabled = true; icon = "lock"; name = "Lock"; }
        { command = [ "systemctl" "suspend-then-hibernate" ]; dangerous = false; description = "Suspend then hibernate"; enabled = true; icon = "bedtime"; name = "Sleep"; }
        { command = [ "caelestia" "shell" "controlCenter" "open" ]; dangerous = false; description = "Configure the shell"; enabled = true; icon = "settings"; name = "Settings"; }
      ];
    };
    notifs = {
      expire = true;
      defaultExpireTimeout = 5000;
      clearThreshold = 0.3;
      expandThreshold = 20;
      actionOnClick = false;
      groupPreviewNum = 3;
      sizes = { width = 400; image = 41; badge = 20; };
    };
    osd = {
      enabled = true;
      hideDelay = 2000;
      enableBrightness = true;
      enableMicrophone = false;
      sizes = { sliderWidth = 30; sliderHeight = 150; };
    };
    session = {
      enabled = true;
      dragThreshold = 30;
      vimKeybinds = false;
      icons = { logout = "logout"; shutdown = "power_settings_new"; hibernate = "downloading"; reboot = "cached"; };
      commands = {
        logout = [ "loginctl" "terminate-user" "" ];
        shutdown = [ "systemctl" "poweroff" ];
        hibernate = [ "systemctl" "hibernate" ];
        reboot = [ "systemctl" "reboot" ];
      };
      sizes.button = 80;
    };
    winfo.sizes = { heightMult = 0.7; detailsWidth = 500; };
    lock = {
      recolourLogo = false;
      enableFprint = true;
      maxFprintTries = 3;
      sizes = { heightMult = 0.7; ratio = 1.7777777777777777; centerWidth = 600; };
    };
    utilities = {
      enabled = true;
      maxToasts = 4;
      sizes = { width = 430; toastWidth = 430; };
      toasts = {
        configLoaded = true;
        chargingChanged = true;
        gameModeChanged = true;
        dndChanged = true;
        audioOutputChanged = true;
        audioInputChanged = true;
        capsLockChanged = true;
        numLockChanged = true;
        kbLayoutChanged = true;
        vpnChanged = true;
        nowPlaying = false;
      };
      vpn = { enabled = false; provider = [ "netbird" ]; };
    };
    sidebar = { enabled = true; dragThreshold = 80; sizes.width = 430; };
    services = {
      weatherLocation = "";
      useFahrenheit = true;
      useFahrenheitPerformance = true;
      useTwelveHourClock = true;
      gpuType = "";
      visualiserBars = 45;
      audioIncrement = 0.1;
      brightnessIncrement = 0.1;
      maxVolume = 1;
      smartScheme = true;
      defaultPlayer = "Spotify";
      playerAliases = [ { from = "com.github.th_ch.youtube_music"; to = "YT Music"; } ];
    };
    paths = {
      wallpaperDir = "/home/meterra/Pictures/Wallpapers";
      sessionGif = "root:/assets/kurukuru.gif";
      mediaGif = "root:/assets/bongocat.gif";
    };
  };

  # ----------------------------------------------------------------------------
  # PACKAGES
  # ----------------------------------------------------------------------------

  home.packages = with pkgs; [
    # Add user-specific packages here if you want to move them from configuration.nix
  ];
}
