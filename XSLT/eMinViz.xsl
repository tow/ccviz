<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:cml="http://www.xml-cml.org/schema"
        xmlns="http://www.w3.org/1999/xhtml"
        exclude-result-prefixes="xsl"
        >

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
    <xsl:when test="/cml:cml/cml:metadataList/cml:metadata[@name='siesta:Program']">
     <xsl:value-of select="/cml:cml/cml:metadataList/cml:metadata[@name='siesta:Program']/@content"/>
    </xsl:when>
    <xsl:when test="/cml:cml/cml:metadataList/cml:metadata[@name='dl_poly:Program']">
     <xsl:value-of select="/cml:cml/cml:metadataList/cml:metadata[@name='dl_poly:Program']/@content"/>
    </xsl:when>
    <!-- <xsl:when test="/cml:cml/cml:metadataList/cml:metadata[@name='dc:creator']">
    <xsl:message> Three </xsl:message>
     <xsl:value-of select="/cml:cml/cml:metadata[@name='dc:creator']/@content"/>
    </xsl:when> -->
    <xsl:when test="/cml:cml/cml:metadataList/cml:metadata[@name='dc:identifier']/@content = 'DL_POLY version 3.06 / March 2006'">
      <xsl:text>DL_POLY</xsl:text>
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


  <xsl:output method="xml" version="1.0" encoding="UTF-8" 
    omit-xml-declaration="no" standalone="yes"
    doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
    doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
    indent="yes" media-type="application/xhtml+xml"/>


<!-- MAIN TEMPLATE -->
  <xsl:template match="/">
    <html>
      <head>
	<title>
	  <xsl:value-of select="$prog"/>
	  <xsl:text> Output</xsl:text>
	</title>
        <style type="text/css">
          <xsl:call-template name="css-style"/>
        </style>
        <xsl:if test="$Jmol!='false'">
          <script type="text/javascript" src="http://www.eminerals.org/jmol/JmolX.js"/>
        </xsl:if>

        <script type="text/javascript">
          <xsl:call-template name="mainJavascript"/>
        </script>
      </head>

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
            <xsl:call-template name="top.level.section">
              <xsl:with-param name="uid" select="'initialMetadata'"/>
              <xsl:with-param name="title" select="'Simulation Metadata'"/>
              <xsl:with-param name="templates" select="/cml:cml/cml:metadataList[position()=1]"/>
            </xsl:call-template>
            <xsl:call-template name="top.level.section">
              <xsl:with-param name="uid" select="'inputParams'"/>
              <xsl:with-param name="title" select="'Input Parameters'"/>
              <xsl:with-param name="templates" select="/cml:cml/cml:parameterList[position()=1]"/>
            </xsl:call-template>
            <xsl:call-template name="top.level.section">
              <xsl:with-param name="uid" select="'initialState'"/>
              <xsl:with-param name="title" select="'Initial State of System'"/>
              <xsl:with-param name="templates" select="/cml:cml/cml:module[@title='Initial System']"/>
            </xsl:call-template>
            <xsl:call-template name="top.level.section">
              <xsl:with-param name="uid" select="'mainBody'"/>
              <xsl:with-param name="title" select="'Main body of simulation'"/>
              <xsl:with-param name="templates" select="/cml:cml/cml:module"/>
            </xsl:call-template>
            <xsl:call-template name="top.level.section">
              <xsl:with-param name="uid" select="'finalState'"/>
              <xsl:with-param name="title" select="'Final State of simulation'"/>
              <xsl:with-param name="templates" select="/cml:cml/cml:module[@title='Finalization']"/>
            </xsl:call-template>
            <xsl:variable name="uid" select="'summaryInfo'"/>
            <br/>
            <div onclick="js:togglemenu(&quot;{$uid}&quot;)" class="divisionTitle clickableDiv">
              <xsl:text>Summary Information</xsl:text>
            </div>
            <div class="sublevel" id="{$uid}">
              <xsl:call-template name="summary"/>
	    </div>
            <br/>
            <hr/>
          </div>
        </div>
<!-- -->

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
    <br/>
    <div onclick="js:togglemenu(&quot;{$uid}&quot;)" class="divisionTitle clickableDiv">
      <xsl:value-of select="$title"/>
    </div>
    <div class="sublevel" id="{$uid}">
       <xsl:apply-templates select="$templates"/>
    </div>
    <br/>
  </xsl:template>

  <xsl:template name="css-style">
    <xsl:text>
      <![CDATA[
        html       {
                     height:100%;
                     max-height:100%;
                     padding:0;
                     margin:0;
                     border:0;
                     background:#fff;
                     overflow: hidden;
                   }
        body       {
                     font-family: serif;
                     background: #ffffff;
                     height:100%;
                     max-height:100%;
                     overflow:hidden;
                     padding:0;
                     margin:0;
                     border:0;
                   }
        table      { text-align: center; 
		     border-collapse: collapse; 
		     }
	table.prop { 
	  	     text-align: right; 
	             border-collapse: collapse; 
	             border-left: hidden; 
		     border-right: hidden;
		     border-top: 1px solid Gray; 
		     border-bottom: 1px solid Gray; 
		     }
        table.structure { background: #ffffff; }

        .step       { 
                      border: 1px solid Gray;
                    }
        th.step     {
                      background: #aa2222;
                    }
        td.step     {
                      font-family: monospace;
                      background: #cc9999;
                    }
        td.stepnum { background: #ffffff; ; }

        .coords { border: 1px solid Gray;}

	.graph     {
                     text-align: left;
                   }
	
	th        { font-weight: bold; }
	td        { padding-left: 7px; padding-right: 7px;}
	.bigTitle 
                  {
                    color: #ffffff; 
                    background: Navy;    
                    font-weight: bold; 
                    margin: 0px; 
                    padding: 2px;
                    font-size: xx-large;
                  }
	.divisionTitle {
                  }
        .listTitle
                  {
                    font-weight: 900;
                    font-size: x-large;
                    margin-top: 2.5ex;
                    margin-bottom: 2.5ex;
                  }
	.clickable { 
                    text-decoration: underline;
                    color: #ffffff; 
                    background: #4682B4; 
                    cursor: pointer; 
                   }
	.eigen    { text-align: right; padding-left: 7px; padding-right: 7px; }
	.band     { vertical-align: text-top; }
	.toplevel { display: block; font-weight: 400; margin-bottom: 0; }
        .clickableDiv {color: #ffffff;
                    background: #4682B4;
                    font-weight: bold;
                    font-size: x-large;
                    border-width-top: 0px;
                    border-width-left: 0px;
                    border-width-right: 5px;
                    border-width-bottom: 5px;
                    border-color: #7dB7FF;
                    border-style: solid;
                    }
        .clickableDiv:hover {
                    color: #9999ff; 
                    }
        .moduletitle {
                    padding: 5px;
                    margin-top: 10px;
                    margin-bottom: 10px;
                     }
        .steptitle   {
                    padding: 5px;
                    margin-top: 10px;
                    margin-bottom: 10px;
                     }
        .switch      { color: #ffffff;
                       background: #4682B4;
                       font-weight: bold;
                       cursor: pointer;
                       display: inline;
                       font-size: medium; }
	.sublevel { display: none; font-weight: normal; margin-left: 20px; margin-top: 0; line-height: 14px; }
        .paramname {color: #0000ff; }
        .paramvalue {color: #ff0000; }
        #head        {
                       position:absolute; margin:0; top:0; left:0; display:block; width:100%; height:50px; z-index:5; color:#fff; background: Navy;
                     }
        #foot        {
                       position:absolute; margin:0; bottom:0; left:0; display:block; width:100%; height:25px; background:rgb(233,238,242); font-size:0.8em; z-index:5; text-align:right; color:rgb(157,78,84);
                     }
        #maindisplay {
                       position:absolute;
                       left:0;
                       top:50px;
                       bottom:25px;
                       z-index: 4;
                       width:80%;
                       overflow:auto;
                     }
        #dictdisplay {
                       position:absolute;
                       left:80%;
                       top:50px;
                       bottom:25px;
                       z-index: 4;
                       width:20%;
                       overflow:auto;
                     }
        * html #maindisplay, * html #dictdisplay {
                       height:100%;
                       top:0;
                       bottom:0;
                       border-top:50px solid #fff;
                       border-bottom:25px solid #fff;}
        .innerMain  {
                       display:block;
                       padding:0 10px 10px 10px;
                    }
        .innerDict {
                       display:block;
                       padding:0 10px 10px 10px;
                       padding-bottom:300%;
                    }

        .dictEntry  { 
                       font-family: sans-serif;
                       font-weight: bold;
                       font-size: medium;
                    }
        .dictDefinition { 
                       font-family: serif;
                       font-weight: normal;
                       font-size: small; 
                         }
        .dictDescription { 
                       font-family: serif;
                       font-weight: normal;
                       font-size: small; 
                       font-style: italic;
                         }

      ]]>
    </xsl:text>
  </xsl:template>

  <xsl:template name="mainJavascript">
    <xsl:text>
      //<![CDATA[
      function togglemenu(submenu) { 
        if (document.getElementById(submenu).style.display == "none") {
          document.getElementById(submenu).style.display = "block";
        }
        else {
          document.getElementById(submenu).style.display = "none";
         }
      }

      function toggleButton(button, submenu) { 
        if (document.getElementById(submenu).style.display == "none") {
          document.getElementById(submenu).style.display = "block";
          button.setAttribute('value', 'Hide');
        }
        else {
          document.getElementById(submenu).style.display = "none";
          button.setAttribute('value', 'Show');
         }
      }

      function toggleJmol(sz, inputNode, thisId, parentId) {
        // Grab object node to be created.
        var appNode = document.getElementById(parentId);

        if (appNode.hasChildNodes()) {
          var newAppNode = document.createElementNS('http://www.w3.org/1999/xhtml','object');
          newAppNode.setAttribute('style', "display:none;")
          var newMessage = 'Activate Jmol viewer';
        }
        else {
          var newAppNode = jmolXAppletNodeId(sz, thisId, "background white", nameSuffix=thisId);
          var newMessage = 'Deactivate Jmol viewer';
        }
        appNode.parentNode.replaceChild(newAppNode, appNode);
        inputNode.setAttribute('value', newMessage);
      }

      //]]>
    </xsl:text>
  </xsl:template>

</xsl:stylesheet>
