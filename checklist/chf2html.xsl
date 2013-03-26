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


<xsl:template match="/">
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title><xsl:value-of select="/chx:checklist/chx:cltitle"/></title>
   <script language="javascript">

      <!-- using xsl:text with disable-output-escaping="yes" here 
       around the CDATA means that when internally 
      converted the CDATA is properly interpreted as XML but when transformed
      into a HTML page its ampersands, greater than, etc. do not get 
      escaped, because that is the (dumb) standard -->

      <!-- thus we need disable-output-escaping=yes if we are generating an
      html intermediate --> 
      
      <xsl:text disable-output-escaping="no"><![CDATA[

function addLoadEvent(func) {
  var oldonload = window.onload;
  if (typeof window.onload != 'function') {
    window.onload = func;
  } else {
    window.onload = function() {
      if (oldonload) {
        oldonload();
      }
      func();
    }
  }
}


      /* addnums_xsl adds checkitemnum attributes to the checkitem tags. 
         It also ensures there is a <notes> element at the bottom and
	 clinfo, specimen, perfby, date, and dest 
	 fields at the top. */
      var addnums_xsl="\
      \
      \
      <xsl:stylesheet version=\"1.0\" xmlns:xsl=\"http://www.w3.org/1999/XSL/Transform\" xmlns=\"http://thermal.cnde.iastate.edu/checklist\" xmlns:chx=\"http://thermal.cnde.iastate.edu/checklist\">\
      <xsl:output method=\"xml\" version=\"1.0\"/>\
      <xsl:param name=\"date\"/>\
      <xsl:template match=\"chx:checkitem\">\
        <xsl:copy>\
          <xsl:copy-of select=\"@*\"/>\
          <xsl:attribute name=\"checkitemnum\"><xsl:number/></xsl:attribute>\
          <xsl:apply-templates/>\
        </xsl:copy>\
      </xsl:template>\
      \
      <xsl:template match=\"*\">\
        <xsl:copy>\
          <xsl:copy-of select=\"@*\"/>\
          <xsl:apply-templates/>\
        </xsl:copy>\
      </xsl:template>\
      \
      <xsl:template match=\"chx:checklist\">\
        <xsl:copy>\
          <xsl:copy-of select=\"@*\"/>\
  	  <xsl:if test=\"not(chx:clinfo)\">\
	    <!-- add empty clinfo tag if not present -->\
	    <chx:clinfo/>\
	  </xsl:if>\
  	  <xsl:if test=\"not(chx:specimen)\">\
	    <!-- add empty specimen tag if not present -->\
	    <chx:specimen/>\
	  </xsl:if>\
  	  <xsl:if test=\"not(chx:perfby)\">\
	    <!-- add empty perfby tag if not present -->\
	    <chx:perfby/>\
	  </xsl:if>\
  	  <xsl:if test=\"not(chx:date)\">\
	    <!-- add initialized-to-current date tag if not present -->\
	    <chx:date><xsl:value-of select=\"$date\"/></chx:date>\
	  </xsl:if>\
  	  <xsl:if test=\"not(chx:dest)\">\
	    <!-- add empty dest tag if not present -->\
	    <chx:dest/>\
	  </xsl:if>\
	  \
          <xsl:apply-templates/>\
  	  <xsl:if test=\"not(chx:notes)\">\
	    <!-- add empty notes tag if not present -->\
	    <chx:notes/>\
	</xsl:if>\
        </xsl:copy>\
      </xsl:template>\
      \
      \
      </xsl:stylesheet>\
      ";


      /* filternums_xsl filters the checkitemnum attributes of the checkitem 
         tags before saving. It also adds a processing instruction to view 
	 with this stylesheet. */

      var filternums_xsl="\
      \
      \
      <xsl:stylesheet version=\"1.0\" xmlns:xsl=\"http://www.w3.org/1999/XSL/Transform\" xmlns=\"http://thermal.cnde.iastate.edu/checklist\" xmlns:chx=\"http://thermal.cnde.iastate.edu/checklist\">\
      <xsl:output method=\"xml\" version=\"1.0\"/>\
      <xsl:template match=\"chx:checkitem\">\
        <xsl:copy>\
	  <xsl:for-each select=\"@*\">\
	    <xsl:if test=\"not(name(.)=\'checkitemnum\')\">\
  	      <xsl:attribute name=\"{name(.)}\"><xsl:value-of select=\".\"/></xsl:attribute>\
            </xsl:if>\
	  </xsl:for-each>\
          <xsl:apply-templates/>\
        </xsl:copy>\
      </xsl:template>\
      \
      <xsl:template match=\"*\">\
        <xsl:copy>\
          <xsl:copy-of select=\"@*\"/>\
          <xsl:apply-templates/>\
        </xsl:copy>\
      </xsl:template>\
      \
      <xsl:template match=\"/\">\
        <xsl:processing-instruction name=\"xml-stylesheet\">href=\"chx2html.xsl\" type=\"text/xsl\"</xsl:processing-instruction>\
        <xsl:copy>\
          <xsl:copy-of select=\"@*\"/>\
          <xsl:apply-templates/>\
        </xsl:copy>\
      </xsl:template>\
      \
      </xsl:stylesheet>\
      ";


      /* <xsl:template match=\"processing-instruction()\">\
        <xsl:copy/>\
      </xsl:template>\ */


      var noteschanged=false;

      var savefilechanged=false;
      var saved=false;
      var alldone=false; // set by set_savecolor_and_allchecked_attribute

      var xsl_parser=new DOMParser();

      var addnums_xsl_parsed=xsl_parser.parseFromString(addnums_xsl,"text/xml");
      var filternums_xsl_parsed=xsl_parser.parseFromString(filternums_xsl,"text/xml");

      var checklistxml=null;

      function nsresolver(prefix) { // namespace resolver for xpath queries
        var ns = {
          'xhtml' : 'http://www.w3.org/1999/xhtml',
          'chx': 'http://thermal.cnde.iastate.edu/checklist'
        };
	return ns[prefix] || null;
      }


      function FirstNonTextChild(el) {
        var FirstChild=el.firstChild;
	while (FirstChild != null && FirstChild.nodeType == Node.TEXT_NODE) {
          /* Skip text nodes */
	  FirstChild = FirstChild.nextSibling;
        }
        return FirstChild;
      }

      var frag;

      function padtotwodigit(number) {
        var s = String(number);
        if (s.length === 1) {
          s= '0' + s;
        }
        return s;
      }

      addLoadEvent(function() {
        /* Grab the source xml document, a copy of which we have placed
	   in a div with an id of "rawchecklist" */
        /* (apparently you can use
	windows.document.XMLDocument in MSIE) */
	var rawdiv=document.getElementById("rawchecklist");
	// var checklistnode=FirstNonTextChild(rawdiv);
	rawdiv.parentNode.removeChild(rawdiv);
	
	//frag=document.createDocumentFragment();
	frag=document.implementation.createDocument("http://thermal.cnde.iastate.edu/checklist","checklist",null)

	maintag=frag.firstChild;

	/* mark our working copy as "filled" */
	maintag.setAttribute("filled","true");
	
        /* move contents onto fragment */
	var curchild=rawdiv.firstChild;
        var nextchild=null;

	while (curchild != null) {
	  nextchild=curchild.nextSibling;
	  if (curchild.nodeName.search("[cC][hH][eE][cC][kK][lL][iI][sS][tT]") >= 0) {
            // copy contents of main tag
            var curmaintagchild=curchild.firstChild;
	    var nextmaintagchild=null;

  	    while (curmaintagchild != null) {
   	      nextmaintagchild=curmaintagchild.nextSibling;
              curchild.removeChild(curmaintagchild);
              maintag.appendChild(curmaintagchild);
              curmaintagchild=nextmaintagchild;
            }
	    break;
          }
	  rawdiv.removeChild(curchild);
	  //alert("Curchild.localName="+curchild.nodeName);
          frag.insertBefore(curchild,maintag);
          curchild=nextchild;
        }

	// append any remaining nodes
	curchild=nextchild;
	while (curchild != null) {
	  nextchild=curchild.nextSibling;
	
	  rawdiv.removeChild(curchild);
          frag.appendChild(curchild,maintag);
          curchild=nextchild;
	}
	
	var processor=new XSLTProcessor();
	/* add item nums with addnums_xsl */
	processor.importStylesheet(addnums_xsl_parsed);

	// Provide date so stylesheet can set it if it is not already set...
	var curdateobj=new Date();
	
	// curdateiso is a global!
	curdateiso=curdateobj.getFullYear()+'-'+padtotwodigit(curdateobj.getMonth()+1)+'-'+curdateobj.getDate();

	processor.setParameter(null,"date",curdateiso);


	//checklistxml=processor.transformToFragment(frag,document);
	checklistxml=processor.transformToDocument(frag);

	var ProcInstr=checklistxml.createProcessingInstruction("xml-stylesheet", 'type="text/xsl" href="chx2html.xsl"');
	checklistxml.insertBefore(ProcInstr,checklistxml.firstChild);

	// Set date widget to what ever ended up in checklist xml (meaning current-date override if applicable)
	
	var datexml=checklistxml.evaluate("chx:checklist/chx:date",checklistxml,nsresolver,XPathResult.FIRST_ORDERED_NODE_TYPE,null).singleNodeValue;
	var dateinput=document.getElementById("date");	
	dateinput.value=datexml.textContent;


	/* set color of all check items */
        var checkitems=checklistxml.evaluate("chx:checklist/chx:checkitem",checklistxml,nsresolver,XPathResult.ORDERED_NODE_ITERATOR_TYPE,null);
	
	var thisitem=checkitems.iterateNext();

	while (thisitem) {
	  setcheckitemcolor(thisitem,thisitem.getAttribute("checkitemnum"));
	  thisitem=checkitems.iterateNext();
	}

	/* set color of notes field */
	setnotescolor();


      });

      function setcheckitemcolor(xmlitem,numberstring) {
        var checked=xmlitem.getAttribute("checked");
	
	if (checked != null && checked=="true") {
          document.getElementById("checkitemnum"+numberstring).style.color="green";
          document.getElementById("checkitemtitle"+numberstring).style.color="green";
          document.getElementById("checkitemnum"+numberstring).style.fontWeight="normal";
          document.getElementById("checkitemtitle"+numberstring).style.fontWeight="normal";
        } else {
          document.getElementById("checkitemnum"+numberstring).style.color="red";
          document.getElementById("checkitemtitle"+numberstring).style.color="red";
          document.getElementById("checkitemnum"+numberstring).style.fontWeight="bold";
          document.getElementById("checkitemtitle"+numberstring).style.fontWeight="bold";

        }
      }

      


      function setnotescolor() {
        notesarea=document.getElementById("notes");
        
        if(noteschanged) {
          notesarea.style.borderColor="green";
	  //alert("setting border green");
          notesarea.style.borderStyle="solid";
          notesarea.style.borderWidth="thin";

        } else {
	  //alert("setting border red");
          notesarea.style.borderColor="red";
          notesarea.style.borderStyle="ridge";
          notesarea.style.borderWidth="thick";
        }
      }

 

    

    ]]>
    </xsl:text></script>
  </head>
  <body>
    <xsl:apply-templates/>

    <!-- hide a copy of the raw checklist in a hidden div (since it is in the chx namespace it should be ignored anyway -->

    <div id="rawchecklist" style="display: none;">
      <!-- <xsl:copy-of select="/"/> --> 
      <xsl:apply-templates select="/" mode="copychecklist"/>
    </div>

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
<table border="1">
<xsl:apply-templates/>
</table>

<h2>Notes</h2>
<textarea rows="6" cols="80" disabled="true" id="notes"><xsl:value-of select="chx:notes"/></textarea>

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
	<xsl:number/>
      </xsl:element>
    </td>
    <td>
      <xsl:element name="span">
	<xsl:attribute name="id">checkitemtitle<xsl:number/></xsl:attribute>
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


<!-- Next templates are used to copy the checklist into the DOM tree -->
<xsl:template  match="@*|node()" mode="copychecklist">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()" mode="copychecklist"/>
  </xsl:copy>
</xsl:template>

<!-- while copying into the DOM tree we need to make sure that 
any checkitems with class=="textentry" have 
<parameter type="str" name="text"/>tags to store the text in -->
<xsl:template  match="checkitem" mode="copychecklist">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()" mode="copychecklist"/>
    <xsl:if test="@class='textentry' and count(chx:parameter[@name='text']) &lt; 1">
      <chx:parameter xmlns="" type="str" name="text">
	<xsl:value-of select="chx:parameter[@name='initialtext']"/>
      </chx:parameter>
    </xsl:if>
  </xsl:copy>  
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
