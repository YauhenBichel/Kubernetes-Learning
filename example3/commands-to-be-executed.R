kubectl apply -f \
https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.44.0/\
deploy/static/provider/cloud/deploy.yaml


kubectl get pods --all-namespaces \
  -l app.kubernetes.io/name=ingress-nginx

# NAMESPACE       NAME                     READY   STATUS
# ingress-nginx   nginx-ingress-contr...   1/1     Running

# Run the following command if services and deployments are already
# running
kubectl delete deployment,service --all

kubectl apply -f hellok8s.yaml
# service/hellok8s-svc created
# deployment.apps/hellok8s created

kubectl apply -f nginx.yaml
# service/nginx-svc created
# deployment.apps/nginx created

kubectl get pods
# NAME                        READY   STATUS    RESTARTS 
# hellok8s-7f4c57d446-6c8b8   1/1     Running   0        
# hellok8s-7f4c57d446-jkqbl   1/1     Running   0        
# nginx-77c5c66899-dgkk2      1/1     Running   0        
# nginx-77c5c66899-w9srw      1/1     Running   0        

kubectl get service
# NAME           TYPE        CLUSTER-IP       PORT(S)   
# hellok8s-svc   ClusterIP   10.102.242.233   4567/TCP  
# nginx-svc      ClusterIP   10.96.19.78      1234/TCP 

kubectl apply -f ingress.yaml
# ingress.extensions/hello-ingress created

# Please enter the following command if you get an error while applying the ingress 
# and then reapply the ingress using the above command
# If not, you can skip this command and move ahead
kubectl delete -A ValidatingWebhookConfiguration ingress-nginx-admission

kubectl get ingress
# NAME            HOSTS   ADDRESS     PORTS   AGE
# hello-ingress   *       localhost   80      1m

kubectl apply -f ingress-updated.yaml
# ingress.extensions/hello-ingress configured

# Inorder to run the ingress on the platform, you need to run the following port-forward command:
# You don't require this command if you're working locally
nohup kubectl port-forward --address 0.0.0.0 -n ingress-nginx service/ingress-nginx-controller 80:80 > /dev/null 2>&1 &

# Now in another terminal session,  run
curl http://localhost/hello
# [v3] Hello, Kubernetes, from hellok8s-7f4c57d446-qth54!

curl http://localhost
# (nginx welcome page)