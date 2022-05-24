#!/usr/bin/env bash
#Author: fenar
echo -e "World is About to End!....\n"
echo
oc project prod1-5gcore
./site1/undeploy-prod1-5gcore.sh
oc project prod2-5gcore
./site2/undeploy-prod2-5gcore.sh
echo "The End"
