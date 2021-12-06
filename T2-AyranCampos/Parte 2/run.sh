bison -d c-v1.1.y
flex c-v1.1.l
cc -o cm lex.yy.c c-v1.1.tab.c ast-TEMP.c tp2-TEMP.c
 ./cm < teste.c