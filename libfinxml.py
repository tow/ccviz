#!/usr/bin/python

# Take an XML document which is incomplete
# (ie otherwise well-formed, but doesn't close all its tags.)
# and complete it (ie close all its unclosed tags) so
# that it is well-formed.

# This is quick & dirty. We can't actually guarantee that the
# resultant document conforms to whatever DTD or schema it claims.

import sys
import xml.sax

tagStack = []

closingTags = ""

class DodgyHandler(xml.sax.ContentHandler):
    def startElement(self, tag, attributes):
	tagStack.append(tag)

    def endElement(self, tag):
	tagStack.pop()


class DodgyErrorHandler(xml.sax.ErrorHandler):
    def fatalError(self,exception):
        tagStack.reverse()
        msg = exception.getMessage()
        global closingTags
        if (msg == "no element found"):
            # We're in the middle of text
            pass
        elif (msg == "not well-formed (invalid token)"):
            # We have <tag\
            closingTags = ">"
        elif (msg == "unclosed token"):
            # We're anywhere in the middle of a tag. Hmm.
            # Try to recover with:
            closingTags = "/>"        
            # Still fails for:
            # a) <tag param    : we want to append =""/>
            # b) <tag param=   : we want to append ""/>
            # c) <tag param="  : we want to append "/>
            # d) <tag param='  : we want to append '/>
            # Conceivably we might try recovering by 
            # constructing each of these documents 
            # and then SAXing them. I'd rather not, though.
        for tag in tagStack:
            closingTags += "</%s>" % tag
        closingTags += "\n"
        return closingTags

def finishXML(text):
    global closingTags
    tagStack = []
    closingTags = ""

    p = xml.sax.make_parser()
    p.setContentHandler(DodgyHandler())
    p.setErrorHandler(DodgyErrorHandler())

    # A fiddle that'll work for siesta:
    # This tries to ensure we are between tags
    lastLine = text.pop()

    for line in text:
       p.feed(line)
    p.close()

    #print lastLine
    #print
    #print lastLine.rstrip()

    #text.append(lastLine.rstrip())
    text.append(closingTags)

def finishXMLFile(fileIn, fileOut):
    global closingTags
    tagStack = []
    closingTags = ""
    p = xml.sax.make_parser()
    p.setContentHandler(DodgyHandler())
    p.setErrorHandler(DodgyErrorHandler())

    for line in fileIn:
       fileOut.write(line)
       p.feed(line)
    p.close()

    fileOut.write(closingTags)
    fileOut.flush()
