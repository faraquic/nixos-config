{ config, pkgs, pkgs-unstable, inputs, lib, ... }:

{
  imports = [
    ./hyprland.nix
    ./waybar.nix
    ./apps.nix
    ./theme.nix
  ];

  home.username    = "faraquic";
  home.homeDirectory = "/home/faraquic";
  home.stateVersion  = "25.11";
  home.file.".ssh/id_rsa.pub".text = ''
  ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDhSxPJFvyO6uhBV4q3URVgRAvwUTX9K49R6XBcmWIoADvPXApm+8XI6I4ZK/Wap6h7GU2UAhcxcJWMSo7Uc67LB/D4LHIEa8CrTWoKSsh0IcmCvQPZWEpIwHlJPgcb8Mn4NlA353JMIo6ZMFns+evshjXbHS5PvDB+OHJ9SyBu59j6bTWNM89J1Ox8TlJk9L7KJD4t4Xpb+5XqTxYxUGHR1jLRx3+M/Za2dY4IRsc2BlE8Gf/x8xiQrDICYRKqp868cw1x5G6vDe+5TK2yLwF4iaYIJ0A9RsPLHG99e1vIIhJOypm9CLBXEc2tAx3lNdVpf9uawmwb3w7aH5GXpgvrh1gXjlNLD6dwWDVzHfkALT+zj4TBWpKevy45xUgZiJynrhV/lPOqxcE06s3VC1x1Gk72Y9Nx5L5BhVSZR/hR4R3tsm4gzJxfLzWJOje2ClD1E9GO+QnGSi7RkDmu7YNw94QmKT8YMq54OFMzfsjpmFx50eJM9Sj8fyLy3Pkyw/k= NiK@Arch
  '';

  programs.home-manager.enable = true;

  # User packages
  # Only packages that don't have a proper home-manager module.
  # Everything with a module is configured in the respective .nix file.
  home.packages = with pkgs; [
    # Terminal / shell
    starship # configured in apps.nix via programs.starship
    tmux
    eza fd ripgrep fzf bat delta jq
    glow duf dust bottom procs gping dogdns tealdeer sd choose xh zoxide
    ouch inxi

    # Desktop utilities
    brightnessctl
    playerctl
    pavucontrol
    libnotify

    # Screenshots & recording
    grim slurp swappy
    wl-screenrec
    hyprpicker

    # Clipboard stack
    wl-clipboard
    cliphist
    wl-clip-persist   # persists clipboard after app closes

    # Logout / lock (binaries — configs in hyprland.nix)
    wlogout

    # Image / document viewers
    imv
    zathura           # configured via programs.zathura in apps.nix

    # File manager (Thunar enabled at system level; Yazi configured in apps.nix)
    xfce.thunar

    # Media
    youtube-music

    # Developer GUI
    vscode

    # Containers (CLI tools — engine is Podman at system level)
    podman-compose

    gnupg
  ];

  # Session variables (user-level, merged with system ones)
  home.sessionVariables = {
    XCURSOR_THEME = "catppuccin-macchiato-dark-cursors";
    XCURSOR_SIZE  = "24";
  };

  # XDG default directories
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
      desktop     = "${config.home.homeDirectory}/Desktop";
      documents   = "${config.home.homeDirectory}/Documents";
      download    = "${config.home.homeDirectory}/Downloads";
      music       = "${config.home.homeDirectory}/Music";
      pictures    = "${config.home.homeDirectory}/Pictures";
      videos      = "${config.home.homeDirectory}/Videos";
      templates   = "${config.home.homeDirectory}/Templates";
      publicShare = "${config.home.homeDirectory}/Public";
    };
    mimeApps = {
      enable = true;
      defaultApplications = {
        "image/jpeg"                = [ "imv.desktop" ];
        "image/png"                 = [ "imv.desktop" ];
        "image/gif"                 = [ "imv.desktop" ];
        "image/webp"                = [ "imv.desktop" ];
        "application/pdf"           = [ "org.pwmt.zathura.desktop" ];
        "text/html"                 = [ "firefox.desktop" ];
        "x-scheme-handler/http"     = [ "firefox.desktop" ];
        "x-scheme-handler/https"    = [ "firefox.desktop" ];
        "inode/directory"           = [ "thunar.desktop" ];
        "video/mp4"                 = [ "mpv.desktop" ];
        "video/webm"                = [ "mpv.desktop" ];
      };
    };
  };
}
