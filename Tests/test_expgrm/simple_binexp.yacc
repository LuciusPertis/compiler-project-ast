%{
#include <stdio.h>
#include <stdlib.h>
%}

%token PLUS 
%token TIMES
%token LPAREN
%token RPAREN
%token ID

%union {
  int ival;
  char* sval;
}

%type <ival> E
%type <ival> T
%type <ival> F

%%

E : E PLUS T   { printf("E -> E + T\n"); }
  | T
  ;

T : T TIMES F  { printf("T -> T * F\n"); }
  | F
  ;

F : LPAREN E RPAREN  { printf("F -> (E)\n"); }
  | ID               { printf("F -> id\n"); }
  ;

%%

int main() {
    yyparse();
    return 0;
}

void yyerror(const char *s) {
    fprintf(stderr, "Parser error: %s\n", s);
}