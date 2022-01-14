kubectl apply -f deployment.yaml
kubectl apply -f service.yaml

kubectl get pods

# NAME                        READY   STATUS    RESTARTS
# hellok8s-7f4c57d446-7j6rd   1/1     Running   0       
# hellok8s-7f4c57d446-lh44f   1/1     Running   0   


# We will choose one of the pods and open a shell session. Please notice that the name of the pods on your machine will be different:

kubectl exec -it hellok8s-7f4c57d446-7j6rd -- sh
# As a reminder, the command follows the format kubectl exec -it {pod_name} -- {command}, so here we are running the "sh" command for the pod "hellok8s-7f4c57d446-7j6rd", and we use the -it flags to have an interactive session.

# Cool, so now we are inside our pod. We can test how things would work for our application that is running there.

# First, in another session, let’s make sure we still have a service running:

kubectl get services

# NAME           TYPE        CLUSTER-IP      PORT(S)        
# hellok8s-svc   NodePort    10.102.141.32   4567:30001/TCP

# Great, we have our hellok8s-svc service running. So from our pod, we should be able to reach it. Let’s first try to use its IP directly. From the services output, we can see that this service’s IP is 10.102.141.32 (probably different for you), so let’s try that:

# Replace the pod name to what you have running locally
kubectl exec -it hellok8s-7f4c57d446-7j6rd -- sh

# Replace the service ip to what you have running locally
curl http://10.102.141.32:4567
# [v3] Hello, Kubernetes, from hellok8s-7f4c57d446-7j6rd!

#Great, it works. But instead of using the service IP, let’s now test the Kubernetes DNS resolver. From this same session, try to access http://hellok8s-svc:4567:

# Replace the pod name to what you have running locally
kubectl exec -it hellok8s-7f4c57d446-7j6rd -- sh

# Replace the service ip to what you have running locally
curl http://10.102.141.32:4567
# [v3] Hello, Kubernetes, from hellok8s-7f4c57d446-7j6rd!

curl http://hellok8s-svc:4567
# [v3] Hello, Kubernetes, from hellok8s-7f4c57d446-lh44f!

# And that also works! That means any pod that is running in our cluster should be able to talk to our hellok8s application reliably by sending requests to http://hellok8s-svc; nice and clean.

# This will work for any type of service we have, such as ClusterIP, NodePort and LoadBalancer. From inside the cluster, they are all the same.

