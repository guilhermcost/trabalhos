/* 
 * Definição flex.
 * Autores: Natan Moura, Pedro Augusto
 */

%option noyywrap nodefault yylineno

%{
#include "c-v1.1.tab.h"
%}

%%

"//".*                { /* void */ }

const                 { return CONST; }
else                  { return ELSE; }
for                   { return FOR; }
if                    { return IF; }
int                   { return INT; }
return                { return RETURN; } 
void                  { return VOID; }
while                 { return WHILE; }

[0-9]+                { return NUM; }

[a-zA-Z][a-zA-Z0-9_]* { return ID; }

"+"                   { return ADD; }    
"-"                   { return SUB; }    
"/"                   { return DIV; }    
"*"                   { return MUL; }    
";"                   { return SC; }    
"("                   { return LP; }    
")"                   { return RP; }    
"="                   { return EQUAL; }    
"{"                   { return LK; }    
"}"                   { return RK; }    
"<"                   { return LT; }    
"<="                  { return LEQ; }    
">"                   { return GT; }    
">="                  { return GEQ; }    
"=="                  { return CMP; }    
","                   { return COMMA; }    
"["                   { return LSB; }    
"]"                   { return RSB; }    
"!="                  { return DIFF; }    

[ \n\t\r]+            { }
.                     {return ERROR;}

%%

/*int main(int argc, char **argv) {
    int token;

    char *token_name[5] = {"KEY", "NUM", "ID","SYM","ERROR"};

    while ((token = yylex())) {
       fprintf(stdout,"(%d", yylineno);
       fprintf(stdout,",%s", token_name[token-258]);
       fprintf(stdout,",\"%s\")\n", yytext);
    }
}*/
