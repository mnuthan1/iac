##
# script to install helm on a pod
#####
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
./get_helm.sh

## init helm
helm init --service-account tiller --upgrade