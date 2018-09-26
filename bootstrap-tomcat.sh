#!/bin/bash

ENV_LETTER=$1
ENV=env$ENV_LETTER
TOMCAT_INSTANCE_NAME=$2
TOMCAT_LIBS_LIST="$(cat $3)"

REPO_BASE_URL=http://build.fxdms.net/artifactory/auto

TOMCAT_MAJOR_VERSION=7
TOMCAT_VERSION=7.0.67
TOMCAT_BASE_DIR=/lfs/$ENV/apps/tomcat

echo ""
echo "---> @ Provisioning Tomcat $TOMCAT_VERSION for Environment $ENV"

echo "---------> @ Adding Tomcat Bash Scripts for Startup, Shutdown, Restart and Debug..."
BOOTSTRAPPER_HOME=`pwd`
BOOTSTRAP_RESOURCES=$BOOTSTRAPPER_HOME/bootstrap/resources
echo "-----> @ \$BOOTSTRAP_RESOURCES=$BOOTSTRAP_RESOURCES"
mkdir -p ~/bin
cp $BOOTSTRAP_RESOURCES/bin-scripts/tomcat/tomcat* ~/bin/

echo "-----> @ Shutting down any running process for Tomcat apache-tomcat-$TOMCAT_INSTANCE_NAME"
if [ -d $TOMCAT_BASE_DIR/apache-tomcat-$TOMCAT_VERSION-$TOMCAT_INSTANCE_NAME ]
then
  ~/bin/tomcat-shutdown $ENV apache-tomcat-$TOMCAT_INSTANCE_NAME
fi

PID=`pgrep -f "apache-tomcat-$TOMCAT_INSTANCE_NAME"`
if [ -n "$PID" ]
then
  kill -9 $PID
fi

echo "-----> @ Removing Previous Tomcat Installation"
if [ -d $TOMCAT_BASE_DIR/apache-tomcat-$TOMCAT_VERSION ]
then
  rm -rf $TOMCAT_BASE_DIR/apache-tomcat-$TOMCAT_VERSION
fi

if [ -L $TOMCAT_BASE_DIR/apache-tomcat-$TOMCAT_INSTANCE_NAME ]
then
  rm -rf $TOMCAT_BASE_DIR/apache-tomcat-$TOMCAT_INSTANCE_NAME
fi

if [ -d $TOMCAT_BASE_DIR/apache-tomcat-$TOMCAT_VERSION-$TOMCAT_INSTANCE_NAME ]
then
  rm -rf $TOMCAT_BASE_DIR/apache-tomcat-$TOMCAT_VERSION-$TOMCAT_INSTANCE_NAME
fi

echo "-----> @ Installing Tomcat"
curl -o $TOMCAT_BASE_DIR/apache-tomcat-$TOMCAT_VERSION.zip $REPO_BASE_URL/apache-tomcat-$TOMCAT_VERSION.zip
unzip $TOMCAT_BASE_DIR/apache-tomcat-$TOMCAT_VERSION.zip -d $TOMCAT_BASE_DIR >/dev/null 2>&1
mv $TOMCAT_BASE_DIR/apache-tomcat-$TOMCAT_VERSION $TOMCAT_BASE_DIR/apache-tomcat-$TOMCAT_VERSION-$TOMCAT_INSTANCE_NAME
ln -s $TOMCAT_BASE_DIR/apache-tomcat-$TOMCAT_VERSION-$TOMCAT_INSTANCE_NAME $TOMCAT_BASE_DIR/apache-tomcat-$TOMCAT_INSTANCE_NAME
chmod +x $TOMCAT_BASE_DIR/apache-tomcat-$TOMCAT_INSTANCE_NAME/bin/*.sh

echo "-------> @ Creating Directories for Context Descriptor"
mkdir -p $TOMCAT_BASE_DIR/apache-tomcat-$TOMCAT_INSTANCE_NAME/conf/Catalina/localhost

echo "-----> @ Adding Tomcat Libraries... "

for lib in $TOMCAT_LIBS_LIST; do
  echo "-----> @ Downloading" $lib;
  curl -o $TOMCAT_BASE_DIR/apache-tomcat-$TOMCAT_INSTANCE_NAME/lib/$lib $REPO_BASE_URL/$lib
done

echo "-----> @ Cleaning up"
rm $TOMCAT_BASE_DIR/apache-tomcat-$TOMCAT_VERSION.zip