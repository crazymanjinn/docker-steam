FROM crazymanjinn/archlinux-multilib:latest

RUN pacman -S --noconfirm \
        lib32-libpulse \
        lib32-nvidia-utils \
        lsb-release \
        nvidia-utils \
        pciutils \
        pulseaudio-alsa \
        steam && \
    pacman -Scc --noconfirm && \
    useradd -m user
    
USER user

ENTRYPOINT [ "steam" ]
