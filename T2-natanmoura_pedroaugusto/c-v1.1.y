/* 
 * Programa bison
 * Autores: Natan Moura, Pedro Augusto
 */
%{

#include <stdlib.h>
#include <stdio.h>
extern int yylineno;
void yyerror (char const *s) {
   fprintf (stderr, "%s: line -> %d\n", s,yylineno);
   exit(1);
 }
int yylex();
%}


%token ID
%token NUM
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

%%

program: declaration-list;

declaration-list: declaration-list declaration
                | declaration
                ;

declaration: var-declaration 
           | const-declaration
           | fun-declaration
           ;

var-declaration: type-specifier ID SC 
               | type-specifier ID LSB NUM RSB SC
               ; 

type-specifier: INT 
              | VOID
              ;

fun-declaration: type-specifier ID LP params RP compound-stmt
               ;

params: param-list 
      | VOID
      ;

param-list: param-list COMMA param
          | param
          ;

param: type-specifier ID
     | type-specifier ID LSB RSB
     ;

const-declaration: CONST type-specifier ID EQUAL NUM SC
                 ;

compound-stmt: LK local-declarations statement-list RK
             ;

local-declarations: local-declarations var-declaration 
                  | %empty
                  ;

statement-list: statement-list statement
              | %empty
              ;

statement: expression-stmt 
         | compound-stmt
         | selection-stmt
         | iteration-stmt
         | return-stmt
         ;

expression-stmt: expression SC
               | SC
               ;

selection-stmt: IF LP expression RP statement
              | IF LP expression RP statement ELSE statement
              ;

iteration-stmt: WHILE LP expression RP statement
              | FOR LP for-expression SC expression SC expression RP statement
              ;

for-expression: INT expression
              | expression
              ;

return-stmt: RETURN SC
           | RETURN expression SC
           ;

expression: var EQUAL expression
          | simple-expression
          ;

var: ID
   | ID LSB expression RSB
   ;

simple-expression: additive-expression relop additive-expression
                 | additive-expression
                 ;

relop: LEQ
     | LT
     | GT
     | GEQ
     | CMP
     | DIFF
     ;

additive-expression: additive-expression addop term
                   | term
                   ;

addop: ADD
     | SUB
     ;

term: term mulop factor
    | factor
    ;

mulop: MUL
     | DIV
     ;

factor: LP expression RP
      | var
      | call
      | NUM
      ;

call: ID LP args RP
    ;

args: arg-list
    | %empty
    ;

arg-list: arg-list COMMA expression
        | expression
        ;
%%

/* void */

int main() {

/*#ifdef YYDEBUG
  yydebug = 1;
#endif*/
yyparse();
printf("Ended without syntax or lexical errors...\n");

}
