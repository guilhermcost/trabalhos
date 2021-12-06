#!/bin/bash

echo "rodando bison ..."
bison -d -v -Wcounterexamples c-v1.1.y

echo "rodando flex ..."
flex c-v1.1.l

echo "gerando o compilador cm para C-v1.0" 
echo
cc -o cm lex.yy.c c-v1.1.tab.c ast.c

echo "compilador cm criado." 
echo
echo "atenção: use o script run.sh, com dois argumentos, para executar o compilador cm:" 
echo
echo "./run.sh mult.c mult.out" 
echo

