" Vim syntax file
" Language:	NXC
" Maintainer:	Anthony Mendez <dexteralm@yahoo.com>
" Last Change:	June 22 2008

" Quit when a (custom) syntax file was already loaded
if exists("b:current_syntax")
  finish
endif


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"  _   ___  ______   _  __                                _     
" | \ | \ \/ / ___| | |/ /___ _   ___      _____  _ __ __| |___ 
" |  \| |\  / |     | ' // _ \ | | \ \ /\ / / _ \| '__/ _` / __|
" | |\  |/  \ |___  | . \  __/ |_| |\ V  V / (_) | | | (_| \__ \
" |_| \_/_/\_\____| |_|\_\___|\__, | \_/\_/ \___/|_|  \__,_|___/
"                             |___/                             
"  ____        __ _                _ 
" |  _ \  ___ / _(_)_ __   ___  __| |
" | | | |/ _ \ |_| | '_ \ / _ \/ _` |
" | |_| |  __/  _| | | | |  __/ (_| |
" |____/ \___|_| |_|_| |_|\___|\__,_|
" 
" API not defined. May do it later if it feels necessary.
" Not Defined (Not sure where/how to implement them)
" 	abs 		(works like a function, no need for special highlighting)
" 	sign		(works like a function, no need for special highlighting)
" 	safecall 	(unsure what it does)
" 	sub		(unsure what it does)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
                                   
"VARIABLE TYPES
syn keyword	cType		bool byte char int short long mutex unsigned string void
syn keyword	cType		task
syn keyword 	cConstant 	true false

syn keyword	cStructure	struct typedef asm
syn keyword	cStorageClass	const inline

"USED IN NBC ASSEMBLY
syn keyword	cConstant 	__RETURN__ __RETVAL__ __STRRETVAL__ __TMPBYTE__ __TMPWORD__ __TMPLONG__

" A bunch of useful C keywords
syn keyword	cStatement	goto break return continue 
syn keyword	cLabel		case default priority start stop
syn keyword	cConditional	if else switch
syn keyword	cRepeat		while for do repeat until


" cCommentGroup allows adding matches for special things in comments
syn keyword	cTodo		contained TODO FIXME XXX
syn cluster	cCommentGroup	contains=cTodo


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"   ___       _                   _    ____    ____          _      
"  / _ \ _ __(_) __ _ _ __   __ _| |  / ___|  / ___|___   __| | ___ 
" | | | | '__| |/ _` | '_ \ / _` | | | |     | |   / _ \ / _` |/ _ \
" | |_| | |  | | (_| | | | | (_| | | | |___  | |__| (_) | (_| |  __/
"  \___/|_|  |_|\__, |_| |_|\__,_|_|  \____|  \____\___/ \__,_|\___|
"               |___/                                               
"  ____       _               
" | __ )  ___| | _____      __
" |  _ \ / _ \ |/ _ \ \ /\ / /
" | |_) |  __/ | (_) \ V  V / 
" |____/ \___|_|\___/ \_/\_/  
" 
" Removed Conflicting Definitions
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" String and Character constants
" Highlight special characters (those which have a backslash) differently
syn match	cSpecial	display contained "\\\(x\x\+\|\o\{1,3}\|.\|$\)"
if !exists("c_no_utf")
  syn match	cSpecial	display contained "\\\(u\x\{4}\|U\x\{8}\)"
endif
if exists("c_no_cformat")
  syn region	cString		start=+L\="+ skip=+\\\\\|\\"+ end=+"+ contains=cSpecial,@Spell
  " cCppString: same as cString, but ends at end of line
  syn region	cCppString	start=+L\="+ skip=+\\\\\|\\"\|\\$+ excludenl end=+"+ end='$' contains=cSpecial,@Spell
else
  if !exists("c_no_c99") " ISO C99
    syn match	cFormat		display "%\(\d\+\$\)\=[-+' #0*]*\(\d*\|\*\|\*\d\+\$\)\(\.\(\d*\|\*\|\*\d\+\$\)\)\=\([hlLjzt]\|ll\|hh\)\=\([aAbdiuoxXDOUfFeEgGcCsSpn]\|\[\^\=.[^]]*\]\)" contained
  else
    syn match	cFormat		display "%\(\d\+\$\)\=[-+' #0*]*\(\d*\|\*\|\*\d\+\$\)\(\.\(\d*\|\*\|\*\d\+\$\)\)\=\([hlL]\|ll\)\=\([bdiuoxXDOUfeEgGcCsSpn]\|\[\^\=.[^]]*\]\)" contained
  endif
  syn match	cFormat		display "%%" contained
  syn region	cString		start=+L\="+ skip=+\\\\\|\\"+ end=+"+ contains=cSpecial,cFormat,@Spell
  " cCppString: same as cString, but ends at end of line
  syn region	cCppString	start=+L\="+ skip=+\\\\\|\\"\|\\$+ excludenl end=+"+ end='$' contains=cSpecial,cFormat,@Spell
endif

syn match	cCharacter	"L\='[^\\]'"
syn match	cCharacter	"L'[^']*'" contains=cSpecial
if exists("c_gnu")
  syn match	cSpecialError	"L\='\\[^'\"?\\abefnrtv]'"
  syn match	cSpecialCharacter "L\='\\['\"?\\abefnrtv]'"
else
  syn match	cSpecialError	"L\='\\[^'\"?\\abfnrtv]'"
  syn match	cSpecialCharacter "L\='\\['\"?\\abfnrtv]'"
endif
syn match	cSpecialCharacter display "L\='\\\o\{1,3}'"
syn match	cSpecialCharacter display "'\\x\x\{1,2}'"
syn match	cSpecialCharacter display "L'\\x\x\+'"

"bwhen wanted, highlight trailing white space
if exists("c_space_errors")
  if !exists("c_no_trail_space_error")
    syn match	cSpaceError	display excludenl "\s\+$"
  endif
  if !exists("c_no_tab_space_error")
    syn match	cSpaceError	display " \+\t"me=e-1
  endif
endif

" This should be before cErrInParen to avoid problems with #define ({ xxx })
syntax region	cBlock		start="{" end="}" transparent fold

"catch errors caused by wrong parenthesis and brackets
" also accept <% for {, %> for }, <: for [ and :> for ] (C99)
" But avoid matching <::.
syn cluster	cParenGroup	contains=cParenError,cIncluded,cSpecial,cCommentSkip,cCommentString,cComment2String,@cCommentGroup,cCommentStartError,cUserCont,cUserLabel,cBitField,cCommentSkip,cOctalZero,cCppOut,cCppOut2,cCppSkip,cFormat,cNumber,cFloat,cOctal,cOctalError,cNumbersCom
if exists("c_no_curly_error")
  syn region	cParen		transparent start='(' end=')' contains=ALLBUT,@cParenGroup,cCppParen,cCppString,@Spell
  " cCppParen: same as cParen but ends at end-of-line; used in cDefine
  syn region	cCppParen	transparent start='(' skip='\\$' excludenl end=')' end='$' contained contains=ALLBUT,@cParenGroup,cParen,cString,@Spell
  syn match	cParenError	display ")"
  syn match	cErrInParen	display contained "^[{}]\|^<%\|^%>"
elseif exists("c_no_bracket_error")
  syn region	cParen		transparent start='(' end=')' contains=ALLBUT,@cParenGroup,cCppParen,cCppString,@Spell
  " cCppParen: same as cParen but ends at end-of-line; used in cDefine
  syn region	cCppParen	transparent start='(' skip='\\$' excludenl end=')' end='$' contained contains=ALLBUT,@cParenGroup,cParen,cString,@Spell
  syn match	cParenError	display ")"
  syn match	cErrInParen	display contained "[{}]\|<%\|%>"
else
  syn region	cParen		transparent start='(' end=')' contains=ALLBUT,@cParenGroup,cCppParen,cErrInBracket,cCppBracket,cCppString,@Spell
  " cCppParen: same as cParen but ends at end-of-line; used in cDefine
  syn region	cCppParen	transparent start='(' skip='\\$' excludenl end=')' end='$' contained contains=ALLBUT,@cParenGroup,cErrInBracket,cParen,cBracket,cString,@Spell
  syn match	cParenError	display "[\])]"
  syn match	cErrInParen	display contained "[\]{}]\|<%\|%>"
  syn region	cBracket	transparent start='\[\|<::\@!' end=']\|:>' contains=ALLBUT,@cParenGroup,cErrInParen,cCppParen,cCppBracket,cCppString,@Spell
  " cCppBracket: same as cParen but ends at end-of-line; used in cDefine
  syn region	cCppBracket	transparent start='\[\|<::\@!' skip='\\$' excludenl end=']\|:>' end='$' contained contains=ALLBUT,@cParenGroup,cErrInParen,cParen,cBracket,cString,@Spell
  syn match	cErrInBracket	display contained "[);{}]\|<%\|%>"
endif

"integer number, or floating point number without a dot and with "f".
syn case ignore
syn match	cNumbers	display transparent "\<\d\|\.\d" contains=cNumber,cFloat,cOctalError,cOctal
" Same, but without octal error (for comments)
syn match	cNumbersCom	display contained transparent "\<\d\|\.\d" contains=cNumber,cFloat,cOctal
syn match	cNumber		display contained "\d\+\(u\=l\{0,2}\|ll\=u\)\>"
"hex number
syn match	cNumber		display contained "0x\x\+\(u\=l\{0,2}\|ll\=u\)\>"
" Flag the first zero of an octal number as something special
syn match	cOctal		display contained "0\o\+\(u\=l\{0,2}\|ll\=u\)\>" contains=cOctalZero
syn match	cOctalZero	display contained "\<0"
syn match	cFloat		display contained "\d\+f"
"floating point number, with dot, optional exponent
syn match	cFloat		display contained "\d\+\.\d*\(e[-+]\=\d\+\)\=[fl]\="
"floating point number, starting with a dot, optional exponent
syn match	cFloat		display contained "\.\d\+\(e[-+]\=\d\+\)\=[fl]\=\>"
"floating point number, without dot, with exponent
syn match	cFloat		display contained "\d\+e[-+]\=\d\+[fl]\=\>"
if !exists("c_no_c99")
  "hexadecimal floating point number, optional leading digits, with dot, with exponent
  syn match	cFloat		display contained "0x\x*\.\x\+p[-+]\=\d\+[fl]\=\>"
  "hexadecimal floating point number, with leading digits, optional dot, with exponent
  syn match	cFloat		display contained "0x\x\+\.\=p[-+]\=\d\+[fl]\=\>"
endif

" flag an octal number with wrong digits
syn match	cOctalError	display contained "0\o*[89]\d*"
syn case match

if exists("c_comment_strings")
  " A comment can contain cString, cCharacter and cNumber.
  " But a "*/" inside a cString in a cComment DOES end the comment!  So we
  " need to use a special type of cString: cCommentString, which also ends on
  " "*/", and sees a "*" at the start of the line as comment again.
  " Unfortunately this doesn't very well work for // type of comments :-(
  syntax match	cCommentSkip	contained "^\s*\*\($\|\s\+\)"
  syntax region cCommentString	contained start=+L\=\\\@<!"+ skip=+\\\\\|\\"+ end=+"+ end=+\*/+me=s-1 contains=cSpecial,cCommentSkip
  syntax region cComment2String	contained start=+L\=\\\@<!"+ skip=+\\\\\|\\"+ end=+"+ end="$" contains=cSpecial
  syntax region  cCommentL	start="//" skip="\\$" end="$" keepend contains=@cCommentGroup,cComment2String,cCharacter,cNumbersCom,cSpaceError,@Spell
  if exists("c_no_comment_fold")
    " Use "extend" here to have preprocessor lines not terminate halfway a
    " comment.
    syntax region cComment	matchgroup=cCommentStart start="/\*" end="\*/" contains=@cCommentGroup,cCommentStartError,cCommentString,cCharacter,cNumbersCom,cSpaceError,@Spell extend
  else
    syntax region cComment	matchgroup=cCommentStart start="/\*" end="\*/" contains=@cCommentGroup,cCommentStartError,cCommentString,cCharacter,cNumbersCom,cSpaceError,@Spell fold extend
  endif
else
  syn region	cCommentL	start="//" skip="\\$" end="$" keepend contains=@cCommentGroup,cSpaceError,@Spell
  if exists("c_no_comment_fold")
    syn region	cComment	matchgroup=cCommentStart start="/\*" end="\*/" contains=@cCommentGroup,cCommentStartError,cSpaceError,@Spell
  else
    syn region	cComment	matchgroup=cCommentStart start="/\*" end="\*/" contains=@cCommentGroup,cCommentStartError,cSpaceError,@Spell fold
  endif
endif
"
" keep a // comment separately, it terminates a preproc. conditional
syntax match	cCommentError	display "\*/"
syntax match	cCommentStartError display "/\*"me=e-1 contained




" Accept %: for # (C99)
syn region	cPreCondit	start="^\s*\(%:\|#\)\s*\(if\|ifdef\|ifndef\|elif\)\>" skip="\\$" end="$" end="//"me=s-1 contains=cComment,cCppString,cCharacter,cCppParen,cParenError,cNumbers,cCommentError,cSpaceError
syn match	cPreCondit	display "^\s*\(%:\|#\)\s*\(else\|endif\)\>"
if !exists("c_no_if0")
  if !exists("c_no_if0_fold")
    syn region	cCppOut		start="^\s*\(%:\|#\)\s*if\s\+0\+\>" end=".\@=\|$" contains=cCppOut2 fold
  else
    syn region	cCppOut		start="^\s*\(%:\|#\)\s*if\s\+0\+\>" end=".\@=\|$" contains=cCppOut2
  endif
  syn region	cCppOut2	contained start="0" end="^\s*\(%:\|#\)\s*\(endif\>\|else\>\|elif\>\)" contains=cSpaceError,cCppSkip
  syn region	cCppSkip	contained start="^\s*\(%:\|#\)\s*\(if\>\|ifdef\>\|ifndef\>\)" skip="\\$" end="^\s*\(%:\|#\)\s*endif\>" contains=cSpaceError,cCppSkip
endif
syn region	cIncluded	display contained start=+"+ skip=+\\\\\|\\"+ end=+"+
syn match	cIncluded	display contained "<[^>]*>"
syn match	cInclude	display "^\s*\(%:\|#\)\s*include\>\s*["<]" contains=cIncluded
"syn match cLineSkip	"\\$"
syn cluster	cPreProcGroup	contains=cPreCondit,cIncluded,cInclude,cDefine,cErrInParen,cErrInBracket,cUserLabel,cSpecial,cOctalZero,cCppOut,cCppOut2,cCppSkip,cFormat,cNumber,cFloat,cOctal,cOctalError,cNumbersCom,cString,cCommentSkip,cCommentString,cComment2String,@cCommentGroup,cCommentStartError,cParen,cBracket,cMulti
syn region	cDefine		start="^\s*\(%:\|#\)\s*\(define\|undef\)\>" skip="\\$" end="$" end="//"me=s-1 keepend contains=ALLBUT,@cPreProcGroup,@Spell
syn region	cPreProc	start="^\s*\(%:\|#\)\s*\(pragma\>\|line\>\|warning\>\|warn\>\|error\>\)" skip="\\$" end="$" keepend contains=ALLBUT,@cPreProcGroup,@Spell

" Highlight User Labels
syn cluster	cMultiGroup	contains=cIncluded,cSpecial,cCommentSkip,cCommentString,cComment2String,@cCommentGroup,cCommentStartError,cUserCont,cUserLabel,cBitField,cOctalZero,cCppOut,cCppOut2,cCppSkip,cFormat,cNumber,cFloat,cOctal,cOctalError,cNumbersCom,cCppParen,cCppBracket,cCppString
syn region	cMulti		transparent start='?' skip='::' end=':' contains=ALLBUT,@cMultiGroup,@Spell
" Avoid matching foo::bar() in C++ by requiring that the next char is not ':'
syn cluster	cLabelGroup	contains=cUserLabel
syn match	cUserCont	display "^\s*\I\i*\s*:$" contains=@cLabelGroup
syn match	cUserCont	display ";\s*\I\i*\s*:$" contains=@cLabelGroup
syn match	cUserCont	display "^\s*\I\i*\s*:[^:]"me=e-1 contains=@cLabelGroup
syn match	cUserCont	display ";\s*\I\i*\s*:[^:]"me=e-1 contains=@cLabelGroup

syn match	cUserLabel	display "\I\i*" contained

" Avoid recognizing most bitfields as labels
syn match	cBitField	display "^\s*\I\i*\s*:\s*[1-9]"me=e-1 contains=cType
syn match	cBitField	display ";\s*\I\i*\s*:\s*[1-9]"me=e-1 contains=cType

if exists("c_minlines")
  let b:c_minlines = c_minlines
else
  if !exists("c_no_if0")
    let b:c_minlines = 50	" #if 0 constructs can be long
  else
    let b:c_minlines = 15	" mostly for () constructs
  endif
endif
exec "syn sync ccomment cComment minlines=" . b:c_minlines

" Define the default highlighting.
" Only used when an item doesn't have highlighting yet
hi def link cFormat		cSpecial
hi def link cCppString		cString
hi def link cCommentL		cComment
hi def link cCommentStart	cComment
hi def link cLabel		Label
hi def link cUserLabel		Label
hi def link cConditional	Conditional
hi def link cRepeat		Repeat
hi def link cCharacter		Character
hi def link cSpecialCharacter	cSpecial
hi def link cNumber		Number
hi def link cOctal		Number
hi def link cOctalZero		PreProc	 " link this to Error if you want
hi def link cFloat		Float
hi def link cOctalError		cError
hi def link cParenError		cError
hi def link cErrInParen		cError
hi def link cErrInBracket	cError
hi def link cCommentError	cError
hi def link cCommentStartError	cError
hi def link cSpaceError		cError
hi def link cSpecialError	cError
hi def link cOperator		Operator
hi def link cStructure		Structure
hi def link cStorageClass	StorageClass
hi def link cInclude		Include
hi def link cPreProc		PreProc
hi def link cDefine		Macro
hi def link cIncluded		cString
hi def link cError		Error
hi def link cStatement		Statement
hi def link cPreCondit		PreCondit
hi def link cType		Type
hi def link cConstant		Constant
hi def link cCommentString	cString
hi def link cComment2String	cString
hi def link cCommentSkip	cComment
hi def link cString		String
hi def link cComment		Comment
hi def link cSpecial		SpecialChar
hi def link cTodo		Todo
hi def link cCppSkip		cCppOut
hi def link cCppOut2		cCppOut
hi def link cCppOut		Comment

let b:current_syntax = "NXC"

" vim: ts=8
