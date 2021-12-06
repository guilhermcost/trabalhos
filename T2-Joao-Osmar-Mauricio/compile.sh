#!/bin/bash

echo "rodando bison ..."
bison -v -d c-v1.1.y

echo "rodando flex ..."
flex c-v1.1.l

echo "gerando o compilador cm para C-v1.1" 
echo
cc -o cm lex.yy.c c-v1.1.tab.c

echo "compilador cm criado." 
echo
echo "atenção: use o script run.sh, com dois argumentos, para executar o compilador cm:" 
echo
echo "./run.sh input.c output.out" 
echo

