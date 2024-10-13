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

USER user
WORKDIR /home/user/prolog

ENTRYPOINT ["prologs"]
CMD ["-k", "-j4", "-O"]
