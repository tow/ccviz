#/bin/make

default: ccViz

XSLT/dictionaries.xml: dictionaries
	echo "<cml xmlns=\"http://www.xml-cml.org/schema\">" > XSLT/dictionaries.xml
	for i in dictionaries/*.xml; do sed -e 1d $$i >> XSLT/dictionaries.xml; done
	echo "</cml>" >> XSLT/dictionaries.xml

ccViz: ccViz.head XSLT XSLT/dictionaries.xml
	cp ccViz.head ccViz
	echo "cat > \$$TMPXSLTDIR/finishXML.py << \"EOF\"" >> ccViz
	cat finishXML.py >> ccViz
	echo EOF >> ccViz
	(cd XSLT; for f in *.xsl dictionaries.xml; do echo "cat > \$$TMPXSLTDIR/$$f << \"EOF\"" >> ../ccViz; cat $$f >> ../ccViz; echo EOF >> ../ccViz; done)
	echo "cp \"\$$1\" \$$TMPXSLTDIR/in.xml; python \$$TMPXSLTDIR/finishXML.py \$$TMPXSLTDIR/in.xml; \$$XSLTPROC -o \"\$$(basename \$$1 .xml).xhtml\" \$$TMPXSLTDIR/display.xsl \$$TMPXSLTDIR/in.xml; rm -rf \$$TMPXSLTDIR" >> ccViz
	chmod +x ccViz

clean:
	rm ccViz

