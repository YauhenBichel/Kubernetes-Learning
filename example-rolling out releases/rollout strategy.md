We can use two different strategies to roll out new versions of our applications: Recreate and RollingUpdate.
The Recreate strategy will guarantee that we don’t have different versions running at the same time and at the cost of requiring a short downtime.
RollingUpdate is the default strategy and will gradually create pods that use the new version while terminating pods running the previous versions.
We can use maxSurge and maxUnavailable to control the rollout rate.
A readinessProbe can be used to only allow traffic to be sent to a container after we determine it is ready.
A livenessProbe can be used to automatically restart containers that don’t appear to be healthy anymore

As you may have noticed, when we are using the rollingUpdate strategy (which is the default) we will have, for a period of time, both versions of our application (v1 and v2) running in parallel. If we don’t want that to happen for any reason, we can configure the Deployments with a different strategy called Recreate:

apiVersion: apps/v1
kind: Deployment
metadata:
  name: hellok8s2
spec:
  strategy:
    type: Recreate
  replicas: 3
  selector:
    matchLabels:
      app: hellok8s
  template:
    metadata:
      labels:
        app: hellok8s
    spec:
      containers:
      - image: yauhenbichel/hellok8s:v2
        name: hellok8s-container

All our pods will be terminated, then pods using the new version will be created. Unfortunately, this creates a period of downtime while the new pods are being created:

