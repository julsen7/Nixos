# nixos-config

```bash
cfdisk gpt (512M EFI-Boot und rest linux filesystem) schreiben

sudo mkfs.vfat -F 32 -n boot /dev/nvme0n1p1
sudo mkfs.ext4 -F -L nixos /dev/nvme0n1p2

sudo mount /dev/vda2 /mnt
sudo mount --mkdir /dev/vda1 /mnt/boot

sudo nixos-install --flake github:julsen7/nixos-config#desktop --no-write-lock-file
```
