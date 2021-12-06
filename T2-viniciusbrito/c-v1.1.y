/* Programa Bison */

%{
#include <stdio.h>

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
%token MUL
%token DIV
%token EQUAL
%token COMPARE
%token GT
%token GTE
%token LT
%token LTE
%token DIF

%token COMMA
%token SEMICOLON
%token LPAREN
%token RPAREN
%token LBRACE
%token RBRACE
%token LBRAKET
%token RBRAKET

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
                | type-specifier ID LBRAKET NUM RBRAKET SEMICOLON
                ;

type-specifier : INT 
               | VOID
               ;

const-declaration : CONST type-specifier ID EQUAL NUM SEMICOLON
                  ; 

fun-declaration : type-specifier ID LPAREN params RPAREN compound-stmt
                ;

params : param-list 
       | VOID 
       ;

param-list : param-list COMMA param 
           | param
           ;

param : type-specifier ID 
      | type-specifier ID LBRAKET RBRAKET
      ; 

compound-stmt : LBRACE declaration-attrb statement-list RBRACE
              | LBRACE local-declarations statement-list RBRACE
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

selection-stmt : IF LPAREN expression RPAREN statement 
               | IF LPAREN expression RPAREN statement ELSE statement
               ;

iteration-stmt : WHILE LPAREN expression RPAREN statement
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

iteration-stmt : FOR LPAREN exp-attr SEMICOLON exp-for SEMICOLON exp-increment RPAREN statement 
               ;

return-stmt : RETURN SEMICOLON 
            | RETURN expression SEMICOLON
            ;

expression : var EQUAL expression 
           | simple-expression
           ;

var : ID 
    | ID LBRAKET expression RBRAKET
    ;

simple-expression : additive-expression relop additive-expression 
                  | additive-expression
                  ;

relop : EQUAL 
      | LTE 
      | LT 
      | GT 
      | GTE 
      | COMPARE 
      | DIF
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

mulop : MUL 
      | DIV
      ;

factor : LPAREN expression RPAREN
       | var 
       | call 
       | NUM
       ;

call : ID LPAREN args RPAREN
     ;

args : arg-list 
     | %empty
     ;

arg-list : arg-list COMMA expression 
         | expression
         ;

%%
