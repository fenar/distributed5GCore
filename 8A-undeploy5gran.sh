#!/usr/bin/env bash
#Author: fenar
echo -e "Wiping UERANSIM....\n"
echo
cd 5gran
rm prod1-worker-ip
echo "Removing UERANSIM Deployment"
rm templates/5gran-gnb-configmap.yaml
rm templates/5gran-ue-configmap.yaml
helm uninstall 5gran-prod1
echo "Bye"
