{ pkgs, ... }:

{
  xdg.configFile."niri/config.kdl".text = ''
    // ============================================================================
    // INPUT
    // ============================================================================

    input {
        keyboard {
            xkb {
                layout "us"
            }
        }

        touchpad {
            natural-scroll
            tap
        }

        mouse {
            // Default: no natural scroll for mice
        }
    }

    // ============================================================================
    // ENVIRONMENT
    // ============================================================================

    environment {
        XCURSOR_SIZE "16"
        XCURSOR_THEME "rose-pine-hyprcursor"
        XDG_SESSION_TYPE "wayland"
        AQ_DRM_DEVICES "/dev/dri/nvidia-gpu:/dev/dri/amd-igpu"
        NIXOS_OZONE_WL "1"
        LIBVA_DRIVER_NAME "radeonsi"
        VDPAU_DRIVER "va_gl"
        DISPLAY ":0"
    }

    cursor {
        xcursor-theme "rose-pine-hyprcursor"
        xcursor-size 16
        hide-after-inactive-ms 3000
    }

    prefer-no-csd

    // ============================================================================
    // LAYOUT
    // ============================================================================

    layout {
        gaps 14

        center-focused-column "on-overflow"

        preset-column-widths {
            proportion 0.33333
            proportion 0.5
            proportion 0.66667
            proportion 1.0
        }

        preset-window-heights {
            proportion 0.33333
            proportion 0.5
            proportion 0.66667
            proportion 1.0
        }

        default-column-width { proportion 0.5; }

        focus-ring {
            width 2
            active-gradient from="#c4a7e7" to="#ea9a97" angle=45
            inactive-color "#393552"
        }

        border {
            off
        }

        shadow {
            on
            softness 25
            spread 3
            offset x=0 y=6
            color "#0d0c1280"
        }

        tab-indicator {
            hide-when-single-tab
            width 4
            gap 4
            gaps-between-tabs 4
            corner-radius 4
            active-gradient from="#c4a7e7" to="#ea9a97" angle=45
            inactive-color "#393552"
        }
    }

    // ============================================================================
    // ANIMATIONS
    // ============================================================================

    animations {
        slowdown 0.7

        workspace-switch {
            spring damping-ratio=0.85 stiffness=900 epsilon=0.0001
        }

        window-open {
            duration-ms 200
            curve "ease-out-expo"
        }

        window-close {
            duration-ms 120
            curve "ease-out-quad"
        }

        horizontal-view-movement {
            spring damping-ratio=0.85 stiffness=700 epsilon=0.0001
        }

        window-movement {
            spring damping-ratio=0.85 stiffness=700 epsilon=0.0001
        }

        window-resize {
            spring damping-ratio=0.9 stiffness=700 epsilon=0.0001
        }

        config-notification-open-close {
            spring damping-ratio=0.6 stiffness=1000 epsilon=0.001
        }
    }

    // ============================================================================
    // WINDOW RULES
    // ============================================================================

    window-rule {
        geometry-corner-radius 12
        clip-to-geometry true
    }

    window-rule {
        match is-focused=false
        opacity 0.92
    }

    window-rule {
        match app-id="vesktop"
        default-column-width { proportion 1.0; }
    }

    // Common dialogs / pickers should float
    window-rule {
        match app-id=r#"^(xdg-desktop-portal|gcr-prompter|polkit-gnome-authentication-agent-1|nm-connection-editor|pavucontrol|blueman-manager|nwg-displays)$"#
        open-floating true
    }

    // ============================================================================
    // AUTOSTART
    // ============================================================================

    spawn-at-startup "xwayland-satellite"
    spawn-at-startup "systemctl" "--user" "start" "hyprpolkitagent"
    spawn-at-startup "kdeconnect-indicator"
    spawn-at-startup "vesktop"

    // ============================================================================
    // KEYBINDINGS
    // ============================================================================

    binds {
        // --- Applications ---
        Mod+Q { spawn "kitty"; }
        Mod+B { spawn "brave"; }
        Mod+E { spawn "thunar"; }
        Mod+Space { spawn "dms" "ipc" "launcher" "toggle"; }

        // --- Window Management ---
        Mod+C { close-window; }
        Mod+M { quit; }
        Mod+G { toggle-window-floating; }
        Mod+F { fullscreen-window; }
        Mod+Tab { toggle-overview; }

        // --- Focus Movement (arrow keys + vim hjkl) ---
        Mod+Left  { focus-column-left; }
        Mod+Right { focus-column-right; }
        Mod+Up    { focus-window-up; }
        Mod+Down  { focus-window-down; }
        Mod+H { focus-column-left; }
        Mod+L { focus-column-right; }
        Mod+J { focus-window-down; }
        Mod+K { focus-window-up; }

        // --- Move Windows (arrow keys + vim hjkl) ---
        Mod+Shift+Left  { move-column-left; }
        Mod+Shift+Right { move-column-right; }
        Mod+Shift+Up    { move-window-up; }
        Mod+Shift+Down  { move-window-down; }
        Mod+Shift+H { move-column-left; }
        Mod+Shift+L { move-column-right; }
        Mod+Shift+J { move-window-down; }
        Mod+Shift+K { move-window-up; }

        // --- Column / Window Sizing ---
        Mod+R { switch-preset-column-width; }
        Mod+Shift+R { reset-window-height; }
        Mod+V { switch-preset-window-height; }
        Mod+Minus { set-column-width "-10%"; }
        Mod+Equal { set-column-width "+10%"; }
        Mod+Shift+Minus { set-window-height "-10%"; }
        Mod+Shift+Equal { set-window-height "+10%"; }

        // --- Column Stacking (tabs) ---
        // Mod+Comma pulls the next window into a tab with the current one
        // Mod+Period pops the focused window out into its own column
        Mod+Comma { consume-window-into-column; }
        Mod+Period { expel-window-from-column; }

        // --- Multi-monitor ---
        Mod+Ctrl+Left  { focus-monitor-left; }
        Mod+Ctrl+Right { focus-monitor-right; }
        Mod+Ctrl+Shift+Left  { move-column-to-monitor-left; }
        Mod+Ctrl+Shift+Right { move-column-to-monitor-right; }

        // --- Workspaces ---
        Mod+1 { focus-workspace 1; }
        Mod+2 { focus-workspace 2; }
        Mod+3 { focus-workspace 3; }
        Mod+4 { focus-workspace 4; }
        Mod+5 { focus-workspace 5; }
        Mod+6 { focus-workspace 6; }
        Mod+7 { focus-workspace 7; }
        Mod+8 { focus-workspace 8; }
        Mod+9 { focus-workspace 9; }
        Mod+0 { focus-workspace 10; }

        Mod+Shift+1 { move-column-to-workspace 1; }
        Mod+Shift+2 { move-column-to-workspace 2; }
        Mod+Shift+3 { move-column-to-workspace 3; }
        Mod+Shift+4 { move-column-to-workspace 4; }
        Mod+Shift+5 { move-column-to-workspace 5; }
        Mod+Shift+6 { move-column-to-workspace 6; }
        Mod+Shift+7 { move-column-to-workspace 7; }
        Mod+Shift+8 { move-column-to-workspace 8; }
        Mod+Shift+9 { move-column-to-workspace 9; }
        Mod+Shift+0 { move-column-to-workspace 10; }

        Mod+WheelScrollDown       cooldown-ms=150 { focus-workspace-down; }
        Mod+WheelScrollUp         cooldown-ms=150 { focus-workspace-up; }
        Mod+Shift+WheelScrollDown cooldown-ms=150 { move-column-to-workspace-down; }
        Mod+Shift+WheelScrollUp   cooldown-ms=150 { move-column-to-workspace-up; }

        Mod+Page_Down       { focus-workspace-down; }
        Mod+Page_Up         { focus-workspace-up; }
        Mod+Shift+Page_Down { move-column-to-workspace-down; }
        Mod+Shift+Page_Up   { move-column-to-workspace-up; }

        // --- Screenshot ---
        Mod+W { spawn "sh" "-c" "grim -g \"$(slurp)\" - | wl-copy"; }
        Mod+Shift+W { spawn "sh" "-c" "grim - | wl-copy"; }

        // --- Volume ---
        XF86AudioRaiseVolume allow-when-locked=true { spawn "wpctl" "set-volume" "-l" "1" "@DEFAULT_AUDIO_SINK@" "5%+"; }
        XF86AudioLowerVolume allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-"; }
        XF86AudioMute        allow-when-locked=true { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"; }
        XF86AudioMicMute     allow-when-locked=true { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle"; }

        // --- Brightness ---
        XF86MonBrightnessUp   allow-when-locked=true { spawn "brightnessctl" "-d" "amdgpu_bl1" "-e4" "-n2" "set" "5%+"; }
        XF86MonBrightnessDown allow-when-locked=true { spawn "brightnessctl" "-d" "amdgpu_bl1" "-e4" "-n2" "set" "5%-"; }

        // --- Media ---
        XF86AudioNext  allow-when-locked=true { spawn "playerctl" "next"; }
        XF86AudioPause allow-when-locked=true { spawn "playerctl" "play-pause"; }
        XF86AudioPlay  allow-when-locked=true { spawn "playerctl" "play-pause"; }
        XF86AudioPrev  allow-when-locked=true { spawn "playerctl" "previous"; }
    }
  '';
}
