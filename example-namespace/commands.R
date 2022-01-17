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


