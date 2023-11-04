%{
  #include "y.tab.h"
  #include <stdlib.h>

%}

%%

"nil"                   { return NIL; }

[a-zA-Z][a-zA-Z0-9_]*   { return ID; }
[1-9][0-9]*             { return NUMCONST; }
\" [^\"\n] \"           { return STRCONST; }

";"                     { return SEMICOLON; }

"("                     { return OBRA; }
")"                     { return CBRA; }


"+"     { return PLUS; }
"-"     { return MINUS; }
"*"     { return MULT; }
"/"     { return DIVIDE; }
"="     { return EQ; }
"<>"    { return NOTEQ; }
">"     { retunr GT; }
"<"     { return LT; }
":="    { return ASSIGN; }

"var"   { return DECLVAR; }
"type"  { return DECLTYP; }

"while" { return LOOPCON; }
"do"    { return LOOPBODY; }

"if"    { return JMPCON; }
"then"  { return JMPTRUE; }
"else"  { return JMPFALSE; }
"break" { return BREAK; }

\n      ; // Ignore newline characters
[ \t]   ; // Ignore spaces and tabs

.       { fprintf(stderr, "Invalid character: %s\n", yytext); }

%%

int yywrap(void) {
    return 1;
}