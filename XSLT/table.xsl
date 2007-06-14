<?xml version="1.0" encoding="UTF-8" ?>

<!--===================== TABLE =========================-->

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:str="http://exslt.org/strings"
        xmlns:cml="http://www.xml-cml.org/schema"
        xmlns="http://www.w3.org/1999/xhtml"
        extension-element-prefixes="str">

  <xsl:template match="cml:table">
    <table>
      <xsl:for-each select="cml:array">
        <xsl:choose>
          <xsl:when test="position() = 1">
	    <tr>
	      <th>Atom</th>
              <xsl:for-each select="str:tokenize(.)">
                <th><xsl:value-of select="."/></th>
	      </xsl:for-each>
	    </tr>
          </xsl:when>
	  <xsl:otherwise>
            <tr>
	      <td><xsl:value-of select="@ref"/></td>
              <xsl:for-each select="str:tokenize(.)">
                <td><xsl:value-of select="format-number(., ' 0.000')"/></td>
	      </xsl:for-each>
	    </tr>
	  </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </table>
  </xsl:template>

</xsl:stylesheet>
