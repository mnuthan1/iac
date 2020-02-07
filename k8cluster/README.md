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

### validate

- login to master and list k8s nodes

```bash
vagrant ssh k8s-master
```

- From server

```bash
>kubectl get nodes
NAME         STATUS   ROLES    AGE     VERSION
k8s-master   Ready    master   7m13s   v1.17.2
node-01      Ready    <none>   5m1s    v1.17.2
node-02      Ready    <none>   2m47s   v1.17.2

```
