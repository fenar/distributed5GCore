#!/bin/bash

set -e

log() {
  echo
  echo "##### $*"
}

# to do: switch context: oc config use-context prod2-cluster
log "Creating projects for prod2-mesh"
oc new-project prod2-mesh || true
oc new-project prod2-5gcore|| true

oc adm policy add-scc-to-user anyuid -z default 
oc adm policy add-scc-to-user hostaccess -z default 
oc adm policy add-scc-to-user hostmount-anyuid -z default 
oc adm policy add-scc-to-user privileged -z default 

log "Installing control plane for prod2-mesh"
oc apply -f site2/smcp.yaml
oc apply -f site2/smmr.yaml

# to do: switch context: oc config use-context prod2-cluster
log "Waiting for prod2-mesh installation to complete"
oc wait --for condition=Ready -n prod2-mesh smmr/default --timeout 300s

# to do: switch context: oc config use-context prod2-cluster
oc project prod2-5gcore
log "Installing 5gcore in Site02"
./site2/deploy-prod2-5gcore.sh

# "Retrieve Istio CA Root certificates"
#PROD1_MESH_CERT=$(oc get configmap -n prod1-mesh istio-ca-root-cert -o jsonpath='{.data.root-cert\.pem}' | sed ':a;N;$!ba;s/\n/\\\n    /g')
#echo $PROD1_MESH_CERT

# Enable federation for site2
# cp site2/mesh-ca-root-cert.bak site2/prodmeshcarootcert.yaml
# sed -e "s:<PROD1_MESH_CERT>:$PROD1_MESH_CERT:g" site2/prod1meshcarootcert.yaml
#oc apply -f site2/prod1meshcarootcert.yaml
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
