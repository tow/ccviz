<?xml version="1.0" encoding="UTF-8" ?>

<!--===================== PARAMETERS =========================-->

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:cml="http://www.xml-cml.org/schema"
        xmlns="http://www.w3.org/1999/xhtml"
	>

  <xsl:template match="cml:parameter">
    <xsl:choose>
    
    <!-- If single parameter then place in a table -->
      <xsl:when test="not(parent::cml:parameterList)">
	<p/>
        <table>
	  <tr>
	    <xsl:if test="@name"><td><xsl:value-of select="@name"/></td></xsl:if>
	    <xsl:if test="@value"><td><xsl:value-of select="@value"/></td></xsl:if>
            <xsl:if test="cml:scalar"><xsl:apply-templates select="cml:scalar"/></xsl:if>
            <xsl:if test="cml:array"><xsl:apply-templates select="cml:array"/></xsl:if>
	    <xsl:if test="cml:matrix"><xsl:apply-templates select="cml:matrix"/></xsl:if>
          </tr>
        </table>
      </xsl:when>

    <!-- If parameter list then place all properties in a single table -->
      <xsl:otherwise>
        <tr>
	  <xsl:if test="@name"><td align="left" class="paramname"><xsl:value-of select="@name"/></td></xsl:if>
          <xsl:if test="@value"><td align="right" class="paramvalue">
	    <xsl:choose>
	      <xsl:when test="string(number(@value)) != 'NaN'">
	        <xsl:value-of select="format-number(@value, '0.0000')"/>
	      </xsl:when>
	      <xsl:otherwise>
	        <xsl:value-of select="@value"/>
	      </xsl:otherwise>
	    </xsl:choose>
	    </td>
	  </xsl:if>
          <xsl:if test="cml:scalar"><xsl:apply-templates select="cml:scalar"/></xsl:if>
          <xsl:if test="cml:array"><xsl:apply-templates select="cml:array"/></xsl:if>
          <xsl:if test="cml:matrix"><xsl:apply-templates select="cml:matrix"/></xsl:if>
        </tr>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
    
</xsl:stylesheet>
