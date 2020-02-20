# Install Spinnaker

From root directory

ansiable-playbook

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