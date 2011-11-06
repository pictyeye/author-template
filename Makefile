MASTER=_master
FINALPDF=sstic-actes.pdf
SRC=$(wildcard */*.tex)
LATEX=pdflatex
LFLAGS=-halt-on-error

BIB_MISSING = 'No file.*\.bbl|Citation.*undefined'
REFERENCE_UNDEFINED='(There were undefined references|Rerun to get (cross-references|the bars) right)'

$(FINALPDF): $(MASTER).tex $(SRC)
	$(LATEX) $(LFLAGS) $(MASTER).tex
	make full
	mv $(MASTER).pdf $(FINALPDF)

full: $(MASTER).ind
	$(LATEX) $(LFLAGS) $(MASTER).tex | grep --color 'LaTeX Warning.*'
	@grep -Eqc $(BIB_MISSING) $(MASTER).log && $(LATEX) $(MASTER).tex > /dev/null ; true
	@grep -Eqc $(REFERENCE_UNDEFINED) $(MASTER).log && $(LATEX) $(MASTER).tex > /dev/null; true

%.ind:
	makeindex $(MASTER)

.PHONY: snapshot clean
snapshot: $(FINALPDF)
	mv $(FINALPDF) "$(FINALPDF:.pdf=-$(shell git rev-parse HEAD').pdf)"

clean:
	rm -f *.aux *.bbl *.blg *.dvi *.log *.ps *.lof *.toc *.glg *.gls
	rm -f *.ilg *.nlo *.nav *.snm *.glo *.glsmake *.ist *.out *.vrb *.lot *.idx *.ind
	rm -f $(MASTER).pdf $(FINALPDF)
