// Isaque Copque e Caio Silva
%{
#include <stdlib.h>
#include <stdio.h>
#include <stdarg.h>
extern int yylineno;

void yyerror(const char* msg) {
      fprintf(stderr, "Line (%d): %s\n", yylineno, msg);
}

int yylex();
%}

%token ERROR
%token NUM

// PALAVRAS CHAVE KEY
%token ID
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
| const_declaration
| fun_declaration
;

var_declaration:
  type_specifier ID SEMICOLON
| type_specifier ID OPENBRACKET NUM CLOSEBRACKET SEMICOLON
;

type_specifier:
  INT
| VOID
;

fun_declaration:
  type_specifier ID OPENPARENTHESES params CLOSEPARENTHESES compound_stmt
;

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
| type_specifier ID OPENBRACKET CLOSEBRACKET
;

compound_stmt:
  OPENBRACE local_declarations statement_list CLOSEBRACE
;

const_declaration:
  CONST type_specifier ID ASSIGN NUM SEMICOLON
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
  IF OPENPARENTHESES expression CLOSEPARENTHESES statement
| IF OPENPARENTHESES expression CLOSEPARENTHESES statement ELSE statement
;

iteration_stmt:
  WHILE OPENPARENTHESES expression CLOSEPARENTHESES statement
| FOR OPENPARENTHESES for_expression SEMICOLON expression SEMICOLON expression CLOSEPARENTHESES statement
;

for_expression:
  INT expression
| expression
;

return_stmt:
  RETURN SEMICOLON
| RETURN expression SEMICOLON
;

expression:
  var ASSIGN expression
| simple_expression
;

var:
  ID
| ID OPENBRACKET expression CLOSEBRACKET
;

simple_expression:
  additive_expression relop additive_expression
| additive_expression
;

relop:
  LESSEQUAL 
| LESS 
| MORE 
| MOREEQUAL 
| EQUALS 
| DIFFERENT
;

additive_expression:
  additive_expression addop term
|  term
;

addop:
  PLUS
| MINUS
;

term:
  term mulop factor
|  factor
;

mulop:
 TIMES
| DIVIDE
;

factor:  
 OPENPARENTHESES expression CLOSEPARENTHESES
| var
| NUM
| call
;

call:
  ID OPENPARENTHESES args CLOSEPARENTHESES
;

args:
| args_list
| %empty
;

args_list:
  args_list COMMA expression
| expression
;

%%

int main(){
    yyparse();
}