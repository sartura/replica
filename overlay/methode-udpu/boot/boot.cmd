test -n "${distro_bootpart}" || setenv distro_bootpart 1
part uuid ${devtype} ${devnum}:${distro_bootpart} uuid
setenv bootargs "root=PARTUUID=${uuid} rw rootwait earlycon"
setenv fdtfile "marvell/armada-3720-uDPU.dtb"

if load ${devtype} ${devnum}:${distro_bootpart} ${kernel_addr_r} /boot/Image; then
  if load ${devtype} ${devnum}:${distro_bootpart} ${fdt_addr_r} /boot/dtbs/${fdtfile}; then
    if load ${devtype} ${devnum}:${distro_bootpart} ${ramdisk_addr_r} /boot/initramfs-linux.img; then
      booti ${kernel_addr_r} ${ramdisk_addr_r}:${filesize} ${fdt_addr_r};
    else
      booti ${kernel_addr_r} - ${fdt_addr_r};
    fi;
  fi;
fi
