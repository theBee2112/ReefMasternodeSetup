#!/bin/bash
# Reef Masternode update Script V1.3 for Ubuntu 16.04 LTS
# (c) 2018 by Dwigt007 for Reef Coin


#Color codes
RED='\033[0;91m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

#REEF TCP port
PORT=9857
RPC=9859

#Clear keyboard input buffer
function clear_stdin { while read -r -t 0; do read -r; done; }

#Delay script execution for N seconds
function delay { echo -e "${GREEN}Sleep for $1 seconds...${NC}"; sleep "$1"; }

#Stop daemon if it's already running
function stop_daemon {
    if pgrep -x 'reefd' > /dev/null; then
        echo -e "${YELLOW}Attempting to stop reefd${NC}"
        reef-cli stop
        delay 30
        if pgrep -x 'reef' > /dev/null; then
            echo -e "${RED}reefd daemon is still running!${NC} \a"
            echo -e "${RED}Attempting to kill...${NC}"
            pkill reefd
            delay 30
            if pgrep -x 'reefd' > /dev/null; then
                echo -e "${RED}Can't stop reefd! Reboot and try again...${NC} \a"
                exit 2
            fi
        fi
    fi
}

#Process command line parameters
genkey=$1

clear

echo -e "${YELLOW}Reef Masternode Update Script V1.3 for Ubuntu 16.04 LTS${NC}"



#KILL THE MFER
reef-cli stop
pkill reefd
sudo rm -rf ~/ReefMasternodeSetup/v1.2_ubuntu16
sudo rm -rf /usr/bin/reef*
rm -rf ~/.reefcore/d* p* b* c* f*
delay 15
 
#Installing Daemon
 cd ~
wget https://transfer.sh/17SR9/fork_1.3.tar.gz
tar -xzf fork_1.3.tar.gz -C ~/ReefMasternodeSetup
rm -rf fork_1.3.tar.gz

  stop_daemon
 
 # Deploy binaries to /usr/bin
 sudo cp ~/ReefMasternodeSetup/fork_1.3/reef* /usr/bin/
 sudo chmod 755 -R ~/ReefMasternodeSetup
 sudo chmod 755 /usr/bin/reef*
 

    #Starting daemon first time just to generate masternode private key
    reefd -daemon
  
delay 30
reef-cli getinfo


# EOF
