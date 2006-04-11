<?xml version="1.0" encoding="UTF-8" ?>

<!--===================== PROPERTY LISTS =========================-->

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:cml="http://www.xml-cml.org/schema"
        xmlns="http://www.w3.org/1999/xhtml"
        >

<!-- cmlComa:propertyList -->
  <xsl:template match="cml:propertyList">
   <xsl:apply-templates select="@title"/>
   <table class="propertyList">
    <xsl:for-each select="*">
     <tr><xsl:apply-templates select="."/></tr>
    </xsl:for-each>
   </table>
  </xsl:template>
  
<!-- @title List -->
  <xsl:template match="@title">
    <div class="listTitle"><xsl:value-of select="."/></div>
  </xsl:template>

</xsl:stylesheet>
