<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:cml="http://www.xml-cml.org/schema"
        xmlns="http://www.w3.org/1999/xhtml"
	>

<xsl:import href="toby_graph.xsl"/>
<xsl:import href="siestagraphs.xsl"/>


  <xsl:template match="cml:module">
    <xsl:variable name="uid" select="generate-id()"/>
    <xsl:choose>
      <xsl:when test="@role='step'">
         <xsl:call-template name="step"/>
      </xsl:when>
      <xsl:otherwise>
         <hr />
         <div>
           <div onclick="js:togglemenu(&quot;{$uid}&quot;)" class="moduletitle">
             <xsl:value-of select="@title"/>
           </div>
         </div>
         <div class="sublevel" id="{$uid}">
           <xsl:apply-templates select="*"/>
         </div>
         <hr />
       </xsl:otherwise>
     </xsl:choose>
  </xsl:template>

<!-- Match Any Step -->
  <xsl:template name="step">
    <xsl:variable name="uid" select="generate-id()"/>
    <xsl:variable name="num">
      <xsl:choose>
        <xsl:when test="@serial">
	  <xsl:value-of select="@serial"/>
	</xsl:when>
        <xsl:otherwise>
	  <xsl:value-of select="count(preceding-sibling::cml:module[@role='step']) + 1"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <!-- For outer steps just give brief title and HR -->
      <!-- i.e when there are descendant steps          -->
      <xsl:when test="descendant::cml:module[@role='step']">
        <div>
          <div onclick="js:togglemenu(&quot;{$uid}&quot;)" class="steptitle">
            <a><xsl:value-of select="@dictRef"/> Step <xsl:value-of select="$num"/></a>
          </div>
        </div>
        <div class="sublevel" id="{$uid}">
          <xsl:apply-templates select="*"/>
	  <!-- here put graphs of substeps ... -->
	  <xsl:if test="@dictRef = 'SCF' or dictRef = 'MD'">
	    <xsl:variable name="SCFnodeSet1">
	      <xsl:call-template name="selectNestedGraphNodes">
		<xsl:with-param name="subTree" select="."/>
		<xsl:with-param name="stepType" select="'SCF'"/>
		<xsl:with-param name="propertyName" select="'siesta:Eharrs'"/>
	      </xsl:call-template>
	    </xsl:variable>
	    <xsl:variable name="SCFgraph1">
	      <xsl:call-template name="drawGraph">
		<xsl:with-param name="graphTitle" select="'Harris energy'"/>
		<xsl:with-param name="xAxisTitle" select="'SCF Step'"/>
		<xsl:with-param name="yAxisTitle" select="'Energy / eV'"/>
		<xsl:with-param name="pointSet" select="exsl:node-set($SCFnodeSet1)"/>
	      </xsl:call-template>
	    </xsl:variable>
	    <div><xsl:copy-of select="$SCFgraph1"/></div>
	  </xsl:if>
        </div>
      </xsl:when>
      <!-- For the Inner most steps only create a summary table -->
      <!-- i.e when there are NO descendant steps               -->
        <xsl:otherwise> 
        <xsl:variable name="count">
          <xsl:number count="cml:module[@role='step']"/>
        </xsl:variable>
	<!-- only output the table on the first step. -->
        <xsl:if test="$count=1">
	  <xsl:variable name="thisId" select="generate-id()"/>
          <div class="listTitle"><xsl:value-of select="@dictRef"/> Steps</div>
          <div>Table <input type="button" value="Show" onclick="js:toggleButton(this, &quot;{$thisId}&quot;)"/></div>
	      <xsl:for-each select="cml:propertyList/cml:property">
	        <xsl:variable name="thisDictRef" select="@dictRef"/>
	        <xsl:variable name="theseUnits" select="@units"/>
		<!-- Only output properties that are there for every SCF step. Should really build up a list here .-->
                <xsl:if test="count(../../../cml:module[@role='step']/cml:propertyList/cml:property[@dictRef=$thisDictRef]) = (count(../../../cml:module[@role='step'])-1)">
                  <xsl:variable name="graphNodeSet">
                    <xsl:call-template name="selectNestedGraphNodes">
                      <xsl:with-param name="stepType" select="'CG'"/>
                      <xsl:with-param name="propertyName" select="$thisDictRef"/>
                    </xsl:call-template>
                  </xsl:variable>

                  <xsl:variable name="Graph">
                    <xsl:call-template name="drawGraph">
                      <xsl:with-param name="graphTitle" select="$thisDictRef"/>
                      <xsl:with-param name="xAxisTitle" select="'Step'"/>
                      <xsl:with-param name="yAxisTitle" select="$theseUnits"/>
                      <xsl:with-param name="pointSet" select="exsl:node-set($graphNodeSet)"/>
                     </xsl:call-template>
                  </xsl:variable>
	        </xsl:if>
            </xsl:for-each>
          </table>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose> 
  </xsl:template>
  
</xsl:stylesheet>
