## Secrets
It’s common to need to pass sensitive configs to our applications like credentials and private keys. We could use ConfigMaps for these configs as well, but when we are concerned with the security of these values, we have a better option: Secrets.

The way a Secret is used is pretty similar to a ConfigMap, but there are some key differences in how they work under the hood:

- Secrets are only distributed to the nodes that are running a pod that needs them.
- They are never written to physical storage.
- In the master node, they are stored encrypted.
- When we read a Secret, we will get the data base64 encoded. This is mostly so we can store binary values in a secret, not much of a security feature as base64 is easily decoded.

# hellok8s-secret.yaml
apiVersion: v1
kind: Secret
metadata:
  name: hellok8s-secret
data:
  SECRET_MESSAGE: "SXQgd29ya3Mgd2l0aCBhIFNlY3JldAo="

The only change is that instead of using configMapKeyRef, we are using secretKeyRef.

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
              secretKeyRef:
                name: hellok8s-secret
                key: SECRET_MESSAGE


It can be annoying to have to base64-encode every string before creating a Secret. And if all we need is a string like we’ve used here and not a binary value, we can use the stringData field to create secrets in raw format:

apiVersion: v1
kind: Secret
metadata:
  name: hellok8s-secret
stringData:
  SECRET_MESSAGE: "It works with a Secret"


It’s up to you to decide if you want to inject your secrets as environment variables or mount a volume, but keep in mind that putting sensitive data in environment variables may have unintended consequences. It’s not uncommon for applications to dump all the environment variables when they crash, outputting everything for error reporting, which could expose some sensitive information. For example, we could be shipping our logs to a third party provider that would gladly receive our database credentials. Environment variables are also inherited by child processes that our container can create. So depending on what we are running, we may not want that to happen.

Secrets are very similar to ConfigMaps in the way they are used, but there are some key differences in how they work to provide more security.

A Secret will never be written to physical storage, they are stored encrypted in the master node, and they are only distributed to the nodes that are running pods that need them.


Secrets, like ConfigMaps, can be injected into containers as environment variables or mounted as a volume.
Keeping sensitive data in environment variables can have unintended consequences, so we should think twice before doing that.

