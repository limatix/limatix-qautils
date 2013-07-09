<?xml version="1.0" encoding="UTF-8"?>

<!-- 

Run this stylesheet with firefox by adding an xml-stylesheet processing 
instruction to the .chx file. It does not work properly if html is
generated as an intermediate because of some of the bizarre things
that happen when html is parsed by a browser. 

in order to view with Chrome/Chromium, you must close all
chrome/chromium windows and restart it with the 
  allow-file-access-from-files parameter, e.g.
 
  chromium-browser  - - allow-file-access-from-files 
   (remove the excess spaces between the minus signs and before 'a')

  In windows this can be done using a shortcut


Generating html can still be useful for debugging, for example to get line numbers

To do this temporarily change disable-output-escaping to "yes" in xsl:text 
below. Then run: 
xsltproc chx2html.xsl myfile.chx > myfile.html

-->

<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:chx="http://thermal.cnde.iastate.edu/checklist" exclude-result-prefixes="#default">
<xsl:output method="xml" version="1.0" media-type="application/xhtml+xml" encoding="UTF-8" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"/>

<xsl:param name="specimen"/>
<xsl:param name="perfby"/>
<xsl:param name="date"/>
<xsl:param name="dest"/>

<xsl:param name="rawlink_postfix"/> <!-- this is the postfix that should go on a relative URL to make a direct link to a raw file, e.g. "?mode=raw"-->

<xsl:template match="/">
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title><xsl:value-of select="/chx:checklist/chx:cltitle"/></title>
  </head>
  <body>
    <xsl:apply-templates/>
  </body>
</html>
</xsl:template>

<xsl:template name="headertd">
  <xsl:param name="fieldname"/>
  <xsl:param name="fieldval"/>

  <td style="text-align: center">
    <xsl:element name="input">
      <xsl:attribute name="type">text</xsl:attribute>
      <xsl:attribute name="name"><xsl:value-of select="$fieldname"/></xsl:attribute>
      <xsl:attribute name="value"><xsl:value-of select="$fieldval"/></xsl:attribute>
      <xsl:attribute name="style">width: 90%;text-align: center</xsl:attribute>
      <xsl:attribute name="id"><xsl:value-of select="$fieldname"/></xsl:attribute>
      <xsl:attribute name="disabled">true</xsl:attribute>
    </xsl:element>
  </td>
</xsl:template>

<xsl:template match="chx:rationale">
  <!-- empty template... rationale is uplled out separately -->
</xsl:template>

<xsl:template match="chx:checklist">
<form>
<table id="headingtable" width="100%">
  <tr>
    <th>Checklist</th>
    <th>Specimen</th>
    <th>Performed by</th>
    <th>Date</th>
    <th>Destination</th>
  </tr>
  <tr>
    <xsl:call-template name="headertd">
      <xsl:with-param name="fieldname">clinfo</xsl:with-param>
      <xsl:with-param name="fieldval"><xsl:value-of select="chx:clinfo"/></xsl:with-param>
    </xsl:call-template>

    <xsl:call-template name="headertd">
      <xsl:with-param name="fieldname">specimen</xsl:with-param>
      <xsl:with-param name="fieldval"><xsl:value-of select="chx:specimen"/></xsl:with-param>
    </xsl:call-template>

    <xsl:call-template name="headertd">
      <xsl:with-param name="fieldname">perfby</xsl:with-param>
      <xsl:with-param name="fieldval"><xsl:value-of select="chx:perfby"/></xsl:with-param>
    </xsl:call-template>

    <xsl:call-template name="headertd">
      <xsl:with-param name="fieldname">date</xsl:with-param>
      <xsl:with-param name="fieldval"><xsl:value-of select="chx:date"/></xsl:with-param>
    </xsl:call-template>

    <xsl:call-template name="headertd">
      <xsl:with-param name="fieldname">dest</xsl:with-param>
      <xsl:with-param name="fieldval"><xsl:value-of select="chx:dest"/></xsl:with-param>
    </xsl:call-template>

  </tr>
</table>
<h1><xsl:value-of select="chx:cltitle"/></h1>
<xsl:if test="string-length(chx:rationale) &gt; 0">
  <h2>Rationale</h2>
  <p>
    <xsl:apply-templates select="chx:rationale" mode="copydescr"/> <!-- mode==copydescr converts namespace of markup tags to xhtml -->
  </p>
</xsl:if>

<!-- embed scanned pdf if present-->
<xsl:if test="string-length(@scannedpdf) &gt; 0">
  <xsl:element name="object">
    <xsl:attribute name="data"><xsl:value-of select="@scannedpdf"/><xsl:value-of select="$rawlink_postfix"/></xsl:attribute>
    <xsl:attribute name="width">100%</xsl:attribute>
    <xsl:attribute name="height">500</xsl:attribute>
    <xsl:attribute name="type">application/pdf</xsl:attribute>
  </xsl:element>
</xsl:if>
    <a>
      <xsl:attribute name="href"><xsl:value-of select="@scannedpdf"/><xsl:value-of select="$rawlink_postfix"/></xsl:attribute>
      Open PDF of filled checklist
    </a>

<table border="1">
<xsl:apply-templates/>
</table>

<xsl:if test="@allchecked='true'">
Header indicates all boxes checked. 
</xsl:if>

<xsl:if test="chx:notes != ''">
  <h2>Notes</h2>
  <textarea rows="6" cols="80" disabled="true" id="notes">
    <xsl:attribute name="style">border-color:green;border-style:solid;border-weight:thin;</xsl:attribute>
    <xsl:value-of select="chx:notes"/>
  </textarea>
</xsl:if>
<h3>Checklist Log</h3>

      <table style="font-size:x-small;">
      <xsl:for-each select="//chx:logentry">
        <tr>
          <td><xsl:value-of select="@timestamp"/></td>
          <td><xsl:value-of select="."/></td>
        </tr>
      </xsl:for-each>
      </table>

</form>
</xsl:template>


<xsl:template match="chx:checkitem">
  <xsl:variable name="number"><xsl:number/></xsl:variable>
  <xsl:variable name="title">
    <xsl:choose>
      <xsl:when test="string-length(string(@title)) > 0">
	<xsl:value-of select="@title"/>
      </xsl:when>
      <xsl:when test="string-length(string(text())) > 0">
	<xsl:value-of select="text()"/>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>
  <tr>
    <td style="vertical-align: top">
      <xsl:element name="span">
	<xsl:attribute name="id">checkitemnum<xsl:number/></xsl:attribute>
  <xsl:choose>
    <xsl:when test="@checked='true'">
      <xsl:attribute name="style">color:green;</xsl:attribute>
    </xsl:when>
    <xsl:otherwise>
      <xsl:attribute name="style">color:red;font-weight:bold;</xsl:attribute>
    </xsl:otherwise>
  </xsl:choose>
	<xsl:number/>
      </xsl:element>
    </td>
    <td>
      <xsl:element name="span">
	<xsl:attribute name="id">checkitemtitle<xsl:number/></xsl:attribute>
  <xsl:choose>
    <xsl:when test="@checked='true'">
      <xsl:attribute name="style">color:green;</xsl:attribute>
    </xsl:when>
    <xsl:otherwise>
      <xsl:attribute name="style">color:red;font-weight:bold;</xsl:attribute>
    </xsl:otherwise>
  </xsl:choose>
        <xsl:value-of select="@title"/>
        <xsl:value-of select="text()"/>
      </xsl:element>
      <br/>
      <table><tr><td>
        <xsl:apply-templates select="chx:description/node()" mode="copydescr"/>
        <xsl:apply-templates select="chx:parameter[@name='description']/node()" mode="copydescr"/> 
        <xsl:choose><xsl:when test="string-length(string(chx:parameter[@name='dg-command'])) > 0">
  	  <br/>  <!-- line-break -->
	  <tt><xsl:value-of select="chx:parameter[@name='dg-command']"/></tt>
        </xsl:when></xsl:choose>
        <xsl:choose><xsl:when test="string-length(string(chx:parameter[@name='dg-param'])) > 0">
	  <br/>  <!-- line-break -->
	  <tt><xsl:value-of select="chx:parameter[@name='dg-param']"/><xsl:value-of select="string(' ')"/><xsl:value-of select="chx:parameter[@name='dg-paramdefault']"/></tt>
        </xsl:when></xsl:choose>
      </td>
      <xsl:if test="@class='textentry'">
	<td style="text-align: right;">
          <input type="text">
    	    <xsl:if test="count(chx:parameter[@name='width']) > 0">
	      <xsl:attribute name="size"><xsl:value-of select="chx:parameter[@name='width']"/></xsl:attribute>
            </xsl:if>
	    <xsl:attribute name="id">textentry<xsl:number/></xsl:attribute>
	    <xsl:attribute name="value">
	      <xsl:choose><xsl:when test="count(chx:parameter[@name='text']) &gt; 0">
		<xsl:value-of select="normalize-space(chx:parameter[@name='text'])"/>
	      </xsl:when><xsl:otherwise>
		<xsl:value-of select="normalize-space(chx:parameter[@name='initialtext'])"/>
	      </xsl:otherwise></xsl:choose>
	    </xsl:attribute>
	    <xsl:attribute name="disabled">true</xsl:attribute>
	  
	  </input>
        </td>
      </xsl:if>


      <xsl:if test="@class='textgraphic'">
	<xsl:variable name="src">
	      <xsl:call-template name="trimspaces">
		<xsl:with-param name="str">
		  <xsl:value-of select="normalize-space(chx:parameter[@name='image'])"/>
		</xsl:with-param>
	      </xsl:call-template>	  
	</xsl:variable>
	<td style="text-align: right;">
	  <img>
	    <xsl:attribute name="src">
	      <xsl:value-of select="$src"/>
	    </xsl:attribute>
	    <xsl:attribute name="alt">
	      <xsl:value-of select="$src"/>	      
	    </xsl:attribute>
	    <xsl:if test="count(chx:parameter[@name='width']) &gt; 0">
	      <xsl:attribute name="width">
		<xsl:value-of select="round(chx:parameter[@name='width'])"/>
	      </xsl:attribute>
	    </xsl:if>
	  </img>
        </td>
      </xsl:if>


    </tr>
  </table>
  <xsl:if test="//chx:logentry[@item=$number]">
 
    <span style="font-size:xx-small">Last Updated: <xsl:value-of select="(//chx:logentry[@item=$number]/@timestamp)[last()]"/></span>

    </xsl:if>
    </td>
    <td>
      <xsl:element name="input">
	<xsl:attribute name="type">checkbox</xsl:attribute>
	<xsl:attribute name="id">checkitem<xsl:number/></xsl:attribute>
	<xsl:attribute name="value"><xsl:number/></xsl:attribute>
	<xsl:attribute name="disabled">true</xsl:attribute>
	<xsl:if test="@checked='true'">
	  <xsl:attribute name="checked">true</xsl:attribute>
	</xsl:if>
      </xsl:element>

    </td>
  </tr>

</xsl:template>


<!-- This template trims leading and trailing spaces off a string-->
<xsl:template name="trimspaces">
  <xsl:param name="str"/>
  <xsl:choose><xsl:when test="starts-with($str,' ') or starts-with($str,'&#x0a;') or starts-with($str,'&#x0d;')">
    <xsl:call-template name="trimspaces">
      <xsl:with-param name="str">
	<xsl:value-of select="substring($str,2)"/>
      </xsl:with-param>
    </xsl:call-template>    
  </xsl:when><xsl:when test="substring($str,string-length($str))=' ' or substring($str,string-length($str))='&#x0a;' or substring($str,string-length($str))='&#x0d;'">
    <xsl:call-template name="trimspaces">
      <xsl:with-param name="str">
	<xsl:value-of select="substring($str,1,string-length($str)-1)"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:when><xsl:otherwise>
    <xsl:value-of select="$str"/>
  </xsl:otherwise></xsl:choose>

</xsl:template>


<!-- These next two templates allow copying the description 
while converting markup into the html namespace -->
<xsl:template match="@*|node()" mode="copydescr">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()" mode="copydescr"/>
  </xsl:copy>
</xsl:template>


<xsl:template mode="copydescr" match="*">
  <xsl:element name="{local-name()}" namespace="http://www.w3.org/1999/xhtml">
    <xsl:apply-templates select="@*|node()" mode="copydescr"/>
  </xsl:element>
</xsl:template>


<!-- Blank templates to ignore the stuff we pulled out above -->
<xsl:template match="chx:clinfo"/>
<xsl:template match="chx:cltitle"/>
<xsl:template match="chx:specimen"/>
<xsl:template match="chx:perfby"/>
<xsl:template match="chx:date"/>
<xsl:template match="chx:dest"/>
<xsl:template match="chx:notes"/>
<xsl:template match="chx:log"/>

</xsl:stylesheet>
