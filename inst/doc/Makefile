VIGS= corrplot-intro.html

all: $(VIGS)

clean:
	rm -rf *.md figure/

%.html: %.Rmd
	$(R_HOME)/bin/Rscript -e "if (getRversion() < '3.0.0') knitr::knit2html('$*.Rmd')"
