#oc create sa makelogsa
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



