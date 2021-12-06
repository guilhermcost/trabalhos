// Isaque Copque e Caio Silva
%{
#include <stdlib.h>
#include <stdio.h>
#include <stdarg.h>
#include "ast.h"
extern int yylineno;

struct decl *parser_result;

void yyerror(const char* msg) {
      fprintf(stderr, "Line (%d): %s\n", yylineno, msg);
}

int yylex();
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

%token ERROR
%token <d> NUM

// PALAVRAS CHAVE KEY
%token <name> ID
%token ELSE
%token INT
%token IF
%token RETURN
%token VOID
%token WHILE 
%token CONST
%token FOR

// SÍMBOLOS SYM 
%token PLUS
%token MINUS
%token TIMES
%token DIVIDE
%token ASSIGN
%token LESS
%token MORE
%token LESSEQUAL
%token MOREEQUAL
%token EQUALS
%token DIFFERENT
%token SEMICOLON
%token COMMA
%token OPENPARENTHESES
%token CLOSEPARENTHESES
%token OPENBRACKET
%token CLOSEBRACKET
%token OPENBRACE 
%token CLOSEBRACE 

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

program: 
  declaration_list { parser_result = $1; $$ = $1; }
;

declaration_list:
  declaration_list declaration { $$ = insert_decl($1,$2); }
| declaration { $$ = $1; }
;

declaration:
  var_declaration
| const_declaration
| fun_declaration
;

var_declaration:
  type_specifier ID SEMICOLON { $$ = var_decl_create($2,$1); }
| type_specifier ID OPENBRACKET NUM CLOSEBRACKET SEMICOLON { $$ = array_decl_create($2,$1,$4); }
;

type_specifier:
  INT { $$ = type_create(TYPE_INTEGER,0,0); }
| VOID { $$ = type_create(TYPE_VOID,0,0); }
;

fun_declaration:
  type_specifier ID OPENPARENTHESES params CLOSEPARENTHESES compound_stmt { $$ = func_decl_create($2,$1,$4,$6); }
;

params:
  param_list
| VOID { $$ = (struct param_list *) 0; }
;

param_list:
  param_list COMMA param { $$ = insert_param($1,$3); }
| param { $$ = $1; }
;

param:
  type_specifier ID { $$ = param_create($2,$1); }
| type_specifier ID OPENBRACKET CLOSEBRACKET { $$ = param_array_create($2,$1); }
;

compound_stmt:
  OPENBRACE local_declarations statement_list CLOSEBRACE { $$ = compound_stmt_create(STMT_BLOCK,$2,$3); }
;

const_declaration:
  CONST type_specifier ID ASSIGN NUM SEMICOLON { $$ = const_decl_create($3,$2,$5); }
;

local_declarations:
  local_declarations var_declaration { $$ = insert_decl($1,$2); }
| %empty { $$ = insert_decl(0,0); }
;

statement_list:
 statement_list statement { $$ = insert_stmt($1,$2); }
| %empty { $$ = insert_stmt(0,0); }
;

statement:
  expression_stmt
| compound_stmt
| selection_stmt
| iteration_stmt
| return_stmt
;

expression_stmt:
  expression SEMICOLON { $$ = stmt_create(STMT_EXPR,0,0,$1,0,0,0,0); }
| SEMICOLON { $$ = stmt_create(STMT_EXPR,0,0,0,0,0,0,0); }
;

selection_stmt:
  IF OPENPARENTHESES expression CLOSEPARENTHESES statement { $$ = if_create($3,$5); }
| IF OPENPARENTHESES expression CLOSEPARENTHESES statement ELSE statement { $$ = if_else_create($3,$5,$7); }
;

iteration_stmt:
  WHILE OPENPARENTHESES expression CLOSEPARENTHESES statement { $$ = while_create($3,$5); }
| FOR OPENPARENTHESES for_expression SEMICOLON expression SEMICOLON expression CLOSEPARENTHESES statement { $$ = for_create($3,$5,$7,$9); }
| FOR OPENPARENTHESES INT for_expression SEMICOLON expression SEMICOLON expression CLOSEPARENTHESES statement { $$ = for_create($4,$6,$8,$10); }
;

return_stmt:
  RETURN SEMICOLON { $$ = stmt_create(STMT_RETURN,0,0,0,0,0,0,0); }
| RETURN expression SEMICOLON { $$ = stmt_create(STMT_RETURN,0,0,$2,0,0,0,0); }
;

expression:
  var ASSIGN expression { $$ = expr_create(EXPR_ASSIGN,$1,$3); }
| simple_expression { $$ = $1;}
;

var:
  ID { $$ = expr_create_var($1); }
| ID OPENBRACKET expression CLOSEBRACKET { $$ = expr_create_array($1,$3); }
;

simple_expression:
  additive_expression relop additive_expression { $$ = expr_create($2,$1,$3); }
| additive_expression
;

relop:
  LESSEQUAL { $$ = EXPR_LTEQ; }
| LESS      { $$ = EXPR_LT; }
| MORE      { $$ = EXPR_GT; }
| MOREEQUAL { $$ = EXPR_GTEQ; }
| EQUALS    { $$ = EXPR_EQ; }
| DIFFERENT { $$ = EXPR_NEQ; }
;

additive_expression:
  additive_expression addop term { $$ = expr_create($2, $1, $3); }
|  term
;

addop:
  PLUS  { $$ = EXPR_ADD; }
| MINUS { $$ = EXPR_SUB; }
;

term:
  term mulop factor { $$ = expr_create($2, $1, $3); }
|  factor
;

mulop:
 TIMES { $$ = EXPR_MUL; }
| DIVIDE { $$ = EXPR_DIV; }
;

factor:  
 OPENPARENTHESES expression CLOSEPARENTHESES { $$ = $2; }
| var
| NUM { $$ = expr_create_integer($1); }
| call
;

call:
  ID OPENPARENTHESES args CLOSEPARENTHESES { $$ = expr_create_call($1,$3); }
;

args:
| args_list
| %empty { $$ = (struct expr *) 0; }
;

args_list:
  args_list COMMA expression { $$ = expr_create_arg($3,$1); }
| expression { $$ = expr_create_arg($1,0); }
;

%%