<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:stm="http://www.xml-cml.org/schema/stmml"
        xmlns="http://www.w3.org/1999/xhtml"
        exclude-result-prefixes="xsl stm"
        >

  <xsl:template name="addDict">
    <xsl:apply-templates select="document('siestaDict.xml')/stm:dictionary/stm:entry">
      <!-- need translate below to prevent separating upper & lower case entries -->
      <xsl:sort data-type="text" order="ascending" 
		select="translate(@term,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
    </xsl:apply-templates> 
  </xsl:template>

</xsl:stylesheet>
