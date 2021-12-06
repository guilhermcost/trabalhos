# T2

Instruções para trabalho 2, analisador sintático para C-v1.1 
a partir do código da versão C-v1.0 (2020).

- Copie o arquivo c-v1.1.l do T1, de um dos membros da equipe, para a pasta criada para a equipe (criar uma pasta T2-nome1-nome2-nome3, se a equipe tiver 3 membros, onde nome1 é o primeiro nome, por exemplo).
- Faça adaptações necessárias no arquivo c-v1.1.l, para retornar tokens específicos para palavras-chave e símbolos (ao invés de KEY ou SYM);
- Altere o arquivo arquivo c-v1.1.y para colocar adicionar as regras de produção para C-v1.1.
- Use o script compile.sh, sem argumentos, para rodar flex, bison e gerar o analisador léxico e o sintático __cm__ para a linguagem C-v1.1.
- Use o script run.sh, que recebe dois argumentos: mult.in e mult.out, para fazer a análise sintática do programa mult.in, e ver a saída em mult.out.
- Use o script run.sh com os casos de teste em /tests, lembrando sempre que o segundo argumento deve ter o nome do arquivo de entrada com extensão .out.

--- 

## Parte II: Análise Sintática

Nesta parte do projeto, você irá implementar um analisador sintático para a [linguagem C-](../../language/README.md) (v2.0) que construirá uma árvore sintática abstrata (AST - Abstract Syntax Tree) para programas C- corretos.
O Trabalho Prático 2 (TP2) deve incluir o analisador sintático, construído com a ferramenta bison, funções auxiliares para a construção da AST durante o processo de análise, uma função de _prettyprint_ para gerar uma representação externa para AST e um programa principal (detalhes a seguir).

<img src="./ast-parsetree.png" width="400">

O analisador sintático gerado pelo Bison, _yyparse()_, deve receber uma sequência de _tokens_ gerados pelo analisador léxico gerado pelo Flex, _yylex()_, e determinar se um programa C- v2.0 segue ou não a especificação definida por sua gramática.
Em caso de sucesso, o analisador sintático deve gerar uma AST para o programa de entrada analisado e disponibilizar uma referência para a raiz da AST. Em caso de erro sintático detectado, apenas uma mensagem de erro deverá ser reportada e a análise sintática deve ser interrompida.

Funções auxiliares para a criação e manipulação da AST e 
para a geração de uma representação usando a notação de _labelled bracketing_ 
(explicada mais adiante) para a AST retornada também fazem parte do TP2.

Antes de iniciar a sua implementação, recomendamos como leitura complementar os capítulos 5 e 6
do livro "Introduction to Compilers and Language Design" de Douglas Thain. 
Apesar da sintaxe de C- v2.0 ser um pouco diferente da usada no livro acima, os exemplos de código e o material são úteis. 
Outra consulta interessante é uma [especificação yacc para ANSI C](https://www.lysator.liu.se/c/ANSI-C-grammar-y.html) 
feita no século passado (década de 80). 
  
O analisador sintático para C- deverá ser desenvolvido com Bison, com base na 
especificação sintática de C- (v2.0) 
e integrado com o analisador léxico para C- v2.0 desenvolvido com Flex.
+ Material de referência: Introducing Bison.

### Notação para a Árvore Sintática Abstrata (Abstract Syntax Tree - AST)

Há diversas formas para representar árvores sintáticas corretas geradas para um programa C-. 
Em nosso projeto de compilador, é importante definir e usar um formato único para representar
a AST, que seja independente de qualquer linguagem específica, seja fonte ou objeto.

Em nosso projeto de compilador, para programas C- sem erros sintáticos, 
o analisador sintático construirá uma AST. 
Para mostrar a AST criada, o TP2 deve incluir um programa principal que "chama" a função _yyparse()_ 
que cria uma AST para programa C- sintaticamente corretos,
e depois chama uma função para gerar uma representação da AST retornada 
na notação de _labelled bracketing_. 
Essa notação define listas aninhadas de _prefix expressions_, usando colchetes ao invés de parênteses. 
Por exemplo, a expressão ``` 2 * 7 + 3``` mostrada acima,
é representada como ```[+ [* [2] [7]] [3]]``` na notação de _labelled bracketing_.
Cada número inteiro NUM, é representado como ```[NUM]```, por exemplo, ```[2] e [7]```, 
e a operação de multiplicação entre dois números, como ```[* [2] [7]]```.

__Formato Geral__:
```
[operator [operand1] ... [operandN]]
```

Recursivamente, cada operando pode contem outra operação, por exemplo,
```
[op1 [op2 [a] [b]] [c]]
```
onde o operador ```op1``` possui os operandos ```[op2 [a] [b]]``` e ```[c]```,  
e o operador ```op2``` tem como operandos ```[a]``` e ```[b]```. 

Assim, a AST para a expressão ``` 2 * 7 + 3```  
deve ser representada como ```[+ [* [2] [7]] [3]]``` na notação de _labelled bracketing_.


### Listas de nós que podem ser mostrados na AST (ainda v1.0) / v2.0 em andamento.

Tipos de nós que podem aparecem em uma AST e seus nomes correspondentes, 
que deverão ser produzidos pelo seu analisador sintático:  

```[program  ... ]```

* ```[const-declaration  ... ]```

   * [int]                ---> nome do tipo 

   * [ID]                 ---> nome da constante

   * [NUM]                ---> valor da constante


* ```[var-declaration  ... ]```

   * [int]                ---> nome do tipo 

   * [ID]                 ---> nome de variável

   * ```[\[\]]```               ---> (opcional) símbolo para descrever uma váriavel como array; IMPORTANTE: o símbolo de barra invertida (backslash \) é usado para não interpretar [ ou ] como nós de colchetes, mas para serem símbolos visíveis na AST.

* ```[enum-var-declaration  ... ]```

   * [ID]                 ---> nome do tipo enumerado

   * [ID]                 ---> nome da variável

* ```[fun-declaration  ... ]```

   * [int] / [void]       ---> o tipo int ou o tipo void 

   * [ID]                 ---> nome de função

   * [params  ...  ]      ---> gerar apenas [params], se não houver parâmetros na função

      * [param  ... ]     ---> (opcional) informação sobre parâmetro

         * [int]           ---> o tipo int

         * [ID]                 ---> nome de variável

   * ```[compound-stmt  ... ]```     ---> (opções de filhos abaixo)

   - [;]                             ---> comando vazio

   - ```[selection-stmt ... ]```     ---> ou comando IF 
   
      * ver EXPRESSION             ---> definição recursiva de qualquer expressão válida 

      * [compound-stmt  ...]       --> ramo "then" (true) 

      * [compound-stmt  ... ]      --> (opcional) ramo "else" (false) 

   - ```[iteration-stmt  ... ]```  --> apenas "while"

      * ver EXPRESSION              --> definição recursiva de qualquer expressão válida

      * [compound-stmt ... ]        --> bloco de comandos do while (statements)

   - ```[return-stmt ... ]```

      * ver EXPRESSION             --> definição recursiva de qualquer expressão válida

   - ```[OP ... ]```              --> operadores de expressão binária 
     ```OP pode ser +, -, *, /, <, <=, >, >=, ==, !=, =``` 

      * [var  ... ]      ---> uso de variável

         * [ID]

         * [NUM]     --> (opcional) índice de array 

      * [const [ID]]      ---> uso de constante definida pelo usuario

      * [NUM]             ---> uso de valor (literal) do tipo integer

      * [call  ... ]      ---> chamada (call) de função

         * [ID]

         * [args ... ]         ---> argumentos de função

            * [var ... ]   

            * [NUM]      

            * [call ... ]   

            * [OP ... ]        ---> expressão binária ou unária

      * [OP ... ]              ---> recursivamente outra expressão binária


### Novos Tipos de Nós (v2.0)

TBD (exercício no Classroom da disciplina).

* ```[const-declaration  ... ]```
* comando for

e outras definições/ adaptações para lidar com os novos elementos introduzidos na versão de C-v1.1.

### Bison e Flex

O Bison deverá ser utilizado para geração do analisador sintático, 
trabalhando em conjunto com o analisador léxico gerado pelo Flex (Trabalho Prático 1).

```$ bison -d c-v1.1.y```

A opção -d faz com que o Bison gere o arquivo _c-v1.1.tab.h_, que faz a interface com o analisador léxico gerado
pelo Flex.

O arquivo flex deverá se chamar _c-v1.1.l_.
Ele deverá ser alterado para incluir o arquivo "c-v1.1.tab.h", gerado pelo Bison. 
Todo o código usado para definir tokens, por exemplo, listas ou tipos escalares, usados no TP1 devem ser eliminados. 
Os tokens serão definidos no arquivo _c-v1.1.y_, usando a diretiva ```%token```.
Também deve ser eliminado o código C usado para chamar a função yylex() 
e gerar o arquivo de saída com triplas solicitado no TP1.

Em seguida, rodar o Flex (observar o novo nome):

```$ flex c-v1.1.l```

Por fim, compilar e gerar o executável, supondo que as funções da AST estão no arquivo _ast.c_ 
e que o programa principal e função para geração de saída no formato _labelled bracket_  estão em _tp2.c_ 

```$ cc -o tp2 c-v1.1.tab.c lex.yy.c ast.c tp2.c -ll```

### Como executar o analisador sintático
   
No TP2, não usaremos nomes de arquivos passados como argumentos. 
Trabalharemos com redirecionamento e uso de entrada e saída padrão.
Um programa principal deve chamar a função _yyparse()_ e passar a raiz da AST retornada, 
como entrada para uma função (pode ser chamada de _prettyprint_, por exemplo)
que percorrerá a AST para gerar sua representação na notação _labelled bracket_.
Em caso de erro sintático identificado, o mesmo será reportado e a análise interrompida, sem geração de AST.

```$ ./tp2 < main.in > main.out```, sendo que _main.in_ contém o programa C- v1.1 e _main.out_ contém a AST na notação _labelled bracket_.

**Observação**:  Atenção para os nomes usados no TP2.
- O nome do arquivo Flex deve ser c-v1.1.l
- O nome do arquivo Bison deve ser c-v1.1.y 
- Manter os nomes ast.h e ast.c para definição e manipulação da AST
- O nome do arquivo que contém a função _main_ deve ser tp2.c.

### Exemplo de arquivo de entrada em C- (main.in)

```
int g;

int foo(int x, int y, int z[]) {

    z[0] = 0;
    y = x * y + 2;

    if(y == 0){
        y = 1;
    }

    return y;

}

void main(void) {

    int a[10];

    while(g < 10){
        g = foo(g, 2, a);
        ;
    }
}
```

### Exemplo de arquivo de saída após análise sintática do programa C- (main.out)

Importante: Caracteres de espacejamento serão ignorados na correção automática.

```
[program 
  [var-declaration [int] [g]]
  [fun-declaration 
    [int]
    [foo] 
    [params 
      [param [int] [x]] 
      [param [int] [y]] 
      [param [int] [z] [\[\]]]
    ]
    [compound-stmt 
      [= [var [z] [0]] [0]]
      [= [var [y]] 
        [+ 
          [* [var [x]] [var [y]]] [2]]]
      [selection-stmt 
        [== [var [y]] [0]]
        [compound-stmt 
          [= [var [y]] [1]]
        ]
      ]
      [return-stmt [var [y]]]
    ]
  ]
  [fun-declaration 
    [void]
    [main]
    [params]
    [compound-stmt 
      [var-declaration [int] [a] [10]]
      [iteration-stmt 
        [< [var [g]] [10]]
        [compound-stmt 
          [= [var [g]] 
            [call
              [foo]
              [args [var [g]] [2] [var [a]]]
            ]]
          [;]
        ]
      ]
    ]
  ]
  
  
]
```

### Ilustração de AST gerada com a ferramenta [RSyntaxTree](https://yohasebe.com/rsyntaxtree/)

![AST](./AST_rsyntaxast.png)

## Outro Exemplo
### C- (entrada)

```
int a;
int const min = 0;
enum rgb {red,green,blue};
enum rgb color;
void main(void) {
   a = min;
   color = red;
}
```

### Saída

```
[program
  [var-declaration [int][a]]
  [const-declaration [int][min][0]]
  [enum-type-declaration [rgb]
    [enum_consts 
      [enum-const [red]]
      [enum-const [green]]
      [enum-const [blue]]
    ]
  ]
  [enum-var-declaration [rgb][color]]
  [fun-declaration 
    [void]
    [main]
    [params]
    [compound-stmt 
       [= [var [a]] [const [min]]]
       [= [var [color]] [const [red]]
     ]
   ]
]

```

## Correção

A correção do TP2 irá considerar apenas os arquivos colocados no repositório da equipe, 
nas pastas indicadas na especificação do trabalho.
A correção automática do TP2 será feita com o apoio de scripts de correção, 
assumindo entrada e saída padrão, e os nomes de arquivos indicados acima.

--------
Traduzido e adaptado a partir do material do Prof. Vinicius Petrucci em outubro/2020 por Christina von Flach.
<!-- https://ruslanspivak.com/lsbasi-part1/ -->
