<h3 align="center">
  <a href="https://stanfy.com"><img src="docs/pics/parse_ansible.png" alt="Parse Ansible Playbook — a magic tool to rule Parse Server backends." width="1310"></a>
  <br>
  <br>
  Parse Server Ansible Playbook — a magic tool to rule Parse Server backends
  <br>
  <br>
</h3>

-----

Create Parse Server backend with RockDB Database and Parse Dashboard. Easily deploy Cloud Code, add indexes, set up Cloud Jobs and monitor your server. 
<br>

## Why?
We migrated many projects from Parse.com and doing it manually means doing many things again and again. Of course, it’s better to automate everything. We created an ansible playbook for all recurrent tasks. The basic idea is that you don’t need to login on the server via ssh every time you want to deploy new code or restart server. Just run one script command from your local machine and enjoy.

## Migration plan
Ready? Steady? Go!

1. Refactor Cloud Code to be compatible with Parse Server (read this post if you want to know more).
2. Register production Digital Ocean account.
3. Register domain name.
4. Register SSL cert (it’s better to register wildcard certificate, it will allow you to use same domain name with different subdomains).
5. Setup Digital Ocean droplet (select pricing plan / server capacities).
6. Install & run Parse Server.
7. Install MongoDB with secure connection (enable SSL).
8. Install & run Parse Dashboard (enable authentication).
9. Deploy cloud code (and pray).
10. Create Amazon S3 bucket and link Parse Server to it (setup file storage for PFFiles).
11. Setup & enable APNS certificates (push notifications should work).
12. Configure custom logger (we used Winston).
13. Configure logrotate for log files.
14. Schedule (cron) Cloud jobs.
15. Migrate production database (partially, for testing). 
16. Create database indexes.
17. Check app/server performance (pay attention on response time).
18. Check backward compatibility (users should be able to update their old app, that is linked to Parse.com, to the new app, linked to your new server, without any problems and missing data).
19. Turn on permanent migration for Parse database. Submit application to the Store.
20. Monitor all the things! Pay attention on server behavior, response time, error rate.

We use the script to automate steps 6-16, basically, everything that deals with infrastructure and services setup.


## Get Started

1. Make sure that **ansible is installed**. <br/>
Check the [Installation guide for ansible](docs/Installation.md).<br/><br/>

2. Use [template project](templates/default-project) to create basic server project with all required configuration files.

3. Are you gonna configure new server to setup parse-server? <br/>
You need to **prepare SSL certificates** and **create configuration files** for new server.<br/>
Read how to [configure files](docs/Configuration.md) for a new project.<br/><br/>
  - More details about SSL certificates are described here – <br/>
  [Prepare chains of certs](docs/SSL.md)<br/><br/>

4. Read more about Mongo container and typical actions with MongoDB. **Migrate MongoDB!** Create database indexes, create backups and many more! <br/>
[Mongo container](docs/Mongo.md)<br/><br/>

5. Okay, droplet is set, ready to **deploy new code**?<br/>
[Development](docs/Development.md)<br/><br/>

6. **Setting up Cloud jobs?** Check how!<br/>
[Cloud jobs configuration](docs/Jobs.md)<br/><br/>

7. **Adding monitoring?** See our suggestions!<br/>
[Monitoring configuration](docs/Monitoring.md)<br/><br/>

8. Read more about **S3 database backup**. It's always better to have backups, right?<br/> 
[S3 database backup](docs/S3-backup.md)<br/><br/>

# Full documentation

Magic [docs folder](docs) contains ever-evolving official documentation, which contains everything from how to use it docs to examples and pics. 

## Any questions?

Open an issue!


You may find these posts useful:

- [Adventures with Parse Server hosted on Digital Ocean](https://stanfy.com/blog)
- [How to change Cloud Code to be compatible with Parse Server](https://stanfy.com/blog/how-to-change-cloud-code-to-be-compatible-with-parse-server/)
- [How we migrated to Parse Server, adventures with Heroku and why we broke up](https://stanfy.com/blog/how-we-migrated-to-parse-server-adventures-with-heroku-and-why-we-broke-up/)


💙