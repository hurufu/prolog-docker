DOCKER_TAG  := prolog-testbed

# All supported Prolog implementations
PACKAGES    :=
PACKAGES    += prologs
PACKAGES    += ciao-lang xsb-prolog gprolog scryer-prolog swi-prolog-git
PACKAGES    += eclipse-clp bprolog binprolog trealla
PACKAGES    += dogelog-node projog tau-prolog tuprolog poplog-git

# Docker image ################################################################
.PHONY: run build clean
run: build
	docker run -v "$(PWD):/home/user/prolog" -it $(DOCKER_TAG)
build: Dockerfile
	docker build --progress=plain --compress --build-arg MYUSER="$(shell id -u)" --build-arg MYGROUP="$(shell id -g)" --tag $(DOCKER_TAG) .

clean: JUNK = $(wildcard pkgs repo)
clean:
	$(if $(JUNK),$(RM) -r $(JUNK))


# AUR packages ################################################################
.PHONY: repo aur-% git-%
.PRECIOUS: pkgs/%/.git
repo: $(addprefix aur-,$(PACKAGES)) | repo/
	find pkgs -name '*.pkg.*' -exec mv --verbose '{}' $| ';'
aur-%: git-%
	env -C pkgs/$* ionice -c3 nice -n19 makepkg -srCc --noconfirm
git-%: | pkgs/%/.git
	env -C pkgs/$* git pull
pkgs/%/.git: | pkgs/
	git clone https://aur.archlinux.org/$*.git $|$*


# Utils #######################################################################
%/:
	mkdir -p $@
