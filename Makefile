COCCI_FILES = \
	api/SetRect.cocci \
	boolean/cond-false-true.cocci \
	boolean/cond-true-false.cocci \
	boolean/FAILED-SUCCEEDED.cocci \
	debug/debugstr_guid.cocci \
	debug/trace.cocci \
	casts/cast-NULL.cocci \
	casts/cast-zero.cocci \
	casts/makeparam.cocci \
	casts/selfcast.cocci \
	COM/method-forward.cocci \
	CONTAINING_RECORD.cocci \
	DllCanUnloadNow.cocci \
	register.cocci \
	string-not-empty.cocci \
	tests/ok.cocci

WINESRC = /home/michi/work/wine

OUTPUT_FILES = $(COCCI_FILES:.cocci=.out)

.SUFFIXES: .cocci .out

all: $(OUTPUT_FILES)

.cocci.out:
	./coccicheck $*.cocci $(WINESRC) >$*.out

clean:
	rm -f $(OUTPUT_FILES)
