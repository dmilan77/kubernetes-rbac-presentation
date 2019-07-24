# Part 1
# User 1: user1@dmilan.com
# User2: user2@dmilan.com
atl-kube-meetup-0724


export my_zone=us-central1-a
export my_cluster=standard-cluster-1

source <(kubectl completion bash)
gcloud container clusters create $my_cluster --num-nodes 3 --enable-ip-alias --zone $my_zone

gcloud container clusters get-credentials $my_cluster --zone $my_zone

git clone https://github.com/dmilan77/training-data-analyst.git
cd ~/training-data-analyst/courses/ak8s/15_RBAC/

# cat my-namespace.yaml
apiVersion: v1
kind: Namespace
metadata:
  name: production

kubectl create -f ./my-namespace.yaml
kubectl get namespaces

# cat my-pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx
  labels:
    name: nginx
spec:
  containers:
  - name: nginx
    image: nginx
    ports:
    - containerPort: 80

kubectl apply -f ./my-pod.yaml --namespace=production

kubectl get pods --namespace=production


# Part 2

In this task you will create a sample custom role, and then create a RoleBinding that grants Username 2 the editor role in the production namespace.
## grant the Username 1 account cluster-admin privileges

kubectl create clusterrolebinding cluster-admin-binding --clusterrole cluster-admin --user google4312086_student@qwiklabs.net

# cat pod-reader-role.yaml
kind: Role
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  namespace: production
  name: pod-reader
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["create","get", "list", "watch"]


kubectl apply -f pod-reader-role.yaml
kubectl get roles --namespace production

# Create a RoleBinding

vi user2-editor-binding.yaml

kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: username2-editor
  namespace: production
subjects:
- kind: User
  name: googleuser6613_student@qwiklabs.net
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role
  name: pod-reader
  apiGroup: rbac.authorization.k8s.io



## on User2 cloud shell
export my_zone=us-central1-a
export my_cluster=standard-cluster-1
source <(kubectl completion bash)
gcloud container clusters get-credentials $my_cluster --zone $my_zone
git clone https://github.com/dmilan77/training-data-analyst.git

cd ~/training-data-analyst/courses/ak8s/15_RBAC/
kubectl get namespaces
kubectl apply -f ./production-pod.yaml

#googleuser6613_student@cloudshell:~/training-data-analyst/courses/ak8s/15_RBAC (qwiklabs-gcp-e8ea6dca40d54835)$ kubectl apply -f ./production-pod.yaml
#Error from server (Forbidden): error when creating "./production-pod.yaml": pods is forbidden: User "googleuser6613_student@qwiklabs.net" cannot create resource "pods" in API group "" in the namespace "production"

## on User1 cloud shell
kubectl apply -f user2-editor-binding.yaml
kubectl get rolebinding --namespace production


## on User2 cloud Shell
kubectl apply -f ./production-pod.yaml






