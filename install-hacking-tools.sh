#!/bin/bash
# Script de instalação completo para ferramentas de pentest/bug bounty
# Ativar modo de depuração
set -x

# Arquivo para erros
LOG_ERROS="$HOME/install_errors.log"
> "$LOG_ERROS"   # limpa o arquivo a cada execução

# Cores para output
VERDE="\e[38;5;82m"
VERMELHO="\e[31m"
AZUL="\e[34m"
RESET="\e[0m"

echo -e "${VERDE}[+] Iniciando instalação das ferramentas de pentest...${RESET}"

# Função para verificar a versão do Go
check_go_version() {
    required_version=$1
    current_version=$(go version | awk '{print $3}' | cut -d 'o' -f 2)
    if [ "$(printf '%s\n' "$required_version" "$current_version" | sort -V | head -n1)" != "$required_version" ]; then
        echo -e "${VERMELHO}Go version $required_version or higher is required. Please update your Go installation.${RESET}"
        exit 1
    fi
}

# Função para instalar programas Go
install_go_program() {
    package=$1
    program_name=$2
    echo -e "${AZUL}[*] Installing $program_name...${RESET}"
    if go install -v "$package" 2>>"$LOG_ERROS"; then
        echo -e "${VERDE}[+] $program_name installed successfully${RESET}"
    else
        echo -e "${VERMELHO}[-] Failed to install $program_name (see $LOG_ERROS)${RESET}"
    fi
}

# Instalar dependências de sistema
echo -e "${AZUL}[*] Installing system dependencies...${RESET}"
sudo apt update 2>>"$LOG_ERROS"
sudo apt install -y libpcap-dev curl wget git build-essential pkg-config 2>>"$LOG_ERROS"

# Verificar se Go está instalado
if ! command -v go &> /dev/null; then
    echo -e "${VERMELHO}[-] Go is not installed. Please install Go first.${RESET}"
    exit 1
fi

echo -e "${VERDE}[+] Go version: $(go version)${RESET}"

# ============ FERRAMENTAS DO GOBOTRECON/BOTTEST ============

# Verificar e instalar subfinder
echo -e "${AZUL}[*] Installing subfinder...${RESET}"
check_go_version "1.21"
install_go_program "github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest" "subfinder"

# instalar dnsx
echo -e "${AZUL}[*] Installing dnsx...${RESET}"
check_go_version "1.21"
install_go_program "github.com/projectdiscovery/dnsx/cmd/dnsx@latest" "dnsx"

# instalar aix
echo -e "${AZUL}[*] Installing aix...${RESET}"
check_go_version "1.21"
install_go_program "github.com/projectdiscovery/aix/cmd/aix@latest" "aix"

# Instalar naabu
echo -e "${AZUL}[*] Installing naabu...${RESET}"
sudo apt install -y build-essential pkg-config libpcap-dev 2>>"$LOG_ERROS"
install_go_program "github.com/projectdiscovery/naabu/v2/cmd/naabu@latest" "naabu"

# Instalar anew
echo -e "${AZUL}[*] Installing anew...${RESET}"
install_go_program "github.com/tomnomnom/anew@latest" "anew"

# Instalar goop
echo -e "${AZUL}[*] Installing goop...${RESET}"
install_go_program "github.com/deletescape/goop@latest" "goop"

# Instalar subjs
echo -e "${AZUL}[*] Installing subjs...${RESET}"
install_go_program "github.com/lc/subjs@latest" "subjs"

# Verificar e instalar httpx
echo -e "${AZUL}[*] Installing httpx...${RESET}"
check_go_version "1.21"
install_go_program "github.com/projectdiscovery/httpx/cmd/httpx@latest" "httpx"

# Verificar e instalar katana
echo -e "${AZUL}[*] Installing katana...${RESET}"
check_go_version "1.18"
CGO_ENABLED=1 go install github.com/projectdiscovery/katana/cmd/katana@latest 2>>"$LOG_ERROS"

# Instalar unfurl
echo -e "${AZUL}[*] Installing unfurl...${RESET}"
install_go_program "github.com/tomnomnom/unfurl@latest" "unfurl"

# Verificar e instalar nuclei
echo -e "${AZUL}[*] Installing nuclei...${RESET}"
check_go_version "1.21"
install_go_program "github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest" "nuclei"

# Instalar alterx
echo -e "${AZUL}[*] Installing alterx...${RESET}"
check_go_version "1.21"
install_go_program "github.com/projectdiscovery/alterx/cmd/alterx@latest" "alterx"

# ============ MINHAS FERRAMENTAS ============
# Instalar xsshunter
echo -e "${AZUL}[*] Installing xsshunter...${RESET}"
install_go_program "github.com/lupedsagaces/xsshunter@latest" "xsshunter"

# Instalar extracth1
echo -e "${AZUL}[*] Installing extracth1...${RESET}"
git clone https://github.com/lupedsagaces/extracth1.git 2>>"$LOG_ERROS"
cd extracth1
sudo cp extracth1.py /usr/local/bin/ 2>>"$LOG_ERROS"
sudo chmod +x /usr/local/bin/extracth1.py 2>>"$LOG_ERROS"
sudo mv /usr/local/bin/extracth1.py /usr/local/bin/extracth1 2>>"$LOG_ERROS"

# Instalar mergedomains
echo -e "${AZUL}[*] Installing mergedomains...${RESET}"
install_go_program "github.com/lupedsagaces/mergedomains@latest" "mergedomains"

# Instalar removehttp
echo -e "${AZUL}[*] Installing removehttp...${RESET}"
install_go_program "github.com/lupedsagaces/removehttp@latest" "removehttp"

# Instalar nmap
echo -e "${AZUL}[*] Installing nmap...${RESET}"
sudo apt update -y 2>>"$LOG_ERROS"; sudo apt upgrade -y 2>>"$LOG_ERROS"
sudo apt install nmap -y 2>>"$LOG_ERROS"

# Instalar massdns
echo -e "${AZUL}[*] Installing massdns...${RESET}"
git clone https://github.com/blechschmidt/massdns.git ~/massdns 2>>"$LOG_ERROS"
cd ~/massdns
sudo apt install build-essential -y 2>>"$LOG_ERROS"
make 2>>"$LOG_ERROS"
sudo cp ./bin/massdns /usr/bin 2>>"$LOG_ERROS"

# Instalar shuffledns
echo -e "${AZUL}[*] Installing shuffledns...${RESET}"
install_go_program "github.com/projectdiscovery/shuffledns/cmd/shuffledns@latest" "shuffledns"

# ============ FERRAMENTAS TESTE DE XSS ============
# Instalar gau
echo -e "${AZUL}[*] Installing gau...${RESET}"
install_go_program "github.com/lc/gau/v2/cmd/gau@latest" "gau"

# Instalar uro
echo -e "${AZUL}[*] Installing uro...${RESET}"
pipx install uro 2>>"$LOG_ERROS"
pipx ensurepath 2>>"$LOG_ERROS"
source ~/.bashrc

# Instalar Gxss
echo -e "${AZUL}[*] Installing Gxss...${RESET}"
install_go_program "github.com/KathanP19/Gxss@latest" "Gxss"

# Instalar dalfox
echo -e "${AZUL}[*] Installing dalfox...${RESET}"
install_go_program "github.com/hahwul/dalfox/v2@latest" "dalfox"

# ============ FERRAMENTAS EXTRAS ============
# Instalar notify
echo -e "${AZUL}[*] Installing notify...${RESET}"
install_go_program "github.com/projectdiscovery/notify/cmd/notify@latest" "notify"

# Instalar waybackurls
echo -e "${AZUL}[*] Installing waybackurls...${RESET}"
install_go_program "github.com/tomnomnom/waybackurls@latest" "waybackurls"

# Instalar assetfinder
echo -e "${AZUL}[*] Installing assetfinder...${RESET}"
install_go_program "github.com/tomnomnom/assetfinder@latest" "assetfinder"

# Instalar ffuf
echo -e "${AZUL}[*] Installing ffuf...${RESET}"
install_go_program "github.com/ffuf/ffuf/v2@latest" "ffuf"

# Instalar gobuster
echo -e "${AZUL}[*] Installing gobuster...${RESET}"
install_go_program "github.com/OJ/gobuster/v3@latest" "gobuster"

# Instalar httprobe
echo -e "${AZUL}[*] Installing httprobe...${RESET}"
install_go_program "github.com/tomnomnom/httprobe@latest" "httprobe"

# Instalar qsreplace
echo -e "${AZUL}[*] Installing qsreplace...${RESET}"
install_go_program "github.com/tomnomnom/qsreplace@latest" "qsreplace"

# Instalar meg
echo -e "${AZUL}[*] Installing meg...${RESET}"
install_go_program "github.com/tomnomnom/meg@latest" "meg"

# Instalar gf
echo -e "${AZUL}[*] Installing gf...${RESET}"
install_go_program "github.com/tomnomnom/gf@latest" "gf"

# Instalar gf templates
echo -e "${AZUL}[*] Installing gf templates...${RESET}"
git clone https://github.com/lupedsagaces/.gf.git ~/.gf 2>>"$LOG_ERROS"

# Instalar subjack
echo -e "${AZUL}[*] Installing subjack...${RESET}"
install_go_program "github.com/haccer/subjack@latest" "subjack"

# Instalar amass
echo -e "${AZUL}[*] Installing amass...${RESET}"
CGO_ENABLED=0 go install -v github.com/owasp-amass/amass/v5/cmd/amass@main

# ============ OUTRAS FERRAMENTAS ============
# linkfinder
echo -e "${AZUL}[*] Installing linkfinder...${RESET}"
cd ~
git clone https://github.com/GerbenJavado/LinkFinder.git 2>>"$LOG_ERROS"
cd LinkFinder
python3 setup.py install 2>>"$LOG_ERROS"
pip3 install -r requirements.txt 2>>"$LOG_ERROS"

# ============ CONFIGURAÇÕES ADICIONAIS ============
# Adicionar $GOPATH/bin ao PATH se não estiver
echo -e "${AZUL}[*] Checking PATH configuration...${RESET}"
GOPATH_BIN="$(go env GOPATH)/bin"
if [[ ":$PATH:" != *":$GOPATH_BIN:"* ]]; then
    echo -e "${AZUL}[*] Adding $GOPATH_BIN to PATH...${RESET}"
    echo 'export PATH="$PATH:$(go env GOPATH)/bin"' >> ~/.bashrc
    echo -e "${VERDE}[+] Added to ~/.bashrc. Run 'source ~/.bashrc' or restart terminal.${RESET}"
fi

# Criar diretórios úteis
echo -e "${AZUL}[*] Creating useful directories...${RESET}"
mkdir -p ~/tools/wordlists
mkdir -p ~/tools/scripts
mkdir -p ~/recon

# Baixar algumas wordlists úteis
echo -e "${AZUL}[*] Downloading useful wordlists...${RESET}"
cd ~/tools/wordlists
wget -q https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/directory-list-2.3-medium.txt 2>>"$LOG_ERROS"
wget -q https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/DNS/subdomains-top1million-110000.txt 2>>"$LOG_ERROS"

# Instalar nuclei templates
echo -e "${AZUL}[*] Installing nuclei templates...${RESET}"
nuclei -update-templates 2>>"$LOG_ERROS"

# Desativar modo de depuração
set +x

echo -e "${VERDE}"
echo "=============================================="
echo "    INSTALAÇÃO CONCLUÍDA COM SUCESSO!"
echo "=============================================="
echo -e "${RESET}"

echo -e "${VERDE}[+] Diretórios criados:${RESET}"
echo "- ~/tools/wordlists (wordlists baixadas)"
echo "- ~/tools/scripts (para seus scripts)"
echo "- ~/recon (para resultados de reconhecimento)"

echo -e "${AZUL}[*] Para usar as ferramentas, execute:${RESET}"
echo "source ~/.bashrc"
echo -e "${VERDE}[+] Ou reinicie seu terminal${RESET}"

echo -e "${AZUL}[*] Teste uma ferramenta:${RESET}"
echo "subfinder -d example.com"

echo -e "${AZUL}[*] Verifique os erros (se houver) no arquivo:${RESET} $LOG_ERROS"
if [ -s "$LOG_ERROS" ]; then
    echo -e "${VERMELHO}[!] Algumas instalações falharam. Confira $LOG_ERROS${RESET}"
else
    echo -e "${VERDE}[+] Nenhum erro registrado!${RESET}"
fi
