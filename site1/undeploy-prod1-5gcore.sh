#!/usr/bin/env bash
#Author: fenar
echo -e "Destroying Site01!....\n"
echo "Removing Open5GCore"
helm uninstall prod1-5gcore
echo "Site01 Destroyed!"
