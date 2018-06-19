#!/usr/bin/env bash
sleep 10
cd ~
cd explorer/explorer-backend/
java -Xms1024m -Xmx2048m -Xdebug -Xrunjdwp:server=y,transport=dt_socket,address=8085,suspend=n -jar ./build/libs/explorer-0.0.1-SNAPSHOT.jar --spring.profiles.active=prod --spring.datasource.initialize=false  >console.log 2>&1 &
sleep 15
cd ../explorer-front
npm run dev >console.log 2>&1 &