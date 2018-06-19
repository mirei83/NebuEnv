#!/bin/bash

export PATH=$PATH:/usr/local/go/bin
export GOPATH=/root/go

# This script is also used for autostart, dont move it.

cd $GOPATH/src/github.com/nebulasio/go-nebulas
$GOPATH/src/github.com/nebulasio/go-nebulas/neb -c $GOPATH/src/github.com/nebulasio/go-nebulas/conf/local/config.conf > /dev/null 2>&1 &
$GOPATH/src/github.com/nebulasio/go-nebulas/neb -c $GOPATH/src/github.com/nebulasio/go-nebulas/conf/local/miner.conf > /dev/null 2>&1 &