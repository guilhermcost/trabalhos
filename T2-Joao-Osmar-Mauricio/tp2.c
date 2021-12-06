
#include <stdio.h>
#include <stdlib.h>
#include "ast.h"



#include "c-v1.1.tab.h"



extern struct decl *parser_result;

void prettyprint_stmt(struct stmt *t, int level);
void prettyprint_func(struct decl *f, int level);
void prettyprint_expr(struct expr *e, int level);

void print_ident(int level);

void prettyprint_name(char *name) {
    printf("[%s]", name);
};

void print_ident(int level) {
    int i = 0;
    while (i < level) {
        printf("  ");
        i++;
    }
};

void prettyprint_type(struct type *type) {
  struct type *t = type;
  if (t) {
    switch(t->kind) {
        case TYPE_VOID: {
            printf("[void]");
            break;
        }
        case TYPE_INTEGER: {
            printf("[int]");
            break;
        }
        case TYPE_ARRAY: {
            if (t->subtype)
                prettyprint_type(t->subtype);
            break;
        }
        case TYPE_FUNCTION: {
            if (t->subtype)
                prettyprint_type(t->subtype);
            break;
        }
        default: break;
     }
   }
}

void prettyprint_params(struct param_list *pl, int level){
    struct param_list *p = pl;
    while (p) {
        printf("\n");
        print_ident(level);
        printf("[param ");
        prettyprint_type(p->type);
        printf("[%s]",p->name);
        printf("]");
        p = p->next;
    }
}


void prettyprint_var(struct decl *var, int level) {
    if(var->expr==0){
        printf("\n");
        print_ident(level);
    	printf("[var-declaration ");
    	prettyprint_type(var->type);
    	prettyprint_name(var->name);
    }else if(var->expr!=0){
        printf("\n");
        print_ident(level);
    	printf("[const-declaration ");
    	prettyprint_type(var->type);
    	prettyprint_name(var->name);
    	prettyprint_expr(var->expr, level++);
    }
    printf("]");
}

void prettyprint_array(struct decl *array, int level) {
    printf("\n");
    print_ident(level);
    printf("[var-declaration ");
    struct type *t = array->type;
    prettyprint_type(array->type);
    prettyprint_name(array->name);
    prettyprint_expr(array->expr, level++);
    printf("]");
}

void prettyprint_func(struct decl *func, int level) {
    printf("\n");
    print_ident(level);
    printf("[func-declaration \n");
    prettyprint_type(func->type);
    printf("\n");
    prettyprint_name(func->name);
    printf("\n[params");
    struct type *t = func->type;
    if (t->params)
        prettyprint_params(t->params, level++);
    printf("\n]");
    if (func->code)
       prettyprint_stmt(func->code, level++);
    printf("]");
}


void prettyprint_decl(struct decl *decl, int level) {
  while (decl) {
    struct type *t = decl->type;
    switch(t->kind) {
        case TYPE_VOID: {
            printf("\n[void]");
            break;
        }
        case TYPE_INTEGER: {
            prettyprint_var(decl, level++);
            break;
        }
        case TYPE_ARRAY: {
            prettyprint_array(decl, level++);
            break;
        }
        case TYPE_FUNCTION: {
            prettyprint_func(decl, level++);
            break;
        }
        case TYPE_CONST: {
            prettyprint_var(decl, level++);
            break;
        }
        default: {
            printf("tipo desconhecido\n");
            break;
        }
     }
     decl = decl->next;
   }
}

void prettyprint_stmt(struct stmt *s, int level) {
  while (s) {
    switch(s->kind) {
        case STMT_EXPR: {
            if (s->expr)
                prettyprint_expr(s->expr, level++);
            else
                printf("\n");
                printf("\n");
                print_ident(level);
                printf("[;]\n");
            break;
        }
        case STMT_IF_ELSE: {
            printf("\n");
            print_ident(level);
            printf("[selection-stmt ");
            prettyprint_expr(s->expr, level++);
            prettyprint_stmt(s->body, level++);
            if (s->else_body)
                prettyprint_stmt(s->else_body, level++);
            printf("]");
            break;
        }
        case STMT_WHILE: {
            printf("\n");
            print_ident(level);
            printf("[iteration-stmt ");
            prettyprint_expr(s->expr, level++);
            prettyprint_stmt(s->body, level++);
            printf("]\n");
            break;
        }
        case STMT_FOR: {
            printf("\n");
            print_ident(level);
            printf("[for-stmt ");
            prettyprint_expr(s->init_expr, level++);
            prettyprint_expr(s->expr, level++);
            prettyprint_expr(s->next_expr, level++);
            prettyprint_stmt(s->body, level++);
            printf("]\n");
            break;
        }
        case STMT_PRINT: {
            break;
        }
        case STMT_RETURN: {
            printf("\n");
            print_ident(level);
            printf("[return-stmt ");
            if (s->expr) {
                prettyprint_expr(s->expr, level++);
            }
            else {
                printf("[;]\n");
                print_ident(level);
            }
            printf("]\n");
            break;
        }
        case STMT_BLOCK: {
            printf("\n");
            print_ident(level);
            printf("[compound-stmt ");
            if (s->decl)
                prettyprint_decl(s->decl, level++);
            if (s->body)
                prettyprint_stmt(s->body, level++);
            printf("]\n");
            break;
        }
        default: break;
     }
     s = s->next;
  }
}

void prettyprint_bexpr(char *c, struct expr *l, struct expr *r, int level) {
    printf("\n");
    print_ident(level);
    printf("[%s ",c);
    prettyprint_expr(l, level++);
    if (r) prettyprint_expr(r, level++);
    printf("]");
}

void prettyprint_expr(struct expr *e, int level) {
  if (e) {
    switch(e->kind) {
        case EXPR_ASSIGN: {
            prettyprint_bexpr("=", e->left, e->right, level++);
            break;
        }
        case EXPR_ADD: {
            prettyprint_bexpr("+", e->left, e->right, level++);
            break;
        }
        case EXPR_SUB:
        {
            prettyprint_bexpr("-", e->left, e->right, level++);
            break;
        }
        case EXPR_MUL: {
            prettyprint_bexpr("*", e->left, e->right, level++);
            break;
        }
        case EXPR_DIV:
        {
            prettyprint_bexpr("/", e->left, e->right, level++);
            break;
        }
        case EXPR_NAME: {
            printf("[%s]", e->name);
            break;
        }
        case EXPR_VAR: {
            printf("[var ");
            prettyprint_expr(e->left, level++);
            printf("]");
            break;
        }

        case EXPR_ARRAY: {
            printf("[var ");
            prettyprint_expr(e->left, level++);
            prettyprint_expr(e->right, level++);
            printf("]");
            break;
        }
        case EXPR_INTEGER_LITERAL: {
            printf("[");
            int i = e->integer_value;
            printf("%d", i);
            printf("]");
            break;
        }
        case EXPR_EQ:
        {
            prettyprint_bexpr("==", e->left, e->right, level++);
            break;
        }
        case EXPR_NEQ:
        {
            prettyprint_bexpr("!=", e->left, e->right, level++);
            break;
        }
        case EXPR_LT:
        {
            prettyprint_bexpr("<", e->left, e->right, level++);
            break;
        }
        case EXPR_GT:
        {
            prettyprint_bexpr(">", e->left, e->right, level++);
            break;
        }
        case EXPR_LTEQ:
        {
            prettyprint_bexpr("<=", e->left, e->right, level++);
            break;
        }
        case EXPR_GTEQ:
        {
            prettyprint_bexpr(">=", e->left, e->right, level++);
            break;
        }
        case EXPR_AND: {
            prettyprint_bexpr("&&", e->left, e->right, level++);
            break;
        }
        case EXPR_OR: {
            prettyprint_bexpr("||", e->left, e->right, level++);
            break;
        }
        case EXPR_NOT: {
            prettyprint_bexpr("!", e->left, e->right, level++);
            break;
        }
        case EXPR_INC: {
            prettyprint_bexpr("++", e->left, e->right, level++);
            break;
        }
        case EXPR_DEC: {
            prettyprint_bexpr("--", e->left, e->right, level++);
            break;
        }
        case EXPR_FUN: {
            break;
        }
        case EXPR_CALL: {
            printf("\n");
            print_ident(level);
            printf("[call ");
            printf("\n");
            prettyprint_expr(e->left, level++);
            printf("\n[args ");
            prettyprint_expr(e->right, level++);
            printf("]\n");
            printf("]");
            break;
        }
        case EXPR_ARG:  {
            prettyprint_expr(e->right, level++);
            prettyprint_expr(e->left, level++);
            break;
        }
        default: {
            printf("internal error:\n");
        }
    }
  }
}

void bracket(struct decl *program) {
    printf("[program ");
    prettyprint_decl(program, 0);
    printf("\n]\n");
}

int main(void) {
    int result = yyparse();
    if (!result)
        bracket(parser_result);

    return result;
}
