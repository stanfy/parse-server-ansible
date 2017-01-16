# Cloud jobs configuration

* Use next lines for configuration in `all.yml` or override in `staging.yml`/`production.yml`

```bash
# Job files location
parse_job_dir: "./cloud/jobs"

# Log files location
logger_log_jobs_dir: "{{ logger_log_dir }}/jobs"

# Cron jobs
cron_jobs:
  - { name: "some script 1",
      minute: "*/1",
      hour: "*",
      day: "*",
      weekday: "*",
      month: "*",
      job: "test1.js" }
  - { name: "some script 2",
      minute: "3",
      hour: "*/2",
      day: "5,12,24",
      weekday: "*",
      month: "*",
      job: "test2.js" }
```

### Deploy jobs to server cron file  

```bash
ansible-playbook -i inventories/staging cron.yml
```


### Read scheduled jobs

`crontab -u parse -l`

### Read logs

`tail -f /var/log/docker/jobs/<jobFileName>`