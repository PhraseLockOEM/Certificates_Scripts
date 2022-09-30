## FIDO2 Compatible Certificate Generating Scripts

### Why do I need a certificate to build an FIDO2 token?

CTAP2, better known as FIDO2, is the fulfilling of the promise to get rid of passwords by using asymmetric certificates. by executing the script <b>make_fido2_certs.sh</b> a pkcs#12 certificates is created into <b>FIDO2CERT</b>.


Below you can see three parameters that define you certificate.
The file <b>ctap2-extensions-x509.cnf</b> is used in the script to make the certificate usable for a FIDO token.


Root- and client-certificates need some more parameters to make them, not at least, human readable. Please take a look to the parameters <b>ca_param</b> and <b>cert_param</b>. If you have no clue what all the items are good for, please read appropriate  documentation about openssl.


__*Please be aware that executing the script requires openssl installed. Windows WLS is not recommended. Better run it on Linux or Mac*__

```
cert_base_name="my_fido2_cert"
cert_pwd="my_secret_cert_pa&&word"
duration="3652"
...
...
ca_param="/C=XX/ST=XXX/L=my_land/OU=my_department/O=my_company/CN=My CTAP2 Root Certificate/emailAddress=john.steam@mycompany.com"
cert_param="/C=XX/ST=XXX/L=my_land/OU=Authenticator Attestation/O=my_company/CN=MY CTAP2 Certificate/emailAddress=john.steam@mycompany.com"

```


*If you want to learn more about FIDO and what this beautifull technology can do for you , please read the specification. But don't be inpatient with yourself if you feel confused.*



[Client to Authenticator Protocol (CTAP2)](
https://fidoalliance.org/specs/fido-v2.1-ps-20210615/fido-client-to-authenticator-protocol-v2.1-ps-20210615.html)
