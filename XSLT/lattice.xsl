<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:cml="http://www.xml-cml.org/schema"
        xmlns:str="http://exslt.org/strings"
        xmlns="http://www.w3.org/1999/xhtml"
        extension-element-prefixes="str"
        >

<!-- cmlCore:crystal -->  
  <xsl:template match="cml:crystal" mode="structure">
    <p/>
    <div class="listTitle">Crystal Parameters: <xsl:value-of select="@title"/></div>
    <xsl:variable name="lenUnits">
      <xsl:choose>
        <xsl:when test="cml:scalar">Ang</xsl:when>
        <xsl:when test="cml:cellParameter">
          <xsl:choose>
            <xsl:when test="cml:cellParameter[@parameterType='length']/@units">
              <xsl:value-of select="cml:cellParameter[@parameterType='length']/@units"/>
            </xsl:when>
            <xsl:otherwise>Ang</xsl:otherwise>
          </xsl:choose>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="angUnits">
      <xsl:choose>
        <xsl:when test="cml:scalar">degrees</xsl:when>
        <xsl:when test="cml:cellParameter">
          <xsl:choose>
            <xsl:when test="cml:cellParameter[@parameterType='angle']/@units">
              <xsl:value-of select="cml:cellParameter[@parameterType='angle']/@units"/>
            </xsl:when>
            <xsl:otherwise>degrees</xsl:otherwise>
          </xsl:choose>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>
               
    <table>
      <tr> 
        <th colspan="3">Crystal lengths (<xsl:value-of select="$lenUnits"/>)</th>
      </tr>
      <tr>
        <xsl:choose>
          <xsl:when test="cml:scalar">
            <td><xsl:value-of select="cml:scalar[position() = 1]"/></td>
            <td><xsl:value-of select="cml:scalar[position() = 2]"/></td>
            <td><xsl:value-of select="cml:scalar[position() = 3]"/></td>
          </xsl:when>
          <xsl:when test="cml:cellParameter">
            <xsl:variable name="cellParameters" value="str:tokenize(cml:cellParameter[@parameterType='length']/text())"/>
            <td><xsl:value-of select="str:tokenize(cml:cellParameter[@parameterType='length'])[1]"/></td>       
            <td><xsl:value-of select="str:tokenize(cml:cellParameter[@parameterType='length'])[2]"/></td>       
            <td><xsl:value-of select="str:tokenize(cml:cellParameter[@parameterType='length'])[3]"/></td>       
          </xsl:when>
        </xsl:choose>
      </tr>  
      <tr>
        <th colspan="3">Crystal angles (<xsl:value-of select="$angUnits"/>)</th>
      </tr>
      <tr>
        <xsl:choose>
          <xsl:when test="cml:scalar">
            <td><xsl:value-of select="cml:scalar[position() = 4]"/></td>
            <td><xsl:value-of select="cml:scalar[position() = 5]"/></td>
            <td><xsl:value-of select="cml:scalar[position() = 6]"/></td>
          </xsl:when>
          <xsl:when test="cml:cellParameter">
            <td><xsl:value-of select="str:tokenize(cml:cellParameter[@parameterType='angle'])[1]"/></td>       
            <td><xsl:value-of select="str:tokenize(cml:cellParameter[@parameterType='angle'])[2]"/></td>       
            <td><xsl:value-of select="str:tokenize(cml:cellParameter[@parameterType='angle'])[3]"/></td>       
          </xsl:when>
        </xsl:choose>
      </tr>
    </table>
  </xsl:template>

  <xsl:template match="cml:lattice" mode="structure">
    <p/>
    <div class="listTitle">Lattice Parameters</div>
    <table>
      <tr><th colspan="3">Lattice Vectors</th></tr>
      <xsl:for-each select="cml:latticeVector">
        <tr>
          <td><xsl:value-of select="str:tokenize(text())[1]"/></td>
          <td><xsl:value-of select="str:tokenize(text())[2]"/></td>
          <td><xsl:value-of select="str:tokenize(text())[3]"/></td>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>
  
</xsl:stylesheet>
