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
oc get configmap -n prod2-mesh istio-ca-root-cert -o jsonpath='{.data.root-cert\.pem}' | sed ':a;N;$!ba;s/\n/\\\n    /g' > PROD2_MESH_CERT.TXT

oc apply -f site2/open5gcorewebui-expose.yaml
