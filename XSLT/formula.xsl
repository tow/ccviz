<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version="1.0">

  <xsl:template match="formula">
    <P/>
    <H3>Formula</H3>
    <xsl:call-template name="format.form">
      <xsl:with-param name="formula" select="normalize-space(.)"/>
    </xsl:call-template>
  </xsl:template>
  

  <xsl:template name="format.form">
    <xsl:param name="formula"/>
    <xsl:if test="not($formula = '')">
      <xsl:variable name="substring" select="substring-before($formula,' ')"/>
      <xsl:variable name="remainder" select="substring-after($formula,' ')"/>
      <!-- Is variable a number or a string? -->
      <xsl:choose>
        <xsl:when test="string(number($substring)) = 'NaN'">      
          <xsl:value-of select="$substring"/>
        </xsl:when>
        <xsl:when test="string(number($substring)) != 'NaN' and $substring != 1">
          <SUB><xsl:value-of select="$substring"/></SUB>
        </xsl:when>
      </xsl:choose>
      <!-- on final iteration this will be processed instead -->
      <xsl:if test="substring-after($formula,' ') = ''">
        <xsl:choose>
        <xsl:when test="string(number($formula)) = 'NaN'">      
          <xsl:value-of select="$formula"/>
        </xsl:when>
        <xsl:when test="string(number($formula)) != 'NaN' and $formula != 1">
          <SUB><xsl:value-of select="$formula"/></SUB>
        </xsl:when>
      </xsl:choose>
      </xsl:if>
      <!-- Recurse -->
      <xsl:call-template name="format.form">
        <xsl:with-param name="formula" select="$remainder"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
  
  </xsl:stylesheet>
  
