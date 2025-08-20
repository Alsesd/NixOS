{
  #config,
  pkgs,
  ...
}: {
  # 1. Kernel & IOMMU support
  boot.kernelParams = [
    "intel_iommu=on" # or "amd_iommu=on" for AMD CPUs
    "iommu=pt"
  ];

  # 2. QEMU / KVM / libvirt
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true; # gives you the GUI

  # 3. USB-passthrough helpers
  environment.systemPackages = with pkgs; [
    usbutils # lsusb
    qemu_full # full QEMU with USB 3.0 support
  ];
  users.users.alsesd.extraGroups = ["libvirtd"];
}
