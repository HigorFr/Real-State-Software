# Aura - Sistema de Gestão para Corretoras de Imóveis

**Aura** é um aplicativo multiplataforma desenvolvido como projeto da disciplina **Banco de Dados I**, ministrada pela professora **Patrícia Rufino Oliveira** na **EACH USP**.  
O sistema foi criado para atender **companias corretoras com grande volume de corretores**, oferecendo uma plataforma moderna e organizada para gestão imobiliária deles.

---

## Sistema

O objetivo do Aura é centralizar e automatizar o fluxo de trabalho de funcionário de uma corretora de imóveis, permitindo:

### Gestão de Imóveis e Contratos
- Cada corretor possui seu próprio painel.
- Visualização de todos os contratos firmados.
- Registro e acompanhamento de vendas e locações.

### Mapa Interativo de Imóveis
- Visão geográfica de todos os imóveis disponíveis na região.
- Pesquisa por localização, tipo, preço, tamanho e outros filtros combinados.

### Indicadores Financeiros
- Consulta de pagamentos realizados.
- Identificação de pagamentos atrasados.
- Análise de inadimplência/vacância com gráficos intuitivos.

### Painel Administrativo
- Gestão do perfil de cada corretor.
- Acompanhamento geral da operação da corretora.
- Organização dos dados de forma centralizada.

### Segurança
- Tela de login com autenticação segura e criptografada (hash).
- Armazenamento estruturado e otimizado no banco de dados do projeto.

---

## Instalação no Windows (Recomendado)

### **1. Baixe o pacote para Windows** 
Na aba **Releases**, baixe o arquivo aura-windows-release.zip
 
### **2. Extraia o conteúdo**
Descompacte o `.zip` em qualquer pasta.

O arquivo extraído conterá:
- `Aura.exe`  
- DLLs necessárias  
- Pasta `data` (assets e arquivos de configuração)

### **3. Execute**
Abra o arquivo aura.exe


---



## Instalação no Android

### **1. Baixe o APK**
Acesse a aba **Releases** do repositório e faça download do arquivo aura-android.apk

### **2. Instale no dispositivo**
No seu celular:
1. Abra o arquivo `.apk`
2. Aceite a instalação de fontes externas, se solicitado
3. Aguarde a instalação

### **3. Execute o app**
Procure por **Aura** na lista de aplicativos e abra normalmente.

---

## Instalação no Linux
## **1. Baixe o Release**
Acesse a aba **Releases** do repositório e faça download do arquivo aura-linux-release.zip

### **2. Extraia o conteúdo**
Descompacte o `.zip` em qualquer pasta.

### **3. Execute**
Dê permissão de execução ao arquivo: `chmod +x aura_frontend`

Execute o arquivo no terminal no mesmo diretório: `./aura_frontend`

## Lembrando que o backend é necessário

1. **Inicie o servidor PostgreSQL**  
   Certifique-se de que o PostgreSQL está rodando e acessível (localhost por padrão).

2. **Crie um banco de dados `imobiliaria`**  
   CREATE DATABASE imobiliaria;

3. **Rode o script de população fornecido em script.sql**  
    psql -U postgres -d imobiliaria -f script.sql

4. **Instale as dependências Python**  
    pip install -r requirements.txt

5. **Execute o servidor**  
    python main.py

**Observação**: Para funcionar a verificação com código de OTP, é necessário cadastrar um email e também uma senha de app de SMTP no Gmail (para enviar códigos de recuperação para o e-mail cadastrado). Isso pode ser feito no backend/main.py, alterando o campo 'MAIL_USERNAME', 'MAIL_DEFAULT_SENDER' e 'MAIL_PASSWORD'. No arquivo, estão alguns exemplos de e-mail e senha, mas que não funcionam diretamente (por motivos de segurança). Porém para as outras funcionalidades, isso não é necessário.

Uma outra observação é que tanto o backend quanto o frontend devem rodar na mesma máquina (porque o IP padrão é o localhost, 127.0.0.1) e a porta do backend é a 8000. Se forem usados portas em dispositivos diferentes, é necessário ajustar para o IP da rede local, o que pode ser ajustado no frontend recompilando os arquivos (no flutter) e mudando frontend/lib/core/api/constants.dart para o IP do backend.

O Python utilizado é o Python 3.8 para rodar o código do backend, mas testamos com o Python 3.14 e funcionou também.

