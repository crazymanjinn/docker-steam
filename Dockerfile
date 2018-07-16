FROM crazymanjinn/archlinux-multilib:latest

RUN pacman -S --noconfirm \
        lib32-libpulse \
        lsb-release \
        pciutils \
        pulseaudio-alsa \
        steam && \
    pacman -Scc --noconfirm && \
    useradd -m user
    
USER user
ENV LD_LIBRARY_PATH "/usr/lib:/usr/lib32:/h1_64:/h1_32"

ENTRYPOINT [ "steam" ]
