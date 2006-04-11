<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
	xmlns="http://www.uszla.me.uk/xsl/1.0/graph"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:cml="http://www.xml-cml.org/schema"
	xmlns:g="http://www.uszla.me.uk/xsl/1.0/graph"
        xmlns:exsl="http://exslt.org/common"
        extension-element-prefixes="exsl"
        >

 <xsl:template name="drawGraphOf">
    <xsl:param name="subTree" select="/cml:cml"/>
    <xsl:param name="stepType"/>
    <xsl:param name="propertyName"/>
    <xsl:param name="title" select="$propertyName"/>
    <xsl:param name="xAxisTitle" select="'Step'"/>
    <xsl:param name="yAxisTitle" select="''"/>
    <xsl:variable name="pointList">
      <g:pointList>
        <xsl:for-each select="$subTree/cml:module[@dictRef=$stepType]">
          <xsl:variable name="x" select="@serial"/>
          <xsl:variable name="y" select="cml:propertyList/cml:property[@dictRef=$propertyName]/cml:scalar"/>
          <g:point x="{$x}" y="{$y}"/>
        </xsl:for-each>
      </g:pointList>
    </xsl:variable>
    <xsl:call-template name="drawGraph">
      <xsl:with-param name="title" select="$title"/>
      <xsl:with-param name="xAxisTitle" select="$xAxisTitle"/>
      <xsl:with-param name="yAxisTitle" select="$yAxisTitle"/>
      <xsl:with-param name="pointSet" select="exsl:node-set($pointList)"/>
    </xsl:call-template>
  </xsl:template>


  <xsl:template name="selectNestedGraphNodes">
    <xsl:param name="nodes"/>
    <xsl:param name="propertyName"/>
    <g:pointList>
      <!-- for each step, if the property exists, then add its value to the pointList -->
      <xsl:for-each select="$nodes">
        <xsl:if test="cml:propertyList/cml:property[@dictRef=$propertyName]">
          <xsl:variable name="x">
	    <xsl:choose>
	      <xsl:when test="@serial">
	        <xsl:value-of select="@serial"/>
	      </xsl:when>
	      <xsl:otherwise>
	        <xsl:value-of select="position()"/>
	      </xsl:otherwise>
	    </xsl:choose>
	  </xsl:variable>
          <xsl:variable name="y" select="cml:propertyList/cml:property[@dictRef=$propertyName]/cml:scalar"/>
          <g:point x="{$x}" y="{$y}"/>
	</xsl:if>
      </xsl:for-each>
    </g:pointList>
  </xsl:template> 

  <xsl:template name="selectRDFPoints">
    <!-- FIXME subject to change as we refine RDF XML format - this is bloody fragile -->
    <xsl:param name="nodes"/>
    <g:pointList>
      <xsl:for-each select="$nodes">
        <xsl:if test="@title='grid'">
          <xsl:variable name="pos" select="position()"/>
          <xsl:variable name="x" select="cml:scalar/text()"/>
          <xsl:variable name="y" select="../cml:property[position() = ($pos + 1)]/cml:scalar/text()"/>
          <g:point x="{$x}" y="{$y}"/>
	</xsl:if>
      </xsl:for-each>
    </g:pointList>
  </xsl:template>

  <xsl:template name="selectPointsFromNodes">
    <xsl:param name="nodes"/>
    <xsl:param name="propertyNames"/>
    <g:pointList>
      <!-- for each step, if the property exists, then add its value to the pointList -->
      <xsl:for-each select="$nodes">
        <xsl:variable name="x">
          <xsl:choose>
	    <xsl:when test="@serial">
	      <xsl:value-of select="@serial"/>
	    </xsl:when>
	    <xsl:otherwise>
	      <xsl:value-of select="position()"/>
	    </xsl:otherwise>
	  </xsl:choose>
	</xsl:variable>
        <xsl:variable name="here" select="."/>
        <xsl:for-each select="$propertyNames">
          <xsl:variable name="propertyName" select="."/>
          <g:group dictRef="{$propertyName}">
            <xsl:if test="$here/cml:propertyList/cml:property[@dictRef=$propertyName]">
              <xsl:variable name="y" select="$here/cml:propertyList/cml:property[@dictRef=$propertyName]/cml:scalar"/>
              <g:point x="{$x}" y="{$y}"/>
	    </xsl:if>
	  </g:group>
	</xsl:for-each>
      </xsl:for-each>
    </g:pointList>
  </xsl:template> 

  <xsl:template name="selectedPointsFromList">
    <xsl:param name="pointList"/>
    <xsl:param name="dictRef"/>
    <g:pointList>
      <xsl:for-each select="$pointList/g:pointList/g:group[@dictRef=$dictRef]">
        <xsl:copy-of select="g:point"/>
      </xsl:for-each>
    </g:pointList>
  </xsl:template>

</xsl:stylesheet>
