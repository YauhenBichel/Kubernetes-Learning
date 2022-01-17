Most resources in Kubernetes will live in a namespace. All the pods, deployments, services, configmaps, and everything else we have created so far are all running in the default namespace; that (as the name implies) is where resources will run if we don’t explicitly say we want them to run somewhere else.

We can create other namespaces if we want, and they can help us organize our resources the same way we can organize our code with modules or packages. It should be clear, though, that namespaces do not provide strong security boundaries. Resources from one namespace can still access resources from another.

## Creating a namespace
Like everything else, namespaces can be created with a manifest file. That is as simple as it gets; we just need to give it a name:
apiVersion: v1
kind: Namespace
metadata:
  name: my-namespace

We can see our my-namespace was created, and we can also notice we have a couple of other namespaces active as well. For example, we have ingress-nginx that was created for us when we installed the nginx ingress controller in a previous chapter, and that is a good example of a use-case for namespaces. All the resources that are running in these namespaces are related to the ingress controller, and we probably don’t want to see these resources when we run something like kubectl get pods. We can, however, see resources from a specific namespace using the -n flag with kubectl:

We can also use the --all-namespaces flag to see resources from all namespaces, and we can combine that with kubectl get all to see everything we have running in our cluster:
kubectl get pods --all-namespaces
kubectl get all --all-namespaces

There are two different ways to define the namespace to run a resource in. We can simply use the -n flag when we run kubectl apply, or we can define that in the resource’s manifest. Let’s use our nginx pod to see how that works.

And if we run it with the -n flag, we can apply the manifest in our new namespace:
kubectl apply -f nginx-pod.yaml -n my-namespace
# pod/nginx created

One thing you will notice is that namespaces provide a scope for names, so we can have a pod (or any other resource) with the exact same name (nginx in this case) running in different namespaces.

We can try to list the pods to confirm we have one pod running in each namespace now:
kubectl get pods
# NAME    READY   STATUS 
# nginx   1/1     Running

kubectl get pods -n my-namespace
# NAME    READY   STATUS   
# nginx   1/1     Running 

Another way to define the resource namespace is by explicitly declaring that in the manifest file. So for our nginx pod, it would look like this:
apiVersion: v1
kind: Pod
metadata:
  name: nginx
  namespace: my-namespace
spec:
  containers:
  - name: nginx-container
    image: nginx

And then we can just kubectl apply it without the -n flag, and this pod would be created in the defined namespace.


