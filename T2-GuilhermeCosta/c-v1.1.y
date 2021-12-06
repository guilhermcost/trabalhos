/* C-v1.1 sem semântica

POR GUILHERME COSTA */

%{
#include <stdlib.h>
#include <stdio.h>

extern int yylineno;
int yylex();
void yyerror(const char* msg) {
      fprintf(stderr, "%s\n", msg);
}

%}

// declaração de Tokens

%token CONST
%token ELSE
%token FOR
%token IF
%token INT
%token RETURN
%token VOID
%token WHILE
%token ID
%token NUM
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

%%

program
: declaration-list
;

declaration-list
: declaration-list declaration
| declaration
;

declaration
: var-declaration
| fun-declaration
| const-declaration
;

var-declaration
: type-specifier ID SEMICOLON
| type-specifier ID OPENSQUARE NUM CLOSESQUARE SEMICOLON
;


fun-declaration
: type-specifier ID OPENP params CLOSEP compound-stmt
;

const-declaration
: type-specifier CONST ID EQUAL NUM SEMICOLON
;

type-specifier
: INT
| VOID
;

params
: param-list
| VOID
;

param-list
: param-list COMMA param
| param
;

param
: type-specifier ID
| type-specifier ID OPENSQUARE CLOSESQUARE
;

compound-stmt
: OPENCURLY local-declarations statement-list CLOSECURLY
;

local-declarations
: local-declarations var-declaration
| %empty
;

statement-list
: statement-list statement
| %empty
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
: expression SEMICOLON
| SEMICOLON
;

selection-stmt
: IF OPENP expression CLOSEP statement
| IF OPENP expression CLOSEP statement ELSE statement
;

iteration-stmt
:  WHILE OPENP expression CLOSEP statement
;

for-stmt
: FOR OPENP expression SEMICOLON expression SEMICOLON expression CLOSEP statement
;

return-stmt
: RETURN SEMICOLON
| RETURN expression SEMICOLON
;

expression
: var EQUAL expression
| simple-expression
;

var
: ID
| ID OPENSQUARE expression CLOSESQUARE
;

simple-expression
: additive-expression relop additive-expression
| additive-expression
;

relop
: LTEQ 
| LT
| GT
| GTEQ 
| ISEQUAL 
| DIFFERENT
;

additive-expression
: additive-expression addop term
| term
;

addop
: PLUS
| MINUS
;

term
: term mulop factor
| factor
;

mulop
: TIMES
| DIVIDE
;

factor
: OPENP expression CLOSEP
| var
| call
| NUM
;

call
: ID OPENP args CLOSEP
;

args
: args-list
| %empty
;

args-list
: args-list COMMA expression
| expression
;

%%
// main

int main() {

	printf("Resultado da analise sintática: %d\n", yyparse());
}


