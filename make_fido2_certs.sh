#!/bin/bash

if [[ ! -d ./FIDO2CERT ]]
then
	echo "./FIDO2CERT folder does not exist!"
	mkdir FIDO2CERT
fi

### ------------ START: This are the parameter of the certificate! Be carefull on editing ------------ ###

cert_base_name="my_fido2_cert"
cert_pwd="my_secret_cert_pa&&word"
ec_curve="prime256v1"
duration="3652"

ca_param="/C=XX/ST=XXX/L=my_land/OU=my_department/O=my_company/CN=My CTAP2 Root Certificate/emailAddress=john.steam@mycompany.com"
cert_param="/C=XX/ST=XXX/L=my_land/OU=Authenticator Attestation/O=my_company/CN=MY CTAP2 Certificate/emailAddress=john.steam@mycompany.com"

### ------------ END: This are the parameter of the certificate! Be carefull on editing ------------ ###


### CA certificate creation

openssl ecparam -name $ec_curve -genkey -noout -out $cert_base_name"ca.key"
openssl req -new -x509 -sha256 -key $cert_base_name"ca.key" -out $cert_base_name"ca.pem" -days $duration -subj "$ca_param" 

### FIDO2 certificate creation as p12 (pkcs#12)
openssl ecparam -name $ec_curve -genkey -noout -out $cert_base_name".key"
openssl req -new -sha256 -key $cert_base_name".key" -out $cert_base_name".csr" -subj "$cert_param"
#openssl x509 -req -in $cert_base_name".csr" -CA $cert_base_name"ca.pem" -CAkey $cert_base_name"ca.key" -CAcreateserial -out $cert_base_name".crt" -days $duration -sha256
openssl x509 -req -extensions v3_ca -extfile ./ctap2-extensions-x509.cnf -in $cert_base_name".csr" -CA $cert_base_name"ca.pem" -CAkey $cert_base_name"ca.key" -CAcreateserial -out $cert_base_name".crt" -days $duration -sha256
openssl pkcs12 -export -passout pass:$cert_pwd -out $cert_base_name".p12" -inkey $cert_base_name".key" -in $cert_base_name".crt"
openssl pkcs12 -export -passout pass:$cert_pwd -out $cert_base_name"ca_cert.p12" -inkey $cert_base_name".key" -in $cert_base_name".crt" -certfile $cert_base_name"ca.pem"
openssl pkcs12 -passin pass:$cert_pwd -in $cert_base_name".p12" -out $cert_base_name".pem" -nodes

### copying
cp $cert_base_name".p12" ./FIDO2CERT/

### Clean up
rm -rf *.key
rm -rf *.pem
rm -rf *.p12
rm -rf *.csr
rm -rf *.srl
rm -rf *.crt
