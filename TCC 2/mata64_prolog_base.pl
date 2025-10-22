% MATA64 - Inteligência Artificial
% Tarefa: Representação de Conhecimento em Prolog
% Domínio: Planejamento de viagens simplificado no Brasil
% Autor:  Luis Felipe Sena
% Data: 29/09/2025

% --------------------------
% Fatos
% --------------------------

% Cidades (opcional, apenas para referência)
cidade(salvador).
cidade(recife).
cidade(fortaleza).
cidade(brasilia).
cidade(rio).
cidade(sao_paulo).
cidade(belo_horizonte).
cidade(porto_alegre).

% Atrações/atributos de cada destino
atrativo(salvador, praia).
atrativo(recife, praia).
atrativo(fortaleza, praia).
atrativo(rio, praia).
atrativo(sao_paulo, cultura).
atrativo(brasilia, cultura).
atrativo(belo_horizonte, gastronomia).
atrativo(porto_alegre, vinho).

% Preferências e orçamento de viajantes
prefere(ana, praia).
orcamento(ana, 500).

prefere(bruno, cultura).
orcamento(bruno, 900).

prefere(carla, gastronomia).
orcamento(carla, 300).

prefere(diego, vinho).
orcamento(diego, 800).

% Rotas diretas (origem, destino, meio, tempo_em_horas, custo_em_reais)
rota(salvador, recife, aviao, 1.2, 650).
rota(salvador, recife, onibus, 10.5, 220).
rota(salvador, rio, aviao, 2.0, 750).

rota(rio, sao_paulo, aviao, 1.0, 400).
rota(rio, sao_paulo, onibus, 6.5, 180).

rota(sao_paulo, belo_horizonte, onibus, 7.0, 210).
rota(sao_paulo, belo_horizonte, aviao, 1.1, 350).

rota(brasilia, salvador, aviao, 1.7, 700).
rota(brasilia, belo_horizonte, onibus, 9.0, 300).
rota(brasilia, belo_horizonte, aviao, 1.0, 320).

rota(fortaleza, recife, onibus, 11.0, 240).
rota(fortaleza, salvador, aviao, 1.6, 700).

rota(porto_alegre, sao_paulo, aviao, 1.5, 500).
rota(porto_alegre, sao_paulo, onibus, 16.0, 300).

% --------------------------
% Regras (pelo menos 10)
% --------------------------

% 1-2) Conexão é simétrica: considera ida e volta a partir das rotas cadastradas
conexao(A,B,Meio,Tempo,Custo) :- rota(A,B,Meio,Tempo,Custo).
conexao(A,B,Meio,Tempo,Custo) :- rota(B,A,Meio,Tempo,Custo).

% 3) Há ligação direta entre duas cidades se existe ao menos uma conexão
ligado_direto(A,B) :- conexao(A,B,_,_,_).

% 4) Existe voo direto entre duas cidades?
tem_voo_direto(A,B) :- conexao(A,B,aviao,_,_).

% 5) O meio mais barato entre duas cidades (quebra empates retornando todos os mínimos)
mais_barato(O,D,Meio,Custo) :-
    conexao(O,D,Meio,_,Custo),
    \+ (conexao(O,D,Outro,_,C2), C2 < Custo).

% 6) O meio mais rápido entre duas cidades (quebra empates retornando todos os mínimos)
mais_rapido(O,D,Meio,Tempo) :-
    conexao(O,D,Meio,Tempo,_),
    \+ (conexao(O,D,Outro,Tempo2,_), Tempo2 < Tempo).

% 7) Custo mínimo absoluto entre duas cidades
custo_minimo(O,D,Custo) :- mais_barato(O,D,_,Custo).

% 8) Tempo mínimo absoluto entre duas cidades
tempo_minimo(O,D,Tempo) :- mais_rapido(O,D,_,Tempo).

% 9) Uma pessoa pode visitar (respeitando orçamento) usando certo meio
pode_visitar(Pessoa, Origem, Destino, Meio) :-
    orcamento(Pessoa, B),
    conexao(Origem, Destino, Meio, _, C),
    C =< B.

% 10) Um destino é adequado à pessoa se casa com sua preferência
destino_adequado(Pessoa, Destino) :-
    prefere(Pessoa, Tipo),
    atrativo(Destino, Tipo).

% 11) Recomendação simples: destino adequado + cabe no orçamento + use o meio mais barato
recomendado(Pessoa, Origem, Destino, Meio) :-
    destino_adequado(Pessoa, Destino),
    mais_barato(Origem, Destino, Meio, _),
    pode_visitar(Pessoa, Origem, Destino, Meio).

% 12) Itinerário com duas pernas (Origem -> Intermediária -> Destino)
itinerario_duas_pernas(O, I, D, M1, M2, TempoTotal, CustoTotal) :-
    conexao(O, I, M1, T1, C1),
    conexao(I, D, M2, T2, C2),
    TempoTotal is T1 + T2,
    CustoTotal is C1 + C2.

% 13) Rota viável por tempo máximo
viavel_por_tempo(O, D, Tmax, Meio, Tempo) :-
    conexao(O, D, Meio, Tempo, _),
    Tempo =< Tmax.

% 14) Existe caminho em até duas pernas (sem procurar caminhos longos)
existe_caminho_em_duas_pernas(O, D) :-
    conexao(O, I, _, _, _),
    conexao(I, D, _, _, _),
    O \= D.

alcance_em_ate_duas_pernas(O, D) :- ligado_direto(O, D).
alcance_em_ate_duas_pernas(O, D) :- existe_caminho_em_duas_pernas(O, D).

% --------------------------
% Exemplos de consultas (com respostas esperadas)
% (Podem ser copiados no seu interpretador Prolog)
% --------------------------
%
% 1) Associação simples:
% ?- atrativo(salvador, X).
% X = praia.
%
% 2) Listar conexões entre Salvador e Recife:
% ?- conexao(salvador, recife, M, T, C).
% M = aviao,  T = 1.2, C = 650 ;
% M = onibus, T = 10.5, C = 220.
%
% 3) Meio mais barato entre Salvador e Recife:
% ?- mais_barato(salvador, recife, M, C).
% M = onibus, C = 220.
%
% 4) Recomendação para Ana (prefere praia; orçamento 500) saindo de Salvador para Recife:
% ?- recomendado(ana, salvador, recife, M).
% M = onibus.
%
% 5) Itinerário em duas pernas: Salvador -> Rio -> São Paulo
% ?- itinerario_duas_pernas(salvador, rio, sao_paulo, M1, M2, T, C).
% M1 = aviao, M2 = aviao,  T = 3.0, C = 1150 ;
% M1 = aviao, M2 = onibus, T = 8.5, C = 930.
%
% 6) Viável por tempo (<= 2h) entre Salvador e Recife:
% ?- viavel_por_tempo(salvador, recife, 2.0, M, T).
% M = aviao, T = 1.2.
%
% 7) Existe voo direto Brasília–Salvador?
% ?- tem_voo_direto(brasilia, salvador).
% true.
%
% 8) Custo mínimo Rio–São Paulo:
% ?- custo_minimo(rio, sao_paulo, C).
% C = 180.
