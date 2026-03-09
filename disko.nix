{
  disko.devices = {
    disk = {
      # SSD (system)
      sda = {
        type = "disk";
        device = "/dev/sda";
        content = {
          type = "gpt";
          partitions = {

            ESP = {
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };

            cryptroot = {
              size = "100%";
              content = {
                type = "luks";
                name = "cryptroot";
                extraOpenArgs = [ "--perf-same_cpu_crypt" ];
                settings = {
                  allowDiscards = true;
                  bypassWorkqueues = true;
                };
                content = {
                  type = "btrfs";
                  extraArgs = [ "-L" "nixos" "-f" ];
                  subvolumes = {
                    "@" = {
                      mountpoint = "/";
                      mountOptions = [ "subvol=@" "noatime" "compress=zstd:1" "ssd" "space_cache=v2" "discard=async" "commit=60" ];
                    };
                    "@nix" = {
                      mountpoint = "/nix";
                      mountOptions = [ "subvol=@nix" "noatime" "compress=zstd:1" "ssd" "space_cache=v2" "discard=async" "commit=60" ];
                    };
                    "@var" = {
                      mountpoint = "/var";
                      mountOptions = [ "subvol=@var" "noatime" "compress=zstd:1" "ssd" "space_cache=v2" "discard=async" "commit=60" ];
                    };
                    "@log" = {
                      mountpoint = "/var/log";
                      mountOptions = [ "subvol=@log" "noatime" "ssd" "space_cache=v2" "discard=async" "nodatacow" ];
                    };
                    "@snapshots" = {
                      mountpoint = "/.snapshots";
                      mountOptions = [ "subvol=@snapshots" "noatime" "compress=zstd:1" "ssd" "space_cache=v2" "discard=async" "commit=60" ];
                    };
                  };
                };
              };
            };
          };
        };
      };

      # HDD (home)
      sdb = {
        type = "disk";
        device = "/dev/sdb";
        content = {
          type = "gpt";
          partitions = {
            crypthome = {
              size = "100%";
              content = {
                type = "luks";
                name = "crypthome";
                # keyFile is used only for NixOS boot auto-unlock.
                # On first disko run this file does not exist yet →
                # disko will prompt for a password. After install, add the keyfile
                # to LUKS slot 1 manually: cryptsetup luksAddKey /dev/sdb1 /etc/luks/crypthome.key
                settings = {
                  keyFile = "/etc/luks/crypthome.key";
                };
                content = {
                  type = "btrfs";
                  extraArgs = [ "-L" "home" "-f" ];
                  subvolumes = {
                    "@home" = {
                      mountpoint = "/home";
                      mountOptions = [ "subvol=@home" "noatime" "compress=zstd:3" "space_cache=v2" ];
                    };
                    "@home-snapshots" = {
                      mountpoint = "/home/.snapshots";
                      mountOptions = [ "subvol=@home-snapshots" "noatime" "compress=zstd:3" "space_cache=v2" ];
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}