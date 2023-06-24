sudo rm -r fabric-ca
docker stop $(docker ps -aq)
docker rm $(docker ps -aq)
