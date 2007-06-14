<!--===================== ARRAY =========================-->

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:str="http://exslt.org/strings"
        xmlns="http://www.w3.org/1999/xhtml"
        xmlns:cml="http://www.xml-cml.org/schema"
        extension-element-prefixes="str">

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
