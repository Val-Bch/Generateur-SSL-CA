#!/bin/bash
########################################################################################
# Créer des certificats SSL auto-signés et créer sa propre autorité de certification
########################################################################################

######################
# Demande du domaine de travail local, du FQDN du serveur et de la durée de validité
read -p 'Saisir le domaine (ex : exemple.fr) : ' valueDomain
read -p 'Saisir le FQDN du serveur (ex : toto.exemple.fr) : ' valueFQDN
read -p 'Saisir la validité du certificat, en jours (ex : 3650 = 10 ans) : ' valueDate

######################
# Generation de la clé privée de la CA
openssl genrsa -des3 -out CA_$valueFQDN.key 2048

######################
# Generation de certificat racine de la CA
openssl req -x509 -new -nodes -key CA_$valueFQDN.key -sha256 -days $valueDate -out CA_$valueFQDN.pem

########################################################################################
# Création d'un certificat CA-signé
########################################################################################

######################
# Generation de la clé privée client
[[ -e $valueFQDN.key ]] || openssl genrsa -des3 -out $valueFQDN.key 2048

######################
# Création de la requête du certificate-signing
[[ -e $valueFQDN.csr ]] || openssl req -new -key $valueFQDN.key -out $valueFQDN.csr

######################
# Création d'un fichier de conf pour le SAN afin de respecter les conditions de Chrome>v.58
>$valueFQDN.ext cat <<-EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names
[alt_names]
DNS.1 = *.$valueDomain
EOF

######################
# Création du certificat client auto signé 
openssl x509 -req -in $valueFQDN.csr -CA CA_$valueFQDN.pem -CAkey CA_$valueFQDN.key -CAcreateserial \
-out $valueFQDN.crt -days $valueDate -sha256 -extfile $valueFQDN.ext

######################
#Génération d'un fichier .pfx (pkcs12)
openssl pkcs12 -export -out $valueFQDN.pfx -inkey $valueFQDN.key -in $valueFQDN.crt -certfile CA_$valueFQDN.pem
