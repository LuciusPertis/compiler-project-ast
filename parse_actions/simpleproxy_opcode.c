#include <stdio.h>
#include <stdlib.h>

extern char * yytext;

union val{
    int ival;
    float fval;
    enum bool bval;
    const char* sval; 
};

#define MEMSIZE 1000

union val* PRGMEM[MEMSIZE] = {NULL};


enum bool{
    true,
    flase
};
enum types {
    NIL,
    NUMCONST,
    STRCONST,
    FLOATCONST,
    TYPINT,
    TYPFLOAT,
    TYPSTR,
    TYPEBOOL,
    TYPINT_ARR,
    TYPFLOAT_ARR,
    TYPSTR_ARR,
    TYPEBOOL_ARR,
};

struct Atom
{
    const char * lex;
    
    int typ_size;
    int memlength;
    enum types typ_label;

    int memaddr;
    int symlabel;
};

int MEMLOC = 0;


int newtemploc(){
    MEMLOC += 1;
    return MEMLOC;
}

struct atom* newConst(enum types t, char* lex){
    struct Atom* a = (struct Atom*)malloc(sizeof(struct Atom));

    if (a == NULL) {
        printf("Memory allocation failed.\n");
        return 1;
    }

    switch(t){
        case NIL:
            free(a);
            return NULL;
            break;
        case NUMCONST:
            a->lex = lex; a->typ_label = NUMCONST;
            a->ival = atoi(lex);
            a->memlength = 1;
            a->typ_size = 4;

            break;
        case STRCONST:
            break;
        case FLOATCONST:
            break;
        case TYPINT:
            break;
        case TYPFLOAT:
            break;
        case TYPSTR:
            break;
        case TYPEBOOL:
            break;
        case TYPINT_ARR:
            break;
        case TYPFLOAT_ARR:
            break;
        case TYPSTR_ARR:
            break;
        case TYPEBOOL_ARR:

    }
}

void proxyprint_const(int type){
    printf("tmp:%d = %s", newtemploc(), yytext);
}