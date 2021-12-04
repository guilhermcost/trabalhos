%option noyywrap nodefault yylineno
%{ 
#include "c-v1.1.tab.h"
%}

%%

"//".*			{ /* no action */ }

[a-zA-Z][a-zA-Z0-9_]*	{ return ID;}
[0-9]+			{ return NUM; }

const			{ return KEY; }
return			{ return KEY; } 
int			{ return KEY; }
void			{ return KEY; }
if 			{ return KEY; }
else			{ return KEY; }
for			{ return KEY; }
while			{ return KEY; }

"+"			{ return SYM; }    
"-"			{ return SYM; }  
"*"			{ return SYM; }      
"/"			{ return SYM; } 
"="			{ return SYM; }  
"=="			{ return SYM; } 
">"			{ return SYM; }  
">="			{ return SYM; } 
"<"			{ return SYM; } 
"<="			{ return SYM; } 
"!="			{ return SYM; }  
","			{ return SYM; }        
";"			{ return SYM; }  
"("			{ return SYM; }    
")"			{ return SYM; }    
"{"			{ return SYM; }    
"}"			{ return SYM; }    
"["			{ return SYM; }    
"]"			{ return SYM; }  

[ \n\t\r]+		{ /* no action */}
.			{return ERROR;}

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


