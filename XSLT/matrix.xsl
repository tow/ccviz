<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:cml="http://www.xml-cml.org/schema"
        xmlns="http://www.w3.org/1999/xhtml"
	>

  <xsl:import href="loop.xsl"/>

  <xsl:template match="cml:matrix">
    <xsl:param name="rows">
      <xsl:value-of select="@rows"/>
    </xsl:param>
    <xsl:param name="cols">
      <xsl:value-of select="@columns"/>
    </xsl:param>
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
