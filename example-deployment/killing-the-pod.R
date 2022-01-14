# The problem we noticed with pods is that they were not automatically rescheduled when they died, so let’s try to kill this pod now to see what happens.

kubectl apply -f deployment.yaml

kubectl get pods       
# NAME                        READY   STATUS    RESTARTS
# hellok8s-6678f66cb8-42jtr   1/1     Running   0       


# Replace the pod name with your local pod name
kubectl delete pod hellok8s-6678f66cb8-42jtr
# pod "hellok8s-6678f66cb8-42jtr" deleted

kubectl get pods
# NAME                        READY   STATUS    RESTARTS  
# hellok8s-6678f66cb8-8nqf2   1/1     Running   0         

# Note: Please notice that the name of the pod and the age of the pod has changed. Both of these things indicate that a new pod has been created.
# So that’s nice. We see that as soon as the deployment notices our pod died, it starts a new one. That goes back to the reconciliation loop we talked about; Kubernetes is always trying to ensure our desired state matches our current state. If it doesn’t, like when the actual number of pods we had running went from 1 to 0 because we killed it, it will take the necessary actions to return to a stable state. In this case, that means starting a new pod.

