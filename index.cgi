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
import urllib

import subProcess
import finishXML

xsltproc = '/usr/bin/xsltproc'
xsltCommand = xsltproc + ' -o %(output)s %(style)s %(input)s >/dev/null'
defaultStylesheet='/var/www/cmlcomp/XSLT/ccViz.xsl'

# Nothing below this line should be altered.
############################################

# CGI environment variables of interest.
thisServer = os.environ['SERVER_NAME']
thisPage = os.environ['SCRIPT_NAME']
thisPage = 'http://CMLComp.org/ccViz/'
if os.environ.has_key('HTTP_ACCEPT'):
    httpAccept = os.environ['HTTP_ACCEPT']
else:
    httpAccept = 'text/html'

# Check if user is using IE or other dumb browser
if httpAccept.find('application/xhtml+xml') > -1:
    contentType = "application/xhtml+xml"
else:
    contentType = 'text/html'

# Templates for output file.
#########################################

header = """<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>ccViz: CMLComp Visualizer</title>
    <link rel="shortcut icon" href="/CMLComp.ico" type="image/vnd.microsoft.icon"/>
    <link rel="stylesheet" type="text/css" href="/style.css"/>
  </head>
  <body>
    <p><object type="image/png" data="/CMLComp.logo.png"><h1>CMLComp</h1></object></p>
    <h2><span class="smallcaps">ccViz</span>: <span class="smallcaps">CMLComp</span> Visualizer</h2>
"""

htmlForm = """
  <p>Choose a CML file below, and press <strong>Visualize</strong>.</p>
  <div id="inputForms">
    <form method="post" action="%(thisPage)s" enctype="multipart/form-data" onsubmit="submitForm(this.id)" id="putForm">
        <p><span class="smallcaps">CMLComp</span> file: <input name="xmlUp" value="" type="file"/></p>
        <p><input value="Visualize" type="submit"/></p>
    </form>
  </div>
"""

footer = """
  <div>
    <p>Alternatively, there is a standalone <span class="smallcaps">ccViz</span> viewer which does not require web access. It will only work on Unix or Mac OS X systems: <a href="ccViz">download the executable here</a> and run it from the command line like so:<br />
<tt>./ccViz CompCMLfile.xml</tt><br />
A file named <tt>CompCMLfile.xhtml</tt> will be produced, which can be viewed locally using Firefox.</p>
</div>
  </body>
</html>
"""

# Exception classes.
#########################################

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
    page.append("<div class='error'><p>Error:</p>")
    page.append("<p>Status " + str(errorCode) + ' ' + xmlEncode(errorString) + "</p>")
    page.append("<p>"+xmlEncode(explanation)+"</p></div>")
    page.append(footer)
    return page

def generate_form():
    page = Page(contentType)
    page.append(header)
    page.append(htmlForm % {'xsltDefault':'', 'thisPage':thisPage})
    page.append(footer)
    return page

def transformXML(inputFile, outputFile):
    stylesheet = defaultStylesheet
    runThisCommand = xsltCommand % {'xsltproc':xsltproc,
                                    'output':outputFile,
                                    'style':stylesheet,
                                    'input':inputFile }
    print >> sys.stderr, runThisCommand
    process = subProcess.subProcess(runThisCommand)
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
    sys.stderr.write(outdata)
    sys.stderr.write(errdata)
    if process.sts != 0:
        raise OSError(errdata)

def main():
    global contentType
    if contentType == 'text/html':
        return errorPage(406, 'Bad browser', "Sorry, but ccViz requires an XML-capable browser, and yours isn't. Try using Firefox or Opera.")
    if not (os.access(xsltproc, os.X_OK)):
        raise EnvironmentError('Bad server configuration - cannot find xsltproc')
    form = cgi.FieldStorage(keep_blank_values=True)
    if os.environ["REQUEST_METHOD"] == "GET":
        page = generate_form()
        return page
    elif os.environ["REQUEST_METHOD"] == "POST":
        try:
            postFile = form['xmlUp']
        except KeyError:
            page = generate_form()
            return page
    global tmpDir
    tmpDir = tempfile.mkdtemp()
    localFileName = os.path.join(tmpDir, 'postfile')
    outputFileName = os.path.join(tmpDir, 'output')
    fUp = open(localFileName, 'wb')
# FIXME Ought to put a check in here to prevent DOS attacks
    while True:
        chunk = postFile.file.read(100000)
        if not chunk: break
        fUp.write (chunk)
    fUp.close()
    finishXML.finishXMLFile(localFileName)
    # Transform should never fail on a valid XML document,
    # and the above should never be invalid
    # Alternatively: make a fifo with input from outputFileName
    # As long as this succeeds:
    transformXML(localFileName, outputFileName)
    contentType = 'application/xhtml+xml'
    fOpen = open(outputFileName)
    print 'Content-Type: application/xhtml+xml'
    print 'Status: 200 OK'
    print 
    # then hook up output to stdout here ...
    for line in fOpen:
        print line,
    return None
    
# Main program.
#########################################

tmpDir = ""

try:
    page = main()
except OSError, inst:
    page = errorPage(400, 'XSLT failure', 'XSLT transform failed')
    
if page: page.write()
# Clear up temporary files - all clean up is done here in one place.
if (os.access(tmpDir, os.X_OK)):
    for file in os.listdir(tmpDir):
        os.unlink(os.path.join(tmpDir,file))
    os.rmdir(tmpDir)

