/* 
 * Equipe:
 * Alan Divino
 * Luca Argolo
 * Gabriela Lima
 */

%option noyywrap yylineno

%{ 
#include "c-v1.1.tab.h" 
%}

%%

"//".*                      { /* no action */ }

const                       { return CONST; }
else                        { return ELSE; }
for                         { return FOR; }
if                          { return IF; }
int                         { return INT; }
return                      { return RETURN; }
void                        { return VOID; }
while                       { return WHILE; }

[A-Za-z]([A-Za-z]|[0-9]|_)* { return ID; }
[0-9]+                      { yylval = atoi(yytext); return NUM; }

"+"                         { return PLUS; }
"-"                         { return MINUS; }
"*"                         { return MUL; }
"/"                         { return DIV; }
"="                         { return EQUAL; } 
"<"                         { return LT; }
">"                         { return GT; }
"<="                        { return LEQ; }
">="                        { return GEQ; }
"=="                        { return EQ; }
"!="                        { return DIF; }
";"                         { return SEMICOLON; }
","                         { return COMMA; }
"("                         { return OP; }
")"                         { return OC; }
"["                         { return LBRACKET; }
"]"                         { return RBRACKET; }
"{"                         { return LCBRT; }
"}"                         { return RCBRT; }

[ \t\n\r]+                  { /* no action */ }

.                           { return ERROR; }


%%
