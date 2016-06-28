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


<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:dcv="http://limatix.org/dcvalue" xmlns:dc="http://limatix.org/datacollect" xmlns:chx="http://limatix.org/checklist" xmlns="http://www.w3.org/1999/xhtml" xmlns:dcfoo="http://limatix.org/datacollect" version="1.0">

<!-- *** Begin datacollect XML representation *** -->
<!-- *** Must keep this set of templates synchronized between
     chx2html.xsl, chf2html.xsl, and databrowse -->

<!-- This template matches all datacollect namespace tags, i.e.
     parameter values, and creates a table row with name, value.
     It applies templates with mode="displaydcvalue"
     to actually display the value
-->

<xsl:template match="dc:*">
  <tr class="datacollecttag">
    <th class="datacollecttag">
      <xsl:choose><xsl:when test="@dc:label">
	<xsl:value-of select="@dc:label"/> <!-- Use dc:label attribute if present -->
	</xsl:when><xsl:otherwise>
	<xsl:value-of select="local-name(.)"/> <!-- Use the name of the dc: tag otherwise -->	
      </xsl:otherwise></xsl:choose>
    </th>
    <td class="datacollecttag">
      <!-- Wrap with hyperlink if present -->
      <xsl:apply-templates select="." mode="displaydcvalue"/>
      
    </td>
  </tr>
</xsl:template>



<!-- Master template for displaying the value of a generic dc: or dcv: tag....
     If an explicit class is specified, applies templates in mode "displaydcvalueclass". Otherwise creates generic representation. 
-->

<xsl:template mode="displaydcvalue" match="dc:*|dcv:*">
  <xsl:choose><xsl:when test="@dcv:valueclass">
    <!-- explicit value class specified -->
    <xsl:apply-templates mode="displaydcvalueclass" select="."/>
    </xsl:when><xsl:otherwise>
    <!-- No value class specified: guess -->
    
    <!-- is it a hyperlink? -->
    <xsl:choose><xsl:when test="@xlink:href">
      <a class="datacollecttag">
	<xsl:attribute name="href"><xsl:value-of select="@xlink:href"/></xsl:attribute>
	<xsl:choose><xsl:when test="string-length(.) &gt; 0">
	  <!-- hyperlink element content is not blank: Display it -->
	  <xsl:value-of select="."/>
	  </xsl:when><xsl:otherwise>
	  <!-- hyperlink element content is blank... just show the hyperlink -->
	  <xsl:value-of select="@xlink:href"/>
	</xsl:otherwise></xsl:choose>	  
      </a>      
      </xsl:when><xsl:otherwise>
      <!-- Not a hyperlink -->
      <xsl:value-of select="."/>
      <xsl:if test="@dcv:units">
	<!-- Has units specified -->
	&#160; <!-- nbsp --> 
	<xsl:value-of select="@dcv:units"/>
      </xsl:if>
    </xsl:otherwise></xsl:choose>
    
  </xsl:otherwise></xsl:choose>
  
  
</xsl:template>

<!-- Templates for displaying various dc value classes go here -->

<xsl:template mode="displaydcvalueclass" match="*[@dcv:valueclass='numericunits']|dc:*[@dcv:valueclass='complexunits']|dc:*[@dcv:valueclass='heating']">
  <xsl:value-of select="."/> &#160; <xsl:value-of select="@dcv:units"/>

</xsl:template>

<xsl:template mode="displaydcvalueclass" match="*[@dcv:valueclass='string']|*[@dcv:valueclass='integer']|*[@dcv:valueclass='dateset']|*[@dcv:valueclass='accumulatingdateset']|*[@dcv:valueclass='integerset']|*[@dcv:valueclass='accumulatingintegerset']">
  <xsl:value-of select="."/>
</xsl:template>

<xsl:template mode="displaydcvalueclass" match="*[@dcv:valueclass='href']">
  <a>
    <xsl:attribute name="href"><xsl:value-of select="@xlink:href"/></xsl:attribute>
    <xsl:value-of select="@xlink:href"/>
  </a>
</xsl:template>



<xsl:template mode="displaydcvalueclass" match="*[@dcv:valueclass='xmltree']">
  <!-- serialize contents using mode=serializexmltree -->
  <xsl:apply-templates select="." mode="serializexmltree"/>

</xsl:template>

<xsl:template mode="displaydcvalueclass" match="*[@dcv:valueclass='excitationparams']">
  <table class="dcvalue dcv_excitationparams">
    <tr class="dcvalue dcv_excitationparams"><th class="dcvalue dcv_excitationparams" colspan="2"><xsl:value-of select="@dcv:exctype"/></th></tr>
    <xsl:apply-templates mode="excitationparams"/>
  </table>
  
</xsl:template>

<xsl:template mode="displaydcvalueclass" match="*[@dcv:valueclass='image']">
  <img>
    <xsl:attribute name="src"><xsl:value-of select="@src"/></xsl:attribute>
  </img>
  
</xsl:template>


<xsl:template mode="displaydcvalueclass" match="*[@dcv:valueclass='photos']">
  <table class="dcvalue dcv_photos">
    <tr class="dcvalue dcv_photos"><th class="dcvalue dcv_photos" colspan="2"><xsl:value-of select="@dcv:exctype"/></th></tr>
    <xsl:apply-templates mode="dcv_photos"/>
  </table>
  
</xsl:template>

<!-- match array class that is C order and has a shape with exactly two elements:
     arrayshape, with normalized space, has a substring after its first space,
     and that substring does not contain a space -->
<xsl:template mode="displaydcvalueclass" match="*[@dcv:valueclass='array' and @dcv:arraystorageorder='C' and string-length(substring-after(normalize-space(dcv:arrayshape),' ')) &gt; 0 and not(contains(substring-after(normalize-space(dcv:arrayshape),' '),' '))]">
  <xsl:variable name="nrows"><xsl:value-of select="number(substring-before(normalize-space(dcv:arrayshape),' '))"/></xsl:variable>
  <xsl:variable name="ncols"><xsl:value-of select="number(substring-after(normalize-space(dcv:arrayshape),' '))"/></xsl:variable>
  <xsl:variable name="numelements"><xsl:value-of select="$nrows * $ncols"/></xsl:variable>
  <xsl:choose><xsl:when test="$numelements &gt; 100">
    <!-- Large matrix: just show size -->
    <xsl:value-of select="$nrows"/> by <xsl:value-of select="$ncols"/> element array
    </xsl:when><xsl:otherwise>
    <!-- show as matrix -->
    <table class="dcvalue dcv_array">
      <xsl:call-template name="show_dcv_matrix_rows">
	<xsl:with-param name="nrows"><xsl:value-of select="$nrows"/></xsl:with-param>
	<xsl:with-param name="ncols"><xsl:value-of select="$ncols"/></xsl:with-param>
	<xsl:with-param name="arraydata"><xsl:value-of select="concat(normalize-space(dcv:arraydata),' ')"/></xsl:with-param>
      </xsl:call-template>
    </table>
  </xsl:otherwise></xsl:choose>
  
</xsl:template>


<!-- match array class that has a shape with exactly one element  -->
<xsl:template mode="displaydcvalueclass" match="*[@dcv:valueclass='array' and not(contains(normalize-space(dcv:arrayshape),' '))]">
  <xsl:variable name="ncols"><xsl:value-of select="number(normalize-space(dcv:arrayshape))"/></xsl:variable>
  <xsl:choose><xsl:when test="$ncols &gt; 100">
    <!-- Large array: just show size -->
    <xsl:value-of select="$ncols"/> element array
    </xsl:when><xsl:otherwise>
    <!-- show as vector -->
    <table class="dcvalue dcv_array">
      <xsl:call-template name="show_dcv_vector_row">
	<xsl:with-param name="ncols"><xsl:value-of select="$ncols"/></xsl:with-param>
	<xsl:with-param name="arraydata"><xsl:value-of select="concat(normalize-space(dcv:arraydata),' ')"/></xsl:with-param>
      </xsl:call-template>
    </table>
  </xsl:otherwise></xsl:choose>
  
</xsl:template>



<xsl:template mode="displaydcvalueclass" match="*">
  <!-- fall-through for unknown dc_value classes -->
  <xsl:value-of select="."/>

</xsl:template>



<!-- templates with mode="serializexmltree" are for representing
     xmltreevalues
     NOTE: Does not currently represent processing instructions
     or define namespace prefixes
-->

<xsl:template match="*" mode="serializexmltree">
  <xsl:choose><xsl:when test="node()"> <!-- contains subnodes -->
    &lt;<xsl:value-of select="name()"/>
    <xsl:apply-templates select="@*" mode="serializexmltree"/>
    &gt;
    <xsl:apply-templates mode="serializexmltree"/>
    &lt;/<xsl:value-of select="name()"/>&gt;
    </xsl:when><xsl:otherwise>
    &lt;<xsl:value-of select="name()"/>
    <xsl:apply-templates select="@*" mode="serializexmltree"/>
    /&gt;
  </xsl:otherwise></xsl:choose>
</xsl:template>

<xsl:template match="@*" mode="serializexmltree">
  <xsl:text> </xsl:text>
  <xsl:value-of select="name()"/>="<xsl:value-of select="."/>"
</xsl:template>

<xsl:template match="text()|comment()" mode="serializexmltree">
  <xsl:value-of select="."/>
</xsl:template>


<!-- templates with mode="excitationparams" are for representing
     parts of excitationparams
-->

<xsl:template match="dcv:*" mode="excitationparams">
  <tr class="dcvalue dcv_excitationparams">
    <th class="dcvalue dcv_excitationparams">
      <xsl:choose><xsl:when test="@dc:label">
	<xsl:value-of select="@dc:label"/> <!-- Use dc:label attribute if present -->
	</xsl:when><xsl:otherwise>
	<xsl:value-of select="local-name(.)"/> <!-- Use the name of the dc: tag otherwise -->	
      </xsl:otherwise></xsl:choose>
    </th>
    <td class="dcvalue dcv_excitationparams">
      <!-- show value -->
      <xsl:apply-templates select="." mode="displaydcvalue"/>      
    </td>

  </tr>
</xsl:template>

<!-- templates with mode="dcv_photos" are for representing
     parts of a photosvalue
-->
<xsl:template mode="dcv_photos" match="*">
  <table class="dcvalue dcv_photos">
    <tr class="dcvalue dcv_photos">
      <td class="dcvalue dcv_photos">
	<img>
	  <xsl:attribute name="src"><xsl:value-of select="@xlink:href"/></xsl:attribute>
	</img>
      </td>
    </tr>
    <tr class="dcvalue dcv_photos">
      <th class="dcvalue dcv_photos">
	<xsl:value-of select="@xlink:href"/>
      </th>
    </tr>
  </table>
</xsl:template>


<!-- Templates for displaying datacollect arrays/matrices -->
<xsl:template name="show_dcv_matrix_rows">
  <!-- WARNING: arraydata parameter should be normalized-space with exactly one trailing space added -->
  <xsl:param name="nrows"/>
  <xsl:param name="ncols"/>
  <xsl:param name="arraydata"/>
  <xsl:variable name="rowdata">
    <xsl:call-template name="dcv_matrix_extract_next_row">
      <xsl:with-param name="ncols"><xsl:value-of select="$ncols"/></xsl:with-param>
      <xsl:with-param name="arraydata"><xsl:value-of select="$arraydata"/></xsl:with-param>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="remainingdata">
    <xsl:call-template name="dcv_matrix_extract_following_rows">
      <xsl:with-param name="ncols"><xsl:value-of select="$ncols"/></xsl:with-param>
      <xsl:with-param name="arraydata"><xsl:value-of select="$arraydata"/></xsl:with-param>
    </xsl:call-template>
  </xsl:variable>

  <!-- Show this row -->
  <tr class="dcvalue dcv_array">
    <xsl:call-template name="show_dcv_vector_row">
      <xsl:with-param name="ncols"><xsl:value-of select="$ncols"/></xsl:with-param>
      <xsl:with-param name="arraydata"><xsl:value-of select="concat(normalize-space($rowdata),' ')"/></xsl:with-param>
    </xsl:call-template>
  </tr>

  <!-- Recursive call to show remaining rows, if present -->
  <xsl:if test="$nrows &gt; 1">
    <xsl:call-template name="show_dcv_matrix_rows">
      <xsl:with-param name="nrows"><xsl:value-of select="$nrows - 1"/></xsl:with-param>
      <xsl:with-param name="ncols"><xsl:value-of select="$ncols"/></xsl:with-param>
      <xsl:with-param name="arraydata"><xsl:value-of select="concat(normalize-space($remainingdata),' ')"/></xsl:with-param>
    </xsl:call-template>
    
  </xsl:if>
</xsl:template>

<!-- Extract next row of dcvalue matrix as a string -->
<xsl:template name="dcv_matrix_extract_next_row">
  <!-- WARNING: arraydata parameter should be normalized-space with exactly one trailing space added -->
  <xsl:param name="ncols"/>
  <xsl:param name="arraydata"/>
  <!-- Extract first element, generate space, recursive call -->
  <xsl:value-of select="substring-before($arraydata,' ')"/>
  <xsl:text> </xsl:text>
  <xsl:if test="$ncols &gt; 1">
    <xsl:call-template name="dcv_matrix_extract_next_row">
      <xsl:with-param name="ncols"><xsl:value-of select="$ncols - 1"/></xsl:with-param>
      <xsl:with-param name="arraydata"><xsl:value-of select="substring-after($arraydata,' ')"/></xsl:with-param>
    </xsl:call-template>
  </xsl:if>
</xsl:template>



<!-- Extract following rows of dcvalue matrix as a string -->
<xsl:template name="dcv_matrix_extract_following_rows">
  <!-- WARNING: arraydata parameter should be normalized-space with exactly one trailing space added -->
  <xsl:param name="ncols"/>
  <xsl:param name="arraydata"/>
  <!-- Recursive call, only operating on what is after the current element -->
  <xsl:choose><xsl:when test="$ncols &gt; 1">
    <xsl:call-template name="dcv_matrix_extract_following_rows">
      <xsl:with-param name="ncols"><xsl:value-of select="$ncols - 1"/></xsl:with-param>
      <xsl:with-param name="arraydata"><xsl:value-of select="substring-after($arraydata,' ')"/></xsl:with-param>
    </xsl:call-template>
    </xsl:when><xsl:otherwise>
    <!-- Deepest recursion: $ncols=1 -->
    <!-- Display what remains after this chunk of string -->
    <xsl:value-of select="substring-after($arraydata,' ')"/>
  </xsl:otherwise></xsl:choose>
</xsl:template>

<xsl:template name="show_dcv_vector_row">
  <!-- WARNING: arraydata parameter should be normalized-space with exactly one trailing space added -->
  <xsl:param name="ncols"/>
  <xsl:param name="arraydata"/>

  <td class="dcvalue dcv_array">
    <xsl:value-of select="substring-before($arraydata,' ')"/>
  </td>
  <xsl:if test="$ncols &gt; 1">
    <xsl:call-template name="show_dcv_vector_row">
      <xsl:with-param name="ncols"><xsl:value-of select="$ncols - 1"/></xsl:with-param>
      <xsl:with-param name="arraydata"><xsl:value-of select="substring-after($arraydata,' ')"/></xsl:with-param>
    </xsl:call-template>
    
  </xsl:if>
</xsl:template>


<!-- *** End datacollect XML representation *** -->

</xsl:stylesheet>
