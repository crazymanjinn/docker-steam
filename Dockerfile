FROM crazymanjinn/archlinux-multilib:latest

RUN pacman -S --noconfirm \
        lsb_release \
        pciutils \
        pulseaudio-alsa \
        steam && \
    useradd -m user
    
USER user
ENV LD_LIBRARY_PATH "/usr/lib:/usr/lib32:/h1_63:/h1_32"

ENTRYPOINT [ "steam" ]
