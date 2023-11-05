#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern char* yytext;

struct atom {
    int symtab_idx;
    char label[30];
    
    union val
    {   
        int ival;
        float fval;
        char sval[30];

    };


};

struct atom* createtoken_numconst(const char* label){
    struct atom* a = (struct atom*) malloc(sizeof(struct atom));
    if (a == NULL){
        printf(">> NO MEMOMRY");
        exit(-1);
    }
    
    a->ival = atoi(yytext);
    strncpy(a->label, label, sizeof(a->label));

    a->symtab_idx = 0;
}

struct atom* createtoken_floatconst(const char* label){
    struct atom* a = (struct atom*) malloc(sizeof(struct atom));
    if (a == NULL){
        printf(">> NO MEMOMRY");
        exit(-1);
    }

    a->fval = atof(yytext);
    strncpy(a->label, label, sizeof(a->label));
    a->symtab_idx = 0;
}

struct atom* createtoken_strconst(const char* label){
    struct atom* a = (struct atom*) malloc(sizeof(struct atom));
    if (a == NULL){
        printf(">> NO MEMOMRY");
        exit(-1);
    }

    strncpy(a->sval,  label, sizeof(a->sval));
    strncpy(a->label, label, sizeof(a->label));

    a->symtab_idx = 0;
}