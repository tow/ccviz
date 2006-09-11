<!--===================== BANDS =========================-->

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:str="http://exslt.org/strings"
        xmlns="http://www.w3.org/1999/xhtml"
        xmlns:cml="http://www.xml-cml.org/schema"
        extension-element-prefixes="str">
	
<!-- bandList -->
  <xsl:template match="cml:bandList">
    <xsl:if test="title"><H3><xsl:value-of select="@title"/></H3></xsl:if>
<!--    <H3>Eigenvalues</H3>  -->
    <table>
      <xsl:apply-templates select="cml:band"/>
    </table>
  </xsl:template>
  
<!-- band -->
  <xsl:template match="cml:band">
    <xsl:param name="mouseoverString">
      <xsl:for-each select="str:tokenize(@kpoint,' ')">
        <xsl:value-of select="format-number(., '0.000')"/>
      </xsl:for-each>
      <xsl:text> (</xsl:text>
      <xsl:value-of select="format-number(@weight, '0.000')"/>
      <xsl:text>)</xsl:text>
    </xsl:param>

    <tr>
      <th align="left">
	<span>
	  <xsl:attribute name="title">
	    <xsl:value-of select="$mouseoverString"/>
	  </xsl:attribute>
	  <i>k</i>-point
	  <xsl:value-of select="position()"/>
	</span>
      </th>
    </tr>
    <tr>
      <td>
        <table>
	<xsl:for-each select="str:tokenize(normalize-space(.), ' ')">
	  <xsl:if test="(position()-1) mod 10 = 0">
           <xsl:variable name="pos" select="position()"/>
           <tr>
            <td class="eigen"><xsl:value-of select="../token[$pos+0]"/></td>
            <td class="eigen"><xsl:value-of select="../token[$pos+1]"/></td>
            <td class="eigen"><xsl:value-of select="../token[$pos+2]"/></td>
            <td class="eigen"><xsl:value-of select="../token[$pos+3]"/></td>
            <td class="eigen"><xsl:value-of select="../token[$pos+4]"/></td>
            <td class="eigen"><xsl:value-of select="../token[$pos+5]"/></td>
            <td class="eigen"><xsl:value-of select="../token[$pos+6]"/></td>
            <td class="eigen"><xsl:value-of select="../token[$pos+7]"/></td>
            <td class="eigen"><xsl:value-of select="../token[$pos+8]"/></td>
            <td class="eigen"><xsl:value-of select="../token[$pos+9]"/></td>
          </tr>
         </xsl:if>
	</xsl:for-each>
        </table>
      </td>
    </tr>
  </xsl:template>

</xsl:stylesheet>
