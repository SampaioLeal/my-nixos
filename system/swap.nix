{ ... }:
{
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 25; # 8GB em 32GB RAM, sem hibernar
  };

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 4 * 1024; # 4GB overflow, era 8GB
    }
  ];
}
