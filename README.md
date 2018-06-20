# NebuEnv

Setup Script for a Development Environment for Nebulas
==================

All Test are done on Vultr.com. Register if you want to power up a small VPS: https://www.vultr.com/?ref=7097618

This is a Script that automatically installs a complete DEV Env on Ubuntu 16.04+.

A better walkthrough can be found here: https://medium.com/@michael_81043/setup-nebulas-development-environment-b8f8f022b170


1.)  Install 
------------------------
To install all components, just SSH into your Ubuntu and start the Install script.

This will Install 
- 2x Nebulas Nodes running on a private Testnet (2 Nodes needed for consensus)
- Nebulas WebWallet
- Nebulas Blockexplorer for private Testnet
- Webserver with Dashboard to get startet.

```shell
curl -sSL https://raw.githubusercontent.com/mirei83/NebuEnv/master/SetupEnvironment.sh | bash
```

2.) Start Node
------------------------
```shell
./start-nebulas-privatenet.sh
./explorer-privatenet.sh
```



