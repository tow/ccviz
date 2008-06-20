<?xml version="1.0" encoding="UTF-8" ?>

<!--===================== PROPERTIES =========================-->

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:cml="http://www.xml-cml.org/schema"
        xmlns="http://www.w3.org/1999/xhtml"
	>


  <xsl:template match="cml:property">
    <xsl:choose>
      <xsl:when test="not(parent::cml:propertyList)">
        <br/>
	<table><tr><xsl:call-template name="addProperty"/></tr></table>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="addProperty"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  
  <xsl:template name="addProperty">
   <tr>
     <td align="left">
       <b>
	 <xsl:call-template name="get.dictionary.reference.html">
	   <xsl:with-param name="dictRef" select="@dictRef"/>
	   <xsl:with-param name="title" select="@title"/>
	 </xsl:call-template>
       </b>
     </td>
     <xsl:choose>
       <!-- Must special-case scalar because units are treated differently -->
       <xsl:when test="cml:scalar">
	 <xsl:apply-templates select="cml:scalar"/>
       </xsl:when>
       <xsl:otherwise>
	 <td align="right">
	   <xsl:choose>
	     <xsl:when test="cml:array">
	       <xsl:apply-templates select="cml:array"/>
	     </xsl:when>
	     <xsl:when test="cml:matrix">
	       <xsl:apply-templates select="cml:matrix"/>
	     </xsl:when>
	     <xsl:when test="cml:table">
	       <xsl:apply-templates select="cml:table"/>
	     </xsl:when>
	   </xsl:choose>
	 </td>
	 <td align="left"><xsl:call-template name="add.units"/><p><br/></p></td>
       </xsl:otherwise>
     </xsl:choose>
   </tr>
  </xsl:template>

  <xsl:template match="cml:propertyList">
   <xsl:apply-templates select="@title"/>
   <table class="propertyList">
     <xsl:for-each select="*">
       <xsl:apply-templates select="."/>
     </xsl:for-each>
   </table>
   <hr/>
  </xsl:template>
  
<!-- @title List -->
  <xsl:template match="@title">
    <div class="listTitle"><xsl:value-of select="."/></div>
  </xsl:template>

</xsl:stylesheet>
