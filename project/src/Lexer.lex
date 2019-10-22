/* --------------------------Usercode Section------------------------ */

import java_cup.runtime.*;
 
%%

/* -----------------Options and Declarations Section----------------- */ 

%class Lexer
%line
%unicode
%column
%cup

%{
  private Symbol symbol(int type) {
    return new Symbol(type, yyline, yycolumn);
  }
%}

LineTerminator   = \r|\n|\r\n
WhiteSpace       = {LineTerminator} | [ \t\f]
Comment          = "#".*
MultiLineComment = "/#"[^#]*"#/"
WordCharacter    = [_a-zA-Z0-9]
Identifier       = [a-zA-Z]{WordCharacter}*
SecurityLabel    = [HL]
Punctuation      = "."|"\""|"$"|"\\"|"["|"]"|"("|")"|"{"|"}"|"+"|"*"|"'"|"?"|"!"|"#"|"%"|"@"|"&"|","|":"|";"|"="|"/"|"<"|">"|"`"|"~"|"^"|"-"|" "
OCharacter       = {WordCharacter}|{Punctuation}
Character	 = \'{OCharacter}\'
Boolean          = [TF]
Integer          = 0|[1-9][0-9]*
Rational         = ({Integer}"_")?{Integer}"/"{Integer}
Float            = {Integer}"."{Integer}
String           = \"{OCharacter}*\"
PrimitiveType	 = "bool"|"int"|"char"|"rat"|"float"
Literal		 = {Character}|{Boolean}|{Integer}|{Rational}|{Float}|{String}        

%%

/* ------------------------Lexical Rules Section---------------------- */

<YYINITIAL> {

  /* comments */
  {Comment}                  { /* ignore */ }
  {MultiLineComment}         { /* ignore */ }

  /* whitespace */
  {WhiteSpace}               { /* ignore */ }

  /* security label */
  {SecurityLabel}	     { return symbol(sym.LABEL); }
     
  /* literals */
  {Literal}		     { return symbol(sym.LITERAL); }

  /* separators */
  ":"		             { return symbol(sym.COLON); }
  "["			     { return symbol(sym.LBRACKET); }
  "]"			     { return symbol(sym.RBRACKET); }
  "{"			     { return symbol(sym.LBRACE); }
  "}"			     { return symbol(sym.RBRACE); }
  "("			     { return symbol(sym.LPAREN); }
  ")"			     { return symbol(sym.RPAREN); }
  ","			     { return symbol(sym.COMMA); }
  ";"			     { return symbol(sym.SEMI); }

  /* operators */
  "."                        { return symbol(sym.DOT); }
  "!="                       { return symbol(sym.NOTEQ); }
  "="			     { return symbol(sym.EQ); }
  "<"			     { return symbol(sym.LE); }
  ">"			     { return symbol(sym.GRE); }
  "<="                       { return symbol(sym.LEQ); }
  "+"                        { return symbol(sym.PLUS); }
  "-"			     { return symbol(sym.MINUS); }
  "*"			     { return symbol(sym.MULT); }
  "/"			     { return symbol(sym.DIV); }
  "^"			     { return symbol(sym.XOR); }
  "!"			     { return symbol(sym.NOT); }
  "&&"			     { return symbol(sym.AND); }
  "||"			     { return symbol(sym.OR); }
  "in"			     { return symbol(sym.IN); }
  "::"			     { return symbol(sym.CONS); }

  /* assignment */
  ":="			     { return symbol(sym.ASSIGNMENT); }

  /* keywords */
  "main"                     { return symbol(sym.MAIN); }
  "alias"		     { return symbol(sym.ALIAS); }
  "tdef"		     { return symbol(sym.TDEF); }
  "fdef"		     { return symbol(sym.FDEF); }
  "top"		             { return symbol(sym.TOP); }
  {PrimitiveType}	     { return symbol(sym.PDT); }
  "seq"			     { return symbol(sym.SEQ); }
  "if"			     { return symbol(sym.IF); }
  "fi"			     { return symbol(sym.FI); }
  "then"		     { return symbol(sym.THEN); }
  "else"		     { return symbol(sym.ELSE); }
  "break"		     { return symbol(sym.BREAK); }
  "loop"		     { return symbol(sym.LOOP); }
  "pool"		     { return symbol(sym.POOL); }
  "read"		     { return symbol(sym.READ); }
  "print"		     { return symbol(sym.PRINT); }
  "return"		     { return symbol(sym.RETURN); }

  /* identifiers */
  {Identifier}               { return symbol(sym.ID); }
}

/* error fallback */
[^]                          {return symbol(sym.BADCHAR);}
