<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:stm="http://www.xml-cml.org/schema/stmml"
        xmlns="http://www.w3.org/1999/xhtml"
        exclude-result-prefixes="xsl stm"
        >

  <!-- For each entry in the dictionary -->
  <xsl:template match="stm:entry">
    <div class="dictAnchor">
      <a>
	<xsl:attribute name="name">
	  <xsl:value-of select="@id"/>
	</xsl:attribute>
      </a>
    </div>
    <div class="dictEntry"><xsl:value-of select="@term"/><xsl:text>:</xsl:text></div>
    <xsl:if test="stm:definition">
      <xsl:choose>
	<xsl:when test="//text()='definition to be supplied'">
	  <p><font color="blue"><xsl:value-of select="stm:definition"/></font></p>
	</xsl:when>
	<xsl:otherwise>
	  <div class="dictDefinition"><xsl:value-of select="stm:definition"/></div>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:if>
    <xsl:if test="stm:description">
      <xsl:copy-of select="stm:description/node()"/>
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
