# Accessing database with [Robomongo](https://robomongo.org/) app

## 1. Download and install Robomongo for your platform

## 2. Create new connection:
a. Open MongoDB connections, new connection.  
b. In "Connection" tab, fill the fields:  
![connection tab](./docs/pics/connection-tab.png)
  address: hostname of the application  
  port: public port that MongoDB is listening on
c. "Authentication"
![auth tab](./docs/pics/auth-tab.png)
Set db name to `parse`, while *username* and *password* are available in corresponding yaml configs.
Auth method should be **SCRAM-SHA-1**
d. SSL tab:
![ssl tab](./docs/pics/ssl-tab.png)
Select "use SSL protocol", and "Self-signed certificate" in Authentication Method.  
Leave all other parameters to default.  
e. Click "test" to test your connection and fix problems :)
f. Save and connect