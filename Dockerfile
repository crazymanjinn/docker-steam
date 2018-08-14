FROM crazymanjinn/archlinux:multilib-devel as builder

RUN git clone https://aur.archlinux.org/linux-steam-integration.git && \
    cd linux-steam-integration && \
    gpg --keyserver hkps.pool.sks-keyservers.net --recv-keys 8876CC8EDAEC52CEAB7742E778E2387015C1205F && \
    makepkg -sf --noconfirm


FROM crazymanjinn/archlinux:multilib

COPY --from=builder /var/cache/pacman/pkg /var/cache/pacman/pkg
RUN pacman -S --noconfirm \
        lib32-libpulse \
        lib32-nvidia-utils \
        lsb-release \
        nvidia-utils \
        pciutils \
        pulseaudio-alsa \
        steam \
        steam-native-runtime

COPY --from=builder /home/builduser/linux-steam-integration/linux-steam-integration-*-x86_64.pkg.tar.xz /tmp/pkgs/
COPY --from=crazymanjinn/su-exec:latest /home/builduser/su-exec/su-exec-*-x86_64.pkg.tar.xz /tmp/pkgs/
RUN pacman -U --noconfirm /tmp/pkgs/*.pkg.tar.xz && \
    rm -rf /tmp/pkgs && \
    yes | pacman -Scc

COPY ./entrypoint.sh /usr/local/bin
ENTRYPOINT [ "entrypoint.sh" ]
CMD [ "lsi-steam" ]
