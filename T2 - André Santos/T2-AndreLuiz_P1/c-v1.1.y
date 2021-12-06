%{
/* includes, C defs */


#include <stdio.h>
#include <stdlib.h>
extern int yylineno;

void yyerror(const char* msg); 

int yylex();

%}

//%locations
%define parse.error verbose

// TODO: adicionar outras classes de tokens de E1

/*
%union {
	int intval;
	char charval;
	double doubleval;
	char *strval;
	int subtok;
}
*/
/* declare tokens */

%token ID
%token CONST
%token NUM
%token ERROR


%token ELSE
%token FOR
%token IF
%token INT
%token RETURN
%token VOID
%token WHILE

%token PLUS    
%token MINUS 
%token TIMES     
%token DIV 
%token ASSIGN 
%token LT    
%token LE    
%token GT    
%token GE    
%token EQUAL 
%token NOTEQUAL  
%token SEMICOLON
%token COMMA      
%token LP    
%token RP
%token LBRAK    
%token RBRAK     
%token LBRACE    
%token RBRACE 





/*%token return*/


%left PLUS MINUS
%left TIMES DIV
//%right '('

//%define api.value.type {int}



%start program

%%

program: declaration-list
;

declaration-list: declaration-list declaration |
declaration
;
declaration: var-declaration |
fun-declaration
; 

var-declaration: type-specifier ID SEMICOLON|
type-specifier ID LBRAK NUM RBRAK SEMICOLON
;

type-specifier: INT | 
VOID
;

fun-declaration: type-specifier ID LP params RP compound-stmt
;

params: param-list |
VOID
;

param-list: param-list COMMA param |
param
;

param: type-specifier ID |
type-specifier ID LBRAK RBRAK
; 

compound-stmt: LBRACE local-declarations statement-list RBRACE
;
local-declarations: local-declarations var-declaration |
%empty
;
statement-list: statement-list statement |
%empty
;

statement: expression-stmt |
compound-stmt |
selection-stmt|
iteration-stmt |
return-stmt
;
expression-stmt: expression SEMICOLON |
SEMICOLON
;

selection-stmt: IF LP expression RP statement |
IF LP expression RP statement ELSE statement
;
iteration-stmt: WHILE LP expression RP statement
;

return-stmt: RETURN SEMICOLON |
RETURN expression SEMICOLON
;

expression: var ASSIGN expression |
simple-expression
;
var: ID |
ID LBRAK expression RBRAK
;

simple-expression: additive-expression relop additive-expression|
additive-expression

relop: LE |
LT |
GT |
GE |
EQUAL |
NOTEQUAL
;

additive-expression: additive-expression addop term |
term
;

addop : PLUS |
MINUS
;
term: term mulop factor |
factor
;

mulop: TIMES |
DIV
;

factor: LP expression RP |
var |
call|
NUM
;
call: ID LP args RP
;

args: arg-list |
%empty
;
arg-list:arg-list COMMA expression |
expression
;

%%
int main(void){
	//extern int yydebug;
	//yydebug = 1;
	int result;
	result = yyparse();
	if(result == 0)
		printf("Sucesso na realização da análise sintática.\n Retorno de yyparse() vale: %d\n", result);
	else{
		printf("Insucesso na realização da análise sintática.\n Retorno de yyparse() vale: %d\n", result);
	
	}
	
	return 0;
}

void yyerror(const char* msg){
    fprintf(stderr, "Linha do erro -> %d | mensagem de erro -> %s\n",yylineno,msg);
}


