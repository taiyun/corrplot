# Makefile to use knitr for package vignettes
	
HTMLS= index.html

all: $(HTMLS) 

clean:
	rm -f *.md *.bbl *.blg *.aux *.out *.log *.png  *.tex

%.html: %.Rmd
	$(R_HOME)/bin/Rscript -e "library(knitr); library(corrplot); knit2html('$*.Rmd')"
	
	
	
PDFS= corrplot-intro.pdf

all: $(PDFS) 
	
%.pdf: %.Rnw
	$(R_HOME)/bin/Rscript -e "library(knitr); knit2pdf('$*.Rnw')"	
	