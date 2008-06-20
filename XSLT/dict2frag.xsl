<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:cml="http://www.xml-cml.org/schema"
        xmlns="http://www.w3.org/1999/xhtml"
        exclude-result-prefixes="xsl cml"
        >

  <xsl:template name="addDict">
    <xsl:variable name="unique-dictRefs" select="//cml:*[@dictRef and (generate-id(.)=generate-id(key('dictRef-keys',  concat(namespace::*[name()=substring-before(../@dictRef,':')], '#', substring-after(@dictRef, ':')))[1]))]"/>
    <!-- Muenchian grouping -->

    <xsl:for-each select="$unique-dictRefs">
      <xsl:sort select="translate(substring-after(@dictRef, ':'), 'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
      <xsl:variable name="dictRef" select="@dictRef"/>
      <xsl:variable name="dictURI"
		    select="namespace::*[name()=substring-before($dictRef,':')]"/>
      <xsl:variable name="dictEntry" select="substring-after($dictRef, ':')"/>
      <xsl:choose>
	<xsl:when test="$dictURI!='' and document('dictionaries.xml')//cml:dictionary[@namespace=$dictURI]/cml:entry[@id=$dictEntry]">
	  <xsl:apply-templates select="document('dictionaries.xml')//cml:dictionary[@namespace=$dictURI]/cml:entry[@id=$dictEntry]"/> 
	</xsl:when>
	<xsl:otherwise>
	  <xsl:call-template name="empty-entry">
	    <xsl:with-param name="id" select="$dictEntry"/>
	  </xsl:call-template>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>
