/* 
 * Programa bison
 * Autores: Natan Moura, Pedro Augusto
 */
%{

#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include "ast.h"

struct decl *parser_result;

extern int yylineno;

void yyerror (char const *s) {
   fprintf (stderr, "%s: line -> %d\n", s,yylineno);
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

%token <name> ID
%token <d> NUM
%token CONST
%token INT
%token RETURN
%token VOID
%token ADD
%token SUB
%token MUL
%token DIV
%token SC
%token LP
%token RP
%token EQUAL
%token LK
%token RK
%token ELSE
%token FOR
%token IF
%token WHILE
%token LT
%token LEQ
%token GT
%token GEQ
%token CMP
%token COMMA
%token LSB
%token RSB
%token DIFF
%token ERROR

%nonassoc EQUAL
%nonassoc DIFF
%nonassoc LT
%nonassoc GT
%nonassoc LEQ
%nonassoc GEQ
%nonassoc CMP

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

%start program

%%

program: declaration-list { parser_result = $1; $$ = $1; } ;

declaration-list: declaration-list declaration { $$ = insert_decl($1,$2); }
                | declaration { $$ = $1; }
                ;

declaration: var-declaration 
           | const-declaration
           | fun-declaration
           ;

var-declaration: type-specifier ID SC  { $$ = var_decl_create($2,$1); }
               | type-specifier ID LSB NUM RSB SC { $$ = array_decl_create($2,$1,$4); }
               ; 

type-specifier: INT { $$ = type_create(TYPE_INTEGER,0,0); }
              | VOID { $$ = type_create(TYPE_VOID,0,0); }
              ;

fun-declaration: type-specifier ID LP params RP compound-stmt  { $$ = func_decl_create($2,$1,$4,$6); }
               ;

params: param-list 
      | VOID { $$ = (struct param_list *) 0; }
      ;

param-list: param-list COMMA param  { $$ = insert_param($1,$3); }
          | param { $$ = $1; }
          ;

param: type-specifier ID { $$ = param_create($2,$1); }
     | type-specifier ID LSB RSB { $$ = param_array_create($2,$1); }
     ;

const-declaration: CONST type-specifier ID EQUAL NUM SC { $$ = const_decl_create($3,$2,$5); }
                 ;

compound-stmt: LK local-declarations statement-list RK  { $$ = compound_stmt_create(STMT_BLOCK,$2,$3); }
             | LK local-declarations RK { $$ = compound_stmt_create(STMT_BLOCK,$2,0); }
             | LK statement-list RK { $$ = compound_stmt_create(STMT_BLOCK,0,$2); }
             | LK RK { $$ = compound_stmt_create(STMT_BLOCK,0,0); }
             ;

local-declarations: local-declarations var-declaration { $$ = insert_decl($1,$2); }
                  | var-declaration { $$ = $1; }
                  ;

statement-list: statement-list statement  { $$ = insert_stmt($1,$2); }
              |  statement { $$ = $1;}
              ;

statement: expression-stmt 
         | compound-stmt
         | selection-stmt
         | iteration-stmt
         | return-stmt
         ;

expression-stmt: expression SC { $$ = stmt_create(STMT_EXPR,0,0,$1,0,0,0,0); }
               | SC { $$ = stmt_create(STMT_EXPR,0,0,0,0,0,0,0); }
               ;

selection-stmt: IF LP expression RP statement { $$ = if_create($3,$5); }
              | IF LP expression RP statement ELSE statement { $$ = if_else_create($3,$5,$7); }
              ;

iteration-stmt: WHILE LP expression RP statement  { $$ = while_create($3,$5); }
              | FOR LP expression SC expression SC expression RP statement { $$ = for_create($3,$5,$7,$9); }
              | FOR LP INT expression SC expression SC expression RP statement { $$ = for_create($4,$6,$8,$10); }
              ;

return-stmt: RETURN SC { $$ = stmt_create(STMT_RETURN,0,0,0,0,0,0,0); }
           | RETURN expression SC  { $$ = stmt_create(STMT_RETURN,0,0,$2,0,0,0,0); }
           ;

expression: var EQUAL expression { $$ = expr_create(EXPR_ASSIGN,$1,$3); }
          | simple-expression { $$ = $1; }
          ;

var: ID { $$ = expr_create_var($1); }
   | ID LSB expression RSB  { $$ = expr_create_array($1,$3); }
   ;

simple-expression: additive-expression
                 | additive-expression LT additive-expression { $$ = expr_create(EXPR_LT,$1,$3); }
                 | additive-expression GT additive-expression { $$ = expr_create(EXPR_GT,$1,$3); }
                 | additive-expression GEQ additive-expression { $$ = expr_create(EXPR_GEQ,$1,$3); }
                 | additive-expression LEQ additive-expression { $$ = expr_create(EXPR_LEQ,$1,$3); }
                 | additive-expression CMP additive-expression { $$ = expr_create(EXPR_EQUAL,$1,$3); }
                 | additive-expression DIFF additive-expression { $$ = expr_create(EXPR_DIFF,$1,$3); }
;

additive-expression: additive-expression ADD term { $$ = expr_create(EXPR_ADD, $1, $3); }
                   | additive-expression SUB term { $$ = expr_create(EXPR_SUB, $1, $3); }
                   | term
                   ;

term: term MUL factor { $$ = expr_create(EXPR_MUL, $1, $3); }
    | term DIV factor { $$ = expr_create(EXPR_DIV, $1, $3); }
    | factor
    ;

factor: LP expression RP { $$ = $2; }
      | var
      | call
      | NUM { $$ = expr_create_integer($1); }
      ;

call: ID LP args RP  { $$ = expr_create_call($1,$3); }
    ;

args: arg-list
    | %empty { $$ = (struct expr *) 0; }
    ;

arg-list: arg-list COMMA expression { $$ = expr_create_arg($3,$1); }
        | expression { $$ = expr_create_arg($1,0); }
        ;
%%

/* void */

