/**

Trabalho 2/ Parte 1 - Compiladores
Caroline Alves, Jeisiane Macedo

**/

%option noyywrap yylineno
%{ 
#include "c-v1.1.tab.h"
extern int yyparse();
%}

%%

"//".*                      { /* no action */ }
else                        { return ELSE; }
if                          { return IF; }
int                         { return INT; }
return                      { return RETURN; }
const                       { return CONST; }
void                        { return VOID; }
while                       { return WHILE; }
for                         { return FOR; }
[A-Za-z]([A-Za-z]|[0-9])*   { return ID; }
[0-9]+                      { yylval = atoi(yytext); return NUM; }

"+"                         { return PLUS; }
"-"                         { return MINUS; }
"*"                         { return MULT; }
"/"                         { return DIV; }
"="                         { return EQUAL; }
";"                         { return SCOLON; }
"("                         { return OP; }
")"                         { return CP; }
"{"                         { return OC; }
"}"                         { return CC; }
"["                         { return OB; }
"]"                         { return CB; }
"<"                         { return LT; }
">"                         { return GT; }
"<="                        { return LTEQ; }
">="                        { return GTEQ; }
"=="                        { return EQEQ; }
"!="                        { return NEQ; }
","                         { return COMMA; }

[ \t\n]                     { /* no action */ }
.                           { return ERROR; }


%%

int main(int argc, char **argv) {
   
  if(yyparse()== 0)
    printf("Sintaxe correta\n");
  else
    printf("Sintaxe incorreta\n");

}

