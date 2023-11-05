#ifndef AST_H
#define AST_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct ast_lcrs_t{
    struct ast_lcrs * left_child;
    struct ast_lcrs * right_sibling;

    int id;
    char label[30];    
};

typedef struct ast_lcrs_t ast_node_t;

ast_lcrs_t* PROGRAM_HEAD;
int NO_OF_NODES;

ast_node_t* create_node(ast_node_t* child, ast_node_t* sibling, const char* label);
void set_label(ast_node_t* node, const char*  label);

#endif