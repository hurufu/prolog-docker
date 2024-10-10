# Program under test
PROG        ?= test.pl
# Default goal to run
MAIN        ?= test

DOCKER_TAG  := prolog-testbed
PROLOGS     := ciao gnu trealla scryer swi

# Mappings from Prolog implementation name to AUR package name
AUR_ciao    := ciao-lang
AUR_gnu     := gprolog
AUR_trealla := trealla
AUR_scryer  := scryer-prolog
AUR_swi     := swi-prolog-devel

###############################################################################
.PHONY: run build
run: build
	docker run -it $(DOCKER_TAG)
build: Dockerfile
	docker build --tag $(DOCKER_TAG) .
Dockerfile: export PACKAGES := $(foreach v,$(addprefix AUR_,$(PROLOGS)),$($v))
Dockerfile: $(MAKEFILE_LIST)
%: %.in
	envsubst <$< >$@


##############################################################################
.PHONY: $(PROLOGS) all
all: $(PROLOGS)

ciao: $(PROG)
	ciao run $<
gnu: $(PROG)
	env TRAILSZ=999999 GLOBALSZ=999999 gprolog --consult-file $< --query-goal '$(MAIN),halt'
trealla: $(PROG)
	tpl $< -g '$(MAIN),halt'
scryer: $(PROG)
	scryer-prolog $< -g '$(MAIN),halt'
swi: $(PROG)
	swipl -l $< -g '$(MAIN),halt'


###############################################################################
.PHONY: repo aur-% git-%
repo: $(addprefix aur-,$(filter-out swi,$(PROLOGS)))
	find pkgs -name '*.pkg.*' -exec mv '{}' repo '+'
aur-%: git-%
	env -C pkgs/$(AUR_$*) ionice -c3 nice -n19 makepkg -srCc
git-%:
	env -C pkgs git clone https://aur.archlinux.org/$(AUR_$*).git
