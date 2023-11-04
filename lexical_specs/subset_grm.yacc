
%token NIL "nil"
%token ID
%token INT
%token STR
%token SEMICOLON ";"
%token OBRA "(" CBRA ")" 

%token PLUS "+" MINUS "-" MULT "*" DIVIDE "/" EQ "=" NOTEQ "<>" GT ">" LT "<"
%token ASSIGN ":="

%token DECLVAR "var"
%token DECLTYP "type"

%token LOOPCON "while" LOOPBODY "do"
%token JMPCON "if" JMPTRUE "then" JMPFALSE "else"
%token BREAK "break"

%%

/* Program struct */
program : exp
        | chunks
        ;
chunks  : chunk chunks
        ;
chunk   : tydec chunk
        | vardec
        ;

/* Expressions */
exps    : exp { ";" exp } 
        |                   /* Nullable */
        ;
exp     : NIL         
        | INT           /* Literals ----- */
        | STR           /* Literals ----- */
        
        | lvalue        /* Variables, field, elements of an array. */
        | lvalue ":=" exp

        | "-" exp       /* Operations --- */
        | exp op exp    /* Operations --- */
        | "(" exps ")"  /* Operations --- */

        | "if" exp "then" exp ctrl_else      /* Control Flow */
        | "while" exp "do" exp                  /* Control Flow */
        | "break"                                 /* Control Flow */
        ;
ctrl_else : "else" exp
        |               /* Nullable */
        ;
lvalue  : ID 
        ;
op      : "+" | "-" | "*" | "/" | "=" | "<>" | ">" | "<"       /* no boolean ops */
        ;

/* declarations */
vardec  : "var" ID ":=" exp
        ;
tydec   : "type" ID "=" ty
        ;
ty      : type_id
        ;
type_id : ID
        ;

%%

int main() {
    yyparse();
    return 0;
}

void yyerror(const char *s) {
    fprintf(stderr, "Parser error: %s\n", s);
}