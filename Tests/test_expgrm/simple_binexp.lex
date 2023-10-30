%{
  #include "y.tab.h"

  int text2int(const char * yt){
    return 10;
  }
%}

%%

"+"     { return PLUS; }
"*"     { return TIMES; }
"("     { return LPAREN; }
")"     { return RPAREN; }
[0-9]+  { printf("%s\n", text2int(yytext)); return ID; }
\n      ; // Ignore newline characters
[ \t]   ; // Ignore spaces and tabs

.       { fprintf(stderr, "Invalid character: %s\n", yytext); }

%%

int yywrap(void) {
    return 1;
}
