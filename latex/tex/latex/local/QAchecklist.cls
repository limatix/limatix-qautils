\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{QAchecklist}[2012/12/04 ]
\LoadClass{article}[1994/06/01]

\RequirePackage{fancyhdr}
\RequirePackage{lastpage}
\RequirePackage{pspicture}
\RequirePackage{pst-barcode}
%\RequirePackage{pst-pdf}
\RequirePackage{auto-pst-pdf}
\PassOptionsToPackage{runs=3}{auto-pst-pdf}   % !!! BUG!!! auto-pst-pdf IGNORES the RUNS parameter for some reason (!)... Must manually make a copy of the   \app@convert{extralatex}{\jobname.\app@ext}{\app@jobname.dvi}% line in auto-pst-pdf.sty right before the app@conver{latex} line!!!  Otherwise the end page number doesn't show up

\RequirePackage{ifmtarg}
\PassOptionsToPackage{absolute}{textpos}
\RequirePackage{textpos}
\RequirePackage{seqsplit}
%\RequirePackage{everypage}

\setlength{\pdfpagewidth}{8.5in}
\setlength{\pdfpageheight}{11in}
\setlength{\paperwidth}{8.5in}
\setlength{\paperheight}{11in}
\setlength{\oddsidemargin}{-0.0in}
\setlength{\evensidemargin}{-0.0in}
\setlength{\textwidth}{6.5in}
\setlength{\textheight}{7.75in}
\setlength{\headheight}{0in}
\setlength{\topmargin}{1.25in}
\setlength{\headsep}{0in}
\addtolength{\parskip}{0.7\baselineskip}
\setlength{\parindent}{0.5in}
\raggedright

%\newcommand{\checklistheaderitem}[5]{
%\begin{textblock*}{1.5in}#1
%#2\\
%\@ifnotmtarg{#4}{
%\tt \small
%\seqsplit{\tiny #3 \normalsize #4 \tiny #5} \\
%\begin{pspicture}(1.5in,1.5in)
%\psbarcode[scalex=0.7,scaley=0.7]{#3#4#5}{}{qrcode}
%\end{pspicture}
%}
%\end{textblock*}
%
%}


\newcommand{\checklistheaderitem}[4]{
\parbox{1.5in}{
#1 \\
\@ifnotmtarg{#3}{
\tt \small 
%\seqsplit{} \\
\seqsplit{\tiny #2 \normalsize #3 \tiny #4}
\\ 
\begin{pspicture}(1.5in,1.5in)
\psbarcode[scalex=0.9,scaley=0.9]{#2#3#4}{eclevel=H}{qrcode}
\end{pspicture}
}
}
}

\newcommand{\checklistfooteritem}[4]{
\parbox{.8in}{#1 \\ \tt \seqsplit{\tiny #2 \normalsize #3/\LASTPAGE \tiny #4}
}
 \parbox{1.5in}{
\begin{pspicture}(1.5in,1.5in)
\psbarcode[scalex=0.9,scaley=0.9]{#2#3/\MyLastPage #4}{}{qrcode}
\end{pspicture}
}
}

\newcommand{\checklistheader}[6]{

%\begingroup
\catcode`\_=8  % make sure underscore is in its usual form

{\Large \bf #2 \\ {\normalsize \tt (#1)}}

%\newcommand{\MyLastPage}{\pageref{LastPage}}
\edef\MyLastPage{\@ifundefined{lastpage@lastpage}{}{\lastpage@lastpage}}


\sbox{\CLINFO}{\checklistheaderitem{Checklist}{<clinfo>}{#1}{</clinfo>}}
\sbox{\SPECIMEN}{\checklistheaderitem{Specimen}{<specimen>}{#3}{</specimen>}}
\sbox{\PERFBY}{\checklistheaderitem{Performed by}{<perfby>}{#4}{</perfby>}}
\sbox{\DATE}{\checklistheaderitem{Date}{<date>}{#5}{</date>}}
\sbox{\DEST}{\checklistheaderitem{Destination}{<dest>}{#6}{</dest>}}

\sbox{\PAGEa}{\checklistfooteritem{Page}{<page>}{1}{</page>}}
\sbox{\PAGEb}{\checklistfooteritem{Page}{<page>}{2}{</page>}}
\sbox{\PAGEc}{\checklistfooteritem{Page}{<page>}{3}{</page>}}
\sbox{\PAGEd}{\checklistfooteritem{Page}{<page>}{4}{</page>}}
\sbox{\PAGEe}{\checklistfooteritem{Page}{<page>}{5}{</page>}}

%\endgroup

}

% Put all barcodes into saveboxes because auto-pst-pdf chokes 
% if they are in the header/footer otherwise
% NOTE: Limit 5 pages PAGEa-b-c-d-e are pages 1-5

\newsavebox{\CLINFO}
\newsavebox{\SPECIMEN}
\newsavebox{\PERFBY}
\newsavebox{\DATE}
\newsavebox{\DEST}
\newsavebox{\PAGEa}
\newsavebox{\PAGEb}
\newsavebox{\PAGEc}
\newsavebox{\PAGEd}
\newsavebox{\PAGEe}


\def\mypage{PAGE}


\def\LASTPAGE{\pageref{LastPage}}
\def\CURPAGE{PAGE\alph{page}} %

\fancyhf{} % clear all header and footer fields
\renewcommand{\headrulewidth}{0pt}
\renewcommand{\footrulewidth}{0pt}

\lhead{
\begin{textblock*}{1.5in}(.25in,.25in)
\usebox{\CLINFO}
\end{textblock*}
\begin{textblock*}{1.5in}(1.85in,.25in)
\usebox{\SPECIMEN}
\end{textblock*}
\begin{textblock*}{1.5in}(3.45in,.25in)
\usebox{\PERFBY}
\end{textblock*}
\begin{textblock*}{1.5in}(5.05in,.25in)
\usebox{\DATE}
\end{textblock*}
\begin{textblock*}{1.5in}(6.65in,.25in)
\usebox{\DEST}
\end{textblock*}
\begin{textblock*}{1.5in}(3.75in,10.15in)
%\begin{textblock*}{1.5in}(4.75in,8.15in)
\usebox{\expandafter\csname \CURPAGE\endcsname}
\end{textblock*}
}


%\pagestyle{empty}
\pagestyle{fancy}

\endinput
