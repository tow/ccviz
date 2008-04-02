<?xml version="1.0" encoding="UTF-8" ?>

<!--===================== STRUCTURES =========================-->

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:str="http://exslt.org/strings" 
        xmlns:cml="http://www.xml-cml.org/schema"
        xmlns="http://www.w3.org/1999/xhtml"
        exclude-result-prefixes="xsl str"
        extension-element-prefixes="str">

  <!-- cmlCore:molecule -->
  <xsl:template match="cml:molecule">
    <xsl:param name="natoms" select="count(cml:atomArray/cml:atom)"/>
    <xsl:param name="num">  
      <xsl:number level="any"/>
    </xsl:param>
    <div class="listTitle">Structure</div>
    <xsl:call-template name="makejmol">
      <xsl:with-param name="natoms" select="$natoms"/>
    </xsl:call-template>

    <br /><br />
    <!-- COORDINATES -->
    <xsl:call-template name="coords">
      <xsl:with-param name="num" select="$num"/>
    </xsl:call-template>
    
  </xsl:template>
  
  <xsl:template name="makejmol">
    <xsl:param name="natoms"/>
    <xsl:param name="num" select="generate-id()"/>
    <xsl:param name="parentId" select="concat('parent_', $num)"/>
    <xsl:param name="thisId" select="concat('mol_', $num)"/>
    <xsl:param name="height">
      <xsl:choose>
        <xsl:when test="$natoms &lt; 10">
          <xsl:value-of select="200"/>
        </xsl:when>
        <xsl:when test="$natoms &gt; 10 and $natoms &lt; 50">
	    <xsl:value-of select="400"/>
        </xsl:when>
        <xsl:when test="$natoms &gt; 50">
	    <xsl:value-of select="600"/>
        </xsl:when>
      </xsl:choose>
    </xsl:param>
    <xsl:param name="width">
      <xsl:choose>
        <xsl:when test="$natoms &lt; 10">
          <xsl:value-of select="200"/>
        </xsl:when>
        <xsl:when test="$natoms &gt; 10 and $natoms &lt; 50">
	    <xsl:value-of select="400"/>
        </xsl:when>
        <xsl:when test="$natoms &gt; 50">
	    <xsl:value-of select="600"/>
        </xsl:when>
      </xsl:choose>
    </xsl:param>
    <div>
      <div style="display:none;">
        <cml:cml id="{$thisId}">
	  <xsl:copy-of select="./cml:molecule"/>
	  <!-- <xsl:copy-of select="./cml:crystal"/>
	  <xsl:copy-of select="./cml:lattice"/> -->
        </cml:cml>
      </div>
      <input type="button" value="Activate Jmol viewer" onclick="javascript:toggleJmol([{$width},{$height}], this, &quot;{$thisId}&quot;, &quot;{$parentId}&quot;)"/>
      <div id="{$parentId}" class="jmol" style="display:none;"/>
    </div>
  </xsl:template>


  <!-- JMOL MOVIE -->
  <xsl:template name="movie">
    <xsl:param name="natoms" select="count(//cml:molecule[position()=1]/cml:atomArray/cml:atom)"/>
    <xsl:param name="height">
      <xsl:choose>
        <xsl:when test="$natoms &lt; 10">
          <xsl:value-of select="200"/>
        </xsl:when>
        <xsl:when test="$natoms &gt; 10 and $natoms &lt; 50">
	    <xsl:value-of select="400"/>
        </xsl:when>
        <xsl:when test="$natoms &gt; 50">
	    <xsl:value-of select="600"/>
        </xsl:when>
      </xsl:choose>
    </xsl:param>
    <xsl:param name="width">
      <xsl:choose>
        <xsl:when test="$natoms &lt; 10">
          <xsl:value-of select="200"/>
        </xsl:when>
        <xsl:when test="$natoms &gt; 10 and $natoms &lt; 50">
	    <xsl:value-of select="400"/>
        </xsl:when>
        <xsl:when test="$natoms &gt; 50">
	    <xsl:value-of select="600"/>
        </xsl:when>
      </xsl:choose>
    </xsl:param>
    <div class="listTitle">Animation</div>
    <div>
      <div style="display:none;">
        <cml:cml id="animation">
          <cml:list convention="JMOL-ANIMATION">
            <xsl:for-each select="//cml:molecule">
              <cml:molecule id="FRAME{position()}">
                <xsl:copy-of select="./cml:atomArray"/>
	      </cml:molecule>
            </xsl:for-each>
          </cml:list>
        </cml:cml>
      </div>
      <input type="button" value="Activate Jmol viewer" onclick="javascript:toggleJmol([{$width},{$height}], this, &quot;animation&quot;, &quot;parentAnim&quot;)"/>
      <object id="parentAnim" class="jmol" style="display:none;"/>
   </div>
  </xsl:template>

 
  <!-- COORDINATES FILE -->
  <xsl:template name="coords">  
    <xsl:param name="num"/>
    <xsl:variable name="id" select="concat('pos_', $num)"/>
    <!--         <title><xsl:value-of select="$file"/></title> -->
    <xsl:variable name="uid" select="generate-id()"/>
    <input type="button" value="View coordinates" onclick="js:togglemenu(&quot;{$uid}&quot;)"/>
    <div class="sublevel" id="{$uid}">
      <table class="coords">
        <tr class="coords">
          <th class="coords">Atom #</th>
          <xsl:if test="cml:atomArray/cml:atom/@elementType"><th class="coords">Element</th></xsl:if>
          <xsl:if test="cml:atomArray/cml:atom/@x3"><th class="coords">x / &#x00C5;ng</th></xsl:if>
          <xsl:if test="cml:atomArray/cml:atom/@y3"><th class="coords">y / &#x00C5;ng</th></xsl:if>
          <xsl:if test="cml:atomArray/cml:atom/@z3"><th class="coords">z / &#x00C5;ng</th></xsl:if>
          <xsl:if test="cml:atomArray/cml:atom/@xyz3">
            <th class="coords">x / &#x00C5;ng</th>
	    <th class="coords">y / &#x00C5;ng</th>
	    <th class="coords">z / &#x00C5;ng</th>
          </xsl:if>
          <xsl:if test="cml:atomArray/cml:atom/@xFract"><th class="coords">x (Frac)</th></xsl:if>
          <xsl:if test="cml:atomArray/cml:atom/@yFract"><th class="coords">y (Frac)</th></xsl:if>
          <xsl:if test="cml:atomArray/cml:atom/@zFract"><th class="coords">z (Frac)</th></xsl:if>
          <xsl:if test="cml:atomArray/cml:atom/@xyzFract">
            <th class="coords">x (Frac)</th>
            <th class="coords">y (Frac)</th>
	    <th class="coords">z (Frac)</th>
          </xsl:if>
          <xsl:if test="cml:atomArray/cml:atom/@occupancy"><th class="coords">Occ.</th></xsl:if>
          <xsl:if test="cml:atomArray/cml:atom/@formalCharge"><th class="coords">Charge</th></xsl:if>
        </tr>
        <xsl:for-each select="cml:atomArray/cml:atom">
	  <tr class="coords">
	    <td class="coords"><xsl:value-of select="position()"/></td>
            <xsl:if test="@elementType"><td class="coords"><xsl:value-of select="@elementType"/></td></xsl:if>
	    <xsl:if test="@x3"><td class="coords"><xsl:value-of select="format-number(@x3, '###0.000')"/></td></xsl:if>
            <xsl:if test="@y3"><td class="coords"><xsl:value-of select="format-number(@y3, '###0.000')"/></td></xsl:if>
            <xsl:if test="@z3"><td class="coords"><xsl:value-of select="format-number(@z3, '###0.000')"/></td></xsl:if>
	    <xsl:if test="@xyz3">
	      <xsl:for-each select="str:tokenize(@xyz3,' ')">
	        <!--  <TD><xsl:value-of select="format-number(., '###0.000')"/></TD> -->
                <td class="coords"><xsl:value-of select="."/> </td>
	      </xsl:for-each>
	    </xsl:if>
	    <xsl:if test="@xFract"><td class="coords"><xsl:value-of select="format-number(@xFract, '###0.000')"/></td></xsl:if>
	    <xsl:if test="@yFract"><td class="coords"><xsl:value-of select="format-number(@yFract, '###0.000')"/></td></xsl:if>
	    <xsl:if test="@zFract"><td class="coords"><xsl:value-of select="format-number(@zFract, '###0.000')"/></td></xsl:if>
	    <xsl:if test="@xyzFract">
	      <xsl:for-each select="str:tokenize(@xyz3,' ')">
	        <!-- <TD><xsl:value-of select="format-number(., '###0.000')"/></TD> -->
                <td class="coords"><xsl:value-of select="."/> </td>
	      </xsl:for-each>
	    </xsl:if>
	    <xsl:if test="@formalCharge"><td class="coords"><xsl:value-of select="format-number(@formalCharge, ' ##;-##')"/></td></xsl:if>
  	  </tr>
        </xsl:for-each>
      </table>
    </div>
    <script type="text/javascript">
      //
      var divnode=document.getElementById(&quot;<xsl:value-of select="$id"/>&quot;)
      //
    </script>
  </xsl:template>

</xsl:stylesheet>
