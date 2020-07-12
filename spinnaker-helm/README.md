# Deploy spinnaker using helm

## pre requirements
- helm3
- add following helm repos
  - ` helm repo add stable https://kubernetes-charts.storage.googleapis.com/ `
- For Minio ssl setup
  - Create self signed certs (optional)
    - ` openssl ecparam -genkey -name prime256v1 | openssl ec -out private.key `
    - ` openssl req -new -x509 -days 3650 -key private.key -out public.crt -subj "/C=US/ST=state/L=location/O=organization/CN=*.cluster.local" `
    - update hooks/install-minio-certs.yaml with correct private.key and public.crt
     - `kubectl create secret generic tls-ssl-minio --from-file=private.key --from-file=public.crt --dry-run=true --output=yaml`


Install charts in spinnaker namespace
helm install dev . --namespace spinnaker --create-namespace

Verify
Minio: curl -v https://127.0.0.1:9000  --insecure --data '{"accessKey": "myaccesskey", "secretKey": "mysecretkey"}'