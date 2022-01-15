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


