/* Programa flex */

%option noyywrap nodefault yylineno

%{
#include "c-v1.1.tab.h"
%}

%%

"//".*                { /* no action */ }

const                 { return CONST; }
return                { return RETURN; } 
int                   { return INT; }
void                  { return VOID; }
if                    { return IF; }
else                  { return ELSE; }
for                   { return FOR; }
while                 { return WHILE; }

[a-zA-Z][a-zA-Z0-9_]* { return ID; }
[0-9]+                {yylval = atoi(yytext); return NUM;}

"+"                   { return PLUS; }    
"-"                   { return MINUS; }  
"*"                   { return MULT; }      
"/"                   { return DIV; } 
"="                   { return EQUAL; }  
"=="                  { return DOUBLEEQUAL; } 
">"                   { return BIGGER; }  
">="                  { return BIGGEREQUAL; } 
"<"                   { return SMALLER; } 
"<="                  { return SMALLEREQUAL; } 
"!="                  { return DIFFERENT; }  
","                   { return COMMA; }        
";"                   { return SEMICOLON; }  
"("                   { return OPENP; }    
")"                   { return CLOSEP; }    
"{"                   { return OPENK; }    
"}"                   { return CLOSEK; }    
"["                   { return OPENB; }    
"]"                   { return CLOSEB; }    
   
[ \n\t\r]+            { /* no action */ }
.                     { /* no action */ } 

%%

