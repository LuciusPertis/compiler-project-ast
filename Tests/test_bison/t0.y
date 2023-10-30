%token A
%type <int> GA

%%
GA  :   GA "*" A
    |   A
    ;
%%

int main() {
    yyparse();
    return 0;
}

void yyerror(const char *s) {
    fprintf(stderr, "Parser error: %s\n", s);
}