%{
        #include <stdlib.h>
        #include <stdio.h>
        #include <string.h>

        struct atom {
                const char* code;
                int lencode = 0;
        };

        int concat(const char* s1, const char* s2) { return concat(s1,s2,"", ""); }
        int concat(const char* s1, const char* s2, const char* s3, ) { return concat(s1,s2,s3,""); }
        int concat(const char* s1, const char* s2, const char* s3, const char* s4){
                int len = strlen(s1) + strlen(s2) + strlen(s3) + strlen(s4);

        }

        


%}


#define GC(a,b,c) 

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

}


%%

/* Program struct */
program : chunks exps           /* this forces decl before use */
        ;
chunks  : chunk chunks      /* adding semicolon to bound exp from decl, desperate move */
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
        | "-" texp
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
texp    : "(" rvalue ")"
        | lvalue                {}
        | consts                {}
        ;

lvalue  : ID "[" rvalue "]"     {       $$.temp = newTemp(); 
                                        GC_SIZE_CHK($3.temp.addr, $1.id.size);
                                        GC("acc := t%d + %d", offset, $3.temp.addr, )
                                        GC("t%d := t%d + ", $$.temp.addr, $3.temp.addr);
                                }
        | ID                    { $$=$1; }
        ;
consts  : NIL                    
        | NUMCONST      { $$.temp = newTemp(); GC("t%d := %s", $$.temp.addr, $1.lexem); }             
        | STRCONST      { $$.temp = newTemp(); GC("t%d := %s", $$.temp.addr, $1.lexem); }  
        | FLOATCONST    { $$.temp = newTemp(); GC("t%d := %s", $$.temp.addr, $1.lexem); }  
        ;
        

%%

int main() {
    yyparse();
    return 0;
}

void yyerror(const char *s) {
    fprintf(stderr, "Parser error: %s\n", s);
}