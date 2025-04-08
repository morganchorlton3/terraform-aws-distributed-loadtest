#!/bin/bash
apt-get update

apt-get install -y python3 python3-pip

pip3 install urllib3==1.26.15
pip3 install locust