#!/bin/bash

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
   echo "You need to be 'root' dude." 1>&2
   exit 1
fi

# just so we're all clear
clear 

# see if we have our setuprc file available and source it
if [ -f ./setuprc ]
then
  . ./setuprc
else
  echo "##########################################################################################################################"
  echo;
  echo "A setuprc config file wasn't found & the install must halt.  Report this at https://github.com/bluechiptek/bluechipstack."
  echo;
  echo "##########################################################################################################################"
  exit;
fi

num_nodes=$NUMBER_NODES

echo "##########################################################################################################################"
echo; 
echo "Please wait while the "$num_nodes" nodes are being configured..."
echo; 
echo "##########################################################################################################################"
echo; 

# loop through config's machines and run against each 
rm -f /tmp/.node_hosts
for (( x=1; x<=$num_nodes; x++ ))
  do
    host="NODE_"$x"_HOSTNAME"
    #./openstack_chef_client.sh ${!host}
  done

# modify our enviroment template
cat grizzly_environment.js | sed -e "s/\${internal_network}/"$PRIVATE_NETWORK"\/24/" > grizzly_environment.js.1
cat grizzly_environment.js.1 | sed -e "s/\${public_network}/"$PUBLIC_NETWORK"\/24/" > grizzly_environment.js.2
cat grizzly_environment.js.2 | sed -e "s/\${bridge_interface}/"$BRIDGE_INTERFACE"/" > grizzly_environment.js.3
cp grizzly_environment.js.3 grizzly_environment.js
rm grizzly_environment.js.1 grizzly_environment.js.2 grizzly_environment.js.3

# create and edit the environment for chef
#/opt/chef-server/bin/knife environment create grizzzly -d "OpenStack Grizzly via BlueChip Install"
#/opt/chef-server/bin/knife environment edit from file grizzly_environment.js
