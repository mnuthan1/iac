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

- Create cluster with vagrant (in order to change the Node OS, update Vagrantfile, currently centos7 and ubuntu-18.04 are supported)

```bash
vagrant up
```
It will create `cred.txt` file with K8s details. you can start using K8s API from your host machine by following these instructions
- Using K8s API
  - `source ./kubernetes-setup/cred.txt`
  - `curl $KUBE_API_EP/api --header "Authorization: Bearer $KUBE_API_TOKEN" --insecure`
- Using `kubectl`

    ```bash
    source ./k8cluster/kubernetes-setup/cred.txt
    kubectl config set-credentials deployer/my-cluster --token $KUBE_API_TOKEN
    kubectl config set-cluster my-cluster --insecure-skip-tls-verify=true --server=$KUBE_API_EP
    kubectl config set-context default/my-cluster/deployer --user=deployer/my-cluster --namespace=default --cluster=my-cluster
    kubectl config use-context default/my-cluster/deployer
    kubectl get nodes -o wide
  ```
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
