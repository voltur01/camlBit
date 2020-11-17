include ../../Makefile.conf

TARGETS := buttons.elf buttons.hex

CAML_BIT_LIB := ../../lib

all: $(TARGETS)

$(TARGETS): buttons.ml
	$(BIN)/omicrob -v -mlopt -I -mlopt $(CAML_BIT_LIB) -device=microbit $(CAML_BIT_LIB)/camlBit.ml $^ -o $@

clean:
	rm -f *.cmi *.cmo *.byte *.c *.arm_o *.elf *.arm_elf *.hex
