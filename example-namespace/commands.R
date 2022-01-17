kubectl apply -f namespace.yaml
# namespace/my-namespace created

$ kubectl get namespaces
# NAME            STATUS
# default         Active
# docker          Active
# ingress-nginx   Active
# kube-public     Active
# kube-system     Active
# my-namespace    Active

kubectl get pods -n ingress-nginx
# NAME                                        READY   STATUS
# nginx-ingress-controller-57548b96c8-mwkrp   1/1     Running

kubectl get pods --all-namespaces
kubectl get all --all-namespaces

kubectl apply -f namespace.yaml 

kubectl apply -f nginx-pod.yaml
# pod/nginx created

kubectl apply -f nginx-pod.yaml -n my-namespace
# pod/nginx created

kubectl get pods
# NAME    READY   STATUS 
# nginx   1/1     Running

kubectl get pods -n my-namespace
# NAME    READY   STATUS   
# nginx   1/1     Running 

kubectl apply -f namespace.yaml

kubectl apply -f pods.yaml
# pod/hellok8s created
# pod/hellok8s created

kubectl apply -f service.yaml -n default
# service/hellok8s-svc created

kubectl apply -f service.yaml -n my-namespace
# service/hellok8s-svc created

kubectl exec -it hellok8s -- sh

curl hellok8s-svc:4567
# [v4] Hello, Kubernetes (from hellok8s)

curl hellok8s-svc.default:4567
# [v4] Hello, Kubernetes (from hellok8s)

curl hellok8s-svc.my-namespace:4567
# [v3] Hello, Kubernetes, from hellok8s!

kubectl exec -it hellok8s -n my-namespace -- sh

# Now inside the container

curl hellok8s-svc:4567
# [v3] Hello, Kubernetes, from hellok8s!

curl hellok8s-svc.default:4567
# [v4] Hello, Kubernetes (from hellok8s)

curl hellok8s-svc.my-namespace:4567
# [v3] Hello, Kubernetes, from hellok8s!


