#!/bin/bash

cat <<EOT > /root/.vimrc
set expandtab
set tabstop=2
set shiftwidth=2
EOT

# init scenario
rm $0
mkdir -p /opt/ks


cp /etc/docker/daemon.json /etc/docker/daemon.json.tmp
cat /etc/docker/daemon.json.tmp | grep -v registry-mirrors | grep -v \} > /etc/docker/daemon.json
cp /etc/docker/daemon.json /etc/docker/daemon.json.tmp
echo "$(cat /etc/docker/daemon.json.tmp)," > /etc/docker/daemon.json

cat >> /etc/docker/daemon.json <<EOF
  "registry-mirrors": ["http://local-registry:5000", "https://mirror.gcr.io", "https://docker-mirror.killer.sh"],
  "insecure-registries": ["local-registry:5000"]
}
EOF
systemctl daemon-reload
systemctl enable docker
systemctl restart docker


# mark init finished
touch /ks/.initfinished
