<xsl:stylesheet version="1.0"
        xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:cml="http://www.xml-cml.org/schema"
        xmlns:str="http://exslt.org/strings"
        extension-element-prefixes="str"
	>

  <xsl:import href="loop.xsl"/>

  <xsl:template match="cml:matrix[@role='plottable']">
    <xsl:param name="cols" select="@columns"/>
    <xsl:variable name="x-values">
      <xsl:call-template name="get-first-row-as-javascript-array">
        <xsl:with-param name="text-input" select="text()"/>
        <xsl:with-param name="row-len" select="@rows"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="y-values">
      <xsl:call-template name="get-other-rows-as-javascript-array">
        <xsl:with-param name="text-input" select="text()"/>
        <xsl:with-param name="row-len" select="@rows"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="graphId" select="generate-id()"/>
    <div class="graph">
      <script id="source" language="javascript" type="text/javascript">
      <xsl:message terminate="no"><xsl:value-of select="text()"/></xsl:message>
	<xsl:text disable-output-escaping="yes">// &lt;![CDATA[
<![CDATA[

function graph(id, name) {
  var xAxis = ]]></xsl:text><xsl:value-of select="$x-values"/><xsl:text disable-output-escaping="yes"><![CDATA[;
  var yAxes = ]]></xsl:text><xsl:value-of select="$y-values"/><xsl:text disable-output-escaping="yes"><![CDATA[;

  var data = [];
  for (i in yAxes) {
    d_ = [];
    for (j in xAxis) {
      d_.push([xAxis[j], yAxes[i][j]]);
    }
    data.push( { data: d_ } );
  }
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

    var plot = $.plot(p, data, options);

    p.bind("selected", function (event, area) {
        // do the zooming
        plot = $.plot(p, data,
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
      <input type="button" value="Show" onclick="js:toggleButton(this, &quot;{$graphId}&quot;); graph(&quot;#{$graphId}&quot;, &quot;{@dictRef}&quot;)"/><br/>
      <div style="display:none;" id="{$graphId}"/>
    </div>
  </xsl:template>  

  <xsl:template match="cml:matrix">
    <xsl:param name="rows" select="@rows"/>
    <xsl:param name="cols" select="@columns"/>
    <xsl:param name="plottable" select="@role='plottable'"/>

    <xsl:variable name="dataString" select="concat(normalize-space(.),' ')"/>
    <table class="prop">
      <tr>
	<th colspan="{$cols}">
	  <xsl:call-template name="get.dictionary.reference.html">
            <xsl:with-param name="dictRef" select="@dictRef"/>
            <xsl:with-param name="value" select="@value"/>
          </xsl:call-template>
	  <xsl:text> (</xsl:text>
	  <xsl:value-of select="@units"/>
	  <xsl:text>) </xsl:text>
  	</th>
      </tr>

      <xsl:call-template name="rows-for-loop">
        <xsl:with-param name="i" select="1"/>
        <xsl:with-param name="increment" select="1"/>
        <xsl:with-param name="testValue" select="$rows"/>
        <xsl:with-param name="innerTestValue" select="$cols"/>
        <xsl:with-param name="outputString" select="$dataString"/>
      </xsl:call-template>
    </table>
  </xsl:template>

  <xsl:template name="get-row-as-table">
  </xsl:template>

  <xsl:template name="get-row-as-csv">
  </xsl:template>

  <xsl:template name="get-first-row-as-javascript-array">
    <xsl:param name="text-input"/>
    <xsl:param name="row-len"/>
    <xsl:text>[</xsl:text>
    <xsl:for-each select="str:tokenize(.)">
      <xsl:if test="position() &lt;= $row-len">
	<xsl:value-of select="."/>
	<xsl:if test="position() != $row-len">
	  <xsl:text>,</xsl:text>
	</xsl:if>
      </xsl:if>
    </xsl:for-each>
    <xsl:text>]</xsl:text>
  </xsl:template>

  <xsl:template name="get-other-rows-as-javascript-array">
    <xsl:param name="text-input"/>
    <xsl:param name="row-len"/>
    <xsl:text>[</xsl:text>
    <xsl:for-each select="str:tokenize(.)">
      <xsl:if test="position() &gt; $row-len">
	<xsl:if test="(position() mod $row-len)=1">
	  <xsl:text>[</xsl:text>
	</xsl:if>
	<xsl:value-of select="."/>
	<xsl:if test="(position() mod $row-len)!=0">
	  <xsl:text>,</xsl:text>
	</xsl:if>
	<xsl:if test="(position() mod $row-len)=0">
	  <xsl:text>]</xsl:text>
	  <xsl:if test="position() != last()">
	    <xsl:text>,</xsl:text>
	  </xsl:if>
	</xsl:if>
      </xsl:if>
    </xsl:for-each>
    <xsl:text>]</xsl:text>
  </xsl:template>


</xsl:stylesheet>
