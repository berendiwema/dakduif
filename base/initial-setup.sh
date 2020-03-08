#!/bin/bash
if [ $(id -u) -ne 0 ]; then
  echo "[$(date)] ERROR: This script requires root privileges."
  exit 1
fi
echo "
______  ___   _   _______ _   _ ___________ 
|  _  \/ _ \ | | / /  _  \ | | |_   _|  ___|
| | | / /_\ \| |/ /| | | | | | | | | | |_   
| | | |  _  ||    \| | | | | | | | | |  _|  
| |/ /| | | || |\  \ |/ /| |_| |_| |_| |    
|___/ \_| |_/\_| \_/___/  \___/ \___/\_|    

"
echo "[$(date)] INFO: Setting up Dakduif server"
echo "[$(date)] INFO: Executing package upgrade"
apt-get update && apt-get upgrade
# Disable IPv6; current ISP doesn't support it yet.
read -p "[$(date)] Disable IPv6?" -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]
  echo "[$(date)] INFO: Disabling IPv6"
  echo "net.ipv6.conf.all.disable_ipv6=1" >> /etc/sysctl.conf
  echo "net.ipv6.conf.default.disable_ipv6=1" >> /etc/sysctl.conf
  sysctl -p    
fi

echo "[$(date)] INFO: Installing base packages for Dakduif server"
apt-get install -y  docker-compose ansiweather screenfetch

# Setup dakduif MOTD
read -p "Enter server location [city]: " -e LOCATION 
echo "[$(date)] INFO: Setting up MOTD, location ${LOCATION}"
chmod -x /etc/update-motd.d/*

echo "#!/bin/sh
echo ''
screenfetch
echo ''
ansiweather -l ${LOCATION}
echo ''
______  ___   _   _______ _   _ ___________ 
|  _  \/ _ \ | | / /  _  \ | | |_   _|  ___|
| | | / /_\ \| |/ /| | | | | | | | | | |_   
| | | |  _  ||    \| | | | | | | | | |  _|  
| |/ /| | | || |\  \ |/ /| |_| |_| |_| |    
|___/ \_| |_/\_| \_/___/  \___/ \___/\_|    

">/etc/update-motd.d/01-custom

echo "[$(date)] INFO: Initial setup done"