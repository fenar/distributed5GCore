#!/usr/bin/env bash
#Author: fenar
current_dir=$PWD
cd $current_dir/site2/cnfs
echo "Deploying Open5G Core Production Site2"
helm install -f values.yaml prod2-5gcore ./
echo "Enjoy The Open 5G Core on Production Site2!"
