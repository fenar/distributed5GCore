#!/usr/bin/env bash
#Author: fenar
echo -e "Destroying Site02!....\n"
echo "Removing Open5GCore"
helm uninstall prod2-5gcore
echo "Site02 Destroyed!"
