<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:cml="http://www.xml-cml.org/schema"
        xmlns="http://www.w3.org/1999/xhtml"
        exclude-result-prefixes="xsl cml"
        >

  <xsl:template name="addDict">
    <xsl:for-each select="//cml:*[@dictRef]">
      <xsl:sort select="translate(substring-after(@dictRef, ':'), 'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
      <xsl:variable name="dictRef" select="@dictRef"/>
      <xsl:variable name="dictURI"
		    select="namespace::*[name()=substring-before($dictRef,':')]"/>
      <xsl:variable name="dictEntry" select="substring-after(@dictRef, ':')"/>
<!--      <xsl:message><xsl:value-of select="concat($dictURI,' ',$dictEntry)"/></xsl:message> -->
      <xsl:apply-templates select="document('dictionaries.xml')//cml:dictionary[@namespace=$dictURI]/cml:entry[@id=$dictEntry]"/> 
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>
