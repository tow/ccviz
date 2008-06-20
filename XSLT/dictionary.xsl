<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:cml="http://www.xml-cml.org/schema"
        xmlns="http://www.w3.org/1999/xhtml"
        exclude-result-prefixes="xsl cml"
	>

  <xsl:template name="get.dictionary.reference.html">
    <xsl:param name="dictRef"/>
    <xsl:param name="title"/>
    <xsl:choose>
      <xsl:when test="$dictRef">
	<xsl:variable name="dictURI"
		      select="namespace::*[name()=substring-before($dictRef,':')]"/>
	<xsl:variable name="dictEntry" select="substring-after(@dictRef, ':')"/>
	<xsl:choose>
	  <xsl:when test="document('dictionaries.xml')//cml:dictionary[@namespace=$dictURI]/cml:entry[@id=$dictEntry]">
	    <xsl:apply-templates select="document('dictionaries.xml')//cml:dictionary[@namespace=$dictURI]/cml:entry[@id=$dictEntry]" mode="htmlOutput">
	      <xsl:with-param name="title" select="$title"/>
	    </xsl:apply-templates>
	  </xsl:when>
	  <xsl:otherwise>
	    <span class="dictRef">
	      <xsl:value-of select="$dictEntry"/>
	    </span>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:when>
      <xsl:when test="not($dictRef) and $title">
	<span>
	  <i><xsl:value-of select="$title"/></i>
	</span>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
    
   <xsl:template match="cml:entry" mode="htmlOutput">
    <xsl:param name="title"/>
    <xsl:variable name="dictTitle">
      <xsl:choose>
	<xsl:when test="$title">
	  <xsl:value-of select="$title"/>
	</xsl:when>
	<xsl:when test="@term">
	  <xsl:value-of select="@term"/>             <!-- 2nd otherwise use @term -->
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="@id"/>            <!-- 3rd failing that use @dictRef -->
	</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>  
    <span class="dictRef dotted">
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
