FROM crazymanjinn/archlinux:multilib-devel as builder

RUN mkdir /tmp/pkgs && \
    gpg --keyserver pgp.mit.edu --recv-keys 8876CC8EDAEC52CEAB7742E778E2387015C1205F && \
    mv /root/.gnupg /.gnupg && \
    chown -R nobody:nobody /.gnupg && \
    sudo -u nobody git clone https://aur.archlinux.org/linux-steam-integration.git && \
    pushd linux-steam-integration && \
    sudo -u nobody makepkg -sf --noconfirm && \
    pacman -U --noconfirm linux-steam-integration-*-x86_64.pkg.tar.xz && \
    mv linux-steam-integration-*-x86_64.pkg.tar.xz /tmp/pkgs && \
    popd

RUN pacman -S --noconfirm \
        expac \
        pacman-contrib && \
    pactree -l linux-steam-integration | \
    xargs expac '%f' -S | \
    xargs -I%% find /var/cache/pacman/pkg -name '%%' -exec mv '{}' /tmp/pkgs \;


FROM crazymanjinn/archlinux:multilib

COPY --from=builder /tmp/pkgs/*.pkg.tar.xz /tmp/pkgs/
COPY --from=crazymanjinn/su-exec:latest /su-exec/* /tmp/pkgs/
RUN pacman -U --noconfirm \
        /tmp/pkgs/*.pkg.tar.xz && \
    pacman -S --noconfirm \
        lib32-libpulse \
        lib32-nvidia-utils \
        lsb-release \
        nvidia-utils \
        pciutils \
        pulseaudio-alsa \
        steam \
        steam-native-runtime && \
    cp /tmp/pkgs/entrypoint.sh /usr/local/bin && \
    rm -rf /tmp/pkgs && \
    yes | pacman -Scc

ENTRYPOINT [ "entrypoint.sh" ]
CMD [ "lsi-steam" ]
