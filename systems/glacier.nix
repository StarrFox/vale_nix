{ config, modulesPath, unstable-pkgs, ...  }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    tmpOnTmpfs = true;
    tmpOnTmpfsSize = "75%";

    initrd.availableKernelModules = [
      "nvme"
      "xhci_pci"
      "ahci"
      "usbhid"
      "usb_storage"
      "sd_mod"
    ];
    initrd.kernelModules = [];

    kernelModules = ["kvm-amd"];
    extraModulePackages = [];

    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    kernelPackages = unstable-pkgs.linuxPackages_latest;
  };

  # NOTE: Despite the name, this option is for Wayland too.
  services.xserver.videoDrivers = ["nvidia"];

  hardware = {
    cpu.amd.updateMicrocode = true;

    opengl.enable = true;

    nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
    nvidia.modesetting.enable = true;
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/182bb213-c166-4288-8065-8d20378acf88";
    fsType = "ext4";
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/DB14-A397";
    fsType = "vfat";
  };
  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/7edab4b6-ed9a-482a-8ab8-d9476342fea0";
    fsType = "ext4";
  };

  swapDevices = [];

  networking = {
    hostName = "glacier";

    useDHCP = false;
    interfaces.wlp35s0.useDHCP = true;

    networkmanager.enable = true;
  };

  nixpkgs.hostPlatform = "x86_64-linux";
}
