%option noyywrap yylineno
%{
#include "c-v1.1.tab.h"
%}

%%

"//".*                      { /* no action */ }

const                       { return CONST; }
else                        { return ELSE; }
for                          { return FOR; }
if                          { return IF; }
int                         { return INT; }
void                        { return VOID; }
return                      { return RETURN; }
while                       { return WHILE; }


[A-Za-z]([A-Za-z_]|[0-9])*   { yylval.name = strdup(yytext); return ID; }
[0-9]+                      { yylval.d = atoi(yytext); return NUM; }

"+"                         { return '+'; }
"-"                         { return '-'; }
"*"                         { return '*'; }
"/"                         { return '/'; }
"="                         { return '='; }

"<"                         { return LT; }
"<="                        { return LTEQ; }
">"                         { return GT; }
">="                        { return GTEQ; }
"=="                        { return EQ; }
"!="                        { return NEQ; }

";"                         { return ';'; }
","                         { return ','; }

"("                         { return '('; }
")"                         { return ')'; }
"["                         { return '['; }
"]"                         { return ']'; }
"{"                         { return '{'; }
"}"                         { return '}'; }

[ \t\n]                       { /* no action */ }

.                           { /* no action */ }


%%
