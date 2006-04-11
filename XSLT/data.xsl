<xsl:stylesheet
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:svg="http://www.w3.org/2000/svg"
        xmlns="http://www.w3.org/1999/xhtml"
        xmlns:cml="http://www.xml-cml.org/schema"
        version="1.0">

  <xsl:import href="dictionary.xsl"/>

  <xsl:output method="xml" indent="yes" name="graph"/>
  <xsl:output method="html" indent="yes" name="graphWrapper"/>


  <xsl:template match='/'>

    <!-- Draw a graph of E_KS -->

    <xsl:param name="graphProperty">siesta:E_KS</xsl:param>
    <xsl:param name="graphType">step</xsl:param>
    <xsl:variable name="fileName" select="'graph_E_KS'"/>

    <xsl:apply-templates select="cml/step">
      <xsl:with-param name="graphProperty">
	<xsl:value-of select="$graphProperty"/>
      </xsl:with-param>
      <xsl:with-param name="graphType">
	<xsl:value-of select="$graphType"/>
      </xsl:with-param>
      <xsl:with-param name="outputFile">
	<xsl:value-of select="concat($fileName, '.svg')"/>
      </xsl:with-param>
    </xsl:apply-templates>
    
    <xsl:result-document format="graphWrapper" href="{concat($fileName, '.html')}">

      <HTML>
        <HEAD>
	  <TITLE>Graph <xsl:value-of select="$graphProperty"/></TITLE>
	</HEAD>
	<BODY BGCOLOR="white">
	  <EMBED ALIGN="left" WIDTH="600" HEIGHT="600">
	    <xsl:attribute name="src">
	      <xsl:value-of select="concat($fileName, '.svg')"/>
	    </xsl:attribute>
	  </EMBED>
	</BODY>
      </HTML>
    </xsl:result-document>

    <!-- Draw a graph of Etot per step -->
<!--
    <xsl:param name="graphProperty">siesta:Etot</xsl:param>
    <xsl:param name="graphType">scfStep</xsl:param>

    <xsl:for-each select="cml/step">

      <xsl:variable name="fileName">
	<xsl:value-of select="concat('graph_', position())"/>
      </xsl:variable>

      <xsl:apply-templates select=".">
        <xsl:with-param name="graphProperty">
	  <xsl:value-of select="$graphProperty"/>
        </xsl:with-param>
        <xsl:with-param name="graphType">
	  <xsl:value-of select="$graphType"/>
        </xsl:with-param>
        <xsl:with-param name="outputFile">
	  <xsl:value-of select="concat($fileName, '.svg')"/>
        </xsl:with-param>
        <xsl:with-param name="position">
	  <xsl:value-of select="position()"/>
        </xsl:with-param>
      </xsl:apply-templates>


      <xsl:result-document format="graphWrapper" href="{concat($fileName, '.html')}">

        <HTML>
	  <HEAD>
	    <TITLE>Graph <xsl:value-of select="$graphProperty"/></TITLE>
	  </HEAD>
	  <BODY BGCOLOR="white">
	    <EMBED ALIGN="left" WIDTH="800" HEIGHT="800">
	      <xsl:attribute name="src">
	        <xsl:value-of select="concat($fileName, '.svg')"/>
	      </xsl:attribute>
	    </EMBED>
	  </BODY>
	</HTML>

      </xsl:result-document>

    </xsl:for-each>
-->
  </xsl:template>



  <xsl:template match="step">
    <xsl:param name="graphProperty"/>
    <xsl:param name="graphType"/>
    <xsl:param name="outputFile"/>
    <xsl:param name="position" select="1"/>

    <!-- Chart dimensions -->
    <xsl:param name='chartX' select='350'/>
    <xsl:param name='chartY' select='250'/>
    
    <!-- Max and Min data values -->
    <xsl:param name="maxX">
      <xsl:choose>
 	<xsl:when test="$graphType='step'">
	  <xsl:value-of select="count(//cml/step)"/>
	</xsl:when>
	<xsl:when test="$graphType='scfStep'">
	  <xsl:for-each select="//cml/step">
	    <xsl:if test="position() = $position">
	      <xsl:value-of select="count(step)"/>
	    </xsl:if>
	  </xsl:for-each>
	</xsl:when>
      </xsl:choose>
    </xsl:param>
    <xsl:param name="minX" select="1"/>

    <xsl:param name="maxY">
      <xsl:choose>
	<xsl:when test="$graphType='step'">
	  <xsl:for-each select="//cml/step/propertyList/property[@dictRef = $graphProperty]">
            <xsl:sort data-type="number" select="scalar" order="ascending"/>
            <xsl:if test="position() = last()">
              <xsl:value-of select="scalar"/>
            </xsl:if>
          </xsl:for-each>
	</xsl:when>
	<xsl:when test="$graphType='scfStep'">
	  <xsl:for-each select="//cml/step">
	    <xsl:if test="position() = $position">
	      <xsl:for-each select="step/propertyList/property[@dictRef = $graphProperty]">
                <xsl:sort data-type="number" select="scalar" order="ascending"/>
                <xsl:if test="position() = last()">
                  <xsl:value-of select="scalar"/>
                </xsl:if>
	      </xsl:for-each>
	    </xsl:if>
	  </xsl:for-each>
	</xsl:when>
      </xsl:choose>
    </xsl:param>

    <xsl:param name="minY">
      <xsl:choose>
	<xsl:when test="$graphType='step'">
	  <xsl:for-each select="//cml/step/propertyList/property[@dictRef = $graphProperty]">
            <xsl:sort data-type="number" select="scalar" order="descending"/>
            <xsl:if test="position() = last()">
              <xsl:value-of select="scalar"/>
            </xsl:if>
          </xsl:for-each>
	</xsl:when>
	<xsl:when test="$graphType='scfStep'">
	  <xsl:for-each select="//cml/step">
	    <xsl:if test="position() = $position">
	      <xsl:for-each select="step/propertyList/property[@dictRef = $graphProperty]">
                <xsl:sort data-type="number" select="scalar" order="descending"/>
                <xsl:if test="position() = last()">
                  <xsl:value-of select="scalar"/>
                </xsl:if>
	      </xsl:for-each>
	    </xsl:if>
	  </xsl:for-each>
	</xsl:when>
      </xsl:choose>
    </xsl:param>


    <!-- Max and Min Range values -->

    <!-- Data ranges -->
    <xsl:param name="rangeX" select="$maxX - $minX"/>

    <xsl:param name="rangeY" select="$maxY - $minY"/>

    <!-- Rounded Data Ranges -->    
    <xsl:param name="ceilingX">
      <xsl:choose>
	<xsl:when test="ceiling(($maxX + ($rangeX div 10)) &gt; 0) and ($maxX &lt;= 0)">
	  <xsl:value-of select="0"/>
	</xsl:when>
	<xsl:otherwise>
          <xsl:value-of select="ceiling($maxX + ($rangeX div 10))"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:param>

    <xsl:param name="floorX">
      <xsl:choose>
	<xsl:when test="floor(($minX - ($rangeX div 10)) &lt; 0) and ($minX &gt;= 0)">
  	  <xsl:value-of select="0"/>
        </xsl:when>
	<xsl:otherwise>
          <xsl:value-of select="floor($minX - ($rangeX div 10))"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:param>
    
    <xsl:param name="floorY">
      <xsl:choose>
	<xsl:when test="floor(($minY - ($rangeY div 10)) &lt; 0) and ($minY &gt;= 0)">
  	  <xsl:value-of select="0"/>
        </xsl:when>
	<xsl:otherwise>
          <xsl:value-of select="floor($minY - ($rangeY div 10))"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:param>
    
    <xsl:param name="ceilingY">
      <xsl:choose>
	<xsl:when test="ceiling(($maxY + ($rangeY div 10)) &gt; 0) and ($maxY &lt;= 0)">
	  <xsl:value-of select="0"/>
	</xsl:when>
	<xsl:otherwise>
          <xsl:value-of select="ceiling($maxY + ($rangeY div 10))"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:param>

    <!-- Get the modulus of the max and min y values -->
    <xsl:param name="modFloorY">
      <xsl:choose>
	<xsl:when test="$floorY &lt; 0">
	  <!-- floorY is negative -->
	  <xsl:value-of select="-$floorY"/>
	</xsl:when>
	<xsl:otherwise>
	  <!-- floorY is non-negative -->
	  <xsl:value-of select="$floorY"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:param>    

    <xsl:param name="modCeilingY">
      <xsl:choose>
	<xsl:when test="$ceilingY &lt; 0">
	  <!-- ceilingY is negative -->
	  <xsl:value-of select="-$ceilingY"/>
	</xsl:when>
	<xsl:otherwise>
	  <!-- ceilingY is non-negative -->
	  <xsl:value-of select="$ceilingY"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:param>    

    <!-- Get the maximum of the two modulus values -->
    <xsl:param name="maxModY">
      <xsl:choose>
	<xsl:when test="$modFloorY &gt;= $modCeilingY">
	  <xsl:value-of select="$modFloorY"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="$modCeilingY"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:param>

    <!-- Get the length of the maximum y-axis number -->
    <xsl:param name="yStringLength">
      <xsl:value-of select="string-length($maxModY)"/>
    </xsl:param>

    <!-- Chart Ranges -->    
    <xsl:param name="chartRangeX">
      <xsl:value-of select="$ceilingX - $floorX"/>
    </xsl:param>

    <xsl:param name="chartRangeY">
      <xsl:value-of select="$ceilingY - $floorY"/>
    </xsl:param>
    

    <!-- Chart starting position -->
    <xsl:param name='offsetX' select='40 + 20 * $yStringLength'/>
    <xsl:param name='offsetY' select='75'/>

    <!-- Padding for graph -->
    <xsl:param name='padLeft'   select="$floorX - $minX"/>
    <xsl:param name='padTop'    select="$floorY - $maxY"/>


    <!-- Work out the placing of the x-axis on the graph -->
    <xsl:param name="xAxisPosition">
      <xsl:choose>
        <xsl:when test="$maxY &gt; 0 and $rangeY &lt; $maxY">
	  <xsl:comment>The data is all positive</xsl:comment>
	  <xsl:value-of select="$offsetY + $chartY"/>
  	</xsl:when>
	<xsl:when test="$minY &lt; 0 and $rangeY &lt; ( -1 * $minY )">
	  <xsl:comment>The data is all negative</xsl:comment>
	  <xsl:value-of select="$offsetY"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:comment>The data crosses zero on the y-axis</xsl:comment>
	  <xsl:value-of select="($offsetY) - ($chartY) * ( (0 - $minY + $padTop ) div $chartRangeY)"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:param>

    <!-- Get the definition of the parameter being graphed for
      	 use within the title -->
    <xsl:param name="titleDefinition">
      	<xsl:call-template name="get.dictionary.reference.graph">
	  <xsl:with-param name="dictRef" select="$graphProperty"/>
	</xsl:call-template>
    </xsl:param>

    <xsl:result-document href="{$outputFile}" format="graph">
     
      <svg:svg xmlns:svg="http://www.w3.org/2000/svg" 
	  zoomAndPan="magnify" width="600" height="500">
        <svg:defs>
        <svg:style type="text/css">
          <xsl:text>
	    <![CDATA[
  	      .xAxisLabels {
		      text-anchor: middle;
		      fill: #000000;
		      font-size: 12px;
		      font-weight: normal;
	      }
	      .yAxisLabels {
		      text-anchor: end;
		      fill: #000000;
		      font-size: 12px;
		      font-weight: normal;
	      }
	      .line1 {
		      fill: none;
		      stroke: #ff0000;
		      stroke-width: 1px;	
	      }
	      .background {
		      fill: #ffffff;
		      stroke: #000000;
		      stroke-width: 1px;
	      }
	      .tick {
		      stroke: #000000;
		      stroke-width: 1px;
	      }
	      .axes {
		      stroke: #000000;
		      stroke-width: 3px;
	      }
	      .graphTitle {
		      text-anchor: middle;
		      fill: #000000;
		      font-size: 14px;
		      font-weight: bold;
	      }
	      .axisTitle {
		      text-anchor: middle;
		      fill: #000000;
		      font-size: 12px;
		      font-weight: bold;
	      }
	    ]]>
	  </xsl:text>
	</svg:style>
        </svg:defs>
 
        <xsl:comment> Main Canvas </xsl:comment>
        <svg:rect x='{$offsetX}' y='{$offsetY}' height='{$chartY}' 
  	  width='{$chartX}' class='background'/>

        <xsl:comment> The graph title </xsl:comment>
        <svg:text class="graphTitle" x="{$offsetX +( $chartX div 2)}" y="{$offsetY div 3}"><xsl:value-of select="$titleDefinition"/></svg:text>    
  
        <xsl:comment> Ticks along y </xsl:comment>
        <svg:line class="tick" x1="{$offsetX}" y1="{$offsetY}"
	  x2="{$offsetX - 5}" y2="{$offsetY}"/>
        <svg:line class="tick" x1="{$offsetX}" 
	  y1="{$offsetY + ($chartY div 4) }"   
	  x2="{$offsetX - 5}" y2="{$offsetY + ($chartY div 4) }"/>
        <svg:line class="tick" x1="{$offsetX}" 
	  y1="{$offsetY + 2*($chartY div 4) }" 
	  x2="{$offsetX - 5}" y2="{$offsetY + 2*($chartY div 4) }"/>
        <svg:line class="tick" x1="{$offsetX}" 
	  y1="{$offsetY + 3*($chartY div 4) }" 
	  x2="{$offsetX - 5}" y2="{$offsetY + 3*($chartY div 4) }"/>
        <svg:line class="tick" x1="{$offsetX}" 
	  y1="{$offsetY + $chartY }" 
	  x2="{$offsetX - 5}" y2="{$offsetY + $chartY }"/>

        <xsl:comment>Draw the x-axis - can't assume will be the bottom of the graph</xsl:comment>
        <svg:line class="axes" x1="{$offsetX}" y1="{$xAxisPosition}" x2="{$offsetX + $chartX}"
	  y2="{$xAxisPosition}"/>

        <xsl:comment>Draw the y-axis - for now assume it is down the left of the graph</xsl:comment>
        <svg:line class="axes" x1="{$offsetX}" y1="{$offsetY}" x2="{$offsetX}"
	  y2="{$offsetY + $chartY}"/>

        <xsl:comment> Ticks along x </xsl:comment>
        <xsl:variable name="tickY2Position">
	  <xsl:comment>If the x axis is at the top of the graph, draw the ticks up, else draw them down</xsl:comment>
	  <xsl:choose>
	    <xsl:when test="$xAxisPosition = $offsetY">
	      <xsl:value-of select="$xAxisPosition - 5"/>
	    </xsl:when>
	    <xsl:otherwise>
	      <xsl:value-of select="$xAxisPosition + 5"/>
	    </xsl:otherwise>
	  </xsl:choose>
        </xsl:variable>

        <svg:line class="tick" x1="{$offsetX}" 
	  y1="{$xAxisPosition}" x2="{$offsetX}" 
	  y2="{$tickY2Position}"/>
        <svg:line class="tick" x1="{$offsetX + ($chartX div 4) }" 
	  y1="{$xAxisPosition}" x2="{$offsetX + ($chartX div 4) }" 
	  y2="{$tickY2Position}"/>
        <svg:line class="tick" x1="{$offsetX + 2*($chartX div 4) }" 
	  y1="{$xAxisPosition}" x2="{$offsetX + 2*($chartX div 4) }" 
	  y2="{$tickY2Position}"/>
        <svg:line class="tick" x1="{$offsetX + 3*($chartX div 4) }" 
	  y1="{$xAxisPosition}" x2="{$offsetX + 3*($chartX div 4) }" 
	  y2="{$tickY2Position}"/>
        <svg:line class="tick" x1="{$offsetX + $chartX }" 
	  y1="{$xAxisPosition}" x2="{$offsetX + $chartX }" 
	  y2="{$tickY2Position}"/>
      
        <xsl:comment> Numbering along y </xsl:comment>
        <svg:text class="yAxisLabels" x="{$offsetX - 10}" y="{$offsetY + 5}">
          <xsl:value-of select="format-number($ceilingY, '0.00')"/>
        </svg:text>
        <svg:text class="yAxisLabels" x="{$offsetX - 10}" 
	  y="{$offsetY + ($chartY div 4)  + 5}">
          <xsl:value-of select="format-number($ceilingY - ($chartRangeY div 4), '0.00') "/>
        </svg:text>
        <svg:text class="yAxisLabels" x="{$offsetX - 10}" y="{$offsetY + 2*($chartY div 4)  + 5}">
          <xsl:value-of select="format-number($ceilingY - 2*($chartRangeY div 4), '0.00')"/>
        </svg:text>
        <svg:text class="yAxisLabels" x="{$offsetX - 10}" y="{$offsetY + 3*($chartY div 4)  + 5}">
          <xsl:value-of select="format-number($ceilingY - 3*($chartRangeY div 4), '0.00')"/>
        </svg:text>
        <svg:text class="yAxisLabels" x="{$offsetX - 10}" y="{$offsetY + $chartY  + 5}">
          <xsl:value-of select="format-number($floorY, '0.00')"/>
        </svg:text>

        <xsl:comment> Label for the y-axis</xsl:comment>
        <svg:text class="axisTitle" x="{$offsetX div 4}" 
	  y="{$offsetY + ($chartY div 2) }" transform="rotate(270, {$offsetX div 4}, {$offsetY + ($chartY div 2)})">
	  <xsl:value-of select="substring-after($graphProperty, ':')"/>
        </svg:text>      

        <xsl:comment> Numbering along x </xsl:comment>

        <xsl:variable name="numberingY2Position">
	  <xsl:comment>If the x axis is at the top of the graph, draw the numbers above, else draw them below</xsl:comment>
	  <xsl:choose>
	    <xsl:when test="$xAxisPosition = $offsetY">
	      <xsl:value-of select="$xAxisPosition - 10"/>
	    </xsl:when>
	    <xsl:otherwise>
	      <xsl:value-of select="$xAxisPosition + 20"/>
	    </xsl:otherwise>
	  </xsl:choose>
        </xsl:variable>

        <svg:text class="xAxisLabels" x="{$offsetX}" y="{$numberingY2Position}">
          <xsl:value-of select="format-number($floorX, '0.00')"/>
        </svg:text>
        <svg:text class="xAxisLabels" x="{$offsetX + ($chartX div 4) }" y="{$numberingY2Position}">
          <xsl:value-of select="format-number($floorX + ($chartRangeX div 4), '0.00')"/>
        </svg:text>
        <svg:text class="xAxisLabels" x="{$offsetX + 2*($chartX div 4) }" y="{$numberingY2Position}">
          <xsl:value-of select="format-number($floorX + 2*($chartRangeX div 4), '0.00')"/>
        </svg:text>
        <svg:text class="xAxisLabels" x="{$offsetX + 3*($chartX div 4) }" y="{$numberingY2Position}">
          <xsl:value-of select="format-number($floorX + 3*($chartRangeX div 4), '0.00')"/>
        </svg:text>
        <svg:text class="xAxisLabels" x="{$offsetX + $chartX }" y="{$numberingY2Position}">
          <xsl:value-of select="format-number($ceilingX, '0.00')"/>
        </svg:text>

        <xsl:comment> Label for the x-axis </xsl:comment>
        <xsl:variable name="xAxisLabelYPosition">
	  <xsl:comment>
	    If the x axis is at the top of the graph, draw the label above the graph,
	    if it is at the bottom, draw the label below, if it somewhere in the middle draw the 
	    label to the end of the axis
	  </xsl:comment>

	  <xsl:choose>
	    <xsl:when test="$xAxisPosition = $offsetY">
	      <xsl:value-of select="2 * $offsetY div 3"/>
	    </xsl:when>
	    <xsl:when test="$xAxisPosition = ($offsetY + $chartY)">
	      <xsl:value-of select="$offsetY + $chartY + 40"/>
	    </xsl:when>
	    <xsl:otherwise>
	      <xsl:value-of select="$xAxisPosition"/>
	    </xsl:otherwise>
	  </xsl:choose>
        </xsl:variable>

        <xsl:variable name="xAxisLabelXPosition">
	  <xsl:comment>
	    If the x axis is at the top of the graph, draw the label above the graph,
	    if it is at the bottom, draw the label below, if it somewhere in the middle draw the 
	    label to the end of the axis
	  </xsl:comment>

	  <xsl:choose>
	    <xsl:when test="($xAxisPosition = $offsetY) or ($xAxisPosition = ($offsetY + $chartY))">
	      <xsl:value-of select="$offsetX + ($chartX div 2)"/>
	    </xsl:when>
	    <xsl:otherwise>
	      <xsl:value-of select="$offsetX + $chartX + 20"/>
	    </xsl:otherwise>
	  </xsl:choose>
        </xsl:variable>

        <svg:text class="axisTitle" x="{$xAxisLabelXPosition}" y="{$xAxisLabelYPosition}">
	  Step
        </svg:text>      

        <xsl:comment> Points on graph </xsl:comment>

        <xsl:choose>
	  <xsl:when test="$graphType = 'step'">
	    <xsl:for-each select="//cml/step">
	      <svg:circle r="2">
	        <xsl:attribute name="cx">
	          <xsl:value-of select="$offsetX + ($chartX * ( (position() - $floorX + $padLeft + $minX) div $chartRangeX) )"/>
	        </xsl:attribute>
	        <xsl:attribute name="cy">
	          <xsl:value-of select="$offsetY - $chartY * ( (propertyList/property[@dictRef=$graphProperty]/scalar - $minY + $padTop) div $chartRangeY)"/>
	        </xsl:attribute>
	      </svg:circle>
	    </xsl:for-each>
	  </xsl:when>
	  <xsl:when test="$graphType = 'scfStep'">
	    <xsl:for-each select="//cml/step">
	      <xsl:if test="position() = $position">
	        <xsl:for-each select="step">
 	          <svg:circle r="2">
  	            <xsl:attribute name="cx">
	              <xsl:value-of select="$offsetX + ($chartX * ( (position() - $floorX + $padLeft + $minX) div $chartRangeX) )"/>
	            </xsl:attribute>
	            <xsl:attribute name="cy">
 	              <xsl:value-of 
		        select="($offsetY) - ($chartY) * ( (propertyList/property[@dictRef=$graphProperty]/scalar - $minY + $padTop ) div $chartRangeY)"/>
	            </xsl:attribute>
	          </svg:circle>
	        </xsl:for-each>
	      </xsl:if>
	    </xsl:for-each>
	  </xsl:when>
        </xsl:choose>
   
        <xsl:comment> Lines on graph </xsl:comment>

        <xsl:choose>
	  <xsl:when test="$graphType = 'step'">
	    <svg:polyline class="line1">
	      <xsl:attribute name="points">
	        <xsl:for-each select="//cml/step">
                  <xsl:value-of select="$offsetX + ($chartX * ( (position() - $floorX + $padLeft + $minX) div $chartRangeX ) )"/><xsl:text>, </xsl:text>
                  <xsl:value-of select="($offsetY) - ($chartY) * ( (propertyList/property[@dictRef=$graphProperty]/scalar - $minY + $padTop ) div $chartRangeY)"/><xsl:text> </xsl:text>
	        </xsl:for-each>
	      </xsl:attribute>
	    </svg:polyline>
	  </xsl:when>
	  <xsl:when test="$graphType = 'scfStep'">
	    <xsl:for-each select="//cml/step">
	      <xsl:if test="position() = $position">
 	        <svg:polyline class="line1">
	          <xsl:attribute name="points">
	            <xsl:for-each select="step">
                      <xsl:value-of select="$offsetX + ($chartX * ( (position() - $floorX + $padLeft + $minX) div $chartRangeX ) )"/><xsl:text>, </xsl:text>
                      <xsl:value-of select="($offsetY) - ($chartY) * ( (propertyList/property[@dictRef=$graphProperty]/scalar - $minY + $padTop ) div $chartRangeY)"/><xsl:text> </xsl:text>
	            </xsl:for-each>
	          </xsl:attribute>
	        </svg:polyline>	        
	      </xsl:if>
	    </xsl:for-each>
	  </xsl:when>
        </xsl:choose>

      </svg:svg>

    </xsl:result-document>
    
  </xsl:template>

  <xsl:template match="*"/>

</xsl:stylesheet>
