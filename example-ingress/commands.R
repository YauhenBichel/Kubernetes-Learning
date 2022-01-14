# You can run the nginx ingress controller by applying this manifest file:
kubectl apply -f \
https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.44.0/\
deploy/static/provider/cloud/deploy.yaml

# And you can confirm the controller is running with:
kubectl get pods --all-namespaces \
  -l app.kubernetes.io/name=ingress-nginx

# NAMESPACE       NAME                     READY   STATUS
# ingress-nginx   nginx-ingress-contr...   1/1     Running


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

curl http://localhost/hello
# [v3] Hello, Kubernetes, from hellok8s-7f4c57d446-qth54!

curl http://localhost
# (nginx welcome page)

# Applying the ingress Controller

kubectl apply -f \
https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.44.0/\
deploy/static/provider/cloud/deploy.yaml

kubectl apply -f hellok8s.yaml
# service/hellok8s-svc created
# deployment.apps/hellok8s created

kubectl apply -f nginx.yaml
# service/nginx-svc created
# deployment.apps/nginx created

kubectl apply -f ingress.yaml
# ingress.extensions/hello-ingress configured

# Please enter the following command if you get an error while applying the ingress 
# and then reapply the ingress using the above command
# If not, you can skip this command and move ahead
kubectl delete -A ValidatingWebhookConfiguration ingress-nginx-admission

kubectl get ingress
# NAME           HOSTS             ADDRESS   PORTS
# hello-ingress  nginx.local.com   localhost 80
#                hello.local.com

# It now lists all the hosts it’s serving; that is, nginx.local.com and hello.local.com.

# One thing that we will notice now is that we can’t access these services using localhost anymore:
# Check the status of the controller using the following commmand:
kubectl get pods --all-namespaces \
  -l app.kubernetes.io/name=ingress-nginx

# Please wait for the controller to run

# Inorder to run the ingress on the platform, you need to run the following port-forward command:
# You don't require this command if you're working locally

nohup kubectl port-forward --address 0.0.0.0 -n ingress-nginx service/ingress-nginx-controller 80:80 > /dev/null 2>&1 &

curl http://localhost
# 404...

# Let’s understand why.
# When our Ingress receives a request, it will check the Host HTTP header to determine which rule will match. We currently have two rules defined, one for nginx.local.com and another for hello.local.com. But when we try to access http://localhost, what is sent in this header is the string "localhost":

curl --verbose http://localhost
# ...
# > GET / HTTP/1.1
# > Host: localhost
# > User-Agent: curl/7.54.0
# ...

# This is not a problem we will have in a production environment where we would have a proper DNS entry pointing to this Ingress endpoint (instead of localhost). And it would, therefore, receive the correct Host header. To test things locally, though, there are two tricks we can use.
# Sending the correct Host in our local requests#
# The first trick is quite simple if we are using something like curl where we can manipulate the headers we send. Using the --header flag with curl, we can change the Host we are sending. For example:

curl --header 'Host: hello.local.com' localhost
# [v3] Hello, Kubernetes, from hellok8s-7f4c57d446-cjznh!

curl --header 'Host: nginx.local.com' localhost
# nginx welcome page

# If we want to see this in our browser, though, it can be a bit harder. We would probably need to use some extension to modify requests. Thats when the things start to get a bit messy.
# A simple way to solve this is to configure our DNS to resolve hello.local.com and nginx.local.com to localhost. This can be done by changing the /etc/hosts file or C:\windows\system32\drivers\etc\hosts on Windows:
echo "127.0.0.1 hello.local.com" >> /etc/hosts
echo "127.0.0.1 nginx.local.com" >> /etc/hosts

# Here, we are just telling our DNS that when we access hello.local.com or nginx.local.com, it should resolve that to 127.0.0.1, which will end up in our Ingress.
# Now we can test that out:
curl http://hello.local.com
# [v3] Hello, Kubernetes, from hellok8s-7f4c57d446-qth54!

curl http://nginx.local.com
# nginx welcome page



