#!/bin/bash

# Copyright (C) 2012 Amazon.com, Inc. or its affiliates.
# All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License").
# You may not use this file except in compliance with the License.
# A copy of the License is located at
#
#    http://aws.amazon.com/apache2.0/
#
# or in the "license" file accompanying this file. This file is
# distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS
# OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the
# License.

# During init and before the network service is started, metadata is not
# available. Exit without attempting to configure the elastic interface
# if eth0/ens5 isn't up yet.
if [ ! -f /sys/class/net/eth0/operstate ] || ! grep 'up' /sys/class/net/eth0/operstate; then
  if [ ! -f /sys/class/net/ens5/operstate ] || ! grep 'up' /sys/class/net/ens5/operstate; then
    logger --tag=ec2net "[hotplug] Primary interface (eth0/ens5) isn't up yet."
    exit
  fi
fi

logger --tag=ec2net "[hotplug] Interface ${INTERFACE} hotplugged with action ${ACTION}"

. /etc/network/ec2net-functions

case $ACTION in
  add)
    plug_interface
    ;;
  remove)
    unplug_interface
    ;;
esac
