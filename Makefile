PREFIX=/usr/local
INSTDIR=$(PREFIX)/QAutils
INSTALL=install
SUBDIRS=checklist/

all:
	@for i in $(SUBDIRS) ; do if [ -d $$i ] && [ -f $$i/Makefile ] ; then $(MAKE) $(MFLAGS) -C $$i ; fi done

clean: 
        @for i in $(SUBDIRS) ; do if [ -d $$i ] && [ -f $$i/Makefile ] ; then $(MAKE) $(MFLAGS) -C $$i clean ; fi done
	rm -f `find . -name "*~"`
	rm -f `find . -name "*.swp"`
	rm -f `find . -name "*.bak"` 
	rm -f `find . -name "core.*"`

install: clean
	$(INSTALL) -d $(PREFIX)/bin
	$(INSTALL) -d $(INSTDIR)
	
	mkdir -p $(INSTDIR)/bin
	mkdir -p $(INSTDIR)/latex
	mkdir -p $(INSTDIR)/lib
	mkdir -p $(INSTDIR)/checklist


	rm -rf $(INSTDIR)/bin.old
	rm -rf $(INSTDIR)/latex.old
	rm -rf $(INSTDIR)/lib.old
	rm -rf $(INSTDIR)/checklist.old
	
	mv -f $(INSTDIR)/bin $(INSTDIR)/bin.old
	mv -f $(INSTDIR)/latex $(INSTDIR)/latex.old
	mv -f $(INSTDIR)/lib $(INSTDIR)/lib.old
	mv -f $(INSTDIR)/checklist $(INSTDIR)/checklist.old
	
	cp -a bin $(INSTDIR)/bin
	cp -a latex $(INSTDIR)/latex
	cp -a lib $(INSTDIR)/lib
	cp -a checklist $(INSTDIR)/checklist

	rm -f $(PREFIX)/bin/chx2pdf
	ln -s $(INSTDIR)/bin/chx2pdf $(PREFIX)/bin/chx2pdf
	rm -f $(PREFIX)/bin/QAstatement2pdf
	ln -s $(INSTDIR)/bin/QAstatement2pdf $(PREFIX)/bin/QAstatement2pdf
	rm -f $(PREFIX)/bin/printQRcode
	ln -s $(INSTDIR)/bin/printQRcode $(PREFIX)/bin/printQRcode

commit: clean
	hg addremove
	hg commit
