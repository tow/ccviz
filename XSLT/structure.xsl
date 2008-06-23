<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:str="http://exslt.org/strings" 
        xmlns:cml="http://www.xml-cml.org/schema"
        xmlns="http://www.w3.org/1999/xhtml"
        exclude-result-prefixes="xsl str"
        extension-element-prefixes="str">

  <xsl:template name="makejmol">
    <xsl:param name="uid" select="generate-id()"/>
    <xsl:call-template name="makejmolobject">
      <xsl:with-param name="natoms" select="count(.//cml:atom)"/>
      <xsl:with-param name="uid" select="$uid"/>
    </xsl:call-template>
    <br/>
    <xsl:call-template name="coords"/>
    <div style="display:none;">
      <cml:cml id="mol_{$uid}">
	<xsl:apply-templates mode="jmol"/>
      </cml:cml>
    </div>
  </xsl:template>

  <xsl:template match="cml:molecule"/>

  <xsl:template match="cml:molecule" mode="jmol">
    <xsl:copy-of select="."/>
  </xsl:template>
  <xsl:template match="cml:crystal" mode="jmol">
    <xsl:copy-of select="."/>
  </xsl:template>
  <xsl:template match="cml:lattice" mode="jmol">
    <xsl:copy-of select="."/>
  </xsl:template>
  
  <xsl:template name="makejmolobject">
    <xsl:param name="uid"/>
    <xsl:param name="parentId" select="concat('parent_', $uid)"/>
    <xsl:param name="molId" select="concat('mol_', $uid)"/>
    <xsl:param name="height" select="600"/>
    <xsl:param name="width" select="600"/>
    <div>
      <input class="togglejmol" type="button" value="Activate Jmol viewer" onclick="toggleJmol([{$width},{$height}], this, &quot;{$molId}&quot;, &quot;{$parentId}&quot;)"/>
      <input type="button" value="Use local Jmol" onclick="toggleLocalJmol(this)"/>
      <div id="{$parentId}" class="jmol" style="display:none;"/>
    </div>
  </xsl:template>


  <!-- JMOL MOVIE -->
  <xsl:template name="movie">
    <xsl:param name="height" select="600"/>
    <xsl:param name="width" select="600"/>
    <div class="listTitle">Animation</div>
    <input class="togglejmol" type="button" value="Activate Jmol viewer" onclick="toggleJmolAnimation([{$width},{$height}], this)"/>
    <input type="button" value="Use local Jmol" onclick="toggleLocalJmol(this)"/>
    <div id="jmolanimation">
      <object style="display:none;"/>
   </div>
  </xsl:template>

 
  <!-- COORDINATES FILE -->
  <xsl:template name="coords">  
    <xsl:variable name="uid" select="generate-id()"/>
    <input type="button" value="View coordinates" class="clickable"/>
    <div class="sublevel" id="{$uid}">
      <table class="coords">
        <tr class="coords">
          <th class="coords">Atom #</th>
          <xsl:if test=".//cml:atom/@elementType"><th class="coords">Element</th></xsl:if>
          <xsl:if test=".//cml:atom/@x3"><th class="coords">x / &#x00C5;ng</th></xsl:if>
          <xsl:if test=".//cml:atom/@y3"><th class="coords">y / &#x00C5;ng</th></xsl:if>
          <xsl:if test=".//cml:atom/@z3"><th class="coords">z / &#x00C5;ng</th></xsl:if>
          <xsl:if test=".//cml:atom/@xyz3">
            <th class="coords">x / &#x00C5;ng</th>
	    <th class="coords">y / &#x00C5;ng</th>
	    <th class="coords">z / &#x00C5;ng</th>
          </xsl:if>
          <xsl:if test=".//cml:atom/@xFract"><th class="coords">x (Frac)</th></xsl:if>
          <xsl:if test=".//cml:atom/@yFract"><th class="coords">y (Frac)</th></xsl:if>
          <xsl:if test=".//cml:atom/@zFract"><th class="coords">z (Frac)</th></xsl:if>
          <xsl:if test=".//cml:atom/@xyzFract">
            <th class="coords">x (Frac)</th>
            <th class="coords">y (Frac)</th>
	    <th class="coords">z (Frac)</th>
          </xsl:if>
          <xsl:if test=".//cml:atom/@occupancy"><th class="coords">Occ.</th></xsl:if>
          <xsl:if test=".//cml:atom/@formalCharge"><th class="coords">Charge</th></xsl:if>
        </tr>
        <xsl:for-each select=".//cml:atom">
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
	    <xsl:if test="@occupancy"><td class="coords"><xsl:value-of select="format-number(@occupancy, ' ###0.000')"/></td></xsl:if>
  	  </tr>
        </xsl:for-each>
      </table>
    </div>
    <xsl:apply-templates mode="structure"/>
  </xsl:template>

</xsl:stylesheet>
