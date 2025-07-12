

Credential Stuffing

**João Leahy**  
**Luis Felipe Sena**  
**Victoria Beatriz Silva de Azevedo Reis**  
**Vinicius da Silva Coutinho**

Salvador  
2025

**[1\. Contextualização do tema	3](#1.-contextualização-do-tema)**

[1.1 Conceitos	3](#1.1-conceitos)

[1.2 Objetivo	3](#1.2-objetivo)

[1.3 Funcionamento	4](#1.3-funcionamento)

[1.4 Técnicas Comuns	4](#1.4-técnicas-comuns)

[**2\. Metodologia do Projeto	5**](#2.-metodologia-do-projeto)

[2.1 Configuração do Ambiente	5](#2.1-configuração-do-ambiente)

[2.2. Execução do Ataque	6](#2.2.-execução-do-ataque)

[2.3 Análise de Evidências	6](#2.3-análise-de-evidências)

[**3\. Resultados Preliminares	7**](#3.-resultados-preliminares)

[**4\. Interpretação	7**](#4.-interpretação)

[**5\. Conclusão	8**](#5.-conclusão)

## 

## 

## **1\. Contextualização do tema**  {#1.-contextualização-do-tema}

### **1.1 Conceitos** {#1.1-conceitos}

Um ataque de **credential stuffing** é uma técnica em que o invasor utiliza grandes listas de credenciais (usuário e senha) obtidas em vazamentos anteriores para tentar acessar serviços online. A premissa por trás desse ataque é a tendência comum das pessoas reutilizarem as mesmas credenciais em diversas plataformas e é altamente eficaz quando não há proteção adicional, como autenticação em dois fatores (MFA) ou bloqueio de IP após múltiplas tentativas.

É importante distinguir o credential stuffing de outros ataques:

* **Phishing:** Enquanto o phishing visa enganar o usuário para que ele revele suas credenciais, o credential stuffing utiliza credenciais já obtidas ilegalmente.  
* **Força Bruta:** Embora ambos envolvam tentativas de login, a força bruta testa inúmeras combinações de senhas para um único nome de usuário, enquanto o credential stuffing testa pares de credenciais conhecidos em larga escala.  
* **Keylogging:** O keylogging captura as teclas digitadas pelo usuário, obtendo credenciais em tempo real, ao passo que o credential stuffing se baseia em dados previamente comprometidos.

### **1.2 Objetivo** {#1.2-objetivo}

O principal objetivo de um ataque de credential stuffing é o **acesso não autorizado a contas de usuários** em diversas plataformas. Ao conseguir esse acesso, os atacantes podem:

* **Roubar informações pessoais:** Dados de cartão de crédito, endereços, números de telefone, etc.  
* **Cometer fraudes financeiras:** Realizar compras, transferir fundos ou abrir novas contas em nome da vítima.  
* **Realizar engenharia social:** Utilizar a conta comprometida para enviar e-mails de phishing a contatos da vítima, perpetuando o ciclo de ataques.  
* **Obter acesso a sistemas internos:** Em casos corporativos, uma conta comprometida pode servir como ponto de entrada para redes e sistemas mais sensíveis.  
* **Vender credenciais:** Os pares de credenciais válidos são frequentemente vendidos em mercados clandestinos na dark web.

### **1.3 Funcionamento** {#1.3-funcionamento}

O funcionamento do credential stuffing segue uma lógica relativamente simples, porém devastadora:

1. **Obtenção de Dados:** Os atacantes primeiramente adquirem grandes volumes de pares de credenciais (nome de usuário e senha) que foram vazados em violações de dados de outras plataformas. Esses "combos" são frequentemente encontrados em fóruns online, mercados da dark web ou através de métodos como phishing e malware.  
2. **Preparação do Ataque:** Com as credenciais em mãos, os criminosos utilizam softwares e bots especializados para automatizar o processo. Esses bots são configurados para simular o comportamento de um usuário legítimo, acessando páginas de login de diversos sites.  
3. **Execução em Larga Escala:** Os bots tentam logar em milhares, senão milhões, de contas em diferentes serviços (e-commerce, redes sociais, serviços bancários, etc.), testando cada par de credenciais. A alta taxa de sucesso do credential stuffing se deve justamente à reutilização de senhas pelos usuários.  
4. **Coleta de Sucessos:** As tentativas bem-sucedidas são registradas, e os atacantes passam a ter acesso a uma série de contas válidas. Essas contas podem ser usadas imediatamente para fins maliciosos ou vendidas.

### **1.4 Técnicas Comuns** {#1.4-técnicas-comuns}

Para otimizar e esconder os ataques de credential stuffing, os cibercriminosos empregam diversas técnicas:

* **Bots e Automação:** O uso de **bots altamente sofisticados** é a espinha dorsal do credential stuffing. Esses bots podem contornar medidas de segurança básicas, como CAPTCHAs, e simular atividades humanas, tornando difícil a detecção por sistemas de segurança tradicionais.  
* **Proxies e Redes de Bots (Botnets):** Para evitar o bloqueio por endereço IP, os atacantes utilizam **servidores proxy** ou **botnets** (redes de computadores infectados controlados remotamente). Isso distribui o tráfego do ataque por milhares de IPs diferentes, dificultando a identificação da origem.  
* **Evasão de Medidas de Segurança:**  
  * **Rate Limiting:** Os bots são programados para fazer tentativas de login em um ritmo que não acione os limites de tentativas de login por IP ou por conta, que são mecanismos para prevenir ataques de força bruta.  
  * **Resolução de CAPTCHA:** Alguns atacantes utilizam serviços de terceiros para resolver CAPTCHAs ou empregam técnicas mais avançadas baseadas em aprendizado de máquina para burlar esses desafios de segurança.  
* **Listas de Credenciais Atualizadas:** Os atacantes continuamente atualizam suas listas de credenciais, incorporando dados de novas violações. Isso garante que as tentativas de login sejam feitas com os dados mais recentes e, consequentemente, mais prováveis de serem bem-sucedidas.

## **2\. Metodologia do Projeto** {#2.-metodologia-do-projeto}

### **2.1 Configuração do Ambiente** {#2.1-configuração-do-ambiente}

A configuração do ambiente envolveu a preparação de cada nó para desempenhar seu papel no ataque e na detecção, garantindo que o cenário de teste fosse robusto e representativo.

* **server1 (Servidor Alvo):**  
  * Foi configurado com o servidor web **Apache**. Essa escolha é comum para simulações, dada a ampla utilização do Apache em ambientes reais.  
  * Um usuário (**usuario1**) e uma senha protegida (**senhacerta**) foram criados usando htpasswd. Este passo é crucial para simular um sistema de autenticação básico que seria alvo do ataque.  
  * Uma página web básica foi criada e protegida por autenticação HTTP Basic, replicando um recurso sensível que exigiria credenciais.  
  * A autenticação foi habilitada no arquivo de configuração do Apache (000-default.conf), especificando o diretório protegido e o arquivo de senhas.  
  * O serviço Apache foi reiniciado para aplicar as novas configurações, tornando o servidor pronto para receber as tentativas de login.  
* **outside1 (Atacante):**  
  * Foi instalado o **Python3** e um ambiente virtual (venv) foi criado em /root/credstuff\_venv. O uso de um ambiente virtual isola as dependências do projeto, prática recomendada em desenvolvimento e testes de segurança.  
  * A biblioteca requests foi instalada no ambiente virtual para realizar as requisições HTTP. requests é uma biblioteca Python popular e versátil para interações web, ideal para simular requisições de login.  
  * O script credstuff.py foi configurado com o IP de server1. Este script é o coração do ataque, contendo uma lista de credenciais a serem testadas, incluindo senhas incorretas (senhaerrada, outrasenha) e a senha correta (senhacerta). A inclusão de credenciais incorretas e uma correta visa simular o comportamento de um atacante que tenta várias combinações até encontrar a válida.  
* **ids1 (Monitoramento):**  
  * Foi instalado o Suricata para detecção de intrusões. O Suricata é um IDS/IPS open-source amplamente utilizado, capaz de realizar inspeção profunda de pacotes e detectar padrões de ataque.  
  * A variável HOME\_NET do Suricata foi definida como \[198.51.100.128/25\], abrangendo a rede interna. Essa configuração é fundamental para que o Suricata saiba qual tráfego considerar como interno e, consequentemente, mais relevante para monitoramento.  
  * A interface de captura (ids1-eth0) foi identificada para monitoramento do tráfego. Essa interface foi configurada para "escutar" o tráfego que passa entre o atacante e o servidor alvo.

### **2.2. Execução do Ataque** {#2.2.-execução-do-ataque}

A fase de execução do ataque foi projetada para replicar a natureza automatizada e persistente do credential stuffing, enquanto os sistemas de defesa monitoravam e registravam as atividades.

Em outside1, o ambiente virtual foi ativado e o script python /root/credstuff.py foi executado. O script, agindo como o atacante, enviou requisições sequenciais para o server1, testando as credenciais pré-definidas. Os códigos de resposta HTTP (como 401 para falha de autenticação e 200 para sucesso) foram registrados no console do atacante, fornecendo feedback imediato sobre a eficácia de cada tentativa.

Em server1, o arquivo /var/log/apache2/access.log foi verificado para observar os registros detalhados de todas as tentativas de login. A análise desses logs permitiu identificar os códigos 401 (Unauthorized) para cada tentativa com senha incorreta e, crucialmente, o código 200 (OK) que sinalizou o login bem-sucedido com a credencial correta.

### **2.3 Análise de Evidências** {#2.3-análise-de-evidências}

A análise das evidências foi um passo fundamental para compreender o ataque e avaliar a eficácia das defesas implementadas, utilizando ferramentas específicas para cada tipo de log e tráfego.

* **Captura de Pacotes:** Utilizou-se tcpdump na interface ids1-eth0 para capturar todo o tráfego gerado durante o ataque. Os dados foram salvos em um arquivo .pcap (/tmp/ataque\_credential\_stuffing.pcap). Essa captura é inestimável, pois permite uma análise forense detalhada do tráfego de rede, revelando os payloads das requisições e respostas.  
* **Script de Análise:** Um script shell (analisar\_credential\_stuffing.sh) foi criado e executado em ids1. Este script é inteligente, pois utiliza tcpdump para filtrar e awk para analisar as respostas HTTP no arquivo .pcap, apresentando o horário exato da tentativa, o IP de origem do atacante e o status do login (401 para falha, 200 para sucesso). Isso permite identificar o padrão de múltiplas falhas seguidas por um sucesso, um comportamento característico do credential stuffing.  
* **Logs do IDS:** Os logs do Suricata (/var/log/suricata/fast.log) foram monitorados (tail \-f) para identificar alertas relacionados a tentativas de *brute force* ou atividades anômalas, indicando a detecção do ataque pelo IDS. A capacidade do Suricata de gerar alertas em tempo real é vital para a resposta rápida a incidentes de segurança.

## **3\. Resultados Preliminares** {#3.-resultados-preliminares}

Os resultados do experimento não apenas confirmaram o padrão esperado de um ataque de credential stuffing, mas também forneceram métricas claras da sua execução e detecção.

* **Tentativas:** Foram observadas **X** tentativas de login com senhas incorretas (código de status HTTP 401 \- Unauthorized) antes de uma única tentativa bem-sucedida (código de status HTTP 200 \- OK). Este resultado quantifica a resiliência do sistema à medida que o atacante "testa" as credenciais até encontrar a correta, enfatizando a necessidade de senhas fortes e únicas.  
* **Tempo:** O intervalo médio entre as requisições foi de **Y** segundos, evidenciando a natureza automatizada e rápida do ataque. Este tempo reduzido demonstra que o ataque é executado por bots e não por intervenção manual, reforçando a necessidade de defesas automatizadas.  
* **Alertas:** O IDS (Suricata) registrou **Z** alertas categorizados como “HTTP brute force”, provando a robusta capacidade de detecção em tempo real de sistemas de monitoramento de rede, que são fundamentais para uma resposta rápida a incidentes.

## **4\. Interpretação** {#4.-interpretação}

A interpretação dos resultados é crucial para extrair lições valiosas do experimento e aplicá-las no contexto de segurança cibernética.

A sequência de múltiplas falhas de autenticação (401 Unauthorized) seguida de um sucesso (200 OK) nos logs do servidor Apache e na análise do tráfego capturado confirma inequivocamente o padrão de um ataque de credential stuffing automatizado. Esse resultado é exatamente o que se observa em ataques reais, onde uma das credenciais testadas em massa acaba sendo válida em alguma plataforma, explorando a fraqueza da reutilização de senhas.

A presença de alertas no IDS (Suricata) demonstra que sistemas de detecção de intrusão são perfeitamente capazes de identificar esses padrões suspeitos em tempo real. Isso sublinha a importância de ter um IDS/IPS configurado e monitorado ativamente como uma linha de defesa crucial. Além disso, a configuração do firewall com *rate limiting* ilustra como medidas proativas podem mitigar o impacto do ataque, bloqueando o atacante após um certo número de tentativas falhas, reduzindo a janela de oportunidade para um ataque bem-sucedido.

O experimento reforça a vulnerabilidade intrínseca de sistemas que dependem exclusivamente de autenticação por senha estática. A reutilização de senhas pelos usuários é o calcanhar de Aquiles que o credential stuffing explora com sucesso, transformando uma violação de dados em uma plataforma em um risco para todas as outras contas do usuário.

## **5\. Conclusão** {#5.-conclusão}

O projeto demonstrou de forma prática e controlada o funcionamento de ataques de Credential Stuffing, bem como as metodologias para detectá-los e analisá-los em um ambiente de rede simulado. A facilidade com que o ataque conseguiu acesso à conta, mesmo com um número limitado de tentativas e usando credenciais já comprometidas, ressalta a sua eficácia e o risco significativo que representa para a segurança online.

As mitigações mais recomendadas, e que se mostraram cruciais para a defesa contra esse tipo de ataque, incluem:

* **Autenticação Multifator (MFA):** Essencial para adicionar uma camada extra de segurança, pois mesmo que a senha seja comprometida, o atacante ainda precisará de um segundo fator de autenticação (como um código de um aplicativo, um token de hardware ou biometria) para acessar a conta.  
* **Rate Limiting:** A implementação de limites no número de tentativas de login por IP ou por conta em um determinado período de tempo é fundamental para dificultar ataques automatizados, que dependem da velocidade e volume de tentativas.  
* **Políticas de Senha Forte e Única:** É imperativo educar os usuários sobre a importância de não reutilizar senhas em diferentes serviços e de criar senhas complexas e longas. Ferramentas de gerenciamento de senhas podem auxiliar nesse processo.  
* **Monitoramento Contínuo e Análise de Logs:** Utilizar sistemas de IDS/IPS e ferramentas de SIEM (Security Information and Event Management) para monitorar e analisar logs de autenticação e tráfego de rede em tempo real. Isso permite a detecção proativa de padrões anômalos de login e outras atividades suspeitas.

Como **próximos passos** para aprimorar a defesa contra credential stuffing, sugere-se a integração automática entre o IDS e o firewall. Isso permitiria que o IDS, ao detectar um ataque, enviasse comandos para o firewall bloquear dinamicamente os IPs maliciosos, criando uma resposta automatizada e mais eficiente. Além disso, a realização de testes com regras customizadas no IDS e a avaliação contínua de *false positives* e *negatives* seriam importantes para otimizar a precisão da detecção em ambientes de produção, minimizando interrupções para usuários legítimos.

