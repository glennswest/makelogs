export token=`oc sa get-token -n makelogs makelogsa`
echo $token > /etc/secret-volume/token
