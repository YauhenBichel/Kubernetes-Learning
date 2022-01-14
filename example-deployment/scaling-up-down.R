# Another cool thing that deployments can do is scale up and down the number of replicas we have running. Right now, we are running a single container for our application. Changing that is just a matter of updating our manifest file with our new desired number of replica and sending that to Kubernetes:

# Enter the following command after running the SPA above
kubectl apply -f scaleup.yaml

# Inspecting the deployment, we now have 10 replicas, but only one is available. That’s because the other 9 containers are still being created, as we can see by inspecting the running pods:
kubectl get deployments
kubectl get pods

kubectl get deployments

# NAME       DESIRED   CURRENT   UP-TO-DATE   AVAILABLE  
# hellok8s   10        10        10           10   

kubectl get pods
# NAME                        READY   STATUS    RESTARTS  
# hellok8s-6678f66cb8-8nqf2   1/1     Running   0         
# hellok8s-6678f66cb8-6r7fb   1/1     Running   0         
# hellok8s-6678f66cb8-7bg4s   1/1     Running   0         
# hellok8s-6678f66cb8-96xh5   1/1     Running   0         
# hellok8s-6678f66cb8-cmb4j   1/1     Running   0         
# hellok8s-6678f66cb8-h5tg4   1/1     Running   0         
# hellok8s-6678f66cb8-j2b5n   1/1     Running   0         
# hellok8s-6678f66cb8-l5hzw   1/1     Running   0         
# hellok8s-6678f66cb8-r9bzd   1/1     Running   0         
# hellok8s-6678f66cb8-wl4bb   1/1     Running   0   

# Right now, as we are running Kubernetes locally, we have only one worker node running our applications, so all these pods will run on this node. In a production environment, where we will likely have several worker nodes in our cluster, Kubernetes will try to schedule these pods across different nodes. So, even if one of the nodes fails, our application will still be up.


