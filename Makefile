# Program under test
PROG        ?= test.pl
# Default goal to run
MAIN        ?= test

DOCKER_TAG  := prolog-testbed

# All supported Prolog implementations (keep alphabetic order!)
PROLOGS     := ciao gnu scryer swi trealla

# Mappings from Prolog implementation name to AUR package name
AUR_ciao    := ciao-lang
AUR_gnu     := gprolog
AUR_scryer  := scryer-prolog
AUR_swi     := swi-prolog-git
AUR_trealla := trealla
AUR_prologs := prologs

PREFIX      ?= /usr/local
DESTDIR     ?= /
BINDIR      := $(DESTDIR)$(PREFIX)/bin


# Docker image ################################################################
.PHONY: run build clean
run: build
	docker run -v "$(PWD):/home/user/prolog" -it $(DOCKER_TAG)
build: Dockerfile
	docker build --compress --build-arg USER="$(shell id -u)" --build-arg GROUP="$(shell id -g)" --tag $(DOCKER_TAG) .

clean: JUNK = $(wildcard pkgs repo Dockerfile)
clean:
	$(if $(JUNK),$(RM) -r $(JUNK))


# AUR packages ################################################################
.PHONY: repo aur-% git-%
repo: $(addprefix aur-,$(PROLOGS)) aur-prologs | repo/
	find pkgs -name '*.pkg.*' -exec mv --verbose '{}' $| ';'
aur-%: git-%
	env -C pkgs/$* ionice -c3 nice -n19 makepkg -srCcf
git-%: | pkgs/%/.git
	env -C pkgs/$* git pull
pkgs/%/.git: | pkgs/
	git clone https://aur.archlinux.org/$(AUR_$*).git $|$*


# Utils #######################################################################
%/:
	mkdir -p $@
