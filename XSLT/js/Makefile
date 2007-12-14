.SUFFIXES:
.SUFFIXES: .packed .js

flot.pack.js: jquery.packed excanvas.pack.esc jquery.flot.packed
	cat jquery.js jquery.flot.js > flot.js
	$(PACKER) flot.js > flot.pack.js

flot.pack.esc: flot.pack.js
	sed -e "s/&/\&amp;/g;s/</\&lt;/g;s/>/\&gt;/g;s/\"/\&quot;/g;s/'/\&apos;/" < $< > $@

excanvas.pack.esc: excanvas.pack.js
	sed -e "s/&/\&amp;/g;s/</\&lt;/g;s/>/\&gt;/g;s/\"/\&quot;/g;s/'/\&apos;/" < $< > $@
