<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:cml="http://www.xml-cml.org/schema"
        xmlns="http://www.w3.org/1999/xhtml"
        exclude-result-prefixes="xsl cml"
        >

  <!-- For each entry in the dictionary -->
  <xsl:template match="cml:entry">
    <div class="dictAnchor">
      <a>
	<xsl:attribute name="name">
	  <xsl:value-of select="@id"/>
	</xsl:attribute>
      </a>
    </div>
    <div class="dictEntry">
      <xsl:choose>
	<xsl:when test="@term and @term!=''">
	  <xsl:value-of select="@term"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="@id"/>
	</xsl:otherwise>
    </xsl:choose>
    <xsl:text>:</xsl:text></div>
    <xsl:if test="cml:definition">
      <xsl:choose>
	<xsl:when test="//text()='definition to be supplied'">
	  <p><font color="blue"><xsl:value-of select="cml:definition"/></font></p>
	</xsl:when>
	<xsl:otherwise>
	  <div class="dictDefinition"><xsl:value-of select="cml:definition"/></div>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:if>
    <xsl:if test="cml:description">
      <xsl:copy-of select="cml:description/node()"/>
    </xsl:if>
    <hr/>
  </xsl:template>
  
  
  <!-- for each description just copy everything -->
  <!-- REM do the same for MathML stuff          -->
<!--  <xsl:template match="stm:description/@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template> -->


  
</xsl:stylesheet>
