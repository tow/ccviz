<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:cml="http://www.xml-cml.org/schema"
        xmlns="http://www.w3.org/1999/xhtml"
	>

  <xsl:import href="toby_graph.xsl"/>

  <xsl:template match="cml:module" mode="noTitle">
    <xsl:variable name="uid" select="generate-id()"/>
    <div>
      <xsl:apply-templates select="*"/>
    </div>
  </xsl:template>

  <xsl:template match="cml:module">
    <xsl:variable name="uid" select="generate-id()"/>
    <xsl:choose>
      <xsl:when test="@role='step'">
         <xsl:call-template name="step"/>
      </xsl:when>
      <xsl:otherwise>
        <div>
           <div class="moduletitle clickableDiv">
             <xsl:value-of select="@title"/>
           </div>
           <div class="sublevel" id="{$uid}">
	     <xsl:apply-templates select="*"/>
	     <xsl:if test="cml:molecule">
	       <xsl:call-template name="makejmol"/>
	     </xsl:if>
           </div>
	</div>
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
      <!-- If we are in a child step; ie we have direct parent steps;
           then we don't want (at this stage, anyway) to output lots of
           crap. Instead, a quick table (and maybe graph) of everything
           that's going on is fine. -->
      <xsl:when test="ancestor::cml:module[@role='step']">
         <xsl:variable name="count">
          <xsl:number count="cml:module[@role='step']"/>
        </xsl:variable>
	<!-- only output the table on the first step. -->
        <xsl:if test="$count=1">
	  <xsl:variable name="thisId" select="generate-id()"/>
          <div class="listTitle"><xsl:value-of select="@dictRef"/> Steps</div>
          <div>Table <input type="button" value="Show" onclick="js:toggleButton(this, &quot;{$thisId}&quot;)"/></div>
          <table class="step" style="display:none;" id="{$thisId}">
            <tr class="step"><th class="step"><xsl:value-of select="@dictRef"/> Step</th>
	      <xsl:for-each select="cml:propertyList/cml:property">
	        <xsl:variable name="thisDictRef" select="@dictRef"/>
		<!-- Only output properties that are there for every SCF step. Should really build up a list here .-->
                <xsl:if test="count(../../../cml:module[@role='step']/cml:propertyList/cml:property[@dictRef=$thisDictRef]) = (count(../../../cml:module[@role='step'])-1)">
	          <th class="step">
	            <xsl:call-template name="get.dictionary.reference.html">
                      <xsl:with-param name="dictRef" select="@dictRef"/>
                      <xsl:with-param name="title" select="@title"/>
                    </xsl:call-template>
	            <xsl:text>(</xsl:text>
	            <xsl:value-of select="cml:scalar/@units"/>
	            <xsl:text>)</xsl:text>
	          </th>
		</xsl:if>
	      </xsl:for-each>
	    </tr>
            <xsl:for-each select="../cml:module[@role='step']">
	      <!-- do not output last step for siesta SCF FIXME -->
	      <xsl:if test="position() != last()">
              <tr class="step">
	        <td class="stepnum">
                  <xsl:choose>
                    <xsl:when test="@serial">
                      <xsl:value-of select="@serial"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select ="position()"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <xsl:for-each select="cml:propertyList/cml:property/cml:scalar"> 
	          <xsl:variable name="thisDictRef" select="../@dictRef"/>
                  <xsl:if test="count(../../../../cml:module[@role='step']/cml:propertyList/cml:property[@dictRef=$thisDictRef]) = (count(../../../../cml:module[@role='step'])-1)">
	            <td class="step"><xsl:value-of select="."/></td>
		  </xsl:if>
                </xsl:for-each>
	      </tr>
	      </xsl:if>
            </xsl:for-each>
          </table>
        </xsl:if>
      </xsl:when> <!-- child step -->
      <xsl:otherwise>
        <xsl:if test="(count(preceding-sibling::cml:module[@role='step'])+1) mod $stepinterval = 0">
        <div>
          <div class="steptitle clickableDiv">
            <a><xsl:value-of select="@dictRef"/> Step <xsl:value-of select="$num"/></a>
          </div>
          <div class="sublevel stepcontents" id="{$uid}">
            <xsl:apply-templates select="*"/>
	  <!-- here put graphs of substeps ... -->
	  <!-- <xsl:if test="@dictRef = 'CG' or dictRef = 'MD'">
	    <xsl:variable name="SCFnodeSet1">
	      <xsl:call-template name="selectNestedGraphNodes">
		<xsl:with-param name="nodes" select="./cml:module[@role='step']"/>
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
	  </xsl:if> -->
	   <xsl:if test="cml:molecule">
	     <xsl:call-template name="makejmol"/>
	   </xsl:if>
          </div>
        </div>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose> 
  </xsl:template>
  
</xsl:stylesheet>
