%{
#include <stdlib.h>
#include <stdio.h>

void yyerror(const char* msg) {
      fprintf(stderr, "%s\n", msg);
}

int yylex();
%}

%token CONST ELSE FOR IF INT VOID RETURN WHILE
%token ID NUM
%token LT LTEQ GT GTEQ EQ NEQ
%token ERROR

%right THEN ELSE
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

const-declaration
: CONST type-specifier ID '=' expression-stmt
;

var-declaration
: type-specifier ID ';'
| type-specifier ID '[' NUM ']' ';'
;

type-specifier
: INT
| VOID
;

fun-declaration
: type-specifier ID '(' params ')' compound-stmt
;

params
: param-list
| VOID
;

param-list
: param-list ',' param
| param
;

param
: type-specifier ID
| type-specifier ID '[' ']'
;

compound-stmt
: '{' local-declarations statement-list '}'
;

local-declarations
: local-declarations var-declaration
| /* empty */
;

statement-list
: statement-list statement
| /* empty */
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
: expression ';'
| ';'
;

selection-stmt
: IF '(' expression ')' statement %prec THEN
| IF '(' expression ')' statement ELSE statement
;

iteration-stmt
: WHILE '(' expression ')' statement
;

for-stmt
: FOR '(' expression ';' expression ';' expression ')' statement
| FOR '(' type-specifier expression ';' expression ';' expression ')' statement
;

return-stmt
: RETURN ';'
| RETURN expression ';'
;

expression
: var '=' expression
| simple-expression
;

var
: ID
| ID '[' expression ']'
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
| EQ
| NEQ
;

additive-expression
: additive-expression addop term
| term
;

addop
: '+'
| '-'
;

term
: term mulop factor
| factor
;

mulop
: '*'
| '/'
;

factor
: '(' expression ')'
| var
| call
| NUM
;

call
: ID '(' args ')'
;

args
: arg-list
| /* empty */
;

arg-list
: arg-list ',' expression
| expression
;

%%

int main() {
  if(yyparse() == 0) {
    printf("Programa válido.\n");
  }
  else {
    printf("Programa inválido.\n");
  }
}
