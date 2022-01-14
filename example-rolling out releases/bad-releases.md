Deployments also allow us to mitigate the risk of a bad release either by letting us manually rollback this release or by automatically preventing this release from happening.

Automatically blocking bad releases#
So we can manually rollback a bad release, but wouldn’t it be nice if we could prevent this bad release from being released in the first place?

Kubernetes lets us define a way to automatically probe a pod before it starts receiving requests, and that’s what we can use in this case. There are two types of probes: a readinessProbe and a livenessProbe. We’ll first use readinessProbe, and then we can talk about the difference between the two.

Let’s go back to our manifest and add this readinessProbe attribute:

apiVersion: apps/v1
kind: Deployment
metadata:
  name: hellok8s
spec:
  replicas: 2
  selector:
    matchLabels:
      app: hellok8s
  template:
    metadata:
      labels:
        app: hellok8s
    spec:
      containers:
      - image: yauhenbichel/hellok8s:v2 # Still using v2
        name: hellok8s-container
        readinessProbe: # New readiness probe
          periodSeconds: 1
          successThreshold: 5
          httpGet:
            path: /
            port: 4567

Here’s what this is doing; We are telling Kubernetes that it should consider this container ready to start receiving requests only after it has received five successful responses from a GET request to the / path on port 4567. And that it should send this request once every second.

Now we can see that Kubernetes created a new pod (hellok8s-68f47f657c-zwn6g) and that this pod is running. But if we check the READY column, it says 0/1. That is, from the 1 container we had to run in this pod 0 are ready, which will prevent Kubernetes from sending it any requests. But more importantly, it will prevent Kubernetes from terminating the pods that we currently have running.

To debug exactly what is happening, we can use kubectl describe:
> kubectl describe pod hellok8s-68f47f657c-zwn6g

# ...
# ...
# ...
# Readiness probe failed:
# HTTP probe failed with statuscode: 500

And we can see that Kubernetes started this pod. But when it tried to send it, the requests we defined in the readinessProbe started receiving an error, so the pod was never considered ready and the rollout was blocked.

A readinessProbe can be used to prevent bad releases from happening in obvious cases like this, but it can also be used to ensure everything is ready for this pod to start receiving requests. It could, for example, warm a cache, or check that another external dependency is available. Only then, signal to Kubernetes that it is ready.

