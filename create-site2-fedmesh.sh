PROD1_MESH_CERT=$(oc get configmap -n prod1-mesh istio-ca-root-cert -o jsonpath='{.data.root-cert\.pem}' | sed ':a;N;$!ba;s/\n/\\\n    /g')
echo $PROD1_MESH_CERT > PROD1_MESH_CERT.TXT

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
