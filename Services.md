Pods come and go. We do not have any guarantees about where they are running or how they can be reached.

Services provide a stable endpoint for pods, so we generally never send requests directly to a pod but always through a service.
The link between services and pods happens through labels. Any pod that has the labels defined in the service’s selector can receive requests sent to that service.

- There are four types of services: ClusterIP, NodePort, LoadBalancer, and ExternalName.
- ClusterIP is used when pods running inside the cluster need to be able to reach that service.
- A NodePort service will open a port on every worker node and will redirect requests received on that port to the pods it’s backing.
- The LoadBalancer service type will try to automatically provision a load balancer in the cloud provider that we are running. A cluster running on AWS, for example, will create a new ELB that will accept external traffic.
- We can access a service through its IP address, but Kubernetes provides two better alternatives for service discovery.
- DNS is the preferred service discovery mechanism and will allow us to access my-service with http://my-service:port.
- Environment variables with the service location are also injected in every container running in our cluster, but they are never updated, so not as reliable as DNS.




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

## NodePort
This is the type of service we have been using so far, and it builds on top of the ClusterIP type. You can think of it as an extension, so everything we can do with a ClusterIP, we can also do with a NodePort service. In addition to allowing applications that are running in our cluster to talk to each other, it will also allow us to expose our application to the outside world. It works by opening a port on all the worker nodes we have in our cluster, and then redirecting requests received on that port to the correct location, even if the pod we are trying to reach is physically running on a different node.

When we create a NodePort service exposing the port 30001, this port is open on both nodes and our external clients would be able to access either http://node1-ip:30001 or http://node2-ip:30001 the same way. When one of the nodes receives a request on this port, it will find our service that will then be able to decide which pod should receive the request (even if the pod is physically running in another node). When we are testing this locally, we have only one worker node (that is localhost), so that’s the only entrypoint for these requests. But in a cluster with, say, 10 nodes, this same port would be open in all these 10 machines, and we would be able to access our service by sending requests to any of them.

## LoadBalancer
The LoadBalancer Service type is really impressive. It’s an extension of the NodePort type, but it will try to provision a Load Balancer on the cloud provider we are running. For example, if our Kubernetes cluster is running on AWS when we create a LoadBalancer service, it would automatically create an ELB (Elastic Load Balancer) that is correctly setup for us.

That should work on pretty much every major cloud provider, and it is probably the easiest way to expose an application running in Kubernetes to the outside world. Then the way it works is pretty similar to the other service types, but instead of having to connect to a worker node IP and port, we can send requests to this Load Balancer, and it will route them to our pods the same way.

Load Balancer is an extension of a NodePort and ClusterIP. This means you have all the capabilities we discussed before, plus the automatic load balancer provisioning.

We just need to keep in mind that it will provision an entirely new load balancer for every service of this type that we have. When we talk about the Ingress resource, we will see ways to use a single load balancer with multiple services.

## ExternalName service type
This service type is a little bit different, as it is not used to provide a stable endpoint to an internal service but to an external one. For example, let’s say we have a database running at my-db.company.com. Instead of having this endpoint hardcoded or defined in a config somewhere, we could create a db service like the following:
  apiVersion: v1
  kind: Service
  metadata:
    name: db
  spec:
    type: ExternalName
    externalName: my-db.company.com

Then our pods can talk to this service without having to know the real address where our database is running. Now, the service is the only place we need to change if this database moves to a different location. Our pods are not affected.

## Service discovery
Given that we have a few applications running in our cluster, each backed by a Kubernetes service providing a stable endpoint that we can use to reach them, we still need a way to actually find these services. That is, if app-a wants to talk to app-b using service-b, how does it know where it should send requests to?

In a previous example, we have used the service IP directly, which is better than hardcoding the pods’ IPs, as it will not change as pods come and go.

Kubernetes provides two different service discovery mechanisms: DNS and injected environment variables.

### DNS
Kubernetes provides an out-of-the box, a DNS service to resolve service names. Here’s how it works: If you create a service called service-a, Kubernetes will add an entry for this service in its DNS, so any pod will be able to call, for example, http://service-a:4567. That will be correctly resolved to the service’s IP

### Environment variables
Another way to find services is through environment variables. Every container that Kubernetes creates will have environment variables that can be used to find every service that is currently running in the cluster. For example, if we use the env command to print all the environment variables with the HELLOK8S string, that’s what we get:

So we could access our service with something like:
curl $HELLOK8S_SVC_SERVICE_HOST:$HELLOK8S_SVC_SERVICE_PORT
# [v3] Hello, Kubernetes, from hellok8s-7f4c57d446-lh44f!

One thing that we need to be aware of is that these environment variables are injected into the pods at creation time only, so that means that services that are created after the pod will not be available. Also, if for some reason the service IP changes, like when we manually deleted and recreated the service, the environment variables won’t be updated in existing pods. These are problems we don’t have when using DNS, and that’s the main reason why it’s generally a preferable solution over environment variables.



