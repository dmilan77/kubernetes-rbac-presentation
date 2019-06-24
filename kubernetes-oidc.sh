set -x
# Step 0
# Configure variables
export OIDC_APP_NAME='kubernetesOIDCTest'
export CLIENT_ID='xtCkD3ChCeAVzJom50ZRNHMsjuF5xnxM'
export CLIENT_SECRET='TtSgoLMhc-AIWAngkjIi3skgM7da8j62_3iYe6VLwgoQGdH-INAYJteETBG6T_Mt'
export ISSUER_URL_DOMAIN='https://dev-btkvvt-i.auth0.com/'
export VMDRIVER=hyperkit
#export VMDRIVER=xhyve

# Check openid-configuration discovery-data
curl ${ISSUER_URL_DOMAIN}/.well-known/openid-configuration | jq .

# Step 1
# Create RBAC minikube
  #--vm-driver $VMDRIVER \

 # --memory 4096 \
 # --cpus 4

# https://github.com/kubernetes/minikube/blob/8e5fd5b2750b05cfc07376d15d1215a7642474b9/docs/openid_connect_auth.md
# https://kubernetes.io/docs/reference/access-authn-authz/authentication/#openid-connect-tokens


minikube start \
  --extra-config=apiserver.authorization-mode=RBAC \
  --extra-config=apiserver.oidc-issuer-url=$ISSUER_URL_DOMAIN \
  --extra-config=apiserver.oidc-username-claim=email \
  --extra-config=apiserver.oidc-groups-claim=groups \
  --extra-config=apiserver.oidc-client-id=$CLIENT_ID 



  # Create Secrets minikube
kubectl create secret \
  -n kube-system \
  generic \
  kube-dashboard-secrets \
  --from-literal=client_id=$CLIENT_ID \
  --from-literal=client_secret=$CLIENT_SECRET \
  --from-literal=session=abcdef6hh87hggs

  # Check minikube ip
 minikube ip

#  bash-4.4$ minikube ip
# + minikube ip
# 192.168.99.106

# Step 2
# Deploy dashboard
kubectl config set-context --user minikube --cluster minikube --namespace kube-system mk-system
kubectl config use-context mk-system

kubectl apply -f ./dashboard.yaml --validate=false

kubectl rollout status deployment/kubernetes-dashboard-oidc

# Step 3
# Deploy rolebindings
kubectl config set-context --user minikube --cluster minikube --namespace kube-system mk-system
kubectl config use-context mk-system

kubectl apply -f ./roles-user.yaml --validate=false




kubectl get svc

open http://$(minikube ip):30004

#

####
Troubleshooting
kubectl -n kube-system get pods

kubectl -n kube-system logs deployment/kubernetes-dashboard-oidc -c openresty-oidc
kubectl -n kube-system logs deployment/kubernetes-dashboard-oidc -c kubernetes-dashboard



