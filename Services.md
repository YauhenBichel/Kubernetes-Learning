We have seen pods come and go. And we can’t rely on their names (or IP addresses) to be stable. You have probably noticed that when we run port-forward, we always need to make sure that we have the correct pod name, as they will change. For example, this is important when we scale a Deployment up and down.

Let’s first clarify some of the problems we have with our current setup:

- We are using port-forward to redirect traffic from our local machine to a pod, so a user that doesn’t have access to our Kubernetes cluster is not able to access this application.
- If we have more than one application running in the cluster, they don’t have a reliable way to talk to each other. We could hardcode the pod IP address to be able to reach it, but as the pod is re-created, the IP will change and that will stop working.
- We are always sending requests to a single pod, even if we have a Deployment that is creating several replicas for us. If we have 10 replicas of our application running, it is only logical that we would want requests to be distributed across all of these pods instead of going to one pod while the others are idle.

# Service 
A Service is another Kubernetes resource that lets us provide a stable endpoint for our pods. It’s something that sits in front of the pods and takes care of receiving requests and delivering them to all the pods that are behind it.

Example:
apiVersion: v1
kind: Service
metadata:
  name: hellok8s-svc
spec:
  type: NodePort
  selector:
    app: hellok8s
  ports:
  - port: 4567
    nodePort: 30001

Most of this service definition is quite similar to the pods and deployment manifests we have seen.
We define a resource with the Service kind and give it a name hellok8s-svc. In the spec section we are defining three things: the service type, the selector, and the ports.

We have a few different types of Services in Kubernetes, and we will talk about them and when to use each one soon. But for this example, we are just using a NodePort that will open a port on the worker node to receive requests (similarly to what port-forward was doing). Then in the selectors section, we need to tell the service which pods are behind it. In the same way we did for Deployments, we use labels for that. Here, we are saying that any pod that has the label app with the value hellok8s can receive the requests sent to this Service. And lastly, we define the port mapping. Here, we are saying that we want to open the port 30001 and send all the requests received on that port to the pod’s port 4567 (that is where our application is listening).

To start the service, we need to deploy the service.yaml file, so let’s go ahead and apply these manifests by using the following commands:

> kubectl apply -f service.yaml

Now if we try to list this service, we will see something like this.
>kubectl get service hellok8s-svc

# NAME           TYPE       CLUSTER-IP        PORT(S)      
# hellok8s-svc   NodePort   10.102.141.32     4567:30001


## Service types
Now that we have seen how a service works, let’s talk about the different types of services we can have. In the previous lesson, we used a NodePort Service that will open a port on all the worker nodes (30001 in our case) and deliver requests received on that port to all the pods that are behind it. Each Service type has its different uses, and we will learn how to choose the best option for our needs.

## ClusterIP
This is the simplest type of service. It’s also the default type, which means if we create a service without a type attribute Kubernetes will assume we mean ClusterIP.

This type of service is used when we only need to give other applications that are running inside our cluster access to our pods. If we have, say, three replicas of application app-a and another application app-b needs a stable endpoint to access these replicas, we could create service-a using the ClusterIP type.




