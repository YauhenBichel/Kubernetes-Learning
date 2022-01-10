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

