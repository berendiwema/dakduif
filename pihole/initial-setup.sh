#!/bin/bash
echo "[$(date)] INFO: Disabling systemd stub caching DNS resolver"
sudo sed -r -i.orig 's/#?DNSStubListener=yes/DNSStubListener=no/g' /etc/systemd/resolved.conf
sudo sh -c 'rm /etc/resolv.conf && ln -s /run/systemd/resolve/resolv.conf /etc/resolv.conf'
echo "[$(date)] INFO: Creating storage directories"
mkdir -p /srv/pihole/etc-pihole/
mkdir /srv/pihole/etc-dnsmasq.d/

# Setup Dakduif DNS properties
echo "[$(date)] INFO: Setting up PiHole configuration"
read -p "Timezone [Europe/Amsterdam]:" -e TIMEZONE
read -p "DNS 1 [1.1.1.1]:" -e DNS1
read -p "DNS 2 [1.0.0.1]:" -e DNS2
read -p "DNSSEC True/False [True]: " -e DNSSEC
read -p "IP to listen on [0.0.0.0]:" -e SERVER_IP
read -p "Virtual host [optional]:" -e VIRTUAL_HOST

# Set configuration variables
cp pihole.env .env

sed -i -e "s/#TIMEZONE#/${TIMEZONE:-Europe\/Amsterdam}/g" .env
sed -i -e "s/#DNS1#/${DNS1:-1.1.1.1}/g" .env
sed -i -e "s/#DNS2#/${DNS2:-1.0.0.1}/g" .env
sed -i -e "s/#DNSSEC#/${DNSSEC:-True}/g" .env
sed -i -e "s/#VIRTUAL_HOST#/${DNSSEC:-True}/g" .env
sed -i -e "s/#SERVER_IP#/${SERVER_IP:-''}/g" .env


echo "[$(date)] INFO: Done"