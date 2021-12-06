
/*André*/
%option noyywrap yylineno
%{ 
#include "c-v1.1.tab.h"
%}

%%

"//".*                      { /* no action */ }
"const"                     { return KEY; }
"else"                      { return KEY; }
"for"                       { return KEY; }
"if"                        { return KEY; }
"int"                       { return KEY; }
"return"                    { return KEY; }
"void"						{ return KEY; }
"while"						{ return KEY; }

"+"                   		{ return SYM; }    
"-"                   		{ return SYM; } 
"*"                   		{ return SYM; }     
"/"                   		{ return SYM; } 
"="                   		{ return SYM; } 
"<"                   		{ return SYM; }    
"<="                  		{ return SYM; }    
">"                   		{ return SYM; }    
">="                  		{ return SYM; }    
"=="                  		{ return SYM; } 
"!="                  		{ return SYM; }  
";"                   		{ return SYM; }
","                   		{ return SYM; }      
"("                   		{ return SYM; }    
")"                   		{ return SYM; }
"["                   		{ return SYM; }    
"]"                   		{ return SYM; }     
"{"                   		{ return SYM; }    
"}"                   		{ return SYM; } 
  
[A-Za-z]([A-Za-z_]|[0-9])*  { return ID; }
[0-9]+                      { return NUM; }

[ \t\n\r]+                  { /* no action */ }
.                           { return ERROR; }


%%

int main(int argc, char **argv) {
    int token;
	/*char *token_name[5] = {"KEY","SYM","ID","NUM", "ERROR"}*/
    while (  (token = yylex())  ) {
        switch (token) {
         case KEY:
            fprintf(stdout,"(%d ,KEY,\"%s\")\n", yylineno, yytext);
            break;
		 case SYM: 
            fprintf(stdout,"(%d,SYM,\"%s\")\n", yylineno, yytext);
            break;
		 case ID: 
            fprintf(stdout,"(%d,ID,\"%s\")\n", yylineno, yytext);
            break;
		 case NUM: 
            fprintf(stdout,"(%d,NUM,\"%s\")\n", yylineno, yytext);
            break; 	
		 case ERROR:
            fprintf(stdout,"(%d,ERROR,\"%s\")\n", yylineno, yytext);
            break;
                  
         
        }/*end switch*/
    }/*end while*/
}

