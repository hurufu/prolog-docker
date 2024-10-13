FROM archlinux:latest

RUN pacman -Syu --noconfirm expac

COPY pacman.conf /etc
COPY repo /var/cache/prolog
WORKDIR /var/cache/prolog
RUN repo-add prolog.db.tar.xz *.pkg.*

RUN pacman -Sy --noconfirm prologs
RUN pacman -S --noconfirm --needed --asdeps $(expac -1S "%n\n%o" prologs)

ARG USER
ARG GROUP

RUN groupadd -g $GROUP user
RUN useradd -ms /bin/sh -u $USER -g user user

COPY --chmod=0755  Makefile /usr/share/prologs/rules.mk

USER user
WORKDIR /home/user/prolog

ENTRYPOINT ["remake"]
CMD ["-f/usr/share/prologs/rules.mk", "-k", "-j4", "-O", "--profile", "all"]
