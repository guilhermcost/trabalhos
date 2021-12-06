%{
/* includes, C defs */

#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include "ast-TEMP.h"

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

%union{
    struct decl *decl;
    struct stmt *stmt;
    struct expr *expr;
    struct type *type;
    struct param_list *plist;
    char *name;
    int d;
}

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

%token <name>ID

%token <d>NUM

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

%nonassoc EQ
%nonassoc NOTEQ
%nonassoc LT
%nonassoc GT
%nonassoc LTEQ    
%nonassoc GTEQ    

%type <decl>  program
%type <decl>  declaration-list declaration
%type <decl>  var-declaration fun-declaration const-declaration 
%type <decl>  local-declarations
%type <type>  type-specifier
%type <plist> params param-list param
%type <stmt>  compound-stmt
%type <stmt>  statement-list statement
%type <stmt>  selection-stmt iteration-stmt return-stmt
%type <stmt>  expression-stmt
%type <expr>  expression simple-expression
%type <expr>  additive-expression factor term call var
%type <expr>  args args-list
%type <d> relop mulop addop

%start program
%%

/*=============== Parte 1 ================*/
program: declaration-list { parser_result = $1; $$ = $1; }
       ;

declaration-list: declaration-list declaration { $$ = insert_decl($1,$2); }
                | declaration { $$ = $1; }
                ;

declaration: var-declaration
            | const-declaration
            | fun-declaration 
            ;

var-declaration: type-specifier ID SEMIC { $$ = var_decl_create($2,$1); }            
               | type-specifier ID OPENCOL NUM CLOSECOL SEMIC { $$ = array_decl_create($2,$1,$4); }
               ;

type-specifier: INT { $$ = type_create(TYPE_INTEGER, 0 , 0);}
              | VOID {$$ = type_create(TYPE_VOID, 0, 0); }
              ;

const-declaration: CONST type-specifier ID EQ NUM SEMIC { $$ = const_decl_create($3, $2, $5); }


/*================ Parte 2 ===============*/
fun-declaration: type-specifier ID OPENP params CLOSEP compound-stmt { $$ = func_decl_create($2,$1,$4,$6); }
               ;

params: param-list
      | VOID { $$ = (struct param_list *) 0; }
      ;

param-list: param-list COMMA param  { $$ = insert_param($1,$3); }
          | param { $$ = $1; }
          ;

param: type-specifier ID { $$ = param_create($2,$1); }
      | type-specifier ID OPENCOL CLOSECOL { $$ = param_array_create($2,$1); }
      ;

/*================ Parte 3 ===============*/
compound-stmt: OPENCHA local-declarations statement-list CLOSECHA { $$ = compound_stmt_create(STMT_BLOCK,$2,$3); }
            | OPENCHA local-declarations CLOSECHA { $$ = compound_stmt_create(STMT_BLOCK,$2,0); }
            | OPENCHA statement-list CLOSECHA { $$ = compound_stmt_create(STMT_BLOCK,0,$2); }
            | OPENCHA CLOSECHA { $$ = compound_stmt_create(STMT_BLOCK,0,0); }
            ;

local-declarations: local-declarations var-declaration { $$ = insert_decl($1,$2); }
                  | var-declaration   { $$ = $1; }
                  ;

statement-list:   statement-list statement { $$ = insert_stmt($1,$2); }
              |   statement { $$ = $1; }
              ;

statement: expression-stmt
         | compound-stmt
         | selection-stmt
         | iteration-stmt
         | return-stmt
         ;

expression-stmt: expression SEMIC { $$ = stmt_create(STMT_EXPR,0,0,$1,0,0,0,0); }
               | SEMIC          { $$ = stmt_create(STMT_EXPR,0,0,0,0,0,0,0); }
               ;

selection-stmt: IF OPENP expression CLOSEP statement { $$ = if_create($3,$5); }
              | IF OPENP expression CLOSEP statement ELSE statement { $$ = if_else_create($3,$5,$7); }
              ;

iteration-stmt: WHILE OPENP expression CLOSEP statement { $$ = while_create($3,$5); }
              | FOR OPENP expression SEMIC expression SEMIC expression CLOSEP statement { $$ = for_create($3,$5,$7,$9); }
              | FOR OPENP INT expression SEMIC expression SEMIC expression CLOSEP statement  { $$ = for_create($4,$6,$8,$10); }
              ;

return-stmt: RETURN SEMIC { $$ = stmt_create(STMT_RETURN,0,0,0,0,0,0,0); }
           | RETURN expression SEMIC { $$ = stmt_create(STMT_RETURN,0,0,$2,0,0,0,0); }
           ;

/*================ Parte 4 ===============*/
expression: var EQ expression { $$ = expr_create(EXPR_ASSIGN,$1,$3); }
          | simple-expression { $$ = $1; }
          ;

var: ID { $$ = expr_create_var($1); }
   | ID OPENCOL expression CLOSECOL { $$ = expr_create_array($1,$3); }
   ;

simple-expression: additive-expression relop additive-expression { $$ = expr_create($2,$1,$3); }
                  | additive-expression
                  ;

relop: DOUBLEQ { $$ = EXPR_EQ; }
     | NOTEQ { $$ = EXPR_NEQ; }
     | LT { $$ = EXPR_LT; }
     | GT { $$ = EXPR_GT; }
     | LTEQ { $$ = EXPR_LTEQ; }
     | GTEQ { $$ = EXPR_GTEQ; }

additive-expression: additive-expression addop term { $$ = expr_create($2, $1, $3); } 
                   | term
                   ;

addop: SOMA { $$ = EXPR_ADD; }
     | MINU { $$ = EXPR_SUB; }
     ;

term: term mulop factor  { $$ = expr_create($2, $1, $3); }
    | factor
    ;

mulop: MULT { $$ = EXPR_MUL; }
     | DIV { $$ = EXPR_DIV; }
     ;

factor: OPENP expression CLOSEP { $$ = EXPR_DIV; }
      | var
      | call
      | NUM { $$ = expr_create_integer($1); }
      ;

call: ID OPENP args CLOSEP  { $$ = expr_create_call($1,$3); }
    ;

args: args-list
    | { $$ = (struct expr *) 0; }
    ;


args-list: args-list COMMA expression { $$ = expr_create_arg($3,$1); }
         | expression { $$ = expr_create_arg($1,0); }
         ;


%%
/*
int main() {
     if (yyparse() == 0) {
           printf("===> Sem erros Lexicos ou Sintaticos <===\n");
     }
}*/