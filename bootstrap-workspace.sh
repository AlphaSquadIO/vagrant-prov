KUBE_SETUP=$1

BOOTSTRAPPER_HOME=/home/vagrant/vagrant-prov

$BOOTSTRAPPER_HOME/bootstrap-node.sh
$BOOTSTRAPPER_HOME/lib/bootstrap-ansible.sh $KUBE_SETUP
$BOOTSTRAPPER_HOME/lib/bootstrap-devtools.sh

if [ '$KUBE_SETUP' == 'true' ]
then
	$BOOTSTRAPPER_HOME/lib/bootstrap-workspace-ssh.sh
	$BOOTSTRAPPER_HOME/lib/bootstrap-kubecluster.sh
fi