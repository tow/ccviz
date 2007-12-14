<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:cml="http://www.xml-cml.org/schema"
        xmlns="http://www.w3.org/1999/xhtml"
        exclude-result-prefixes="xsl"
        >

<!-- JS/CSS includes -->
<xsl:import href="header.xsl"/>

<!-- CML -->
<xsl:import href="structure.xsl"/>
<xsl:import href="dictionary.xsl"/>
<xsl:import href="metadata.xsl"/>
<xsl:import href="parameter.xsl"/>
<xsl:import href="property.xsl"/>
<xsl:import href="bandList.xsl"/>
<xsl:import href="formula.xsl"/>
<xsl:import href="units.xsl"/>

<!-- CMLComp -->
<xsl:import href="module.xsl"/>
<xsl:import href="lattice.xsl"/>

<!-- STMML -->
<xsl:import href="scalar.xsl"/>
<xsl:import href="array.xsl"/> 
<xsl:import href="matrix.xsl"/>
<xsl:import href="table.xsl"/>

<!-- Dictionary -->
<xsl:import href="dict2frag.xsl"/>
<xsl:import href="dictcommon.xsl"/>

<!-- Special templates -->
<xsl:import href="summary.xsl"/>
<xsl:import href="rdf.xsl"/>

<xsl:strip-space elements="*"/>

<xsl:template match="text()"/>

<!-- Global Variable holding the program name -->
<xsl:param name="prog">
  <xsl:choose>
    <xsl:when test="/cml:cml/cml:metadataList/cml:metadata[@name='eMinerals:Program']">
      <xsl:value-of select="/cml:cml/cml:metadataList/cml:metadata[@name='eMinerals:Program']/@content"/>
    </xsl:when>
    <xsl:when test="/cml:cml/cml:metadataList/cml:metadata[@name='siesta:Program']">
      <xsl:value-of select="/cml:cml/cml:metadataList/cml:metadata[@name='siesta:Program']/@content"/>
    </xsl:when>
    <xsl:when test="/cml:cml/cml:metadataList/cml:metadata[@name='dl_poly:Program']">
      <xsl:value-of select="/cml:cml/cml:metadataList/cml:metadata[@name='dl_poly:Program']/@content"/>
    </xsl:when>
    <xsl:when test="contains(/cml:cml/cml:metadataList/cml:metadata[@name='dc:identifier']/@content,'DL_POLY')">
      <xsl:text>DL_POLY</xsl:text>
    </xsl:when>
    <xsl:when test="/cml:cml/cml:metadataList/cml:metadata[@name='dc:creator']">
      <xsl:value-of select="/cml:cml/cml:metadataList/cml:metadata[@name='dc:creator']/@content"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>Program</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:param>

<!-- Global variable - do we want jmol output or not? -->
  <xsl:param name="Jmol">
    <xsl:value-of select="boolean(//cml:molecule)"/>
  </xsl:param>

<!-- Global variable - how many steps do we want? -->
  <xsl:param name="stepinterval">
    <xsl:choose>
      <xsl:when test="count(cml:cml/cml:module[@role='step']) &gt; 100">
         10
      </xsl:when>
      <xsl:otherwise>
         1
      </xsl:otherwise>
    </xsl:choose>
  </xsl:param>


  <xsl:output method="xml" version="1.0" encoding="UTF-8" 
    omit-xml-declaration="no" standalone="yes"
    doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
    doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
    indent="no" media-type="application/xhtml+xml"/>


<!-- MAIN TEMPLATE -->
  <xsl:template match="/">
    <html>
      <xsl:call-template name="head"/>

      <body>
        <xsl:if test="$Jmol!='false'">
         <xsl:attribute name="onload">
           <xsl:text>jmolXInitialize(&quot;http://www.eminerals.org/jmol&quot;)</xsl:text>
         </xsl:attribute>
        </xsl:if>
 
        <div id="head"><div class="bigTitle">
           <xsl:value-of select="$prog"/>
           <xsl:text> Output</xsl:text>
        </div></div>

<!-- Generate body of document -->
        <div id="maindisplay">
          <div class="innerMain">

            <br/><div onclick="js:togglemenu(&quot;initialMetadata&quot;)" class="divisionTitle clickableDiv">
              <xsl:value-of select="'Initial Metadata'"/>
            </div>
            <div class="sublevel" id="initialMetadata">
              <xsl:apply-templates select="/cml:cml/cml:metadataList[position()=1]"/>
            </div><br/>

            <br/><div onclick="js:togglemenu(&quot;inputParams&quot;)" class="divisionTitle clickableDiv">
              <xsl:value-of select="'Input Parameters'"/>
            </div>
            <div class="sublevel" id="inputParams">
              <xsl:apply-templates select="/cml:cml/cml:parameterList"/>
            <!--   <xsl:apply-templates select="/cml:cml/cml:parameterList[position()=1]"/> -->
            </div><br/>

            <br/><div onclick="js:togglemenu(&quot;initialState&quot;)" class="divisionTitle clickableDiv">
              <xsl:value-of select="'Input State of System'"/>
            </div>
            <div class="sublevel" id="initialState">
              <xsl:apply-templates select="/cml:cml/cml:module[@title='Initial System']" mode="noTitle"/>
            </div><br/>

            <br/><div onclick="js:togglemenu(&quot;mainBody&quot;)" class="divisionTitle clickableDiv">
              <xsl:value-of select="'Main Body of Simulation'"/>
            </div>
            <div class="sublevel" id="mainBody">
              <xsl:apply-templates select="/cml:cml/cml:module[(@title!='Initial System' and @title!='Finalization') or not(@title)]"/>
            </div><br/>

            <br/><div onclick="js:togglemenu(&quot;finalState&quot;)" class="divisionTitle clickableDiv">
              <xsl:value-of select="'Final State of System'"/>
            </div>
            <div class="sublevel" id="finalState">
              <xsl:apply-templates select="/cml:cml/cml:module[@title='Finalization']" mode="noTitle"/>
            </div><br/>

            <br/>
            <div onclick="js:togglemenu(&quot;summaryInfo&quot;)" class="divisionTitle clickableDiv">
              <xsl:text>Summary Information</xsl:text>
            </div>
            <div class="sublevel" id="summaryInfo">
              <xsl:call-template name="summary"/>
	    </div>
            <br/>
            <hr/>
          </div>
        </div>

<!-- Generate dictionary of document -->
        <div id="dictdisplay">
          <div class="innerDict">
            <xsl:call-template name="addDict"/>
          </div>
        </div>
<!-- -->

        <div id="foot">
          <i>Created by Toby White, Jon Wakelin,  &amp; Richard Bruin </i>
        </div>

      </body>
    </html>

  </xsl:template>

  <xsl:template name="top.level.section">
    <xsl:param name="uid"/>
    <xsl:param name="title"/>
    <xsl:param name="templates"/>
  </xsl:template>

</xsl:stylesheet>
