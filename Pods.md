A pod is the atomic unit of scheduling in Kubernetes. It’s where our containers run.
We can have multiple containers running in the same pod, but we usually have one primary container and the others just helping the primary.

We don’t scale applications by creating a pod with multiple containers but by creating multiple pods.
We can interact with running pods through kubectl.
Pods are not rescheduled automatically when they die.


Pods are where our applications run. It’s the basic building block and the atomic unit of scheduling in Kubernetes. Each pod will include one or more containers and every time we run a container in Kubernetes, it will be inside a pod.

It is important to understand that a pod is the atomic unit of scheduling in Kubernetes. So if we want to run, say, 10 replicas of our application, we would create 10 pods instead of creating one pod with 10 containers.

At first glance, a pod seems pretty similar to a container, but the main difference is that we can have multiple containers running inside a single pod. We can think of a pod as a way to group containers that cooperate to do something.

In most cases though, especially for simple applications like the ones we are running here, we will have only one container per pod.

When we run more than one container in a single pod, it’s usually to support the primary application. For example, we could have our primary nginx container running alongside another container that periodically pulls a github repository to update the website that nginx is serving.
In this case, the primary container is nginx, which is serving our website, and the container that is getting the code from github is there just to help this pod serve its main function.

