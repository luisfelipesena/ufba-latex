# MATA64 — Inteligência Artificial  
## Tarefa: Representação de Conhecimento em Prolog  
**Aluno(a):** Luis Felipe Sena **Matrícula:** 220115573  
**Data:** 26/09/2025

### 1) Domínio escolhido
O domínio modelado é **planejamento de viagens domésticas no Brasil**. Representamos cidades, rotas diretas entre pares de cidades (com **meio de transporte**, **tempo** e **custo**), além de **atributos**/atrações de cada destino (p.ex., praia, cultura) e **preferências** e **orçamentos** de viajantes. O objetivo é permitir **consultas dedutivas** para apoiar decisões como: “qual o meio mais barato/rápido?”, “esse destino é adequado ao meu perfil?”, “cabe no meu orçamento?”, “existe caminho em até duas pernas?”.

### 2) Modelagem (predicados)
- `cidade(Cidade).` — referência às cidades consideradas.  
- `atrativo(Cidade, Tipo).` — principal atributo do destino (p.ex., `praia`, `cultura`).  
- `prefere(Pessoa, Tipo).` / `orcamento(Pessoa, Valor).` — perfil do viajante e orçamento.  
- `rota(Origem, Destino, Meio, TempoHoras, CustoReais).` — **fatos** de rotas diretas cadastradas.  
- `conexao/5` — regra que torna a rota **simétrica** (ida/volta).  
- `ligado_direto/2`, `tem_voo_direto/2` — conectividade e voo direto.  
- `mais_barato/4`, `mais_rapido/4`, `custo_minimo/3`, `tempo_minimo/3` — **otimização** simples por custo/tempo (retorna todos os mínimos em caso de empate).  
- `pode_visitar/4` — respeita orçamento do viajante.  
- `destino_adequado/2` — combina preferência com atrativo do destino.  
- `recomendado/4` — recomendação básica (adequação + cabe no bolso + usa meio mais barato).  
- `itinerario_duas_pernas/7` — compõe duas conexões somando **tempo** e **custo**.  
- `viavel_por_tempo/5` — filtra rotas por um teto de duração.  
- `existe_caminho_em_duas_pernas/2`, `alcance_em_ate_duas_pernas/2` — alcançabilidade limitada.

> **Complexidade mínima**: a base contém **20+ fatos** (cidades, atrativos, preferências/orçamentos, rotas) e **14 regras**, atendendo e superando os requisitos do enunciado.

### 3) Como executar
1. Abra um interpretador Prolog (SWI‑Prolog, por exemplo).  
2. Carregue o arquivo:  
   ```prolog
   ?- [mata64_prolog_base].
   ```
3. Execute as consultas abaixo (ou outras de seu interesse).

### 4) Consultas demonstrativas (com respostas esperadas)
```prolog
% (1) Associação simples
?- atrativo(salvador, X).
X = praia.

% (2) Conexões Salvador–Recife
?- conexao(salvador, recife, M, T, C).
M = aviao,  T = 1.2, C = 650 ;
M = onibus, T = 10.5, C = 220.

% (3) Mais barato Salvador–Recife
?- mais_barato(salvador, recife, M, C).
M = onibus, C = 220.

% (4) Recomendação para Ana (prefere praia; orçamento 500), saindo de Salvador para Recife
?- recomendado(ana, salvador, recife, M).
M = onibus.

% (5) Itinerário em duas pernas: Salvador -> Rio -> São Paulo
?- itinerario_duas_pernas(salvador, rio, sao_paulo, M1, M2, T, C).
M1 = aviao, M2 = aviao,  T = 3.0, C = 1150 ;
M1 = aviao, M2 = onibus, T = 8.5, C = 930.

% (6) Viável por tempo (<= 2h) Salvador–Recife
?- viavel_por_tempo(salvador, recife, 2.0, M, T).
M = aviao, T = 1.2.

% (7) Existe voo direto Brasília–Salvador?
?- tem_voo_direto(brasilia, salvador).
true.

% (8) Custo mínimo Rio–São Paulo
?- custo_minimo(rio, sao_paulo, C).
C = 180.
```
_Obs.: em casos de empate, `mais_barato/4` e `mais_rapido/4` retornam todas as opções mínimas._

### 5) Observações finais
- A escolha por **duas pernas** limita a busca por percursos mais longos, o que mantém as regras simples e o custo computacional baixo para este exercício.  
- A simetria de `conexao/5` evita duplicar fatos de `rota/5` para ambos os sentidos.  
- Como extensão, seria possível incluir restrições de janela de tempo, escalas múltiplas, ou heurísticas (ex.: custo por hora).
