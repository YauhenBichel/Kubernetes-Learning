Notice that we are creating a Service and a Deployment in the same file. Multiple resources can be grouped together in a single manifest, separated by a line with three dashes (---). It’s a common pattern to have Service and Deployment together.

Right now these services are only reachable from inside the cluster, so let’s see how we can expose them with an Ingress. Remember that an Ingress sits in front of the services, defining rules to when a request should go to one service or another. Let’s start with a very simple Ingress that will send any request it receives to nginx-svc:

We now have an ingress listening on localhost:80. We’ll explore what this "HOSTS: *" means in a future lesson.

If we look at the ingress manifest, we’ll see that we are defining a single rule that says that requests sent to the path "/" will be sent to our nginx-svc service, using the port 1234.

Now, if we try to access the above URL, we should see the default nginx page.

If this was all we could do with an Ingress though, there wouldn’t be much difference from what we already can do with a single LoadBalancer service, so let’s see how we can expand this example to make it more interesting.

We will update our ingress manifest to define a new path that sends every request received at "/hello" to our hellok8s-svc. It works exactly the same way as the nginx rule; it’s just another entry in the same manifest:


