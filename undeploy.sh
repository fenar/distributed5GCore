#!/usr/bin/env bash
#Author: fenar
echo -e "World is About to End!....\n"
echo
./site1/undeploy-prod1-5gcore.sh
./site2/undeploy-prod2-5gcore.sh
echo "The End"
