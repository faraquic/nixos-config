{ config, pkgs, lib, ... }:

{
  # Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = false;
    # Proton-GE
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };

  # 32-bit Graphics
  hardware.graphics.enable32Bit = true;

  # GameMode
  programs.gamemode = {
    enable = true;
    enableRenice = true;
    settings = {
      general = {
        renice = 10;
        softrealtime = "auto";
        inhibit_screensaver = 1;
      };
      gpu = {
        apply_gpu_optimisations = "accept-responsibility";
        gpu_device = 1;
        nv_powermizer_mode = 1; # NVIDIA: Prefer Maximum Performance
      };
      cpu = {
        park_cores = "no";
        pin_cores = "yes";
      };
    };
  };

  environment.systemPackages = with pkgs; [
    vulkan-tools
    vulkan-validation-layers
    mangohud
    gamescope
  ];

  environment.sessionVariables = {
    DXVK_ASYNC                = "1";
    PROTON_FORCE_LARGE_ADDRESS_AWARE = "1";
    __GL_SYNC_TO_VBLANK = "0";
  };

  # Ulimit для Steam
  security.pam.loginLimits = [
    { domain = "@users"; item = "nofile"; type = "soft"; value = "1048576"; }
    { domain = "@users"; item = "nofile"; type = "hard"; value = "1048576"; }
  ];

  boot.kernel.sysctl = {
    "vm.swappiness" = 10;
    "net.core.rmem_max"         = 134217728;
    "net.core.wmem_max"         = 134217728;
    "net.ipv4.tcp_congestion_control" = "bbr";
  };
}
