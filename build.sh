#!/bin/bash

read -p "nagios version [default=4.3.1]: " nv
nv=${nv:-4.3.1}

read -p "nagios plugin version [defalut=2.1.4]: " npv
npv=${npv:-2.1.4}

read -p "docker image tag: " tag

docker build  -t ${tag} --build-arg NAGIOS_VERSION=${nv} --build-arg NAGIOS_PLUGIN_VERSION=${npv} .
