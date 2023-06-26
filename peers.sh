# ./gen-crypto-artifacts.sh

export home=$PWD
myArray=('manufacturer' 'distributor1' 'distributor2' 'retailer1' 'retailer2' 'orderer')

registerAndEnrollPeer() {
  export FABRIC_CA_CLIENT_HOME=${home}/fabric-ca/fabric-ca-client
  for i in ${!myArray[@]}; do
    export orgVar=${myArray[$i]}
    export port=$(($i + 7060))
    fabric-ca-client register -d --id.name peer0_$orgVar --id.secret peerpw -u https://localhost:$port --mspdir org-ca/$orgVar/msp --id.type peer --tls.certfiles tls-root-certs/$orgVar/tls-ca-cert.pem
  done
  sleep 2
  for i in ${!myArray[@]}; do
    export orgVar=${myArray[$i]}
    export port=$(($i + 7060))
    fabric-ca-client enroll -u https://peer0_$orgVar:peerpw@localhost:$port --mspdir ../../organizations/peerOrganizations/$orgVar/peer0.$orgVar/msp --tls.certfiles tls-root-certs/$orgVar/tls-ca-cert.pem
    cd $home/organizations/peerOrganizations/$orgVar/peer0.$orgVar
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
   OrganizationalUnitIdentifier: orderer' >msp/config.yaml

    cd msp/keystore
    mv * key.pem

  done

}

# registerAndEnrollPeer

getTlsCertsForPeer() {
  export FABRIC_CA_CLIENT_HOME=${home}/fabric-ca/fabric-ca-client

  for i in ${!myArray[@]}; do
    export orgVar=${myArray[$i]}
    export port=$(($i + 7054))
    fabric-ca-client register -d --id.name rcaadmin --id.secret rcaadminpw -u https://localhost:$port --tls.certfiles tls-root-certs/$orgVar/tls-ca-cert.pem --mspdir tls-ca/tls-ca-admins/$orgVar-tls-ca-admin/msp
  done

  for i in ${!myArray[@]}; do
    export orgVar=${myArray[$i]}
    export port=$(($i + 7054))
    fabric-ca-client enroll -d -u https://rcaadmin:rcaadminpw@localhost:$port --tls.certfiles tls-root-certs/$orgVar/tls-ca-cert.pem --enrollment.profile tls --csr.hosts 'localhost' --mspdir ../../organizations/peerOrganizations/$orgVar/peer0.$orgVar/tls
    cd ${home}/organizations/peerOrganizations/$orgVar/peer0.$orgVar/tls/keystore
    mv * key.pem
    cd ../
    mv keystore/key.pem key.pem
    mv signcerts/cert.pem cert.pem
    cd ../
    rm -r tls/cacerts tls/keystore tls/signcerts
    mkdir msp/tlscacerts
    cd tls/tlscacerts
    cp * ../../msp/tlscacerts/
  done
}

# getTlsCertsForPeer

copyOrgMsp() {
  cd $home
  # cp -R fabric-ca/fabric-ca-client/org-ca/* organizations/peerOrganizations
  cd organizations/peerOrganizations
  for i in ${!myArray[@]}; do
    export orgVar=${myArray[$i]}
    cd $orgVar
    # cp peer0.$orgVar/msp/config.yaml msp/config.yaml
    # cp -r peer0.$orgVar/msp/tlscacerts msp
    rm -r msp/keystore msp/signcerts
    cd ../
  done
}

copyOrgMsp
