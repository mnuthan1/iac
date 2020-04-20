# Creating K8 local cluster using Vagrant and Ansible with Centos

## Pre requisites

- Vagrant
- Virtual box
- Ansible

## Steps

- Clone Repo

```bash
git clone https://github.com/mnuthan1/iac.git
```

- Change working directory

```bash
cd <repo_path>/k8cluster
```

- Create cluster with vagrant

```bash
vagrant up
```
It will create `cred.txt` file with K8s details. you can start using K8s API from your host machine by following these instructions
- Using K8s API
  - `source ./kubernetes-setup/cred.txt`
  - `curl $KUBE_API_EP/api --header "Authorization: Bearer $KUBE_API_TOKEN" --insecure`
- Using `kubectl`
  - Setting up credentials
    ```bash
    kubectl config set-credentials deployer/my-cluster --token $KUBE_API_TOKEN
    ```
  - pointing to Cluster
    ```bash
    kubectl config set-cluster my-cluster --insecure-skip-tls-verify=true --server=$KUBE_API_EP
    ```
  - Create Context
    ```bash
    kubectl config set-context default/my-cluster/deployer --user=deployer/my-cluster --namespace=default --cluster=my-cluster
    ```
  - Use the above created context
    ```bash
    kubectl config use-context default/my-cluster/deployer
    ```
  - List node
    ```bash
    >kubectl get nodes -o wide
    NAME         STATUS   ROLES    AGE     VERSION
    k8s-master   Ready    master   7m13s   v1.17.2
    node-01      Ready    <none>   5m1s    v1.17.2
    node-02      Ready    <none>   2m47s   v1.17.2
    ```

## Trouble shooting
- error: unable to upgrade connection: container not found ("halyard")

- No Internet access from PODS
  REF: https://kubernetes.io/docs/tasks/administer-cluster/dns-custom-nameservers/
  - Edit coredns configmap
  ```bash
    kubectl edit configmaps coredns -n kube-system
  ```
    replace content with this (look for modiciations on  **forward** )

```yml
# Please edit the object below. Lines beginning with a '#' will be ignored,
# and an empty file will abort the edit. If an error occurs while saving this file will be
# reopened with the relevant failures.
#
apiVersion: v1
data:
  Corefile: |
    .:53 {
        log
        errors
        health {
           lameduck 5s
        }
        ready
        kubernetes cluster.local in-addr.arpa ip6.arpa {
           pods insecure
           fallthrough in-addr.arpa ip6.arpa
           ttl 30
        }
        prometheus :9153
        forward . 8.8.8.8
        cache 30
          loop
        reload
        loadbalance
    }
kind: ConfigMap
metadata:
  creationTimestamp: "2020-02-14T05:29:58Z"
  name: coredns
  namespace: kube-system
  resourceVersion: "202469"
  selfLink: /api/v1/namespaces/kube-system/configmaps/coredns
  uid: 0b3b233a-8d7b-4d58-a02f-b501527c5203
```
Reset
kubectl scale deployment coredns --replicas=0 -n kube-system
kubectl scale deployment coredns --replicas=2 -n kube-system
### 

source ./k8cluster/kubernetes-setup/cred.txt
kubectl config set-credentials deployer/my-cluster --token $KUBE_API_TOKEN

kubectl config set-cluster my-cluster --insecure-skip-tls-verify=true --server=$KUBE_API_EP

kubectl config set-context default/my-cluster/deployer --user=deployer/my-cluster --namespace=default --cluster=my-cluster

kubectl config use-context default/my-cluster/deployer

kubectl get nodes -o wide