/*
 * Definição  do flex.
 * Autores: João, Mauricio, Osmar
 */

%option nodefault noyywrap yylineno

%{
#include "c-v1.1.tab.h"

#define YY_USER_ACTION \
    yylloc.first_line = yylloc.last_line; \
    yylloc.first_column = yylloc.last_column; \
    for(int i = 0; yytext[i] != '\0'; i++) { \
        if(yytext[i] == '\n') { \
            yylloc.last_line++; \
            yylloc.last_column = 0; \
        } \
        else { \
            yylloc.last_column++; \
        } \
    }

int line_num = 1;
%}

%%

[\n]                        { line_num++; }

"//".*                      { ; } /* do nothing */

else                        { return KEYELSE; }
if                          { return KEYIF; }
int                         { return KEYINT; }
return                      { return KEYRETURN; }
void                        { return KEYVOID; }
while                       { return KEYWHILE; }
const                       { return KEYCONST; }
for                         { return KEYFOR; }
[A-Za-z]([A-Za-z]|[0-9])*   { return ID; }
[0-9]+                      { return NUM; }
"+"                         { return PLUS; }
"-"                         { return MINUS; }
"/"                         { return DIVISION; }
"*"                         { return MULT; }
";"                         { return SEMICOLON; }
"("                         { return OPARENT; }
")"                         { return CPARENT; }
"="                         { return EQUAL; }
"{"                         { return OKEY; }
"}"                         { return CKEY; }
"<"                         { return LESSTHAN; }
"<="                        { return LESSEQUAL; }
">"                         { return GREATERTHAN; }
">="                        { return GREATEREQUAL; }
"=="                        { return EQUALEQUAL; }
","                         { return COLON; }
"["                         { return OBRACKETS; }
"]"                         { return CBRACKETS; }
"!="                        { return NOTEQUAL; }

[ \t\r]+                    { ; } /* do nothing */

.                           { fprintf(stderr,
                              "\nErro léxico: caractere desconhecido \'%c\' na linha %d.\n",
                              *yytext, line_num);
                            }

%%

void yyerror(char *s) {
    printf("\nErro sintático: \"%s\" em \'%s\' próximo da linha %d.\n",
    s, yytext, yylloc.first_line);
}
