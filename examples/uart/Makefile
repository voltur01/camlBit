include ../../Makefile.conf

# set to >0 get OCaml bytecode interpreter tracing into UART
TRACE := 0

SOURCE := uart

TARGETS := $(SOURCE).elf $(SOURCE).hex

CAML_BIT_LIB := ../../lib

all: $(TARGETS)

$(TARGETS): $(SOURCE).ml
	$(BIN)/omicrob -trace $(TRACE) -stack-size 256 -heap-size 2048 -v -mlopt -I -mlopt $(CAML_BIT_LIB) -device=microbit $(CAML_BIT_LIB)/camlBit.ml $^ -o $@

clean:
	rm -f *.cmi *.cmo *.byte *.c *.arm_o *.elf *.arm_elf *.hex
