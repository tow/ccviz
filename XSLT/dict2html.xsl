<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:stm="http://www.xml-cml.org/schema/stmml"
        xmlns="http://www.w3.org/1999/xhtml"
        >

  <xsl:import href="dictcommon.xsl"/>

  <xsl:output method="xml" version="1.0" encoding="UTF-8" 
    omit-xml-declaration="no" standalone="yes"
    doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
    doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
    indent="yes" media-type="application/xhtml+xml"/>

  <xsl:template match="/">
    <html>
      <head>
	<title><xsl:value-of select="/stm:dictionary/@title"/></title>
      </head>
    <body>
      <h1><xsl:value-of select="/stm:dictionary/@title"/></h1>
      <hr></hr>
      <xsl:apply-templates select="/stm:dictionary/stm:entry">
	<!-- need translate below to prevent separating upper & lower case entries -->
        <xsl:sort data-type="text" order="ascending" 
		  select="translate(@term,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
      </xsl:apply-templates>
    </body>
  </html>
</xsl:template>

</xsl:stylesheet>
