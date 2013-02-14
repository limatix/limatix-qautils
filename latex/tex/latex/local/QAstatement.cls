\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{QAstatement}[2012/12/04 ]
\LoadClass{article}[1994/06/01]

\RequirePackage{pspicture}
\RequirePackage{xifthen}
\RequirePackage{standalone}
\RequirePackage{amssymb}
\RequirePackage{pst-barcode}
%\RequirePackage{pst-pdf}
\RequirePackage{auto-pst-pdf}
\RequirePackage{textpos}

\setlength{\pdfpagewidth}{8.5in}
\setlength{\pdfpageheight}{11in}
\setlength{\paperwidth}{8.5in}
\setlength{\paperheight}{11in}
\setlength{\oddsidemargin}{-0.0in}
\setlength{\evensidemargin}{-0.0in}
\setlength{\textwidth}{6.5in}
\setlength{\textheight}{9.25in}
\setlength{\headheight}{0in}
\setlength{\topmargin}{-.25in}
\setlength{\headsep}{0in}
\addtolength{\parskip}{0.7\baselineskip}
\setlength{\parindent}{0.5in}
\raggedright


% Requires --shell-escape option so we can trigger XML processing
% (also requires texml)

\newwrite\checklistxmlfile

% See http://tex.stackexchange.com/questions/12721/control-command-arguments
% for information on simulating a verbatim environment and
% http://tug.org/pipermail/macostex-archives/2008-June/035587.html
% for information on \newwrite \openout \write and \closeout

\def\checklistxml#1{%
    %\unskip
    \def\checklistxmlname{#1}
    \begingroup
    \let\do\@makeother
    \dospecials %
    % \catcode`\^^M=\active %
    %\let^^M\par %
    %\par
    %\obeylines 
%    \do \
    \catcode`\{=1\relax%
    \catcode`\}=2\relax%
    %\let\partmp\par
    %\def\par\ 
    \checklist@xml%
    %\let\par\partmp
}

%\ifthenelse{\NOT \isin{autopp}{\jobname}}{  % disable checklist inside auto-pst-pdf
\def\checklist@xml#1{%
    \endgroup
    \ifpdf   % Hide checklist generation in regular latex (i.e. auto-pst-pdf figure-generation mode) 
      \@ifnotmtarg{#1}{
        \immediate\openout\checklistxmlfile=\jobname_\checklistxmlname.chx
        \immediate\write\checklistxmlfile{#1}%
        \immediate\closeout\checklistxmlfile

        \write18{rm -f \jobname_\checklistxmlname.texml}  % delete file to be generated so we will fail to generate anything should texml not run
        \write18{xsltproc chx2texml.xsl \jobname_\checklistxmlname.chx >\jobname_\checklistxmlname.texml}

        \write18{rm -f \jobname_\checklistxmlname.tex}  % delete file to be generated so we will fail to generate anything should texml not run
        \write18{texml \jobname_\checklistxmlname.texml \jobname_\checklistxmlname.tex}

        \write18{rm -f \jobname_\checklistxmlname.pdf}  % delete file to be generated so we will fail to generate anything should texml not run
        \write18{pdflatex --shell-escape \jobname_\checklistxmlname.tex}
        \write18{pdflatex --shell-escape \jobname_\checklistxmlname.tex}
        \newpage
        \input{\jobname_\checklistxmlname.tex}
      }
    \fi
}

%{
%\def\checklist@xml#1{%
%    \endgroup
%}




% checklist environment from: 
% http://newsgroups.derkeiler.com/Archive/Comp/comp.text.tex/2005-08/msg01658.html
%\newcommand*{\thecheckbox}{\hss[\hss]}
%\newcommand*{\thecheckbox}{$\checkmark$}

\newcommand*{\thecheckbox}{$\Box$}
\newenvironment*{checklist}
{\list{}{%
\renewcommand*{\makelabel}[1]{\thecheckbox}}}
{\endlist} 



\newcommand{\checklistheader}[6]{
{\Large \bf #2 \\ {\normalsize \tt (#1) \\}}} 

