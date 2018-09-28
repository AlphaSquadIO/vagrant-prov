
#1

Run ./bootstrap-hosts.sh on local

#2
Run bootstrap-hosts for all

- vagrant ssh kmaster
- sudo su
- /vagrant/bootstrap-hosts.sh
- test, and if successful response and check ip address
	- ping workspace
	- ping kmaster
	- ping kworker01lx
	- ping kworker02lx

- vagrant ssh kworker01lx
- sudo su
- /vagrant/bootstrap-hosts.sh
- test, and if successful response and check ip address
	- ping workspace
	- ping kmaster
	- ping kworker01lx
	- ping kworker02lx

- vagrant ssh kworker02lx
- sudo su
- /vagrant/bootstrap-hosts.sh
- test, and if successful response and check ip address
	- ping workspace
	- ping kmaster
	- ping kworker01lx
	- ping kworker02lx	

- vagrant ssh workspace
- sudo su
- /vagrant/bootstrap-hosts.sh
- test, and if successful response and check ip address
	- ping workspace
	- ping kmaster
	- ping kworker01lx
	- ping kworker02lx	

#2
bootstrap-ssh for all

- vagrant ssh kmaster
- sudo su
- /vagrant/bootstrap-ssh.sh
- test, and if successful response
	- ssh -i /vagrant/config/ssh/idkey root@localhost
	- ssh -i /vagrant/config/ssh/idkey deploy@localhost
	- exit
	- exit
	- vagrant ssh kmaster
	- ssh -i config/ssh/idkey root@kmaster


- vagrant ssh kworker01lx
- sudo su
- /vagrant/bootstrap-ssh.sh
- test, and if successful response and check ip address
	- ssh -i /vagrant/config/ssh/idkey root@localhost
	- ssh -i /vagrant/config/ssh/idkey deploy@localhost
	- exit
	- exit
	- vagrant ssh kworker01lx
	- ssh -i config/ssh/idkey root@kworker01lx

- vagrant ssh kworker02lx
- sudo su
- /vagrant/bootstrap-ssh.sh
- test, and if successful response and check ip address
	- ssh -i /vagrant/config/ssh/idkey root@localhost
	- ssh -i /vagrant/config/ssh/idkey deploy@localhost
	- exit
	- exit
	- vagrant ssh kworker02lx
	- ssh -i config/ssh/idkey root@kworker02lx

- vagrant ssh workspace
- sudo su
- /vagrant/bootstrap-ssh.sh
- test, and if successful response and check ip address
	- ssh -i /vagrant/config/ssh/idkey root@localhost
	- ssh -i /vagrant/config/ssh/idkey deploy@localhost
	- exit
	- exit
	- vagrant ssh workspace
	- ssh -i config/ssh/idkey root@workspace

#3
bootstrap-workspace-ssh on workspace
test

bootstrap-ansible on workspace

