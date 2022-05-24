#!/bin/bash

set -e

log() {
  echo
  echo "##### $*"
}

# to do: switch context: oc config use-context prod1-cluster
#log "Retrieving Istio CA Root certificates"
# to do: switch context: oc config use-context prod2-cluster
PROD2_MESH_CERT=`cat PROD2_MESH_CERT.TXT`

# to do: switch context: oc config use-context prod1-cluster
log "Enabling federation for site1"
oc project prod1-mesh
cp site1/mesh-ca-root-cert.bak site1/prod2meshcarootcert.yaml
sed "s:<PROD2_MESH_CERT>:$PROD2_MESH_CERT:g" site1/prod2meshcarootcert.yaml | oc apply -f -
oc apply -f site1/smp.yaml
oc apply -f site1/iss.yaml

log "Installing VirtualService for site1"
oc apply -n prod1-5gcore -f site1/vs-mirror-details.yaml

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
