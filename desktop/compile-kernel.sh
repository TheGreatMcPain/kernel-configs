#!/bin/sh
# RUN INSIDE KERNEL SOURCES
cd /usr/src/linux/

echo "* Reseting config"
rm -v .config

echo "* Running 'make defconfig'"
make defconfig

## CONFIGURE STAGE ##
echo "* Configuring"

# Kernel boot cmdline
./scripts/config --enable CONFIG_CMDLINE_BOOL
# 'acpi_enforce_resources=lax' = "Allows OpenRGB access to DRAM LEDS"
# 'amd_iommu=on' = "Enable AMD IOMMU"
# 'default_hugepagesz' = default hugepage size
# 'hugepagesz=1G' = 1 gigabyte hugepages
./scripts/config --set-str CONFIG_CMDLINE "acpi_enforce_resources=lax amd_iommu=on iommu=pt default_hugepagesz=2M hugepagesz=2M hugepages=0"

# Compiler is too new i guess
./scripts/config --disable CONFIG_WERROR

# Optimize
./scripts/config --disable CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE
./scripts/config --enable CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE_O3

# CPU governor
./scripts/config --enable CONFIG_CPU_FREQ_GOV_POWERSAVE

# AMD Ryzen (From Gentoo Wiki)
./scripts/config --enable CONFIG_X86_X2APIC
./scripts/config --enable CONFIG_X86_AMD_PLATFORM_DEVICE
./scripts/config --disable CONFIG_GENERIC_CPU
#./scripts/config --enable CONFIG_MK8
./scripts/config --enable CONFIG_MZEN3
./scripts/config --enable CONFIG_X86_AMD_PSTATE
./scripts/config --enable CONFIG_X86_AMD_FREQ_SENSITIVITY
./scripts/config --set-str CONFIG_EXTRA_FIRMWARE_DIR "/lib/firmware"
./scripts/config --set-str CONFIG_EXTRA_FIRMWARE "amd-ucode/microcode_amd_fam19h.bin"
./scripts/config --enable CONFIG_IOMMU_SUPPORT
./scripts/config --enable CONFIG_AMD_IOMMU
./scripts/config --enable CONFIG_AMD_IOMMU_V2
# ./scripts/config --enable CONFIG_SENSORS_K10TEMP # Using zenpower3
./scripts/config --module CONFIG_SENSORS_IT87
./scripts/config --module CONFIG_SENSORS_LM75
./scripts/config --enable CONFIG_AMD_PMC


# AMD's crypto co-processor
./scripts/config --enable CONFIG_CRYPTO_DEV_CCP
./scripts/config --enable CONFIG_CRYPTO_DEV_CCP_DD
./scripts/config --enable CONFIG_CRYPTO_DEV_SP_CCP
./scripts/config --enable CONFIG_CRYPTO_DEV_CCP_CRYPTO
./scripts/config --enable CONFIG_CRYPTO_DEV_SP_PSP

# Enable BFQ
./scripts/config --enable CONFIG_IOSCHED_BFQ

# Alternate CPU scheduler (liquorix-sources)
./scripts/config --enable CONFIG_SCHED_ALT
./scripts/config --enable CONFIG_SCHED_PDS

# Actually get a console
./scripts/config --enable CONFIG_FB
./scripts/config --enable CONFIG_FB_EFI
#./scripts/config --enable CONFIG_FB_SIMPLE
#./scripts/config --enable CONFIG_SYSFB_SIMPLEFB
./scripts/config --enable CONFIG_FRAMEBUFFER_CONSOLE
./scripts/config --enable CONFIG_IPMI_HANDLER
./scripts/config --enable CONFIG_DRM_FBDEV_EMULATION

# Network block device (useful for qemu image mounting)
./scripts/config --module CONFIG_BLK_DEV_NBD

# Intel 2.5gigabit Eth
./scripts/config --enable CONFIG_IGC

# Intel Wi-Fi 6
./scripts/config --module CONFIG_IWLWIFI
./scripts/config --module CONFIG_IWLDVM
./scripts/config --module CONFIG_IWLMVM

# NVME Storage
./scripts/config --enable CONFIG_BLK_DEV_NVME
./scripts/config --enable CONFIG_NVME_MULTIPATH
./scripts/config --enable CONFIG_NVME_HWMON

# /proc/config.gz
./scripts/config --enable CONFIG_IKCONFIG
./scripts/config --enable CONFIG_IKCONFIG_PROC

# Compress kernel (ZSTD)
./scripts/config --disable CONFIG_KERNEL_GZIP
./scripts/config --enable CONFIG_KERNEL_ZSTD

# Tickless kernel
./scripts/config --disable CONFIG_NO_HZ_IDLE
./scripts/config --enable CONFIG_NO_HZ_FULL

./scripts/config --disable CONFIG_HZ_1000
./scripts/config --enable CONFIG_HZ_300

# low-latency
./scripts/config --disable CONFIG_PREEMPT_VOLUNTARY
./scripts/config --enable CONFIG_PREEMPT

# Transparent Huge Pages
./scripts/config --enable CONFIG_TRANSPARENT_HUGEPAGE

# BPF subsystem
./scripts/config --enable CONFIG_BPF_SYSCALL
./scripts/config --enable CONFIG_BPF_JIT
./scripts/config --enable CONFIG_BPF_JIT_ALWAYS_ON

# Compressed cache for swap pages
./scripts/config --enable CONFIG_ZSWAP
./scripts/config --disable CONFIG_ZSWAP_COMPRESSOR_DEFAULT_LZO
./scripts/config --enable CONFIG_ZSWAP_COMPRESSOR_DEFAULT_ZSTD
./scripts/config --disable CONFIG_ZSWAP_ZPOOL_DEFAULT_ZBUD
./scripts/config --enable CONFIG_ZSWAP_ZPOOL_DEFAULT_ZSMALLOC
./scripts/config --enable CONFIG_ZSWAP_DEFAULT_ON

# Enable Contiguous Memory Allocator (Allows Dynamic Hugepages)
./scripts/config --enable CONFIG_CMA

# Compressed RAM block device
./scripts/config --module CONFIG_ZRAM

# Enable systemd (openrc is already enabled)
./scripts/config --enable CONFIG_GENTOO_LINUX_INIT_SYSTEMD

# For proton and Steam Runtime
./scripts/config --enable CONFIG_USER_NS
./scripts/config --enable CONFIG_USER_NS_UNPRIVILEGED

# dm-crypt
./scripts/config --enable CONFIG_DM_CRYPT
./scripts/config --enable CONFIG_CRYPTO_XTS
./scripts/config --enable CONFIG_CRYPTO_USER_API_SKIPHER

# dm-cache
./scripts/config --enable CONFIG_DM_CACHE

# TCP Congestion control (Use BBR2 like liquorix config)
./scripts/config --enable CONFIG_TCP_CONG_BBR2
./scripts/config --disable CONFIG_DEFAULT_CUBIC
./scripts/config --enable CONFIG_DEFAULT_BBR2

# RCU Subsystem (make similar to liquorix config)
./scripts/config --enable CONFIG_RCU_EXPERT
./scripts/config --enable CONFIG_RCU_BOOST
./scripts/config --set-val CONFIG_RCU_BOOST_DELAY 97
./scripts/config --enable CONFIG_RCU_EXP_KTHREAD
./scripts/config --enable CONFIG_RCU_NOCB_CPU

# Enable Multi-Gen LRU
./scripts/config --enable CONFIG_LRU_GEN
./scripts/config --enable CONFIG_LRU_GEN_ENABLED

# Filesystems
./scripts/config --enable CONFIG_BTRFS_FS
./scripts/config --enable CONFIG_BTRFS_FS_POSIX_ACL
./scripts/config --enable CONFIG_EXFAT_FS
./scripts/config --enable CONFIG_NTFS3_FS
./scripts/config --enable CONFIG_NTFS3_LZX_XPRESS
./scripts/config --enable CONFIG_UDF_FS
./scripts/config --module CONFIG_FUSE_FS
./scripts/config --module CONFIG_VIRTIO_FS
./scripts/config --module CONFIG_CIFS
./scripts/config --enable CONFIG_CIFS_XATTRS
./scripts/config --enable CONFIG_CIFS_UPCALL
./scripts/config --enable CONFIG_CIFS_DFS_UPCALL
./scripts/config --enable CONFIG_CIFS_SWN_UPCALL

# 32-bit abi (Not sure if this improves 32bit programs)
./scripts/config --enable CONFIG_X86_X32_ABI

# Audio devices
./scripts/config --module CONFIG_SND_USB_AUDIO
./scripts/config --module CONFIG_SND_HDA_INTEL
./scripts/config --module CONFIG_SND_HDA_CODEC_REALTEK
#./scripts/config --module CONFIG_SND_HDA_CODEC_ANALOG
#./scripts/config --module CONFIG_SND_HDA_CODEC_SIGMATEL
#./scripts/config --module CONFIG_SND_HDA_CODEC_VIA
./scripts/config --module CONFIG_SND_HDA_CODEC_HDMI
#./scripts/config --module CONFIG_SND_HDA_CODEC_CIRRUS
#./scripts/config --module CONFIG_SND_HDA_CODEC_CS8409
#./scripts/config --module CONFIG_SND_HDA_CODEC_CONEXANT
#./scripts/config --module CONFIG_SND_HDA_CODEC_CA0110
#./scripts/config --module CONFIG_SND_HDA_CODEC_CA0132
#./scripts/config --module CONFIG_SND_HDA_CODEC_CMEDIA
#./scripts/config --module CONFIG_SND_HDA_CODEC_SI3054
#./scripts/config --module CONFIG_SND_HDA_GENERIC

./scripts/config --module CONFIG_SND_ALOOP

# QEMU
./scripts/config --enable CONFIG_KVM
./scripts/config --enable CONFIG_KVM_AMD
./scripts/config --enable CONFIG_VHOST_NET
./scripts/config --enable CONFIG_NET_CORE
./scripts/config --enable CONFIG_TUN
./scripts/config --enable CONFIG_IPV6
./scripts/config --enable CONFIG_BRIDGE

# libvirt
./scripts/config --enable CONFIG_BRIDGE_EBT_MARK_T
./scripts/config --enable CONFIG_BRIDGE_NF_EBTABLES
./scripts/config --enable CONFIG_NETFILTER_ADVANCED
./scripts/config --enable CONFIG_NETFILTER_XT_CONNMARK
./scripts/config --enable CONFIG_NETFILTER_XT_TARGET_CHECKSUM
./scripts/config --enable CONFIG_IP6_NF_NAT
./scripts/config --enable CONFIG_BRIDGE_EBT_T_NAT
./scripts/config --enable CONFIG_NET_ACT_POLICE
./scripts/config --enable CONFIG_NET_CLS_FW
./scripts/config --enable CONFIG_NET_CLS_U32
./scripts/config --enable CONFIG_NET_SCH_HTB
./scripts/config --enable CONFIG_NET_SCH_INGRESS
./scripts/config --enable CONFIG_NET_SCH_SFQ
./scripts/config --module CONFIG_VFIO
./scripts/config --module CONFIG_VFIO_PCI
./scripts/config --module CONFIG_VFIO_MDEV

# Docker
./scripts/config --enable CONFIG_MEMCG
./scripts/config --module CONFIG_VETH
./scripts/config --module CONFIG_BRIDGE_NETFILTER
./scripts/config --module CONFIG_NETFILTER_XT_MATCH_IPVS
./scripts/config --enable CONFIG_MEMCG_SWAP
./scripts/config --enable CONFIG_BLK_DEV_THROTTLING
./scripts/config --enable CONFIG_CFS_BANDWIDTH
./scripts/config --module CONFIG_IP_VS
./scripts/config --enable CONFIG_IP_VS_PROTO_TCP
./scripts/config --enable CONFIG_IP_VS_PROTO_UDP
./scripts/config --enable CONFIG_IP_VS_NFCT
./scripts/config --module CONFIG_IP_VS_RR
./scripts/config --module CONFIG_VXLAN
./scripts/config --module CONFIG_IPVLAN
./scripts/config --module CONFIG_MACVLAN
./scripts/config --module CONFIG_DUMMY
./scripts/config --module CONFIG_OVERLAY_FS
./scripts/config --module CONFIG_IP_NF_TARGET_REDIRECT

# TPM
./scripts/config --module CONFIG_TCG_TPM
./scripts/config --enable CONFIG_HW_RANDOM_TPM
./scripts/config --module CONFIG_TCG_TIS
./scripts/config --module CONFIG_TCG_CRB

# PCIstub
./scripts/config --module CONFIG_PCI_STUB

# Remove intel graphics
./scripts/config --disable CONFIG_DRM_I915

# X11
./scripts/config --enable CONFIG_INPUT_MOUSEDEV

# Ckb
./scripts/config --module CONFIG_INPUT_UINPUT

# OpenRGB
./scripts/config --module CONFIG_I2C_CHARDEV
./scripts/config --module CONFIG_I2C_PIIX4
./scripts/config --module CONFIG_I2C_NVIDIA_GPU

# Bluez
./scripts/config --module CONFIG_BT
./scripts/config --module CONFIG_BT_RFCOMM
./scripts/config --enable CONFIG_BT_RFCOMM_TTY
./scripts/config --module CONFIG_BT_BNEP
./scripts/config --enable CONFIG_BT_BNEP_MC_FILTER
./scripts/config --enable CONFIG_BT_BNEP_PROTO_FILTER
./scripts/config --module CONFIG_BT_HIDP
./scripts/config --module CONFIG_CRYPTO_USER_API_SKCIPHER
./scripts/config --module CONFIG_CRYPTO_USER
./scripts/config --module CONFIG_CRYPTO_USER_API_AEAD
./scripts/config --enable CONFIG_KEY_DH_OPERATIONS
./scripts/config --module CONFIG_BT_HCIBTUSB
./scripts/config --module CONFIG_BT_HCIUART

echo "* Updating config via 'make olddefconfig'"
make olddefconfig

## END CONFIGURE ##
## START COMPILE ##

echo "* Building kernel"
NPROC=$(nproc)
NPROC_PLUG_ONE=$((NPROC+1))
make -j$NPROC_PLUG_ONE -l$NPROC

echo "* Installing modules"
make modules_install

echo "* Compiling external kernel-modules"
emerge -1v @module-rebuild

## END COMPILE ##
## START INITRAMFS ##

echo "* Creating initramfs via dracut"

dracut --add crypt-gpg \
	--hostonly \
	--force \
	--kver $(make kernelrelease) \
	--no-early-microcode \
	--no-compress \
	--install "/usr/local/bin/vfio-pci-override.sh" \
	--force-drivers "vfio-pci " \
	--kernel-cmdline "rd.luks.key=/ryzen-key.gpg:UUID=E18E-2029 rd.luks.allow-discards" \
	/boot/initramfs.cpio

echo "* Add initramfs into kernel"
./scripts/config --set-str CONFIG_INITRAMFS_SOURCE "/boot/initramfs.cpio"
make olddefconfig
make -j$NPROC_PLUG_ONE -l$NPROC

## END INITRAMFS ##

echo "* Installing kernel"
make install

echo "* Updating grub.cfg"
grub-mkconfig -o /boot/grub/grub.cfg
