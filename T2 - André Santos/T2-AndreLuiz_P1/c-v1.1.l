
/*André*/
%option noyywrap yylineno

%{ 
#include "c-v1.1.tab.h"

#define DEBUG

%}

%%

"//".*                      { /* no action */ }
"const"                     { return CONST; }
"else"                      { return ELSE; }
"for"                       { return FOR; }
"if"                        { return IF; }
"int"                       { /*#ifdef DEBUG
								printf("token int na linha %d com valor %s\n", yylineno, yytext);
							#endif */
							return INT; }
"return"                    { /*#ifdef DEBUG
								printf("token return na linha %d com valor %s\n", yylineno, yytext);
							#endif */
							return RETURN; }
"void"						{ return VOID; }
"while"						{ return WHILE; }

"+"                   		{ return PLUS; }    
"-"                   		{ return MINUS; } 
"*"                   		{ return TIMES; }     
"/"                   		{ return DIV; } 
"="                   		{ /* #ifdef DEBUG
								printf("token ASSIGN na linha %d com valor %s\n", yylineno, yytext);
							#endif */
							return ASSIGN; } 
"<"                   		{ return LT; }    
"<="                  		{ return LE; }    
">"                   		{ return GT; }    
">="                  		{ return GE; }    
"=="                  		{ return EQUAL; } 
"!="                  		{ return NOTEQUAL; }  
";"                   		{ return SEMICOLON; }
","                   		{ return COMMA; }      
"("                   		{ return LP; }    
")"                   		{ return RP; }
"["                   		{ return LBRAK; }    
"]"                   		{ return RBRAK; }     
"{"                   		{ return LBRACE; }    
"}"                   		{ return RBRACE; } 
  
[A-Za-z]([A-Za-z_]|[0-9])*  { /*#ifdef DEBUG
								printf("token ID na linha %d com valor %s\n", yylineno, yytext);
							#endif */
							  return ID; }
[0-9]+                      { return NUM; }

[ \t\n\r]+                  { /* no action */ }
.                           { return ERROR; }


%%



