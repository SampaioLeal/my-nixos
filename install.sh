nix-shell -p git vim

git clone https://github.com/SampaioLeal/my-nixos
cd my-nixos

HOSTNAME=workstation

cp -r hosts/default hosts/$HOSTNAME

nixos-generate-config --show-hardware-config > hosts/$HOSTNAME/hardware-configuration.nix