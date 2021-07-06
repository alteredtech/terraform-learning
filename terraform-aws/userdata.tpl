#!/bin/bash

sudo hostnamectl set-hostname node-${nodename} &&
curl -sfL https://get.k3s.io | sh -s - server \
--datastore-endpoint="mysql://${db_user}:${db_password}@tcp(${db_endpoint})/${db_name}" \
--write-kubeconfig-mode 644 \
--tls-san=$(curl http://169.254.169.254/latest/meta-data/public-ipv4)