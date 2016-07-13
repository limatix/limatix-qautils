The LIMATIX QAutils package is a set of miscellaneous tools and
scripts that assist the use, development, and documentation of
consistent and repeatable research practices. Some tools are
very specialized to our work and platforms (tested on Red Hat
Enterprise Linux 60. They are published in the hope that they
will be useful. 

CONTENTS
--------
checklist/         Specification for the .chx checklist file
		   format; JavaScript and XSLT-based checklist
		   viewer and editor. 
barcodereader/     A DBus server and client for capturing
		   barcodes from a Datalogic Gryphon barcode
		   reader and making the values available to
		   multiple processes and automatically opening
		   specimen database and transducer database
		   entries.
latex/  	   LaTeX files required for printing checklists
                   and QA statements. DO NOT MODIFY THE
		   DIRECTORY STRUCTURE
lib/chx2texml.xsl  XSLT Stylesheet for converting XML checklists 
                   to TeXML which is in turn convertible to LaTeX
examples/QAoverall.tex  Example QA statement. Can be processed
                   with bin/QAstatement2pdf
bin/chx2pdf        Converts checklists to printable .pdf files
                   with barcodes
bin/printQRcode    Print QR barcode to label printer
bin/QAstatement2pdf  Convert "QA statement" written in LaTeX to 
                     printable .pdf and series of checklists
bin/scan_checklist   Tool for scanning printed checklists and
                     interpreting their barcodes
bin/sdb_gotimage   Helper for bin/scan_checklist that handles
                   scanned images as they are received
		   


LaTeX Requirements
------------------
To use the chx2pdf, QAstatement2pdf, and printQRcode tools you
will need the LaTeX document processor. Either TeXLive or MikTeX
distributions should work fine. You will also need the TeXML
converter from http://sourceforge.net/projects/getfo/files/texml/

In particular you may need the
following sub-packages (this list is from Fedora Linux 24):
  auto-pst-pdf.sty:    texlive-auto-pst-pdf
  catchfile.sty:       texlive-oberdiek
  currfile.sty:        texlive-currfile
  etexcmds.sty:        texlive-oberdiek
  filehook.sty:        texlive-filehook
  filemod-expmin.sty:  texlive-filemod
  ifluatex.sty:        texlive-ifluatex
  ifplatform.sty:      texlive-ifplatform
  infwarerr.sty:       texlive-oberdiek
  ltxcmds.sty:         texlive-oberdiek
  pdftexcmds.sty:      texlive-oberdiek
  preview.sty:         tex-preview
  pst-barcode.sty:     texlive-pst-barcode
  pst-barcode.pro:     texlive-pst-barcode
  standalone.cls:      texlive-standalone
  standalone.sty:      texlive-standalone
(If you are having trouble try to put the .cls or .sty files
into the latex/tex/latex/local/external subdirectory and the
.pro files into the latex/dvips subdirectory)


ACKNOWLEDGMENTS
---------------
Thanks to Michelle Balmer, a former quality assurance officer
at the Iowa Department of Natural resources for her input
and feedback. 
