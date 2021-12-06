/*Isaque Copque e Caio Silva*/

%option noyywrap yylineno
%{ 
#include "c-v1.1.tab.h" 
%}

%%

"//".*                      { /* no action */ }
else                        { return ELSE; }
if                          { return IF; }
int                         { return INT; }
return                      { return RETURN; }
void                        { return VOID; }
while                       { return WHILE; }
const                       { return CONST; }
for                         { return FOR; }
[a-zA-Z][a-zA-Z0-9_]*       { yylval.name = strdup(yytext); return ID; }
[0-9]+                      { yylval.d = atoi(yytext); return NUM; }
"+"                         { return PLUS; }
"-"                         { return MINUS; }
"*"                         { return TIMES; }
"/"                         { return DIVIDE; }
"="                         { return ASSIGN; }
"<"                         { return LESS; }
">"                         { return MORE; }
"<="                        { return LESSEQUAL; }
">="                        { return MOREEQUAL; }
"=="                        { return EQUALS; }
"!="                        { return DIFFERENT; }
";"                         { return SEMICOLON; }
","                         { return COMMA; }
"("                         { return OPENPARENTHESES; }
")"                         { return CLOSEPARENTHESES; }
"["                         { return OPENBRACKET; }
"]"                         { return CLOSEBRACKET; }
"{"                         { return OPENBRACE; }
"}"                         { return CLOSEBRACE; }
[ \t\n]                       { /* no action */ }
.                           { return ERROR; }

%%