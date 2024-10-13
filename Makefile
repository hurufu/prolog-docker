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


# Docker image ################################################################
.PHONY: run build clean
run: build
	docker run -it $(DOCKER_TAG)
build: Dockerfile
	docker build --compress --tag $(DOCKER_TAG) .
Dockerfile: export PACKAGES := $(foreach v,$(addprefix AUR_,$(PROLOGS)),$($v))
Dockerfile: $(MAKEFILE_LIST)

clean: JUNK = $(wildcard pkgs repo Dockerfile)
clean:
	$(if $(JUNK),$(RM) -r $(JUNK))


# Prolog #####################################################################
.PHONY: $(PROLOGS) all
all: $(PROLOGS)

ciao: $(PROG)
	ciao run $<
gnu: $(PROG)
	env TRAILSZ=999999 GLOBALSZ=999999 gprolog --consult-file $< --query-goal '$(MAIN),halt'
scryer: $(PROG)
	scryer-prolog $< -g '$(MAIN),halt'
swi: $(PROG)
	swipl -l $< -g '$(MAIN),halt'
trealla: $(PROG)
	tpl $< -g '$(MAIN),halt'


# AUR packages ################################################################
.PHONY: repo aur-% git-%
repo: $(addprefix aur-,$(PROLOGS)) | repo/
	find pkgs -name '*.pkg.*' -exec mv --verbose '{}' $| '+'
aur-%: git-%
	env -C pkgs/$* ionice -c3 nice -n19 makepkg -sr
git-%: | pkgs/%/.git
	env -C pkgs/$* git pull
pkgs/%/.git: | pkgs/
	git clone https://aur.archlinux.org/$(AUR_$*).git $|$*


# Utils #######################################################################
%: %.in
	envsubst <$< >$@

%/:
	mkdir -p $@
