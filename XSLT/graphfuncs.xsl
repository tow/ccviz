<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:func="http://exslt.org/functions"
	xmlns:exsl="http://exslt.org/common"
        xmlns:tohw="http://www.uszla.me.uk/xsl/1.0/functions"
        xmlns:tohw_="http://www.uszla.me.uk/xsl/1.0/functions"
        xmlns:g="http://www.uszla.me.uk/xsl/1.0/graph"
        extension-element-prefixes="func exsl tohw"
	version="1.0">

<!--    <func:function name="tohw:min">
      <xsl:param name="values"/>
      <xsl:param name="current" select="$values[1]"/>
      <xsl:if test="count($values) = 0">
        <xsl:message terminate="yes">
tohw:min requires more than zero values
        </xsl:message>
      </xsl:if>
      <xsl:variable name="newcurrent">
	<xsl:choose>
	  <xsl:when test="$values[1] &lt; $current">
	    <xsl:value-of select="$values[1]"/>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:value-of select="$current"/>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:variable>
      <func:result>
	<xsl:choose>
	  <xsl:when test="count($values) = 1">
	    <xsl:value-of select="$newcurrent"/>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:value-of select="tohw:min($values[position()!=1], $newcurrent)"/>
	  </xsl:otherwise>
	</xsl:choose>
      </func:result>
    </func:function>

    <func:function name="tohw:max">
      <xsl:param name="values"/>
      <xsl:param name="current" select="$values[1]"/>
      <xsl:if test="count($values) = 0">
        <xsl:message terminate="yes">
tohw:max requires more than zero values
        </xsl:message>
      </xsl:if>
      <xsl:variable name="newcurrent">
	<xsl:choose>
	  <xsl:when test="$values[1] &gt; $current">
	    <xsl:value-of select="$values[1]"/>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:value-of select="$current"/>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:variable>
      <func:result>
	<xsl:choose>
	  <xsl:when test="count($values) = 1">
	    <xsl:value-of select="$newcurrent"/>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:value-of select="tohw:max($values[position()!=1], $newcurrent)"/>
	  </xsl:otherwise>
	</xsl:choose>
      </func:result>
    </func:function>
-->	

  <func:function name="tohw:intpow">
    <xsl:param name="x"/>
    <xsl:param name="y"/>
    <xsl:if test="$y != floor(number($y))">
      <xsl:message terminate="yes">
tohw:intpow requires an integer power
      </xsl:message>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="$y = 0">
	<func:result select="1"/>
      </xsl:when>
      <xsl:when test="$y = 1">
	<func:result select="$x"/>
      </xsl:when>
      <xsl:when test="$y &lt; 0">
	<func:result select="1 div tohw:intpow($x,-1 * $y)"/>
      </xsl:when>
      <xsl:otherwise>
	<func:result select="$x * tohw:intpow($x, $y - 1)"/>
      </xsl:otherwise>
    </xsl:choose>
  </func:function>

  <func:function name="tohw:floorlog10">
    <xsl:param name="x"/>
    <xsl:variable name="stringLog">
      <xsl:choose>
	<xsl:when test="$x = 0.0">
          0	  
	</xsl:when>
	<xsl:when test="contains(string($x), 'e')">
	  <!-- non-conformant xpath implementation -->
	  <xsl:value-of select="substring-after(string($x),'e')"/>
	</xsl:when>
	<xsl:when test="contains(string($x),'E')">
	  <!-- non-conformant xpath implementation -->
	  <xsl:value-of select="substring-after(string($x),'E')"/>
	</xsl:when>
	<xsl:when test="$x &gt;= 1">
	  <xsl:choose>
	    <xsl:when test="contains($x, '.')">
	      <xsl:value-of select="string-length(substring-before(string($x),'.'))"/>
	    </xsl:when>
	    <xsl:otherwise>
	      <xsl:value-of select="string-length($x)"/>
	    </xsl:otherwise>
	  </xsl:choose>
	</xsl:when>
	<xsl:when test="$x &lt;= -1">
	  <xsl:choose>
	    <xsl:when test="contains($x, '.')">
	      <xsl:value-of select="string-length(substring-before(string($x),'.')) - 1"/>
	    </xsl:when>
	    <xsl:otherwise>
	      <xsl:value-of select="string-length($x) - 1"/>
	    </xsl:otherwise>
	  </xsl:choose>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="-1 * tohw:floorlog10(1 div $x)"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="contains($stringLog,'+')">
	<func:result select="number(substring-after($stringLog,'+'))-1"/>
      </xsl:when>
      <xsl:otherwise>
	<func:result select="number($stringLog)-1"/>
      </xsl:otherwise>
    </xsl:choose>
  </func:function>

  <xsl:template name="tohw:addUp">
    <!-- Generate an (inclusive) list of 0*$size, 1*$size, ..., $endIter*$size -->
    <xsl:param name="size"/>
    <xsl:param name="iterator" select="0"/>
    <xsl:param name="endIter"/>
    <number value="{$iterator * $size}"/>
    <xsl:if test="$iterator &lt; $endIter">
      <xsl:call-template name="tohw:addUp">
	<xsl:with-param name="size" select="$size"/>
	<xsl:with-param name="iterator" select="$iterator+1"/>
	<xsl:with-param name="endIter" select="$endIter"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <func:function name="tohw:launderFP">
    <xsl:param name="x"/>
    <xsl:variable name="n">
      <xsl:choose>
	<xsl:when test="contains(string($x), 'e')">
	  <xsl:value-of select="number(substring-before(string($x),'e'))"/>
	</xsl:when>
	<xsl:when test="contains(string($x),'E')">
	  <xsl:value-of select="number(substring-before(string($x),'E'))"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="number($x)"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="p1">
      <xsl:choose>
	<xsl:when test="contains(string($x), 'e')">
	  <xsl:value-of select="substring-after(string($x),'e')"/>
	</xsl:when>
	<xsl:when test="contains(string($x),'E')">
	  <xsl:value-of select="substring-after(string($x),'E')"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="0"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="p">
      <xsl:choose>
	<xsl:when test="contains($p1,'+')">
	  <xsl:value-of select="number(substring-after($p1,'+'))"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="number($p1)"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <func:result select="number($n)*tohw:intpow(10,$p)"/>
  </func:function>

  <xsl:template name="g:tickValues">
    <xsl:param name="minV"/>
    <xsl:param name="maxV"/>
    <xsl:param name="numTicks" select="4"/>
    <xsl:variable name="range" select="$maxV - $minV"/>
    <xsl:variable name="sectionSize" select="$range div ($numTicks + 1)"/>
    <xsl:variable name="ticks">
      <xsl:call-template name="tohw:addUp">
	<xsl:with-param name="size" select="$sectionSize"/>
	<xsl:with-param name="endIter" select="$numTicks+1"/>
      </xsl:call-template>
    </xsl:variable>
    <g:tickList>
      <xsl:for-each select="exsl:node-set($ticks)/number/@value">
	<g:tick value="{. + $minV}"/>
      </xsl:for-each>
    </g:tickList>
  </xsl:template>

  <xsl:template name="launderTree">
    <xsl:param name="tree"/>
    <xsl:for-each select="$tree/node()">
      <xsl:choose>
	<xsl:when test="local-name()='point' and namespace-uri()='http://www.uszla.me.uk/xsl/1.0/graph'">
	  <g:point x="{tohw:launderFP(@x)}" y="{tohw:launderFP(@y)}"/>
	</xsl:when>
	<xsl:when test="count(./child::node()) &gt; 0">
	  <xsl:element namespace="{namespace-uri()}" name="{local-name()}">
	    <xsl:call-template name="launderTree">
	      <xsl:with-param name="tree" select="."/>
	    </xsl:call-template>
	  </xsl:element>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:copy-of select="."/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>
