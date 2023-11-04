
%token NIL "nil"
%token ID
%token NUMCONST
%token STRCONST
%token SEMICOLON ";"
%token COLON ":"
%token OBRA "(" CBRA ")" 

%token PLUS "+" MINUS "-" MULT "*" DIVIDE "/" EQ "=" NOTEQ "<>" GT ">" LT "<"
%token ASSIGN ":="

%token DECLVAR "var"
%token DECLTYP "type"
%token DECLARR "array of"
%token TYPINT "int" TYPFLOAT "float" TYPSTR "str" TYPEBOOL "bool"

%token LOOPCON "while" LOOPBODY "do"
%token JMPCON "if" JMPTRUE "then" JMPFALSE "else"
%token BREAK "break"

%left "<>" ">" "<" "="
%left "+" "-"
%left "*" "/" 

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

/* declarations */
vardec  : "var" ID ":=" rvalue
        : "var" ID ":" ty "
        ;
tydec   : "type" ID "=" ty
        ;
ty      : type_id
        | "array of" type_id
        ;
type_id : "int"
        | "str"
        | "bool"
        ;

/* Expressions */
exps    : exp 
        | exp ";" exps  
        |                       /* Nullable */
        ;       
exp     :  lvalue ":=" rvalue    /* Variables */

        | "if"    rvalue "then" exps  ctrl_else     /* Control Flow */
        | "while" rvalue "do"   exps                /* Control Flow */
        | "break"                                   /* Control Flow */
        ;
ctrl_else       : "else" exps                       /* Control Flow */
                | %empty                                                      
        ;

rvalue  : NIL                    /* Literal  */
        | NUMCONST               /* Literals ----- */
        | STRCONST               /* Literals ----- */
        | lvalue
        | binops
        ;
binops  : "-" binops            /* Operations */
        
        | fexp "=" binop
        | fexp "<>"binops 
        | fexp ">" binops
        | fexp "<" binops
        
        | fexp "+" binops
        | fexp "-" binops
        
        | fexp
        ;
fexp    : fexp "*" fexp
        | fexp "/" fexp
        ;
fexp    : "(" rvalue ")"
        | rvalue
        ;

lvalue  : ID 
        ;
        

%%

int main() {
    yyparse();
    return 0;
}

void yyerror(const char *s) {
    fprintf(stderr, "Parser error: %s\n", s);
}