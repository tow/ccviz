<!--===================== LATTICE =========================-->

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:cml="http://www.xml-cml.org/schema"
        xmlns="http://www.w3.org/1999/xhtml"
        >

<!-- cmlCore:crystal -->  
  <xsl:template match="cml:crystal">
    <p/>
    <div class="listTitle">Lattice Parameters</div>
    <table>
    <tr> <!-- TOHW FIXME put units in here -->
      <td align="left"><b>Lattice Modules</b></td>
      <td><xsl:value-of select="cml:scalar[position() = 1]"/></td>
      <td><xsl:value-of select="cml:scalar[position() = 2]"/></td>
      <td><xsl:value-of select="cml:scalar[position() = 3]"/></td>
    </tr>  
    <tr>
      <td align="left"><b>Lattice Angles</b></td>
      <td><xsl:value-of select="format-number(cml:scalar[position() = 4], '0.0000')"/></td>
      <td><xsl:value-of select="format-number(cml:scalar[position() = 5], '0.0000')"/></td>
      <td><xsl:value-of select="format-number(cml:scalar[position() = 6], '0.0000')"/></td>
    </tr>
    </table>
  </xsl:template>

  <xsl:template match="cml:lattice">
    <p/>
    <div class="listTitle">Lattice Parameters</div>
    <table>
    <tr><th>Lattice Vectors</th></tr>
    <xsl:for-each select="cml:latticeVector">
      <tr><td><xsl:value-of select="text()"/></td></tr>
    </xsl:for-each>
    </table>
  </xsl:template>
  
</xsl:stylesheet>
