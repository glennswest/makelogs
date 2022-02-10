oc new-project makelogs
sleep 5
oc create sa makelogsa
sleep 5
export token=`oc sa get-token -n makelogs makelogsa`
echo $token
cat << EOF > makelogsecret.yaml
apiVersion: v1
kind: Secret
metadata:
  name: makelogs-secret
stringData:
  token: $token
EOF
oc create -f makelogsecret.yaml
oc create -f app.yaml
