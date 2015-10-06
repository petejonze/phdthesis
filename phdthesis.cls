%%    File: 	phdthesis.cls    (LaTeX2e class file)
%%
%%  Author: 	Pete R Jones <petejonze@gmail.com>
%%
%% Version:	0.0.1  [12/07/12] 	- Initial build complete.
%%				0.0.8  [03/08/12] 	- Rationalisation. Massively improved and simplified.
%% 				0.0.9  [05/08/12]		- Further tweaks and improvements.
%% 				1.0.0  [05/08/12] 	- First major release. Hooray!
%% 				1.0.1  [11/09/12] 	- Tweaked RaggedRight margin settings (too much hyphenation in draft mode)
%% 				1.0.2  [24/09/12] 	- Added glossary support and sentence-initial reference commands (e.g. \Fref)
%% 				1.0.3  [28/09/12] 	- Tweaked references
%% 				1.0.4  [12/10/12] 	- Added wrappers for subappendices, margin comments, private (watermark) option
%% 				1.0.5  [14/10/12] 	- Removed ragged-right from frontmatter to stop over-runs in TOC (but retained 
%%									  				for abstract). Moved bibstyle inside references subdir. Integrated some more
%%									  				packages concerning tables and references. Refactored directory structure.
%% 				1.0.6  [20/10/12] 	- Tweaked some definitions, marginnotes (added marginnotesc env), linebreaking
%%													(added mathlist env), removed endnotes from appearing in page headers, made
%%													references follow mainbody justification, made chapter abstracts less italic, 
%%													tweaked chapter heading style, tweaked front cover, improved the look of justified
%%													(non-ragged) layout (fewer midword breaks, but also fewer runons)
%% 				1.0.7  [01/11/12] 	- Tweaked endnote numbering and layout. Improved nomenclature layout and added 
%% 													a force-print-all option. Added pdfbookmarks for all sections. Moved references
%%													out of backmatter and back into the main directory. Made endnotes hyperlinks.
%% 				1.0.8  [09/11/12] 	- Final tweaks. Added nth commands.
%% 				1.1.1  [09/03/13] 	- Improved toc layout (no more run-on dots) and tweaked page numbering
%% 				1.1.2  [16/04/13] 	- Decreased caption and reference fontsize from small to footnote
%% 				1.1.3  [20/05/13] 	- Changed title page to Nottingham standard (shame)
%% 				1.2.0  [09/12/13] 	- Updated some documentation
%% 				1.3.0  [02/10/15] 	- Fix minor bugs in front-matter
%% 
%% This file contains a class definition, phdthesis, for the LaTeX2e system which defines the layout of PhD theses.
%%
%% This file was originally used for thesis submitted in the MRC Institute of Hearing Research at the University of Nottingham.
%% It was inspired by previous thesis templates by Edinburgh School of Informatics and Cambridge University.
%%
%% The following options may be specified at load:
%%  isdraft: 									condense [single-spaced, no blank page] with additional markups [line numbers, comments]
%%  oneside, twoside: 							specify a one-sided or two-sided thesis
%%  singlespacing, fullspacing, doublespacing:	choose vertical line spacing
%%  sansheadings, normalheadings: 				headings and captions in sans-serif (default) or in the same font as the rest of the thesis
%%  ragged: 									make right-hand margin tastefully ragged
%%  logo: 										put a logo onto the title page
%%  10pt, 11pt, 12pt:	 						choose a font size
%%  centrechapter, leftchapter, rightchapter: 	alignment of chapter headings
%%  listsintoc: 								put list of figures/tables in table of contents (default: not)
%%  romanprepages, plainprepages: 				number prelim pages with roman numerals (default) or consecutively with the rest of the thesis
%%  parskip: 									don't indent paragraphs, put a blank line between instead
%%  abbrevs: 									define a list of useful abbreviations (see documentation) (default: on)
%%  draft: 										supress images and mark overfull hboxes
%%  watermark: 									add a 'private' watermark to every page
%%
%% For example:
%%	\documentclass[isdraft, twoside, logo, abbrevs, a4paper, listsintoc, parskip, ragged]{phdthesis}
%%
%%	Defined commands & environments:
%% 		(1)	\begin{quotetext}{anony mouse} TEXT \end{quotetext}
%%		(2)	\refstyle
%%		(3)	\ChapterOutsidePart
%%		(4)	\mathlist
%%	See the example .tex file for more!
%%
%%	For more information on this class, please refer to "texdoc phdthesis"
%%
%
% TODO: 
%		texdoc phdthesis
% 		externalise:
%			http://tex.stackexchange.com/questions/79594/outsourcing-tikz-code
%			\usetikzlibrary{external}
%			\tikzexternalize % activate!
%			\tikzset{external/force remake}
%
% tips: refs: Jabref; .blg log file

%-------------------------- identification ---------------------------
\NeedsTeXFormat{LaTeX2e}[1994/12/01] % YYYY/MM/DD
\ProvidesClass{phdthesis}[2015/02/10 v1.3.0 PhD Thesis Class]


%-------------------------- initial code -----------------------------
%% Prevent excessive warnings by allowing hbox's to be overfull 
%% by a length of 30pt before an overfull error is thrown.
\hfuzz=30pt 

%% Define where to look for any extra local styles
\def\input@path{{_packages/}}


%-------------------------- packages -----------------------------
%% Required packages:
\RequirePackage{ifthen,ifpdf,geometry,graphics,xspace,setspace,import,ragged2e,datetime,tgheros,pifont,lineno,fnbreak,nicefrac,amsmath,amsfonts,amsthm,amssymb,calc,tocloft}
%%% Additional are also used but are included further on rather
%%% than here, either because their options depend on the class options or
%%% because they only need to be loaded if certain conditions hold.

%% INTERNAL
%% - ifthen			% For conditional statements within phdthesis.cls
%% - ifpdf			% For conditional statements within phdthesis.cls
%% - calc			% simple arithmatic (used with fancyhdr & floatrow)
%% - datetime		% useful when tagging document
%% DEVELOPMENT TOOLS
%% - fixme 			% annotate document with comments
%% - nag 			% warns when you use deprecated LaTeX constructs (cf. l2tabu)
%% - lipsum 		% fill page with fake text
%% - lineno			% line numbers  
%% CUSTOM SECTIONS
%% - appendix		% for end of thesis appendices
%% - glossaries 	% for glossaries
%% TITLE FORMATTING
%% - sectsty 		% to change format of section headers
%% - titlesec 		% custom title formats (e.g. number after section name)
%% - fncychap 		% Heading styling: overrides the sectsty font definition
%% REFERENCES
%% - natbib			% For professional references / citations
%% PAGE LAYOUT & TYPOGRAPHY
%% - ragged2e		% superior right hand ragged margin
%% - geometry		% For margin-setting
%% - fnbreak		% warn about footnotes broken across pages
%% - xspace			% useful if abbreviations are used
%% - setspace		% for vertical spacing (superior to manual baselinestretch)
%% - microtype		% Improves the appearance of written text blocks in very subtle ways
%% - hyphenat		% Suppress excessive wordbreaking across lines
%% - parskip 		% for alternate formatting of paragraphs
%% TABLE OF CONTENTS
%% - tocbibind 		% to put LOF and LOT into table of contents
%% - tocloft		% for TOC alignment tweaks
%% FONTS AND CHARACTERS
%% - tgheros		% font
%% - pifont			% font
%% - inputenc 		% Maps certain characters to their corresponding TeX macros
%% - textcomp 		% Provides extra symbols (useful for listings)
%% PAGE ELEMENTS
%% - fancyhdr		% well formatted headers and footers
%% - lettrine		% Provides 'dropcap' stylings at the start of chapters
%% - marginnote		% Allows for margin notes (wrapper for marginpar) 
%% - endnotes		% Support for endnotes (i.e., at end of chapter, rather than footnote at bottom of page)
%% - hyperref 		% For clickable hyperlinks
%% - enumerate 		% For custom enumeration formats
%% MATHS
%% - nicefrac, amsmath, amsfonts, amsthm, amssymb
%% DRAWING
%% - tikz, tikz, pgfplots, pgfplotstable, filecontents, adjustbox
%% FLOAT CAPTIONS
%% - caption 		% to change format of captions
%% - subcaption		% for captioning subfigures
%% - caption3		% Kernel used by 'caption' package
%% FIGURES
%% - graphics		% for logo (additional graphics packages loaded below)
%% - epsfig 		% Enhanced support for EPS graphics
%% - graphicx		% Enhanced support for JPG/PNG/PDF graphics
%% - floatrow		% For figures with multiple subfigure elements
%% - import			% make figure references relative to sub-documents
%% TABLES
%% - multirow 		% for table cells spanning multiple rows		
%% - longtable		% for tables spanning multiple pages
%% - xcolor			% for coloured lines in tables
%% - colortbl		% for coloured lines in tables
%% - kbordermatrix	% allows for bordered matrices (cf \bordermatrix)
%% - booktabs		% for professionally formatted tables
%% - threeparttable % for table footnotes
%% - tabularx 		% for variable width cells (expand to fit margins)
%% - siunitx		% provides the "S" column type, which allows numbers in tables to be easily aligned (e.g. on the decimal marker)
%% LISTINGS
%% - color			% Support for color text
%% - listings		% support for listings


%------------------------ Define input vars --------------------------
%% Default values for various fields
\newcommand{\@degreetext}{}
\newcommand{\@chapteralignment}{\centering}
\newcommand{\@chapterfont}{}
\newcommand{\@thesisside}{}
\newcommand{\@thesisopen}{}
\newcommand{\@thesispoints}{}
\newcommand{\@draftmessage}{}

%% Lots of boolean things to keep track of options
\newboolean{draftthesis}
\newboolean{usesinglespacing}
\newboolean{usedoublespacing}
\newboolean{usefullspacing}
\newboolean{useabbrevs}
\newboolean{sansheadings}
\newboolean{ltoc}
\newboolean{romanpre}
\newboolean{logo}
\newboolean{raggedRightMargin}
\newboolean{inclEmail}
\newboolean{noSplitFeet}
\newboolean{addWatermark}
    
%-------------------------- Process user inputs -----------------------
%% Chapter header alignment, font of headings
%\DeclareOption{centerchapter,centrechapter}
%   {\renewcommand{\@chapteralignment}{\centering}}
%\DeclareOption{leftchapter}
%   {\renewcommand{\@chapteralignment}{\raggedright}}
%\DeclareOption{rightchapter}
%   {\renewcommand{\@chapteralignment}{\raggedleft}}
\DeclareOption{sansheadings}{%
    \setboolean{sansheadings}{true}}
\DeclareOption{normalheadings}{%
    \setboolean{sansheadings}{false}}

%% Sidedness, openright-ness, and font size (so that the draft option can
%% override them as needed. 
\DeclareOption{twoside}{\renewcommand{\@thesisside}{twoside}}
\DeclareOption{oneside}{\renewcommand{\@thesisside}{oneside}}
\DeclareOption{openany}{\renewcommand{\@thesisopen}{openany}}
\DeclareOption{openright}{\renewcommand{\@thesisopen}{openright}}
\DeclareOption{10pt}{\renewcommand{\@thesispoints}{10pt}}
\DeclareOption{11pt}{\renewcommand{\@thesispoints}{11pt}}
\DeclareOption{12pt}{\renewcommand{\@thesispoints}{12pt}}

%% Whether it's a draft (if so, single space and wider margins to fit more)
\DeclareOption{isdraft}{
   	\setboolean{draftthesis}{true}
   	\setboolean{addWatermark}{true}
   	\if@twoside
		\PackageWarning{phdthesis}{twoside not valid in draft mode. Reverting to oneside}
	\fi
   \ExecuteOptions{10pt,openany,oneside}
   \renewcommand{\@draftmessage}{(Draft Copy)\\ \jobname\\ \today }}
   
%% Use useful abbrevations?
\DeclareOption{abbrevs}{\setboolean{useabbrevs}{true}}

%% Select spacing (default: fullspacing)
\DeclareOption{singlespace}{\setboolean{usesinglespacing}{true}}
\DeclareOption{doublespace}{\setboolean{usedoublespacing}{true}}

%% Options to control the format of the cover page
\DeclareOption{logo}{%
    \setboolean{logo}{true}}

%% Use parskip formatting of paragraphs
\DeclareOption{parskip}{\AtEndOfClass{\RequirePackage{parskip}}}

%% Whether to put list of figures and tables into TOC (default: no)
\DeclareOption{listsintoc}{%
    \setboolean{ltoc}{true}}

%% Pre pages can be numbered separately or with the rest of the thesis.
\DeclareOption{romanprepages}{\setboolean{romanpre}{true}}
\DeclareOption{plainprepages}{\setboolean{romanpre}{false}}

%% Whether to have a ragged right margin [often considered more professional]
\DeclareOption{ragged}{\setboolean{raggedRightMargin}{true}}

%% Whether to prevent split footnotes
\DeclareOption{noSplitFootnotes}{\setboolean{noSplitFeet}{true}}

%% Whether to add watermark
\DeclareOption{private}{\setboolean{addWatermark}{true}}

%% Pass all other options directly to report class
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{report}}

%% Set default options and process the ones we were given.
\ExecuteOptions{centerchapter,romanprepages,%
    sansheadings,openright,oneside,12pt} 
\ProcessOptions


%-------------------------- Load Class -----------------------------
%% Built on top of report.cls
\LoadClass[a4paper,\@thesispoints,\@thesisside,\@thesisopen]{report}
\ifthenelse{\boolean{draftthesis}}{} {
	\if@twoside
  		\if@openright
     	\else
       		\PackageWarning{phdthesis}{A two-sided thesis mustnot use the "openany" option}
      	\fi
	\fi
}


%-------------------------- Set chapter names -----------------------
%% Set up the default names for the various chapter headings
%% 	n.b. vals will be overwritten if using the babel package
\renewcommand{\contentsname}{Table of Contents} 
\renewcommand{\listfigurename}{List of Figures}
\renewcommand{\listtablename}{List of Tables}
\renewcommand{\indexname}{Index}
\renewcommand{\abstractname}{Thesis Abstract}
\newcommand{\glossname}{Nomenclature}
\renewcommand{\bibname}{References}


%-------------------------- Format page layout -----------------------
%% First we will sort out the page layout. The following is a brief
%% summary of some typical university typesetting regulations:
%%   Printed on A4 paper, entirely on rectos (single-sided) or on both sides
%%      but with chapters starting on even pages
%%   4cm binding margin
%%   2cm head margin
%%   2.5cm fore-edge margin
%%   4cm tail margin
%%   spacing: not less then 1.5 spacing (18pt leading)
%%            quotations & footnotes in single spacing
%%            bibliography may be in single spacing
%%   character size: not exceed 12pt for body text (at least 10pt)
%%   style: a serif font should be used, with a sans-serif for headings
%%   hyphenation should be avoided if possible

\usepackage{geometry,xspace,setspace,lineno,ragged2e,fnbreak}				
				
%% Set the margins according to the regulation specifications
\ifthenelse{\boolean{draftthesis}}
{
	\if@twoside % defensive - should never get to here
        \geometry{a4paper,twoside,left=2cm,right=2cm,top=2cm,bottom=2cm,bindingoffset=0cm}
     \else % recommended for drafting
        \geometry{a4paper,left=1cm,right=4cm,top=2cm,bottom=2cm,bindingoffset=0cm} % large space on the right for comments
    \fi
}{
	\if@twoside % recommended for final, hardbound version
        \geometry{a4paper,twoside,left=3.25cm,right=3.25cm,top=2.6cm,bottom=3.4cm,bindingoffset=.75cm}
     \else % recommended for softbound, viva version
        %\geometry{a4paper,left=4cm,top=2cm,right=2.5cm,bottom=4cm}
        \geometry{a4paper,left=3.25cm,right=3.25cm,top=2.6cm,bottom=3.4cm,bindingoffset=.75cm} % same as twoside, just on oneside
    \fi
}

%% Establish right-hand margin
\ifthenelse{\boolean{raggedRightMargin}} {
	\ifthenelse{\boolean{draftthesis}}
	{
   		\RaggedRightRightskip=0pt plus 4em % limit the amount of indentation (increase em to further limit)
   	}{}
   \RaggedRight % from ragged2e
   %\renewcommand{\@tocrmarg}{2.75em}
}{
	\usepackage[none]{hyphenat} % suppress excessive wordbreaking across lines
	\sloppy % used to allow url to breakline
}

%% Define header style
\ifthenelse{\boolean{draftthesis}}
{
	% DRAFT: add line numbers, but no headers
	\linenumbers
}
{ 
	% FINAL: add a nice header
	\RequirePackage{fancyhdr}
	\pagestyle{fancy}
	
	% Set headers on content pages
	\if@twoside % chapter on the left page, section on the right page
		\fancyhead[LE,RO]{\small\thepage}
		\fancyhead[LO]{\small\textit\leftmark}
		\fancyhead[RE]{\small\textit\rightmark}
	\else % chapter on all pages
		\fancyhead[L]{\small\textit\leftmark}
		\fancyhead[R]{\small\thepage}
    \fi
    \renewcommand{\chaptermark}[1]{\markboth{\chaptername \ \thechapter.\ #1}{}}
	\renewcommand{\sectionmark}[1]{\markright{#1}}
    		
	% Set headers on chapter pages
	\fancypagestyle{plain}{
		\fancyhead{} % get rid of headers
		%\fancyhead[LE,RO]{\small\thepage} % reintroduce page numbers
		\if@twoside
			\fancyfoot[CE,CO]{\small\thepage} % reintroduce page numbers
		\else % chapter on all pages
			\fancyfoot[C]{\small\thepage}
    	\fi	
		\renewcommand{\headrulewidth}{0pt} % remove the line
	}
	% Blank footer
	\fancyfoot{}
	% If you wanted to extend header beyond margins:
	%\fancyheadoffset[LE,RO]{\marginparsep+1cm}  % requires \usepackage{calc}
	% Nudge header down a little
	\setlength{\headheight}{22pt}
	
	\setlength\headsep{1.5cm} % rule to body content

}

%% Prevent split footnotes completely
\ifthenelse{\boolean{noSplitFeet}} {
	\interfootnotelinepenalty=10000
}{}

%% Establish the vertical line spacing (using the commands provided by setspace)
\ifthenelse{\boolean{draftthesis}}
{
	% DRAFT: single space
	\AtBeginDocument{\singlespacing}
}
{
	% FINAL: onehalf space, unless user specifies otherwise	
	\ifthenelse{\boolean{usesinglespacing}}{
		%\AtBeginDocument{\singlespacing}
		\AtBeginDocument{\setstretch{1.1}}
		\PackageWarning{phdthesis}{Single spacing is not permitted in the regulations!}
	}{
		\ifthenelse{\boolean{usedoublespacing}}
	{
   		\AtBeginDocument{\doublespacing}}
 		{
     		\AtBeginDocument{\onehalfspacing}
		}
	}
}

% In case of big figures, allow pages with only a few lines of text
\renewcommand{\topfraction}{0.9}
\renewcommand{\bottomfraction}{0.6}
\setcounter{topnumber}{2}
\setcounter{bottomnumber}{2}
\setcounter{totalnumber}{2}
\renewcommand{\textfraction}{0.07}
\renewcommand{\floatpagefraction}{0.7}
\renewcommand{\dblfloatpagefraction}{0.7}
% flushbottom is in principle better than raggedbottom for twoside, but my life is too short to try to make this kind of document (lots of figures, section headings, equations) layout properly in LaTeX with flushbottom. the stretchy topskip is a trick to get (slightly) better pagebreaks:
\widowpenalty=10000 \raggedbottom  \addtolength{\topskip}{0pt plus 10pt}
   

   
%-------------------------- Front matter [preliminary pages] --------------------------

%% Hack to make minitoc work. We declare a new chapter
%% variable called starchapter to be used by \addcontentsline when we
%% add contents lines for List of Figures/Tables. If we don't, then
%% minitoc treats the LOF/LOT sections as chapters of the thesis.
\@ifundefined{chapter}{}{\let\l@starchapter\l@chapter}
\setcounter{secnumdepth}{6}

%% "preliminary" environment to control numbering of pages between title and
%% first chapter. This will only kick in if romanprepages is specificed (the
%% default).
\newenvironment{preliminary}
    {\singlespacing % TOC just looks silly in anything other
    \justifying % don't want preliminary info to ever be ragged right (e.g. screws up linewrapping in the TOC)
    \ifthenelse{\boolean{romanpre}}%
        {\pagestyle{plain}\pagenumbering{roman}}
        {\pagestyle{empty}}}%
    {\cleardoublepage%
     \ifthenelse{\boolean{romanpre}}%
        {\pagenumbering{arabic}}%
        {}}

%% Prelim page insertion commands
% (1) Generic
\newcommand{\frontmatter}[2]{
	\chapter*{#1}
	{#2}
    \cleardoublepage
}
% (1b) Abstract
\renewcommand{\abstract}[1]{
	\ifthenelse{\boolean{raggedRightMargin}} {
		\RaggedRight % allow for a ragged right margin as per the body matter
	}{}
	\setlength{\parskip}{10pt plus 8pt}
	\pdfbookmark{\abstractname}{Abstract} 
	\frontmatter{\abstractname}{#1}
	\justifying	% turn back on justification for the remainder of the frontmatter
}
% (1c) Acknowledgements
\newcommand{\acknowledgements}[1]{
	\frontmatter{Acknowledgements}{#1}
}
% (2) Declaration
\newcommand*{\SignatureAndDate}[1]{%
	{\raggedleft
	\slshape
    \par\noindent\makebox[2.5in]{\hrulefill} \hfill\makebox[2.0in]{\hrulefill}\\[-1pt]
    \par\noindent\makebox[2.5in][l]{#1}      \hfill\makebox[2.0in][l]{Date}%
    }
}%

\newcommand{\declaration}[1]{
   	\chapter*{Declaration}
	{#1}
	\par
	\vspace{.25in}
	\SignatureAndDate{\@author}
	\cleardoublepage
}
% (3) Dedication
% If you want the centered text to have a solid left margin, enclose it in a table
% e.g. \begin{tabular}{>{\it}l}aaa\\bbb\\ccc\\\end{tabular}
\newcommand{\dedication}[1]{
   {\vspace*{\fill}
    \begin{center}
	{#1}  
    \end{center}
    \vspace*{\fill}}
    \cleardoublepage
}

%% Title page user input variables
\def\submityear#1{\gdef\@submityear{#1}}
\gdef\@submityear{\the\year}
%
\def\graduationdate#1{\gdef\@graduationdate{#1}}
\gdef\@graduationdate{}
%
\def\university#1{\gdef\@university{#1}}
\gdef\@university{} %University Unspecified???}
%
\def\school#1{\gdef\@school{#1}}
\gdef\@school{} %School Unspecified???}
%
\def\institute#1{\gdef\@institute{#1}}
\gdef\@institute{}
%
\def\email#1{\gdef\@email{#1} \setboolean{inclEmail}{true}}
\gdef\@email{}
%
\gdef\@thetitle{Use $\backslash$title to specify title!} % save for later
\gdef\@title{Use $\backslash$title to specify title!}
\renewcommand\title[1]{\gdef\@thetitle{#1} \gdef\@title{#1}}

%% Define crest insertion command
\newcommand{\includeshield}{\includegraphics{_logo/logo}} \ifx\pdfoutput\undefined \AtBeginDocument{\@endspecial} \fi 

%% Make the title page
\renewcommand{\maketitle}{
	%% tag pdf with info [do it here before title and author are cleared after maketitle]
	\ifpdf
	    \pdfinfo { /Title  (\@title)
	               /Creator (TeX)
	               /Producer (pdfTeX)
	               /Author (\@author)
	               /CreationDate (D:20030101000000)
	               /ModDate (D:\pdfdate)
	               /Subject (PhD thesis)
	               /Keywords (PhD, Thesis)}
	    \pdfcatalog { /PageMode (/UseOutlines)
	                  /OpenAction (fitbh)  }
	\fi

	\pdfbookmark{Front Cover}{Title}
	\begin{titlepage}\begin{center}
	\null\vfil\vskip 50\p@
	%{\LARGE\bfseries \@chapterfont \@title \par
	{\LARGE\bfseries \@title \par
	\large\textit\@draftmessage
	}\vfill    
 	\ifthenelse{\boolean{logo}}%
		{\resizebox{50mm}{!}{\includeshield}\\\vfill}
  		{}
 		{
 		\Large 
 		\ifthenelse{\boolean{inclEmail}} {
			\begingroup
			\hypersetup{urlcolor=black}
			\href{mailto:\@email}{\@author}
			\endgroup 			
		}{
			\@author
		}	 	
		\par	
		\vskip .75cm
 		}
		{\large
		\ifx\@empty\@institute
    	\else
        	\@institute \\
    	\fi
    	\ifx\@empty\@school
    	\else
        	\@school \\
    	\fi
    	\ifx\@empty\@university
			 \vspace{1.5cm}
    	\else
        	\@university \\[1.5cm]
    	\fi
    	
    	\ifthenelse{\boolean{draftthesis}}{}
    	{
			\ifx\@empty\@university
				{Thesis submitted}
			\else
				{Thesis submitted to the \@university\\}
			\fi
 			{for the degree of \textit{Doctor of Philosophy} \par\vskip .75cm \@submityear \par \vskip 2cm}}
  			\ifthenelse{\equal{\@graduationdate}{}}{}
  			{{\large \ttfamily (Graduation date: \@graduationdate)}}
  		}
  			
	\end{center}
  	\end{titlepage}
	\if@twoside
		\setcounter{page}{0} % ensure numbering begins on first frontmatter page (and at 1)
	\fi	
}

%-------------------------- Front matter [toc] --------------------------


% Add table of contents
\let\old@tableofcontents\tableofcontents
\renewcommand{\tableofcontents}
{
	\pdfbookmark{\contentsname}{Contents}
	\old@tableofcontents
}

%% If requested, put the list of figures and list of tables into the table of
%% contents.
\ifthenelse{\boolean{ltoc}}
    {\RequirePackage[nottoc,notbib]{tocbibind}}
    {}

% slightly increase the page-number box (default =  1.55em), to prevent an extra dot on some pages (e.g., 11, 21)
\renewcommand{\@pnumwidth}{1.75em}

  
%-------------------------- Main matter [chapters] -------------------------- 
%% Introduce a chapabstract env. which is small and italic [piggy back on quote]
\newenvironment{chapabstract}
{
	\begin{quote}
	\singlespacing
	\small
	%\em % italic
	\slshape % more subtle slant
}{
	\end{quote}
	\vspace{4pt}
}

%% Introduce a quotetext env. which is single spaced, enclosed in quote marks,
%% and can have an attribution.
\newcommand{\quotationname}{}
\newenvironment{quotetext}[1]
   {\renewcommand{\quotationname}{#1}\begin{quote}``\it}{\rm '' \end{quote}
    \hspace*{\fill}\nolinebreak[1]\hspace*{\fill}
    \rm\raisebox{2ex}{(\quotationname)} % vertical raise up by the height of 2 x's
   }   

\newenvironment{chapacknowledgements}
{
	\vspace{12pt}
	\section*{Acknowledgements}
	\vspace{-12pt}
	\singlespacing
	\small
}{}
    
    
%---------------------- Widows and Orphans -------------------------- 
% By Michael Downes 

% set \clubpenalty, etc. to distinctive values for use 
% in tracing page breaks. These values are chosen so that 
% no single penalty will absolutely prohibit a page break, but 
% certain combinations of two or more will. 
\clubpenalty=9996 
\widowpenalty=9999 
\brokenpenalty=4991 
% Reiterate the default value of \redisplaypenalty, for 
% completeness. 
% Set postdisplaypenalty to a fairly high value to discourage a 
% page break between a display and a widow line at the end of a 
% paragraph. 
\predisplaypenalty=10000 
\postdisplaypenalty=1549 
% And then \displaywidowpenalty should be at least as high as 
% \postdisplaypenalty, otherwise in a situation where two displays 
% are separated by two lines, TeX will prefer to break between the 
% two lines, rather than before the first line. 
\displaywidowpenalty=1602 

    
%-------------------------- References --------------------------
\usepackage{natbib} % for good references - see http://merkel.zoneo.net/Latex/natbib.php - n.b. requires .bst file (e.g. apalike.bst)

%% ALWAYS put the bibliography into the TOC.
%% Thanks to Peter Wilson <peter.r.wilson@boeing.com> for pointing me in the
%% right direction, and to Heiko Oberdiek <oberdiek@ruf.uni-freiburg.de>
%% and Michael J Downes <epsmjd@ams,org> for together coming up with this
%% solution.
%%
%% However the bibliography is defined, this will append the \addcontentsline
%% statement to it. Also, it will put the bibname into the page headers.
\AtBeginDocument{%
    \expandafter\def\expandafter\thebibliography\expandafter
        #\expandafter1\expandafter{\thebibliography{#1}%
        {\addcontentsline{toc}{chapter}{\bibname}}
        \markboth{\bibname}{\bibname}}}
 
% Define a bibliography style with single-lining and small font        
\newcommand{\refstyle}{
	\bibliographystyle{./_references/myapalike}
	\singlespacing
	\footnotesize
	\ifthenelse{\boolean{raggedRightMargin}} {
		\renewcommand*{\bibfont}{\raggedright} % allow for a ragged right margin as per the body matter
	}{}
}

% Intercept bibliograpy call and implement above reference style
\let\old@bibliography\bibliography
\renewcommand{\bibliography}[1]
{
	\pdfbookmark{\bibname}{References}
	\refstyle
	\old@bibliography{#1}
}


%-------------------------- Fonts --------------------------
\usepackage{tgheros,pifont}
				
%% Bitstream Charter is a popular, free, serif typeface7. It has native support for mathematical typesetting, and is fully scalable (e.g., allowing %% it to support custom stylings, such as chapter-initial dropcaps). It is somewhat stronger than the standard modern font, making it better suited %% to low-resolution printing and e-reading.
\renewcommand{\familydefault}{bch}

%% Do what is requested with headings and captions... can't include these
%% packages above because sectsty won't work except from within report.cls
%% itself. Must save \@chapterfont because the front environments (abstract
%% etc) also need to use it.
\RequirePackage{sectsty}

% BUG!
% http://www.latex-community.org/viewtopic.php?f=5&t=996
\usepackage{caption3} % load caption package kernel first
\DeclareCaptionOption{parskip}[]{} % disable "parskip" caption option

\RequirePackage[hang,footnotesize,bf,justification=justified,singlelinecheck=false]{caption}
\ifthenelse{\boolean{sansheadings}}
    {
    \renewcommand{\sfdefault}{lmss} % use latin modern sans as sans serif font
     \allsectionsfont{\sffamily}
     \renewcommand{\@chapterfont}{\sffamily}
    }{}

\usepackage{subcaption}
\captionsetup[subfigure]{justification=centering}

% general formating & text control
\usepackage[latin1]{inputenc} 	% maps certain characters to their corresponding TeX macros
%\usepackage{siunitx}	% for typesetting units and especially for the "S" column type, which allows numbers in tables to be easily aligned, e.g. on the decimal marker.
\usepackage{textcomp} % provides extra symbols
\usepackage{microtype}	% It improves the appearance of written text blocks in very subtle ways
\usepackage{lettrine}


%-------------------------- Chapter Heading Styles --------------------------
%% Chapter style
%% 	n.b. a fncychap style will override the sectsty font definition
\usepackage[Sonny]{fncychap}

% Actually Sonny is not so nice, (re)define a slightly nicer version
\ChRuleWidth{0.4pt} 
\renewcommand{\DOCH}{%
	\onehalfspacing
	\raggedleft
	\CNV\FmN{\@chapapp}\space \CNoV\thechapter
	\par\nobreak
	\vskip 4\p@ % gap from chapter number to title
}
\renewcommand{\DOTI}[1]{%
	\onehalfspacing
	\CTV\raggedleft\color{gray}\mghrulefill{\RW}\\[-6pt]
	\color{black}\CTV\FmTi{#1}\\[-16pt]
	\color{gray}\mghrulefill{\RW}\par\nobreak
	\vskip 25\p@ % gap to abstract
}
\renewcommand{\DOTIS}[1]{%
	\onehalfspacing
	\CTV\raggedleft\color{gray}\mghrulefill{\RW}\\[-6pt]
	\color{black}\CTV\FmTi{#1}\\[-16pt]
	\color{gray}\mghrulefill{\RW}\par\nobreak
	\vskip 25\p@
}

%% To make sure we get chapters aligned correctly, we set it here instead.
\chapterfont{\@chapterfont}


%-------------------------- Notes --------------------------
% Define the marginnote wrapper for marginpar
% [see also fixme, below]
\usepackage{marginnote}

\newcommand{\marginnotesc}[1]{%
	%\marginpar{\small\textsc{#1}}
	\marginnote{\small\textsc{#1}}
}

% define with \endnote{}. Print the list of endnotes with \theendnotes
\usepackage{endnotes}

% Reset endnote numbering every new chapter
\@addtoreset{endnote}{chapter}
 
% Prevent 'Notes' appearing in the fancyhdr. (Stop \theendnotes from 
% setting the marks for the headers). Start on new page
\renewcommand\enoteheading{\clearpage\section*{\notesname}%
\mbox{}\par\vskip-\baselineskip}

% Redefine a portion of endnote.sty to allow for hyperlinks
% - with thanks to Ulrich Dirr 
\newif\ifenotelinks
\newcounter{Hendnote}
% Redefining portions of endnotes-package:
\let\savedhref\href
\let\savedurl\url
\def\endnotemark{%
\@ifnextchar[\@xendnotemark{%
\stepcounter{endnote}%
\protected@xdef\@theenmark{\theendnote}%
\protected@xdef\@theenvalue{\number\c@endnote}%
\@endnotemark
}%
}%
\def\@xendnotemark[#1]{%
\begingroup\c@endnote#1\relax
\unrestored@protected@xdef\@theenmark{\theendnote}%
\unrestored@protected@xdef\@theenvalue{\number\c@endnote}%
\endgroup
\@endnotemark
}%
\def\endnotetext{%
\@ifnextchar[\@xendnotenext{%
\protected@xdef\@theenmark{\theendnote}%
\protected@xdef\@theenvalue{\number\c@endnote}%
\@endnotetext
}%
}%
\def\@xendnotenext[#1]{%
\begingroup
\c@endnote=#1\relax
\unrestored@protected@xdef\@theenmark{\theendnote}%
\unrestored@protected@xdef\@theenvalue{\number\c@endnote}%
\endgroup
\@endnotetext
}%
\def\endnote{%
\@ifnextchar[\@xendnote{%
\stepcounter{endnote}%
\protected@xdef\@theenmark{\theendnote}%
\protected@xdef\@theenvalue{\number\c@endnote}%
\@endnotemark\@endnotetext
}%
}%
\def\@xendnote[#1]{%
\begingroup
\c@endnote=#1\relax
\unrestored@protected@xdef\@theenmark{\theendnote}%
\unrestored@protected@xdef\@theenvalue{\number\c@endnote}%
\show\@theenvalue
\endgroup
\@endnotemark\@endnotetext
}%
\def\@endnotemark{%
\leavevmode
\ifhmode
\edef\@x@sf{\the\spacefactor}\nobreak
\fi
\ifenotelinks
\expandafter\@firstofone
\else
\expandafter\@gobble
\fi
{%
\Hy@raisedlink{%
\hyper@@anchor{Hendnotepage.\@theenvalue}{\empty}%
}%
}%
\hyper@linkstart{link}{Hendnote.\@theenvalue}%
\makeenmark
\hyper@linkend
\ifhmode
\spacefactor\@x@sf
\fi
\relax
}%
\long\def\@endnotetext#1{%
\if@enotesopen
\else
\@openenotes
\fi
\immediate\write\@enotes{%
\@doanenote{\@theenmark}{\@theenvalue}%
}%
\begingroup
\def\next{#1}%
\newlinechar='40
\immediate\write\@enotes{\meaning\next}%
\endgroup
\immediate\write\@enotes{%
\@endanenote
}%
}%
\def\theendnotes{%
\immediate\closeout\@enotes
\global\@enotesopenfalse
\begingroup
\makeatletter
\edef\@tempa{`\string>}%
\ifnum\catcode\@tempa=12
\let\@ResetGT\relax
\else
\edef\@ResetGT{\noexpand\catcode\@tempa=\the\catcode\@tempa}%
\@makeother\>%
\fi
\def\@doanenote##1##2##3>{%
\def\@theenmark{##1}%
\def\@theenvalue{##2}%
\par
\smallskip %<-small vertical gap between endnotes
\begingroup
\def\href{\expandafter\savedhref}%
\def\url{\expandafter\savedurl}%
\@ResetGT
\edef\@currentlabel{\csname p@endnote\endcsname\@theenmark}%
\enoteformat
}%
\def\@endanenote{%
\par\endgroup
}%
% Redefine, how numbers are formatted in the endnotes-section:
\renewcommand*\@makeenmark{%
\hbox{\textsuperscript{\normalfont\@theenmark}}% PJ: superscript
}%
% header of endnotes-section
\enoteheading
% font-size of endnotes
\enotesize
\input{\jobname.ent}%
\endgroup
}%
\def\enoteformat{%
\rightskip\z@
\leftskip1.8em
\parindent\z@
\leavevmode\llap{%
\setcounter{Hendnote}{\@theenvalue}%
\addtocounter{Hendnote}{-1}%
\refstepcounter{Hendnote}%
\ifenotelinks
\expandafter\@secondoftwo
\else
\expandafter\@firstoftwo
\fi
{\@firstofone}%
{\hyperlink{Hendnotepage.\@theenvalue}}%
{\makeenmark}%
}%
}%

% Toggle switch in order to turn on/off back-links in the
% endnote-section:
\enotelinkstrue
%\enotelinksfalse


%-------------------------- Matlab --------------------------
%% Define a Matlab style
\RequirePackage{listings,textcomp}
\RequirePackage[usenames,dvipsnames]{color}
\definecolor{listinggray}{gray}{0.9}
\definecolor{lbcolor}{rgb}{0.95,0.95,0.95} % background colour
\definecolor{dkgreen}{rgb}{0,0.6,0}
\definecolor{gray}{rgb}{0.5,0.5,0.5}
\definecolor{mauve}{rgb}{0.58,0,0.82}
\definecolor{dkgray}{rgb}{0.4,0.4,0.4}
\lstset{ %
  language=matlab,                				% the language of the code
  basicstyle=\ttfamily\small,  		 		% the size of the fonts that are used for the code
  numbers=left,                   					% where to put the line-numbers
  numberstyle=\tiny\color{gray}, 		% the style that is used for the line-numbers
  numberfirstline=true,                   		% [1/2]
  firstnumber=1,                   				% [2/2] ensure numbering goes 1.. 5.. 10.. 15.. etc.
  stepnumber=5,                   				% the step between two line-numbers. If it's 1, each line will be numbered
  numbersep=5pt,                  				% how far the line-numbers are from the code   
  backgroundcolor=\color{lbcolor}, 	% choose the background color. You must add \usepackage{color}
  showspaces=false,         					% show spaces adding particular underscores
  showstringspaces=false,  					% underline spaces within strings
  showtabs=false,           						% show tabs within strings adding particular underscores
  frame=single,                   					% adds a frame around the code
  rulecolor=\color{black}, 					% if not set, the frame-color may be changed on line-breaks within not-black text (e.g. commens (green here))
  tabsize=4,                      					% sets default tabsize to 4 spaces
  captionpos=b,                   				% sets the caption-position to bottom
  breaklines=true,                				% sets automatic line breaking
  breakatwhitespace=false,	 				% sets if automatic breaks should only happen at whitespace
  title=\lstname,                   				% show the filename of files included with \lstinputlisting;
  keywordstyle=\color{blue},          		% keyword style
  commentstyle=\color{dkgreen}, 		% comment style
  stringstyle=\color{mauve},         		% string literal style
  escapeinside={\%*}{*)},            			% if you want to add a comment within your code
  morekeywords={*,...},               			% if you want to add more keywords to the set
  prebreak = \raisebox{0ex}[0ex][0ex]{\ensuremath{\ldots}}, % show linebreaks
  aboveskip=.75cm, 								% gap from text. Default: \medskipamount
  belowskip=.25cm, 								% gap to text
  upquote=true % for better quote marks [in conjunction with the textcomp package]
}
\lstset{
    literate={~} {$\sim$}{1} % nicer symbol
}
\def\lstinlineB{\lstinline[language=matlab,basicstyle=\ttfamily\color{dkgreen}\normalsize]} %[ an alternative style for including inline Matlab references
\def\lstinlineC{\lstinline[language=matlab,basicstyle=\ttfamily\color{dkgreen}\normalsize,keywordstyle=\color{dkgreen}]} %[ an alternative style for including inline Matlab references (no blue keywords] 


%-------------------------- Hyperlinks & Graphics -----------------------
% Redfine the label used in captions. Figure 1: => Fig. 1:
\renewcommand{\figurename}{Fig.} % For tables, \tablename. For contents, \contentsname

%% Will depend on whether or not using pdftex
\ifpdf
    \usepackage[ pdftex, plainpages = false, pdfpagelabels, 
                 pdfpagelayout = OneColumn, % display single page, advancing flips the page - Sasa Tomic
                 bookmarks,
                 bookmarksopen = true,
                 bookmarksnumbered = true,
                 breaklinks = true,
                 linktocpage,
                 pagebackref,
                 colorlinks = true,
                 linkcolor = blue,
                 urlcolor  = blue,
                 citecolor = black,
                 anchorcolor = green,
                 hyperindex = true,
                 hyperfigures,
                 backref=page
                 ]{hyperref} 
    \usepackage[pdftex]{graphicx}
    \DeclareGraphicsExtensions{.pdf, .png, .jpg, .jpeg}
    \pdfcompresslevel=9 %best compression level for text and image
    %\graphicspath{{ThesisFigs/PNG/}{ThesisFigs/PDF/}} % no longer works, since using subimport
\else
    \usepackage[ dvips, 
                 bookmarks,
                 bookmarksopen = true,
                 bookmarksnumbered = true,
                 breaklinks = false, % pj: changed from true to supress warning
                 linktocpage,
                 pagebackref,
                 colorlinks = true,
                 linkcolor = blue,
                 urlcolor  = blue,
                 citecolor = black,
                 anchorcolor = green,
                 hyperindex = true,
                 hyperfigures
                 ]{hyperref}

    \usepackage{epsfig}
    \usepackage{graphicx}
    \DeclareGraphicsExtensions{.eps, .ps}
    %\graphicspath{{ThesisFigs/EPS/}{ThesisFigs/}}
\fi


%---------------- Subfigures / float placement -------------------
% First there was subfigure. Next came subfig. Then came float ('subfloat')
% Now apparently we are all supposed to use floatrow.
% (requires caption, subcaption, and calc - all loaded earlier)
\usepackage{floatrow}
\floatsetup{ 
  heightadjust=object,
  valign=t
}


%---------------------------- Tables -------------------------------
\usepackage{multirow} 			% for table cells spanning multiple rows		
\usepackage{longtable}		
\usepackage{xcolor,colortbl} 				% for coloured lines in tables
\usepackage{kbordermatrix}	% allows for bordered matrices (cf \bordermatrix)
\usepackage{booktabs}
\usepackage{threeparttable} 	% for table footnotes
\usepackage{tabularx}

% double rules at top and bottom
%\let\old@toprule\toprule
%\let\old@bottomrule\bottomrule
%%\renewcommand{\toprule}{\old@toprule \old@toprule}
%\renewcommand{\toprule}{\old@bottomrule \old@bottomrule \noalign{\vskip 5pt}  } % [\heavyrulewidth] ?
%\renewcommand{\bottomrule}{\old@bottomrule\old@bottomrule}
\renewcommand{\toprule}{\specialrule{.4pt}{.5cm}{1pt} \specialrule{.4pt}{1pt}{0pt} }
\renewcommand{\bottomrule}{\specialrule{.4pt}{0cm}{1pt} \specialrule{.4pt}{1pt}{0pt} }


%---------------------------- Lists -------------------------------      
\usepackage{enumerate} 			% for custom enumeration formats


%-------------------------- Mathematics -------------------------
\usepackage{nicefrac, amsmath, amsfonts, amsthm, amssymb}

%% Number equations within each chapter
\numberwithin{equation}{chapter}

%\DeclareMathSymbol{\mlq}{\mathord}{operators}{``}
%\DeclareMathSymbol{\mrq}{\mathord}{operators}{`'}

% provide a \mathlist environment in which 
% commas can break lines when in inline maths mode
\mathchardef\breakingcomma\mathcode`\,
{\catcode`,=\active
  \gdef,{\breakingcomma\discretionary{}{}{}}
}
\newcommand{\mathlist}[1]{
	\ensuremath{\mathcode`\,=\string"8000 #1}
}
  

%-------------------------- Common Abbreviations -----------------------------
%% Some sundry abbreviations which are generally useful...
\ifthenelse{\boolean{useabbrevs}}
{
\newcommand{\ns}{n.s.\@\xspace}
\newcommand{\cf}{cf.\@\xspace}
\newcommand{\NB}{N.B.\@\xspace}
\newcommand{\nb}{n.b.\@\xspace}	
\newcommand{\eg}{e.g.,\@\xspace}
\newcommand{\Eg}{E.g.,\@\xspace}
\newcommand{\ie}{i.e.,\@\xspace}
\newcommand{\Ie}{I.e.,\@\xspace}
\newcommand{\etc}{etc.\@\xspace}
\newcommand{\etal}{{\em et al}.\@\xspace}
\newcommand{\etseq}{{\em et seq}.\@\xspace}
\newcommand{\precis}{pr\'ecis\xspace}
\newcommand{\Precis}{Pr\'ecis\xspace}
\newcommand{\role}{r\^ole\xspace}
\newcommand{\Role}{R\^ole\xspace}
\newcommand{\naive}{na\"\i ve\xspace}
\newcommand{\Naive}{Na\"\i ve\xspace}
\newcommand{\tm}{\raisebox{1ex}{\tiny TM}\xspace}
\newcommand{\cpright}{\raisebox{1ex}{\tiny\copyright}\xspace}
\newcommand{\degrees}{\raisebox{1.2ex}{\tiny\ensuremath{\circ}}\xspace}
\newcommand{\iid}{i.i.d.\@\xspace}
\newcommand{\dprime}{\ensuremath{d^{\prime}}~}
\newcommand{\about}{\ensuremath{\mathord{\sim}}} % mathord to prevent horizontal space
%\newcommand{\tickmark}{\checkmark} % alt: \ding{51} in pifont's dingbats
%\newcommand{\crossmark}{\text{\sffamily X}} % alt: \ding{55} in pifont's dingbats, i.e., can be overwritten with: \usepackage{pifont} \renewcommand{\crossmark}{\text{\ding{55}}}
\newcommand{\tickmark}{\text{\ding{51}}}
\newcommand{\crossmark}{\text{\ding{55}}}
\newcommand{\yo}{y.o.\@\xspace}
\newcommand{\yos}{years old\@\xspace}
% Maths
\DeclareMathOperator*{\argmin}{arg\,min} % e.g. \argmin_c f(c)
\DeclareMathOperator*{\argmax}{arg\,max} % e.g. \argmax_c f(c)
\newcommand{\superscript}[1]{\ensuremath{^{\textrm{#1}}}} % by anthony liekens
\renewcommand{\th}[0]{\superscript{th}}
\newcommand{\st}[0]{\superscript{st}}
\newcommand{\nd}[0]{\superscript{nd}}
\newcommand{\rd}[0]{\superscript{rd}}
% References
\newcommand{\fref}[1]{Fig~\ref{#1}}
\newcommand{\tref}[1]{Table~\ref{#1}}
\newcommand{\eref}[1]{Eq~\ref{#1}}
\newcommand{\cref}[1]{Chapter~\ref{#1}}
\newcommand{\sref}[1]{\ensuremath{\oint}\ref{#1}} %\newcommand{\sref}[1]{Section~\ref{#1}}
\newcommand{\aref}[1]{Appendix~\ref{#1}}
%
\newcommand{\Fref}[1]{Figure~\ref{#1}}
\newcommand{\Eref}[1]{Equation~\ref{#1}}
\newcommand{\Sref}[1]{Section~\ref{#1}}
\newcommand{\Tref}[1]{\tref{#1}} % same
\newcommand{\Cref}[1]{\cref{#1}}
\newcommand{\Aref}[1]{\aref{#1}}
}{}

%% It is probably not a good idea to use document Part(s), but if one does then
%% the backmatter (references, appendices, etc.) are liable to appear in the pdf
%% bookmarks within the last content Part. Use \ChapterOutsidePart to prevent
%% this.
%%  - 	by Juanjo on Sat Nov 1st, 2008
%% 		http://www.latex-community.org/forum/viewtopic.php?f=5&t=2674
\newcommand{\ChapterOutsidePart}{%
   \def\toclevel@chapter{-1}\def\toclevel@section{0}\def\toclevel@subsection{1}}
\newcommand{\ChapterInsidePart}{%
   \def\toclevel@chapter{0}\def\toclevel@section{1}\def\toclevel@subsection{2}}


%--------------- Document development & maintainance ---------------
%% Comments / track changes
\ifthenelse{\boolean{draftthesis}} {
	\usepackage[draft]{fixme}
}{
	\usepackage[final]{fixme}
	%In final mode, non fatal annotations (those generated by \fxnote, \fxwarning, \fxerror and their corresponding environments) are still logged, but they’re not typeset. On the other hand, fatal ones (those generated by the \fxfatal command and the anfxfatal environment) will throw a LATEX error and thus interrupt or abort compilation with an informative message. This will help you track down forgotten important caveats in your document.
}

\usepackage{nag} % warns when you use deprecated LaTeX constructs (cf. l2tabu)
\usepackage{lipsum}


%--------------- Drawing ---------------
% hack for getting tikz working on my version of windows
\usepackage{etex}
\reserveinserts{28}

\usepackage{tikz}
\usepackage{pgfplots}
\usepackage{pgfplotstable}
\usepackage{filecontents}
\usepackage{adjustbox}


%----------------------------- Further page-layout tweaks -----------------------------  
% have had to move this down here for it to work (presumably so as to be after sectsty(?))
%% Nudge content up closer to section headers, and make pages created by "cleardoublepage" be
%% really empty.
\usepackage[compact,clearempty]{titlesec}
\titlespacing{\section}{0pt}{*1}{*0} % move content up closer to header [left, before, after, right]
\titlespacing{\subsection}{0pt}{*1}{*-.25}
\titlespacing{\subsubsection}{0pt}{*1}{*-.75}
%\titlespacing{\subsubsection}{0pt}{0pt}{0pt}

   
%----------------------------- Parts -----------------------------  
% (requires titlesec)
\titleclass{\part}{top} % make part like a chapter
\titleformat{\part}
[display]
{\centering\@chapterfont\LARGE}
{\vskip 140\p@ \MakeUppercase{\partname} \thepart}
{0pt}
%{\titlerule[2pt]\vspace{1pc}\Large\MakeUppercase}
{\titlerule[0.75pt]\vspace{1pc}\LARGE}
%
\titlespacing*{\part}{0pt}{0pt}{20pt}


%----------------------------- Appendices -----------------------------  
% See http://www.tex.ac.uk/cgi-bin/texfaq2html?label=appendix
\usepackage{appendix}		
	
\newcommand{\chapappendices}
{
	\clearpage
	\section*{Chapter Appendices} % print title
	\newcommand{\sectionbreak}{\clearpage} % have each subappendix appear on a new line
	\subappendices % run
}

%--------------- Glossary ---------------
% n.b. for this to work, use: "/usr/texbin/makeindex" %.idx %.glo -s %.ist -t %.glg -o %.gls
\usepackage[sanitize={name=false,description=false,symbol=false}]{glossaries} % relax sanitize to allow for symbols

\makeindex
\makeglossaries

\renewcommand*{\glossaryname}{\glossname} % change title on glossary page
\renewcommand*{\glstextformat}[1]{\textcolor{black}{#1}} % change glossary links in bodytext to be black
\renewcommand*{\glspostdescription}{} % remove fullstop from the end of each glossary description
% make new glossary style
\newglossarystyle{ihrgloss}{%
  \renewenvironment{theglossary}%
  {\singlespacing\begin{longtable}{>{\footnotesize}p{0.05\linewidth}>{\footnotesize\RaggedRight\slshape}p{0.2\linewidth}>{\footnotesize}p{0.65\linewidth}}}%
  {\end{longtable}}%
  \renewcommand*{\glossaryheader}{}%
  \renewcommand*{\glsgroupheading}[1]{}%
  \renewcommand*{\glossaryentryfield}[5]{%
     \glsentryitem{##1}\glstarget{##2}{##4} &  \makefirstuc{##2} & ##3\\} % table row
  \renewcommand*{\glossarysubentryfield}[6]{%
     &
     \glssubentryitem{##2}%
     \glstarget{##2}{\strut}##4 & ##6\\}%
 % \renewcommand*{\glsgroupskip}{ & & &\\}%
  \renewcommand*{\glsgroupskip}{}% no skip better letters in the alphabet
}

% Only show first occurrence [only half works]
% https://groups.google.com/forum/?fromgroups=#!topic/comp.text.tex/BoX7vjoUgnI
\def\dofirstnumber#1#2[#3]#4#5#6#7\enddofirstnumber{3}
\renewcommand\glossaryentrynumbers[1]{%
	%\relax \setentrycounter{page}\glsnumberformat{1}
 	\dofirstnumber#1\enddofirstnumber
}

\newcommand*{\glsgobblenumber}[1]{}
% \renewcommand*{\glsgobblenumber}[1]{#1}% uncomment for testing

\renewcommand*{\glsadd}[2][]{%
\def\@glsnumberformat{glsnumberformat}% DELETED
    \def\@glsnumberformat{glsgobblenumber}% NEW
    \edef\@gls@counter{\csname glo@#2@counter\endcsname}%
    \setkeys{glossadd}{#1}%
    \@gls@saveentrycounter
    \@do@wrglossary{#2}%
}

%\defglsdisplayfirst{#1#4} % initially display text
%\defglsdisplayfirst{#1#4, #3} % initially display text, symbol <-- clever, but too confusing
\defglsdisplayfirst{#3} % use symbol even on first use
\defglsdisplay{#3} % just use symbol from then on
\newcommand{\glsdef}[1]{\glstext{#1}, \gls{#1}}
\newcommand{\Glsdef}[1]{\Glstext{#1}, \gls{#1}}
\renewcommand*{\glspl}[1]{\gls{#1}s}
\newcommand{\glstextpl}[1]{\glstext{#1}s}
%\defglsdisplayfirst{#1#4, #3,} % hack, what if end of sentence?

% define trigger
\newcommand{\nomenclature}[1][0]{
	\pdfbookmark{\glossaryname}{Nomenclature} 
	\renewcommand{\arraystretch}{1.4} %gap between entries

	\ifthenelse{#1=1}{ % if \nomenclature[1]
		\printglossary[nonumberlist=true,style=ihrgloss] % suppress number list
		\glsaddall
	}{
		\printglossary[style=ihrgloss]
	} 
	\clearpage
}


%----------------------------- Watermark -----------------------------  
%% Add watermark to the page background
\ifthenelse{\boolean{addWatermark}}
{
	\usepackage{type1cm,eso-pic}
	\makeatletter
	\AddToShipoutPicture{
	\setlength{\@tempdimb}{.5\paperwidth}
	\setlength{\@tempdimc}{.4\paperheight}
	\setlength{\unitlength}{1pt}
	\put(\strip@pt\@tempdimb,\strip@pt\@tempdimc){
	\makebox(0,0){\rotatebox{55}{\textcolor[gray]{0.85}
	{\fontsize{3.5cm}{3.5cm}\selectfont{PRIVATE}}}}
	}
	}
	\makeatother
}{}   


%% EOF: phdthesis.cls