kubectl describe nodes
# ...
# Allocatable:
#  cpu:                2
#  ephemeral-storage:  56453061334
#  hugepages-1Gi:      0
#  hugepages-2Mi:      0
#  memory:             1944636Ki
#  pods:               110
# ...
# ...
# non-terminated pods:
#   namespace    name                 cpu requests
#   ---------    ----                 ------------
#   kube-system  kube-apiserver...    250m (12%)  
#   kube-system  kube-controlle...    200m (10%)  
#   kube-system  kube-dns-86f4d...    260m (13%)  
#   kube-system  kube-scheduler...    100m (5%)   

When we create a pod to run our application, we can define how much CPU and memory it will need. Kubernetes will then only schedule this pod on nodes that have enough capacity to fulfil these requests.

This does not mean the containers will be limited to that amount of resources; it just means that if a node can’t provide the requested CPU and memory, the pod won’t even be allowed to run there.

Here’s how we define this request in the pod’s definition:
apiVersion: v1
kind: Pod
metadata:
  name: busybox
spec:
  containers:
  - name: busybox-container
    image: busybox
    command: ["dd", "if=/dev/zero", "of=/dev/null"]
    resources:
      requests:
        cpu: 500m
        memory: 5Mi

We’re running a busybox container, which is a super small image that includes some useful UNIX utilities we can use. We define the command dd if=/dev/zero of=/dev/null as the container entrypoint. This is a command that won’t really do anything useful, but it will use as much CPU as it can, so it works well for our tests.

We can also see a new attribute called resources where we define how much CPU and memory we need. We are saying we want 500 millicores (1/2 of a single CPU core) and 5 megabytes of memory.

apiVersion: v1
kind: Pod
metadata:
  name: hungry-busybox
spec:
  containers:
  - name: hungry-busybox-container
    image: busybox
    command: ["dd", "if=/dev/zero", "of=/dev/null"]
    resources:
      requests:
        cpu: 700m
        memory: 5Mi

kubectl apply -f busybox.yaml
# pod/busybox created

Now we can run the top command to see how much CPU is being used:
kubectl exec -it busybox -- top
# ...
#   PID  PPID USER %CPU COMMAND
#     1     0 root 51.5 dd if /dev/zero of /dev/null

We see this process is using around 50% of the CPU available on this node. Since we have two CPUs, this means the container is using all the resources from one CPU (because it runs in a single thread, it will never be able to use more than that). It’s important to demonstrate that; even though we requested 500m, the container is allowed to use more than that and is now using 1000m (such as, one entire CPU).

Let’s now try to create another container requesting 700m, which is more than we have available (500m + 700m is more than the 1190m we have), to see what happens:
apiVersion: v1
kind: Pod
metadata:
  name: hungry-busybox
spec:
  containers:
  - name: hungry-busybox-container
    image: busybox
    command: ["dd", "if=/dev/zero", "of=/dev/null"]
    resources:
      requests:
        cpu: 700m
        memory: 5Mi

kubectl apply -f hungry-busybox.yaml
#  pod/hungry-busybox created

Even though kubectl can successfully apply this manifest, let’s see the pods that are running:
kubectl get pods
# NAME             READY   STATUS
# busybox          1/1     Running
# hungry-busybox   0/1     Pending

We see the hungry-busybox pod we just created, but it will stay in the Pending state forever. If we get more information about the pod with describe, we will be able to see the reason it is not being scheduled:
kubectl describe pod hungry-busybox
# ...
# Events:
# Type     Reason            Message
# ----     ------            -------
# Warning  FailedScheduling  0/1 nodes are available:
#                            1 Insufficient cpu.

So we can see the pod was not scheduled because none of the nodes available had enough capacity to fulfil the container’s request of 700m.

In our case, there is not much that can be done, as we have only one node running locally. But in a production environment, this would be used to try to schedule this pod in another node with enough resources available.

We can now try to delete our busybox to see what happens:
kubectl delete pod busybox
# pod "busybox" deleted

After a few seconds, we’ll see our hungry-busybox going from Pending to Running. As the busybox container does not exist anymore, this node can now fulfill the request for 700m of CPU and the container can be scheduled. The same thing would happen if we could, for example, add a new worker node to our cluster. As soon as Kubernetes detects our cluster has enough resources, it will schedule all the pods we need to run.

As we have seen, even though defining the container’s request will help with the scheduling of pods, it will not limit how much memory or CPU a container can use. Our busybox container was, in fact, using double the amount of CPU it requested.

We can use the limits property to define hard limits for these resources:
apiVersion: v1
kind: Pod
metadata:
  name: limited-busybox
spec:
  containers:
  - name: limited-busybox-container
    image: busybox
    command: ["dd", "if=/dev/zero", "of=/dev/null"]
    resources:
      requests:
        cpu: 500m
        memory: 10Mi
      limits:
        cpu: 500m
        memory: 10Mi

Here, we are defining another pod called limited-busybox that also includes a limits section that will limit our CPU usage to 500m.

If we run this pod and check the CPU usage again using top, we will notice the difference:
kubectl apply -f limited-busybox.yaml

---

kubectl exec -it limited-busybox -- top
# ...
# PID  PPID USER %CPU COMMAND
#   1     0 root 24.7 dd if /dev/zero of /dev/null
# ...

This container is now limited to 500m. That, in our case, will be around 25% of the CPU available.

There is a difference in what happens to a container when it reaches its limit for CPU and memory usage. CPU is a compressible resource, which means Kubernetes can just stop giving that specific container CPU time if a container tries to use more CPU than it should. The container will not be killed. It will just not have to keep running with the amount of CPU time it has available.

With memory, it’s different. If a container tries to allocate more memory than it can, Kubernetes will kill the process. Then, depending on the restartPolicy that is defined for this pod, it can be restarted.

So we saw that defining resource requests are useful to help Kubernetes schedule our pod in a node that has enough resources and defining a limit will guarantee that a rogue container won’t affect other applications sharing the same worker node. It is a good idea to always set these properties.

Kubernetes allows us to define a LimitRange with default values that will be used for every container that we run in a namespace.

apiVersion: v1
kind: LimitRange
metadata:
  name: memory-limit-range
spec:
  limits:
  - default:
      memory: 500Mi
      cpu: 200m
    defaultRequest:
      memory: 100Mi
      cpu: 100m
    type: Container

kubectl apply -f default-limit-range.yaml
# limitrange/memory-limit-range created

kubectl apply -f hellok8s.yaml
# pod/hellok8s created

kubectl describe pod hellok8s
# ...
# Limits:
#   cpu:     200m
#   memory:  500Mi
# Requests:
#   cpu:        100m
#   memory:     100Mi
# ...


Containers without resource limits can affect other applications sharing the same worker node.

We can define a resource request so Kubernetes will only schedule a pod in a worker node that can fulfill that request.

Containers can use more resources than they requested.


We can also explicitly limit the resources a container is allowed to use.
CPU is throttled and a container is not killed because it tried to use more CPU than its limit.
If a container tries to allocate more memory than its limit, Kubernetes will kill the process and the container can be restarted.
We can use LimitRage to define default resources limits and requests for a namespace.





