#!/usr/bin/env bash
#Author: fenar
echo -e "Site1 is getting Destroyed!....\n"
echo
oc project prod1-5gcore
./site1/undeploy-prod1-5gcore.sh
oc delete -f site1/open5gcorewebui-expose.yaml
oc delete -n prod1-5gcore -f site1/virtservices-distribute-details.yaml
oc delete -f site1/smcp.yaml
oc delete -f site1/smmr.yaml
oc delete -f site2/smp.yaml
oc delete -f site2/ess.yaml
echo "The End"
