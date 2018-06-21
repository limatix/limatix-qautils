PREFIX=/usr/local
INSTDIR=$(PREFIX)/limatix-qautils
INSTALL=install
SUBDIRS=checklist/

DIST_FILES=.
PUBEXCLUDE=--exclude .hg 

all:
	@for i in $(SUBDIRS) ; do if [ -d $$i ] && [ -f $$i/Makefile ] ; then $(MAKE) $(MFLAGS) -C $$i ; fi done

clean: 
	@for i in $(SUBDIRS) ; do if [ -d $$i ] && [ -f $$i/Makefile ] ; then $(MAKE) $(MFLAGS) -C $$i clean ; fi done
	rm -f `find . -name "*~"`
	rm -f `find . -name "*.swp"`
	rm -f `find . -name "*.bak"` 
	rm -f `find . -name "core.*"`

realclean: clean
distclean: clean

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
	rm -f $(PREFIX)/bin/sdb_gotimage
	ln -s $(INSTDIR)/bin/sdb_gotimage $(PREFIX)/bin/sdb_gotimage
	rm -f $(PREFIX)/bin/scan_checklist
	ln -s $(INSTDIR)/bin/scan_checklist $(PREFIX)/bin/scan_checklist

commit: clean
	git add -A # hg addremove
	git commit -a # hg commit


dist:
	mv VERSION VERSIONtmp
	sed 's/-[^-]*$$//' <VERSIONtmp >VERSION    # remove trailing -devel
	date "+%B %d, %Y" >VERSIONDATE
	rm -f VERSIONtmp

	$(MAKE) $(MFLAGS) commit
	$(MAKE) $(MFLAGS) all
	$(MAKE) $(MFLAGS) realclean
	#	hg tag -f `cat VERSION`
	git checkout master
	git merge --no-ff develop
	git tag -f `cat VERSION` -a -m `cat VERSION`

	tar -cvzf /tmp/realclean-limatix-qautils-`cat VERSION`.tar.gz $(DIST_FILES)

	#tar $(PUBEXCLUDE) -cvzf /tmp/realclean-limatix-qautils-pub-`cat VERSION`.tar.gz $(DIST_FILES)

	@for archive in  limatix-qautils-`cat VERSION`  ; do mkdir /tmp/$$archive ; tar -C /tmp/$$archive  -x -f /tmp/realclean-$$archive.tar.gz ; make -C /tmp/$$archive all ; make -C /tmp/$$archive distclean ; tar -C /tmp -c -v -z -f /home/sdh4/research/software/archives/$$archive.tar.gz $$archive ; ( cd /tmp; zip -r /home/sdh4/research/software/archives/$$archive.zip $$archive ) ; done

	git checkout develop

	mv VERSION VERSIONtmp
	awk -F . '{ print $$1 "." $$2 "." $$3+1 "-devel"}' <VERSIONtmp >VERSION  # increment version number and add trailing-devel
	rm -f VERSIONtmp
	rm -f VERSIONDATE

	@echo "If everything worked, you should do a git push --all ; git push --tags"
