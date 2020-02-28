#!/bin/bash
# Script to configure halyarpod with K8 cluster
# TO run manually
#  kubectl exec -it $(kubectl get pods | grep hal) -- bash  (logs into halyard pod)
#  run below commands
#  

cd
kubectl config set-cluster default --server=https://$KUBERNETES_SERVICE_HOST:$KUBERNETES_PORT_443_TCP_PORT --certificate-authority=/var/run/secrets/kubernetes.io/serviceaccount/ca.crt
kubectl config set-context default --cluster=default
token=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
kubectl config set-credentials user --token=$token
kubectl config set-context default --user=user
kubectl config use-context default