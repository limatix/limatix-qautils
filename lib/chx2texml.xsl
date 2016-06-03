<?xml version="1.0" encoding="UTF-8"?>

<!-- The output of this stylesheet can be tested with the xsltproc
command:
  xsltproc chx2texml.xsl example.chx > example.texml 
  Or use the chx2pdf script to automate execution and parameter passing

-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:chx="http://thermal.cnde.iastate.edu/checklist" xmlns:xlink="http://www.w3.org/1999/xlink">
<xsl:output method="xml"/>

<xsl:param name="specimen"/>
<xsl:param name="perfby"/>
<xsl:param name="date"/>
<xsl:param name="dest"/>

<xsl:template match="/">
<TeXML>
<!-- Insert header with DO NOT EDIT notation -->
<TeXML escape="0">
\documentclass{QAchecklist}
% AUTOMATICALLY GENERATED... DO NOT EDIT!
\usepackage[latin1]{inputenc}
\usepackage[T1]{fontenc}
\usepackage{amssymb} % for \Box
\usepackage[runs=3]{auto-pst-pdf}
\usepackage[normalem]{ulem} % for \sout (strikeout)
% checklist environment from: 
% http://newsgroups.derkeiler.com/Archive/Comp/comp.text.tex/2005-08/msg01658.html
%\newcommand*{\thecheckbox}{\hss[\hss]}
%\newcommand*{\thecheckbox}{$\checkmark$}

\newcommand*{\thecheckbox}{$\Box$}
\newenvironment*{checklist}
{\list{}{%
\renewcommand*{\makelabel}[1]{\thecheckbox}}}
{\endlist} 

</TeXML>
<env name="document">
  <xsl:apply-templates/>
</env>
</TeXML>

</xsl:template>

<xsl:template match="chx:i" mode="descrmarkup">
<group><cmd name="em"/><xsl:apply-templates mode="descrmarkup"/></group>
</xsl:template>

<xsl:template match="chx:b" mode="descrmarkup">
<group><cmd name="bf"/><xsl:apply-templates mode="descrmarkup"/></group>
</xsl:template>

<xsl:template match="chx:sub" mode="descrmarkup">
<math><ctrl ch=" "/><spec cat="sub"/><group><cmd name="mbox"><parm><cmd name="tiny"/><xsl:apply-templates mode="descrmarkup"/></parm></cmd></group></math>
</xsl:template>

<xsl:template match="chx:sup" mode="descrmarkup">
<math><ctrl ch=" "/><spec cat="sup"/><group><cmd name="mbox"><parm><cmd name="tiny"/><xsl:apply-templates mode="descrmarkup"/></parm></cmd></group></math>
</xsl:template>

<xsl:template match="chx:tt" mode="descrmarkup">
<group><cmd name="tt"/><xsl:apply-templates mode="descrmarkup"/></group>
</xsl:template>

<xsl:template match="chx:s" mode="descrmarkup">
<cmd name="sout"><parm><xsl:apply-templates mode="descrmarkup"/></parm></cmd>
</xsl:template>


<xsl:template match="chx:u" mode="descrmarkup">
<cmd name="underline"><parm><xsl:apply-templates mode="descrmarkup"/></parm></cmd>
</xsl:template>

<xsl:template match="chx:br" mode="descrmarkup">
<spec cat="tilde"/><ctrl ch="\"/>
</xsl:template>


<xsl:template name="unescapeunderscore">
<xsl:param name="paramstr"/>
<xsl:choose><xsl:when test="contains(string($paramstr),'_')">
  <xsl:value-of select="substring-before(string($paramstr),'_')"/>
  <spec cat="sub"/> <!-- insert unescaped underscore -->
  <xsl:call-template name="unescapeunderscore">
    <xsl:with-param name="paramstr">
      <xsl:value-of select="substring-after(string($paramstr),'_')"/>
    </xsl:with-param>
  </xsl:call-template>
</xsl:when><xsl:otherwise>
  <xsl:value-of select="string($paramstr)"/>
</xsl:otherwise></xsl:choose>
</xsl:template>

<xsl:template match="chx:checklist">

<!-- TeXML automatically escapes underscores, but that screws things up
     because the escaping would then make it through, possibly into the 
     barcodes. Instead we make underscore a regular character, 
     and then bypass the unescaping of the underscore by using the
     "unescapeunderscore" template that replaces each underscore 
     in the input with a <spec cat="sub"/> tag that generates a raw
     underscore -->

<!-- Make underscore a regular character -->
<TeXML escape="0">
 \catcode`_=11   
</TeXML>
<cmd name="checklistheader">
  <parm>
    <xsl:call-template name="unescapeunderscore">
      <xsl:with-param name="paramstr">
	<xsl:value-of select="chx:clinfo"/>
      </xsl:with-param>
    </xsl:call-template>
  </parm>
  <parm>
    <xsl:call-template name="unescapeunderscore">
      <xsl:with-param name="paramstr">
        <xsl:value-of select="chx:cltitle"/>
      </xsl:with-param>
    </xsl:call-template>
  </parm>
  <!-- These parameters can either be in the XML or provided as 
       XSLT parameters (we just concatenate assuming the other is empty) -->
  <parm>
    <xsl:call-template name="unescapeunderscore">
      <xsl:with-param name="paramstr">
        <xsl:value-of select="chx:specimen"/><xsl:value-of select="$specimen"/>
      </xsl:with-param>
    </xsl:call-template>
  </parm>
  <parm>
    <xsl:call-template name="unescapeunderscore">
      <xsl:with-param name="paramstr">
        <xsl:value-of select="chx:perfby"/><xsl:value-of select="$perfby"/>
      </xsl:with-param>
    </xsl:call-template>
  </parm>
  <parm>
    <xsl:call-template name="unescapeunderscore">
      <xsl:with-param name="paramstr">
        <xsl:value-of select="chx:date"/><xsl:value-of select="$date"/>
      </xsl:with-param>
    </xsl:call-template>
  </parm>
  <parm>
    <xsl:call-template name="unescapeunderscore">
      <xsl:with-param name="paramstr">
        <xsl:value-of select="chx:dest"/><xsl:value-of select="$dest"/>
      </xsl:with-param>
    </xsl:call-template>
  </parm>
</cmd>
<TeXML escape="0">
\catcode`\_=8   % Make underscore special again
</TeXML>
<xsl:if test="chx:rationale">
  <xsl:value-of select="chx:rationale"/>
</xsl:if>
<env name="checklist">
  <xsl:apply-templates/>
</env>
</xsl:template>

<xsl:template match="*" mode="checkitemtitle">
  <!-- ignore all elements -->
</xsl:template>

<xsl:template match="text()" mode="checkitemtitle">
<xsl:copy-of select="."/>
</xsl:template>

<xsl:template match="chx:checkitem">
  <cmd name="item"/>
    <!-- extract title from attribute + any text nodes within checkitem -->
    <xsl:value-of select="@title"/>
    <xsl:apply-templates mode="checkitemtitle"/>
    <ctrl ch=" "/>  <ctrl ch="\"/>  <!-- space followed by line-break -->
    <!-- extract description tags and description parameters -->
    <xsl:apply-templates select="chx:description" mode="descrmarkup"/>
    <xsl:apply-templates select="chx:parameter[@name='description']" mode="descrmarkup"/>
    <xsl:choose><xsl:when test="string-length(string(chx:parameter[@name='dg-command'])) > 0">
      <ctrl ch=" "/>  <ctrl ch="\"/>  <!-- space followed by line-break -->
      <group><cmd name="tt"/><xsl:value-of select="chx:parameter[@name='dg-command']"/></group>
    </xsl:when></xsl:choose>
    <xsl:choose><xsl:when test="string-length(string(chx:parameter[@name='dg-param'])) > 0">
      <ctrl ch=" "/>  <ctrl ch="\"/>  <!-- space followed by line-break -->
      <group><cmd name="tt"/><xsl:value-of select="chx:parameter[@name='dg-param']"/><xsl:value-of select="string(' ')"/><xsl:value-of select="chx:parameter[@name='dg-paramdefault']"/></group>
    </xsl:when></xsl:choose>
    <xsl:if test="@class='textentry'">
      <!-- insert line where text should ae written -->
      <ctrl ch=" "/>  <ctrl ch="\"/>  <!-- space followed by line-break -->
      <cmd name="vspace">
	<parm>.3in</parm>
      </cmd>
      <cmd name="underline">
	<parm>
	  <cmd name="makebox">
	    <opt>4.5in</opt>
	    <opt>l</opt>
	    <parm></parm>
	  </cmd>
	</parm>
      </cmd>
    </xsl:if>

    <xsl:if test="@class='textgraphic'">
      <!-- insert graphic -->
      <ctrl ch=" "/>  <ctrl ch="\"/>  <!-- space followed by line-break -->
<TeXML escape="0">\catcode`_=11</TeXML>
      <cmd name="includegraphics">
	<xsl:if test="count(chx:parameter[@name='width']) &gt; 0">
	  <opt>width=<xsl:value-of select="chx:parameter[@name='width']"/>pt</opt>	  
	</xsl:if>
	<parm>
    <xsl:call-template name="unescapeunderscore">
      <xsl:with-param name="paramstr">
        <xsl:call-template name="trimspaces">
          <xsl:with-param name="str">
	    <xsl:choose>
	      <xsl:when test="chx:image/@xlink:href">
		<xsl:value-of select="chx:image/@xlink:href"/>
	      </xsl:when> <xsl:when test="chx:parameter[@name='image']/@xlink:href">
		<xsl:value-of select="chx:parameter[@name='image']/@xlink:href"/>
		
	      </xsl:when><xsl:when test="string-length(chx:parameter[@name='image']) &gt; 0">
		<xsl:value-of select="chx:parameter[@name='image']"/>
	      </xsl:when><xsl:when test="string-length(chx:image) &gt; 0">
		<xsl:value-of select="chx:image"/>
	      </xsl:when>
	      <!-- <xsl:otherwise>(no image specified)</xsl:otherwise> -->
	      
	    </xsl:choose>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:with-param>
	  </xsl:call-template>
	</parm>
      </cmd>
<TeXML escape="0">\catcode`\_=8</TeXML>
    </xsl:if>

</xsl:template>

<!-- Blank templates to ignore the stuff we pulled out above -->
<xsl:template match="chx:clinfo"/>
<xsl:template match="chx:cltitle"/>
<xsl:template match="chx:specimen"/>
<xsl:template match="chx:perfby"/>
<xsl:template match="chx:date"/>
<xsl:template match="chx:dest"/>
<xsl:template match="chx:log"/>
<xsl:template match="chx:rationale"/>


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

</xsl:stylesheet>
