DOCKER_TAG  := prolog-testbed

# All supported Prolog implementations
PACKAGES    := ciao-lang gprolog scryer-prolog swi-prolog-git trealla prologs
PACKAGES    += eclipse-clp bprolog binprolog poplog-git

# Docker image ################################################################
.PHONY: run build clean
run: build
	docker run -v "$(PWD):/home/user/prolog" -it $(DOCKER_TAG)
build: repo Dockerfile
	docker build --compress --build-arg USER="$(shell id -u)" --build-arg GROUP="$(shell id -g)" --tag $(DOCKER_TAG) .

clean: JUNK = $(wildcard pkgs repo)
clean:
	$(if $(JUNK),$(RM) -r $(JUNK))


# AUR packages ################################################################
.PHONY: repo aur-% git-%
repo: $(addprefix aur-,$(PACKAGES)) | repo/
	find pkgs -name '*.pkg.*' -exec mv --verbose '{}' $| ';'
aur-%: git-%
	-env -C pkgs/$* ionice -c3 nice -n19 makepkg -srCc
git-%: | pkgs/%/.git
	env -C pkgs/$* git pull
pkgs/%/.git: | pkgs/
	git clone https://aur.archlinux.org/$*.git $|$*


# Utils #######################################################################
%/:
	mkdir -p $@
