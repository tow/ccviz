#/bin/make

default: ccViz

ccViz: ccViz.head XSLT
	cp ccViz.head ccViz
	(cd XSLT; for f in *.xsl; do echo "cat > \$$TMPDIR/$$f << EOF" >> ../ccViz; cat $$f >> ../ccViz; echo EOF >> ../ccViz; done)
	echo "\$$XSLTPROC -o \$$1.xhtml \$$TMPDIR/ccViz.xsl \$$1" >> ccViz

