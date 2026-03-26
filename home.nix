{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hyprland.nix
    ./niri.nix
    inputs.spicetify-nix.homeManagerModules.default
    inputs.nixvim.homeModules.nixvim
  ];

  home.username = "meterra";
  home.homeDirectory = "/home/meterra";

  # State version for Home Manager
  home.stateVersion = "25.11";

  # ----------------------------------------------------------------------------
  # PROGRAMS
  # ----------------------------------------------------------------------------

  programs.home-manager.enable = true;

  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    opts = {
      number = true;
      relativenumber = true;
      shiftwidth = 2;
      tabstop = 2;
      expandtab = true;
      smartindent = true;
      wrap = false;
      ignorecase = true;
      smartcase = true;
      termguicolors = true;
      scrolloff = 8;
      signcolumn = "yes";
      updatetime = 50;
    };

    globals = {
      mapleader = " ";
    };

    colorschemes.rose-pine = {
      enable = true;
      settings.variant = "moon";
    };

    plugins = {
      lualine.enable = true;
      web-devicons.enable = true;
      telescope = {
        enable = true;
        keymaps = {
          "<leader>ff" = "find_files";
          "<leader>fg" = "live_grep";
          "<leader>fb" = "buffers";
        };
      };
      treesitter = {
        enable = true;
        settings.highlight.enable = true;
      };
      nvim-tree = {
        enable = true;
        openOnSetup = true;
      };
      lsp = {
        enable = true;
        servers = {
          nil_ls.enable = true;     # Nix
          lua_ls.enable = true;
          ts_ls.enable = true;   # TypeScript/JavaScript
          pyright.enable = true;    # Python
        };
      };
      cmp = {
        enable = true;
        settings = {
          sources = [
            { name = "nvim_lsp"; }
            { name = "buffer"; }
            { name = "path"; }
          ];
          mapping = {
            "<C-Space>" = "cmp.mapping.complete()";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
            "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
          };
        };
      };
    };

    keymaps = [
      { mode = "n"; key = "<leader>e"; action = "<cmd>NvimTreeToggle<CR>"; }
      { mode = "n"; key = "<leader>w"; action = "<cmd>w<CR>"; }
      { mode = "n"; key = "<leader>q"; action = "<cmd>q<CR>"; }
      { mode = "v"; key = "<"; action = "<gv"; }
      { mode = "v"; key = ">"; action = ">gv"; }
    ];
  };

  programs.java = {
    enable = true;
    package = pkgs.jdk21;
  };

  # Terminal & Shell
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set -g fish_greeting ""
      cat ~/.local/state/caelestia/sequences.txt 2> /dev/null
    '';
    shellAliases = {
      clean = "nh clean all";
    };
    functions = {
      rebuild = {
        description = "Rebuild NixOS";
        body = "nh os switch ~/nixos-config $argv";
      };
      update = {
        description = "Rebuild NixOS with updated inputs";
        body = "nh os switch ~/nixos-config --update $argv";
      };
    };
  };

  programs.starship = {
    enable = true;
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
    options = [
      "--cmd cd"
    ];
  };

  programs.kitty = {
    enable = true;
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
    enableDefaultConfig = false;
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

  programs.spicetify =
    let
      spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
    in
    {
      enable = true;
      enabledExtensions = with spicePkgs.extensions; [
        
      ];
      theme = spicePkgs.themes.catppuccin;
      colorScheme = "mocha";
    };

  programs.vesktop = {
    enable = true;

    vencord.settings = {
      autoUpdate = true;
      autoUpdateNotification = true;
      notifyAboutUpdates = true;

      enabledThemes = [ "caelestia.theme.css" ];

      plugins = {
        ClearURLs.enabled = true;
        FixYoutubeEmbeds.enabled = true;
        FakeNitro.enabled = true;
        LastFMRichPresence.enabled = true;
      };
    };
  };

  # ----------------------------------------------------------------------------
  # XDG CONFIG FILES (Direct migration)
  # ----------------------------------------------------------------------------

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "x-scheme-handler/http" = [ "brave-browser.desktop" ];
      "x-scheme-handler/https" = [ "brave-browser.desktop" ];
      "application/pdf" = [ "brave-browser.desktop" ];
      "application/msword" = [ "writer.desktop" ];
      "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = [ "writer.desktop" ];
      "application/vnd.openxmlformats-officedocument.wordprocessingml.template" = [ "writer.desktop" ];
      "application/vnd.ms-word.document.macroEnabled.12" = [ "writer.desktop" ];
      "application/vnd.ms-word.template.macroEnabled.12" = [ "writer.desktop" ];
      "application/vnd.oasis.opendocument.text" = [ "writer.desktop" ];
      "application/vnd.oasis.opendocument.text-template" = [ "writer.desktop" ];
      # File manager
      "inode/directory" = [ "thunar.desktop" ];
      "x-scheme-handler/file" = [ "thunar.desktop" ];
      "application/x-gnome-saved-search" = [ "thunar.desktop" ];
    };
  };

  xdg.configFile."brave-flags.conf".text = ''
    --ozone-platform=wayland
    --use-gl=egl
    --enable-features=TouchpadOverscrollHistoryNavigation
  '';

  # ----------------------------------------------------------------------------
  # PROTON DRIVE (rclone mount)
  # Files stream on-demand from Proton Drive — not stored locally.
  # One-time setup required: run `rclone config` and name the remote "proton-drive"
  # ----------------------------------------------------------------------------

  # home.activation.createProtonDriveMountpoint = ''
  #   mkdir -p "$HOME/ProtonDrive"
  # '';

  # systemd.user.services.proton-drive = {
  #   Unit = {
  #     Description = "Proton Drive rclone mount";
  #     After = [ "network-online.target" ];
  #     Wants = [ "network-online.target" ];
  #   };
  #   Service = {
  #     Type = "notify";
  #     ExecStart = "${pkgs.rclone}/bin/rclone mount proton-drive: %h/ProtonDrive --vfs-cache-mode minimal --dir-cache-time 5m --poll-interval 1m --vfs-read-chunk-size 32M --buffer-size 64M";
  #     ExecStop = "${pkgs.fuse3}/bin/fusermount3 -uz %h/ProtonDrive";
  #     Restart = "on-failure";
  #     RestartSec = "10s";
  #   };
  #   Install = {
  #     WantedBy = [ "default.target" ];
  #   };
  # };

  # ----------------------------------------------------------------------------
  # USER ENVIRONMENT
  # ----------------------------------------------------------------------------

  home.sessionVariables = {
    NH_FLAKE = "/home/meterra/nixos-config";
    # In Hybrid/PRIME mode Hyprland composites across both GPUs — setting GBM_BACKEND
    # and __GLX_VENDOR_LIBRARY_NAME to nvidia globally causes Wayland apps (browsers)
    # to allocate buffers on NVIDIA while the compositor runs on AMD, causing glitches.
    LIBVA_DRIVER_NAME = "nvidia";
  };

  # ----------------------------------------------------------------------------
  # PACKAGES
  # ----------------------------------------------------------------------------

  home.packages = with pkgs; [
    nh
    # --- Desktop / Window Manager ---
    hyprpicker
    hypridle
    wl-clipboard
    cliphist
    nwg-displays
    nwg-look
    grim
    slurp
    libpulseaudio

    # --- Terminal & Shell ---
    foot
    nvtopPackages.full
    jq
    socat
    yt-dlp
    cmake
    ninja
    pkg-config
    fzf
    cowsay

    # --- Development ---
    git
    vscodium
    jetbrains.idea-oss
    jetbrains.clion
    gemini-cli-bin
    claude-code
    matugen
    inotify-tools
    app2unit
    swappy
    clang

    # --- NodeJS ---
    nodejs
    
    # -- Python 3 ---
    python3
    python313Packages.pip
    python313Packages.requests

    # --- Cybersecurity ---
    hash-identifier
    ghidra-bin
    exiftool
    hashcat
    cudaPackages.cudatoolkit
    nmap
    wireshark
    metasploit
    john
    sqlmap
    thc-hydra
    aircrack-ng
    binwalk
    gobuster
    rockyou

    # --- Internet & Communication ---
    firefox
    brave
    vesktop
    obsidian
    protonvpn-gui
    wireguard-tools
    libreoffice-qt
    proton-pass
    rclone
    fuse3

    # --- File Management & Utilities ---
    thunar
    nautilus
    trash-cli
    xdg-utils
    wget
    ntfs3g
    dosfstools
    curl
    imagemagick
    ffmpeg
    flac
    libqalculate
    taskwarrior3

    # --- Media & System Utilities ---
    vlc
    feishin
    kdePackages.gwenview
    bluez
    bluez-tools
    brightnessctl
    ddcutil
    lm_sensors
    cava
    aubio
    jellyfin-desktop
    sshfs
    qbittorrent
    obs-studio

    # --- Gaming ---
    eden
    protonplus
    mangohud
    gamemode
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
