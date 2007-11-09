<?xml version="1.0" encoding="UTF-8" ?>
<!--===================== DICTIONARY =========================-->

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:stm="http://www.xml-cml.org/schema/stmml"
        xmlns="http://www.w3.org/1999/xhtml"
        exclude-result-prefixes="xsl stm"
	>
  
  <!-- GET DICTIONARY REFERENCE FOR USE WITHIN THE HTML OUTPUT -->	
  <xsl:template name="get.dictionary.reference.html">
    <!-- if dictionary reference is given try to resolve it -->
    <xsl:param name="dictRef" select="' '"/>
    <xsl:param name="title" select="' '"/>
    <xsl:choose>
      <xsl:when test="$dictRef">
          <xsl:call-template name="resolve.dictionary.id.html">
	    <xsl:with-param name="dictionary" select="document(concat(substring-before($dictRef, ':'), 'Dict.xml'))"/>
	    <xsl:with-param name="entry" select="substring-after(@dictRef, ':')"/>
	  </xsl:call-template>
      </xsl:when>
      <xsl:when test="not($dictRef) and $title">                
        <span>
	  <i><xsl:value-of select="$title"/></i>
	</span>
      </xsl:when>
    </xsl:choose>
  </xsl:template>


<!-- RESOLVE DICTIONARY ID FOR THE HTML OUTPUT -->
  <xsl:template name="resolve.dictionary.id.html">
    <xsl:param name="dictionary"/>
    <xsl:param name="entry"/>
    <xsl:variable name="title">
      <xsl:choose>
        <xsl:when test="@title">
	  <xsl:value-of select="@title"/>
	</xsl:when>
	<xsl:otherwise>
          <xsl:text>Unknown</xsl:text>  
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:choose>
    <!-- If dictionary exists use it-->  
      <xsl:when test="$dictionary/stm:dictionary/stm:entry[@id =  $entry]">
        <xsl:apply-templates select="$dictionary/stm:dictionary/stm:entry[@id = $entry]" mode="htmlOutput">
          <xsl:with-param name="entry" select="$entry"/>
	  <xsl:with-param name="title" select="$title"/>
        </xsl:apply-templates>
      </xsl:when>
    <!-- If dictionary does NOT exist use entry name and flag a warning -->  
      <xsl:otherwise>
        <xsl:choose>
        <xsl:when test="$title = 'Unknown'">
          <xsl:value-of select="$entry"/>            <!-- 2nd failing that use @dictRef -->
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="$title"/>            <!-- 1st preferentially use @title -->
	</xsl:otherwise>
      </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <!-- GET DICTIONARY ENTRY FOR HTML OUTPUT -->	
  <xsl:template match="stm:entry" mode="htmlOutput">
    <xsl:param name="entry"/>
    <xsl:param name="title"/>
    <xsl:variable name="dictTitle">
      <xsl:choose>
        <xsl:when test="$title = 'Unknown'">
          <xsl:choose>
	    <xsl:when test="@term">
	      <xsl:value-of select="@term"/>             <!-- 2nd otherwise use @term -->
	    </xsl:when>
	    <xsl:otherwise>
	      <xsl:value-of select="$entry"/>            <!-- 3rd failing that use @dictRef -->
	    </xsl:otherwise>
	  </xsl:choose>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="$title"/>                  <!-- 1st preferentially use @title -->
	</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>  
    <span class="dictRef">
      <xsl:attribute name="onmouseover">window.location.href='#<xsl:value-of select="@id"/>';</xsl:attribute>
      <xsl:value-of select="$dictTitle"/>
    </span>
  </xsl:template>
  
  
  
  
<!-- GRAPH -->
  <!-- GET DICTIONARY REFERENCE FOR USE WITHIN THE GRAPH OUTPUT -->	
  <xsl:template name="get.dictionary.reference.graph">
    <!-- if dictionary reference is given try to resolve it -->
    <xsl:param name="dictRef"/>
    <xsl:choose>
      <xsl:when test="$dictRef">
	<xsl:call-template name="resolve.dictionary.id.graph">
	  <xsl:with-param name="dictionary" 
	     select="document(concat(substring-before($dictRef, ':'), 'Dict.xml'))"/>
	  <xsl:with-param name="entry" select="substring-after($dictRef, ':')"/>
	</xsl:call-template>
      </xsl:when>
      <!-- else try to use the title attribute and flag a warning -->
      <xsl:when test="@title">
	<xsl:text>No dictionary reference given</xsl:text>
      </xsl:when>
      <!-- otherwise just write 'unknown' and flag a warning -->
      <xsl:otherwise>
	<xsl:text>No dictionary reference or title given</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  
  <!-- RESOLVE DICTIONARY ID FOR THE GRAPH OUTPUT-->	
  <xsl:template name="resolve.dictionary.id.graph">
    <xsl:param name="dictionary"/>
    <xsl:param name="entry"/>
    <xsl:choose>
      
      <!-- If dictionary exists use it-->  
      <xsl:when test="$dictionary/dictionary">

        <!-- If entry found then use it -->
	<xsl:if test="$dictionary/dictionary/entry[@id =  $entry]">
	  <xsl:apply-templates select="$dictionary/dictionary/entry[@id =  $entry]" mode="graphOutput">
	    <xsl:with-param name="entry" select="$entry"/>
	  </xsl:apply-templates>
	</xsl:if>
	
	<!--  If entry NOT found then use entry name and flag a warning  -->
	<xsl:if test="not($dictionary/dictionary/entry[@id =  $entry])">
	  <xsl:text>Entry </xsl:text><xsl:value-of select="$entry"/>
	  <xsl:text> not found in the dictionary</xsl:text>
	</xsl:if>
      </xsl:when>
      
      <!-- If dictionary does NOT exist use entry name and flag a warning -->  
      <xsl:otherwise>
	<xsl:value-of select="$dictionary"/><xsl:text> dictionary not found.</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <!-- GET DICTIONARY ENTRY FOR GRAPH OUTPUT -->
  <xsl:template match="entry" mode="graphOutput">
    <xsl:param name="entry"/>

    <xsl:value-of select="definition"/>
  </xsl:template>

</xsl:stylesheet>
