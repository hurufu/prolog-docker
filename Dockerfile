FROM archlinux:latest

COPY pacman.conf /etc
COPY repo /var/cache/prolog
WORKDIR /var/cache/prolog
RUN repo-add prolog.db.tar.xz *.pkg.*

RUN pacman -Syu --noconfirm make swi-prolog gprolog scryer-prolog ciao-lang

RUN useradd -ms /bin/sh user
RUN install --owner=user --mode=750 -d /home/user/prolog/repo

USER user
WORKDIR /home/user/prolog
COPY --chown=user Makefile test.pl .

ENTRYPOINT ["make"]
CMD ["all"]
