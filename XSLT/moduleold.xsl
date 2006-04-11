<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:cml="http://www.xml-cml.org/schema"
        xmlns="http://www.w3.org/1999/xhtml"
	>

  <xsl:template match="cml:module">
    <xsl:variable name="uid" select="generate-id()"/>
    
    <hr />
    <div>
      <div onclick="js:togglemenu(&quot;{$uid}&quot;)" class="moduletitle">
        <xsl:value-of select="@title"/>
      </div>
    </div>
    <div class="sublevel" id="{$uid}">
      <xsl:apply-templates select="*"/>
    </div>
    <hr />
  </xsl:template>

</xsl:stylesheet>
