Kubernetes Dashboard is a web-based UI for Kubernetes clusters. It’s not deployed by default with Kubernetes, but running it is fairly straightforward.

A lot of the things that we did with kubectl can also be done through the dashboard, and it is also nice to be able to explore everything we have running in a cluster visually.

To run it, we will use the manifest file provided in the dashboard github repository:
kubectl create -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.2.0/aio/deploy/recommended.yaml


We can also see our containers’ logs, open an interactive session, scale deployments up and down, and a lot more.

We won’t talk about every single feature that is present in this dashboard, but a lot of what we can do with kubectl can also be done there. We can click around and explore it.

This would also work the same way if our cluster were running in a cloud provider; we just run kubectl proxy, and we’ll be able to access it from our local machine without needing to have it exposed to the outside world. How convenient!

To run any example locally, you need to have Docker and Kubernetes installed and running. If you already have that setup, feel free to skip this section. If you are not sure, you can run kubectl cluster-info to double-check:

kubectl cluster-info
# Kubernetes master is running at https://localhost:6443
# KubeDNS is running at https://localhost:6443/api...

All the examples you will run should work the same way with a Kubernetes cluster running in a cloud provider like AWS or Google Cloud. So, feel free to use that if you prefer.

If you have never used Kubernetes before, running it locally is convenient and should be very easy to set up, as you will see.

The three things we need to have available are:

Docker: The tool we use to build and run containers.
Kubernetes: The cluster where our container will run.
kubectl: The command line tool we use to talk to Kubernetes.
If you are using a Mac or Windows, the easiest way to run Docker and Kubernetes is with Docker Desktop. It’s a desktop application that is installed like any other. Just double-click it, and follow the installation instructions.

Once the installation is complete, you will see a pretty whale icon in the menu/task bar. After a few short seconds, you should see that Docker is running.

You can confirm that by running this in your terminal:
docker info

# Containers: 46
# Running: 22
# Paused: 0
# Stopped: 24
# Images: 198
# Server Version: 18.09.2
# ...

kubectl cluster-info
# Kubernetes master is running at https://localhost:6443
# KubeDNS is running at https://localhost:6443/api/v1/...

kubectl get nodes
# NAME                 STATUS   ROLES    AGE   VERSION
# docker-for-desktop   Ready    master   1d    v1.10.11


