Kubernetes has already been established as the OS of the cloud. As such, it sits between the applications and infrastructure. 
Kubernetes runs on infrastructure, and applications run on Kubernetes.

A Kubernetes installation is known as a Kubernetes cluster.
- It is unusual for a single Kubernetes cluster to span multiple infrastructures
- Although Kubernetes can run on many platforms, applications that run on Kubernetes have stricter requirements.

A Kubernetes cluster consists of one or more machines that have Kubernetes installed on them. 
The machines can be physical servers, virtual machines (VM), cloud instances, your laptop, Raspberry Pis, and more. 
Installing Kubernetes on these machines and connecting them together creates a Kubernetes cluster. 
After creating a cluster, you can deploy applications to that cluster.
Machines in a Kubernetes cluster are, normally, referred to as Nodes.
Speaking of Nodes, a Kubernetes cluster contains two types of Nodes:
- Master Nodes
- Worker Nodes

Usually, Master Nodes are referred to as “Masters” and Worker Nodes are called “Nodes”.
Masters host the control plane and Nodes are where you run user applications.

It is good practice for the Masters to exclusively run control plane services (no user applications). All user applications should run on Nodes.
Masters host the control plane. That is a fancy way of referring to the brains of the cluster.
With this in mind, it is good practice to have more than one Master in order to maintain high availability (HA). 
This way, if one of them fails, the cluster can remain operational. 
It is common to have 3 or 5 Masters in a production cluster and to spread them across failure domains. 
It is not wise to stick them all in the same room, under the same leaky air conditioning unit, functioning on the same glitchy electricity supply.

Masters run the following services that form the control plane:
- API Server
- Scheduler
- Store
- Cloud controller

The API Server is the only part of a Kubernetes cluster that you directly interact with. 
When you send commands to the cluster, they go to the API server. 
When you receive responses, they come from the API server.

The Scheduler chooses which Nodes to run the user applications on.

The Store is where the state of the cluster and all the applications are stored.

The Cloud controller allows Kubernetes to integrate with cloud services, such as storage and load-balancers. 

Nodes run user applications and can either be Linux or Windows Nodes. Linux Nodes run Linux applications, whereas Windows Nodes run Windows applications
All Nodes run two main services, namely:
- Kubelet
- Container runtime

The kubelet is the main Kubernetes agent. It joins the Node to the cluster and communicates with the control plane, 
in charge of notifying when tasks are received and reporting on the status of those tasks.

The container runtime starts and stops containers.


Most of the cloud providers have hosted Kubernetes Services. Some of the more popular ones include:
- AWS: Elastic Kubernetes Service (EKS)
- Azure: Azure Kubernetes Service (AKS)
- DO: Digital Ocean Kubernetes Service (DOKS)
- GCP: Google Kubernetes Engine (GKE)
- Linode: Linode Kubernetes Engine (LKE)


### Kubernetes's job
Kubernetes’ job is to take a group of machines and expose them to us as if it was a single thing. It’s similar to running an application locally; you don’t care which CPU core is executing it or the memory addresses the application is using. We just run the application, and let the operating system take care of the rest. Kubernetes does that at the datacenter level. It doesn’t matter if we have one or one thousand machines available. The way we interact with Kubernetes is the same: we tell it what we want, and it will do its best to make that happen.

### cluster
When we say “cluster,” we are talking about the two main components of Kubernetes:
- The master node
- Worker nodes.

### worker node
The worker nodes are where our applications actually run. We usually never need to interact with these nodes directly, and they should be easily replaceable. Multiple applications can run on the same node, and the same application can have multiple replicas spread across different nodes.

### master node
In the master node is where the magic happens. You can think of it as the brain of the cluster. We send changes to our desired state (usually in the form of yaml manifest files) to the master that will then decide what it needs to do. Kubernetes is always running this reconciliation loop. It compares the current state with the desired state, and makes the necessary changes to always make sure we have what we want.

### kubectl 
kubectl is the Kubernetes CLI, and it will be our main interface with Kubernetes for most of the time. It is the tool we use to send information to our cluster

There are two main ways to use kubectl:
- Declarative way
- Imperative way

We use it declaratively when we create a manifest that defines what we want and just send that to our cluster that will then find a way to make that happen.

We use it imperatively when we give our cluster specific orders telling it how to do what we want.

The imperative usage of kubectl is fine for development or to quickly test things out. But, the recommended way to use Kubernetes is declaratively, and that’s what we are going to do throughout this course. You will see that things are a lot simpler when we can just tell it what we want and not have to worry about how that will get done.



