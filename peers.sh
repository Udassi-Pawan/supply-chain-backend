# ./gen-crypto-artifacts.sh

export home=$PWD
myArray=('manufacturer' 'distributor1' 'distributor2' 'retailer1' 'retailer2')

registerAndEnrollPeer() {
    export FABRIC_CA_CLIENT_HOME=${home}/fabric-ca/fabric-ca-client
    fabric-ca-client register -d --id.name peer0_manufacturer --id.secret peerpw -u https://localhost:7060 --mspdir org-ca/manufacturer/msp --id.type peer --tls.certfiles tls-root-certs/manufacturer/tls-ca-cert.pem
    fabric-ca-client enroll -u https://peer0_manufacturer:peerpw@localhost:7060 --mspdir ../../organizations/peerOrganizations/manufacturer/peer0.manufacturer/msp --tls.certfiles tls-root-certs/manufacturer/tls-ca-cert.pem
    cd $home/organizations/peerOrganizations/manufacturer/peer0.manufacturer
    echo 'NodeOUs:
 Enable: true
 ClientOUIdentifier:
   Certificate: cacerts/localhost-7054-ca-org1.pem
   OrganizationalUnitIdentifier: client
 PeerOUIdentifier:
   Certificate: cacerts/localhost-7054-ca-org1.pem
   OrganizationalUnitIdentifier: peer
 AdminOUIdentifier:
   Certificate: cacerts/localhost-7054-ca-org1.pem
   OrganizationalUnitIdentifier: admin
 OrdererOUIdentifier:
   Certificate: cacerts/localhost-7054-ca-org1.pem
   OrganizationalUnitIdentifier: orderer' to msp >path >msp/config.yaml
}

registerAndEnrollPeer
