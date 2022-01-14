

At a high level, you start with the application code. That gets packaged as a container and wrapped in a Pod so it can run on Kubernetes. However, Pods don’t self-heal; they don’t scale, and they don’t allow for easy updates or rollbacks. Deployments do all of these. As a result, you’ll almost always deploy Pods via a Deployment controller.

It’s important to know that a single Deployment object can only manage a single Pod template. For example, if you have an application with a Pod template for the web front end and another Pod template for the catalog service, you’ll need two Deployments. 

Deployments are fully fledged objects in the Kubernetes API. This means you define them in manifest files that you POST to the API server.

Deployments leverage another object called a ReplicaSet. While it’s best practice that you don’t interact directly with ReplicaSets, it’s important to understand the role they play.

Keeping it high level, Deployments use ReplicaSets to provide self-healing and scaling.

Think of Deployments as managing ReplicaSets, and ReplicaSets as managing Pods. Put them all together, and you’ve got a great way to deploy and manage applications on Kubernetes.

Deployment -> replicate set -> mods

Deployments coordinate with ReplicaSets to manage pods. This enables high availability and auto-scaling.

Before going any further, it’s critical to understand three concepts that are fundamental to everything about Kubernetes:
- Desired state
- Current state (sometimes called actual state or observed state)
- Declarative model

Desired state is what you want. Current state is what you have. If the two match, everybody’s happy.

The declarative model is a way of telling Kubernetes what your desired state is, without having to get into the detail about how to implement it. You leave the how up to Kubernetes.

The declarative model is stating what you want (chocolate cake for 10). The imperative model is a long list of steps required to make a chocolate cake for 10.

Assume you’ve got an application with two services – front-end and back-end. You’ve built container images so that you can have a Pod for the front-end service and a separate Pod for the back-end service. To meet expected demand, you always need 5 instances of the front-end Pod and 2 instances of the back-end Pod.

Taking the declarative approach, you write a configuration file that tells Kubernetes what you want your application to look like. For example, I want 5 replicas of the front-end Pod all listening externally on port 80 please. And I also want 2 back-end Pods listening internally on port 27017. That’s the desired state. Obviously, the YAML format of the config file will be different, but you get the picture.

Once you’ve described the desired state, you give the config file to Kubernetes and sit back while Kubernetes does the hard work of implementing it.

The opposite of the declarative model is the imperative model. In the imperative model, there’s no concept of what you actually want. At least there’s no record of what you want, all you get is a list of instructions.

To make things worse, imperative instructions might have multiple variations. For example, the commands to start containerd containers are different from the commands to start gVisor containers. This ends up being more work that is prone to more errors, and, because it’s not declaring a desired state, there’s no self-healing.

Kubernetes supports both models but strongly prefers the declarative model.

As well as self-healing and scaling, Deployments give us zero-downtime rolling updates.

As previously mentioned, Deployments use ReplicaSets for some of the background legwork. In fact, every time you create a Deployment, you automatically get a ReplicaSet that manages the Deployment’s Pods.

It works like this: You design applications with each discrete service as a Pod. For convenience – self-healing, scaling, rolling updates, etc. – you wrap Pods in Deployments. This means creating a YAML configuration file describing all of the following:

How many Pod replicas
What image to use for the Pod’s container(s)
What network ports to use
Details about how to perform rolling updates
You POST the YAML file to the API server and Kubernetes does the rest.

Once everything is up and running, Kubernetes sets up watch loops to make sure the observed state matches the desired state.

Now, assume you’ve experienced a bug, and you need to deploy an updated image that implements a fix. To do this, you update the same Deployment YAML file with the new image version and re-POST it to the API server. This registers a new desired state on the cluster, requesting the same number of Pods, but all running the new version of the image. To make this happen, Kubernetes creates a new ReplicaSet for the Pods with the new image. You now have two ReplicaSets – the original one for the Pods with the old version of the image and a new one for the Pods with the updated version. Each time Kubernetes increases the number of Pods in the new ReplicaSet (with the new version of the image), it decreases the number of Pods in the old ReplicaSet (with the old version of the image). Net result: you get a smooth rolling update with zero downtime. And you can rinse and repeat the process for future updates – just keep updating that manifest file (which should be stored in a version control system).

Rollbacks
As we’ve seen in the slides above, older ReplicaSets are wound down and no longer manage any Pods. However, they still exist with their full configuration. This makes them a great option for reverting to previous versions.

The process of rolling back is essentially the opposite of a rolling update – wind one of the old ReplicaSets up and wind the current one down. Simple.





