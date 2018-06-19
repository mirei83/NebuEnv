#!/bin/sh

### Supported OS: Ubuntu 16.04 

## activate Swap
echo "########################"
echo "Activating Swap"
echo "########################"
dd if=/dev/zero of=/mnt/myswap.swap bs=1M count=4000 &&  mkswap /mnt/myswap.swap &&  swapon /mnt/myswap.swap
echo "/mnt/swap.img    none    swap    sw    0    0" >> /etc/fstab


## Set environment paths for GO
export PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME/go

## create GO Folder
mkdir -p $GOPATH/src

### Update System and install dependencies
apt-get update
apt-get -y install build-essential libgflags-dev libsnappy-dev zlib1g-dev libbz2-dev liblz4-dev libzstd-dev git make automake build-essential cmake curl

### Get Files for NebuEnv
cd ~
git clone https://github.com/mirei83/NebuEnv.git

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
### Change Dynasty frpm 21 to 1 for a 2 Node Network
sed -i -e "s/= 21/= 1/g" $GOPATH/src/github.com/nebulasio/go-nebulas/consensus/dpos/dpos_state.go
sed -i -e "s/*2\/3 + 1//g" $GOPATH/src/github.com/nebulasio/go-nebulas/consensus/dpos/dpos_state.go
make dep
make deploy-v8
make build
mv $HOME/NebuEnv/local $GOPATH/src/github.com/nebulasio/go-nebulas/conf/
echo "export PATH=$PATH:/usr/local/go/bin" >> /etc/profile
echo "export GOPATH=/root/go" >> /etc/profile



#### Install WebWallet with web browser on port 80
cd ~
apt-get install -y nginx
rm -rf /var/www/html
mv $HOME/NebuEnv/html /var/www/

## Change IP to Node
IPADDRESS="`ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p'`"
sed -i -e "s/123.123.123.123/$IPADDRESS/g" /var/www/html/index.html
cd /var/www/html
git clone https://github.com/nebulasio/web-wallet.git

### Remove all real Nodes from list and just add localnode
sed -i -e 's/{.*Mainnet.*}\,//g' /var/www/html/web-wallet/js/ui-block.js
sed -i -e 's/{.*Testnet.*}\,//g' /var/www/html/web-wallet/js/ui-block.js
sed -i -e "s/127.0.0.1/$IPADDRESS/g" /var/www/html/web-wallet/js/ui-block.js
sed -i -e "s/Local Nodes/$IPADDRESS/g" /var/www/html/web-wallet/js/ui-block.js

## Create StartUp-Script
echo "########################"
echo "Creating Node Startup Script"
echo "########################"
cd ~
mv $HOME/NebuEnv/startup/start-nebulas-privatenet.sh $HOME
chmod +x $HOME/start-nebulas-privatenet.sh

echo "########################"
echo "Creating Explorer Startup Script"
echo "########################"
cd ~
mv $HOME/NebuEnv/startup/explorer-privatenet.sh $HOME
chmod +x $HOME/explorer-privatenet.sh


### Prepare Autostart
crontab -l > mycron
echo "@reboot root $HOME/.profile; /root/start-nebulas-privatenet.sh " >> mycron
echo "@reboot root $HOME/.profile; /root/explorer-privatenet.sh " >> mycron
crontab mycron
rm mycron


## Install NodeJS
cd ~
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt-get install -y nodejs

## Install Explorer
git clone https://github.com/mirei83/explorer
## Explorer Fronend
## Change IP to NodeIP
IPADDRESS="`ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p'`"
sed -i -e "s/123.123.123.123/$IPADDRESS/g" explorer/explorer-front/src/assets/app-config.js
cd explorer/explorer-front
npm i
## Explorer BackEnd
cd ../explorer-backend
## Set Env to install mySQL with RootPW
ROOT_SQL_PASS=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $ROOT_SQL_PASS"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $ROOT_SQL_PASS"
echo -e "[client]\nuser=root\npassword=$ROOT_SQL_PASS" | sudo tee /root/.my.cnf
## Install MySQL / Java
sudo apt-get install -y openjdk-8-jdk redis-server mysql-server
## Create DB
mysql -u root --password=$ROOT_SQL_PASS < src/main/resources/deploy_schema.sql 
chmod +x build-expl.sh
./build-expl.sh