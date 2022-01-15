Most real-world applications will need some kind of configuration that should not be baked into the docker image itself. These are usually settings that vary depending on which environment the application is running on such as production, staging, development, and so on.

A common solution for this problem is to store these configs in environment variables that can be easily changed between deploys without requiring us to change any code or to rebuild our docker images.

If we want to run this same application in multiple different environments, like staging and production, we would need to have two copies of this manifest just to change the value of these environment variables. This is one of the problems with embedding these environment variables in the manifest.

Luckily, Kubernetes has a high level resource called ConfigMap that serves this purpose. It’s basically a place for us to store key-value pairs that can be injected into our containers when they run. Let’s see an example.

# hellok8s-config.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: hellok8s-config
data:
  MESSAGE: "It works with a ConfigMap!"

Once again, it’s defined as a manifest file, and it’s as simple as it gets. It just needs a name and a list of keys with their respective values. In this case, we are defining a ConfigMap called hellok8s-config that defines a config called MESSAGE with the value "It works with a ConfigMap!".

Let’s now replace what we did in our manifest to make it use this ConfigMap:

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
      - image: brianstorti/hellok8s:v4
        name: hellok8s-container
        env:
          - name: MESSAGE
            valueFrom:
              configMapKeyRef:
                name: hellok8s-config
                key: MESSAGE

Here, we are saying that this container should be created with the environment variable MESSAGE, and that the value for this variable should come from the key MESSAGE defined in a ConfigMap called hellok8s-config. Notice that it just happens that we are using the same name for the variable here ("MESSAGE"). But we could, for example, reuse this same value in another container with an environment variable that has a different name:

env:
  - name: ANOTHER_VARIABLE_NAME
    valueFrom:
      configMapKeyRef:
        name: hellok8s-config
        key: MESSAGE


## Getting all the variables from a ConfigMap
This solution works fine in this case where we have only one variable we need to get from the ConfigMap, but we can imagine how it can start to get tedious if we need to do that for dozens of variables.

env:
  - name: VAR1
    valueFrom:
      configMapKeyRef:
        name: hellok8s-config
        key: VAR1

  - name: VAR2
    valueFrom:
      configMapKeyRef:
        name: hellok8s-config
        key: VAR2

  - name: VAR3
    valueFrom:
      configMapKeyRef:
        name: hellok8s-config
        key: VAR3
# ...

So Kubernetes provides a way for us to get all the variables from a ConfigMap and inject them into the container at once:

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
      - image: brianstorti/hellok8s:v4
        name: hellok8s-container
        envFrom:
          - configMapRef:
              name: hellok8s-config

If we apply this change and run the following commands, we will see everything keeps working the same way. But now, every new key that is added to the ConfigMap will be available for this container when it’s created.

kubectl apply -f hellok8s-updated.yaml

curl localhost:30001
# [v4] It works with a ConfigMap! (from hellok8s-54d5fb5765-nl62z)

One thing that we lose when we use envFrom to get all the values from a ConfigMap is the ability to specify the name of the environment variables that will be injected. It will always use the name defined in the ConfigMap. This is usually fine. But if we are injecting the configs from multiple different ConfigMaps, we can have conflicting variable names that would be overridden. To fix that, we can add a prefix to all the variables names imported from each ConfigMap:

apiVersion: apps/v1
kind: Deployment
metadata:
  name: hellok8s
spec:
  replicas: 1
  selector:
    matchLabels:
      app: hellok8s
  template:
    metadata:
      labels:
        app: hellok8s
    spec:
      containers:
      - image: brianstorti/hellok8s:v4
        name: hellok8s-container
        envFrom:
        - configMapRef:
            name: hellok8s-config
          prefix: CONFIG_

With this change, our environment variable would be injected as "CONFIG_MESSAGE".


