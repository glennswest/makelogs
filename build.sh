export GIT_COMMIT=$(git rev-parse --short HEAD)
rm -r -f tmp
mkdir tmp
echo $GIT_COMMIT > commit.id
docker build --no-cache -t glennswest/makelogs:$GIT_COMMIT .
docker tag glennswest/makelogs:$GIT_COMMIT  docker.io/glennswest/makelogs:$GIT_COMMIT
docker push docker.io/glennswest/makelogs:$GIT_COMMIT

