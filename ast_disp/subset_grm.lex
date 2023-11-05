%{
  #include "y.tab.h"
  #include <stdlib.h>

  #include "token_attribute.h"

%}

%%

// keywords 
"nil"   { return NIL; }
"var"   { return DECLVAR; }
"type"  { return DECLTYP; }
"array of" { return DECLARR; }
"int"   { return TYPINT; }
"float" { return TYPFLOAT; }
"str"   { return TYPSTR; }
"bool"  { return TYPEBOOL; }

"while" { return LOOPCON; }
"do"    { return LOOPBODY; }

"if"    { return JMPCON; }
"then"  { return JMPTRUE; }
"else"  { return JMPFALSE; }
"break" { return BREAK; }


[a-zA-Z][a-zA-Z0-9_]*   { return ID; }
[1-9][0-9]*             { yylval.temp = createtoken_numconst(yytext); return NUMCONST; }
[0-9]+\.[0-9]+          { yylval.temp = createtoken_floatconst(yytext); return FLOATCONST; }
\" [^\"\n] \"           { yylval.temp = createtoken_strconst(yytext);return STRCONST; }

";"                     { return SEMICOLON; }
":"                     { return COLON; }

"("                     { return OBRA; }
")"                     { return CBRA; }
"["                     { return OARRBRA; }
"]"                     { return CARRBRA; }



"+"     { return PLUS; }
"-"     { return MINUS; }
"*"     { return MULT; }
"/"     { return DIVIDE; }
"="     { return EQ; }
"<>"    { return NOTEQ; }
">"     { return GT; }
"<"     { return LT; }
":="    { return ASSIGN; }



\n      ; // Ignore newline characters
[ \t]   ; // Ignore spaces and tabs

.       { fprintf(stderr, "Invalid character: %s\n", yytext); }

%%

int yywrap(void) {
    return 1;
}