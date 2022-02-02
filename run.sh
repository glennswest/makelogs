oc delete project/rezex
sleep 15
oc new-project rezex
oc create -f app.yaml

