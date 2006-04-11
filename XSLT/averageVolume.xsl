<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
   xmlns:cml="http://www.xml-cml.org/schema"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:tohw="http://www.uszla.me.uk/xsl/1.0/functions"
   xmlns:g="http://www.uszla.me.uk/xsl/1.0/graph"
   extension-element-prefixes="tohw"
>

<xsl:import href="graphfuncs.xsl"/>

<xsl:output method="xml"/>

<xsl:param name="fileList"/>

<xsl:template match="/">
  <g:graphSet>
    <g:pointList>
      <xsl:apply-templates select="*"/>
    </g:pointList>
  </g:graphSet>
</xsl:template>

<xsl:template match="file">
  <xsl:element name="point" namespace="http://www.uszla.me.uk/xsl/1.0/graph">
    <xsl:attribute name="x">
      <xsl:value-of select="document(.)//cml:parameterList[@title='control parameters']/cml:parameter[@dictRef='dl_poly:pressure']/cml:scalar"/>
    </xsl:attribute>
    <xsl:attribute name="y">
      <xsl:value-of select="sum(document(.)//cml:step/cml:propertyList[@title='instantaneous']/cml:property[@dictRef='dl_poly:volume']/cml:scalar) div count(document(.)//cml:step/cml:propertyList[@title='instantaneous']/cml:property[@dictRef='dl_poly:volume']/cml:scalar)"/>
    </xsl:attribute>
  </xsl:element>
</xsl:template>


</xsl:stylesheet>

