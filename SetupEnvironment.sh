#!/bin/sh

### Supported OS: Ubuntu 16.04 


## Set environment paths for GO
export PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME/go

## create GO Folder
mkdir -p $GOPATH/src

### Update System and install dependencies
apt-get update
apt-get -y install build-essential libgflags-dev libsnappy-dev zlib1g-dev libbz2-dev liblz4-dev libzstd-dev git make automake build-essential cmake curl


### Get Files for NebuEnv

### Install go
echo "########################"
echo "Installing go"
echo "########################"
cd ~
wget https://dl.google.com/go/go1.10.3.linux-amd64.tar.gz
tar -C /usr/local -xzf go1.10.3.linux-amd64.tar.gz
chmod +x /usr/local/go/bin/go
rm go1.10.3.linux-amd64.tar.gz

### Install RocksDB
echo "########################"
echo "Installing RocksDB"
echo "########################"
cd ~
git clone https://github.com/facebook/rocksdb.git
cd rocksdb && make shared_lib && make install-shared

### Install dep
echo "########################"
echo "Installing dep"
echo "########################"
cd /usr/local/bin/
wget https://github.com/golang/dep/releases/download/v0.4.1/dep-linux-amd64
ln -s dep-linux-amd64 dep
chmod +x /usr/local/bin/*


### Install Nebulas
echo "########################"
echo "Installing Nebulas"
echo "########################"
cd ~
mkdir -p $GOPATH/src/github.com/nebulasio
cd $GOPATH/src/github.com/nebulasio
git clone https://github.com/nebulasio/go-nebulas.git
cd go-nebulas
git checkout master
make dep
make deploy-v8
make build
mkdir conf/local
cd conf/local
wget https://raw.githubusercontent.com/mirei83/Nebulas/master/NebuEnv/local/config.conf
wget https://raw.githubusercontent.com/mirei83/Nebulas/master/NebuEnv/local/genesis.conf
wget https://raw.githubusercontent.com/mirei83/Nebulas/master/NebuEnv/local/miner.conf
cd ~

#### Install WebWallet with web browser on port 80
apt-get install -y nginx
cd /var/www/html
git clone https://github.com/nebulasio/web-wallet.git

### Remove all real Nodes from list and just add localnode
IPADDRESS="`ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p'`"
sed -i -e 's/{.*Mainnet.*}\,//g' /var/www/html/web-wallet/js/ui-block.js
sed -i -e 's/{.*Testnet.*}\,//g' /var/www/html/web-wallet/js/ui-block.js
sed -i -e "s/127.0.0.1/$IPADDRESS/g" /var/www/html/web-wallet/js/ui-block.js
sed -i -e "s/Local Nodes/$IPADDRESS/g" /var/www/html/web-wallet/js/ui-block.js


### Install Explorer
##cd ~
##curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
##sudo apt-get install -y nodejs
##git clone https://github.com/nebulasio/explorer.git
##Fronend
##cd explorer/explorer-front
##npm i
##sed -i -e "s/localhost/0.0.0.0/g" config/index.js
## npm run dev
## BackEnd
##cd ../explorer-backend
##sudo apt-get install -y openjdk-8-jdk redis-server mysql-server


### Create StartUp-Script

echo "########################"
echo "Creating Startup Miner Script"
echo "########################"
cd
echo '#!/bin/bash' >> ./start-nebulas-LocalNode.sh
echo "cd $GOPATH/src/github.com/nebulasio/go-nebulas"  >> ./start-nebulas-LocalNode.sh
echo "$GOPATH/src/github.com/nebulasio/go-nebulas/neb -c $GOPATH/src/github.com/nebulasio/go-nebulas/conf/local/config.conf > /dev/null 2>&1 & " >> ./start-nebulas-LocalNode.sh
echo "$GOPATH/src/github.com/nebulasio/go-nebulas/neb -c $GOPATH/src/github.com/nebulasio/go-nebulas/conf/local/miner.conf > /dev/null 2>&1 & " >> ./start-nebulas-LocalNode.sh
chmod +x ./start-nebulas-LocalNode.sh
