%option noyywrap yylineno
%{ 
#include "c-v1.1-old.tab.h" 
%}

%%

"//".*                      { /* no action */ }
const                       { return CONST; }
else                        { return ELSE; }
for                      { return FOR; }
if                          { return IF; }
int                         { return INT; }
return                      { return RETURN; }
void                        { return VOID; }
while                       { return WHILE; }
[A-Za-z]([A-Za-z]|[0-9]|"_")*   { return ID; }
[0-9]+                      { yylval = atoi(yytext); return NUM; }
"+"			     { return PLUS;}
"-"			     { return MINUS;}
"*"			     { return TIMES;}
"/"			     { return DIVIDE;}
"="			     { return EQUAL;}
"<"			     { return LT;}
">"			     { return GT;}
"<="			     { return LTEQ;}
">="			     { return GTEQ;}
"=="			     { return ISEQUAL;}
"!="			     { return DIFFERENT;}
";"			     { return SEMICOLON;}
","			     { return COMMA;}
"("			     { return OPENP;}
")"			     { return CLOSEP;}
"["			     { return OPENSQUARE;}
"]"			     { return CLOSESQUARE;}
"{"			     { return OPENCURLY;}
"}"			     { return CLOSECURLY;}
[ \t\n]                       { /* no action */ }
.                           { return ERROR; }


%%
/*
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
}*/

