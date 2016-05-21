Ansible Cluster Management
================

This is a collection of ansible playbook *tasks* and *roles* for managing efficiently a cluster of servers.

# What is Ansible?
Ansible is a radically simple IT automation tool that makes your applications and systems easier to deploy. 
Developers can use it internally to avoid writing scripts or custom code to deploy and update their applications.
Tasks can be automated in a language that approaches plain English, using SSH, with no agents to install on remote systems (not a centralised solution like puppet of chef).

Ansible also emphasises push mode, where configuration is pushed from a master machine. This mode is really interesting since you do not need to have a 'publicly' accessible 'master' to be able to configure remote nodes: it's the nodes that need to be accessible (we'll see later that 'hidden' nodes can pull their
configuration too!), and most of the time they are.

Ansible tasks/commands/roles are usually triggered from command line like: ** ansible-playbook roles/ansible-rabbitmq/rabbitMQ-install.yml ** For convenience, you could use a web interface like Semaphore which is similar to ansible Tower but open-source!



# Prerequisites for Ansible

You need the following python modules on your machine (the machine you run ansible 
on) 
- python-yaml
- python-jinja2

On Debian/Ubuntu run:
``sudo apt-get install python-yaml python-jinja2 python-paramiko python-crypto``


# Basics

**An ad-hoc** command is something that you might type in to do something really quick, but don't want to save for later.

**Playbooks** are Ansible's configuration, deployment, and orchestration language. They can describe a policy you want your remote systems to enforce, or a set of steps in a general IT process.

[Terminology](https://docs.ansible.com/ansible/glossary.html):
 - [commands or actions](https://docs.ansible.com/ansible/intro_adhoc.html)
 - [ansible modules](https://docs.ansible.com/ansible/modules.html) like just a shell command
 - task: combines an action (a module and its arguments) with a name and optionally some other keywords (like looping directives).
 - [playbook](https://docs.ansible.com/ansible/playbooks_intro.html): an yaml file contains roles executed in sequence, and eventually individual tasks.
 - [role](https://docs.ansible.com/ansible/playbooks_roles.html): an organisational unit grouping tasks together in order to install a piece of software.



# Contents

This repository contains a number of **tasks** I found useful when managing a number of machines. These include playbooks, roles, and jenkins-playbooks.

### Playbooks

1. [User Management](./tasks/users/sshd_auth.yml)
  * **Usage:** This playbook is managing *admin*, *root* and *spark* users. The concept is that multiple users want to have access to the accounts above using their rsa keys. The playbook is reading */files/keys* folder containing all the user keys by name and [ssh_users.yml](./vars/ssh_users.yml) file which defines the users granted access to an account.
  * **Command:** ``ansible-playbook tasks/users/sshd_auth.yml --vault-password-file=/opt/ansible_playbooks/vault.txt -k --sudo``
  * **Configuration:** If you need to add a user just add his pub key under /files/keys and then update the [ssh_users.yml](./vars/ssh_users.yml) file. To remove a user just turn the acces flag to false and rerun the playbook
2. [Golang Install/Upgrade](./tasks/servers/golang_update.yml)
  * **Command:** ``ansible-playbook tasks/servers/golang_update.yml --vault-password-file=/opt/ansible_playbooks/vault.txt -k --sudo``
  * **Configuration:** If you need to change GO version just change the go_version, go_tarball and go_tarball_checksum variables at [main.yml](./defaults/main.yml) according to the new version details as found at [http://golang.org/dl/](http://golang.org/dl/)
3. [Java 8 Setup](./tasks/servers/java8_default.yml)
  * **Command:** ``ansible-playbook tasks/servers/java8_default.yml --vault-password-file=/opt/ansible_playbooks/vault.txt -k --sudo``
4. [UTC Timezone](./tasks/servers/timezone_UTC.yml)
  * **Command:** ``ansible-playbook tasks/servers/timezone_UTC.yml --vault-password-file=/opt/ansible_playbooks/vault.txt -k --sudo``
5. [fail2ban](./tasks/servers/fail2ban.yml)
  * **Command:** ``ansible-playbook tasks/servers/fail2ban.yml --vault-password-file=/opt/ansible_playbooks/vault.txt -k --sudo``
  * **Configuration:** take a look at [main.yml](./defaults/main.yml) for email, whitelist and log path configuration
  * **Info:** This task is using a jinja to create a custom configuration
6. [UFW](./tasks/servers/firewall.yml)
  * **Command:** ``ansible-playbook tasks/servers/firewall.yml --vault-password-file=/opt/ansible_playbooks/vault.txt -k --sudo``
  * **Configuration:** take a look at [main.yml](./defaults/main.yml) for email and circle-of-trust configuration
  * **Info:** This task is using a jinja to create a custom ufw configuration including the blocked/allowed applications, ips and ports. For more customisation check [main.yml](./defaults/main.yml)
7. [Maintenace (Logwatch Ufw and fail2ban) ](./tasks/servers/maintenance.yml)
  * **Command:** ``ansible-playbook tasks/servers/maintenance.yml --vault-password-file=/opt/ansible_playbooks/vault.txt -k --sudo``
  * **Configuration:** take a look at [main.yml](./defaults/main.yml) for fail2ban email, whitelist and more
8. [Python Launcher Dependencies](./tasks/servers/launcher_python_dependencies.yml)
  * **Command:** ``ansible-playbook tasks/servers/launcher_python_dependencies.yml --vault-password-file=/opt/ansible_playbooks/vault.txt -k --sudo``
  * **Info:** Installs all the package dependencies needed for the interal python launcher to work. To extend the dependency list check [launcher_python_dependencies.yml](./tasks/servers/launcher_python_dependencies.yml)
9. [Build Tools Deploy](./tasks/servers/build_tools-repo-clone-update.yml)
  * **Command:** ``ansible-playbook tasks/servers/build_tools-repo-clone-update.yml --vault-password-file=/opt/ansible_playbooks/vault.txt -k --sudo``
  * **Info:** Installs the build_tools in the machines specified and creates a symbolic link under /usr/bin for launcher and builder scripts
10. [SMTP](./tasks/servers/ssmtp.yml)
  * **Command:** ``ansible-playbook tasks/servers/ssmtp.yml --vault-password-file=/opt/ansible_playbooks/vault.txt -k --sudo``
  * **Info:** Configures SSMTP server agent using credentials specified under [main.yml](./defaults/main.yml)


### Roles

**Roles** define a specific behaviour of a machines. Currently supported roles:

- [Mesos](./roles/ansible-mesos/mesos-install.yml)
  * **Command:** ``ansible-playbook roles/ansible-mesos/mesos-install.yml -i roles/ansible-mesos/inventory/ -s -vvv --vault-password-file=/opt/ansible_playbooks/vault.txt -k --sudo``
  * **Info:** Mesos cluster - machine roles are defined under [inventory](./roles/ansible-mesos/inventory/inventory.yml). Role configuration under [main.yml](./roles/ansible-mesos/defaults/main.yml)
- [RabbitMQ](./roles/ansible-rabbitmq/rabbitMQ-install.yml)
  * **Command:** ``ansible-playbook roles/ansible-rabbitmq/rabbitMQ-install.yml -i roles/ansible-rabbitmq/inventory/ --vault-password-file=/opt/ansible_playbooks/vault.txt --sudo``
  * **Info:** Installs Rabbit either cluster or standalone mode. Playbook supports clustering and custom partioning errors handling (auto_heal mode and HA) using jinja templates here again. Configure rabbit at [main.yml](./roles/ansible-rabbitmq/defaults/main.yml). Configure the deployment hosts at [inventory](./roles/ansible-rabbitmq/inventory/inventory.yml) 


### Jenkins Tasks

**Jenkins** works quite well with ansible, so instead of writing some scripts inside jenkins I replaced them with some playbooks which also take care the deployment of the code executables to all the servers.
Some jenkins-related-playbooks are:

- [Jenkins Web App Build](./tasks/jenkins-web-build.yml)
- [Spark VirtualEnv Update](./tasks/spark/jenkins-virtualenv-update.yml)
- [Firewall Extra rules through jenkins](./tasks/jenkins-firewall.yml)


# Getting Started

1. Make sure you have a user called ansible with root priviledges in all the managed hosts (also disable asking sudo pass for this specific user) 
2. Some playbooks are expecting the ansible_collection (also named ansible_playbooks) folder to be located under /opt - change them to fit your needs
3. Lets create a new user called spark using an ansible playbook
  * Update hosts file with your nodes
  * Update tasks/users/new_user.yml with your PATH
  * Store new user public key under /files/user_keys/spark
  * Run **ansible-playbook tasks/users/new_user.yml  -k -sudo -i hosts**
4. Have fun!

# Extras

## 1. Inventory

[Ansible Inventory usage](./README-Tutorial/inventory.md)


### 2. Ansinble Command line usage ###

Inside the cloned directory (ansible_playbooks):

* ansible-playbook ping.yml --vault-password-file=vault.txt
* ansible-playbook build_tools-git-clone-update.yml  --vault-password-file=vault.txt


### 3. Ansible Ad-hoc Commands ###

If you want install a package or run an one time commeand there is not neeed to create a new playbook.
You can use ansible ad-hock commands

* Ensure a package is installed, but don't update it: ``ansible local -m apt -a "name=libssl-dev state=present" -u admin -k --sudo``
* ``ansible databases -s -m apt -a "name=libffi-dev state=present" -k -u admin``
* ``ansible databases -m shell -a 'sudo apt-get update; sudo pip install -U pip setuptools wheel virtualenv; echo 'DONE'' -k -u admin --sudo``


# References


