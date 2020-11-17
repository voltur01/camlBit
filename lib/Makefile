include ../Makefile.conf

TARGETS := camlBit.elf camlBit.hex

all: $(TARGETS) camlBit.mli camlBit.cma

camlBit.mli: camlBit.ml
	CAMLLIB=$(LIB) $(OCAMLC) -I ../../OMicroB/lib/targets/microbit -i $< > $@

camlBit.cma: camlBit.cmo
	$(OCAMLC) -a $^ -o $@

$(TARGETS): camlBit.ml
	$(BIN)/omicrob -v -device=microbit $^ -o $@

clean:
	rm -f *.mli *.cmi *.cmo *.cma *.byte *.c *.arm_o *.elf *.arm_elf *.hex

docs:
	rm -f ../docs/camlBit/*
	CAMLLIB=$(LIB) ocamldoc -html -d ../docs/camlBit -I ../../OMicroB/lib/targets/microbit camlBit.ml 
	rm -f ../docs/stdlib/*
	CAMLLIB=$(LIB) ocamldoc -html -d ../docs/stdlib ../../OMicroB/src/stdlib/*.mli
