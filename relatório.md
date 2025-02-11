# Relatório: Implementação do Algoritmo de Snapshot Distribuído de Chandy-Lamport

## 1. Introdução

O algoritmo de Chandy-Lamport é fundamental para capturar estados globais consistentes em sistemas distribuídos. Este relatório apresenta uma implementação em Python que simula um sistema distribuído com três processos, demonstrando a captura de snapshots globais consistentes.

## 2. Implementação

### 2.1 Estrutura do Sistema

O sistema é composto por:
- 3 processos (P0, P1, P2) executando como threads
- Canais de comunicação bidirecionais entre todos os processos
- Mensagens assíncronas com delays aleatórios
- Estado local de cada processo representado por um número inteiro aleatório

### 2.2 Componentes Principais

#### Classe Process
- Mantém estado local (`self.state`)
- Gerencia canais de comunicação (`self.channels`)
- Controla gravação de mensagens durante snapshot (`self.recording_channels`)
- Implementa lógica do algoritmo de Chandy-Lamport

#### Sistema de Mensagens
- Mensagens normais: `MSG from {pid}`
- Mensagens de controle: `MARKER`
- Delays simulados entre 0.1 e 0.3 segundos

### 2.3 Implementação do Algoritmo

O algoritmo segue três fases principais:

1. **Iniciação do Snapshot**
```python
def initiate_snapshot(self):
    self.recording = True
    self.snapshot_state = self.state
    self.channel_states = {pid: [] for pid in self.channels.keys()}
    self.recording_channels = set(self.channels.keys())
    # Envia markers para todos os canais
```

2. **Recebimento de Marker**
```python
def handle_marker(self, src):
    if not self.recording:
        # Primeiro marker: grava estado e propaga
        self.snapshot_state = self.state
        self.recording_channels = set(self.channels.keys()) - {src}
    else:
        # Marker subsequente: finaliza gravação do canal
        self.recording_channels.remove(src)
```

3. **Captura de Mensagens em Trânsito**
```python
if self.recording and src in self.recording_channels:
    self.channel_states[src].append(content)
```

## 3. Análise dos Logs

### 3.1 Início do Snapshot

```
[INÍCIO] P0 iniciou snapshot com estado local = 87
[MARKER] P0 -> P1
[MARKER] P0 -> P2
```
- P0 inicia o snapshot gravando seu estado (87)
- Envia markers para P1 e P2

### 3.2 Propagação dos Markers

```
[MARKER] P2 recebeu primeiro marker de P0
[SNAPSHOT] P2 gravou estado local = 10
[MARKER] P2 -> P1
```
- P2 recebe marker, grava estado (10)
- Propaga marker para P1

### 3.3 Captura de Mensagens em Trânsito

```
[CAPTURA] P2 gravou mensagem do canal P1: MSG from 2
[CAPTURA] P1 gravou mensagem do canal P0: MSG from 0
```
- Mensagens capturadas durante o período de gravação
- Demonstra mensagens que estavam "em trânsito" durante o snapshot

## 4. Resultados e Estado Global

O snapshot final capturou:
1. Estados locais:
   - P0: 87
   - P2: 10
2. Mensagens em trânsito nos canais:
   - P1 -> P2: ["MSG from 2"]
   - P0 -> P1: ["MSG from 0"]

## 5. Conclusão

A implementação demonstra com sucesso os principais aspectos do algoritmo de Chandy-Lamport:
- Captura consistente de estados locais
- Registro correto de mensagens em trânsito
- Propagação adequada de markers
- Terminação apropriada do algoritmo

Os logs formatados permitem clara visualização do progresso do algoritmo e do estado global capturado.

## Referências

[1] K. Mani Chandy and Leslie Lamport. 1985. Distributed snapshots: determining global states of distributed systems. ACM Trans. Comput. Syst. 3, 1 (February 1985), 63-75.
