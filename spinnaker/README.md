# Install Spinnaker

## Folder Structure
- spin-playbook.yml - main ansible play book
- manifests/* - kubernetes object configurations
- scripts/* - shell scripts to configure services

## Basic Setup

1. From root directory

```bash
ansible-playbook spinnaker/spin-playbook.yml
```
This setups following services
- setup hal pod 
- Configures pod with kubernetes cluter (scripts/halyar_pod_config_kubectl.sh)
- install helm  and minio (scripts/install_helm.sh)

2. Deploy Spinnaker
- Login to hal pod
```bash
 kubectl get deployments

NAME    READY   UP-TO-DATE   AVAILABLE   AGE
hal     1/1     1            1           13m
minio   1/1     1            1           4m27s

kubectl exec -it hal-648bf9c9b6-rrltn  -- bash
```
- Run to install Spinnaker
```bash
 /scripts/install_spinnaker.sh
```

**NOTE** This will always install latest spinnaker version, no need to update the version

**NOTE** Look for `MINIO_ACCESS_KEY` and `MINIO_SECRET_KEY` in `install_helm.sh` and `install_spinnaker.sh` both should match

## Custom Spinnaker Service image
In order to deploy custom Spinnaker image

- update `custom_spin_services.sh` to create new service-settings
for example in order to use custom front50 image create `front-50.yml` with custom artifactId

``` bash
tee /root/.hal/default/service-settings/front50.yml <<-'EOF'
artifactId: docker.io/mnuthan/front50
EOF
```


## Issues
### Hal POD has issue with external url. 
- Get the node where POD is running
kubectl get pods -o wide

- ssh into the node
- install tcpdump
- then monitor tcp pockerts
tcpdump -i any host <POD-IP>

in our case its able to connect via IP but not via hostname (external urls)

- workaround
- update hal deployment file to use custom dnsconfig with google dns