<?xml version="1.0" encoding="UTF-8" ?>

<!--===================== RDF graphs =========================-->

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:cml="http://www.xml-cml.org/schema"
        xmlns="http://www.w3.org/1999/xhtml"
        xmlns:exsl="http://exslt.org/common"
        extension-element-prefixes="exsl"
        >

  <xsl:template match="cml:propertyList[@dictRef='dl_poly:rdf']">
   <div>
     <p><xsl:text> RDF profiles </xsl:text></p>
     <table>
       <xsl:for-each select="cml:propertyList[@title='rdf pair']">

         <xsl:variable name="RDFtitle">
           <xsl:value-of select="cml:property[@title='atom type 1']"/>
           <xsl:text>-</xsl:text>
           <xsl:value-of select="cml:property[@title='atom type 2']"/>
         </xsl:variable>
 
         <!-- Retrieve all numbers: -->
         <xsl:variable name="gridpoints" select="cml:propertyList[@title='rdf table']/cml:property"/>
         <xsl:variable name="RDFGraphPoints">
           <xsl:call-template name="selectRDFPoints">
             <xsl:with-param name="nodes" select="exsl:node-set($gridpoints)"/>
           </xsl:call-template>
         </xsl:variable> 
         <!-- draw the graph -->
         <xsl:variable name="graph">
           <xsl:call-template name="drawGraph">
             <xsl:with-param name="graphTitle" select="$RDFtitle"/>
             <xsl:with-param name="xAxisTitle" select="r"/>
             <xsl:with-param name="yAxisTitle" select="Occupation"/>
             <xsl:with-param name="pointSet" select="exsl:node-set($RDFGraphPoints)"/>
           </xsl:call-template> 
         </xsl:variable>
         <div>
           <!-- output the graph -->
           <xsl:variable name="graphId" select="generate-id()"/>
           <tr class="graph">
             <td class="graph"><xsl:value-of select="$RDFtitle"/>:</td>
             <td class="graph"><input type="button" value="Show" onclick="js:toggleButton(this, &quot;{$graphId}&quot;)"/></td><br/>
             <div style="display:none;" id="{$graphId}"><xsl:copy-of select="$graph"/></div>
           </tr>
         </div>
       </xsl:for-each>
     </table>
   </div>
 </xsl:template>

  
</xsl:stylesheet>
