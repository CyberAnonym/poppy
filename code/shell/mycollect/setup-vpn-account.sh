#!/bin/bash

#  Setup StrongSwan VPN Account
#
#  Copyright (c) 2016 Zack Devine <zack@zdevine.me>
#  Adapted from Phil Plückthun's 'setup-strong-strongswan' script.
#  https://github.com/philpl/setup-strong-strongswan
#
#  This work is licensed under the GNU General Public License v3

if [ `id -u` -ne 0 ]
then
  echo "Please start this script with root privileges!"
  echo "Try again with sudo."
  exit 0
fi

echo "StrongSwan VPN Account Creator"
echo ""

VPNUSER=""
VPNPASS=""

generateKey () {
  KEY=`cat /dev/urandom | tr -dc _A-Z-a-z-0-9 | head -c 16`
}

backupCredentials () {
  echo "Backing up /etc/ipsec.secrets..."
  if [ -f /etc/ipsec.secrets ]; then
    cp /etc/ipsec.secrets /etc/ipsec.secrets.backup
    echo "Success! Backup created at /etc/ipsec.secrets.backup."
  fi

  echo ""
  echo "Backing up /etc/ppp/l2tp-secrets..."
  if [ -f /etc/ppp/l2tp-secrets ]; then
    cp /etc/ppp/l2tp-secrets /etc/ppp/l2tp-secrets.backup
    echo "Success! Backup created at /etc/ppp/l2tp-secrets.backup."
  fi

  echo ""
  echo "Backing up /etc/ppp/chap-secrets..."
  if [ -f /etc/ppp/chap-secrets ]; then
    cp /etc/ppp/chap-secrets /etc/ppp/chap-secrets.backup
    echo "Success! Backup created at /etc/ppp/chap-secrets.backup."
  fi
}

backupCredentials

echo ""
read -p "Username: " VPNUSER

echo "Generate random password? [y/n]"
while true; do
  read -p "" yn
  case $yn in
    [Nn]* ) echo ""; read -p "Password: " VPNPASS; break;;
    [Yy]* ) generateKey; VPNPASS=$KEY; break;;
    * ) echo "Please answer with Yes or No [y/n].";;
  esac
done

echo ""
echo "Adding VPN Account to /etc/ipsec.secrets..."
cat >> /etc/ipsec.secrets <<EOF
$VPNUSER : EAP "$VPNPASS"
$VPNUSER : XAUTH "$VPNPASS"
EOF
echo "Done!"

echo ""
echo "Adding VPN Account to /etc/ppp/chap-secrets..."
cat >> /etc/ppp/chap-secrets <<EOF
"$VPNUSER" "*" "$VPNPASS" "*"
EOF
echo "Done!"

echo ""
echo "============================================================"
echo "Username: $VPNUSER"
echo "Password: $VPNPASS"
echo "============================================================"
