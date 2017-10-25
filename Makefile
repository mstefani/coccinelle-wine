COCCI_FILES = \
	api/CopyRect.cocci \
	api/EqualRect.cocci \
	api/InflateRect.cocci \
	api/IsRectEmpty.cocci \
	api/OffsetRect.cocci \
	api/SetRect.cocci \
	api/VariantInit.cocci \
	boolean/cond-false-true.cocci \
	boolean/cond-true-false.cocci \
	boolean/FAILED-SUCCEEDED.cocci \
	debug/critsect.cocci \
	debug/debugstr_aw.cocci \
	debug/debugstr_guid.cocci \
	debug/trace.cocci \
	debug/wine_dbgstr_rect.cocci \
	casts/cast-NULL.cocci \
	casts/cast-zero.cocci \
	casts/makeparam.cocci \
	casts/selfcast.cocci \
	COM/COM-aggregation.cocci \
	COM/COM-sanity.cocci \
	COM/LPJUNK.cocci \
	COM/method-forward.cocci \
	COM/method-use.cocci \
	DllCanUnloadNow.cocci \
	mem/memset.cocci \
	mem/redundant_null_check.cocci \
	mem/register.cocci \
	misc/ARRAY_SIZE.cocci \
	misc/CONTAINING_RECORD.cocci \
	misc/redundant-check-before-set.cocci \
	string-not-empty.cocci \
	tests/broken.cocci \
	tests/ok.cocci

WINESRC = /home/michi/work/wine

OUTPUT_FILES = $(COCCI_FILES:.cocci=.out)
DIFF_FILES = $(COCCI_FILES:.cocci=.diff)

.SUFFIXES: .cocci .out .diff

all: $(OUTPUT_FILES)

diff: $(DIFF_FILES)

.cocci.out:
	./coccicheck --try-report $*.cocci $(WINESRC) >$*.out

.cocci.diff:
	./coccicheck $*.cocci $(WINESRC) >$*.diff

clean:
	rm -f $(OUTPUT_FILES) $(DIFF_FILES)

reportcheck:
	for i in $(COCCI_FILES); do grep -q '^virtual report' $$i || echo "Missing report mode for $$i"; done
