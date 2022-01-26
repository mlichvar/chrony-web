ADOC_FLAGS=--backend=html -B . -a linkcss -a stylesdir=nodir -a stylesheet=chrony.css -a docinfo1
ADOC_COMMAND=asciidoctor
HOST_DIR=ssh.tuxfamily.org:chrony/chrony.tuxfamily.org-web/htdocs

FILES = $(patsubst %.adoc,output/%.html,$(wildcard *.adoc doc/*/*.adoc))
EXTRA_FILES = $(patsubst extra/%,output/%,$(wildcard extra/*.*))

all: output $(FILES) $(EXTRA_FILES)

output:
	mkdir -p $@

output/%.asc: extra/%.asc
	cp -p $< $@

output/%.css: extra/%.css
	cp -p $< $@

output/%.html: %.adoc body-start.html process_html.sh
	mkdir -p `dirname $@`
	$(ADOC_COMMAND) $(ADOC_FLAGS) --out-file - $< | ./process_html.sh $* > $@

upload:
	rsync -aP output/* $(HOST_DIR)

clean:
	rm -rf output
