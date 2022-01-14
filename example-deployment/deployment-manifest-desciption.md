Let’s go through all the fields in this manifest to understand what’s happening. First, we tell Kubernetes what kind of object we are defining here. In our case, this is a Deployment.

In the metadata.name field, we define a unique name for our deployment. This can be anything that helps you identify what this deployment is managing.

In the spec section, we define what this deployment will do. First, we define how many replicas we want. That is, how many exact copies of this pod we want to run. For now, we’re running just one replica, but we will play with that field in a bit.

The selector section is probably the only thing that’s not super intuitive right away. What we are doing in this field is telling Kubernetes that this deployment is managing all the pods that have a label called app with the value hellok8s. This is what links deployments to pods. Labels are simply key-value pairs that you define for your pods, and that’s what is used to find all the pods that a Deployment needs to look after.

Then we define the template section: that’s the definition of pods that we want to run. Here, we are defining a pod with the label app: hellok8s (to create the link with the deployment) and saying this pod will run the brianstorti/hellok8s:v1 docker image.
