myArray=('manufacturer' 'distributor1' 'distributor2' 'retailer1' 'retailer2')
for i in ${!myArray[@]}; do
    export orgVar=${myArray[$i]}
    export port=$(($i + 7054))
    echo $orgVar $port
done
