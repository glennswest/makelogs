export VERBOSE_LOG="true"
export token=`cat /etc/secret-volume/token`
curl --insecure -H "Authorization: Bearer ${token}" https://elasticsearch.openshift-logging:9200
/app/bin/makelogs --verbose --trace --host https://elasticsearch.openshift-logging:9200
while true; do sleep 10000; done
