/*
* GRUPO 4:
   - LUCAS MOREIRA PIRES
   - VINICIUS TEIXEIRA MACEDO
   - RAFAEL SOUZA COIMBRA
*/

%{
/* includes, C defs */

#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include "ast.h"

struct decl *parser_result;

extern int yylineno;
int yylex();
void yyerror(const char *s);

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
%token ELSE
%token FOR
%token IF
%token INT
%token RETURN
%token VOID
%token WHILE
%token <name> ID
%token <d> NUM
%token PLUS
%token MINUS
%token TIMES
%token DIVIDE
%token EQUAL
%token LT
%token GT
%token LTEQ
%token GTEQ
%token ISEQUAL
%token DIFFERENT
%token SEMICOLON
%token COMMA
%token OPENP
%token CLOSEP
%token OPENSQUARE
%token CLOSESQUARE
%token OPENCURLY
%token CLOSECURLY
%token ERROR

%nonassoc EQUAL
%nonassoc DIFFERENT
%nonassoc LT
%nonassoc GT
%nonassoc LTEQ
%nonassoc GTEQ

%type <decl>  program
%type <decl>  declaration-list declaration
%type <decl>  var-declaration fun-declaration const-declaration //
%type <decl>  local-declarations
%type <type>  type-specifier
%type <plist> params param-list param
%type <stmt>  compound-stmt
%type <stmt>  statement-list statement
%type <stmt>  selection-stmt iteration-stmt for-stmt return-stmt
%type <stmt>  expression-stmt
%type <expr>  expression simple-expression
%type <expr>  conditional-expression-and conditional-expression-or
%type <expr>  additive-expression factor term call var
%type <expr>  args args-list

%start program

%%

program: declaration-list { parser_result = $1; $$ = $1; }
;

declaration-list:
  declaration-list declaration { $$ = insert_decl($1,$2); }
| declaration { $$ = $1; }
;

declaration:
  var-declaration
| fun-declaration
| const-declaration
;

var-declaration:
  type-specifier ID ';'             { $$ = var_decl_create($2,$1); }
| type-specifier ID '[' NUM ']' ';' { $$ = array_decl_create($2,$1,$4); }
;

fun-declaration:
  type-specifier ID '(' params ')' compound-stmt
  { $$ = func_decl_create($2,$1,$4,$6); }
;

const-declaration
: type-specifier CONST ID SEMICOLON
;

type-specifier:
  INT  { $$ = type_create(TYPE_INTEGER,0,0); }
| VOID { $$ = type_create(TYPE_VOID,0,0); }
;

params:
  param-list
| VOID { $$ = (struct param_list *) 0; }
;

param-list:
  param-list COMMA param  { $$ = insert_param($1,$3); }
| param { $$ = $1; }
;

param:
  type-specifier ID { $$ = param_create($2,$1); }
| type-specifier ID OPENSQUARE CLOSESQUARE { $$ = param_array_create($2,$1); }
;


compound-stmt
:  OPENCURLY local-declarations statement-list CLOSECURLY
        { $$ = compound_stmt_create(STMT_BLOCK,$2,$3); }
;

local-declarations
: local-declarations var-declaration { $$ = insert_decl($1,$2); }
| %empty
;


statement-list
:  statement-list statement { $$ = insert_stmt($1,$2); }
| %empty
;

statement
:  expression-stmt
| compound-stmt
| selection-stmt
| iteration-stmt
| for-stmt
| return-stmt
;

expression-stmt:
  expression SEMICOLON { $$ = stmt_create(STMT_EXPR,0,0,$1,0,0,0,0); }
| SEMICOLON            { $$ = stmt_create(STMT_EXPR,0,0,0,0,0,0,0); }
;

selection-stmt:
  IF OPENP expression CLOSEP statement { $$ = if_create($3,$5); }
| IF OPENP expression CLOSEP statement ELSE statement
  { $$ = if_else_create($3,$5,$7); }
;

iteration-stmt
:  WHILE OPENP expression CLOSEP statement { $$ = while_create($3,$5); }
;

for-stmt
: FOR OPENP expression SEMICOLON expression SEMICOLON expression CLOSEP statement //{$$ = for_create($3, $5, $7);}

return-stmt
: RETURN SEMICOLON { $$ = stmt_create(STMT_RETURN,0,0,0,0,0,0,0); }
| RETURN expression SEMICOLON { $$ = stmt_create(STMT_RETURN,0,0,$2,0,0,0,0); }
;

expression:
  var EQUAL expression { $$ = expr_create(EXPR_ASSIGN,$1,$3); }
| simple-expression	{ $$ = $1; }
;

var:
  ID { $$ = expr_create_var($1); }
| ID OPENSQUARE expression CLOSESQUARE { $$ = expr_create_array($1,$3); }
;

simple-expression
: additive-expression relop additive-expression { $$ = expr_create($2, $1, $3); }
| additive-expression

relop
: LTEQ {$$ = EXPR_LTEQ}
| LT   {$$ = EXPR_LT}
| GT   {$$ = EXPR_GT}
| GTEQ {$$ = EXPR_GTEQ}
| ISEQUAL {$$ = EXPR_EQ}
| DIFFERENT {$$ = EXPR_NEQ}
;

additive-expression
: additive-expression addop term { $$ = expr_create($2, $1, $3); }
| term
;

addop
: PLUS	{$$ = EXPR_ADD;}
| MINUS {$$ = EXPR_SUB;}
;

term
: term mulop factor { $$ = expr_create($2, $1, $3); }
| factor
;

mulop
: TIMES	{$$ = EXPR_MUL;}
| DIVIDE	{$$ = EXPR_DIV;}
;

factor
: OPENP expression CLOSEP { $$ = $2; }
| var
| call
| NUM	{$$ = expr_create_integer($1);}
;

call
: ID OPENP args CLOSEP	{ $$ = expr_create_call($1,$3); }
;

args
: args-list
| { $$ = (struct expr *) 0; }
;

args-list
: args-list COMMA expression	{ $$ = expr_create_arg($3,$1); }
| expression	{ $$ = expr_create_arg($1,0); }
;

%%
// main

int main() {

	printf("Resultado da analise sintática: %d\n", yyparse());
}


