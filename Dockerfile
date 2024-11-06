FROM archlinux:base-devel AS construction-site
COPY 00-pacman-nopasswd /etc/sudoers.d/
RUN <<EOT
    pacman -Syu --noconfirm
    pacman -S --noconfirm git
    useradd -m builder
    chown builder /opt
    chmod 775 /opt
EOT

USER builder
WORKDIR /home/builder
COPY --chown=builder Makefile .
RUN <<EOT
    git config --global init.defaultBranch master
    make -j$(nproc) -O repo
EOT

FROM archlinux:base AS stage
ARG MYGROUP
ARG MYUSER
WORKDIR /var/cache/prolog
COPY --chmod=644 pacman.conf /etc
COPY --from=construction-site /home/builder/repo/* ./
RUN <<EOT
    repo-add prolog.db.tar.xz *.pkg.*
    pacman -Syu --noconfirm
    pacman -S --noconfirm prologs expac
    pacman -S --noconfirm --asdeps $(expac -1S "%n\n%o" prologs)
    pacman -Scc --noconfirm
    groupadd -g $MYGROUP user
    useradd -m -u $MYUSER -g $MYGROUP runner
EOT

USER runner
WORKDIR /home/user/prolog

LABEL org.opencontainers.image.authors="aur@asap.mozmail.com"

ENTRYPOINT ["prologs"]
CMD ["-k", "-j4", "-O" "-p 'ciao xsb'"]
