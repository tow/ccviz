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
            <td>
              <xsl:if test="@name"><xsl:value-of select="@name"/></xsl:if>
              <xsl:call-template name="get.dictionary.reference.html">
                <xsl:with-param name="dictRef" select="@dictRef"/>
                <xsl:with-param name="title" select="@name"/>
              </xsl:call-template>
            </td>
            <td><xsl:if test="@value"><xsl:value-of select="@value"/></xsl:if></td>
            <xsl:if test="cml:scalar"><xsl:apply-templates select="cml:scalar"/></xsl:if>
            <xsl:if test="cml:array"><xsl:apply-templates select="cml:array"/></xsl:if>
	    <xsl:if test="cml:matrix"><xsl:apply-templates select="cml:matrix"/></xsl:if>
          </tr>
        </table>
      </xsl:when>

    <!-- If parameter list then place all properties in a single table -->

      <xsl:otherwise>
        <tr>

    <!-- The parameter name *should* be in a name attribute - I think
         sometimes it may come out in title, so we check below. That
         option will be removed later on, since FoX never does that. -->

        <td class="paramname" align="left">
          <xsl:if test="@name"><xsl:value-of select="@name"/></xsl:if>
          <xsl:text> : </xsl:text>
          <xsl:call-template name="get.dictionary.reference.html">
            <xsl:with-param name="dictRef" select="@dictRef"/>
            <xsl:with-param name="title" select="@name"/>
          </xsl:call-template>
        </td>

    <!-- The parameter value *should* be in a scalar/array/matrix child.
         Sometimes it is in the value attribue though, so we check below
         That option will be removed later on since FoX never does that. -->

          <td align="right" class="paramvalue">
            <xsl:choose>
              <xsl:when test="@value">
              <!-- When it is in @value, we can't tell the datatype unless we try: -->
                <xsl:choose>
	          <xsl:when test="string(number(@value)) != 'NaN'">
	            <xsl:value-of select="format-number(@value, '0.0000')"/>
	          </xsl:when>
	          <xsl:otherwise>
	            <xsl:value-of select="@value"/>
	          </xsl:otherwise>
	        </xsl:choose>
              </xsl:when>
              <xsl:otherwise>
                <xsl:if test="cml:scalar"><xsl:apply-templates select="cml:scalar"/></xsl:if>
                <xsl:if test="cml:array"><xsl:apply-templates select="cml:array"/></xsl:if>
                <xsl:if test="cml:matrix"><xsl:apply-templates select="cml:matrix"/></xsl:if>
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
    
  <xsl:template match="cml:parameterList">
    <xsl:apply-templates select="@title"/>
    <table><xsl:apply-templates select="*"/></table>
  </xsl:template>
  
<!-- @title List -->
  <xsl:template match="@title">
    <div class="listTitle"><xsl:value-of select="."/></div>
  </xsl:template>

</xsl:stylesheet>
