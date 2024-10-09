TAG     := prolog-testbed
PROG    ?= test.pl
MAIN    ?= main(_)
PROLOGS := gnu scryer swi

.PHONY: $(PROLOGS) run build all
run: build
	docker run -it $(TAG)
build:
	docker build --tag $(TAG) .

all: $(PROLOGS)

ciao: $(PROG)
	ciao run $<
gnu: $(PROG)
	env TRAILSZ=999999 GLOBALSZ=999999 gprolog --consult-file $< --query-goal '$(MAIN),halt'
scryer: $(PROG)
	scryer-prolog $< -g '$(MAIN),halt'
swi: $(PROG)
	swipl -l $< -g '$(MAIN),halt'
