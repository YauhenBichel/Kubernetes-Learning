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

