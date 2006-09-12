#!/usr/bin/python

# Copyright (c) 2005, Toby White <tow21@cam.ac.uk>
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without 
# modification, are permitted provided that the following conditions 
# are met:
#
#     * Redistributions of source code must retain the above copyright 
# notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above 
# copyright notice, this list of conditions and the following disclaimer 
# in the documentation and/or other materials provided with the 
# distribution.
#     * The name of Toby White may not be used to endorse or promote 
# products derived from this software without specific prior written 
# permission.
#     * Any individuals or entities associated with the San Diego 
# Supercomputing Centre may not use, modify, or redistribute this code 
# in any form without the explicit permission of the copyright holder.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS 
# FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE 
# COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, 
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, 
# BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS 
# OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND 
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR 
# TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE 
# USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. 



import cgi
import cgitb; cgitb.enable()
import mimetypes
import os
import sys
import tempfile
import time
import urllib

import subProcess
import libfinxml

xsltproc = '/usr/bin/xsltproc'
xsltCommand = xsltproc + ' -o %(output)s %(style)s %(input)s >/dev/null'
defaultStylesheet='http://www.eminerals.org/XSLT/ccViz.xsl'

# Nothing below this line should be altered.
############################################

# CGI environment variables of interest.
thisServer = os.environ['SERVER_NAME']
thisPage = os.environ['SCRIPT_NAME']
if os.environ.has_key('HTTP_ACCEPT'):
    httpAccept = os.environ['HTTP_ACCEPT']
else:
    httpAccept = 'text/html'

# Check if user is using IE or other dumb browser
if httpAccept.find('application/xhtml+xml') > -1:
    contentType = "application/xhtml+xml"
else:
    contentType = 'text/html'
contentType = 'text/html'

# Templates for output file.
#########################################

header = """
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
  </head>
  <body>
"""

htmlForm = """
  <hr/>
  <div id="inputForms">
    <form method="get" action="%(thisPage)s" enctype="multipart/form-data" onsubmit="submitForm(this.id)" id="listForm">
      <table>
        <tr><td>XML file address</td><td><input name="xmlIn" value="" type="text"/></td></tr>
        <tr><td>XSLT stylesheet</td><td><input name="xsltSheet" value="%(xsltDefault)s" type="text"/>(leave blank for internal)</td></tr>
        <tr><td><input type="submit" value="SUBMIT"/></td><td><input value="CLEAR" type="reset"/></td></tr>
      </table>
    </form>
  </div>
  <hr/>
  <div>
    <form method="post" action="%(thisPage)s" enctype="multipart/form-data" onsubmit="submitForm(this.id)" id="putForm">
      <table>
        <tr><td>XML file to upload</td><td><input name="xmlUp" value="" type="file"/></td></tr>
        <tr><td>XSLT stylesheet</td><td><input name="xsltSheet" value="%(xsltDefault)s" type="text"/>(leave blank for internal)</td></tr>
        <tr><td><input value="SUBMIT" type="submit"/></td><td><input value="CLEAR" type="reset"/></td></tr>
      </table>
    </form>
  </div>
"""

footer = """
  </body>
</html>
"""

# Exception classes.
#########################################

class InputDataError(Exception):
    def __init__(self, value):
	self.value = value
    def __str__ (self):
	return self.value

class Page:
    def __init__(self, contentType='text/plain', status=200, statusmsg='OK'):
	self.headers = {}
	self.headers['Content-Type'] = contentType
	self.headers['Status'] = str(status)+' '+statusmsg
	self.contents = []

    def appendHeaders(self, headers):
	for key in headers:
	    self.headers[key] = headers[key]

    def append(self, line):
	self.contents.append(line)

    def write(self, output=sys.stdout):
	for key in self.headers:
	    output.write(key+': '+self.headers[key]+'\n')
	output.write('\n')
	for line in self.contents:
	    output.write(line+'\n')

def xmlEncode(string):
    tempstring = string.replace("&", '&amp;')
    tempstring = tempstring.replace('<', '&lt;')
    tempstring = tempstring.replace('"', '&quot;')
    tempstring = tempstring.replace("'", '&apos;')
    return tempstring

def errorPage(errorCode, errorString, explanation):
    page = Page(contentType, errorCode, errorString)
    page.append(header % {'title':'ERROR'})
    page.append("<p>Error:</p>")
    page.append("<p>Status " + str(errorCode) + ' ' + xmlEncode(errorString) + "</p>")
    page.append("<p>"+xmlEncode(explanation)+"</p>")
    page.append(footer)
    return page

def generate_form():
    page = Page(contentType)
    page.append(header)
    page.append(htmlForm % {'xsltDefault':'', 'thisPage':thisPage})
    page.append(footer)
    return page

def transformXML(inputFile, outputFile, stylesheet="default"):

    xmlFile = urllib.urlopen(inputFile)

    tfname = os.path.join(tmpDir, 'output.xml')
    tf = open(tfname, 'w')
    libfinxml.finishXMLFile(xmlFile, tf)
    tf.close()
    if stylesheet == "default":
        sys.stderr.write(xsltCommand % {'xsltproc':xsltproc,
                                        'output':outputFile,
                                        'style':'',
                                        'input':tfname })
        process = subProcess.subProcess(xsltCommand % 
                                         {'xsltproc':xsltproc,
                                          'output':outputFile,
                                          'style':'',
                                          'input':tfname })
        done = process.read(300) # 1 minute time out
        if done == 1:
            # we timed out.
            process.kill()
            errdata = 'xsltproc timeout'
        else:
            # we finished (for better or worse) & don't want to retry.
            outdata = process.outdata
            errdata = process.errdata
    process.cleanup()
    if process.sts != 0 or stylesheet != "default":
        # we have failed on the document's internal stylesheet, let's try again with the default:
        stylesheet = defaultStylesheet
        process = subProcess.subProcess(xsltCommand % 
                                         {'xsltproc':xsltproc,
                                          'output':outputFile,
                                          'style':stylesheet,
                                          'input':tfname })
        done = process.read(300) # 1 minute time out
        if done == 1:
            # we timed out.
            process.kill()
            errdata = 'xsltproc timeout'
        else:
            # we finished (for better or worse) & don't want to retry.
            outdata = process.outdata
            errdata = process.errdata
        process.cleanup()
        if process.sts != 0:
            raise OSError(errdata)
        sys.stderr.write(xsltCommand % {'xsltproc':xsltproc,
                                        'output':outputFile,
                                        'style':stylesheet,
                                        'input':tfname })
        sys.stderr.write(outdata)
        sys.stderr.write(errdata)
        os.unlink(tfname)
        os.rmdir(tmpDir)

def isXML(file):
    retval = os.system('xmllint '+file)
    return (retval == 0)

def main():
    if not (os.access(xsltproc, os.X_OK)):
        raise EnvironmentError('Bad server configuration - cannot find xsltproc')
    form = cgi.FieldStorage(keep_blank_values=True)
    if os.environ["REQUEST_METHOD"] == "GET":
        try: 
            xmlDoc = form['xmlIn'].value
        except KeyError:
            page = generate_form()
            return page
    elif os.environ["REQUEST_METHOD"] == "POST":
        try:
            postFile = form['xmlUp']
        except KeyError:
            page = generate_form()
            return page
        localFileName = os.path.join(tmpDir, 'postfile')
        fUp = open(localFileName, 'wb')
        while True:
            chunk = postFile.file.read(100000)
            if not chunk: break
            fUp.write (chunk)
        fUp.close()
        xmlDoc = localFileName
    try:
        xsltSheet = form['xsltSheet'].value
    except KeyError:
        xsltSheet = '' # We will use stylesheet specified in document.
    outFile = os.path.join(tmpDir, 'outputFile')
    transformXML(xmlDoc, outFile)
    #if xsltSheet == '': # then we know we will be getting xhtml
    #    contentType = 'application/xhtml+xml'
#    else:
        # unfortunately, 'file -i' - which should give us mimetypes
        # seems horribly broken wrt XML files. Therefore we will just
        # say text/plain & worry about it later.
    #    contentType = 'text/plain'
        # FIXME: we should do an xmllint to check for XML, and then
        # maybe also check for SVG & XHTML, and otherwise fall
        # back to file
    contentType = 'application/xhtml+xml'
    page = Page(contentType)
    fOpen = open(outFile)
    for line in fOpen:
        page.append(line)
    return page
    
# Main program.
#########################################

tmpDir = tempfile.mkdtemp()

try:
    page = main()
except OSError, inst:
    page= errorPage(400, 'XSLT failure', 'XSLT transform failed')
except InputDataError, inst:
    page = errorPage(400, 'Bad Request', 'Could not retrieve document xmlDoc')
    
# Clear up temporary files - all clean up is done here in one place.
for file in os.listdir(tmpDir):
    os.unlink(os.path.join(tmpDir,file))
os.rmdir(tmpDir)

page.write()
