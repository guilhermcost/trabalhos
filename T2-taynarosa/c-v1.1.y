/* Tayna Rosa */

%{
#include <stdlib.h>
#include <stdio.h>
#include <stdarg.h>

extern int yylineno;

void yyerror(const char* msg) {
        fprintf(stderr, "%s: Linha %d\n", msg, yylineno);
}

int yylex();

%}

%token ERROR
%token ID
%token NUM
%token CONST
%token ELSE
%token FOR
%token IF
%token INT
%token RETURN
%token VOID
%token WHILE
%token PLUS
%token MINUS
%token MUL
%token SLASH
%token EQUAL
%token LESS
%token GREATER
%token LESSEQUAL
%token GREATEREQUAL
%token EQUALEQUAL
%token DIFF
%token SEMICOLON
%token COMMA
%token OP
%token CP
%token OB
%token CB
%token OBRACES
%token CBRACES

%%

program:
  declaration_list
;

declaration_list:
  declaration_list declaration
| declaration
;

declaration:
  var_declaration
| fun_declaration
| const_declaration
;

var_declaration:
  type_specifier ID SEMICOLON
| type_specifier ID OB NUM CB SEMICOLON
;

type_specifier:
  INT
| VOID
| CONST
;

fun_declaration:
  type_specifier ID OP params CP compound_stmt
;

const_declaration:
  type_specifier ID EQUAL NUM SEMICOLON

params:
  param_list
| VOID
;

param_list:
  param_list COMMA param
| param
;

param:
  type_specifier ID
| type_specifier ID OB CB
;

compound_stmt:
  OBRACES local_declarations statement_list CBRACES
;

local_declarations:
  local_declarations var_declaration
| %empty
;

statement_list:
  statement_list statement
| %empty
;

statement:
  expression_stmt
| compound_stmt
| selection_stmt
| iteration_stmt
| return_stmt
;

expression_stmt:
  expression SEMICOLON
| SEMICOLON
;

selection_stmt:
  IF OP expression CP statement
| IF OP expression CP statement ELSE statement
;

iteration_stmt:
  WHILE OP expression CP statement
| FOR OP for_expression SEMICOLON expression SEMICOLON expression CP statement
;

return_stmt:
  RETURN SEMICOLON
| RETURN expression SEMICOLON
;

expression:
  var EQUAL expression
| simple_expression
;

for_expression:
  INT expression
| expression
;

var:
  ID
| ID OB expression CB
;

simple_expression:
  additive_expression relop additive_expression
| additive_expression
;

relop:
  LESSEQUAL
| LESS
| GREATER
| GREATEREQUAL
| EQUALEQUAL
| DIFF
;

additive_expression:
  additive_expression addop term
| term
;

addop:
  PLUS
| MINUS
;

term:
  term mulop factor
| factor
;

mulop:
  MUL
| SLASH
;

factor:
  OP expression CP
| var
| call
| NUM
;

call:
  ID OP args CP
;

args:
  arg_list
| %empty
;

arg_list:
  arg_list COMMA expression
| expression
;

%%
int yyparse();

int main() {
    int result = yyparse();
    if (result == 0){
        printf("Sem erros sintáticos!\n");
    } else {
        printf("Erro sintático!\n");
    }
}
