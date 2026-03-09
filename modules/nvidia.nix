{ config, pkgs, lib, ... }:

{
  # Proprietary NVIDIA driver
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    # Kernel Modesetting — REQUIRED for Wayland
    modesetting.enable = true;

    # Power management (for desktop — turn off):
    powerManagement.enable = false;
    powerManagement.finegrained = false;

    # Enable settings via the nvidia-settings GUI:
    nvidiaSettings = true;

    # Open nuclear modules (experimental, NOT recommended for Pascal):
    open = false;
  };

  # Graphics + 32-bit (for games via Proton/Wine)
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [ nvidia-vaapi-driver libva-vdpau-driver libvdpau-va-gl ];
    extraPackages32 = with pkgs.pkgsi686Linux; [  ];
  };

  # Environment variables for NVIDIA + Wayland
  environment.sessionVariables = {
    # Force NVIDIA for Wayland (Hyprland)
    LIBVA_DRIVER_NAME   = "nvidia";
    GBM_BACKEND         = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    WLR_NO_HARDWARE_CURSORS   = "1"; # if the cursor disappears in Hyprland
    # Electron applications (VSCode, Discord) on Wayland:
    NIXOS_OZONE_WL      = "1";
    # XWayland scaling (optional):
    # XWAYLAND_NO_GLAMOR = "0";
  };


  # Packages related to NVIDIA:
  environment.systemPackages = with pkgs; [
    nvidia-vaapi-driver
    nvtopPackages.nvidia # GPU monitoring
    vulkan-tools         # vulkaninfo
    vulkan-loader
    mesa-demos
  ];
}