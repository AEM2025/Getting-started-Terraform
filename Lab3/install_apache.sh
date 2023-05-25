#!/bin/bash
apt-get update -y
apt-get install -y apache2
systemctl restart apache2