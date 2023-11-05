
%token NIL "nil"
%token ID
%token NUMCONST
%token STRCONST
%token FLOATCONST
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

%right "then" "else" // Same precedence, but "shift" wins.

%%

/* Program struct */
program : chunks exps           /* this forces decl before use */
        ;
chunks  : chunk ";" chunks      /* adding semicolon to bound exp from decl, desperate move */
        | /* nullable epsillon */
        ;
chunk   : tydec
        | vardec
        ;

/* declarations */
vardec  : "var" ID ":=" rvalue 
        | "var" ID ":" ty      /* if type is given, init val not required; also array cant be init during decl (we will add a rule for this or init all elems with the rvalue ) */
        | "var" ID ":" ty ":=" rvalue
        ;
tydec   : "type" ID "=" ty      /* if records are not there this is basically allias */
        ;
ty      : type_id
        | "array of" type_id "[" NUMCONST "]"   /* fixed size intro */
        | ID    /* already declared types */
        ;
type_id : "int"
        | "str"
        | "bool"
        | "float"
        ;

/* Expressions */
exps    : exp 
        | exp ";" exps  
        |                       /* Nullable */
        ;       
exp     : lvalue ":=" rvalue    /* Variables assingment */

        | "(" exps ")"          /* block/group expressions */

        | "if"    rvalue "then" exp  
        | "if"    rvalue "then" exp  "else" exp     /* Control Flow */
        | "while" rvalue "do"   exp                /* Control Flow */
        | "break"                                   /* Control Flow */
        ;

rvalue  : binops
        | texp
        ;
binops  : "-" binops            /* Operations */
        
        | fexp "=" binops
        | fexp "<>"binops 
        | fexp ">" binops
        | fexp "<" binops
        
        | fexp "+" binops
        | fexp "-" binops
        
        | fexp
        ;
fexp    : texp "*" fexp
        | texp "/" fexp
        | texp "*" texp
        | texp "/" texp
        ;
texp    : "(" rvalue ")"
        | lvalue
        | consts
        ;

lvalue  : ID "[" rvalue "]"
        | ID 
        ;
consts  : NIL                    /* Literal  */
        | NUMCONST               /* Literals ----- */
        | STRCONST               /* Literals ----- */
        | FLOATCONST
        ;
        

%%

int main() {
    yyparse();
    return 0;
}

void yyerror(const char *s) {
    fprintf(stderr, "Parser error: %s\n", s);
}