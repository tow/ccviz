#/bin/make

default: ccViz

ccViz: ccViz.head XSLT
	cp ccViz.head ccViz
	echo "cat > \$$TMPXSLTDIR/finishXML.py << \"EOF\"" >> ccViz
	cat finishXML.py >> ccViz
	echo EOF >> ccViz
	(cd XSLT; for f in *.xsl *.xml; do echo "cat > \$$TMPXSLTDIR/$$f << \"EOF\"" >> ../ccViz; cat $$f >> ../ccViz; echo EOF >> ../ccViz; done)
	echo "cp \"\$$1\" \$$TMPXSLTDIR/in.xml; python \$$TMPXSLTDIR/finishXML.py \$$TMPXSLTDIR/in.xml; \$$XSLTPROC -o \"\$$(basename \$$1 .xml).xhtml\" \$$TMPXSLTDIR/display.xsl \$$TMPXSLTDIR/in.xml; rm -rf \$$TMPXSLTDIR" >> ccViz
	chmod +x ccViz

clean:
	rm ccViz

