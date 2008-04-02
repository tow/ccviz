<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns="http://www.w3.org/1999/xhtml"
        xmlns:exsl="http://exslt.org/common"
        xmlns:cml="http://www.xml-cml.org/schema"
        extension-element-prefixes="exsl"
        >

  <xsl:import href="graph_bits.xsl"/>
  
<!-- 
Unlike the previous version, this leaves graph generation until runtime.
Here we just collate the values to be later graphed (by flot)
-->

  <xsl:template name="summaryGraphs">

    <div class="listTitle">Graphs by timestep</div>
    
<script id="source" language="javascript" type="text/javascript">
<xsl:text disable-output-escaping="yes">// &lt;![CDATA[
<![CDATA[
var propertyArrays = [];

function graph(id, name) {

  var p = $(id);

  if (p.css("display")!="none") {
    p.width(500);
    p.height(300);
    // setup plot

    var options = {
        legend: { show: true },
        lines: { show: true },
        points: { show: true },
        yaxis: { noTicks: 10 },
        selection: { mode: "xy" }
    };

    d = [ { label: name+"/"+propertyArrays[name]["units"], data: propertyArrays[name]["data"] } ];

    var plot = $.plot(p, d, options);

    p.bind("selected", function (event, area) {
        // do the zooming
        plot = $.plot(p, d,
                      $.extend(true, {}, options, {
                          xaxis: { min: area.x1, max: area.x2 },
                          yaxis: { min: area.y1, max: area.y2 }
                      }));
    });
  };
};
// ]]]]></xsl:text>
<xsl:text disable-output-escaping="yes">></xsl:text>
</script>


    <table class="graph">
      <xsl:for-each select="//cml:cml[cml:module/@role='step']">
	<xsl:variable name="steps" select="cml:module[@role='step']"/>

	<!-- find all scalar numerical properties that are output in the first steps: -->
	<xsl:for-each select="$steps[position()=1]/cml:propertyList/cml:property">
	  <xsl:if test="cml:scalar/@dataType = 'xsd:integer' or cml:scalar/@dataType = 'xsd:decimal' or cml:scalar/@dataType = 'xsd:float' or cml:scalar/@dataType = 'xsd:double' or cml:scalar/@dataType = 'fpx:real'">
	    <xsl:variable name="dictRef" select="@dictRef"/>
	    <!-- is this variable also output in the last step? -->
	    <xsl:if test="$steps[position()=last()]/cml:propertyList/cml:property[@dictRef=$dictRef]">
	      <!-- then output an array of all the values by step -->
	      <script language="javascript" type="text/javascript">
		<xsl:text>propertyArrays["</xsl:text><xsl:value-of select="@dictRef"/><xsl:text>"] = { units: "</xsl:text><xsl:value-of select="cml:scalar/@units"/><xsl:text>", data: [</xsl:text> 
		<xsl:for-each select="$steps/cml:propertyList/cml:property[@dictRef=$dictRef]">
		  <xsl:text>[</xsl:text><xsl:value-of select="position()"/><xsl:text>,</xsl:text><xsl:value-of select="normalize-space(./cml:scalar/text())"/><xsl:text>]</xsl:text>
		  <xsl:if test="position()!=last()"><xsl:text>,</xsl:text></xsl:if>
		  <!--                 <property><xsl:value-of select="./cml:scalar/text()"/></property> -->
		  <!--                <xsl:copy-of select="."/> -->
		</xsl:for-each>
		<xsl:text>] };</xsl:text> 
	      </script>
	      <xsl:variable name="graphId" select="generate-id()"/>
	      <tr class="graph">
		<td class="graph"><xsl:value-of select="@dictRef"/>:</td>
		<td class="graph"><input type="button" value="Show" onclick="js:toggleButton(this, &quot;{$graphId}&quot;); graph(&quot;#{$graphId}&quot;, &quot;{@dictRef}&quot;)"/></td><br/>
		<div style="display:none;" id="{$graphId}"><!-- <xsl:copy-of select="$graph"/> --></div>
	      </tr>
	    </xsl:if>
	  </xsl:if>
	</xsl:for-each>
      </xsl:for-each>

    </table>
  </xsl:template>

  <xsl:template name="summaryGraphs2">
    <div class="listTitle">Graphs by timestep</div>
    <table class="graph">
    <xsl:variable name="steps" select="/cml:cml/cml:module[@role='step']"/>

    <!-- find all properties that are output in both first and last steps: -->
    <xsl:variable name="properties">
      <xsl:for-each select="$steps[position()=1]/cml:propertyList/cml:property">
        <xsl:variable name="dictRef" select="@dictRef"/>
        <xsl:if test="$steps[position()=last()]/cml:propertyList/cml:property[@dictRef=$dictRef]">
          <xsl:copy-of select="."/>
	</xsl:if>
      </xsl:for-each>
    </xsl:variable>

    <xsl:variable name="allPoints">
      <xsl:call-template name="selectPointsFromNodes">
        <xsl:with-param name="nodes" select="exsl:node-set($steps)"/>
        <xsl:with-param name="propertyNames" select="exsl:node-set($properties)/cml:property/@dictRef"/>
      </xsl:call-template>
    </xsl:variable>
    <!-- for each of said properties ... -->
    <xsl:for-each select="exsl:node-set($properties)/cml:property">
        <xsl:variable name="units" select="cml:scalar/@units"/>
        <!-- lookup units somewhere -->
        <xsl:variable name="dictName">
          <xsl:call-template name="get.dictionary.reference.html">
            <xsl:with-param name="dictRef" select="@dictRef"/>
            <xsl:with-param name="title" select="@title"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="graphNodeSet">
          <xsl:call-template name="selectedPointsFromList">
            <xsl:with-param name="pointList" select="exsl:node-set($allPoints)"/>
            <xsl:with-param name="dictRef" select="@dictRef"/>
	  </xsl:call-template>
	</xsl:variable> 
        <!-- draw the graph -->
        <xsl:variable name="graph">
          <xsl:call-template name="drawGraph">
            <xsl:with-param name="graphTitle" select="$dictName"/>
            <xsl:with-param name="xAxisTitle" select="'Step'"/>
            <xsl:with-param name="yAxisTitle" select="$units"/>
            <xsl:with-param name="pointSet" select="exsl:node-set($graphNodeSet)"/>
          </xsl:call-template> 
        </xsl:variable>
        <!-- output the graph -->
        <xsl:variable name="graphId" select="generate-id()"/>
        <tr class="graph">
          <td class="graph"><xsl:value-of select="$dictName"/>:</td>
          <td class="graph"><input type="button" value="Show" onclick="js:toggleButton(this, &quot;{$graphId}&quot;)"/></td><br/>
          <div style="display:none;" id="{$graphId}"><xsl:copy-of select="$graph"/></div>
        </tr>
    </xsl:for-each>
  </table>
  </xsl:template>

</xsl:stylesheet>
  
