export home=$PWD
myArray=('manufacturer' 'distributor1' 'distributor2' 'retailer1' 'retailer2' 'orderer')

./create-folder-structure.sh
docker-compose up -d
sleep 2

copyRootCertsForAllOrgsTlsCa() {
    cd $home
    for i in ${!myArray[@]}; do
        export orgVar=${myArray[$i]}
        cp fabric-ca/fabric-ca-servers-tls/$orgVar-ca-tls/ca-cert.pem fabric-ca/fabric-ca-client/tls-root-certs/$orgVar/tls-ca-cert.pem
    done
}

copyRootCertsForAllOrgsTlsCa

enrollAdminForAllOrgsTlsCa() {
    export FABRIC_CA_CLIENT_HOME=${home}/fabric-ca/fabric-ca-client
    for i in ${!myArray[@]}; do
        export orgVar=${myArray[$i]}
        export port=$(($i + 7054))
        fabric-ca-client enroll -d -u https://admin:adminpw@localhost:$port --tls.certfiles tls-root-certs/$orgVar/tls-ca-cert.pem --enrollment.profile tls --mspdir tls-ca/tls-ca-admins/$orgVar-tls-ca-admin/msp
    done
}

enrollAdminForAllOrgsTlsCa
sleep 1

getTlsCertsForAllOrgsCaAdmin() {
    export FABRIC_CA_CLIENT_HOME=${home}/fabric-ca/fabric-ca-client
    for i in ${!myArray[@]}; do
        export orgVar=${myArray[$i]}
        export port=$(($i + 7054))
        fabric-ca-client register -d --id.name rcaadmin --id.secret rcaadminpw -u https://localhost:$port --tls.certfiles tls-root-certs/$orgVar/tls-ca-cert.pem --mspdir tls-ca/tls-ca-admins/$orgVar-tls-ca-admin/msp
    done

    for i in ${!myArray[@]}; do
        export orgVar=${myArray[$i]}
        export port=$(($i + 7054))
        fabric-ca-client enroll -d -u https://rcaadmin:rcaadminpw@localhost:$port --tls.certfiles tls-root-certs/$orgVar/tls-ca-cert.pem --enrollment.profile tls --csr.hosts 'localhost' --mspdir tls-ca/org-ca-admins/$orgVar/msp
        cd ${home}/fabric-ca/fabric-ca-client/tls-ca/org-ca-admins/$orgVar/msp/keystore
        mv * key.pem
        cd ${home}/fabric-ca
        cp fabric-ca-client/tls-ca/org-ca-admins/$orgVar/msp/keystore/key.pem fabric-ca-servers-org/$orgVar/tls/key.pem
        cp fabric-ca-client/tls-ca/org-ca-admins/$orgVar/msp/signcerts/cert.pem fabric-ca-servers-org/$orgVar/tls/cert.pem
    done
}

getTlsCertsForAllOrgsCaAdmin
sleep 1

enrollOrgCaAdminForAllOrgs() {
    export FABRIC_CA_CLIENT_HOME=${home}/fabric-ca/fabric-ca-client
    cd ${home}
    docker-compose -f ./docker-compose-orgs-ca.yaml up -d
    sleep 1

    for i in ${!myArray[@]}; do
        export orgVar=${myArray[$i]}
        export port=$(($i + 7060))
        fabric-ca-client enroll -d -u https://rcaadmin:rcaadminpw@localhost:$port --tls.certfiles tls-root-certs/$orgVar/tls-ca-cert.pem --mspdir org-ca/$orgVar/msp
    done

}

enrollOrgCaAdminForAllOrgs
