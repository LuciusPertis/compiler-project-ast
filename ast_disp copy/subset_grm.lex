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
"int"   { long attr1_addr = symtab_add("TYPINT.1.offset", "4"); symtab_add("TYPINT.2.memsize", "1"); 
          yylval = symtab_create_obj("TYPINT", 2, attr1_addr); yylval.lexem = "TYPINT" return TYPINT;    }
"float" { long attr1_addr = symtab_add("TYPFLOAT.1.offset", "8"); symtab_add("TYPFLOAT.2.memsize", "1"); 
          yylval = symtab_create_obj("TYPFLOAT", 2, attr1_addr); yylval.lexem = "TYPFLOAT" return TYPFLOAT;  }
"str"   { long attr1_addr = symtab_add("TYPSTR.1.offset", "1"); symtab_add("TYPSTR.2.memsize", "30"); 
          yylval = symtab_create_obj("TYPSTR", 2, attr1_addr); yylval.lexem = "TYPSTR" return TYPSTR;    }
"bool"  { long attr1_addr = symtab_add("TYPBOOL.1.offset", "1"); symtab_add("TYPBOOL.2.memsize", "1"); 
          yylval = symtab_create_obj("TYPBOOL", 2, attr1_addr); yylval.lexem = "TYPBOOL" return TYPBOOL;  }

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