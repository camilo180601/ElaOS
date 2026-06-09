FROM kalilinux/kali-rolling

# Entorno de construcción de ElaOS (live-build sobre Kali Rolling = Debian + arsenal Kali)
RUN apt-get update && apt-get install -y --no-install-recommends \
        live-build \
        debootstrap \
        ca-certificates \
        kali-archive-keyring \
        git \
        curl \
        xorriso \
        isolinux \
        syslinux-common \
        grub-efi-amd64-bin \
        grub-efi-arm64-bin \
        dosfstools \
        mtools \
        squashfs-tools \
        apt-utils \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /build
