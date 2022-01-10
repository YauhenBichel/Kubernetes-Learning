# KubernetesLearning

- Running a Kubernetes Cluster Locally
- Pods
- ReplicaSets
- Services
- Deployments
- Ingress
- Volumes
- ConfigMaps
- Secrets
- Namespaces
- Securing Kubernetes Clusters
- Managing Resources
- Creating a Production-Ready Kubernetes Cluster
- Persisting State

- Kubernetes Primer
- Kubernetes Principles of Operation
- Working with Pods
- Kubernetes Deployments
- Kubernetes Services
- Services Discovery
- Kubernetes Storage
- ConfigMaps
- StatefulSets
- Threat Modeling with Kubernetes
- Real-World Kubernetes Security

- Introduction to Kubernetes Chaos Engineering
- Defining Requirements
- Destroying Application Instances
- Experimenting with Application Availability
- Obstructing and Destroying Networks
- Draining and Deleting Nodes
- Creating Chaos Experiment Reports
- Running Chaos Experiments inside a Kubernetes Cluster
- Executing Random Chaos

## What is Kubernetes
Kubernetes is an orchestrator of cloud-native microservices applications.

## Cloud-native
A cloud-native application must :
- Scale on demand
- Self-heal
- Support zero-downtime rolling updates
- Run anywhere that has Kubernetes

Scaling on demand is the ability for an application and associated infrastructure to automatically scale up and down based on demand.
If configured correctly, Kubernetes can automatically scale your applications and infrastructure up when demand increases and scale them down when the demand 
drops off.

Kubernetes saves this as your desired state and monitors your application to make sure it always matches this desired state. If something changes, for example if an instance crashes, Kubernetes notices this and spins up a replacement. This is called self-healing.

Zero-downtime rolling updates is just a fancy way of saying you can incrementally update parts of an application without having to shut it down and without clients even noticing. You will see this in action later in the course.

