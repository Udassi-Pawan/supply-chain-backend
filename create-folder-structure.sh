export home=$PWD

mkdir fabric-ca
cd fabric-ca
mkdir fabric-ca-client fabric-ca-servers-tls
cd fabric-ca-client
mkdir tls-ca tls-root-certs
cd ../fabric-ca-servers-tls
mkdir manufacturer-ca-tls distributor1-ca-tls distributor2-ca-tls retailer1-ca-tls retailer2-ca-tls orderer-ca-tls

cd ${home}

mkdir fabric-ca/fabric-ca-client/tls-root-certs/distributor1/
mkdir fabric-ca/fabric-ca-client/tls-root-certs/distributor2/
mkdir fabric-ca/fabric-ca-client/tls-root-certs/retailer1/
mkdir fabric-ca/fabric-ca-client/tls-root-certs/retailer2/
mkdir fabric-ca/fabric-ca-client/tls-root-certs/manufacturer/
mkdir fabric-ca/fabric-ca-client/tls-root-certs/orderer/

mkdir fabric-ca/fabric-ca-servers-org
cd fabric-ca/fabric-ca-servers-org
mkdir manufacturer distributor1 distributor2 retailer1 retailer2 orderer
mkdir manufacturer/tls distributor1/tls distributor2/tls retailer1/tls retailer2/tls orderer/tls
