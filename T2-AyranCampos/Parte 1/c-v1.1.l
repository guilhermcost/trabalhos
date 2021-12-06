%option noyywrap nodefault yylineno

%{ 

#include "c-v1.1.tab.h" 
int confirm = 0;
%}

%%

"//".*                      { /* no action */  }

const                       { return CONST;    }
else                        { return ELSE;     }
for                         { return FOR;      }
if                          { return IF;       }
int                         { return INT;      }
return                      { return RETURN;   }
void                        { return VOID;     }
while                       { return WHILE;    }

[a-zA-Z][a-zA-Z0-9_]*       { return ID;       }

[0-9]+                      { return NUM;      }

"+"                         { return SOMA;     }
"-"                         { return MINU;     }
"*"                         { return MULT;     }
"/"                         { return DIV;      }

"="                         { return EQ;       }
"<"                         { return LT;       }
">"                         { return GT;       }

"<="                        { return LTEQ;     }
">="                        { return GTEQ;     }
"=="                        { return DOUBLEQ;  }
"!="                        { return NOTEQ;    }

","                         { return COMMA;    }
";"                         { return SEMIC;    }


"("                         { return OPENP;    }
")"                         { return CLOSEP;   }
"["                         { return OPENCOL;  }
"]"                         { return CLOSECOL; }
"{"                         { return OPENCHA;  }
"}"                         { return CLOSECHA; }

" "*                        {  /* no action */  }
[ \t\n\r]+                  { /* no action */   }

.                           { confirm = 1; return ERROR;     }


%%

/*int main(int argc, char **argv) {
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
*/
