/* A Bison parser, made by GNU Bison 3.8.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2021 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

#ifndef YY_YY_C_V1_1_TAB_H_INCLUDED
# define YY_YY_C_V1_1_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token kinds.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYEMPTY = -2,
    YYEOF = 0,                     /* "end of file"  */
    YYerror = 256,                 /* error  */
    YYUNDEF = 257,                 /* "invalid token"  */
    ID = 258,                      /* ID  */
    CONST = 259,                   /* CONST  */
    NUM = 260,                     /* NUM  */
    ERROR = 261,                   /* ERROR  */
    ELSE = 262,                    /* ELSE  */
    FOR = 263,                     /* FOR  */
    IF = 264,                      /* IF  */
    INT = 265,                     /* INT  */
    RETURN = 266,                  /* RETURN  */
    VOID = 267,                    /* VOID  */
    WHILE = 268,                   /* WHILE  */
    PLUS = 269,                    /* PLUS  */
    MINUS = 270,                   /* MINUS  */
    TIMES = 271,                   /* TIMES  */
    DIV = 272,                     /* DIV  */
    ASSIGN = 273,                  /* ASSIGN  */
    LT = 274,                      /* LT  */
    LE = 275,                      /* LE  */
    GT = 276,                      /* GT  */
    GE = 277,                      /* GE  */
    EQUAL = 278,                   /* EQUAL  */
    NOTEQUAL = 279,                /* NOTEQUAL  */
    SEMICOLON = 280,               /* SEMICOLON  */
    COMMA = 281,                   /* COMMA  */
    LP = 282,                      /* LP  */
    RP = 283,                      /* RP  */
    LBRAK = 284,                   /* LBRAK  */
    RBRAK = 285,                   /* RBRAK  */
    LBRACE = 286,                  /* LBRACE  */
    RBRACE = 287                   /* RBRACE  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 24 "c-v1.1.y"

    struct decl *decl;
    struct stmt *stmt;
    struct expr *expr;
    struct type *type;
    struct param_list *plist;
    char *name;
    int d;
	enum expr_t  *expr_type;
	

#line 108 "c-v1.1.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;


int yyparse (void);


#endif /* !YY_YY_C_V1_1_TAB_H_INCLUDED  */
