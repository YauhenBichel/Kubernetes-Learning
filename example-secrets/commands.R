kubectl apply -f deployment.yaml
kubectl apply -f hellok8s-secret.yaml

kubectl get pods
# NAME                        READY   STATUS    RESTARTS
# hellok8s-6696859cbd-72g9b   1/1     Running   0       
# hellok8s-6696859cbd-hbczd   1/1     Running   0       

# Replace the pod anme to what you have running locally
kubectl exec -it hellok8s-6696859cbd-72g9b -- \
cat /secrets/SECRET_MESSAGE
# It works with a Secret