# README #

### This is a collection of ansible playbook *tasks* and *roles* for managing efficiently a cluster of servers. ###

#### Tasks include: ####
* Quick summary
* Version
* [Learn Markdown](https://bitbucket.org/tutorials/markdowndemo)

### What is Ansible? ###

Ansible is a radically simple IT automation tool that makes your applications and systems easier to deploy. 
Developers can use it internally to avoid writing scripts or custom code to deploy and update their applications.
Tasks can be automated in a language that approaches plain English, using SSH, with no agents to install on remote systems (not a centralised solution like puppet of chef).

Ansible tasks/commands/roles are usually triggered from command line like: ** ansible-playbook roles/ansible-rabbitmq/rabbitMQ-install.yml **

For convenience you could use a web interface like Semaphore which is similar to ansible Tower but it is open-source!

## Basics ##

TODO: Explain playbooks

You can use ansible:
* either from the command line like: **ansible-playbook semaphore_local-repo_update.yml**
* either using the web iterface (Semaphore).
In the second senario make sure you run semaphore local repo update task to make sure semaphore's repo (running at docker) is synchronised with the latest changes.
 

## Moving a Step further ##

TODO: Explain vault encryption and pub/private keys.


### Ansinble Command line usage ###

Inside the cloned directory (ansible_playbooks):

* ansible-playbook ping.yml --vault-password-file=vault.txt
* ansible-playbook build_tools-git-clone-update.yml  --vault-password-file=vault.txt


### Ansible Ad-hoc Commands ###

If you want install a package or run an one time commeand there is not neeed to create a new playbook.
You can use ansible ad-hock commands

* ansible local -m apt -a "name=libssl-dev state=present" -u admin -k --sudo : Ensure a package is installed, but don’t update it
* ansible databases -s -m apt -a "name=libffi-dev state=present" -k -u admin
* ansible databases -m shell -a 'sudo apt-get update; sudo pip install -U pip setuptools wheel virtualenv; echo 'DONE'' -k -u admin --sudo



### Server Tasks

To install and configure java8 for the cluster run:

* ansible-playbook tasks/servers/java8_default.yml -s -vvv --vault-password-file=/opt/ansible_playbooks/vault.txt -k --sudo

### Installing a Role

Rolles define a specific behaviour of a machines.. Currently supported roles:

Mesos cluster - machine roles are defined under roles/ansible-mesos/inventory

* ansible-playbook roles/ansible-mesos/mesos-install.yml -i roles/ansible-mesos/inventory/ -s -vvv --vault-password-file=/opt/ansible_playbooks/vault.txt -k --sudo

RabbitMQ supporting clustering and custom partioning errors handling:

*  ansible-playbook roles/ansible-rabbitmq/ -i roles/ansible-rabbitmq/inventory/ -s -vvv --vault-password-file=/opt/ansible_playbooks/vault.txt -k --sudo