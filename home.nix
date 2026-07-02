{ pkgs, noctalia-shell, ... }:

{
  home.stateVersion = "25.11";

  programs.fish.enable = true;

  programs.fish.interactiveShellInit = "starship init fish | source";

  programs.fish.functions = {
    nix = {
      body = ''
        if test "$argv[1]" = "add"
          set -l pkg $argv[2]
          if test -z "$pkg"
            echo "Usage: nix add <package>"
            return 1
          end
          if not grep -q "$pkg" /etc/nixos/configuration.nix
            sudo sed -i '/^\s*environment\.systemPackages/,/^\s*\];/{
              /^\s*\];/i\    '$pkg'
            }' /etc/nixos/configuration.nix
          end
          sudo nixos-rebuild switch --flake /etc/nixos
        else
          command nix $argv
        end
      '';
      wraps = "nix";
    };
  };

  home.file.".config/quickshell".source =
    "${noctalia-shell.packages.x86_64-linux.default}/share/noctalia-shell";

  xdg.configFile."niri/config.kdl".text = ''
    layout {
        default-column-width { proportion 0.5; }
        focus-ring { off; }
        border { off; }
    }

    animations {
        workspace-switch {
            spring damping-ratio=1.0 stiffness=1000 epsilon=0.0001
        }
        window-open {
            spring damping-ratio=0.7 stiffness=600 epsilon=0.0001
        }
        window-close {
            duration-ms 150
            curve "ease-out-quad"
        }
        window-movement {
            spring damping-ratio=1.0 stiffness=800 epsilon=0.0001
        }
        window-resize {
            spring damping-ratio=1.0 stiffness=800 epsilon=0.0001
        }
    }

    input {
        keyboard {
            xkb {
                layout "us"
            }
        }
    }

    output "eDP-1" {
        scale 1.0
    }

    prefer-no-csd

    spawn-at-startup "noctalia-shell"

    window-rule {
        geometry-corner-radius 12
        clip-to-geometry true
    }

    binds {
        Super+Return { spawn "kitty"; }
        Super+T { spawn "kitty"; }
        Super+Q { close-window; }

        Super+Space { spawn "noctalia-shell" "ipc" "call" "launcher" "toggle"; }
        Super+D { spawn "noctalia-shell" "ipc" "call" "launcher" "toggle"; }
        Super+S { spawn "noctalia-shell" "ipc" "call" "controlCenter" "toggle"; }
        Super+Comma { spawn "noctalia-shell" "ipc" "call" "settings" "toggle"; }

        Super+Left { focus-column-left; }
        Super+Right { focus-column-right; }
        Super+Up { focus-window-up; }
        Super+Down { focus-window-down; }

        Super+Shift+Left { move-column-left; }
        Super+Shift+Right { move-column-right; }
        Super+Shift+Up { move-window-up; }
        Super+Shift+Down { move-window-down; }

        Super+F { fullscreen-window; }
        Super+Shift+F { toggle-window-floating; }
        Super+R { switch-preset-column-width; }
        Super+Shift+R { reset-window-height; }
        Super+M { set-column-width "100%"; }

        Super+Tab { toggle-overview; }

        Super+1 { focus-workspace 1; }
        Super+2 { focus-workspace 2; }
        Super+3 { focus-workspace 3; }
        Super+4 { focus-workspace 4; }
        Super+5 { focus-workspace 5; }
        Super+6 { focus-workspace 6; }
        Super+7 { focus-workspace 7; }
        Super+8 { focus-workspace 8; }
        Super+9 { focus-workspace 9; }

        Super+Ctrl+1 { move-column-to-workspace 1; }
        Super+Ctrl+2 { move-column-to-workspace 2; }
        Super+Ctrl+3 { move-column-to-workspace 3; }
        Super+Ctrl+4 { move-column-to-workspace 4; }
        Super+Ctrl+5 { move-column-to-workspace 5; }
        Super+Ctrl+6 { move-column-to-workspace 6; }
        Super+Ctrl+7 { move-column-to-workspace 7; }
        Super+Ctrl+8 { move-column-to-workspace 8; }
        Super+Ctrl+9 { move-column-to-workspace 9; }

        Super+Page_Down { focus-workspace-down; }
        Super+Page_Up { focus-workspace-up; }
        Super+Shift+Page_Down { move-workspace-down; }
        Super+Shift+Page_Up { move-workspace-up; }

        Print { spawn "grim"; }
        Super+Shift+S { spawn "sh" "-c" "grim -g $(slurp)"; }

        XF86AudioRaiseVolume { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%+"; }
        XF86AudioLowerVolume { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-"; }
        XF86AudioMute { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"; }
        XF86MonBrightnessUp { spawn "brightnessctl" "s" "10%+"; }
        XF86MonBrightnessDown { spawn "brightnessctl" "s" "10%-"; }
    }
  '';

  xdg.configFile."alacritty/alacritty.toml".text = ''
    [window]
    opacity = 0.93

    [font]
    normal = { family = "JetBrainsMono Nerd Font", style = "Regular" }
    bold = { family = "JetBrainsMono Nerd Font", style = "Bold" }
    italic = { family = "JetBrainsMono Nerd Font", style = "Italic" }
    bold_italic = { family = "JetBrainsMono Nerd Font", style = "Bold Italic" }
    size = 11

    [colors]
    [colors.primary]
    background = "#0a0e14"
    foreground = "#b3b1ad"

    [colors.normal]
    black = "#01060e"
    red = "#ea6c73"
    green = "#91b362"
    yellow = "#f9af4f"
    blue = "#53bdfa"
    magenta = "#fae994"
    cyan = "#90e1c6"
    white = "#c7c5c5"

    [colors.bright]
    black = "#626a73"
    red = "#ea6c73"
    green = "#91b362"
    yellow = "#f9af4f"
    blue = "#53bdfa"
    magenta = "#fae994"
    cyan = "#90e1c6"
    white = "#c7c5c5"

    [colors.selection]
    text = "#0a0e14"
    background = "#53bdfa"

    [cursor]
    style = "Underline"
    unfocused_hollow = false
  '';

  xdg.configFile."kitty/kitty.conf".text = ''
    confirm_os_window_close 0
    background_opacity 0.93

    font_family JetBrainsMono Nerd Font
    bold_font JetBrainsMono Nerd Font
    italic_font JetBrainsMono Nerd Font
    bold_italic_font JetBrainsMono Nerd Font
    font_size 11.0

    background #0a0e14
    foreground #b3b1ad

    color0 #01060e
    color1 #ea6c73
    color2 #91b362
    color3 #f9af4f
    color4 #53bdfa
    color5 #fae994
    color6 #90e1c6
    color7 #c7c5c5

    color8 #626a73
    color9 #ea6c73
    color10 #91b362
    color11 #f9af4f
    color12 #53bdfa
    color13 #fae994
    color14 #90e1c6
    color15 #c7c5c5

    selection_foreground #0a0e14
    selection_background #53bdfa

    cursor_shape underline
    cursor_underline_thickness 2.0
  '';

  xdg.configFile."starship/starship.toml".text = ''
    format = "  $all"
  '';

  xdg.configFile."noctalia/settings.toml".text = ''
    [shell.panel]
    background_blur = true
    transparency_mode = "solid"
    attach_launcher = true
    attach_clipboard = true
    attach_control_center = true
    attach_wallpaper = true
    attach_session = false

    [bar.main]
    position = "top"
    thickness = 34
    background_opacity = 1.0
    radius = 12
    margin_h = 180
    margin_v = 10
    padding = 14
    widget_spacing = 6
    scale = 1.0
    shadow = true
    auto_hide = false
    reserve_space = true
    attach_panels = true
    capsule = false

    [bar.main.widgets]
    start = ["launcher", "workspaces"]
    center = ["clock"]
    end = ["media", "tray", "notifications", "clipboard", "network", "volume", "battery", "control-center", "session"]
  '';

  home.packages = with pkgs; [
    alacritty
    kitty
    fastfetch
    rofi
    nerd-fonts.jetbrains-mono
    noctalia-shell.packages.x86_64-linux.default
  ];
}
