/*
Trabalho 2/Parte 1 - Compiladores
Caroline Alves, Jeisiane Macedo
*/

%{
#include <stdlib.h>
#include <stdio.h>

int yylex();
int yyparse();
extern int yylineno;
extern char * yytext;

void yyerror(const char* msg) {
      fprintf(stderr, "%s\n", msg);
}

//int yylex();
%}

%token NUM
%token ID
%token IF
%token ELSE
%token INT
%token RETURN
%token CONST
%token VOID
%token WHILE
%token FOR
%token PLUS
%token MINUS
%token MULT
%token DIV
%token EQUAL
%token SCOLON
%token OP
%token CP
%token OC
%token CC
%token OB
%token CB
%token LT
%token GT
%token LTEQ
%token GTEQ
%token EQEQ
%token NEQ
%token COMMA
%token ERROR

%%
program : declaration-list
        ;

declaration-list : declaration-list declaration
                 | declaration
                 ;

declaration : var-declaration 
            | fun-declaration
            ;

var-declaration : type-specifier ID SCOLON
                | type-specifier ID OB NUM CB SCOLON
                ; 

type-specifier : INT 
               | VOID
               ;

fun-declaration : type-specifier ID OP params CP compound-stmt
                ;

params : param-list
       | VOID
       ;

param-list : param-list COMMA param 
           | param
           ;

param : type-specifier ID 
      | type-specifier ID OB CB
      ;

compound-stmt : OC local-declarations statement-list CC
              ;    

local-declarations : local-declarations var-declaration 
                   |
                   ;

statement-list : statement-list statement 
               |
               ;

statement : expression-stmt
          | compound-stmt
          | selection-stmt
          | iteration-stmt
          | return-stmt
          ;

expression-stmt : expression SCOLON 
                | SCOLON
                ;

selection-stmt : IF OP expression CP statement 
               | IF OP expression CP statement ELSE statement
               ;

iteration-stmt : WHILE OP expression CP statement
               ;

return-stmt : RETURN SCOLON 
            | RETURN expression SCOLON
            ;

expression : var EQUAL expression
           | simple-expression
           ;

var : ID 
    | ID OB expression CB
    ;

simple-expression : additive-expression relop additive-expression 
                  | additive-expression
                  ;

relop : LTEQ 
      | LT 
      | GT 
      | GTEQ 
      | EQEQ 
      | NEQ
      ;

additive-expression : additive-expression addop term
                    | term
                    ;
addop : PLUS
      | MINUS
      ;

term : term mulop factor
     | factor
     ;

mulop : MULT
      | DIV
      ;

factor : OP expression CP 
       | var 
       | call 
       | NUM
       ;

call : ID OP args CP
     ;

args : arg-list 
     |
     ;

arg-list : arg-list COMMA expression 
         | expression
         ;


%%



