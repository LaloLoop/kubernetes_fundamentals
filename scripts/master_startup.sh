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

IP_ADDR=$(ip addr show ens4|grep inet|grep -v inet6|awk '{print $2}'|awk '{split($0,a,"/"); print a[1]}')

# Master setup

wget https://docs.projectcalico.org/manifests/calico.yaml

echo "$IP_ADDR k8smaster" >> /etc/hosts

cat << EOF > kubeadm-config.yaml
apiVersion: kubeadm.k8s.io/v1beta2
kind: ClusterConfiguration
kubernetesVersion: 1.18.1
controlPlaneEndpoint: "k8smaster:6443"
networking:
  podSubnet: 192.168.0.0/16
EOF

kubeadm init --config=kubeadm-config.yaml --upload-certs | tee kubeadm-init.out

cp ./calico.yaml /home/student/

# Run as user

mkdir -p /home/student/.kube
cp -i /etc/kubernetes/admin.conf /home/student/.kube/config
chown -R student:student /home/student/.kube/

su - student -c <<EOF
kubectl apply -f /home/student/calico.yaml
kubectl taint nodes --all node-role.kubernetes.io/master-
echo "source <(kubectl completion bash)" >> ~/.bashrc
EOF
