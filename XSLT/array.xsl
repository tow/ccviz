<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:str="http://exslt.org/strings"
        xmlns="http://www.w3.org/1999/xhtml"
        xmlns:cml="http://www.xml-cml.org/schema"
        extension-element-prefixes="str">

  <xsl:import href="loop.xsl"/>

  <xsl:template match="cml:kpoint" mode="eigen">
    <div><i><xsl:text>k</xsl:text></i><xsl:text>-point at: (</xsl:text>
    <xsl:for-each select="str:tokenize(@coords)">
      <xsl:value-of select="format-number(., '0.0000')"/>
      <xsl:if test="position()!=last()">
	<xsl:text>,</xsl:text>
      </xsl:if>
    </xsl:for-each>
    <xsl:text>) with weight </xsl:text><xsl:value-of select="@weight"/></div>
  </xsl:template>

  <xsl:template match="cml:property" mode="eigen">
    <table><tr>
      <xsl:call-template name="rows-for-loop">
	<xsl:with-param name="i" select="1"/>
	<xsl:with-param name="increment" select="1"/>
	<xsl:with-param name="testValue" select="ceiling(cml:array/@size div 8)"/>
	<xsl:with-param name="innerTestValue" select="8"/>
	<xsl:with-param name="outputString" select="concat(normalize-space(cml:array/text()),' ')"/>
      </xsl:call-template>
      </tr></table>
  </xsl:template>

  <xsl:template match="cml:array">
    <xsl:variable name="delimiter">
      <xsl:choose>
        <xsl:when test="@delimiter">
          <xsl:value-of select="@delimiter"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="' '"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <p><br/></p>
    <table class="prop2">
      <tr>
        <xsl:for-each select="str:tokenize(text(),$delimiter)">
	  <td>
	    <xsl:choose>
              <xsl:when test="ceiling(.) = floor(.) and not(contains(.,'.'))">
	        <xsl:value-of select="."/>
	      </xsl:when>
	      <xsl:when test="string(number(.)) != 'NaN'">
	        <xsl:value-of select="format-number(., '0.0000')"/>
	      </xsl:when>
	      <xsl:otherwise>
	        <xsl:value-of select="."/>
              </xsl:otherwise>
            </xsl:choose>	        
	  </td>
        </xsl:for-each>
      </tr>
    </table>
  </xsl:template>

</xsl:stylesheet>
