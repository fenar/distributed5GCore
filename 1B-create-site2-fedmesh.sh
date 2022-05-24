#!/bin/bash

set -e

log() {
  echo
  echo "##### $*"
}

PROD1_MESH_CERT=`cat PROD1_MESH_CERT.TXT`

# Enable federation for site2
cp site2/mesh-ca-root-cert.bak site2/prod1meshcarootcert.yaml
sed -e "s:<PROD1_MESH_CERT>:$PROD1_MESH_CERT:g" site2/prod1meshcarootcert.yaml
oc apply -f site2/prod1meshcarootcert.yaml
oc apply -f site2/smp.yaml
oc apply -f site2/ess.yaml

log "INSTALLATION COMPLETE
#Run the following command in the prod-mesh to check the connection status:
  oc -n prod1-mesh get servicemeshpeer prod2-mesh -o json | jq .status
#Run the following command to check the connection status in prod2-mesh:
  oc -n prod2-mesh get servicemeshpeer prod1-mesh -o json | jq .status
#Check if services from prod2-mesh are imported into prod-mesh:
  oc -n prod1-mesh get importedservicesets prod2-mesh -o json | jq .status
#Check if services from prod2-mesh are exported:
  oc -n prod2-mesh get exportedservicesets prod1-mesh -o json | jq .status
"
