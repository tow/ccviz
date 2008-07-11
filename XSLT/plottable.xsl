<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
        xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:cml="http://www.xml-cml.org/schema"
        xmlns:str="http://exslt.org/strings"
        extension-element-prefixes="str"
	>

  <xsl:template match="cml:module[@role='plottable']">
    <!-- We expect there to be multiple arrays in here.
    The first is a list of x values; the others are all
    sets of y-values to be independently plotted. -->
    <xsl:variable name="x-values">
      <xsl:call-template name="get-array-as-javascript-array">
        <xsl:with-param name="text-input" select="cml:property[1]/cml:array/text()"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="y-values">
      <xsl:text>[</xsl:text>
      <xsl:for-each select="cml:property[position()!=1]/cml:array">
	<xsl:text>{ "name":"</xsl:text><xsl:value-of select="../@dictRef"/><xsl:text>", "units":"</xsl:text><xsl:value-of select="@units"/><xsl:text>", "data":</xsl:text>
	<xsl:call-template name="get-array-as-javascript-array">
	  <xsl:with-param name="text-input" select="text()"/>
	</xsl:call-template>
	<xsl:text>}</xsl:text>
	<xsl:if test="position()!=last()"><xsl:text>,</xsl:text></xsl:if>
      </xsl:for-each>
      <xsl:text>]</xsl:text>
    </xsl:variable>
    <div class="graph">
      <div class="title"><xsl:value-of select="@title"/></div>
      <div>
	<xsl:call-template name="draw-graph">
	  <xsl:with-param name="graphId" select="generate-id()"/>
	  <xsl:with-param name="x-values" select="$x-values"/>
	  <xsl:with-param name="y-values" select="$y-values"/>
	</xsl:call-template>
      </div>
      <div class="label">
	<xsl:text>Abscissa: </xsl:text>
	<xsl:value-of select="cml:property[1]/@dictRef"/>
	<xsl:text>/</xsl:text>
	<xsl:value-of select="cml:property[1]/cml:array/@units"/>
      </div>
    </div>
    <hr/>
  </xsl:template>


  <xsl:template name="get-array-as-javascript-array">
    <xsl:param name="text-input"/>
    <xsl:text>[</xsl:text>
    <xsl:for-each select="str:tokenize($text-input)">
      <xsl:value-of select="."/>
      <xsl:if test="position()!=last()">
	<xsl:text>,</xsl:text>
      </xsl:if>
    </xsl:for-each>
    <xsl:text>]</xsl:text>
  </xsl:template>


  <xsl:template name="draw-graph">
    <xsl:param name="graphId"/>
    <xsl:param name="x-values"/>
    <xsl:param name="y-values"/>
    <input type="button" value="Show" onclick="js:toggleButton(this, &quot;{$graphId}&quot;); plottable(&quot;#{$graphId}&quot;, {$x-values}, {$y-values})"/><br/>
    <div style="display:none;" id="{$graphId}"/>
  </xsl:template>

</xsl:stylesheet>
