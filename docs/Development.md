My typical actions on the server.

## Run your code

### Deploy your current code on server (without commiting)
At the first time install python lib:

```bash
pip install watchdog --user python
```

Run script for watching of file changes and sync to server

:radioactive:Be careful with this command!:biohazard:

```bash
#for staging
ansible-playbook -i inventories/staging dev.yml --ask-vault-pass
```

### Upload your ssh pub key for parse user
tag:
- `update_pubkey`

```bash
ansible-playbook -i inventories/staging init.yml -t update_pubkey --ask-vault-pass
```

### Update SSL certificate
Prepare ssl certs somehow :)

tag:
- `update_ssl`

```bash
ansible-playbook -i inventories/staging init.yml -t update_ssl --ask-vault-pass
```

... and restart containers

```bash
ansible-playbook -i inventories/staging main.yml -t 'restart_mongo,restart_parse,restart_nginx,restart_dashboard' --ask-vault-pass
```

### Pull repo from specific branch:
- `repo_branch=feature-v2`

```bash
ansible-playbook -i inventories/staging main.yml -t update_repo -e "repo_branch=feature-v2" --ask-vault-pass
```

### Pull repo with your custom private key:
- `ssh_key_path=~/.ssh/your_private_key`

```bash
ansible-playbook -i inventories/staging main.yml -t update_repo -e "ssh_key_path=~/.ssh/your_private_key" --ask-vault-pass
```

### Pull repo from default branch (*repo_branch* in you .yml file)
tag:
- `update_repo`

```bash
ansible-playbook -i inventories/staging main.yml -t update_repo --ask-vault-pass
```

## Connect to server

Connect to server by ssh.

```bash
ssh root@<your-server-ip> -p9033
```

Not working? Probably you need to [add your public key](Adding_new_engineer.md) on the server.

## Read logs

Logs are stored in `/var/log/docker/`.<br/>

Each container has own logs. For example, parse server logs are available:

`cat /var/log/docker/server.log`

interactive mode:<br/>

`tail -f /var/log/docker/server.log`

## Restart parse server

### Restart parse-server container
tag:
- `restart_parse`

```bash
ansible-playbook -i inventories/staging main.yml -t restart_parse --ask-vault-pass
```

### Restart server manually

List of running containers:<br/>
`docker ps`

Restart server:<br/>
`docker restart parse_server`

## Manually run scripts/jobs

Open bash terminal in parse_server container:<br/>
`docker exec -it parse_server bash`

See list of things:<br/>
`ls`


Run job:<br/>
`docker exec -it parse_server node ./cloud/jobs/jobMarkVideosAsOld.js`

## Add new job

Please, refer to [Jobs](Jobs.md)

### Read scheduled jobs

`crontab -u parse -l`
