%option noyywrap yylineno

%{ 
#include "c-v1.1.tab.h"
%}

%%

const                      { return KEY; }
else                       { return KEY; }
for                        { return KEY; }
if                         { return KEY; }
int                        { return KEY; }
return                     { return KEY; }
void                       { return KEY; }
while                      { return KEY; }
                             
[0-9]+                     { return NUM; }
[A-Za-z][A-Za-z0-9_]*      { return ID; }
("+"|"-"|"*"|"/")          { return SYM; }
("="|"<"|">")              { return SYM; }
("<="|">="|"=="|"!=")      { return SYM; }
(";"|",")                  { return SYM; }
("("|")"|"["|"]"|"{"|"}")  { return SYM; }

[ \t\n\r]+                 { /* no action */ }
"//".*                     { /* no action */ }

.                          { return ERROR; }

%%

int main(int argc, char **argv) {
    int token;

    while ((token = yylex())) {
        switch (token) {
         case ERROR:
            printf("(%d,ERROR,\"%s\")\n", yylineno, yytext);
            break;
         case NUM: 
            printf("(%d,NUM,\"%s\")\n", yylineno, yytext);
            break; 
         case ID: 
            printf("(%d,ID,\"%s\")\n", yylineno, yytext);
            break;
         case KEY:
            printf("(%d,KEY,\"%s\")\n", yylineno, yytext);
            break;
         case SYM: 
            printf("(%d,SYM,\"%s\")\n", yylineno, yytext);
            break;
        }
    }
}
