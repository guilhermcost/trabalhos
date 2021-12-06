/* Programa Bison */

%{
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include "ast.h"

struct decl *parser_result;

extern int yylineno;
int yylex();

void yyerror(const char* msg) {
      fprintf(stderr, "%s\n", msg);
}

%}

%union{
    struct decl *decl;
    struct stmt *stmt;
    struct expr *expr;
    struct type *type;
    struct param_list *plist;
    char *name;
    int d;
}

%define parse.error verbose
%expect 1

/* declare tokens */

%token CONST
%token RETURN
%token INT
%token VOID
%token IF
%token ELSE
%token FOR
%token WHILE

%token <name> ID
%token <d> NUM

%token PLUS
%token MINUS
%token MULT
%token DIV
%token EQUAL
%token DOUBLEEQUAL
%token BIGGER
%token BIGGEREQUAL
%token SMALLER
%token SMALLEREQUAL
%token DIFFERENT

%token COMMA
%token SEMICOLON
%token OPENP
%token CLOSEP
%token OPENK
%token CLOSEK
%token OPENB
%token CLOSEB

%token ERROR

%nonassoc EQUAL
%nonassoc DIFFERENT
%nonassoc SMALLER
%nonassoc BIGGER
%nonassoc SMALLEREQUAL
%nonassoc BIGGEREQUAL

%type <decl>  program
%type <decl>  declaration-list declaration
%type <decl>  var-declaration fun-declaration const-declaration 
%type <decl>  local-declarations
%type <type>  type-specifier
%type <plist> params param-list param
%type <stmt>  compound-stmt
%type <stmt>  statement-list statement
%type <stmt>  selection-stmt iteration-stmt return-stmt
%type <stmt>  expression-stmt
%type <expr>  expression simple-expression
%type <expr>  additive-expression factor term call var
%type <expr>  args arg-list
%type <d> relop mulop addop

%start program


%%

program : declaration-list { parser_result = $1; $$ = $1; }
        ;

declaration-list : declaration-list declaration { $$ = insert_decl($1,$2); }
                 | declaration { $$ = $1; }
                 ;

declaration : var-declaration 
            | fun-declaration
            | const-declaration
            ;

var-declaration : type-specifier ID SEMICOLON { $$ = var_decl_create($2,$1); }
                | type-specifier ID OPENB NUM CLOSEB SEMICOLON { $$ = array_decl_create($2,$1,$4); }
                ;

type-specifier : INT { $$ = type_create(TYPE_INTEGER,0,0); }
               | VOID { $$ = type_create(TYPE_VOID,0,0); }
               ;

const-declaration : CONST type-specifier ID EQUAL expression SEMICOLON { $$ = const_decl_create($3,$2,$5); }
                  ; 

fun-declaration : type-specifier ID OPENP params CLOSEP compound-stmt { $$ = func_decl_create($2,$1,$4,$6); }
                ;

params : param-list 
       | VOID { $$ = (struct param_list *) 0; }
       ;

param-list : param-list COMMA param { $$ = insert_param($1,$3); }
           | param { $$ = $1; }
           ;

param : type-specifier ID { $$ = param_create($2,$1); }
      | type-specifier ID OPENB CLOSEB { $$ = param_array_create($2,$1); }
      ; 

compound-stmt: OPENK local-declarations statement-list CLOSEK { $$ = compound_stmt_create(STMT_BLOCK,$2,$3); }
             | OPENK local-declarations CLOSEK { $$ = compound_stmt_create(STMT_BLOCK,$2,0); }
             | OPENK statement-list CLOSEK { $$ = compound_stmt_create(STMT_BLOCK,0,$2); }
             | OPENK CLOSEK { $$ = compound_stmt_create(STMT_BLOCK,0,0); }
             ;

local-declarations : local-declarations var-declaration { $$ = insert_decl($1,$2); }
                   | var-declaration { $$ = $1; }
                   ;

statement-list : statement-list statement { $$ = insert_stmt($1,$2); }
               | statement { $$ = $1; }
               ;

statement : expression-stmt
          | compound-stmt 
          | selection-stmt
          | iteration-stmt 
          | return-stmt
          ;

expression-stmt : expression SEMICOLON { $$ = stmt_create(STMT_EXPR,0,0,$1,0,0,0,0); }
                | SEMICOLON { $$ = stmt_create(STMT_EXPR,0,0,0,0,0,0,0); }
                ;

selection-stmt : IF OPENP expression CLOSEP statement { $$ = if_create($3,$5); }
               | IF OPENP expression CLOSEP statement ELSE statement { $$ = if_else_create($3,$5,$7); }
               ;

iteration-stmt : WHILE OPENP expression CLOSEP statement { $$ = while_create($3,$5); }
               | FOR OPENP expression SEMICOLON expression SEMICOLON expression CLOSEP statement { $$ = for_create($3,$5,$7,$9); }
               | FOR OPENP INT expression SEMICOLON expression SEMICOLON expression CLOSEP statement { $$ = for_create($4,$6,$8,$10); }
               ;

return-stmt : RETURN SEMICOLON { $$ = stmt_create(STMT_RETURN,0,0,0,0,0,0,0); }
            | RETURN expression SEMICOLON { $$ = stmt_create(STMT_RETURN,0,0,$2,0,0,0,0); }
            ;

expression : var EQUAL expression { $$ = expr_create(EXPR_ASSIGN,$1,$3); }
           | simple-expression { $$ = $1;}
           ;

var : ID { $$ = expr_create_var($1); }
    | ID OPENB expression CLOSEB { $$ = expr_create_array($1,$3); }
    ;

simple-expression : additive-expression relop additive-expression { $$ = expr_create($2,$1,$3); }
                  | additive-expression
                  ;

relop : SMALLEREQUAL { $$ = EXPR_LTEQ; }
      | SMALLER { $$ = EXPR_LT; }
      | BIGGER { $$ = EXPR_GT; }
      | BIGGEREQUAL { $$ = EXPR_GTEQ; }
      | DOUBLEEQUAL { $$ = EXPR_EQ; }
      | DIFFERENT { $$ = EXPR_NEQ; }
      ;

additive-expression : additive-expression addop term { $$ = expr_create($2, $1, $3); }
                    | term
                    ;

addop : PLUS { $$ = EXPR_ADD; }
      | MINUS { $$ = EXPR_SUB; }
      ;

term : term mulop factor { $$ = expr_create($2, $1, $3); }
     | factor
     ;

mulop : MULT { $$ = EXPR_MUL; }
      | DIV { $$ = EXPR_DIV; }
      ;

factor : OPENP expression CLOSEP { $$ = $2; }
       | var 
       | call 
       | NUM { $$ = expr_create_integer($1); }
       ;

call : ID OPENP args CLOSEP { $$ = expr_create_call($1,$3); }
     ;

args : arg-list 
     | { $$ = (struct expr *) 0; }
     ;

arg-list : arg-list COMMA expression { $$ = expr_create_arg($3,$1); }
         | expression { $$ = expr_create_arg($1,0); }
         ;

%%

/*int main (void) {     
      printf("Resultado da análise: %d\n", yyparse());
}*/