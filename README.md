# README #

This README would normally document whatever steps are necessary to get your application up and running.

### What is this repository for? ###

* Quick summary
* Version
* [Learn Markdown](https://bitbucket.org/tutorials/markdowndemo)

### How do I get set up? ###

Ansible is a radically simple IT automation tool that makes your applications and systems easier to deploy. 
***REMOVED*** developers can use it internally to avoid writing scripts or custom code to deploy and update their applications.
Tasks can be utomated in a language that approaches plain English, using SSH, with no agents to install on remote systems (not a centralised solution like puppet of chef).

For conveninience in ***REMOVED*** we are also using a web interface called Semaphore extended to fit our own needs.
Semaphore is similar to ansible Tower but it is open-source!
The interface is available at: (http://db07.***REMOVED***.co:80)[http://db07.***REMOVED***.co:80]

Credentials:
* username: panagiotis@***REMOVED***.co
* password: CastawayLabs

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


### Installing a Role

For example mesos cluster - machine roles are defined under roles/ansible-mesos/inventory

* ansible-playbook roles/ansible-mesos/mesos-install.yml -i roles/ansible-mesos/inventory/ -s -vvv --vault-password-file=/opt/ansible_playbooks/vault.txt -k --sudo
