%{

#include <stdlib.h>
#include <stdio.h>

extern void yyerror();
extern int yyparse();
int yylex();

int main() {
    if(yyparse()==0)
        printf("\nSem erros sintáticos.\n");
}

%}

%locations

%token ERROR
%token KEYELSE
%token KEYIF
%token KEYINT
%token KEYRETURN
%token KEYVOID
%token KEYWHILE
%token KEYCONST
%token KEYFOR
%token ID
%token NUM
%token PLUS
%token MINUS
%token DIVISION
%token MULT
%token SEMICOLON
%token OPARENT
%token CPARENT
%token EQUAL
%token OKEY
%token CKEY
%token LESSTHAN
%token LESSEQUAL
%token BIGGERTHAN
%token BIGGEREQUAL
%token EQUALEQUAL
%token COLON
%token OBRACKETS
%token CBRACKETS
%token NOTEQUAL

%%

program : declarationList;

declarationList : declarationList declaration
                | declaration
                ;

declaration : varDeclaration
            | constDeclaration
            | funDeclaration
            ;

varDeclaration : typeSpecifier ID SEMICOLON
               | typeSpecifier ID OBRACKETS NUM CBRACKETS SEMICOLON
               ;

typeSpecifier : KEYINT
              | KEYVOID
              ;

constDeclaration : KEYCONST typeSpecifier ID EQUAL NUM SEMICOLON;

funDeclaration : typeSpecifier ID OPARENT params CPARENT compoundStmt;

params : paramList
       | KEYVOID
       ;

paramList : paramList COLON param
          | param
          ;

param : typeSpecifier ID
      | typeSpecifier ID OBRACKETS CBRACKETS
      ;

compoundStmt : OKEY localDeclarations statementList CKEY
             ;

localDeclarations : localDeclarations varDeclaration
                  | %empty
                  ;

statementList : statementList statement
              | %empty
              ;

statement : expressionStmt
          | compoundStmt
          | selectionStmt
          | iterationStmt
          | returnStmt
          ;

expressionStmt : expression SEMICOLON
               | SEMICOLON
               ;

selectionStmt : KEYIF OPARENT expression CPARENT statement
              | KEYIF OPARENT expression CPARENT statement KEYELSE statement
              ;

iterationStmt : KEYWHILE OPARENT expression CPARENT statement
              | KEYFOR OPARENT expression SEMICOLON expression SEMICOLON expression CPARENT statement
              ;

returnStmt : KEYRETURN SEMICOLON
           | KEYRETURN expression SEMICOLON
           ;

expression : var EQUAL expression
           | simpleExpression
           ;

var : ID
    | ID OBRACKETS expression CBRACKETS
    ;

simpleExpression : additiveExpression relop additiveExpression
                 | additiveExpression
                 ;

relop : LESSEQUAL
      | LESSTHAN
      | BIGGERTHAN
      | BIGGEREQUAL
      | EQUALEQUAL
      | NOTEQUAL
      ;

additiveExpression : additiveExpression addop term
                   | term
                   ;

addop : PLUS
      | MINUS
      ;

term : term mulop factor
     | factor
     ;

mulop : MULT
      | DIVISION
      ;

factor : OPARENT expression CPARENT
       | var
       | call
       | NUM
       ;

call : ID OPARENT args CPARENT;

args : argList
     | %empty
     ;

argList : argList COLON expression
        | expression
        ;

%%