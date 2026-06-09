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
        dosfstools \
        mtools \
        squashfs-tools \
        apt-utils \
    && ARCH="$(dpkg --print-architecture)" \
    && if [ "$ARCH" = "amd64" ]; then \
           apt-get install -y --no-install-recommends \
               isolinux syslinux-common grub-pc-bin grub-efi-amd64-bin; \
       else \
           apt-get install -y --no-install-recommends grub-efi-arm64-bin; \
       fi \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /build
