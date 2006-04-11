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
      <xsl:when test="@type=='step'">
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

</xsl:stylesheet>
<?xml version="1.0" encoding="UTF-8" ?>

<!-- Match Any Step -->
  <xsl:template name="step">
    <xsl:variable name="uid" select="generate-id()"/>
    <xsl:variable name="num"><xsl:number count="cml:step"/></xsl:variable>
    <xsl:variable name="num">
      <xsl:choose>
        <xsl:when test="@serial">
	  <xsl:value-of select="@serial"/>
	</xsl:when>
        <xsl:otherwise>
	  <xsl:number count="parent::cml:module[@type='step']">
	</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <!-- For outer steps just give brief title and HR -->
      <!-- i.e when there are descendant steps          -->
      <xsl:when test="descendant::cml:module[@type='step']">
        <div>
          <div onclick="js:togglemenu(&quot;{$uid}&quot;)" class="steptitle">
            <a><xsl:value-of select="@type"/> Step <xsl:value-of select="$num"/></a>
          </div>
        </div>
        <div class="sublevel" id="{$uid}">
          <xsl:apply-templates select="*"/>
	  <!-- here put graphs of substeps ... -->
	  <xsl:if test="@type = 'SCF' or @type = 'MD'">
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
          <xsl:number count="cml:step"/>
        </xsl:variable>
        <xsl:if test="$count=1">
	  <xsl:variable name="thisId" select="generate-id()"/>
          <div class="listTitle"><xsl:value-of select="@type"/> Steps</div>
          <div>Table <input type="button" value="Show" onclick="js:toggleButton(this, &quot;{$thisId}&quot;)"/></div>
          <table class="step" style="display:none;" id="{$thisId}">
            <tr class="step"><th class="step"><xsl:value-of select="@type"/> Step</th>
	      <xsl:for-each select="cml:propertyList/cml:property">
	        <th class="step">
	          <xsl:call-template name="get.dictionary.reference.html">
                    <xsl:with-param name="dictRef" select="@dictRef"/>
                    <xsl:with-param name="title" select="@title"/>
                  </xsl:call-template>
	          <xsl:text>(</xsl:text>
	          <xsl:value-of select="cml:scalar/@units"/>
	          <xsl:text>)</xsl:text>
	        </th>
	      </xsl:for-each>
	    </tr>
            <xsl:for-each select="../cml:step">
              <tr class="step">
	        <td class="stepnum">
                  <xsl:choose>
                    <xsl:when test="@index">
                      <xsl:value-of select="@index"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select ="position()"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <xsl:for-each select="cml:propertyList/cml:property/cml:scalar"> 
	          <td class="step"><xsl:value-of select="."/></td>
                </xsl:for-each>
	      </tr>
            </xsl:for-each>
          </table>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose> 
  </xsl:template>
  
</xsl:stylesheet>
