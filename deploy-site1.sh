#!/bin/bash

set -e

log() {
  echo
  echo "##### $*"
}

# to do: switch context: oc config use-context prod1-cluster
log "Creating projects for prod-mesh"
oc new-project prod1-mesh || true
oc new-project prod1-5gcore || true
oc adm policy add-scc-to-user anyuid -z default 
oc adm policy add-scc-to-user hostaccess -z default 
oc adm policy add-scc-to-user hostmount-anyuid -z default 
oc adm policy add-scc-to-user privileged -z default 

log "Installing control plane for prod-mesh"
oc apply -f site1/smcp.yaml
oc apply -f site1/smmr.yaml

# to do: switch context: oc config use-context prod1-cluster
log "Waiting for prod1-mesh installation to complete"
oc wait --for condition=Ready -n prod1-mesh smmr/default --timeout 300s

# to do: switch context: oc config use-context prod1-cluster
oc project prod1-5gcore
log "Installing 5gcore in Site01"
./site1/deploy-prod1-5gcore.sh

# to do: switch context: oc config use-context prod1-cluster
#log "Retrieving Istio CA Root certificates"
# to do: switch context: oc config use-context prod2-cluster
PROD2_MESH_CERT=$(oc get configmap -n prod2-mesh istio-ca-root-cert -o jsonpath='{.data.root-cert\.pem}' | sed ':a;N;$!ba;s/\n/\\\n    /g')
echo $PROD2_MESH_CERT

# to do: switch context: oc config use-context prod1-cluster
log "Enabling federation for site1"
oc project prod1-mesh
cp site1/mesh-ca-root-cert.bak site1/prod2meshcarootcert.yaml
cat site1/prod2meshcarootcert.yaml
echo "Embed the CA Cert Pasted Above in to site1/prod2meshcarootcert.yaml"
#sed -e "s:<PROD2_MESH_CERT>:$PROD2_MESH_CERT:g" site1/prod2meshcarootcert.yaml 
#oc apply -f site1/prod2meshcarootcert.yaml
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
