# Build the image
docker build . -t yauhenbichel/hellok8s:v1

# And push it to DockerHub
docker push yauhenbichel/hellok8s:v1

# We have already saved this file as deployment.yaml. Let’s apply it to our cluster:
kubectl apply -f deployment.yaml

# Now if we inspect the deployments we have running, we should see our new hellok8s there
kubectl get deployments

# And if we inspect our pods, we will see that a new pod was also created by this deployment
kubectl get pods

# replace the pod name to what you have running locally

kubectl port-forward hellok8s-6678f66cb8-42jtr 3001:4567

# replace the pod name to what you have running locally and 
# In order to run this on the platform, you need to add the additional 
# address flag so the above command would become:

kubectl port-forward hellok8s-78997b6f8f-66kkc --address 0.0.0.0 3001:4567

# you can also run this with no hup as:
# Don't forget to replace the pod name to what you have running locally
nohup kubectl port-forward --address 0.0.0.0 hellok8s-78997b6f8f-66kkc  3001:4567 > /dev/null 2>&1 &



