ADOC_FLAGS=--backend=html -B . -a linkcss -a stylesdir=nodir -a stylesheet=chrony.css -a docinfo1
ADOC_COMMAND=asciidoctor

FILES = $(patsubst %.adoc,output/%.html,$(wildcard *.adoc doc/*/*.adoc))
EXTRA_FILES = $(patsubst extra/%,output/%,$(wildcard extra/*.* extra/img/*.* extra/css/*.*))

all: output $(FILES) $(EXTRA_FILES)

output:
	mkdir -p $@

output/%.asc: extra/%.asc
	cp -p $< $@

output/css/%.css: extra/css/%.css
	mkdir -p `dirname $@`
	cp -p $< $@

output/img/%.png: extra/img/%.png
	mkdir -p `dirname $@`
	cp -p $< $@

output/%.html: %.adoc body-start.html process_html.sh
	mkdir -p `dirname $@`
	$(ADOC_COMMAND) $(ADOC_FLAGS) --out-file - $< | ./process_html.sh $* > $@

clean:
	rm -rf output
