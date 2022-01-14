kubectl apply -f deployment.yaml
kubectl apply -f service.yaml

# Get all the running pods using the following command
kubectl get pods

# Replace the pod name to what you have running locally
kubectl exec -it hellok8s-664f77d78c-49nhw -- sh

# Filtering the HELLOK8S resource by it's name by using grep.
env | grep HELLOK8S

# HELLOK8S_SVC_PORT_4567_TCP=tcp://10.102.141.32:4567
# HELLOK8S_SVC_SERVICE_HOST=10.102.141.32
# HELLOK8S_SVC_PORT_4567_TCP_ADDR=10.102.141.32
# HELLOK8S_SVC_PORT=tcp://10.102.141.32:4567
# HELLOK8S_SVC_SERVICE_PORT=4567
# HELLOK8S_SVC_PORT_4567_TCP_PORT=4567
# HELLOK8S_SVC_PORT_4567_TCP_PROTO=tcp

curl $HELLOK8S_SVC_SERVICE_HOST:$HELLOK8S_SVC_SERVICE_PORT
# [v3] Hello, Kubernetes, from hellok8s-7f4c57d446-lh44f!
