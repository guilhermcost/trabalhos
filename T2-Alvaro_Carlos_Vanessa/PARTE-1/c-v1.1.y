/* Programa Bison */

%{
#include <stdio.h>
extern int yyparse();

void yyerror(const char* msg) {
      fprintf(stderr, "%s\n", msg);
}

int yylex();
%}

/* declare tokens */

%token CONST
%token RETURN
%token INT
%token VOID
%token IF
%token ELSE
%token FOR
%token WHILE

%token ID
%token NUM

%token PLUS
%token MINUS
%token MULT
%token DIV
%token EQUAL
%token DOUBLEEQUAL
%token BIGGER
%token BIGGEREQUAL
%token SMALLER
%token SMALLEREQUAL
%token DIFFERENT

%token COMMA
%token SEMICOLON
%token OPENP
%token CLOSEP
%token OPENK
%token CLOSEK
%token OPENB
%token CLOSEB

%token ERROR

%%

program : declaration-list
        ;

declaration-list : declaration-list declaration 
                 | declaration
                 ;

declaration : var-declaration 
            | fun-declaration
            | const-declaration
            ;

declaration-attrb : type-specifier ID EQUAL NUM SEMICOLON
                  | type-specifier ID EQUAL ID SEMICOLON
                  ;

var-declaration : type-specifier ID SEMICOLON 
                | type-specifier ID OPENB NUM CLOSEB SEMICOLON
                ;

type-specifier : INT 
               | VOID
               ;

const-declaration : CONST type-specifier ID EQUAL NUM SEMICOLON
                  ; 

fun-declaration : type-specifier ID OPENP params CLOSEP compound-stmt
                ;

params : param-list 
       | VOID 
       ;

param-list : param-list COMMA param 
           | param
           ;

param : type-specifier ID 
      | type-specifier ID OPENB CLOSEB
      ; 

compound-stmt : OPENK declaration-attrb statement-list CLOSEK
              | OPENK local-declarations statement-list CLOSEK
              ;

local-declarations : local-declarations var-declaration 
                   | %empty
                   ;

statement-list : statement-list statement 
               | %empty
               ;

statement : expression-stmt 
          | compound-stmt 
          | selection-stmt 
          | iteration-stmt 
          | return-stmt
          ;

expression-stmt : expression SEMICOLON 
                | SEMICOLON
                ;

selection-stmt : IF OPENP expression CLOSEP statement 
               | IF OPENP expression CLOSEP statement ELSE statement
               ;

iteration-stmt : WHILE OPENP expression CLOSEP statement
               ;

exp-attr : ID EQUAL ID
         | ID EQUAL NUM
         | type-specifier ID EQUAL NUM
         ;

exp-for : ID relop NUM
        | ID relop ID
        ;

exp-increment : ID EQUAL ID addop NUM
              | ID EQUAL ID mulop NUM
              | ID EQUAL ID addop ID
              | ID EQUAL ID mulop ID
              ;

iteration-stmt : FOR OPENP exp-attr SEMICOLON exp-for SEMICOLON exp-increment CLOSEP statement 
               ;

return-stmt : RETURN SEMICOLON 
            | RETURN expression SEMICOLON
            ;

expression : var EQUAL expression 
           | simple-expression
           ;

var : ID 
    | ID OPENB expression CLOSEB
    ;

simple-expression : additive-expression relop additive-expression 
                  | additive-expression
                  ;

relop : EQUAL 
      | SMALLEREQUAL 
      | SMALLER 
      | BIGGER 
      | BIGGEREQUAL 
      | DOUBLEEQUAL 
      | DIFFERENT
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

factor : OPENP expression CLOSEP
       | var 
       | call 
       | NUM
       ;

call : ID OPENP args CLOSEP
     ;

args : arg-list 
     | %empty
     ;

arg-list : arg-list COMMA expression 
         | expression
         ;

%%

int main (void) {     
      printf("Resultado da análise: %d\n", yyparse());
}