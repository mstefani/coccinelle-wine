COCCI_FILES = \
	casts/cast-NULL.cocci \
	casts/cast-zero.cocci \
	DllCanUnloadNow.cocci \
	FAILED-SUCCEEDED.cocci

WINESRC = /home/michi/work/wine

OUTPUT_FILES = $(COCCI_FILES:.cocci=.out)

.SUFFIXES: .cocci .out

all: $(OUTPUT_FILES)

.cocci.out:
	./coccicheck $*.cocci $(WINESRC) >$*.out

clean:
	rm -f $(OUTPUT_FILES)
