# Trabalho 2
Grupo: João Victor Carneiro, Maurício dos Santos, Osmar Oliveira 
Usuários Github: jvmcarneiro, oliveiraop, mauricio-sj

Disciplina: MATA61 2021.2 T01


## Parte 1
Utilizando como base os arquivos do [Trabalho 1](../T1-jvmcarneiro) de um dos componentes, o parser `c-v1.1.y` foi modificado para incluir as regras sintáticas da C-v1.1.
O arquivo léxico `c-v1.1.l` também foi modificado para acomodar as mensagens de erro do parser.


Concluídas as modificações, foram rodados os casos teste `teste.c` `test_expr.c` e os da pasta `tests-v1.1/inputs/` (com saídas salvas em `tests-v1.1/outputs/`).

Muitos dos testes da pasta `tests-v1.1/` pareciam ser exclusivamente testes léxicos e apresentaram erros na análise sintática, mas os que possuíam gramática semelhante à proposta por C-1.v1 foram compilados com sucesso.
Foram eles: `green-keyword-for.in`, `green-program-gcd.in`, `green-program-selection-sort.in`, `green-program-simple.in`, `green-program-sum.in` e `test-several-lines.in`.

A equipe tomou a liberdade de adicionar regras sintáticas para o `for` em `iterationStmt`, e `const` em `constDeclaration`.

## Execução

O script `run.sh` também foi modificado para receber opcionalmente apenas o argumento da entrada e criar automaticamente a pasta e extensão do arquivo de saída.
O intuito foi reduzir o trabalho para realizar os múltiplos testes.

Para compilar:

```
$ ./compile.sh
```

Para rodar os exemplos:

```
$ ./run.sh tests-v1.1/inputs/green-keyword-for.in tests-v1.1/outputs/green-keyword-for.out
```

Ou, com apenas um argumento (irá resultar no mesmo arquivo de saída):

```
$ ./run.sh tests-v1.1/inputs/green-keyword-for.in
```
