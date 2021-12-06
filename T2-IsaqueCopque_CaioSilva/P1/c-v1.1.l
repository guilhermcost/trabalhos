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
[a-zA-Z][a-zA-Z0-9_]*       { return ID; }
[0-9]+                      { return NUM; }
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

// int main(int argc, char **argv) {
//     int token;
//     while ((token = yylex())) {
//         switch (token) {
//          case ERROR:
//             printf("(%d,ERROR,\"%s\")\n", yylineno, yytext);
//             break;
//          case NUM: 
//             printf("(%d,NUM,\"%s\")\n", yylineno, yytext);
//             break; 
//          case ID: 
//             printf("(%d,ID,\"%s\")\n", yylineno, yytext);
//             break;
//          case KEY:
//             printf("(%d,KEY,\"%s\")\n", yylineno, yytext);
//             break;
//          case SYM: 
//             printf("(%d,SYM,\"%s\")\n", yylineno, yytext);
//             break;
//         }
//     }
// }
