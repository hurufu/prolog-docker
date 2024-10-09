TAG     := prolog-testbed
PROG    ?= test.pl
MAIN    ?= test
PROLOGS := swi

.PHONY: $(PROLOGS) run build all
run: build
	docker run -it $(TAG)
build:
	docker build --tag $(TAG) .

all: $(PROLOGS)

swi: $(PROG)
	swipl -l $< -g '$(MAIN),halt'
