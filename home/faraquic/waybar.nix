{ config, pkgs, lib, ... }:

{
  programs.waybar = {
    enable = true;
    # waybar reads WAYLAND_DISPLAY from environment — starts correctly under Hyprland
    systemd.enable = true;

    settings = [{
      layer    = "top";
      position = "top";
      height   = 32;
      spacing  = 4;
      margin-top    = 6;
      margin-left   = 10;
      margin-right  = 10;

      modules-left   = [ "hyprland/workspaces" "hyprland/window" ];
      modules-center = [ "clock" ];
      modules-right  = [
        "custom/media"
        "pulseaudio"
        "cpu"
        "memory"
        "temperature"
        "network"
        "tray"
        "custom/power"
      ];

      "hyprland/workspaces" = {
        disable-scroll  = true;
        all-outputs     = false;
        on-click        = "activate";
        format          = "{icon}";
        format-icons    = {
          "1" = "󰲡";
          "2" = "󰲣";
          "3" = "󰲥";
          "4" = "󰲧";
          "5" = "󰲩";
          "6" = "󰲫";
          "7" = "󰲭";
          "8" = "󰲯";
          "9" = "󰲱";
          "urgent"  = "";
          "focused" = "";
          "default" = "";
        };
        persistent-workspaces = {
          "1" = [];
          "2" = [];
          "3" = [];
          "4" = [];
          "5" = [];
        };
      };

      "hyprland/window" = {
        max-length      = 60;
        separate-outputs = true;
        rewrite          = {
          "(.*) - Mozilla Firefox" = "  $1";
          "(.*) - Visual Studio Code" = "󰨞 $1";
          "kitty" = " kitty";
        };
      };

      clock = {
        timezone       = "Asia/Yekaterinburg";
        format         = "  {:%H:%M}";
        format-alt     = "  {:%Y-%m-%d %H:%M:%S}";
        tooltip-format = "<big>{:%B %Y}</big>\n<tt><small>{calendar}</small></tt>";
        calendar = {
          mode       = "year";
          mode-mon-col = 3;
          weeks-pos  = "right";
          on-scroll  = 1;
          format = {
            months    = "<span color='#cad3f5'><b>{}</b></span>";
            days      = "<span color='#b8c0e0'>{}</span>";
            weeks     = "<span color='#8bd5ca'>W{}</span>";
            weekdays  = "<span color='#c6a0f6'><b>{}</b></span>";
            today     = "<span color='#ed8796'><b><u>{}</u></b></span>";
          };
        };
      };

      "custom/media" = {
        format = "{icon}  {}";
        return-type = "json";
        max-length  = 40;
        format-icons = {
          "spotify"       = "";
          "youtube-music" = "";
          "default"       = "󰝚";
        };
        escape = true;
        exec = "${pkgs.playerctl}/bin/playerctl -a metadata --format '{\"text\": \"{{markup_escape(title)}}\", \"tooltip\": \"{{playerName}}: {{markup_escape(title)}}\", \"alt\": \"{{playerName}}\", \"class\": \"{{playerName}}\"}' -F 2>/dev/null";
        on-click = "${pkgs.playerctl}/bin/playerctl play-pause";
      };

      pulseaudio = {
        format            = "{icon}  {volume}%";
        format-muted      = "󰝟  Muted";
        format-icons = {
          "headphone"      = "󰋋";
          "hands-free"     = "󰋎";
          "headset"        = "󰋎";
          "phone"          = "";
          "portable"       = "";
          "car"            = "";
          "default"        = [ "" "" "" ];
        };
        on-click          = "${pkgs.pavucontrol}/bin/pavucontrol";
        scroll-step       = 5;
        max-volume        = 150;
        tooltip-format    = "{desc} ({volume}%)";
      };

      cpu = {
        interval = 5;
        format   = "  {usage}%";
        tooltip  = true;
        on-click = "${pkgs.kitty}/bin/kitty --class btop btop";
      };

      memory = {
        interval = 10;
        format   = "  {percentage}%";
        tooltip-format = "{used:0.1f}G / {total:0.1f}G";
        on-click = "${pkgs.kitty}/bin/kitty --class btop btop";
      };

      temperature = {
        interval          = 10;
        critical-threshold = 80;
        format            = "{icon}  {temperatureC}°C";
        format-critical   = "  {temperatureC}°C";
        format-icons      = [ "" "" "" "" "" ];
      };

      network = {
        interval          = 5;
        format-wifi       = "󰤨  {signalStrength}%";
        format-ethernet   = "󰈀  {ipaddr}";
        format-disconnected = "󰤭  Offline";
        format-linked     = "󰈀  (no IP)";
        tooltip-format    = "󰈀 {ifname}\n󰩟 {ipaddr}/{cidr}\n  {gwaddr}\n  {bandwidthUpBits}  {bandwidthDownBits}";
        on-click          = "${pkgs.networkmanagerapplet}/bin/nm-connection-editor";
      };

      tray = {
        icon-size  = 16;
        spacing    = 8;
        show-passive-items = true;
      };

      "custom/power" = {
        format   = "⏻";
        tooltip  = false;
        on-click = "${pkgs.wlogout}/bin/wlogout -b 5";
      };
    }];

    style = ''
      /* Catppuccin Macchiato */
      @define-color base    #24273a;
      @define-color mantle  #1e2030;
      @define-color surface0 #363a4f;
      @define-color surface1 #494d64;
      @define-color overlay0 #6e738d;
      @define-color text    #cad3f5;
      @define-color subtext1 #b8c0e0;
      @define-color subtext0 #a5adcb;
      @define-color teal    #8bd5ca;
      @define-color mauve   #c6a0f6;
      @define-color blue    #8aadf4;
      @define-color red     #ed8796;
      @define-color yellow  #eed49f;
      @define-color peach   #f5a97f;

      * {
        font-family: "JetBrainsMono Nerd Font Mono";
        font-size: 13px;
        border: none;
        border-radius: 0;
        min-height: 0;
      }

      window#waybar {
        background-color: transparent;
        color: @text;
      }

      .modules-left,
      .modules-center,
      .modules-right {
        background-color: alpha(@base, 0.9);
        border-radius: 10px;
        padding: 0 6px;
        margin: 0 4px;
      }

      /* Workspaces */
      #workspaces {
        background-color: transparent;
        padding: 0 4px;
      }
      #workspaces button {
        color: @overlay0;
        padding: 0 6px;
        border-radius: 8px;
        transition: all 0.2s ease;
      }
      #workspaces button:hover {
        background-color: @surface1;
        color: @text;
      }
      #workspaces button.active {
        background-color: @teal;
        color: @base;
        font-weight: bold;
      }
      #workspaces button.urgent {
        background-color: @red;
        color: @base;
      }

      /* Window title */
      #window {
        color: @subtext1;
        padding: 0 8px;
        font-style: italic;
      }

      /* Clock */
      #clock {
        color: @blue;
        font-weight: bold;
        padding: 0 12px;
      }

      /* Modules */
      #pulseaudio, #cpu, #memory, #temperature,
      #network, #tray, #custom-media, #custom-power {
        padding: 0 10px;
        color: @text;
      }

      #pulseaudio { color: @teal; }
      #pulseaudio.muted { color: @overlay0; }
      #cpu { color: @yellow; }
      #memory { color: @mauve; }
      #temperature { color: @peach; }
      #temperature.critical { color: @red; }
      #network { color: @blue; }
      #network.disconnected { color: @red; }

      #custom-media {
        color: @teal;
        font-style: italic;
      }
      #custom-power {
        color: @red;
        font-size: 15px;
        padding: 0 12px;
        cursor: pointer;
      }
      #tray > .passive { -gtk-icon-effect: dim; }
      #tray > .needs-attention { -gtk-icon-effect: highlight; color: @peach; }
    '';
  };
}
