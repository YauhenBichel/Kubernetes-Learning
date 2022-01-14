#- Write a pod manifest file to run the apache container (the docker image is called httpd).
#- Use kubectl to apply this manifest and see it running.
#- Use kubectl port-forward to send requests from the port 3000 to the container’s port 80.
#Note: You need to add the --address 0.0.0.0 to the kubectl port-forward to run it on the platform.

#- Confirm that you can see Apache’s default page saying “It works!” when you access localhost:3000.
#- Enter the container, and change the contents of the file
#/usr/local/apache2/htdocs/index.html, so when you refresh the page you can see your changes.

#Let’s apply this manifest using the following command:

kubectl apply -f apache.yaml
#Next, let’s check the pods we have running:

kubectl get pods
#Once the pod is in the running state, we’ll use kubectl port-forward to send requests from localhost:3000 to the container’s port 80:

kubectl port-forward apache 3000:80

#Now, let’s try to change the contents of the /usr/local/apache2/htdocs/index.html file. For this, we need to enter the container by running the following command:

kubectl exec -it apache -- sh
#Once inside the container, we can change the contents of this file to whatever string we want. But for the sake of this example, let’s change it to “Welcome to Apache!” We can use the following command to do just that:

echo "Welcome to Apache!" > /usr/local/apache2/htdocs/index.html
#Now, when you reopen the URL and refresh the page, you will see the “Welcome to Apache!” page.

