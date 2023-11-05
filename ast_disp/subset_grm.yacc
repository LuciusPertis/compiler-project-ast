%{      
        #include <stdlib.h>
        #include <stdio.h>
        #include <string.h>

        #include "ast.h"        
%}

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


// Non-terminals
%union{
        struct ast_lcrs* node;
}

#define TAC_ASSIGN_CONST(a, c, f)  sprintf(a.code, "%s%d \t := \t f", a.symtab_label, a.symtab_idx, c)
#define TAC_ASSIGN_REGIS(a, b)  sprintf(a.code, "%s%d \t := \t %s%d", a.symtab_label, a.symtab_idx, b.symtab_label, b.symtab_idx)


%start program


%type <node> program
%type <node> chunks 
%type <node> chunk  

%type <node> vardec
%type <node> tydec  
%type <node> ty     
%type <node> type_id

%type <node> exps   
%type <node> exp    
%type <node> rvalue 
%type <node> binops 
%type <node> fexp   
%type <node> texp   
%type <node> lvalue 
%type <node> consts 

%%

/* Program struct */
program : chunks exps           { $2 = create_node(NULL, NULL, "chunks"); $1 = create_node(NULL, $2, "exps"); $$ = create_node($1, NULL, "program");}
        ;
chunks  : chunk chunks          { $2 = create_node(NULL, NULL, "chunks"); $1 = create_node(NULL, $2, "chunk"); $$ = create_node($1, NULL, "chunks");}
        | /* nullable epsillon */
        ;
chunk   : tydec         { $1 = create_node(NULL, NULL, "tydec"); $$}
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
        | "-" texp              {$$.val-=$1.val; }
        ;
binops  : fexp "=" binops
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
texp    : "(" rvalue ")"        {$$.val=$1.val; sprintf($$.code, "%s%d \t := \t %s%d",
                                                        $$.symtab_label, $$.symtab_idx, 
                                                        $1.symtab_label, $1.symtab_idx);}
        | lvalue                {$$.val=$1.val; sprintf($$.code, "%s%d \t := \t %s%d",
                                                        $$.symtab_label, $$.symtab_idx, 
                                                        $1.symtab_label, $1.symtab_idx);}
        | consts                {$$=$1;}
        ;

lvalue  : ID "[" rvalue "]"
        | ID                    { $$=$1; }    
        ;
consts  : NIL                    
        | NUMCONST               { $$.val = $1.val; TAC_ASSIGN($$, $1);}
        | STRCONST               { $$.val = $1.val; TAC_ASSIGN($$, $1);}
        | FLOATCONST             { $$.val = $1.val; TAC_ASSIGN($$, $1);}
        ;
        

%%

int main() {
    yyparse();
    return 0;
}

void yyerror(const char *s) {
    fprintf(stderr, "Parser error: %s\n", s);
}