"-"                         { return MINUS; }
"*"                         { return MUL; }
"/"                         { return SLASH; }
"="                         { return EQUAL; }
"<"                         { return LESS; }
">"                         { return GREATER; }
"<="                        { return LESSEQUAL; }
">="                        { return GREATEREQUAL; }
"=="                        { return EQUALEQUAL; }
"!="                        { return DIFF; }
";"                         { return SEMICOLON; }
","                         { return COMMA; }
"("                         { return OP; }
")"                         { return CP; }
"["                         { return OB; }
"]"                         { return CB; }
"{"                         { return OBRACES; }
"}"                         { return CBRACES; }

[ \t\n\r]+                  { /* void */ }

.                           { return ERROR; }


%%
