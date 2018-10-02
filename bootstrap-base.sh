#!/bin/bash

OS_VERSION=$1
PROXY_EXISTS=$2
BOOTSTRAPPER_HOME=$3
INFRASTRUCTURE=$4

echo ""
echo "---> @ Provisioning a Base VM"

echo ""
echo "---> @ Disabling Firewall"

if [ $OS_VERSION == '6' ]
then
  service iptables save
  service iptables stop
  chkconfig iptables off
  service ip6tables save
  service ip6tables stop
  chkconfig ip6tables off
elif [ $OS_VERSION == '7' ]
then
  systemctl stop firewalld 
  systemctl disable firewalld
fi

echo ""
echo "---> @ Setting SELinux to Permissive"
setenforce 0

if [ $PROXY_EXISTS == 'true' ]
then
  echo ""
  echo "---> @ Setting up Proxy"

  echo ""
  echo "-----> @ Setting up CNTLM Proxy"

  if [ $OS_VERSION == '6' ]
  then
    rpm -ivh $BOOTSTRAPPER_HOME/dependencies/proxy/cntlm-0.92.3-1.x86_64.rpm
    mv /etc/cntlm.conf /etc/cntlm.conf.org
    cp $BOOTSTRAPPER_HOME/dependencies/proxy/config/$INFRASTRUCTURE/cntlm.conf /etc/cntlm.conf
    service cntlmd start
    chkconfig cntlmd on
  else
    rpm -ivh $BOOTSTRAPPER_HOME/dependencies/proxy/cntlm-0.92.3-10.el7.x86_64.rpm
    mv /etc/cntlm.conf /etc/cntlm.conf.org
    cp $BOOTSTRAPPER_HOME/dependencies/proxy/config/$INFRASTRUCTURE/cntlm.conf /etc/cntlm.conf
    service cntlm start
    chkconfig cntlm on
  fi


  export http_proxy='http://127.0.0.1:3128'
  export no_proxy="'$HOSTNAME, localhost, source.fxdms.net, build.fxdms.net, *.fxdms.net, 135.101.*, 172.16.*, 192.168.*, 13.198.*'"

  echo "export http_proxy=$http_proxy" > /etc/profile.d/proxy.sh
  echo "export https_proxy=$http_proxy" >> /etc/profile.d/proxy.sh
  echo "export no_proxy=$no_proxy" >> /etc/profile.d/proxy.sh
  echo "export HTTP_PROXY=$http_proxy" >> /etc/profile.d/proxy.sh
  echo "export HTTPS_PROXY=$http_proxy" >> /etc/profile.d/proxy.sh
  echo "export NO_PROXY=$no_proxy" >> /etc/profile.d/proxy.sh
  echo "export RSYNC_PROXY=$http_proxy" >> /etc/profile.d/proxy.sh
  echo "export SSL_CERT_FILE=/etc/pki/tls/cert.pem" >> /etc/profile.d/proxy.sh

  . /etc/profile.d/proxy.sh

  echo "http_proxy=$http_proxy" > /etc/environment
  echo "https_proxy=$http_proxy" >> /etc/environment
  echo "no_proxy=$no_proxy" >> /etc/environment
  echo "HTTP_PROXY=$http_proxy" >> /etc/environment
  echo "HTTPS_PROXY=$http_proxy" >> /etc/environment
  echo "NO_PROXY=$no_proxy" >> /etc/environment
  echo "SSL_CERT_FILE=/etc/pki/tls/cert.pem" >> /etc/environment

  echo "proxy=$http_proxy" >> /etc/yum.conf
  echo "timeout=360" >> /etc/yum.conf

  echo ""
  echo "-----> @ Adding CA Certificates (and ROOT) to CA Truststore"
  yum -y install ca-certificates
  update-ca-trust enable

  openssl x509 -inform der -in $BOOTSTRAPPER_HOME/dependencies/proxy/config/$INFRASTRUCTURE/ssl/ROOT-CA.cer -out  $BOOTSTRAPPER_HOME/dependencies/proxy/config/$INFRASTRUCTURE/ssl/ROOT-CA.pem
  openssl x509 -inform der -in $BOOTSTRAPPER_HOME/dependencies/proxy/config/$INFRASTRUCTURE/ssl/INTERMEDIATE-CA.cer -out $BOOTSTRAPPER_HOME/dependencies/proxy/config/$INFRASTRUCTURE/ssl/INTERMEDIATE-CA.pem
  cp $BOOTSTRAPPER_HOME/dependencies/proxy/config/$INFRASTRUCTURE/ssl/ROOT-CA.pem /etc/pki/ca-trust/source/anchors/
  update-ca-trust extract
  cp $BOOTSTRAPPER_HOME/dependencies/proxy/config/$INFRASTRUCTURE/ssl/INTERMEDIATE-CA.pem /etc/pki/ca-trust/source/anchors
  update-ca-trust extract

fi

echo ""
echo "---> @ Cleaning out any incomplete yum transactions"
yum-complete-transaction

echo ""
echo "---> @ Updating Software"
yum -y install deltarpm
yum -y clean all
yum -y update

echo ""
echo "---> @ Setting up Other Yum Repository"
if [ $OS_VERSION == '6' ]
then
  rpm -ivh $BOOTSTRAPPER_HOME/dependencies/yumrepos/epel-release-6-8.noarch.rpm
else
  rpm -ivh $BOOTSTRAPPER_HOME/dependencies/yumrepos/epel-release-7-8.noarch.rpm
fi

echo "-----> @ Adding plugin priorities to add priorities to each installed repositories"
yum -y install yum-plugin-priorities
sed -i -e "s/\]$/\]\npriority=1/g" /etc/yum.repos.d/CentOS-Base.repo

echo "-----> @ Adding the EPEL Repository provided from the Fedora project"
yum -y install epel-release
sed -i -e "s/\]$/\]\npriority=5/g" /etc/yum.repos.d/epel.repo

echo ""
echo "-----> @ Installing CentOS Software Collections Repository to Allow the Install of the Latest"
yum -y install centos-release-scl

echo ""
echo "---> @ Configuring to accept Self-Signed Certificates"
yum -y install ca-certificates
update-ca-trust enable

echo ""
echo "---> @ Setting up Timezone"
rm -rf /etc/localtime
ln -s /usr/share/zoneinfo/Australia/Sydney /etc/localtime

echo ""
echo "---> @ Setting up NTP"
yum -y install ntp
echo "restrict 10.0.0.0 mask 255.255.255.0 nomodify notrap" >> /etc/ntp.conf
service ntpd start
if [ $OS_VERSION == '6' ]
then
  chkconfig ntpd on
elif [ $OS_VERSION == '7' ]
then
  systemctl enable ntpd
fi
