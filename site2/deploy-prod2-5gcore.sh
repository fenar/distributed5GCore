#!/usr/bin/env bash
#Author: fenar
cd cnfs
echo "Deploying Open5G Core Production Site2"
helm install -f values.yaml prod2-5gcore ./
echo "Enjoy The Open 5G Core on Production Site2!"
