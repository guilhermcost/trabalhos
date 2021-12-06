%{
#include <stdlib.h>
#include <stdio.h>

void yyerror(const char* msg) {
      fprintf(stderr, "%s\n", msg);
}

int yylex();
%}

%token KEY
%token SYM
%token ID
%token NUM
%token ERROR

%%

program: /* empty */
;

%%

