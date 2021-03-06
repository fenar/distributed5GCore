#!/usr/bin/env bash
#Author: fenar
oc new-project open5gran
oc adm policy add-scc-to-user anyuid -z default -n open5gran
oc adm policy add-scc-to-user hostaccess -z default -n open5gran
oc adm policy add-scc-to-user hostmount-anyuid -z default -n open5gran
oc adm policy add-scc-to-user privileged -z default -n open5gran
cd 5gran
rm templates/5gran-gnb-configmap.yaml
rm templates/5gran-ue-configmap.yaml
## gNB Section
echo "Preparing gNB config"
oc get nodes -o wide | grep worker | awk '{print $6}' | head -1 > prod1-worker-ip
echo "Worker Node IP:" && cat prod1-worker-ip
cp templates/5gran-gnb-configmap.bak templates/5gran-gnb-configmap.yaml
cp templates/5gran-ue-configmap.bak templates/5gran-ue-configmap.yaml
sed -e "s/<put-your-amf-service-ip-here>/$(<prod1-worker-ip sed -e 's/[\&/]/\\&/g' -e 's/$/\\n/' | tr -d '\n')/g" -i templates/5gran-gnb-configmap.yaml
echo "gNB Config:" && cat templates/5gran-gnb-configmap.yaml
helm install -f values.yaml 5gran-prod1 ./
echo "Enjoy The 5GRAN!"
