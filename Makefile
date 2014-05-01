MASTER=_master
FINALPDF=sstic-actes.pdf
FINALHTML=$(FINALPDF:pdf=html)
SRC=$(MASTER).tex $(wildcard */*.tex)
SRCEBK=$(MASTER)-ebook.tex $(wildcard */*.tex)
LATEX?=pdflatex
HTLATEX=htlatex
LFLAGS?=-halt-on-error

IMGPDFS=$(wildcard */img/*.pdf)
IMGEPSS=$(foreach img, $(IMGPDFS), $(img:pdf=eps))
IMGJPGS=$(wildcard */img/*.jpg)
IMGPNGS=$(foreach img, $(IMGJPGS), $(img:jpg=png))

BIB_MISSING = 'No file.*\.bbl|Citation.*undefined'
REFERENCE_UNDEFINED='(There were undefined references|Rerun to get (cross-references|the bars) right)'

$(FINALPDF): $(SRC)
	$(LATEX) $(LFLAGS) $(MASTER).tex
	make $(MASTER).bbl
	make full
	gs -sOutputFile=$@ -sDEVICE=pdfwrite -dCompatibilityLevel=1.6 $(MASTER).pdf < /dev/null

$(FINALHTML): $(SRCEBK) $(IMGPNGS) $(IMGEPSS)
	$(HTLATEX) $(MASTER)-ebook.tex
	make LATEX=$(HTLATEX) LFLAGS="" $(MASTER)-ebook.bbl
	make full-ebook
	mv $(MASTER)-ebook.html $(FINALHTML)

full: $(MASTER).ind
	$(LATEX) $(LFLAGS) $(MASTER).tex
	-grep --color '\(Warning\|Overful\).*' $(MASTER).log
	@grep -Eqc $(BIB_MISSING) $(MASTER).log && $(LATEX) $(MASTER).tex > /dev/null ; true
	@grep -Eqc $(REFERENCE_UNDEFINED) $(MASTER).log && $(LATEX) $(MASTER).tex > /dev/null; true

full-ebook: $(MASTER)-ebook.ind
	$(HTLATEX) $(MASTER)-ebook.tex
	-grep --color '\(Warning\|Overful\).*' $(MASTER)-ebook.log
	@grep -Eqc $(BIB_MISSING) $(MASTER)-ebook.log && $(HTLATEX) $(MASTER)-ebook.tex > /dev/null ; true
	@grep -Eqc $(REFERENCE_UNDEFINED) $(MASTER)-ebook.log && $(HTLATEX) $(MASTER)-ebook.tex > /dev/null; true

%.bbl:
	bibtex $(@:.bbl=) ||true
	$(LATEX) $(LFLAGS) $(@:.bbl=.tex)

%.ind:
	makeindex $(@:.ind=)

README: $(SRC)
	@awk  '/^%% / { print substr($$0, 4)}' $(SRC) > $@

%.eps: %.pdf
	pdftocairo $< $@

%.png: %.jpg
	convert $< $@

$(IMGPNGS): $(IMGJPGS)
$(IMGEPSS): $(IMGPDFS)

.PHONY: snapshot clean
snapshot: $(FINALPDF)
	mv $(FINALPDF) "$(FINALPDF:.pdf=-$(shell git rev-parse HEAD').pdf)"

clean:
	rm -f *.aux *.bbl *.blg *.dvi *.log *.ps *.lof *.toc *.glg *.gls
	rm -f *.ilg *.nlo *.nav *.snm *.glo *.glsmake *.ist *.out *.vrb *.lot *.idx *.ind
	rm -f $(MASTER).pdf $(FINALPDF)
	rm -f *.html
