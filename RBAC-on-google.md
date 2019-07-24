# Part 1
# User 1: user1@dmilan.com
# User2: user2@dmilan.com
### atl-kube-meetup-0724

```
export my_zone=us-central1-a
export my_cluster=dmilan-cluster-1

source <(kubectl completion bash)
gcloud container clusters create $my_cluster --num-nodes 3 --enable-ip-alias --zone $my_zone

gcloud container clusters get-credentials $my_cluster --zone $my_zone

git clone https://github.com/dmilan77/training-data-analyst.git
cd ~/training-data-analyst/courses/ak8s/15_RBAC/

cat > production-namespace.yaml <<EOF
apiVersion: v1
kind: Namespace
metadata:
  name: production
EOF



kubectl create -f ./production-namespace.yaml
kubectl get namespaces

cat > nginx-pod.yaml <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: nginx
  namespace: production
  labels:
    name: nginx
spec:
  containers:
  - name: nginx
    image: nginx
    ports:
    - containerPort: 80
EOF

kubectl apply -f ./nginx-pod.yaml

kubectl get pods --namespace=production

```
# Part 2

In this task you will create a sample custom role, and then create a RoleBinding that grants Username 2 the editor role in the production namespace.
## grant the Username 1 account cluster-admin privileges
```
kubectl create clusterrolebinding cluster-admin-binding --clusterrole cluster-admin --user user1@dmilan.com

cat > pod-reader-role.yaml <<EOF
kind: Role
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  namespace: production
  name: pod-reader
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["create","get", "list", "watch"]
EOF

kubectl apply -f pod-reader-role.yaml
kubectl get roles --namespace production

# Create a RoleBinding

cat > user2-editor-binding.yaml  <<EOF

kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: username2-editor
  namespace: production
subjects:
- kind: User
  name: user2@dmilan.com
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role
  name: pod-reader
  apiGroup: rbac.authorization.k8s.io
EOF


## on User2 cloud shell
export my_zone=us-central1-a
export my_cluster=dmilan-cluster-1
source <(kubectl completion bash)
gcloud container clusters get-credentials $my_cluster --zone $my_zone

kubectl get namespaces

cat > production-pod.yaml <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: production-pod
  labels:
    name: production-pod
  namespace: production
spec:
  containers:
  - name: production-pod
    image: nginx
    ports:
    - containerPort: 8080
EOF

kubectl apply -f ./production-pod.yaml

#googleuser6613_student@cloudshell:~/training-data-analyst/courses/ak8s/15_RBAC (qwiklabs-gcp-e8ea6dca40d54835)$ kubectl apply -f ./production-pod.yaml
#Error from server (Forbidden): error when creating "./production-pod.yaml": pods is forbidden: User "XXXXXXXXX" cannot create resource "pods" in API group "" in the namespace "production"

## on User1 cloud shell
kubectl apply -f user2-editor-binding.yaml
kubectl get rolebinding --namespace production


## on User2 cloud Shell
kubectl apply -f ./production-pod.yaml





```
