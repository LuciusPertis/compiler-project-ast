%{
    #define PLUS    90
    #define MINUS   91
    #define TIMES   92
    #define DIVIDE  93
    #define EQ      94

    #define ASSIGN  95
    #define LPAREN  96
    #define RPAREN  97

    

%}

%%
[ ]
[\t\f\v\r\n]    /* Ignore white space */
"/*".*?"*/"    /* Ignore comments */

"+"             { return PLUS; }
"-"             { return MINUS; }
"*"             { return TIMES; }
"/"             { return DIVIDE; }
"="             { return EQ; }
":="            { return ASSIGN; }

"("             { return LPAREN; }
")"             { return RPAREN; }

[0-9]+          { yylval.integer = atoi(yytext); return INT; }
[a-zA-Z][_a-zA-Z0-9]* { yylval.string = strdup(yytext); return ID; }

.               { /* Catch-all for unrecognized characters */ }

%%

int yywrap() {
    return 1;
}
