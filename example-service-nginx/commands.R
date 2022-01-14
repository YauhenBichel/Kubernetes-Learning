# Apply these files
kubectl apply -f deployment.yaml
kubectl apply -f nginx.yaml 


kubectl get service
# NAME            TYPE        CLUSTER-IP
# clusterip-svc   ClusterIP   10.105.223.250

kubectl get pod
# NAME                        READY   STATUS
# hellok8s-6696859cbd-gmhcp   1/1     Running
# nginx                       1/1     Running

# Replace the pod name to what you have running locally
kubectl exec -it hellok8s-6696859cbd-gmhcp -- sh

# Replace the service ip to what you have running locally
# We are now inside the hellok8s container
curl http://10.105.223.250:80
# nginx welcome page

