#!/usr/bin/env bash
#Author: fenar
echo -e "Site1 is getting Destroyed!....\n"
echo
oc project prod1-5gcore
./site1/undeploy-prod1-5gcore.sh
oc delete -f site1/smcp.yaml
oc delete -f site1/smmr.yaml
echo "The End"
