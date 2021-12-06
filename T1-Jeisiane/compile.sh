#!/bin/bash

echo "rodando bison ..."
bison -d c-v1.1.y

echo "rodando flex ..."
flex c-v1.1.l

echo "gerando o compilador cm para C-v1.0" 
echo
cc -o cm lex.yy.c c-v1.1.tab.c

echo "compilador cm criado." 
echo

