#!/bin/bash
cd /src/github.com/nebulasio/go-nebulas
/src/github.com/nebulasio/go-nebulas/neb -c /src/github.com/nebulasio/go-nebulas/conf/local/config.conf > /dev/null 2>&1 &
/src/github.com/nebulasio/go-nebulas/neb -c /src/github.com/nebulasio/go-nebulas/conf/local/miner.conf > /dev/null 2>&1 &