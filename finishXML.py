#!/usr/bin/env python

import sys
from xml.parsers import expat

def finishXMLFile(filename):
    """
This function will read in a file which is a truncated well-formed XML file,
and fix it up at the end so that it is well-formed. 

What it does *not* do:
1) Cope with ill-formed files (ie files that could not be transformed into
   a well-formed file simply by appending characters)
2) Make any guarantees of the validitiy of the output file.

Known bugs:
1) If the file hasn't got a root element - or the root element opening
   tag is incomplete - this will not create one, so the result will
   be ill-formed. Probably this should throw an exception.
2) I think it's possible that where the file is Unicode, and the
   truncation happens halfway through a Unicode character, that the
   result will not be well-formed.
3) No checking is made that the input file is actually correct in its
   nearly-well-formedness.

Warning: this *overwrites* the file which is given to it (Done this
         way to save space since I am dealing with several-hundred
         megabyte files ...
"""

    tagStack = []
    def start(name, attributes): tagStack.append(name)
    def end(name): tagStack.pop()

    p = expat.ParserCreate()
    p.StartElementHandler = start
    p.EndElementHandler = end

    e = None
    fIn = open(filename,'r+')
    try:
        p.ParseFile(fIn)
    except expat.ExpatError, e:
        pass

    if not e: return

    fIn.seek(0, 0)

    for i in range(e.lineno-1): fIn.readline()
    lastLine = fIn.readline()

    fIn.seek(-len(lastLine), 1)
    fIn.truncate()

    lastLine = lastLine.rstrip() # for some reason python appends a newline
    if e.message.startswith("no element found"):
        # We're in a text section, carry on
        pass
    elif e.message.startswith("unclosed token"):
        # throw away the final token and finish
        lastLine = lastLine[:e.offset]
    elif e.message.startswith("unclosed CDATA section"):
        lastLine = lastLine + u']]>'
    elif e.message.startswith("not well-formed (invalid token)"):
        # We need to worry about where we are. These
        # are the possibilities
        if (lastLine[-1] == u'/'):
            # We have "<tagName /"
            lastLine = lastLine + u'>'
        elif (lastLine[-1] == u'<'):
            # We have simply "<"
            lastLine = lastLine[:-1]
        elif (lastLine[-1] == u'<'): 
            # We have "</t" with offset before the "<"
            lastLine = lastLine[:e.offset]
        elif (lastLine[-1] == u'!'):
            # We have "<!"
            lastLine = lastLine[:-2]
        elif (lastLine[-1] == u'-'):
             if (lastLine[-3:] == u'<!-'):
                 lastLine = lastLine[:-3]
             elif (lastLine[-4:] == u'<!--'):
                 lastLine = lastLine[:-4]
             else:
                 # We have "<!-- blah --"
                 lastLine = lastLine + u'>'
        elif (lastLine[-1] == u"A"):
            # We have "<![CDATA"
            lastLine = lastLine[:-8]
        elif (lastLine[-1] == u"?"):
            # We have "<?"
            lastLine = lastLine[:-2]

    fIn.write(lastLine)

    tagStack.reverse()
    for tag in tagStack:
       fIn.write("</"+tag+">")
    fIn.close()

if __name__ == '__main__':
    finishXMLFile(sys.argv[1])
