<?xml version="1.0" encoding="UTF-8" ?>

<!--===================== SCALAR =========================-->

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:cml="http://www.xml-cml.org/schema"
        xmlns="http://www.w3.org/1999/xhtml"
        >

<!-- scalar List-->
  <xsl:template match="cml:scalar">
    <xsl:if test="@dictRef">
      <br/> 
      <td align="left">
        <b>
          <xsl:call-template name="get.dictionary.reference.html">
            <xsl:with-param name="dictRef" select="@dictRef"/>
            <xsl:with-param name="title" select="@title"/>
          </xsl:call-template>
        </b>
      </td>
    </xsl:if>

   <xsl:variable name="printableOutput">
     <!-- look for dataType attribute to see how to format -->
     <!-- except actually at the moment, we format the same
          way regardless -->
     <xsl:choose>
       <xsl:when test="@dataType">
         <xsl:value-of select="text()"/>
       </xsl:when>
       <xsl:otherwise>
         <xsl:value-of select="text()"/>
       </xsl:otherwise>
     </xsl:choose>
   </xsl:variable>
    
    <xsl:choose>
      <xsl:when test="parent::cml:parameter">
        <td align="right" class="paramvalue"><xsl:value-of select="$printableOutput"/></td>
      </xsl:when>
      <xsl:otherwise>
      	<td align="right">
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
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="@units">
      <td align="left"><xsl:text> </xsl:text><i><xsl:value-of select="@units"/></i></td>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
