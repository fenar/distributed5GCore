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

PROD1_MESH_CERT=$(oc get configmap -n prod1-mesh istio-ca-root-cert -o jsonpath='{.data.root-cert\.pem}' | sed ':a;N;$!ba;s/\n/\\\n    /g')
echo $PROD1_MESH_CERT > PROD1_MESH_CERT.TXT
