# Install Spinnaker

From root directory

```bash
ansible-playbook spinnaker/spin-playbook.yml
```
This will setup hal pod and install helm in it, it also setups minio storage for spinnaker setup

login to hal pod and then run scripts/install_spinnaker.sh to install spinnaker

verify for hal and minio deployments to be read
 
 ```bash
 kubectl get deployments

NAME    READY   UP-TO-DATE   AVAILABLE   AGE
hal     1/1     1            1           13m
minio   1/1     1            1           4m27s

kubectl exec -it hal-648bf9c9b6-rrltn  -- bash
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