Ingress is another Kubernetes resource we can use to expose http(s) routes to external users.

You can think of an Ingress as something that sits in front of several services, and based on some rules that you define, it will decide where a given request should be sent to.

One peculiarity of the Ingress resource is that in order for it to work you need to have an Ingress Controller running in your cluster. This controller is what will decide what happens when you create a new Ingress. There are several different open source controllers available, each with its own set of features. We will run the nginx ingress controller in our cluster, but the features we will use should work fine in any other controller you may choose.

You can run the nginx ingress controller by applying this manifest file:
>kubectl apply -f \
https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.44.0/\
deploy/static/provider/cloud/deploy.yaml

And you can confirm the controller is running with:
>kubectl get pods --all-namespaces \
  -l app.kubernetes.io/name=ingress-nginx

# NAMESPACE       NAME                     READY   STATUS
# ingress-nginx   nginx-ingress-contr...   1/1     Running

If you see a pod running and ready, you’re good to go.

Before we start
Before we start exploring this Ingress resource, let’s just prepare our environment so we have some services running. Let’s run two services: one for our hellok8s app and another running nginx.

If we have any deployments and services that are running, we need to delete those first just to make sure we are starting clean by using the following command. If not, we’re ready to go:
>kubectl delete deployment,service --all

Then we will create a Service and a Deployment for our hellok8s applications:

