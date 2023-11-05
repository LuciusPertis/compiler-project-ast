#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int NO_OF_NODES = 0;

struct ast_lcrs_t{
    struct ast_lcrs * left_child;
    struct ast_lcrs * right_sibling;

    int id;
    char label[30];    
};

typedef struct ast_lcrs_t ast_node_t;

ast_node_t* create_node(ast_node_t* child, ast_node_t* sibling, const char* label){
    ast_node_t* new_node = (ast_node_t*) malloc(sizeof(ast_node_t));
    if (new_node == NULL){
        printf(">> NO MEMOMRY");
        exit(-1);
    }

    NO_OF_NODES +=1 ;
    new_node->id = NO_OF_NODES;
    new_node->left_child = child;
    new_node->right_sibling = sibling;

    strncpy(new_node->label, label, sizeof(new_node->label));

    return new_node;
}

void set_label(ast_node_t* node, const char*  label){
    strncpy(node->label, label, sizeof(node->label));

}