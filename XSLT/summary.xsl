<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:html="http://www.w3.org/1999/xhtml"
        xmlns:func="http://exslt.org/functions"
        xmlns:exsl="http://exslt.org/common"
        xmlns:cml="http://www.xml-cml.org/schema"
        extension-element-prefixes="func exsl"
        >

<xsl:import href="toby_graph.xsl"/>
<xsl:import href="summarygraphs.xsl"/>
 
<!-- Summary information at end of html output. 
     Including graphs of relevant properties 
     and animation of simulation progression -->

  <xsl:template name="summary">

    <xsl:call-template name="summaryGraphs"/>
    <xsl:message terminate="yes"/>
    
    <!-- Finally, add animation -->
    <xsl:if test="count(//cml:molecule) &gt; 0">
      <xsl:call-template name="movie"/>
    </xsl:if>    
    
  </xsl:template>
  

</xsl:stylesheet>
