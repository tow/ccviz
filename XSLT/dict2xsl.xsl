<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:stm="http://www.xml-cml.org/schema/stmml"
        xmlns="http://www.w3.org/1999/xhtml"
        >

  <xsl:import href="dictcommon.xsl"/>

  <xsl:output method="xml" version="1.0" encoding="UTF-8" 
    omit-xml-declaration="no" standalone="yes"
    indent="yes" media-type="text/xsl"/>

  <xsl:template match="/">
    <xsl:element name="xsl:stylesheet" namespace="http://www.w3.org/1999/XSL/Transform">
      <xsl:attribute name="version">1.0</xsl:attribute>
 <!--      <xsl:attribute name="xmlns">http://www.w3.org/1999/xhtml</xsl:attribute> -->
      <xsl:element name="xsl:template" namespace="http://www.w3.org/1999/XSL/Transform">
	<xsl:attribute name="name">addDict</xsl:attribute>
	<xsl:apply-templates select="//stm:entry">
	  <!-- need translate below to prevent separating upper & lower case entries -->
	  <xsl:sort data-type="text" order="ascending" 
		    select="translate(@term,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
	</xsl:apply-templates>
      </xsl:element>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>
