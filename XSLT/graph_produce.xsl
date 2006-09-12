<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
        xmlns:cml="http://www.xml-cml.org/schema"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:g="http://www.uszla.me.uk/xsl/1.0/graph"
        >

<xsl:import href="toby_graph.xsl"/>
<xsl:import href="graphfuncs.xsl"/>

<xsl:output method="xml" encoding="utf-8" indent="yes"/>

<xsl:param name="graphTitle" select="default"/>
<xsl:param name="xAxisTitle" select="default"/>
<xsl:param name="yAxisTitle" select="default"/>

<!-- MAIN TEMPLATE -->
  <xsl:template match="/">
    <xsl:apply-templates select="*"/>
  </xsl:template>

  <xsl:template match="g:graphSet">

    <xsl:call-template name="drawGraph">
      <xsl:with-param name="graphTitle" select="$graphTitle"/>
      <xsl:with-param name="xAxisTitle" select="$xAxisTitle"/>
      <xsl:with-param name="yAxisTitle" select="$yAxisTitle"/>
      <xsl:with-param name="pointSet" select="."/>
    </xsl:call-template>
  </xsl:template>

</xsl:stylesheet>
