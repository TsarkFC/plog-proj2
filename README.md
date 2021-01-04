# Wrong Products - Puzzle

2nd Project for the Logic Programming course 2020

## Instruções de Execução

Para execução, abrir o SICStus na pasta src/ e inserir:

`consult('wp.pl')`

**Para resolver um problema**

`solve([LowerLimit, UpperLimit], [Columns, Rows], Res)`,
sendo:

- LowerLimit: o valor mínimo que um número inserido na grelha pode tomar
- UpperLimit: o valor máximo que um número inserido na grelha pode tomar
- Columns: uma lista com os cabeçalhos das colunas
- Rows: uma lista com os cabeçalhos das linhas
- Res: a solução obtida pelo predicado

Os limites de problemas válidos vão normalmente de 1 a n, sendo n o número de linhas/colunas.

Problemas: 
```
[[7,5],[2,9]]   tabuleiro 2x2, limites: [1, 4]
[[19,11,4],[3,31,11]]   tabuleiro 3x3, limites: [1, 6]
[[34,3,23,11],[6,7,17,55]]   tabuleiro 4x4, limites: [1,8]
[[29,81,7,10,27],[11,29,73,8,23]]   tabuleiro 5x5, limites: [1, 10]
```

Exemplo:

`solve([1, 10], [[29,81,7,10,27],[11,29,73,8,23]], Res)`

**Para gerar um problema**

*De modo aleatório*
`generateRandom(BoardSize, Res)`,
sendo:

- BoardSize: o tamanho do tabuleiro (n), tendo o tabuleiro dimensões nxn    
- Res: o problema obtido pelo predicado 

*Utilizando a heurística implementada*
`generateHeuristic(BoardSize, Res)`,
sendo:

- BoardSize: o tamanho do tabuleiro (n), tendo o tabuleiro dimensões nxn    
- Res: a solução obtida pelo predicado

Para obter outros problemas, inserir ';' após a receção de um.

