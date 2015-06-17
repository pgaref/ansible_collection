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
 

### Ansinble Command line usage ###

Inside the cloned directory (ansible_playbooks):

* ansible-playbook ping.yml --vault-password-file=vault.txt
* ansible-playbook build_tools-git-clone-update.yml  --vault-password-file=vault.txt