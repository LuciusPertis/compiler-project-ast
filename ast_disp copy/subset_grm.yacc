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
        struct 
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
vardec  : "var" ID ":=" rvalue  { $$.val = }
        | "var" ID ":" ty      
        | "var" ID ":" ty ":=" rvalue
        ;
tydec   : "type" ID ":=" ty     { $2.addr=create_type($2.lexeme, $4); free($2); }
        ;
ty      : type_id       { $$=$1; }
        | "array of" type_id "[" NUMCONST "]"   
                        { if ($4.ival < 1) yyerror(); $$=create_array_type($2, $4.ival); }
        | ID            { $$=lookup_type($1.lexeme); }
        ;
type_id : "int"    { $$=$1; if(lookup_("type", $1.lexeme)=NULL) lookup_add("type", $1.lexeme, $1);  }/*init in LEX:offset,memsize */        
        | "str"    { $$=$1; if(lookup_("type", $1.lexeme)=NULL) lookup_add("type", $1.lexeme, $1);  }/*init in LEX:offset,memsize */        
        | "bool"   { $$=$1; if(lookup_("type", $1.lexeme)=NULL) lookup_add("type", $1.lexeme, $1);  }/*init in LEX:offset,memsize */
        | "float"  { $$=$1; if(lookup_("type", $1.lexeme)=NULL) lookup_add("type", $1.lexeme, $1);  }/*init in LEX:offset,memsize */
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

rvalue  : binops                {$1 = newTemp(); $1}
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