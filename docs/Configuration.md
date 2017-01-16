**Goal:**

We are going to create new git repository and configure your server (Droplet) to run Parse Server.

**Expected result:**

Your repository will contain server configuration. Server environment (pythons packages, docker containers) will be deployed on your Droplet. Parse Server, Mongo and Dashboard will be working on server.


# Step 1. Server configuration

* Create DO droplet (`Ubuntu 16.04 x64`), launch it, and get ip

## DevOps things:

* You need to prepare client certificate, please read [Prepare chains of certs](docs/SSL.md)
* Prepare DNS name in your DNS account with ip from previous step


# Step 2. Script configuration

Script is a thing that will deploy everything on server.


## 2.1 Generate configuration files (Init setup)


* Run first script, you need prepared staging password and folder with client's ssl

```bash
./scripts/init-new-project.sh
```

* Add your remote origin url to parse server project

```bash
git remote add origin ssh://git@github.com:your-project.git
```

#### Important: save all generated keys into your project's wiki! They are important!

* Edit inventories files, set ip for server

``` bash
nano inventories/staging
nano inventories/production
```

* Edit common config

``` bash
nano group_vars/all.yml
```

* Edit staging/production config

``` bash
nano group_vars/staging.yml
nano group_vars/production.yml
```


* Edit `newrelic.js` in the root folder with correct `app_name`

* Edit `package.json` in the root folder with correct npm versions

* Commit and push to remote git

### 2.2 Run Script

* Run ansible init script for setup staging/production

```bash
# for staging
ansible-playbook -i inventories/staging init.yml --ask-vault-pass --extra-vars "ansible_port=22 drop_database=true"
```

```bash
# for production
ansible-playbook -i inventories/production init.yml --ask-vault-pass --extra-vars "ansible_port=22 drop_database=true"
```

Where:
- `-i inventories/production.yml` use specific inventory file with ip
- `--ask-vault-pass` use for staging/production password asking
- `--extra-vars "ansible_port=22"` use env ansible_port=22
- `drop_database=true` will drop whole MongoDb; it's required if you want to migrate database from Parse.

This script will use your configuration files and setup everything on server.

### Troubleshooting


#### I see scary 'you're under MitM attack' message.

Smth like this: "WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED! IT IS POSSIBLE THAT SOMEONE IS DOING SOMETHING NASTY! Someone could be eavesdropping on you right now (man-in-the-middle attack)!".
<br/>
No worries. Server's ssh key was changed. All you need to do is to remove server's ip from known_hosts file.

```bash
open ~/.ssh/known_hosts
```

and remove server's ip (probably the last row).

## What's next?

- migrate MongoDB
- make sure that server's code is working
- setup monitoring
