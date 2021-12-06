/* 
 * Equipe:
 * Alan Divino
 * Luca Argolo
 * Gabriela Lima
 */

%{
#include <stdlib.h>
#include <stdio.h>

void yyerror(const char* msg) {
      fprintf(stderr, "%s\n", msg);
}

int yylex();
%}

%token CONST
%token ELSE
%token FOR
%token IF
%token INT
%token RETURN
%token VOID
%token WHILE
%token ERROR
%token ID
%token NUM
%token PLUS
%token MINUS
%token MUL
%token DIV
%token EQUAL
%token LT
%token GT
%token LEQ
%token GEQ
%token EQ
%token DIF
%token SEMICOLON
%token COMMA
%token OP
%token OC
%token LBRACKET
%token RBRACKET
%token LCBRT
%token RCBRT

%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

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
;

var-declaration 
: type-specifier ID SEMICOLON 
| type-specifier ID LBRACKET NUM RBRACKET SEMICOLON
;

type-specifier 
: INT 
| VOID
;

fun-declaration 
: type-specifier ID OP params OC compound-stmt
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
| type-specifier ID LBRACKET RBRACKET
;

compound-stmt 
: LCBRT local-declarations statement-list RCBRT
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
| return-stmt
;

expression-stmt 
: expression SEMICOLON 
| SEMICOLON
;

selection-stmt 
: IF OP expression OC statement %prec LOWER_THAN_ELSE
| IF OP expression OC statement ELSE statement
;

iteration-stmt 
: WHILE OP expression OC statement
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
| ID LBRACKET expression RBRACKET
;

simple-expression 
: additive-expression relop additive-expression 
| additive-expression
;

relop 
: LEQ 
| LT 
| GT 
| GEQ 
| EQ 
| DIF
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
: MUL 
| DIV
;

factor 
: OP expression OC 
| var 
| call 
| NUM
;

call 
: ID OP args OC
;

args 
: arg-list 
| %empty
;

arg-list 
: arg-list COMMA expression 
| expression
;

%%

int main() {
      printf("Resultado da analise sintatica: %d\n", yyparse());
}