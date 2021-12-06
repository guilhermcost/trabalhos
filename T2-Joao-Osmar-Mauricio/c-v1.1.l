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

else                        { printf("(%d,KEYELSE,\"%s\")\n", yylineno, yytext); return KEYELSE; }
if                          { printf("(%d,KEYIF,\"%s\")\n", yylineno, yytext); return KEYIF; }
int                         { printf("(%d,KEYINT,\"%s\")\n", yylineno, yytext); return KEYINT; }
return                      { printf("(%d,KEYRETURN,\"%s\")\n", yylineno, yytext); return KEYRETURN; }
void                        { printf("(%d,KEYVOID,\"%s\")\n", yylineno, yytext); return KEYVOID; }
while                       { printf("(%d,KEYWHILE,\"%s\")\n", yylineno, yytext); return KEYWHILE; }
const                       { printf("(%d,KEYCONST,\"%s\")\n", yylineno, yytext); return KEYCONST; }
for                         { printf("(%d,KEYFOR,\"%s\")\n", yylineno, yytext); return KEYFOR; }
[A-Za-z]([A-Za-z]|[0-9])*   { printf("(%d,ID,\"%s\")\n", yylineno, yytext); return ID; }
[0-9]+                      { printf("(%d,NUM,\"%s\")\n", yylineno, yytext); return NUM; }
"+"                         { printf("(%d,PLUS,\"%s\")\n", yylineno, yytext); return PLUS; }
"-"                         { printf("(%d,MINUS,\"%s\")\n", yylineno, yytext); return MINUS; }
"/"                         { printf("(%d,DIVISION,\"%s\")\n", yylineno, yytext); return DIVISION; }
"*"                         { printf("(%d,MULT,\"%s\")\n", yylineno, yytext); return MULT; }
";"                         { printf("(%d,SEMICOLON,\"%s\")\n", yylineno, yytext); return SEMICOLON; }
"("                         { printf("(%d,OPARENT,\"%s\")\n", yylineno, yytext); return OPARENT; }
")"                         { printf("(%d,CPARENT,\"%s\")\n", yylineno, yytext); return CPARENT; }
"="                         { printf("(%d,EQUAL,\"%s\")\n", yylineno, yytext); return EQUAL; }
"{"                         { printf("(%d,OKEY,\"%s\")\n", yylineno, yytext); return OKEY; }
"}"                         { printf("(%d,CKEY,\"%s\")\n", yylineno, yytext); return CKEY; }
"<"                         { printf("(%d,LESSTHAN,\"%s\")\n", yylineno, yytext); return LESSTHAN; }
"<="                        { printf("(%d,LESSEQUAL,\"%s\")\n", yylineno, yytext); return LESSEQUAL; }
">"                         { printf("(%d,BIGGERTHAN,\"%s\")\n", yylineno, yytext); return BIGGERTHAN; }
">="                        { printf("(%d,BIGGEREQUAL,\"%s\")\n", yylineno, yytext); return BIGGEREQUAL; }
"=="                        { printf("(%d,EQUALEQUAL,\"%s\")\n", yylineno, yytext); return EQUALEQUAL; }
","                         { printf("(%d,COLON,\"%s\")\n", yylineno, yytext); return COLON; }
"["                         { printf("(%d,OBRACKETS,\"%s\")\n", yylineno, yytext); return OBRACKETS; }
"]"                         { printf("(%d,CBRACKETS,\"%s\")\n", yylineno, yytext); return CBRACKETS; }
"!="                        { printf("(%d,NOTEQUAL, \"%s\")\n", yylineno, yytext); return NOTEQUAL; }

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
