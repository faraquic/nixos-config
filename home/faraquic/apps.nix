{ config, pkgs, vscode-extensions, lib, ... }:

{
  # Terminal: Kitty
  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font Mono";
      size = 12;
    };
    settings = {
      # Catppuccin Macchiato
      foreground            = "#cad3f5";
      background            = "#24273a";
      selection_foreground  = "#24273a";
      selection_background  = "#c6a0f6";
      cursor                = "#f4dbd6";
      cursor_text_color     = "#24273a";
      url_color             = "#8aadf4";

      # Black
      color0  = "#494d64";
      color8  = "#5b6078";
      # Red
      color1  = "#ed8796";
      color9  = "#ed8796";
      # Green
      color2  = "#a6da95";
      color10 = "#a6da95";
      # Yellow
      color3  = "#eed49f";
      color11 = "#eed49f";
      # Blue
      color4  = "#8aadf4";
      color12 = "#8aadf4";
      # Magenta
      color5  = "#f5bde6";
      color13 = "#f5bde6";
      # Cyan
      color6  = "#8bd5ca";
      color14 = "#8bd5ca";
      # White
      color7  = "#b8c0e0";
      color15 = "#a5adcb";

      background_opacity  = "0.92";
      dynamic_background_color = "yes";

      window_padding_width = 8;
      confirm_os_window_close = 0;
      enable_audio_bell   = "no";
      hide_window_decorations = "yes";

      # Scrollback
      scrollback_lines = 10000;
    };
    extraConfig = ''
      # Tab bar
      tab_bar_style       powerline
      tab_powerline_style slanted
      active_tab_foreground   #24273a
      active_tab_background   #8bd5ca
      inactive_tab_foreground #a5adcb
      inactive_tab_background #363a4f
    '';
  };

  # Shell prompt: Starship
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      format = lib.concatStrings [
        "$os"
        "$username"
        "$hostname"
        "$directory"
        "$git_branch"
        "$git_status"
        "$python"
        "$rust"
        "$nodejs"
        "$cmd_duration"
        "$line_break"
        "$character"
      ];
      add_newline = true;

      os = {
        disabled = false;
        symbols.NixOS = " ";
      };
      username = {
        show_always = false;
        format      = "[$user]($style) ";
        style_user  = "bold #8bd5ca";
      };
      directory = {
        style           = "bold #8aadf4";
        truncate_to_repo = true;
        truncation_length = 3;
      };
      character = {
        success_symbol = "[❯](bold #a6da95)";
        error_symbol   = "[❯](bold #ed8796)";
        vimcmd_symbol  = "[❮](bold #c6a0f6)";
      };
      git_branch = {
        symbol = " ";
        style  = "bold #c6a0f6";
      };
      git_status = {
        style = "#eed49f";
      };
      cmd_duration = {
        min_time = 2000;
        format   = "[$duration]($style) ";
        style    = "bold #f5a97f";
      };
      python = {
        symbol = " ";
        style  = "bold #eed49f";
      };
      rust = {
        symbol = " ";
        style  = "bold #f5a97f";
      };
      nodejs = {
        symbol = " ";
        style  = "bold #a6da95";
      };
    };
  };

  # Fish shell (config, not enable — that's system-level)
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set -g fish_greeting ""
      # Zoxide integration
      zoxide init fish | source
    '';
    shellAliases = {
      ls   = "eza --icons";
      ll   = "eza -lah --icons --git";
      lt   = "eza --tree --icons --level=2";
      cat  = "bat --style=plain";
      grep = "rg";
      find = "fd";
      top  = "btop";
      df   = "duf";
      du   = "dust";
      man  = "batman";  # bat-extras
      # NixOS shortcuts
      nrs  = "sudo nixos-rebuild switch --flake /etc/nixos#desktop";
      nrb  = "sudo nixos-rebuild boot --flake /etc/nixos#desktop";
      nrt  = "sudo nixos-rebuild test --flake /etc/nixos#desktop";
      nfu  = "cd /etc/nixos && sudo nix flake update && cd -";
      ngc  = "sudo nix-collect-garbage --delete-older-than 30d";
    };
  };

  # Launcher: rofi
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    terminal = "${pkgs.kitty}/bin/kitty";
    font = "JetBrainsMono Nerd Font Mono 12";
    location = "center";
    extraConfig = {
      modi             = "drun,run,window,ssh";
      icon-theme       = "Colloid-teal-dark";
      show-icons       = true;
      drun-display-format = "{name}";
      disable-history  = false;
      hide-scrollbar   = true;
      display-drun     = "   Apps";
      display-run      = "   Run";
      display-window   = " 󱂬  Window";
      display-ssh      = "   SSH";
    };
    theme = let
      inherit (config.lib.formats.rasi) mkLiteral;
    in {
      "*" = {
        bg-col         = mkLiteral "#24273a";
        bg-col-light   = mkLiteral "#363a4f";
        border-col     = mkLiteral "#8bd5ca";
        selected-col   = mkLiteral "#363a4f";
        blue           = mkLiteral "#8aadf4";
        fg-col         = mkLiteral "#cad3f5";
        fg-col2        = mkLiteral "#ed8796";
        grey           = mkLiteral "#a5adcb";
        width          = 600;
        line-margin    = 0;
        line-padding   = 1;
        border         = mkLiteral "0px solid";
        border-radius  = mkLiteral "12px";
        font           = "JetBrainsMono Nerd Font Mono 12";
      };
      "element-text, element-icon, mode-switcher" = {
        background-color = mkLiteral "inherit";
        text-color       = mkLiteral "inherit";
      };
      "window" = {
        height         = mkLiteral "360px";
        border         = mkLiteral "2px solid";
        border-color   = mkLiteral "@border-col";
        background-color = mkLiteral "@bg-col";
        border-radius  = mkLiteral "12px";
      };
      "mainbox" = {
        background-color = mkLiteral "@bg-col";
      };
      "inputbar" = {
        children       = mkLiteral "[prompt, entry]";
        background-color = mkLiteral "@bg-col";
        border-radius  = mkLiteral "10px";
        padding        = mkLiteral "2px";
      };
      "prompt" = {
        background-color = mkLiteral "@blue";
        padding          = mkLiteral "6px";
        text-color       = mkLiteral "@bg-col";
        border-radius    = mkLiteral "10px";
        margin           = mkLiteral "20px 0 0 20px";
      };
      "entry" = {
        padding        = mkLiteral "6px";
        margin         = mkLiteral "20px 0 0 10px";
        text-color     = mkLiteral "@fg-col";
        background-color = mkLiteral "@bg-col";
      };
      "listview" = {
        border         = mkLiteral "0 0 0";
        padding        = mkLiteral "6px 0 6px";
        margin         = mkLiteral "10px 0 0 20px";
        columns        = 2;
        background-color = mkLiteral "@bg-col";
      };
      "element" = {
        padding        = mkLiteral "5px";
        background-color = mkLiteral "@bg-col";
        text-color     = mkLiteral "@fg-col";
        border-radius  = mkLiteral "10px";
      };
      "element-icon" = {
        size           = mkLiteral "25px";
      };
      "element selected" = {
        background-color = mkLiteral "@selected-col";
        text-color       = mkLiteral "@blue";
      };
      "mode-switcher" = {
        spacing           = 0;
      };
      "button" = {
        padding        = mkLiteral "10px";
        background-color = mkLiteral "@bg-col-light";
        text-color     = mkLiteral "@grey";
        vertical-align = mkLiteral "0.5";
        horizontal-align = mkLiteral "0.5";
      };
      "button selected" = {
        background-color = mkLiteral "@bg-col";
        text-color       = mkLiteral "@blue";
      };
    };
  };

  # Notifications: Dunst
  services.dunst = {
    enable = true;
    iconTheme = {
      name    = "Colloid-teal-dark";
      package = pkgs.colloid-icon-theme;
    };
    settings = {
      global = {
        monitor        = 0;
        follow         = "mouse";
        width          = 350;
        height         = 200;
        origin         = "top-right";
        offset         = "10x50";
        scale          = 0;
        notification_limit = 10;
        progress_bar   = true;
        progress_bar_height = 8;
        progress_bar_frame_width = 1;
        indicate_hidden = "yes";
        transparency   = 8;
        separator_height = 2;
        padding        = 12;
        horizontal_padding = 14;
        text_icon_padding = 0;
        frame_width    = 2;
        frame_color    = "#8bd5ca"; # teal
        separator_color = "frame";
        sort           = "yes";
        font           = "JetBrainsMono Nerd Font Mono 11";
        line_height    = 0;
        markup         = "full";
        format         = "<b>%s</b>\\n%b";
        alignment      = "left";
        vertical_alignment = "center";
        show_age_threshold = 60;
        ellipsize      = "middle";
        ignore_newline = "no";
        stack_duplicates = true;
        hide_duplicate_count = false;
        show_indicators = "yes";
        enable_recursive_icon_lookup = true;
        sticky_history = "yes";
        history_length = 20;
        browser        = "${pkgs.firefox}/bin/firefox -new-tab";
        always_run_script = true;
        corner_radius  = 10;
        ignore_dbusclose = false;
        mouse_left_click  = "close_current";
        mouse_middle_click = "do_action, close_current";
        mouse_right_click = "close_all";
      };

      urgency_low = {
        background = "#24273a";
        foreground = "#cad3f5";
        frame_color = "#363a4f";
        timeout    = 5;
      };
      urgency_normal = {
        background = "#24273a";
        foreground = "#cad3f5";
        frame_color = "#8bd5ca";
        timeout    = 8;
      };
      urgency_critical = {
        background = "#24273a";
        foreground = "#ed8796";
        frame_color = "#ed8796";
        timeout    = 0;
      };
    };
  };

  # Night Gamma: Wlsunset
  # Yekaterinburg: 56.8°N, 60.6°E
  services.wlsunset = {
    enable = true;
    latitude  = "56.8";
    longitude = "60.6";
    temperature = {
      day   = 6500;
      night = 3800;
    };
  };

  # OSD: Avizo
  # No native home-manager module — run as systemd user service
  systemd.user.services.avizo = {
    Unit = {
      Description = "Avizo — volume/brightness OSD";
      After       = [ "graphical-session.target" ];
      PartOf      = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart  = "${pkgs.avizo}/bin/avizo-service";
      Restart    = "on-failure";
      RestartSec = 2;
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };

  # Browser: Firefox
  programs.firefox = {
    enable = true;
    profiles.faraquic = {
      id = 0;
      name = "faraquic";
      isDefault = true;
      settings = {
        # Privacy
        "privacy.trackingprotection.enabled"              = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
        "dom.security.https_only_mode"                    = true;
        # Performance
        "gfx.webrender.all"                               = true;
        "media.ffmpeg.vaapi.enabled"                      = true; # VAAPI hardware decode
        "media.hardware-video-decoding.force-enabled"     = true;
        # Wayland
        "widget.use-xdg-desktop-portal.file-picker"       = 1;
        "widget.use-xdg-desktop-portal.mime-handler"      = 1;
        # Quality of life
        "browser.tabs.warnOnClose"                        = false;
        "browser.startup.page"                            = 3; # restore session
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      };
      extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
        absolute-enable-right-click
        return-youtube-dislikes
        youtube-nonstop
        clearurls
        disconnect
        untrap-for-youtube
        user-agent-string-switcher
        tampermonkey
        sponsorblock
        languagetool
        adblocker-ultimate
        ublock-origin
        simple-translate
        better-canvas
        search-by-image
        privacy-badger
        youtube-enhancer-vc
        enhanced-github
        github-isometric-contributions
        darkreader
      ];
    };
  };

  # File manager: Yazi
  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      manager = {
        show_hidden  = false;
        sort_by      = "natural";
        sort_dir_first = true;
        show_symlink = true;
      };
      preview = {
        image_delay = 50;
      };
    };
    theme = {
      # Catppuccin Macchiato
      manager = {
        cwd = { fg = "#8aadf4"; };
        hovered = { fg = "#24273a"; bg = "#8bd5ca"; };
        preview_hovered = { underline = true; };
        find_keyword  = { fg = "#eed49f"; italic = true; };
        find_position = { fg = "#f5a97f"; italic = true; };
        marker_selected = { fg = "#a6da95"; bg = "#a6da95"; };
        marker_copied  = { fg = "#eed49f"; bg = "#eed49f"; };
        marker_cut     = { fg = "#ed8796"; bg = "#ed8796"; };
        tab_active  = { fg = "#24273a"; bg = "#8bd5ca"; };
        tab_inactive = { fg = "#cad3f5"; bg = "#363a4f"; };
        count_selected = { fg = "#a6da95"; };
        count_copied   = { fg = "#eed49f"; };
        count_cut      = { fg = "#ed8796"; };
      };
    };
  };

  # Document viewer: Zathura
  programs.zathura = {
    enable = true;
    options = {
      font              = "JetBrainsMono Nerd Font Mono 11";
      default-bg        = "#24273a";
      default-fg        = "#cad3f5";
      statusbar-bg      = "#1e2030";
      statusbar-fg      = "#cad3f5";
      inputbar-bg       = "#1e2030";
      inputbar-fg       = "#cad3f5";
      notification-bg   = "#1e2030";
      notification-fg   = "#cad3f5";
      notification-error-bg   = "#24273a";
      notification-error-fg   = "#ed8796";
      notification-warning-bg = "#24273a";
      notification-warning-fg = "#eed49f";
      highlight-color         = "rgba(139,213,202,0.4)"; # teal
      highlight-active-color  = "rgba(198,160,246,0.6)"; # mauve
      completion-bg     = "#363a4f";
      completion-fg     = "#cad3f5";
      completion-highlight-bg = "#8bd5ca";
      completion-highlight-fg = "#24273a";
      recolor-lightcolor  = "#24273a";
      recolor-darkcolor   = "#cad3f5";
      recolor            = true;
      adjust-open        = "best-fit";
    };
    mappings = {
      "<C-i>"  = "zoom in";
      "<C-o>"  = "zoom out";
      "K"      = "navigate previous";
      "J"      = "navigate next";
      "f"      = "toggle_fullscreen";
    };
  };

  # VSCode
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    profiles.default.extensions =
      (with pkgs.vscode-extensions; [
        charliermarsh.ruff
        esbenp.prettier-vscode
        gruntfuggly.todo-tree
        mikestead.dotenv
        ms-azuretools.vscode-docker
        ms-python.debugpy
        ms-python.python
        ms-python.vscode-pylance
        pkief.material-icon-theme
        ritwickdey.liveserver
        rust-lang.rust-analyzer
        streetsidesoftware.code-spell-checker
        tamasfe.even-better-toml
        usernamehw.errorlens
        vadimcn.vscode-lldb
        wakatime.vscode-wakatime
      ])
      ++ (with vscode-extensions; [
        aaron-bond.better-comments
        anseki.vscode-color
        cardinal90.multi-cursor-case-preserve
        denjay.fold-level
        dlahmad.dracula-for-rust-theme
        evgeniypeshkov.syntax-highlighter
        formulahendry.code-runner
        github.github-vscode-theme
        github.vscode-github-actions
        icrawl.discord-vscode
        inci-august.august-themes
        ms-azuretools.vscode-containers
        ms-python.vscode-python-envs
        njpwerner.autodocstring
        njqdev.vscode-python-typehint
        streetsidesoftware.code-spell-checker-russian
        tabzyragu.coffee-status
      ]);
    profiles.default.userSettings = {
      "workbench.colorTheme"    = "GitHub Dark Default";
      "workbench.iconTheme"     = "material-icon-theme";
      "editor.fontFamily"       = "'JetBrainsMono Nerd Font Mono', monospace";
      "editor.fontSize"         = 16;
      "editor.fontLigatures"    = true;
      "editor.lineHeight"       = 22;
      "editor.formatOnSave"     = true;
      "editor.tabSize"          = 4;
      "editor.minimap.enabled"  = false;
      "editor.smoothScrolling"  = true;
      "editor.cursorBlinking"   = "smooth";
      "editor.cursorSmoothCaretAnimation" = "on";
      "editor.bracketPairColorization.enabled" = true;
      "window.titleBarStyle"    = "custom";
      "window.decorationStyle"  = "custom";
      "terminal.integrated.fontFamily" = "'JetBrainsMono Nerd Font Mono'";
      "files.autoSave"          = "afterDelay";
      "git.enableSmartCommit"   = true;
      "telemetry.telemetryLevel" = "off";
      "workbench.activityBar.location" = "top";
    };
  };
}
