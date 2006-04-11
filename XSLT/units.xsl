<?xml version="1.0" encoding="UTF-8" ?>

<!--===================== @units =========================-->

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:cml="http://www.xml-cml.org/schema"
        xmlns="http://www.w3.org/1999/xhtml"
	>

  <xsl:template name="add.units">
    <xsl:choose>
      <xsl:when test="@units">
        <xsl:text> (</xsl:text><i><xsl:value-of select="@units"/></i><xsl:text>)</xsl:text>
      </xsl:when>
      <xsl:when test="child::*/@units">
        <xsl:text> (</xsl:text><i><xsl:value-of select="child::*/@units"/></i><xsl:text>)</xsl:text>
      </xsl:when>
    </xsl:choose>       
  </xsl:template>


  <xsl:template match="@units">
    <xsl:text> (</xsl:text><i><xsl:value-of select="."/></i><xsl:text>)</xsl:text>
  </xsl:template>
  
</xsl:stylesheet>
