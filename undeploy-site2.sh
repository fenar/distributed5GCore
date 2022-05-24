#!/usr/bin/env bash
#Author: fenar
echo -e "Site2 is About to End!....\n"
echo
oc project prod2-5gcore
./site2/undeploy-prod2-5gcore.sh
#oc delete project prod2-5gcore
log "Uninstalling control plane for prod2-mesh"
oc delete -f site2/smcp.yaml
oc delete -f site2/smmr.yaml
echo "The End"
