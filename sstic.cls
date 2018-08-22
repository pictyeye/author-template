\NeedsTeXFormat{LaTeX2e}%[1995/12/01] TODO: Add a date?
\ProvidesClass{sstic}[2018/08/21 SSTIC Proceedings style]

\LoadClass[b5paper,11pt]{llncs}


%%%%%%%%%%%%%%%%%%%%%%%%%
% Class Option Handling %
%%%%%%%%%%%%%%%%%%%%%%%%%
\let\ifssticbw\iffalse
\DeclareOption{bw}{\let\ifssticbw\iftrue}
\let\ifssticebook\iffalse
\DeclareOption{ebook}{\let\ifssticebook\iftrue}

\ProcessOptions


%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Fonts and similar stuff %
%%%%%%%%%%%%%%%%%%%%%%%%%%%
\RequirePackage[utf8x]{inputenc}
\ifssticebook
  \RequirePackage{textcomp}
  \DeclareUnicodeCharacter{00A0}{~}
\fi
\RequirePackage[fit]{truncate}
\RequirePackage{xspace}
\RequirePackage[T1]{fontenc}
\RequirePackage{microtype}     % Requires the cm-super Debian package
\RequirePackage{lmodern}
\RequirePackage{eurosym}
\RequirePackage{amsmath}
\RequirePackage{amssymb}
\RequirePackage{pifont}


%%%%%%%%%
% Babel %
%%%%%%%%%
\RequirePackage[english,french,main=french]{babel}
% Bug:
% babel wrongly warns about Figure/Table captions being possibly wrong in French
% Since the warning does not apply here (false positive), we can remove it.
\frenchbsetup{SuppressWarning=true} % TODO: Remove this!


%%%%%%%%%%%
% Headers %
%%%%%%%%%%%
\newcommand{\theshorttitle}{}
\newcommand\settitle[2][]{%
 \title{#2}%
 \ifthenelse{\equal{#1}{}}%
  {\renewcommand{\theshorttitle}{#2}\toctitle{#2}\titlerunning{#2}}%
  {\renewcommand{\theshorttitle}{#1}\toctitle{#1}\titlerunning{#1}}%
}

\newcommand{\theshortauthor}{}
\newcommand\setauthor[2][]{%
 \author{#2}%
 \ifthenelse{\equal{#1}{}}%
  {\renewcommand{\theshortauthor}{#2}\tocauthor{#2}\authorrunning{#2}}%
  {\renewcommand{\theshortauthor}{#1}\tocauthor{#1}\authorrunning{#1}}%
}

\ifssticebook
\else
  \RequirePackage{fancyhdr}

  \pagestyle{fancy}
  \fancyhf{}
  \setlength{\headheight}{16pt}
  \fancyhead[LE,RO]{\thepage}
  \fancyhead[RE]{\truncate{.90\headwidth}{\theshorttitle}}
  \fancyhead[LO]{\truncate{.90\headwidth}{\theshortauthor}}
\fi



%%%%%%%%%%%%%%%%%%%%%%%
% Graphics, tables... %
%%%%%%%%%%%%%%%%%%%%%%%
\RequirePackage[table]{xcolor}
\RequirePackage{graphicx}
%\RequirePackage{pgfplots}
%\pgfplotsset{compat=1.11}
\RequirePackage{tabularx}
\RequirePackage{array}
\RequirePackage{longtable}
\RequirePackage{multirow}
\RequirePackage{lscape}
\RequirePackage{etoolbox}
\RequirePackage{subfigure}
\RequirePackage{verbatim}
\RequirePackage{pmboxdraw}
\RequirePackage{fancyvrb}
\RequirePackage{algorithm}
\RequirePackage{tcolorbox}
\RequirePackage{booktabs}
\RequirePackage{rotating}

\ifssticebook
  % use dvips, ebook readers don't cope to well with svg
  \def\pgfsysdriver{pgfsys-dvips.def}
\fi

\RequirePackage{tikz}
\RequirePackage{tikz-qtree}
\usetikzlibrary{arrows,positioning}
\usetikzlibrary{patterns}
\usetikzlibrary{automata}
\usetikzlibrary{calc}
\RequirePackage[fancy]{tikz-inet}
\usetikzlibrary{shapes,backgrounds}
\usetikzlibrary{trees}

\ifssticebook
  % htlatex uses latex in dvi mode so force the extension to something (either png or eps)
  \DeclareGraphicsExtensions{.eps, .png}
\fi


%%%%%%%%%%%%%%
% Listing... %
%%%%%%%%%%%%%%
\RequirePackage{listings}
\RequirePackage[noend]{algpseudocode}

\definecolor{grigri}{RGB}{233,232,234}
\lstset{breaklines=true,
        tabsize=4,
        boxpos=c,
        showstringspaces=false,
        basicstyle=\ttfamily\scriptsize,
        aboveskip=\bigskipamount,
        belowskip=\bigskipamount,
        captionpos=b,
        language=C,
        extendedchars=false
        basicstyle=\scriptsize\sffamily\color{darkgray},
        keywordstyle=\bfseries\color{purple},
        identifierstyle=\bfseries\color{black},
        commentstyle=\ttfamily\itshape\color{purple},
        stringstyle=\ttfamily\color{brown},
        showstringspaces=false,
        frame=leftline,
        backgroundcolor=\color{grigri},
        fillcolor=\color{grigri}}

\lstdefinelanguage{Rust}%
  {
   morekeywords={abstract,alignof,as,become,box,%
                 break,const,continue,crate,do,%
                 else,enum,extern,false,final,%
                 fn,for,if,impl,in,%
                 let,loop,macro,match,mod,%
                 move,mut,offsetof,override,priv,%
                 proc,pub,pure,ref,return,%
                 Self,self,sizeof,static,struct,%
                 super,trait,true,type,typeof,%
                 unsafe,unsized,use,virtual,where,%
                 while,yield},%
   sensitive,%
   morekeywords=[1]{\$},%
   morecomment=[s]{/*}{*/},%
   morecomment=[l]//,%
   morestring=[b]",%
%   morestring=[b]', Unfortunately lifetimes also use this and it
%   breaks
   classoffset=1,
   morekeywords={u8,u16,u32},keywordstyle=\color{blue},
   classoffset=0,
}[keywords,comments,strings]

\lstloadlanguages{[Sharp]C,[x86masm]Assembler,java,PHP,C,Python}

% Change the style of listing numerotation
\AtBeginDocument{\renewcommand{\thelstlisting}{\arabic{lstlisting}}}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Biblio, index and acronyms %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\RequirePackage{makeidx}
\makeindex
\RequirePackage[nolist]{acronym}
\RequirePackage[sort]{cite}


%%%%%%%%
% Misc %
%%%%%%%%
\RequirePackage{alltt}
\RequirePackage{ifthen}
\RequirePackage[hyphens]{url}
\RequirePackage[super]{nth}
\RequirePackage[binary-units=true]{siunitx}


%%%%%%%%%%%%%%%%%%%%%
% Internal commands %
%%%%%%%%%%%%%%%%%%%%%
\newcommand{\myclearpage}{\newpage{\pagestyle{empty}\cleardoublepage}}

\newcommand{\inputarticle}[1]{%
\bgroup
\input{#1/master}
\myclearpage
\egroup
\renewcommand{\thesection}{\arabic{section}}
}




%%%%%%%%%%%%%%%%%
% Stuff to sort %
%%%%%%%%%%%%%%%%%

\def\lastand{\ifnum\value{auco}=2\relax
                \unskip{} \andname\
             \else
                \unskip \lastandname\
             \fi}%
\def\and{\stepcounter{@auth}\relax
         \ifnum\value{@auth}=\value{auco}%
            \lastand
         \else
            \unskip,
         \fi}%

\bibliographystyle{plain}

\sloppy

\endinput
