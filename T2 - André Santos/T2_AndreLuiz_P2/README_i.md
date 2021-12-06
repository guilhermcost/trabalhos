# T2

Instruções para trabalho 2, analisador sintático para C-v1.1 
a partir do código da versão C-v1.0 (2020).


- Copie o arquivo c-v1.1.l do T1, de um dos membros da equipe, para a pasta criada para a equipe 
(criar uma pasta T2-nome1-nome2-nome3, se a equipe tiver 3 membros, 
onde nome1 é o primeiro nome, por exemplo).
- Faça adaptações necessárias no arquivo c-v1.1.l, para retornar tokens específicos para palavras-chave e
 símbolos (ao invés de KEY ou SYM);

- Altere o arquivo arquivo c-v1.1.y para colocar adicionar as regras de produção para C-v1.1.

- Use o script compile.sh, sem argumentos, para rodar flex, bison e gerar o analisador léxico
 e o sintático __cm__ para a linguagem C-v1.1.
- Use o script run.sh, que recebe dois argumentos: mult.in e mult.out, para fazer a análise sintática
do programa mult.in, e ver a saída em mult.out.
- Use o script run.sh com os casos de teste em /tests, 
lembrando sempre que o segundo argumento deve ter o nome do arquivo de entrada com extensão .out.
