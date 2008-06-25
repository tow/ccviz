<xsl:stylesheet version="1.0"
        xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:cml="http://www.xml-cml.org/schema"
        xmlns:str="http://exslt.org/strings"
        extension-element-prefixes="str"
	>

  <xsl:import href="loop.xsl"/>

  <xsl:template match="cml:matrix">
    <xsl:param name="rows" select="@rows"/>
    <xsl:param name="cols" select="@columns"/>
    <xsl:param name="plottable" select="@role='plottable'"/>

    <xsl:variable name="dataString" select="concat(normalize-space(.),' ')"/>
    <table class="prop">
      <tr>
	<th colspan="{$cols}">
	  <xsl:call-template name="get.dictionary.reference.html">
            <xsl:with-param name="dictRef" select="@dictRef"/>
            <xsl:with-param name="value" select="@value"/>
          </xsl:call-template>
	  <xsl:text> (</xsl:text>
	  <xsl:value-of select="@units"/>
	  <xsl:text>) </xsl:text>
  	</th>
      </tr>

      <xsl:call-template name="rows-for-loop">
        <xsl:with-param name="i" select="1"/>
        <xsl:with-param name="increment" select="1"/>
        <xsl:with-param name="testValue" select="$rows"/>
        <xsl:with-param name="innerTestValue" select="$cols"/>
        <xsl:with-param name="outputString" select="$dataString"/>
      </xsl:call-template>
    </table>
  </xsl:template>

</xsl:stylesheet>
