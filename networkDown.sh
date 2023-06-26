sudo rm -r fabric-ca organizations
docker stop $(docker ps -aq)
docker rm $(docker ps -aq)
