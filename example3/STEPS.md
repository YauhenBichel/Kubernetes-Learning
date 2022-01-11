1. Create nginx manifiest
2. To send the manifest to Kubernetes, we will use the kubectl command-line tool that we already have installed for you.
Run the application below, and enter the following command
> kubectl apply -f nginx.yaml
3. But just seeing a Running state is not good enough. Let’s try to actually see this application in our browser to make sure it’s running fine.
> kubectl port-forward --address 0.0.0.0 nginx 3000:80 
We used kubectl again but now calling the port-forward command. It will take the name of our application that is nginx, and forwards the requests received locally on port 3000 to the container’s port, 80 (that’s the default port nginx is listening to)


Sumup:
- We created a manifest file called nginx.yaml, saying we wanted to run the nginx docker image.
- We sent this manifest to Kubernetes using kubectl.
- After we confirmed the application was running, we used kubectl again to forward request, which was received on port 3000, to our application.
