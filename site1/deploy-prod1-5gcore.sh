#!/usr/bin/env bash
#Author: fenar
current_dir=$PWD
cd $current_dir/site1/cnfs
echo "Deploying Open5G Core Production Site1"
helm install -f values.yaml prod1-5gcore ./
echo "Enjoy The Open 5G Core on Production Site1!"
