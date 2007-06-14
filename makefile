#/bin/make

default: ccViz

ccViz: ccViz.head XSLT
	cp ccViz.head ccViz
	(cd XSLT; for f in *.xsl *.xml; do echo "cat > \$$TMPXSLTDIR/$$f << \"EOF\"" >> ../ccViz; cat $$f >> ../ccViz; echo EOF >> ../ccViz; done)
	echo "\$$XSLTPROC -o \"\$$(basename \$$1 .xml).xhtml\" \$$TMPXSLTDIR/display.xsl \"\$$1\"; rm -rf \$$TMPXSLTDIR" >> ccViz
	chmod +x ccViz

clean:
	rm ccViz

