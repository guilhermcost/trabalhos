%{
#include <stdlib.h>
#include <stdio.h>
#include <stdarg.h>
#include "ast.h"

struct decl *parser_result;

extern int yylineno;
int yylex();

void yyerror (char const *s) {
   fprintf (stderr, "%s, line: %d\n", s, yylineno);
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


%token <name> ID
%token <d> NUM
%token CONST FOR ELSE IF INT VOID RETURN WHILE
%token LT LTEQ GT GTEQ EQ NEQ

%type <decl>  program
%type <decl>  declaration-list declaration
%type <decl>  var-declaration fun-declaration const-declaration
%type <type>  type-specifier
%type <plist> params param-list param
%type <stmt>  compound-stmt
%type <decl>  local-declarations
%type <stmt>  statement-list statement
%type <stmt>  expression-stmt
%type <stmt>  selection-stmt iteration-stmt for-stmt return-stmt
%type <expr>  expression simple-expression
%type <expr>  additive-expression factor term call var
%type <expr>  args arg-list
%type <d> relop addop mulop

%right THEN ELSE
%%

program
: declaration-list { parser_result = $1; $$ = $1; }
;

declaration-list
: declaration-list declaration { $$ = insert_decl($1,$2); }
| declaration { $$ = $1; }
;

declaration
: var-declaration
| fun-declaration
| const-declaration
;

const-declaration
: CONST type-specifier ID '=' simple-expression ';' { $$ = const_decl_create($3, $2, $5); }
;

var-declaration
: type-specifier ID ';' { $$ = var_decl_create($2,$1); }
| type-specifier ID '[' NUM ']' ';' { $$ = array_decl_create($2,$1,$4); }
;

type-specifier
: INT { $$ = type_create(TYPE_INTEGER,0,0); }
| VOID { $$ = type_create(TYPE_VOID,0,0); }
;

fun-declaration
: type-specifier ID '(' params ')' compound-stmt { $$ = func_decl_create($2,$1,$4,$6); }
;

params
: param-list
| VOID { $$ = (struct param_list *) 0; }
;

param-list
: param-list ',' param { $$ = insert_param($1,$3); }
| param { $$ = $1; }
;

param
: type-specifier ID { $$ = param_create($2,$1); }
| type-specifier ID '[' ']' { $$ = param_array_create($2,$1); }
;

compound-stmt
: '{' local-declarations statement-list '}' { $$ = compound_stmt_create(STMT_BLOCK,$2,$3); }
| '{' local-declarations '}' { $$ = compound_stmt_create(STMT_BLOCK,$2,0); }
| '{' statement-list '}' { $$ = compound_stmt_create(STMT_BLOCK,0,$2); }
| '{' '}' { $$ = compound_stmt_create(STMT_BLOCK,0,0); }

local-declarations
: local-declarations var-declaration { $$ = insert_decl($1,$2); }
| var-declaration { $$ = $1; }
;

statement-list
: statement-list statement { $$ = insert_stmt($1,$2); }
| statement { $$ = $1;}
;

statement
: expression-stmt
| compound-stmt
| selection-stmt
| iteration-stmt
| for-stmt
| return-stmt
;

expression-stmt
: expression ';' { $$ = stmt_create(STMT_EXPR,0,0,$1,0,0,0,0); }
| ';' { $$ = stmt_create(STMT_EXPR,0,0,0,0,0,0,0); }
;

selection-stmt
: IF '(' expression ')' statement { $$ = if_create($3,$5); } %prec THEN
| IF '(' expression ')' statement ELSE statement { $$ = if_else_create($3,$5,$7); }
;

iteration-stmt
: WHILE '(' expression ')' statement { $$ = while_create($3,$5); }
;

for-stmt
: FOR '(' expression ';' expression ';' expression ')' statement { $$ = for_create($3,$5,$7,$9); }
| FOR '(' type-specifier expression ';' expression ';' expression ')' statement { $$ = for_create($4,$6,$8,$10); }
;

return-stmt
: RETURN ';' { $$ = stmt_create(STMT_RETURN,0,0,0,0,0,0,0); }
| RETURN expression ';' { $$ = stmt_create(STMT_RETURN,0,0,$2,0,0,0,0); }
;

expression
: var '=' expression { $$ = expr_create(EXPR_ASSIGN,$1,$3); }
| simple-expression { $$ = $1; }
;

var
: ID { $$ = expr_create_var($1); }
| ID '[' expression ']' { $$ = expr_create_array($1,$3); }
;

simple-expression
: additive-expression relop additive-expression { $$ = expr_create($2,$1,$3); }
| additive-expression
;

relop
: LTEQ { $$ = EXPR_LTEQ; }
| LT { $$ = EXPR_LT; }
| GT { $$ = EXPR_GT; }
| GTEQ { $$ = EXPR_GTEQ; }
| EQ { $$ = EXPR_EQ; }
| NEQ { $$ = EXPR_NEQ; }
;

additive-expression
: additive-expression addop term { $$ = expr_create($2, $1, $3); }
| term
;

addop
: '+' { $$ = EXPR_ADD; }
| '-' { $$ = EXPR_SUB; }
;

term
: term mulop factor { $$ = expr_create($2, $1, $3); }
| factor
;

mulop
: '*' { $$ = EXPR_MUL; }
| '/' { $$ = EXPR_DIV; }
;

factor
: '(' expression ')' { $$ = $2; }
| var
| call
| NUM { $$ = expr_create_integer($1); }
;

call
: ID '(' args ')' { $$ = expr_create_call($1,$3); }
;

args
: arg-list
| /* empty */ { $$ = (struct expr *) 0; }
;

arg-list
: arg-list ',' expression { $$ = expr_create_arg($3,$1); }
| expression { $$ = expr_create_arg($1,0); }
;

%%
