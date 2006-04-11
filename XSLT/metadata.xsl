<?xml version="1.0" encoding="UTF-8" ?>

<!--===================== METADATA =========================-->

<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns="http://www.w3.org/1999/xhtml"
        xmlns:cml="http://www.xml-cml.org/schema"
        >

  <xsl:template match="cml:metadataList">
    <xsl:if test="count(cml:metadata)&gt;0">
      <ul><xsl:apply-templates select="cml:metadata"/></ul>
    </xsl:if>
    <hr/>
  </xsl:template>

  <xsl:template match="cml:metadata">  
   <xsl:choose>
    <xsl:when test="parent::cml:metadataList">
     <li>
      <xsl:value-of select="@name"/><xsl:text>: </xsl:text>
      <i><xsl:value-of select="@content"/></i>
     </li>
    </xsl:when>
    <xsl:otherwise>
     <ul><li>
      <xsl:value-of select="@name"/><xsl:text>: </xsl:text>
      <i><xsl:value-of select="@content"/></i>
     </li></ul>
    </xsl:otherwise>
   </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
