%{

#include <stdlib.h>
#include <stdio.h>
#include "ast.h"

struct decl *parser_result;

extern void yyerror();
extern int yyparse();
int yylex();

%}

%union{
  struct decl *decl;
  struct stmt *stmt;
  struct expr *expr;
  struct type *type;
  struct param_list *plist;
  char *name;
  int d;
}

%locations

%token KEYELSE
%token KEYIF
%token KEYINT
%token KEYRETURN
%token KEYVOID
%token KEYWHILE
%token KEYCONST
%token KEYFOR
%token <name> ID
%token <d> NUM
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
%token GREATERTHAN
%token GREATEREQUAL
%token EQUALEQUAL
%token COLON
%token OBRACKETS
%token CBRACKETS
%token NOTEQUAL

%type <decl>  program
%type <decl>  declarationList declaration
%type <decl>  varDeclaration funDeclaration constDeclaration
%type <type>  typeSpecifier
%type <plist> params paramList param
%type <stmt>  compoundStmt
%type <decl>  localDeclarations
%type <stmt>  statementList statement
%type <stmt>  expressionStmt
%type <stmt>  selectionStmt iterationStmt forStmt returnStmt
%type <expr>  expression simpleExpression
%type <expr>  additiveExpression factor term call var
%type <expr>  args argList
%type <d> relop addop mulop

%right THEN ELSE

%%

program : declarationList { parser_result = $1; $$ = $1; }
;

declarationList : declarationList declaration { $$ = insert_decl($1,$2); }
                | declaration { $$ = $1; }
                ;

declaration : varDeclaration
            | constDeclaration
            | funDeclaration
            ;

varDeclaration : typeSpecifier ID SEMICOLON { $$ = var_decl_create($2,$1); }
               | typeSpecifier ID OBRACKETS NUM CBRACKETS SEMICOLON { $$ = array_decl_create($2,$1,$4); }
               ;

typeSpecifier : KEYINT { $$ = type_create(TYPE_INTEGER,0,0); }
              | KEYVOID { $$ = type_create(TYPE_VOID,0,0); }
              ;

constDeclaration : KEYCONST typeSpecifier ID EQUAL simpleExpression SEMICOLON { $$ = const_decl_create($3, $2, $5); }
; 

funDeclaration : typeSpecifier ID OPARENT params CPARENT compoundStmt { $$ = func_decl_create($2,$1,$4,$6); }
;

params : paramList
       | KEYVOID { $$ = (struct param_list *) 0; }
       ;

paramList : paramList COLON param { $$ = insert_param($1,$3); }
          | param { $$ = $1; }
          ;

param : typeSpecifier ID { $$ = param_create($2,$1); }
      | typeSpecifier ID OBRACKETS CBRACKETS { $$ = param_array_create($2,$1); }
      ;

compoundStmt 
: OKEY localDeclarations statementList CKEY { $$ = compound_stmt_create(STMT_BLOCK,$2,$3); }
| OKEY localDeclarations CKEY { $$ = compound_stmt_create(STMT_BLOCK,$2,0); }
| OKEY statementList CKEY { $$ = compound_stmt_create(STMT_BLOCK,0,$2); }
| OKEY CKEY { $$ = compound_stmt_create(STMT_BLOCK,0,0); }
;

localDeclarations : localDeclarations varDeclaration { $$ = insert_decl($1,$2); }
                  | varDeclaration { $$ = $1; }
                  ;

statementList : statementList statement { $$ = insert_stmt($1,$2); } //@check
              | statement { $$ = $1;}
              ;

statement : expressionStmt
          | compoundStmt
          | selectionStmt
          | iterationStmt
          | returnStmt
          | forStmt
          ;

expressionStmt : expression SEMICOLON { $$ = stmt_create(STMT_EXPR,0,0,$1,0,0,0,0); }
               | SEMICOLON { $$ = stmt_create(STMT_EXPR,0,0,0,0,0,0,0); }
               ;

selectionStmt : KEYIF OPARENT expression CPARENT statement { $$ = if_create($3,$5); } %prec THEN
              | KEYIF OPARENT expression CPARENT statement KEYELSE statement { $$ = if_else_create($3,$5,$7); }
              ;

iterationStmt : KEYWHILE OPARENT expression CPARENT statement { $$ = while_create($3,$5); }
              ;


forStmt
: KEYFOR OPARENT expression SEMICOLON expression SEMICOLON expression CPARENT statement { $$ = for_create($3,$5,$7,$9); }
| KEYFOR OPARENT typeSpecifier expression SEMICOLON expression SEMICOLON expression CPARENT statement { $$ = for_create($4,$6,$8,$10); }
;

returnStmt : KEYRETURN SEMICOLON { $$ = stmt_create(STMT_RETURN,0,0,0,0,0,0,0); }
           | KEYRETURN expression SEMICOLON { $$ = stmt_create(STMT_RETURN,0,0,$2,0,0,0,0); }
           ;

expression : var EQUAL expression { $$ = expr_create(EXPR_ASSIGN,$1,$3); }
           | simpleExpression { $$ = $1; }
           ;

var : ID { $$ = expr_create_var($1); }
    | ID OBRACKETS expression CBRACKETS { $$ = expr_create_array($1,$3); }
    ;

simpleExpression : additiveExpression relop additiveExpression { $$ = expr_create($2,$1,$3); }
                 | additiveExpression
                 ;

relop : LESSEQUAL { $$ = EXPR_LTEQ; }
      | LESSTHAN { $$ = EXPR_LT; }
      | GREATERTHAN { $$ = EXPR_GT; }
      | GREATEREQUAL { $$ = EXPR_GTEQ; }
      | EQUALEQUAL { $$ = EXPR_EQ; }
      | NOTEQUAL { $$ = EXPR_NEQ; }
      ;

additiveExpression : additiveExpression addop term { $$ = expr_create($2, $1, $3); }
                   | term
                   ;

addop : PLUS { $$ = EXPR_ADD; }
      | MINUS { $$ = EXPR_SUB; }
      ;

term : term mulop factor { $$ = expr_create($2, $1, $3); }
     | factor
     ;

mulop : MULT { $$ = EXPR_MUL; }
      | DIVISION { $$ = EXPR_DIV; }
      ;

factor : OPARENT expression CPARENT { $$ = $2; }
       | var
       | call
       | NUM { $$ = expr_create_integer($1); }
       ;

call : ID OPARENT args CPARENT { $$ = expr_create_call($1,$3); }
;

args : argList
     | /* empty */ { $$ = (struct expr *) 0; }
     ;

argList : argList COLON expression { $$ = expr_create_arg($3,$1); }
        | expression { $$ = expr_create_arg($1,0); }
        ;

%%