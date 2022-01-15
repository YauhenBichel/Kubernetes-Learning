kubectl apply -f hellok8s.yaml
kubectl apply -f hellok8s-config.yaml

kubectl get pods
# NAME                       READY   STATUS
# hellok8s-8c56675c9-7gxpv   1/1     Running
# hellok8s-8c56675c9-bfk8t   1/1     Running

# Replace the pod name to what you have running locally
kubectl exec -it hellok8s-8c56675c9-7gxpv -- sh
cat /config/MESSAGE
# It works with a ConfigMap!