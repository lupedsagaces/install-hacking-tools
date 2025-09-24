# install-hacking-tools
## Pentest & Bug Bounty Toolkit Installer

Este é um script de instalação automatizado para configurar rapidamente um ambiente completo de **pentest** e **bug bounty** em sistemas Linux. Ele instala diversas ferramentas populares, configura diretórios úteis e baixa wordlists essenciais para testes de segurança.

---

## 🚀 Funcionalidades

- Instalação de ferramentas Go para **reconhecimento, fuzzing e exploração**:
  - `subfinder`, `naabu`, `httpx`, `katana`, `nuclei`, `notify`, etc.
- Ferramentas específicas para **teste de XSS**:
  - `gau`, `uro`, `Gxss`, `dalfox`
- Ferramentas extras de suporte:
  - `ffuf`, `gobuster`, `waybackurls`, `assetfinder`, `httprobe`, `qsreplace`, `meg`, `gf`, `amass`, `subjack`
- Download de **wordlists úteis**
- Criação de diretórios para organização de scripts, wordlists e resultados de reconhecimento.
- Configuração automática do `$GOPATH/bin` no `PATH`.

---

## 📋 Pré-requisitos

- Linux (Ubuntu/Debian recomendado)
- `Go` instalado (versão mínima necessária para algumas ferramentas: 1.21)
- `pipx` (para instalar ferramentas Python como `uro`)
- Dependências de sistema: `libpcap-dev`, `curl`, `wget`, `git`, `build-essential`, `pkg-config`

---

## ⚙️ Como usar

1. **Baixe o script:**

`git clone https://github.com/lupedsagaces/install-hacking-tools.git`
`cd seu-repositorio`

Dê permissão de execução:

`chmod +x install-tools.sh`

Execute o script:

`./install-tools.sh`

O script irá instalar todas as ferramentas, criar diretórios úteis e baixar wordlists essenciais.

📂 Diretórios criados

~/tools/wordlists – wordlists baixadas

~/tools/scripts – para seus scripts

~/recon – para resultados de reconhecimento

🛠️ Uso das ferramentas
Após a instalação, carregue o PATH atualizado:

`source ~/.bashrc`

Ou reinicie o terminal.

Exemplo de teste de uma ferramenta:

`subfinder -d example.com`

--- 

## 🎯 Ferramentas incluídas
Categoria	Ferramentas
Recon / DNS	subfinder, naabu, amass, assetfinder
HTTP & URLs	httpx, katana, waybackurls, httprobe, meg, qsreplace
Vulnerability scanning	nuclei, notify
Fuzzing	ffuf, gobuster
XSS / web exploitation	gau, uro, Gxss, dalfox
Subdomain takeover	subjack
Utility	anew, unfurl, gf

--- 

## 💡 Observações
Algumas ferramentas exigem versões específicas do Go. O script verifica automaticamente.

Para ferramentas Python, o pipx é utilizado para isolamento.

Wordlists baixadas são provenientes do SecLists.
