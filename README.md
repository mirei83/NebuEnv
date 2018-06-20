# NebuEnv

Setup Script for a Development Environment for Nebulas
==================

All Test are done on Vultr. Register if you want and power up a small VPS: https://www.vultr.com/?ref=7097618

This is a Script to automatically install a complete DEV Env on a Ubuntu 16.04+ System.

A better walkthrough can be found here: https://medium.com/@michael_81043/setup-nebulas-development-environment-b8f8f022b170


1.)  Install 
------------------------
To install all components, just SSH into your Ubuntu and start the Install script

```shell
curl -sSL https://raw.githubusercontent.com/mirei83/NebuEnv/master/SetupEnvironment.sh | bash
```

4.) Start Node
------------------------
```shell
./start-nebulas-privatenet.sh
./explorer-privatenet.sh
```



