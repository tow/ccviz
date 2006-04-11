<?xml version="1.0" encoding="UTF-8" ?>
<!-- 
     Copyright (c) 2005 Toby White <tow21@cam.ac.uk>

     Permission is hereby granted, free of charge, to any person obtaining 
     a copy of this software and associated documentation files (the 
     "Software"), to deal in the Software without restriction, including 
     without limitation the rights to use, copy, modify, merge, publish, 
     distribute, sublicense, and/or sell copies of the Software, and to 
     permit persons to whom the Software is furnished to do so, subject to 
     the following conditions:

     The above copyright notice and this permission notice shall be 
      included in all copies or substantial portions of the Software.

     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS 
     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY 
     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--> 


<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:exsl="http://exslt.org/common"
        xmlns:math="http://exslt.org/math"
        xmlns:tohw="http://www.uszla.me.uk/xsl/1.0/functions"
        xmlns:g="http://www.uszla.me.uk/xsl/1.0/graph"
        xmlns="http://www.w3.org/2000/svg"
        extension-element-prefixes="exsl math tohw"
        version="1.0">

  <xsl:import href="graphfuncs.xsl"/>

  <!-- Aid to visualizing geometry:

       In SVG coordinates;


       .________________________________________________________.
       |                                                        |
       |                                                        |
       |                                                        |
       |                                                        |
       |                                                        |
       |                                                        |
       |                                                        | 
       |                                                        | 
       |                                                        |
       |                                                        |
       |                                                        |
       |                                                        |
       .________________________________________________________.

-->




  <xsl:template name="drawGraph">

    <xsl:param name="canvasX" select="600"/>
    <xsl:param name="canvasY" select="500"/>

    <xsl:param name="pointSet"/>
    <xsl:param name="paramSet" select="'None'"/>

    <xsl:param name="xAxisTitle" select="default"/>
    <xsl:param name="yAxisTitle" select="default"/>
    <xsl:param name="graphTitle" select="default"/>

    <!-- Convert floating point numbers to Xpath-compliant numbers. -->

    <xsl:variable name="cleanPointSet">
      <xsl:call-template name="launderTree">
        <xsl:with-param name="tree" select="exsl:node-set($pointSet)"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:call-template name="drawCleanGraph">
      <xsl:with-param name="canvasX" select="$canvasX"/>
      <xsl:with-param name="canvasY" select="$canvasY"/>
      <xsl:with-param name="pointSet" select="exsl:node-set($cleanPointSet)"/>
      <xsl:with-param name="xAxisTitle" select="$xAxisTitle"/>
      <xsl:with-param name="yAxisTitle" select="$yAxisTitle"/>
      <xsl:with-param name="graphTitle" select="$graphTitle"/>
    </xsl:call-template>

  </xsl:template>

  <xsl:template name="drawCleanGraph">

    <!-- Interface to the function; 
	 canvasX:
         canvasY:     size of output graphic in x & y directions.
	              (The size of the actual graph will be smaller, in 
                      order to fit in all the text round the edges.)
	 pointSet:     The data from which the graph will be 
                       generated. The format of pointSet is
                       described in README.
         paramSet:     A set of parameters for the graph. If not
	               supplied, then a (hopefully reasonable)
		       default is calculated below in default-geometry.
		       The format of paramSet is also described in README.
         xAxisTitle: 
         yAxisTitle:   Labels for the x & y axes. These may also be
                       specified in paramSet, but specifying this parameter
                       overrides any paramSet specification.
         graphTitle:   Graph title. This may also be specified in paramSet.                 
                       Again, specifying this parameter overrides any
                       paramSet specification.
   -->
    <!-- Input parameters -->

    <xsl:param name="canvasX" select="600"/>
    <xsl:param name="canvasY" select="500"/>

    <xsl:param name="pointSet"/>
    <xsl:param name="paramSet" select="'None'"/>

    <xsl:param name="xAxisTitle" select="default"/>
    <xsl:param name="yAxisTitle" select="default"/>
    <xsl:param name="graphTitle" select="default"/>

    <!-- Calculate dependent variables -->

    <!-- Work out the min and max X and Y data values 
         Note necessity of number() call to trim whitespace-->
    <xsl:variable name="minX" select="math:min($pointSet/g:pointList/g:point/@x)"/>
    <xsl:variable name="maxX" select="math:max($pointSet/g:pointList/g:point/@x)"/>
    <xsl:variable name="minY" select="math:min($pointSet/g:pointList/g:point/@y)"/>
    <xsl:variable name="maxY" select="math:max($pointSet/g:pointList/g:point/@y)"/>

    <!-- Work out the range of x and y axis values -->
    <xsl:variable name="rangeX" select="$maxX - $minX"/>
    <xsl:variable name="rangeY" select="$maxY - $minY"/>
    <!-- Calculate default graph parameters -->
    <xsl:variable name="gp">
      <xsl:choose>
	<xsl:when test="$paramSet!='None'">
	  <xsl:value-of select="exsl:node-set($paramSet)"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:call-template name="g:default-geometry">
	    <xsl:with-param name="xAxisTitle" select="$xAxisTitle"/>
	    <xsl:with-param name="yAxisTitle" select="$yAxisTitle"/>
	    <xsl:with-param name="canvasX" select="$canvasX"/>
	    <xsl:with-param name="canvasY" select="$canvasY"/>
	    <xsl:with-param name="minX" select="$minX"/>
	    <xsl:with-param name="maxX" select="$maxX"/>
	    <xsl:with-param name="minY" select="$minY"/>
	    <xsl:with-param name="maxY" select="$maxY"/>
	  </xsl:call-template>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <!-- Range of graph -->
    <xsl:variable name="floorX"        select="exsl:node-set($gp)/g:range/@floorX"/>
    <xsl:variable name="ceilingX"      select="exsl:node-set($gp)/g:range/@ceilingX"/>
    <xsl:variable name="floorY"        select="exsl:node-set($gp)/g:range/@floorY"/>
    <xsl:variable name="ceilingY"      select="exsl:node-set($gp)/g:range/@ceilingY"/>
    <xsl:variable name="graphRangeX"   select="exsl:node-set($gp)/g:range/@graphRangeX"/>
    <xsl:variable name="graphRangeY"   select="exsl:node-set($gp)/g:range/@graphRangeY"/>

    <!-- Details of axes -->
       
    <!-- Positions of graph feature on canvas -->
    <xsl:variable name="scaleX"       select="exsl:node-set($gp)/g:positions/@scaleX"/>
    <xsl:variable name="scaleY"       select="exsl:node-set($gp)/g:positions/@scaleY"/>
    <xsl:variable name="canvasRangeX" select="exsl:node-set($gp)/g:positions/@canvasRangeX"/>
    <xsl:variable name="canvasRangeY" select="exsl:node-set($gp)/g:positions/@canvasRangeY"/>
    <xsl:variable name="padLeft"      select="exsl:node-set($gp)/g:positions/@padLeft"/>
    <xsl:variable name="padRight"     select="exsl:node-set($gp)/g:positions/@padRight"/>
    <xsl:variable name="padTop"       select="exsl:node-set($gp)/g:positions/@padTop"/>
    <xsl:variable name="padBottom"    select="exsl:node-set($gp)/g:positions/@padBottom"/>

      <svg zoomAndPan="magnify" width="{$canvasX}" height="{$canvasY}">

<!-- css formatting is not used currently, since it is not
     supported by a sufficiently wide range of user agents.
     (most irritatingly, ksvg; but also inkscape)
     This means lots of duplicated formatting in the svg itself.
     Once ksvg2 is available, I intend to reintroduce the css. -->
<!-- 	<defs>
	  <style type="text/css">
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
	    	.line0 {
			fill: none;
			stroke: #ff0000;
			stroke-width: 1px;
	    	}
	    	.line1 {
			fill: none;
			stroke: #ff0000;
			stroke-width: 1px;
	    	}
	    	.line2 {
			fill: none;
			stroke: #00ff00;
			stroke-width: 1px;
	    	}
	    	.line3 {
			fill: none;
			stroke: #0000ff;
			stroke-width: 1px;
	    	}
	    	.line4 {
			fill: none;
			stroke: #ffff00;
			stroke-width: 1px;
	    	}
	    	.line5 {
			fill: none;
			stroke: #ff00ff;
			stroke-width: 1px;
	    	}
	    	.line6 {
			fill: none;
			stroke: #00ffff;
			stroke-width: 1px;
	    	}
	    	.line7 {
			fill: none;
			stroke: #330000;
			stroke-width: 1px;
	    	}
	    	.line8 {
			fill: none;
			stroke: #003300;
			stroke-width: 1px;
	    	}
	    	.line9 {
			fill: none;
			stroke: #000033;
			stroke-width: 1px;
	    	}
	    	.line10 {
			fill: none;
			stroke: #333300;
			stroke-width: 1px;
	    	}
	    	.background {
			fill: #ff00ff;
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
	  </style>
	</defs> -->
	
	<!-- Make the graph's title -->
	<text class="graphTitle" x="{$padLeft + ($canvasRangeX div 2) }" y="24" font-szie="24px" font-weight="bold" text-anchor="middle">
	  <xsl:value-of select="$graphTitle"/>
	</text>
	
	<!-- Draw canvas for graph -->
	<rect x="{$padLeft}" y="{$padTop}" width="{$canvasRangeX}" height="{$canvasRangeY}" class="background" fill="#fff0ff"/>

	<!-- Draw the axes and add ticks -->

	<!-- x axes: -->
	<xsl:for-each select="exsl:node-set($gp)/g:axis[@type='x']">
	  <xsl:variable name="xpos1" select="@xAxisPos"/>
	  <xsl:variable name="xpos2" select="@xAxisPos2"/>
	  <xsl:variable name="xpos2b" select="@xAxisPos2b"/>
	  <xsl:variable name="xpos3" select="@xAxisPos3"/>
	  <line stroke="black"  stroke-width="3px" class="axes" x1="{$padLeft}" y1="{$xpos1}" x2="{$padLeft + $canvasRangeX}" y2="{$xpos1}"/>
	  <xsl:for-each select="g:tickList/g:tick">
	    <xsl:variable name="xTickPos" select="$scaleX * (@value - $floorX) + $padLeft"/>
            <text class="xAxisLabels" x="{$xTickPos}" y="{$xpos2b}" text-anchor="middle" font-size="12px" font-weight="normal">
	      <xsl:value-of select="@value"/>
            </text>
            <line stroke="black" stroke-width="1px" class="tick" x1="{$xTickPos}" y1="{$xpos1}" x2="{$xTickPos}" y2="{$xpos2}"/>
	  </xsl:for-each>
	  <text class="axisTitle" x="{$padLeft + $canvasRangeX div 2}" y="{$xpos3}" font-size="12px" font-weight="bold">
	    <xsl:value-of select="@title"/>
	  </text>
	</xsl:for-each>
	<!-- y axis: -->
	<xsl:for-each select="exsl:node-set($gp)/g:axis[@type='y']">
	  <xsl:variable name="ypos1" select="@yAxisPos"/>
	  <xsl:variable name="ypos2" select="@yAxisPos2"/>
	  <xsl:variable name="ypos3" select="@yAxisPos3"/>
	  <line stroke="black"  stroke-width="3px" class="axes" x1="{$ypos1}" y1="{$padTop}" x2="{$ypos1}" y2="{$padTop + $canvasRangeY}"/>
	  <xsl:for-each select="g:tickList/g:tick">
	    <xsl:variable name="yTickPos" select="$scaleY * ($ceilingY - @value) + $padTop"/>
            <text class="xAxisLabels" x="{$ypos2}" y="{$yTickPos}" text-anchor="end" font-size="12px" font-weight="normal">
	      <xsl:value-of select="@value"/>
            </text>
            <line stroke="black" stroke-width="1px" class="tick" x1="{$ypos1}" y1="{$yTickPos}" x2="{$ypos2}" y2="{$yTickPos}"/>
	  </xsl:for-each>
	  <text class="axisTitle" x="0" y="0" font-size="12px" font-weight="bold" transform="translate({$ypos3},{$padTop + $canvasRangeY div 2}) rotate(-90)">
	    <xsl:value-of select="@title"/>
	  </text>
	</xsl:for-each>

	<!-- iterate over all graphs that must be drawn: -->
	<xsl:for-each select="$pointSet/g:pointList">

	  <!-- Draw points on graph -->
          <xsl:for-each select="g:point">
	    <xsl:variable name="xScaled" select="$scaleX * (@x - $floorX) + $padLeft"/>
	    <xsl:variable name="yScaled" select="$scaleY * ($ceilingY - @y) + $padTop"/>
            <circle r="2" cx="{$xScaled}" cy="{$yScaled}"/>
	  </xsl:for-each>
	  
	  <!-- Draw lines between points -->
          <polyline fill="none" stroke="red" stroke-width="1">
            <xsl:attribute name="class">
              <xsl:value-of select="concat('line', 1)"/>
            </xsl:attribute>
            <xsl:attribute name="points">
              <xsl:for-each select="g:point"> 
		<xsl:variable name="xScaled" select="$scaleX * (@x - $floorX) + $padLeft"/>
		<xsl:variable name="yScaled" select="$scaleY * ($ceilingY - @y) + $padTop"/>
		<xsl:value-of select="$xScaled"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="$yScaled"/>
		<xsl:text> </xsl:text>
              </xsl:for-each>
          </xsl:attribute>
          </polyline>
	</xsl:for-each>
	
	<!-- Transform coords into the scale of the graph -->
	<g transform="translate({$padLeft},{$canvasY - $padTop}) scale({$scaleX},{-1 * $scaleY}) translate({-1*$floorX},{-1*$floorY})">
	  
	</g>
	
      </svg>
      
  </xsl:template>


  <xsl:template name="g:default-geometry">
    <!-- Calculate necessary variables for plot positions -->
    <xsl:param name="xAxisTitle"/>
    <xsl:param name="yAxisTitle"/>
    <xsl:param name="canvasX"/>
    <xsl:param name="canvasY"/>
    <xsl:param name="minX"/>
    <xsl:param name="maxX"/>
    <xsl:param name="minY"/>
    <xsl:param name="maxY"/>

    <!-- Work out the range of x and y axis values -->
    <xsl:variable name="rangeX" select="$maxX - $minX"/>
    <xsl:variable name="rangeY" select="$maxY - $minY"/>

    <!-- Round the range values to something useable -->
    <xsl:variable name="floorX">
      <xsl:choose>
	<xsl:when test="$rangeX &gt; 0">
	  <xsl:value-of select="floor($minX div tohw:intpow(10,tohw:floorlog10($rangeX)))*tohw:intpow(10,tohw:floorlog10($rangeX))"/>
	</xsl:when>
	<xsl:when test="$minX != 0">
	  <xsl:variable name="fakeMinX" select="0.9 * $minX"/>
	  <xsl:variable name="fakeRangeX" select="0.2 * $minX"/>
	  <xsl:value-of select="floor($fakeMinX div tohw:intpow(10,tohw:floorlog10($fakeRangeX)))*tohw:intpow(10,tohw:floorlog10($fakeRangeX))"/>
	</xsl:when>
	<xsl:otherwise>
	  -1.0
	</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="ceilingX">
      <xsl:choose>
	<xsl:when test="$rangeX &gt; 0">
	  <xsl:value-of select="ceiling($maxX div tohw:intpow(10,tohw:floorlog10($rangeX)))*tohw:intpow(10,tohw:floorlog10($rangeX))"/>
	</xsl:when>
	<xsl:when test="$minX != 0">
	  <xsl:variable name="fakeMaxX" select="1.1 * $minX"/>
	  <xsl:variable name="fakeRangeX" select="0.2 * $minX"/>
	  <xsl:value-of select="ceiling($fakeMaxX div tohw:intpow(10,tohw:floorlog10($fakeRangeX)))*tohw:intpow(10,tohw:floorlog10($fakeRangeX))"/>
	</xsl:when>
	<xsl:otherwise>
	  1.0
	</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="floorY">
      <xsl:choose>
	<xsl:when test="$rangeY &gt; 0">
	  <xsl:value-of select="floor($minY div tohw:intpow(10,tohw:floorlog10($rangeY)))*tohw:intpow(10,tohw:floorlog10($rangeY))"/>
	</xsl:when>
	<xsl:when test="$minY != 0">
	  <xsl:variable name="fakeMinY" select="0.9 * $minY"/>
	  <xsl:variable name="fakeRangeY" select="0.2 * $minY"/>
	  <xsl:value-of select="floor($fakeMinY div tohw:intpow(10,tohw:floorlog10($fakeRangeY)))*tohw:intpow(10,tohw:floorlog10($fakeRangeY))"/>
	</xsl:when>
	<xsl:otherwise>
	  -1.0
	</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="ceilingY">
      <xsl:choose>
	<xsl:when test="$rangeY &gt; 0">
	  <xsl:value-of select="ceiling($maxY div tohw:intpow(10,tohw:floorlog10($rangeY)))*tohw:intpow(10,tohw:floorlog10($rangeY))"/>
	</xsl:when>
	<xsl:when test="$minY != 0">
	  <xsl:variable name="fakeMaxY" select="1.1 * $minY"/>
	  <xsl:variable name="fakeRangeY" select="0.2 * $minY"/>
	  <xsl:value-of select="ceiling($fakeMaxY div tohw:intpow(10,tohw:floorlog10($fakeRangeY)))*tohw:intpow(10,tohw:floorlog10($fakeRangeY))"/>
	</xsl:when>
	<xsl:otherwise>
	  1.0
	</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

      <!-- Get the range of values covered on the axes -->
    <xsl:variable name="graphRangeX" select="$ceilingX - $floorX"/>
    <xsl:variable name="graphRangeY" select="$ceilingY - $floorY"/>
    
    <!-- Work out axis types -->
    <xsl:variable name="xAxisType">
      <xsl:choose>
	  <xsl:when test="$floorY &gt;= 0">
	    <!-- The data is all positive - draw x axis at the bottom -->
	    <xsl:value-of select="'bottom'"/>
	  </xsl:when>
	  <xsl:when test="$ceilingY &lt;= 0">
	    <!-- the data is all negative - draw the x axis at the top -->
	    <xsl:value-of select="'top'"/>
	  </xsl:when>
	  <xsl:otherwise>
	    <!-- The data crosses the x axis, find the nominal height of y=0 -->
	    <xsl:value-of select="'middle'"/>
	  </xsl:otherwise>
	</xsl:choose>
    </xsl:variable>
    <xsl:variable name="yAxisType">
      <xsl:choose>
	  <xsl:when test="$floorX &gt;= 0">
	    <!-- The data is all positive - draw y axis at the left -->
	    <xsl:value-of select="'left'"/>
	  </xsl:when>
	  <xsl:when test="$ceilingX &lt;= 0">
	    <!-- the data is all negative - draw the y axis at the right -->
	    <xsl:value-of select="'right'"/>
	  </xsl:when>
	  <xsl:otherwise>
	    <!-- The data crosses the x axis, find the nominal height of y=0 -->
	    <xsl:value-of select="'middle'"/>
	  </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <!-- We can now calculate the offsets necessary to fit the ticklabels in: -->

    <xsl:variable name="maxyStringLength">
      <xsl:choose>
	<xsl:when test="string-length($ceilingY) &gt; string-length($floorY)">
	  <xsl:value-of select="string-length($ceilingY)"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="string-length($floorY)"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <!-- Work out the padding of the graph within the canvas -->
    <!-- We assume each character of the yAxis label is 20px wide  - we probably ought to query this -->
    <!-- We also force a minimum padding of 10px -->
    <xsl:variable name="padLeft">
      <xsl:choose>
	<xsl:when test="$yAxisType='left' or $yAxisType='both'">
	  <xsl:value-of select="40 + (10 * $maxyStringLength)"/>
	</xsl:when>
	<xsl:when test="$yAxisType='right' or $yAxisType='middle'">
	  <xsl:value-of select="10"/>
	</xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="padRight">
      <xsl:choose>
	<xsl:when test="$yAxisType='left' or $yAxisType='middle'">
	  <xsl:value-of select="10"/>
	</xsl:when>
	<xsl:when test="$yAxisType='right' or $yAxisType='both'">
	  <xsl:value-of select="40 + (20 * $maxyStringLength)"/>
	</xsl:when>
      </xsl:choose>
    </xsl:variable>
    <!-- And we assume (for the moment) a constant y offset -->
    <xsl:variable name="padTop"    select="75"/>
    <xsl:variable name="padBottom" select="75"/>

    <xsl:variable name="canvasRangeX" select="$canvasX - $padLeft - $padRight"/>
    <xsl:variable name="canvasRangeY" select="$canvasY - $padTop - $padBottom"/>

    <!-- Calculate graph scaling -->
    <xsl:variable name="scaleX" select="$canvasRangeX div $graphRangeX"/>
    <xsl:variable name="scaleY" select="$canvasRangeY div $graphRangeY"/>

    <!-- Calculate positions of paddings and axes on global grid-->
    <!-- x axis -->
    <!-- ?AxisPos is the coordinate (in pixel space) where the axis will be drawn.
         ?AxisPos2 is the coordinate where the ticklabel will be drawn -->
    <xsl:variable name="xAxisPos">
      <xsl:choose>
	<xsl:when test="$xAxisType = 'bottom'">
	  <xsl:value-of select="$padTop + $canvasRangeY"/>
	</xsl:when>
	<xsl:when test="$xAxisType = 'top'">
	  <xsl:value-of select="$padTop"/>
	</xsl:when>
	<xsl:when test="$xAxisType = 'middle'">
	  <xsl:value-of select="$padTop + $ceilingY * $scaleY"/>
	</xsl:when>
      </xsl:choose>
    </xsl:variable>
    <!-- where should ticks extend to -->
    <xsl:variable name="xAxisPos2">
      <xsl:choose>
	<xsl:when test="$xAxisType = 'bottom' or $xAxisType = 'middle'">
	  <xsl:value-of select="$xAxisPos + 5"/>
	</xsl:when>
	<xsl:when test="$xAxisType = 'top'">
	  <xsl:value-of select="$xAxisPos - 5"/>
	</xsl:when>
      </xsl:choose>
    </xsl:variable>
    <!-- where should ticklabels be written -->
    <xsl:variable name="xAxisPos2b">
      <xsl:choose>
        <xsl:when test="$xAxisType = 'bottom' or $xAxisType = 'middle'">
          <xsl:value-of select="$xAxisPos2 + 10"/>
        </xsl:when>
        <xsl:when test="$xAxisType = 'top'">
          <xsl:value-of select="$xAxisPos2"/>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>
    <!-- where should we write the axis title -->
    <xsl:variable name="xAxisPos3">
      <xsl:choose>
	<xsl:when test="$xAxisType = 'bottom' or $xAxisType = 'middle'">
	  <xsl:value-of select="$xAxisPos + 30"/>
	</xsl:when>
	<xsl:when test="$xAxisType = 'top'">
	  <xsl:value-of select="$xAxisPos - 20"/>
	</xsl:when>
      </xsl:choose>
    </xsl:variable>
    <!-- y axis -->
    <xsl:variable name="yAxisPos">
      <xsl:choose>
	<xsl:when test="$yAxisType = 'left'">
	  <xsl:value-of select="$padLeft"/>
	</xsl:when>
	<xsl:when test="$yAxisType = 'right'">
	  <xsl:value-of select="$padLeft + $canvasRangeX"/>
	</xsl:when>
	<xsl:when test="$yAxisType = 'middle'">
	  <xsl:value-of select="$padLeft + $floorY * $scaleY"/>
	</xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="yAxisPos2">
      <xsl:choose>
	<xsl:when test="$yAxisType = 'left' or $xAxisType = 'middle'">
	  <xsl:value-of select="$yAxisPos - 5"/>
	</xsl:when>
	<xsl:when test="$yAxisType = 'right'">
	  <xsl:value-of select="$yAxisPos + 5"/>
	</xsl:when>
      </xsl:choose>
    </xsl:variable>
    <!-- where should we write the axis title -->
    <xsl:variable name="yAxisPos3">
      <xsl:choose>
	<xsl:when test="$yAxisType = 'left' or $xAxisType = 'middle'">
	  <xsl:value-of select="$yAxisPos - 20 - 10 * string-length($xAxisTitle)"/>
	</xsl:when>
	<xsl:when test="$yAxisType = 'right'">
	  <xsl:value-of select="$yAxisPos + 20"/>
	</xsl:when>
      </xsl:choose>
    </xsl:variable>

    <g:range 
           floorX     ="{$floorX}" 
           ceilingX   ="{$ceilingX}" 
           floorY     ="{$floorY}"
           ceilingY   ="{$ceilingY}"
           graphRangeX="{$graphRangeX}"
           graphRangeY="{$graphRangeY}"
    />
    
    <g:axis 
           type="x"
           title="{$xAxisTitle}"
           xAxisPos   ="{$xAxisPos}"
           xAxisPos2  ="{$xAxisPos2}"
           xAxisPos2b ="{$xAxisPos2b}"
           xAxisPos3  ="{$xAxisPos3}">
      <xsl:call-template name="g:tickValues">
	<xsl:with-param name="minV" select="$floorX"/>
	<xsl:with-param name="maxV" select="$ceilingX"/>
	<xsl:with-param name="numTicks" select="3"/>
      </xsl:call-template>
    </g:axis>
    <g:axis 
           type="y"
           title="{$yAxisTitle}"
           yAxisPos   ="{$yAxisPos}"
           yAxisPos2  ="{$yAxisPos2}"
           yAxisPos3  ="{$yAxisPos3}">
      <xsl:call-template name="g:tickValues">
	<xsl:with-param name="minV" select="$floorY"/>
	<xsl:with-param name="maxV" select="$ceilingY"/>
	<xsl:with-param name="numTicks" select="4"/>
      </xsl:call-template>
    </g:axis>

    <g:positions
      scaleX      ="{$scaleX}"
      scaleY      ="{$scaleY}"
      canvasRangeX="{$canvasRangeX}"
      canvasRangeY="{$canvasRangeY}"
      padLeft     ="{$padLeft}"
      padRight    ="{$padRight}"
      padTop      ="{$padTop}"
      padBottom   ="{$padBottom}"
    />
    
  </xsl:template>
 

</xsl:stylesheet>
