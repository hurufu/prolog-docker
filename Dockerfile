FROM archlinux:latest

RUN pacman -Syu --noconfirm make
RUN pacman -S --noconfirm swi-prolog

RUN useradd -ms /bin/sh user
RUN install --owner=user --mode=750 -d /home/user/prolog

USER user
WORKDIR /home/user/prolog
COPY --chown=user Makefile test.pl .

ENTRYPOINT ["make"]
CMD ["all"]
