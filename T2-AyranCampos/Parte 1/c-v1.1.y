%{
/* includes, C defs */

#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>

struct decl *parser_result;

extern int yylineno;
extern int confirm;
extern char* yytext;
#define YYERROR_VERBOSE 1

extern int yyparse();

int yylex();

void yyerror(const char* msg) {
      if (confirm == 1) {
            printf("=============================================================\nError Lexico na linha -> %d\nChar desconhecido -> %s\n=============================================================\n",yylineno, yytext);
      }
      else {
            fprintf(stderr, "%d=============================================================\nError Sintatico na linha -> %d\nError -> %s\n=============================================================\n", confirm,yylineno, msg);
      }
}

%}
%define parse.error verbose
%expect 1

/* declare tokens */
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

%token SOMA
%token MINU
%token MULT
%token DIV

%token EQ
%token LT
%token GT

%token LTEQ
%token GTEQ
%token DOUBLEQ
%token NOTEQ

%token COMMA
%token SEMIC

%token OPENP
%token CLOSEP
%token OPENCOL
%token CLOSECOL
%token OPENCHA
%token CLOSECHA

%token ERROR

%%

/*=============== Parte 1 ================*/
program: declaration-list 
       ;

declaration-list: declaration-list declaration 
                | declaration
                ;

declaration: var-declaration
            | const-declaration
            | fun-declaration 
            ;

var-declaration: type-specifier ID SEMIC         
               | type-specifier ID OPENCOL NUM CLOSECOL SEMIC 
               ;

type-specifier: INT 
              | VOID 
              ;

const-declaration: CONST type-specifier ID EQ NUM SEMIC 


/*================ Parte 2 ===============*/
fun-declaration: type-specifier ID OPENP params CLOSEP compound-stmt 
               ;

params: param-list
      | VOID
      ;

param-list: param-list COMMA param 
          | param 
          ;

param: type-specifier ID 
      | type-specifier ID OPENCOL CLOSECOL 
      ;

/*================ Parte 3 ===============*/
compound-stmt: OPENCHA local-declarations statement-list CLOSECHA
            | OPENCHA local-declarations CLOSECHA
            | OPENCHA statement-list CLOSECHA
            | OPENCHA CLOSECHA 
            ;

local-declarations: local-declarations var-declaration 
                  | var-declaration   
                  ;

statement-list:   statement-list statement
              |   statement 
              ;

statement: expression-stmt
         | compound-stmt
         | selection-stmt
         | iteration-stmt
         | return-stmt
         ;

expression-stmt: expression SEMIC 
               | SEMIC          
               ;

selection-stmt: IF OPENP expression CLOSEP statement 
              | IF OPENP expression CLOSEP statement ELSE statement 
              ;

iteration-stmt: WHILE OPENP expression CLOSEP statement
              | FOR OPENP expression SEMIC expression SEMIC expression CLOSEP statement 
              | FOR OPENP INT expression SEMIC expression SEMIC expression CLOSEP statement  
              ;

return-stmt: RETURN SEMIC
           | RETURN expression SEMIC 
           ;

/*================ Parte 4 ===============*/
expression: var EQ expression 
          | simple-expression 
          ;

var: ID 
   | ID OPENCOL expression CLOSECOL 
   ;

simple-expression: additive-expression relop additive-expression 
                  | additive-expression
                  ;

relop: DOUBLEQ 
     | NOTEQ 
     | LT 
     | GT 
     | LTEQ 
     | GTEQ 

additive-expression: additive-expression addop term 
                   | term
                   ;

addop: SOMA 
     | MINU 
     ;

term: term mulop factor  
    | factor
    ;

mulop: MULT 
     | DIV
     ;

factor: OPENP expression CLOSEP
      | var
      | call
      | NUM 
      ;

call: ID OPENP args CLOSEP  
    ;

args: args-list
    | { $$ = (struct expr *) 0; }
    ;


args-list: args-list COMMA expression 
         | expression 
         ;


%%

int main() {
     if (yyparse() == 0) {
           printf("===> Sem erros Lexicos ou Sintaticos <===\n");
     }
}