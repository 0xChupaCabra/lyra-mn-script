#!/bin/bash
color=`tput setaf 2`

reset=`tput sgr0`

echo "${color}LYRA MN Installer by stepollo${reset}"

sleep 1

read -p "${color}Please insert your VPS IP address:${reset} " vpsip

read -p "${color}Please insert your MN key generated in the local wallet:${reset} " genkey

read -p "${color}Please insert a rpc user:${reset} " rpcuser

read -p "${color}Please insert a rpc password:${reset} " rpcpass

echo "${color}Adding some swap space..${reset}"

sleep 1

#fallocate -l 2G /swapfile && chmod 600 /swapfile && mkswap /swapfile && swapon /swapfile


echo "${color}Building system dependencies........${reset}"

sleep 1

apt-get update -y && apt-get upgrade -y && apt-get install git unzip apt-transport-https ca-certificates curl gnupg-agent software-properties-common build-essential libtool autotools-dev autoconf pkg-config libssl-dev libevent-dev automake libminiupnpc-dev libboost-all-dev -y


echo "${color}Creating conf file....${reset}"

sleep 1

mkdir ~/.lyra
touch ~/.lyra/lyra.conf

tee -a ~/.lyra/lyra.conf << END

rpcuser=${rpcuser}
rpcpassword=${rpcpass}
rpcallowip=127.0.0.1
listen=1
server=1
daemon=1
logtimestamps=1
maxconnections=64
masternode=1
externalip=${vpsip}
bind=${vpsip}
masternodeaddr=${vpsip}:42222
masternodeprivkey=${genkey}

END

wget http://95.111.237.31/scrypta-wallet.deb && apt install ./scrypta-wallet.deb -y && rm scrypta-wallet.deb
#wget https://github.com/scryptachain/scrypta/releases/download/v2.0.1/lyra-2.0.1.deb && apt install ./lyra-2.0.1.deb -y && rm lyra-2.0.1.deb

cd ~/.lyra && wget http://bootstrap.scryptachain.org/latest.zip && unzip latest.zip && rm latest.zip
cd ~/
lyrad &
