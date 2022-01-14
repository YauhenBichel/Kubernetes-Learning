docker build . -t brianstorti/hellok8s:v2
docker push brianstorti/hellok8s:v2

kubectl apply -f deployment.yaml
# deployment.apps/hellok8s configured

kubectl get pods
# You should see new pods being created 
# and the old ones being terminated.

kubectl get pods
# NAME                        READY   STATUS
# hellok8s-6678f66cb8-52zt9   1/1     Running
# hellok8s-6678f66cb8-nxphs   1/1     Running

# You can locally run the port forward command by replacing the pod name
kubectl port-forward hellok8s-6678f66cb8-52zt9 3001:4567

# To run it on the platform, please make sure to replace the pod name 
# and add the address flag to run it on the platform
kubectl port-forward hellok8s-6678f66cb8-52zt9 --address 0.0.0.0 3001:4567

# or you can use it with nohup too by entering the following command
# Don't forget to replace the pod name to what you have running locally
nohup kubectl port-forward --address 0.0.0.0 hellok8s-6678f66cb8-52zt9 3001:4567 > /dev/null 2>&1 &
# or open another terminal and run the followig command
curl http://localhost:3001
# [v2] Hello, Kubernetes!

kubectl apply -f deployment.yaml
kubectl get pods

docker build . -t yauhenbichel/hellok8s:buggy
docker push yauhenbichel/hellok8s:buggy

kubectl rollout undo deployment hellok8s


