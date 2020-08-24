#!/bin/bash

apt-get update && apt-get upgrade -y
apt-get install vim -y
apt-get install -y docker.io
apt-get install bash-completion -y

echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

apt-get update
apt-get install -y kubeadm=1.18.1-00 kubelet=1.18.1-00 kubectl=1.18.1-00
apt-mark hold kubelet kubeadm kubectl

# Run as user

# mkdir -p $HOME/.kube
# sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
# sudo chown $(id -u):$(id -g) $HOME/.kube/config

# kubectl apply -f calico.yaml

# echo "source <(kubectl completion bash)" >> ~/.bashrc

# Worker setup

# CERT_HASH=$(openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -hex | sed 's/^.* //')
# TOKEN=$(sudo kubeadm token create)

# kubeadm join --token $TOKEN k8smaster:6443 --discovery-token-ca-cert-hash "sha256:$CERT_HASH"
