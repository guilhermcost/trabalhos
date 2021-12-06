%{
/* includes, C defs */


#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include "ast.h"
extern int yylineno;

struct decl *parser_result;

void yyerror(const char* msg); 

int yylex();

%}

//%locations
%define parse.error verbose

// TODO: adicionar outras classes de tokens de E1

%union{
    struct decl *decl;
    struct stmt *stmt;
    struct expr *expr;
    struct type *type;
    struct param_list *plist;
    char *name;
    int d;
	enum expr_t  *expr_type;
	
}
//enum expr_t expr_type;
/* declare tokens */

%token <name> ID
%token CONST
%token <expr> NUM
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

%nonassoc LT
%nonassoc LE
%nonassoc GT
%nonassoc GE
%nonassoc EQUAL
%nonassoc NOTEQUAL





/*%token return*/


%left PLUS MINUS
%left TIMES DIV


//%define api.value.type {int}

%type <decl>  program
%type <decl>  declaration-list declaration
%type <decl>  var-declaration fun-declaration  //const-declaration enum_declaration
//%type <plist> enumerator_list enume
%type <decl>  local-declarations
%type <type>  type-specifier
%type <plist> params param-list param
%type <stmt>  compound-stmt
%type <stmt>  statement-list statement
%type <stmt>  selection-stmt iteration-stmt return-stmt
%type <stmt>  expression-stmt
%type <expr>  expression simple-expression
//%type <expr>  conditional-expression-and conditional-expression-or
%type <expr>  additive-expression factor term call var
%type <expr>  args arg-list

%type <d>  relop
%type <d>  addop
%type <d>  mulop

%start program

%%

program: declaration-list                        { parser_result = $1; $$ = $1; }
;

declaration-list: declaration-list declaration   { $$ = insert_decl($1,$2); }|
declaration 									 { $$ = $1; }
;
declaration: var-declaration|
fun-declaration
; 

var-declaration: type-specifier ID SEMICOLON      { $$ = var_decl_create($2,$1); }|
type-specifier ID LBRAK NUM RBRAK SEMICOLON       { $$ = array_decl_create($2,$1,$4); }
;

type-specifier: INT 							  { $$ = type_create(TYPE_INTEGER,0,0); }| 
VOID				                              { $$ = type_create(TYPE_VOID,0,0); }
;

fun-declaration: type-specifier ID LP params RP compound-stmt { $$ = func_decl_create($2,$1,$4,$6); }
;

params: param-list |
VOID											   { $$ = (struct param_list *) 0; }
;

param-list: param-list COMMA param 				   { $$ = insert_param($1,$3); }|
param
;

param: type-specifier ID 						   { $$ = param_create($2,$1); }|
type-specifier ID LBRAK RBRAK					   { $$ = param_array_create($2,$1); }
; 

compound-stmt: LBRACE local-declarations statement-list RBRACE { $$ = compound_stmt_create(STMT_BLOCK,$2,$3); }
;
local-declarations: local-declarations var-declaration { $$ = insert_decl($1,$2); }|
%empty
;
statement-list: statement-list statement 		   { $$ = insert_stmt($1,$2); }|
%empty
;

statement: expression-stmt |
compound-stmt |
selection-stmt|
iteration-stmt |
return-stmt
;
expression-stmt: expression SEMICOLON 			   { $$ = stmt_create(STMT_EXPR,0,0,$1,0,0,0,0); }|
SEMICOLON										   { $$ = stmt_create(STMT_EXPR,0,0,0,0,0,0,0); }
;

selection-stmt: IF LP expression RP statement 	   { $$ = if_create($3,$5); }|
IF LP expression RP statement ELSE statement	   { $$ = if_else_create($3,$5,$7); }
;
iteration-stmt: WHILE LP expression RP statement   { $$ = while_create($3,$5); }
;

return-stmt: RETURN SEMICOLON 					   { $$ = stmt_create(STMT_RETURN,0,0,0,0,0,0,0); }|
RETURN expression SEMICOLON						   { $$ = stmt_create(STMT_RETURN,0,0,$2,0,0,0,0); }
;

expression: var ASSIGN expression 				   {$$ = expr_create(EXPR_ASSIGN,$1,$3); }|
simple-expression								   
;
var: ID 										   { $$ = expr_create_var($1); }|
ID LBRAK expression RBRAK						   { $$ = expr_create_array($1,$3); }
;

simple-expression: additive-expression relop additive-expression { 
	switch( $2 ){
		case LT:
			$$ = expr_create(EXPR_LT,$1,$3); 
			break;
		case LE:
			$$ = expr_create(EXPR_LTEQ,$1,$3); 
			break;
		case GT:
			$$ = expr_create(EXPR_GT,$1,$3); 
			break;
		case GE:
			$$ = expr_create(EXPR_GTEQ,$1,$3); 
			break;
		case EQUAL:
			$$ = expr_create(EXPR_EQ,$1,$3); 
			break;
		case NOTEQUAL:
			$$ = expr_create(EXPR_NEQ,$1,$3); 
			break;
	} 															}|
additive-expression
;
relop: LE |
LT |
GT |
GE |
EQUAL |
NOTEQUAL
;

additive-expression: additive-expression addop term { $$ = expr_create($2, $1, $3); }|
term
;

addop : PLUS |
MINUS
;
term: term mulop factor 							{ $$ = expr_create($2, $1, $3); }|
factor
;

mulop: TIMES |
DIV
;

factor: LP expression RP 							{ $$ = $2; }|
var |
call|
NUM
;
call: ID LP args RP									{ $$ = expr_create_call($1,$3); }
;

args: arg-list |
%empty                                              { $$ = (struct expr *) 0; }
;
arg-list: arg-list COMMA expression 				{ $$ = expr_create_arg($3,$1); }|
expression											{ $$ = expr_create_arg($1,0); }
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


