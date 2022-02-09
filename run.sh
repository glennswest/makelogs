oc delete project/makelogs
sleep 15
oc new-project makelogs
oc create -f app.yaml
