%{
  #include "y.tab.h"
  #include <stdlib.h>

%}

%%

"+"     { return PLUS; }
"*"     { return TIMES; }
"("     { return LPAREN; }
")"     { return RPAREN; }
[0-9]+  { printf("id :: %d\n", atoi(yytext)); yylval.ival=atoi(yytext); return ID; }
\n      ; // Ignore newline characters
[ \t]   ; // Ignore spaces and tabs

.       { fprintf(stderr, "Invalid character: %s\n", yytext); }

%%

int yywrap(void) {
    return 1;
}
