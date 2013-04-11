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

/* BlobBuilder.js
 * A BlobBuilder implementation.
 * 2012-04-21
 * 
 * By Eli Grey, http://eligrey.com
 * License: X11/MIT
 *   See LICENSE.md
 */

/*global self, unescape */
/*jslint bitwise: true, regexp: true, confusion: true, es5: true, vars: true, white: true,
  plusplus: true */

/*! @source http://purl.eligrey.com/github/BlobBuilder.js/blob/master/BlobBuilder.js */

var BlobBuilder = BlobBuilder || self.WebKitBlobBuilder || self.MozBlobBuilder || self.MSBlobBuilder || (function(view) {
"use strict";
var
	  get_class = function(object) {
		return Object.prototype.toString.call(object).match(/^\[object\s(.*)\]$/)[1];
	}
	, FakeBlobBuilder = function(){
		this.data = [];
	}
	, FakeBlob = function(data, type, encoding) {
		this.data = data;
		this.size = data.length;
		this.type = type;
		this.encoding = encoding;
	}
	, FBB_proto = FakeBlobBuilder.prototype
	, FB_proto = FakeBlob.prototype
	, FileReaderSync = view.FileReaderSync
	, FileException = function(type) {
		this.code = this[this.name = type];
	}
	, file_ex_codes = (
		  "NOT_FOUND_ERR SECURITY_ERR ABORT_ERR NOT_READABLE_ERR ENCODING_ERR "
		+ "NO_MODIFICATION_ALLOWED_ERR INVALID_STATE_ERR SYNTAX_ERR"
	).split(" ")
	, file_ex_code = file_ex_codes.length
	, realURL = view.URL || view.webkitURL || view
	, real_create_object_URL = realURL.createObjectURL
	, real_revoke_object_URL = realURL.revokeObjectURL
	, URL = realURL
	, btoa = view.btoa
	, atob = view.atob
	, can_apply_typed_arrays = false
	, can_apply_typed_arrays_test = function(pass) {
		can_apply_typed_arrays = !pass;
	}
	
	, ArrayBuffer = view.ArrayBuffer
	, Uint8Array = view.Uint8Array
;
FakeBlobBuilder.fake = FB_proto.fake = true;
while (file_ex_code--) {
	FileException.prototype[file_ex_codes[file_ex_code]] = file_ex_code + 1;
}
try {
	if (Uint8Array) {
		can_apply_typed_arrays_test.apply(0, new Uint8Array(1));
	}
} catch (ex) {}
if (!realURL.createObjectURL) {
	URL = view.URL = {};
}
URL.createObjectURL = function(blob) {
	var
		  type = blob.type
		, data_URI_header
	;
	if (type === null) {
		type = "application/octet-stream";
	}
	if (blob instanceof FakeBlob) {
		data_URI_header = "data:" + type;
		if (blob.encoding === "base64") {
			return data_URI_header + ";base64," + blob.data;
		} else if (blob.encoding === "URI") {
			return data_URI_header + "," + decodeURIComponent(blob.data);
		} if (btoa) {
			return data_URI_header + ";base64," + btoa(blob.data);
		} else {
			return data_URI_header + "," + encodeURIComponent(blob.data);
		}
	} else if (real_create_object_url) {
		return real_create_object_url.call(realURL, blob);
	}
};
URL.revokeObjectURL = function(object_url) {
	if (object_url.substring(0, 5) !== "data:" && real_revoke_object_url) {
		real_revoke_object_url.call(realURL, object_url);
	}
};
FBB_proto.append = function(data/*, endings*/) {
	var bb = this.data;
	// decode data to a binary string
	if (Uint8Array && data instanceof ArrayBuffer) {
		if (can_apply_typed_arrays) {
			bb.push(String.fromCharCode.apply(String, new Uint8Array(data)));
		} else {
			var
				  str = ""
				, buf = new Uint8Array(data)
				, i = 0
				, buf_len = buf.length
			;
			for (; i < buf_len; i++) {
				str += String.fromCharCode(buf[i]);
			}
		}
	} else if (get_class(data) === "Blob" || get_class(data) === "File") {
		if (FileReaderSync) {
			var fr = new FileReaderSync;
			bb.push(fr.readAsBinaryString(data));
		} else {
			// async FileReader won't work as BlobBuilder is sync
			throw new FileException("NOT_READABLE_ERR");
		}
	} else if (data instanceof FakeBlob) {
		if (data.encoding === "base64" && atob) {
			bb.push(atob(data.data));
		} else if (data.encoding === "URI") {
			bb.push(decodeURIComponent(data.data));
		} else if (data.encoding === "raw") {
			bb.push(data.data);
		}
	} else {
		if (typeof data !== "string") {
			data += ""; // convert unsupported types to strings
		}
		// decode UTF-16 to binary string
		bb.push(unescape(encodeURIComponent(data)));
	}
};
FBB_proto.getBlob = function(type) {
	if (!arguments.length) {
		type = null;
	}
	return new FakeBlob(this.data.join(""), type, "raw");
};
FBB_proto.toString = function() {
	return "[object BlobBuilder]";
};
FB_proto.slice = function(start, end, type) {
	var args = arguments.length;
	if (args < 3) {
		type = null;
	}
	return new FakeBlob(
		  this.data.slice(start, args > 1 ? end : this.data.length)
		, type
		, this.encoding
	);
};
FB_proto.toString = function() {
	return "[object Blob]";
};
return FakeBlobBuilder;
}(self));

/* FileSaver.js
 * A saveAs() FileSaver implementation.
 * 2012-12-11
 * 
 * By Eli Grey, http://eligrey.com
 * License: X11/MIT
 *   See LICENSE.md
 */

/*global self */
/*jslint bitwise: true, regexp: true, confusion: true, es5: true, vars: true, white: true,
  plusplus: true */

/*! @source http://purl.eligrey.com/github/FileSaver.js/blob/master/FileSaver.js */

var saveAs = saveAs
  || (navigator.msSaveOrOpenBlob && navigator.msSaveOrOpenBlob.bind(navigator))
  || (function(view) {
	"use strict";
	var
		  doc = view.document
		  // only get URL when necessary in case BlobBuilder.js hasn't overridden it yet
		, get_URL = function() {
			return view.URL || view.webkitURL || view;
		}
		, URL = view.URL || view.webkitURL || view
		, save_link = doc.createElementNS("http://www.w3.org/1999/xhtml", "a")
		, can_use_save_link = "download" in save_link
		, click = function(node) {
			var event = doc.createEvent("MouseEvents");
			event.initMouseEvent(
				"click", true, false, view, 0, 0, 0, 0, 0
				, false, false, false, false, 0, null
			);
			return node.dispatchEvent(event); // false if event was cancelled
		}
		, webkit_req_fs = view.webkitRequestFileSystem
		, req_fs = view.requestFileSystem || webkit_req_fs || view.mozRequestFileSystem
		, throw_outside = function (ex) {
			(view.setImmediate || view.setTimeout)(function() {
				throw ex;
			}, 0);
		}
		, force_saveable_type = "application/octet-stream"
		, fs_min_size = 0
		, deletion_queue = []
		, process_deletion_queue = function() {
			var i = deletion_queue.length;
			while (i--) {
				var file = deletion_queue[i];
				if (typeof file === "string") { // file is an object URL
					URL.revokeObjectURL(file);
				} else { // file is a File
					file.remove();
				}
			}
			deletion_queue.length = 0; // clear queue
		}
		, dispatch = function(filesaver, event_types, event) {
			event_types = [].concat(event_types);
			var i = event_types.length;
			while (i--) {
				var listener = filesaver["on" + event_types[i]];
				if (typeof listener === "function") {
					try {
						listener.call(filesaver, event || filesaver);
					} catch (ex) {
						throw_outside(ex);
					}
				}
			}
		}
		, FileSaver = function(blob, name) {
			// First try a.download, then web filesystem, then object URLs
			var
				  filesaver = this
				, type = blob.type
				, blob_changed = false
				, object_url
				, target_view
				, get_object_url = function() {
					var object_url = get_URL().createObjectURL(blob);
					deletion_queue.push(object_url);
					return object_url;
				}
				, dispatch_all = function() {
					dispatch(filesaver, "writestart progress write writeend".split(" "));
				}
				// on any filesys errors revert to saving with object URLs
				, fs_error = function() {
					// don't create more object URLs than needed
					if (blob_changed || !object_url) {
						object_url = get_object_url(blob);
					}
					target_view.location.href = object_url;
					filesaver.readyState = filesaver.DONE;
					dispatch_all();
				}
				, abortable = function(func) {
					return function() {
						if (filesaver.readyState !== filesaver.DONE) {
							return func.apply(this, arguments);
						}
					};
				}
				, create_if_not_found = {create: true, exclusive: false}
				, slice
			;
			filesaver.readyState = filesaver.INIT;
			if (!name) {
				name = "download";
			}
			if (can_use_save_link) {
				object_url = get_object_url(blob);
				save_link.href = object_url;
				save_link.download = name;
				if (click(save_link)) {
					filesaver.readyState = filesaver.DONE;
					dispatch_all();
					return;
				}
			}
			// Object and web filesystem URLs have a problem saving in Google Chrome when
			// viewed in a tab, so I force save with application/octet-stream
			// http://code.google.com/p/chromium/issues/detail?id=91158
			if (view.chrome && type && type !== force_saveable_type) {
				slice = blob.slice || blob.webkitSlice;
				blob = slice.call(blob, 0, blob.size, force_saveable_type);
				blob_changed = true;
			}
			// Since I can't be sure that the guessed media type will trigger a download
			// in WebKit, I append .download to the filename.
			// https://bugs.webkit.org/show_bug.cgi?id=65440
			if (webkit_req_fs && name !== "download") {
				name += ".download";
			}
			if (type === force_saveable_type || webkit_req_fs) {
				target_view = view;
			} else {
				target_view = view.open();
			}
			if (!req_fs) {
				fs_error();
				return;
			}
			fs_min_size += blob.size;
			req_fs(view.TEMPORARY, fs_min_size, abortable(function(fs) {
				fs.root.getDirectory("saved", create_if_not_found, abortable(function(dir) {
					var save = function() {
						dir.getFile(name, create_if_not_found, abortable(function(file) {
							file.createWriter(abortable(function(writer) {
								writer.onwriteend = function(event) {
									target_view.location.href = file.toURL();
									deletion_queue.push(file);
									filesaver.readyState = filesaver.DONE;
									dispatch(filesaver, "writeend", event);
								};
								writer.onerror = function() {
									var error = writer.error;
									if (error.code !== error.ABORT_ERR) {
										fs_error();
									}
								};
								"writestart progress write abort".split(" ").forEach(function(event) {
									writer["on" + event] = filesaver["on" + event];
								});
								writer.write(blob);
								filesaver.abort = function() {
									writer.abort();
									filesaver.readyState = filesaver.DONE;
								};
								filesaver.readyState = filesaver.WRITING;
							}), fs_error);
						}), fs_error);
					};
					dir.getFile(name, {create: false}, abortable(function(file) {
						// delete file if it already exists
						file.remove();
						save();
					}), abortable(function(ex) {
						if (ex.code === ex.NOT_FOUND_ERR) {
							save();
						} else {
							fs_error();
						}
					}));
				}), fs_error);
			}), fs_error);
		}
		, FS_proto = FileSaver.prototype
		, saveAs = function(blob, name) {
			return new FileSaver(blob, name);
		}
	;
	FS_proto.abort = function() {
		var filesaver = this;
		filesaver.readyState = filesaver.DONE;
		dispatch(filesaver, "abort");
	};
	FS_proto.readyState = FS_proto.INIT = 0;
	FS_proto.WRITING = 1;
	FS_proto.DONE = 2;
	
	FS_proto.error =
	FS_proto.onwritestart =
	FS_proto.onprogress =
	FS_proto.onwrite =
	FS_proto.onabort =
	FS_proto.onerror =
	FS_proto.onwriteend =
		null;
	
	view.addEventListener("unload", process_deletion_queue, false);
	return saveAs;
}(self));

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
          <!-- Give textentry a parameter name=text seeded with initialtext value if not present -->\
  	  <xsl:if test=\"@class='textentry' and not(chx:parameter[@name='text'])\">\
            <chx:parameter type=\"str\" name=\"text\"><xsl:value-of select=\"chx:parameter[@name='initialtext']\"/></chx:parameter>\
          </xsl:if>\
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
	set_savecolor_and_allchecked_attribute();
	setresetcolor();

	/* set default value of filenameinput */	

	/* look up dest/@autofilename attribute */
	var autofilenameattr=checklistxml.evaluate("string(chx:checklist/chx:dest/@autofilename)",checklistxml,nsresolver,XPathResult.STRING_TYPE,null).stringValue;
	
	if (autofilenameattr.length > 0) {
	  /* Have autofilename attribute ... evaluate xpath to determine file name */
	  UpdateAutofilename();
        } else {
          /* use baseline default -- source filename with .chx -> .chf */
  	  /* extract filename from base URI */
	  var sourcefilename=document.baseURI.split('/').pop()

	  var filenameinput=document.getElementById("filenameinput");
	  /* force extension to ".chf" */
	  filenameinput.value=sourcefilename.substr(0, sourcefilename.lastIndexOf(".")) + ".chf";

        }


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

      function checkitemchanged(checkitem,numberstring) {
        var xmlitem=checklistxml.evaluate("chx:checklist/chx:checkitem[@checkitemnum=\""+numberstring+"\"]",checklistxml,nsresolver,XPathResult.FIRST_ORDERED_NODE_TYPE,null).singleNodeValue;
		xmlitem.setAttribute("checked",checkitem.checked.toString());
		
		// Get Handle to Log if it Exists - Otherwise Create It
		if (checklistxml.getElementsByTagNameNS("http://thermal.cnde.iastate.edu/checklist","log").length==0) {
			newel = checklistxml.createElementNS("http://thermal.cnde.iastate.edu/checklist","log");
			log = checklistxml.getElementsByTagNameNS("http://thermal.cnde.iastate.edu/checklist","checklist")[0].appendChild(newel);
		}
		else {
			log = checklistxml.getElementsByTagNameNS("http://thermal.cnde.iastate.edu/checklist","log")[0];
		}
		// Get a Timestamp
		var currentdate = new Date();
		var timestamp = currentdate.toISOString();
		// Set Log Status Message
		if(checkitem.checked.toString() == "checked" || checkitem.checked.toString() == "true") 
		{
			logmessage = "Item " + String(numberstring) + " Marked Complete";
		}
		else 
		{
			logmessage = "Item " + String(numberstring) + " Marked Not Complete";
		}
		// Append to Log
		logentry = checklistxml.createElementNS("http://thermal.cnde.iastate.edu/checklist","logentry");
		logentry.setAttribute("timestamp", timestamp);
		logentry.setAttribute("item", numberstring)
		logentrytext = checklistxml.createTextNode(logmessage);
		logentry.appendChild(logentrytext);
		log.appendChild(logentry);


		setcheckitemcolor(xmlitem,numberstring);
	
		set_savecolor_and_allchecked_attribute();

      }

      function textentrychanged(textentry,numberstring) {
        var xmlitemtext=checklistxml.evaluate("chx:checklist/chx:checkitem[@checkitemnum=\""+numberstring+"\"]/chx:parameter[@name=\"text\"]",checklistxml,nsresolver,XPathResult.FIRST_ORDERED_NODE_TYPE,null).singleNodeValue;
	xmlitemtext.textContent=textentry.value;
	// Get Handle to Log if it Exists - Otherwise Create It
		if (checklistxml.getElementsByTagNameNS("http://thermal.cnde.iastate.edu/checklist","log").length==0) {
			newel = checklistxml.createElementNS("http://thermal.cnde.iastate.edu/checklist","log");
			log = checklistxml.getElementsByTagNameNS("http://thermal.cnde.iastate.edu/checklist","checklist")[0].appendChild(newel);
		}
		else {
			log = checklistxml.getElementsByTagNameNS("http://thermal.cnde.iastate.edu/checklist","log")[0];
		}
		// Get a Timestamp
		var currentdate = new Date();
		var timestamp = currentdate.toString();
		// Set Log Status Message
		logmessage = "Text Field " + textentry.getAttribute("id") + " on Item " + String(numberstring) + " Updated";
		// Append to Log
		logentry = checklistxml.createElementNS("http://thermal.cnde.iastate.edu/checklist","logentry");
		logentry.setAttribute("timestamp", timestamp);
		logentry.setAttribute("item", numberstring)
		logentrytext = checklistxml.createTextNode(logmessage);
		logentry.appendChild(logentrytext);
		log.appendChild(logentry);

	UpdateAutofilename();

      }


      function updatenotes(notesarea) {
        var xmlnotes=checklistxml.evaluate("chx:checklist/chx:notes",checklistxml,nsresolver,XPathResult.FIRST_ORDERED_NODE_TYPE,null).singleNodeValue;
	xmlnotes.textContent=notesarea.value;

		// Get Handle to Log if it Exists - Otherwise Create It
		if (checklistxml.getElementsByTagNameNS("http://thermal.cnde.iastate.edu/checklist","log").length==0) {
			newel = checklistxml.createElementNS("http://thermal.cnde.iastate.edu/checklist","log");
			log = checklistxml.getElementsByTagNameNS("http://thermal.cnde.iastate.edu/checklist","checklist")[0].appendChild(newel);
		}
		else {
			log = checklistxml.getElementsByTagNameNS("http://thermal.cnde.iastate.edu/checklist","log")[0];
		}
		// Get a Timestamp
		var currentdate = new Date();
		var timestamp = currentdate.toString();
		// Set Log Status Message
		logmessage = "Notes Area Updated";
		// Append to Log
		logentry = checklistxml.createElementNS("http://thermal.cnde.iastate.edu/checklist","logentry");
		logentry.setAttribute("timestamp", timestamp);
		logentry.setAttribute("item", "notes")
		logentrytext = checklistxml.createTextNode(logmessage);
		logentry.appendChild(logentrytext);
		log.appendChild(logentry);

	noteschanged=true;
	setnotescolor();
	set_savecolor_and_allchecked_attribute();
	UpdateAutofilename();

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

      function set_savecolor_and_allchecked_attribute() {
        savebutton=document.getElementById("savebutton");

	/* check whether all items are checked */
        var checkitems=checklistxml.evaluate("chx:checklist/chx:checkitem",checklistxml,nsresolver,XPathResult.ORDERED_NODE_ITERATOR_TYPE,null);
	
	var allchecked=true;
	var thisitem=checkitems.iterateNext();
	while (thisitem) {
	  itemstatus=thisitem.getAttribute("checked");
	  if (itemstatus == null || itemstatus!="true") {
            allchecked=false;
	  }

	  thisitem=checkitems.iterateNext();
          
	}

        
	var checklistnode=checklistxml.evaluate("chx:checklist",checklistxml,nsresolver,XPathResult.FIRST_ORDERED_NODE_TYPE,null).singleNodeValue;
	if (allchecked) {
	  checklistnode.setAttribute("allchecked","true");
	}
	else { 
	  checklistnode.setAttribute("allchecked","false");
	}
	
        if(noteschanged && allchecked && !saved) {
          savebutton.style.background="yellow";
          savebutton.style.fontWeight="bold";
	  alldone=true;

        } else if (noteschanged && allchecked && saved) {
          savebutton.style.background="green";
          savebutton.style.fontWeight="normal";
	  alldone=true;

        } else {
	  alldone=false;
          savebutton.style.background="white";
          savebutton.style.fontWeight="normal";
	}
	setresetcolor();
      }

      function setresetcolor() {
        resetbutton=document.getElementById("resetbutton");
        if (saved && alldone) {
          resetbutton.style.background="yellow";
          resetbutton.style.fontWeight="bold";
	  
        } else {
          resetbutton.style.background="white";
          resetbutton.style.fontWeight="normal";
	}
      }

      function textinputchanged(textinput) {
        var nodename=textinput.getAttribute("name")
        var textxml=checklistxml.evaluate("chx:checklist/chx:"+nodename,checklistxml,nsresolver,XPathResult.FIRST_ORDERED_NODE_TYPE,null).singleNodeValue;
		textxml.textContent=textinput.value;
		
		// Get Handle to Log if it Exists - Otherwise Create It
		if (checklistxml.getElementsByTagNameNS("http://thermal.cnde.iastate.edu/checklist","log").length==0) {
			newel = checklistxml.createElementNS("http://thermal.cnde.iastate.edu/checklist","log");
			log = checklistxml.getElementsByTagNameNS("http://thermal.cnde.iastate.edu/checklist","checklist")[0].appendChild(newel);
		}
		else {
			log = checklistxml.getElementsByTagNameNS("http://thermal.cnde.iastate.edu/checklist","log")[0];
		}
		// Get a Timestamp
		var currentdate = new Date();
		var timestamp = currentdate.toString();
		// Set Log Status Message
		logmessage = "Text Field " + textinput.getAttribute("name") + " Updated";
		// Append to Log
		logentry = checklistxml.createElementNS("http://thermal.cnde.iastate.edu/checklist","logentry");
		logentry.setAttribute("timestamp", timestamp);
		logentry.setAttribute("item", textinput.getAttribute("name"))
		logentrytext = checklistxml.createTextNode(logmessage);
		logentry.appendChild(logentrytext);
		log.appendChild(logentry);
	
	UpdateAutofilename();

      }

      function savexml() {
        /* save current value of checklistxml using saveAs() */

	/* first filter checkitemnum attributes from <checkitem> tags */
	var processor=new XSLTProcessor();
	processor.importStylesheet(filternums_xsl_parsed);
	//filteredchecklistxml=processor.transformToFragment(checklistxml,document);
	var filteredchecklistxml=processor.transformToDocument(checklistxml);




        var bb = new BlobBuilder();
        //bb.append((new XMLSerializer).serializeToString(frag));
        //bb.append((new XMLSerializer).serializeToString(checklistxml));
        bb.append((new XMLSerializer).serializeToString(filteredchecklistxml));



        var blob = bb.getBlob("application/octet-string");

	var filenameinput=document.getElementById("filenameinput");
        saveAs(blob, filenameinput.value);


	saved=true;
	set_savecolor_and_allchecked_attribute();
      }

      function resetxml() {


        // reset each checkbox

	thisitem = checklistxml.evaluate("chx:checklist/chx:checkitem[@checked='true']",checklistxml,nsresolver,XPathResult.FIRST_ORDERED_NODE_TYPE,null).singleNodeValue;

	
	while (thisitem) {
	  var itemstatus=thisitem.setAttribute("checked","false");
	  var inputtag=document.getElementById("checkitem"+thisitem.getAttribute("checkitemnum"));
	  inputtag.checked=false;
	  setcheckitemcolor(thisitem,thisitem.getAttribute("checkitemnum"));


  	  thisitem = checklistxml.evaluate("chx:checklist/chx:checkitem[@checked='true']",checklistxml,nsresolver,XPathResult.FIRST_ORDERED_NODE_TYPE,null).singleNodeValue;
          
	}

	// reset textentries
	// extract list of checkitemnums
	var textentrynums=checklistxml.evaluate("chx:checklist/chx:checkitem[@class='textentry']/@checkitemnum",checklistxml,nsresolver,XPathResult.ORDERED_NODE_SNAPSHOT_TYPE,null);  // Firefox may be obecting to extracting attributes as nodes (?)

	// NOTE: Firefox objects to the use of snapshotItem().textContent below as possibly deprecated .value instead? 
	for (var i=0 ; i < textentrynums.snapshotLength; i++ ) {
  	  var textentry=checklistxml.evaluate("chx:checklist/chx:checkitem[@checkitemnum='" + textentrynums.snapshotItem(i).textContent  + "']/chx:parameter[@name='text']",checklistxml,nsresolver,XPathResult.FIRST_ORDERED_NODE_TYPE,null).singleNodeValue; // firefox may be objecting to extracting singleNodeValue from a node (?)


	  var initialtext=""
	  try {
  	    initialtext=checklistxml.evaluate("normalize-space(chx:checklist/chx:checkitem[@checkitemnum='" + textentrynums.snapshotItem(i).textContent  + "']/chx:parameter[@name='initialtext'])",checklistxml,nsresolver,XPathResult.STRING_TYPE,null).stringValue;
	    initialtext=initialtextentry.textContent
          }
          catch(e) {
            // no such element.... initialize to blank
          }
          
	  // reset XML content
	  textentry.textContent=initialtext

	  // reset DOM INPUT tag 
	  var inputtag=document.getElementById("textentry"+textentrynums.snapshotItem(i).textContent);
	  inputtag.value=initialtext;

	}
	

	// clear notes
	var notesarea=document.getElementById("notes");
	notesarea.value=""; 

	noteschanged=false;
	saved=false;
	alldone=false;

	/* set color of notes field */
	setnotescolor();

	
	set_savecolor_and_allchecked_attribute();
	setresetcolor();


        // reset date to today
	var dateinput=document.getElementById("date");	
	dateinput.value=curdateiso


	
	// check if we should reset specimen
        var resetspecimen=checklistxml.evaluate("string(chx:checklist/chx:specimen/@reset = 'true')",checklistxml,nsresolver,XPathResult.Boolean_TYPE,null)

	if (resetspecimen) {
          // xml representation
          var textxml=checklistxml.evaluate("chx:checklist/chx:specimen",checklistxml,nsresolver,XPathResult.FIRST_ORDERED_NODE_TYPE,null).singleNodeValue;
	  textxml.textContent="";
	  
          // input tag
	  var inputtag=document.getElementById("specimen");
	  inputtag.value="";
        }

      }

      function UpdateAutofilename() {
	var autofilenameattr=checklistxml.evaluate("string(chx:checklist/chx:dest/@autofilename)",checklistxml,nsresolver,XPathResult.STRING_TYPE,null).stringValue;
	
	if (autofilenameattr.length > 0) {
	  /* Have autofilename attribute ... evaluate xpath to determine file name */
	  var contextnode=checklistxml.evaluate("chx:checklist",checklistxml,nsresolver,XPathResult.FIRST_ORDERED_NODE_TYPE,null).singleNodeValue;
	  var autofilename = checklistxml.evaluate("string("+autofilenameattr+")",contextnode,nsresolver,XPathResult.STRING_TYPE,null).stringValue;

	  var filenameinput=document.getElementById("filenameinput");

	  if (filenameinput.value != autofilename) {
	    filenameinput.value=autofilename;
	  }
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
      <xsl:attribute name="onchange">textinputchanged(this);</xsl:attribute>
      <xsl:attribute name="style">width: 90%;text-align: center</xsl:attribute>
      <xsl:attribute name="id"><xsl:value-of select="$fieldname"/></xsl:attribute>
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
<textarea rows="6" cols="80" onchange="updatenotes(this);" id="notes"><xsl:value-of select="chx:notes"/></textarea>
<br/>
<input name="filenameinput" id="filenameinput" type="text"/>
<button name="save" type="button" onclick="savexml();" id="savebutton">Save...</button>
<button name="reset" type="button" onclick="resetxml();" id="resetbutton">Reset</button>
</form>
</xsl:template>


<xsl:template match="chx:checkitem">
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
	    <xsl:attribute name="onchange">textentrychanged(this,"<xsl:number/>");</xsl:attribute>	  
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


    </tr></table>
    </td>
    <td>
      <xsl:element name="input">
	<xsl:attribute name="type">checkbox</xsl:attribute>
	<xsl:attribute name="id">checkitem<xsl:number/></xsl:attribute>
	<xsl:attribute name="value"><xsl:number/></xsl:attribute>
	<xsl:attribute name="onchange">checkitemchanged(this,"<xsl:number/>");</xsl:attribute>
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
