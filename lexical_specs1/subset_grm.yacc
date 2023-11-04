
%token NIL "nil"
%token ID
%token NUMCONST
%token STRCONST
%token SEMICOLON ";"
%token COLON ":"
%token OBRA "(" CBRA ")"
%token OARRBRA  "[" CARRBRA"]"

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
program : chunks exps           /* this forces decl before use */
        ;
chunks  : chunk chunks
        ;
chunk   : tydec
        | vardec
        ;

/* declarations */
vardec  : "var" ID ":=" rvalue
        : "var" ID ":" ty      /* if type is given, init val not required; also array cant be init during decl (we will add a rule for this or init all elems with the rvalue ) */
        : "var" ID ":" ty ":=" rvalue
        ;
tydec   : "type" ID "=" ty
        ;
ty      : type_id
        | "array of" type_id "[" NUMCONST "]"   /* fixed size intro */
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
exp     : lvalue ":=" rvalue    /* Variables assingment */

        | "(" exps ")"          /* block/group expressions */

        | "if"    rvalue "then" exp  ctrl_else     /* Control Flow */
        | "while" rvalue "do"   exp                /* Control Flow */
        | "break"                                   /* Control Flow */
        ;
ctrl_else       : "else" exp                       /* Control Flow */
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
        : ID "[" rvalue "]"
        ;
        

%%

int main() {
    yyparse();
    return 0;
}

void yyerror(const char *s) {
    fprintf(stderr, "Parser error: %s\n", s);
}