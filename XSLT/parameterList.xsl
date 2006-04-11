<?xml version="1.0" encoding="UTF-8" ?>

<!--===================== PARAMETER LISTS =========================-->

<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns="http://www.w3.org/1999/xhtml"
        xmlns:cml="http://www.xml-cml.org/schema"
	version="1.0">

<!-- cmlComa:parameterList -->
  <xsl:template match="cml:parameterList">
    <xsl:apply-templates select="@title"/>
    <table><xsl:apply-templates select="*"/></table>
  </xsl:template>
  
<!-- @title List -->
  <xsl:template match="@title">
    <div class="listTitle"><xsl:value-of select="."/></div>
  </xsl:template>

</xsl:stylesheet>
