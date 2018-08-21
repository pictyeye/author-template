MASTER=_master
FINALPDF=sstic-actes.pdf
SRC=$(MASTER).tex $(wildcard */*.tex)
LATEX?=pdflatex
LFLAGS?=-halt-on-error

BIB_MISSING = 'No file.*\.bbl|Citation.*undefined'
REFERENCE_UNDEFINED='(There were undefined references|Rerun to get (cross-references|the bars) right)'


# # ebook variables

# FINALHTML=$(FINALPDF:pdf=html)
# FINALEPUB=$(FINALHTML:html=epub)
# FINALAZW3=$(FINALHTML:html=azw3)
# FINALMOBI=$(FINALHTML:html=mobi)
# SRCEBK=$(MASTER)-ebook.tex $(wildcard */*.tex)
# HTLATEX=htlatex
# HTFLAGS?="xhtml,charset=utf-8" " -cunihtf -utf8"

# # ebook metadata
# CALFLAGS+=--book-producer STIC --publisher STIC
# CALFLAGS+=--series SSTIC2019 --language fr
# -include article/metadata.mk
# AUTHORS?=SSTIC
# CALFLAGS+=--authors $(AUTHORS)

# IMGPDFS=$(wildcard */img/*.pdf */img/**/*.pdf)
# IMGEPSS=$(foreach img, $(IMGPDFS), $(img:pdf=eps))
# IMGJPGS=$(wildcard */img/*.jpg */img/**/*.jpg)
# IMGPNGS=$(foreach img, $(IMGJPGS), $(img:jpg=png))



.PHONY: article actes clean targets export


# Generic targets
article: targets article.pdf

actes: $(FINALPDF)

clean:
	rm -f *.aux *.bbl *.blg *.dvi *.log *.ps *.lof *.toc *.glg *.gls
	rm -f *.ilg *.nlo *.nav *.snm *.glo *.glsmake *.ist *.out *.vrb *.lot *.idx *.ind
	rm -f $(MASTER).pdf $(FINALPDF)
	rm -f $(MASTER)-ebook.4ct $(MASTER)-ebook.4tc $(MASTER)-ebook.css
	rm -f $(MASTER)-ebook.idv $(MASTER)-ebook.lg $(MASTER)-ebook.tmp
	rm -f $(MASTER)-ebook.xref $(MASTER)-ebook.html
	rm -f $(FINALEPUB) $(FINALAZW3) $(FINALMOBI)
	rm -f *.tmp.tex *.tmp.aux *.tmp.log *.tmp.pdf standalone-targets


%.pdf: %.tex
	$(LATEX) $(LFLAGS) $<
	bibtex $(<:.tex=.aux) || true
	$(LATEX) $(LFLAGS) $<
	makeindex $(@:.pdf=.idx) || true
	@grep -Eqc $(BIB_MISSING) $(<:.tex=.log) && $(LATEX) $< > /dev/null ; true
	@grep -Eqc $(REFERENCE_UNDEFINED) $(<:.tex=.log) && $(LATEX) $< > /dev/null; true
	-grep --color '\(Warning\|Overful\).*' $(<:.tex=.log)

%.pdf: %.tmp.pdf
	gs -sOutputFile=$@ -sDEVICE=pdfwrite -dPDFSETTINGS=/prepress -dEmbedAllFonts=true -dCompatibilityLevel=1.6 $< < /dev/null



# Helpers for generic targets

article.tmp.tex: _standalone.tex
	sed 's/@@DIRECTORY@@/$(@:.tmp.tex=)/' _standalone.tex > $@


$(FINALPDF): $(MASTER).pdf
	gs -sOutputFile=$@ -sDEVICE=pdfwrite -dPDFSETTINGS=/prepress -dEmbedAllFonts=true -dCompatibilityLevel=1.6 $< < /dev/null

$(MASTER).pdf: $(SRC)



# Specific standalone targets

targets:
	@for d in [^_]*/; do if [ $$d != "article/" ]; then \
		i=$$(basename $$d); \
		echo "$$i.tmp.tex: _standalone.tex"; \
		echo "	sed 's/@@DIRECTORY@@/\$$(@:.tmp.tex=)/' _standalone.tex > \$$@"; \
		echo; \
		echo "$$i.tmp.pdf: $$i.tmp.tex $$(ls $$i/*.tex)"; \
		echo; \
		echo "$$i.pdf: $$i.tmp.pdf"; \
		echo "	gs -sOutputFile=\$$@ -sDEVICE=pdfwrite -dPDFSETTINGS=/prepress -dEmbedAllFonts=true -dCompatibilityLevel=1.6 $$< < /dev/null"; \
	fi; done > standalone-targets

-include standalone-targets




# # ebook targets

# $(FINALHTML): $(SRCEBK) $(IMGPNGS) $(IMGEPSS)
# 	$(HTLATEX) $(MASTER)-ebook.tex $(HTFLAGS)
# 	make LATEX=$(HTLATEX) LFLAGS="" $(MASTER)-ebook.bbl
# 	make full-ebook
# 	mv $(MASTER)-ebook.html $(FINALHTML)

# full-ebook: $(MASTER)-ebook.ind
# 	$(HTLATEX) $(MASTER)-ebook.tex $(HTFLAGS)
# 	-grep --color '\(Warning\|Overful\).*' $(MASTER)-ebook.log
# 	@grep -Eqc $(BIB_MISSING) $(MASTER)-ebook.log && $(HTLATEX) $(MASTER)-ebook.tex $(HTFLAGS) > /dev/null ; true
# 	@grep -Eqc $(REFERENCE_UNDEFINED) $(MASTER)-ebook.log && $(HTLATEX) $(MASTER)-ebook.tex $(HTFLAGS) > /dev/null; true

# %.bbl:
# 	bibtex $(@:.bbl=) ||true
# 	$(LATEX) $(LFLAGS) $(@:.bbl=.tex)

# %.ind:
# 	makeindex $(@:.ind=)

# %.eps: %.pdf
# 	pdftocairo -eps $< $@

# %.png: %.jpg
# 	convert $< $@

# $(IMGPNGS): $(IMGJPGS)
# $(IMGEPSS): $(IMGPDFS)

# %.epub: %.html
# 	ebook-convert $< $@ $(CALFLAGS)

# %.mobi: %.html
# 	ebook-convert $< $@ $(CALFLAGS)

# %.azw3: %.epub
# 	# ebook-convert doesn't rasterize svgs for azw3, but Kindle svg parser seems
# 	# buggy, so instead of doing html -> azw3 we do html -> epub -> azw3.
# 	ebook-convert $< $@ $(CALFLAGS)
