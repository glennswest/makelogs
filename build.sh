./delete.sh
export GIT_COMMIT=$(git rev-parse --short HEAD)
rm -r -f tmp
mkdir tmp
echo $GIT_COMMIT > commit.id
docker build --no-cache -t glennswest/makelogs:$GIT_COMMIT .
docker tag glennswest/makelogs:$GIT_COMMIT  docker.io/glennswest/makelogs:$GIT_COMMIT
docker push docker.io/glennswest/makelogs:$GIT_COMMIT
rm app.yaml.old
mv app.yaml app.yaml.old
cat << EOF > app.yaml
apiVersion: v1
kind: Pod
metadata:
  name: makelogs
spec:
  containers:
  - image: docker.io/glennswest/makelogs:$GIT_COMMIT
    name: makelogs
    volumeMounts:
       - name: secret-volume
         mountPath: /etc/secret-volume
         readOnly: true
  volumes:
    - name: secret-volume
      secret:
        secretName: makelogs-secret
EOF

