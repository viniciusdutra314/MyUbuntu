echo "change_password" | sudo cryptsetup open /dev/nvme0n1p3 my_encrypted_partition --key-file=-
mount --mkdir /dev/mapper/my_encrypted_partition /mnt
btrfs subvolume create /mnt/@
mv /mnt/* /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@tmp
btrfs subvolume create /mnt/@log
btrfs subvolume create /mnt/@cache
mv /mnt/@/home/* /mnt/@home/
mv /mnt/@/tmp/* /mnt/@tmp/
mv /mnt/@/var/cache/* /mnt/@cache/
mv /mnt/@/var/log/* /mnt/@log/
umount /mnt
