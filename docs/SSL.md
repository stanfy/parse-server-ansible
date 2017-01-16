# Prepare ssl chains

* Get next files from your SSL service
 * ssl.csr (Certificate signing request)
 * ssl.key (Private key)
 * ssl.crt (Public cert)
 * intermediateCA.crt ( several CA cert for authority chain )
* Create pem file for mongo
```bash
cat ssl.key ssl.crt > ssl.pem
```
* Create CA pem file in proper order from intermediateCALocal -> intermediateCAMain -> rootCA
Example:
```bash
cat intermediateCALocal.crt intermediateCAMain.crt rootCA.crt > ca.pem
```
* Add CA certificates to ssl-bundle.pem
```bash
cat ssl.crt ca.pem > ssl-bundle.pem
```
