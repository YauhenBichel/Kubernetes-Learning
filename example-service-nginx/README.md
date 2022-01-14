Notice that we are creating a Service and a Pod in the same file. Multiple resources can be grouped together in a single manifest, separated by a line with three dashes (-).

Here, we are creating a service and a pod in the same manifest. We add the label app: nginx to the pod so the service can find it, as that’s what is defined in the service’s selector. Also, notice that we explicitly defined the service type. We could have left that out and Kubernetes would have assumed it was a ClusteIP service.



