## Build the image 
> docker build
> docker image build -t {DockerHubId}/qsk-course:1.0 .
> docker image ls

## Host the image on a registry
> docker login --username <DockerHubId>
> docker image push {DockerHubId}/qsk-course:1.0

## Verify cluster
> kubectl get nodes
- Configure kubectl to talk to your LKE cluster
>kubectl config view
>export KUBECONFIG=/usercode/config

Kubernetes orchestrates and runs containers, these containers must be wrapped in a Kubernetes construct called a Pod. A Pod is a lightweight wrapper found around a container. Kubernetes runs containers inside of Pods – in the same way that VMware runs applications inside of VMs, Kubernetes runs containerized applications inside of Pods. 
>kubectl get nodes
>kubectl apply -f pod.yml
>kubectl port-forward --address 0.0.0.0 first-pod 8080:8080
The application is now running on Kubernetes

>kubectl get pods

Connecting to the application requires a separate object called a Service.
“Object” is a technical term used to describe something running on Kubernetes. You’ve already deployed a Pod object. Now, you’re about to deploy a Service object to provide connectivity to the application running in the Pod.

The svc-cloud.yml file defines a Service object to provide connectivity if your cluster is in the cloud 
The svc-local.yml file defines a NodePort Service, instead of a LoadBalancer Service. This is because Docker Desktop and other laptop-based clusters do not have access to internet-facing load balancers.

As with Pods, you can deploy Service objects with kubectl apply.
As was mentioned previously, the source code has two Services:
- svc-cloud.yml is for use on cloud-based clusters. This will be called the "load-balancer Service"
- svc-local.yml is for use on clusters, such as Docker Desktop, that do not run on clouds. This one will be called the “NodePort Service.”

The load-balancer Service tells Kubernetes to provision one of your cloud’s internet-facing load balancers. It works with all the major clouds and is a simple way to expose your application to the internet.
>kubectl apply -f pod.yml
>kubectl apply -f svc-local.yml
>kubectl get svc
Now that the Service is running, you can connect to the application and view the web page in the browser tab.
>kubectl apply -f svc-cloud.yml
>kubectl get svc
>kubectl port-forward --address 0.0.0.0 service/cloud-lb 8080:8080
>kubectl get svc
>kubectl delete svc cloud-lb


There are two important elements to the working of a Deployment.
- The Deployment object
- The Deployment controller

The Deployment object is the YAML configuration that defines an application. It states things like which container to run, what network port to listen on, and how many instances (Pods) to deploy.

The Deployment controller is a control plane process, which is constantly monitoring the cluster to ensure that all the Deployment objects are running as they are supposed to.
>kubectl get pods
>kubectl get deployments
>kubectl apply -f deploy.yml
>kubectl get deployments
>kubectl delete pod qsk-deploy-69996c4549-r59nl
>kubectl get pods

When a Node fails, any Pods running on it are lost. If those Pods are managed by a controller such as a Deployment, replacements will be started on other Nodes in the cluster.
If your cluster is on a cloud that implements Node pools, the failed Node may also be replaced. This is a Node pool and cloud infrastructure feature, not a feature of Deployments

>get pods -o wide
>kubectl get nodes

Kubernetes has a separate object, called a Horizontal Pod Autoscaler (HPA), for automatic scaling.

>kubectl apply -f deploy.yml
>kubectl get deployments
>kubectl get deployment qsk-deploy
>kubectl apply -f deploy.yml
>kubectl get deployment qsk-deploy
>kubectl get pods

>kubectl scale --replicas 5 deployment/qsk-deploy
>kubectl get pods
>kubectl apply -f deploy.yml -f svc-cloud.yml
>kubectl get deployments
>kubectl get svc

>kubectl rollout status deployment qsk-deploy
>kubectl delete deployment qsk-deploy
>kubectl delete svc cloud-lb






