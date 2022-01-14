Notice that we are creating a Service and a Deployment in the same file. Multiple resources can be grouped together in a single manifest, separated by a line with three dashes (---). It’s a common pattern to have Service and Deployment together.

Right now these services are only reachable from inside the cluster, so let’s see how we can expose them with an Ingress. Remember that an Ingress sits in front of the services, defining rules to when a request should go to one service or another. Let’s start with a very simple Ingress that will send any request it receives to nginx-svc:

We now have an ingress listening on localhost:80. We’ll explore what this "HOSTS: *" means in a future lesson.

If we look at the ingress manifest, we’ll see that we are defining a single rule that says that requests sent to the path "/" will be sent to our nginx-svc service, using the port 1234.

Now, if we try to access the above URL, we should see the default nginx page.

If this was all we could do with an Ingress though, there wouldn’t be much difference from what we already can do with a single LoadBalancer service, so let’s see how we can expand this example to make it more interesting.

We will update our ingress manifest to define a new path that sends every request received at "/hello" to our hellok8s-svc. It works exactly the same way as the nginx rule; it’s just another entry in the same manifest:

So that’s nice! Now we can direct requests to the service we want based on the path we receive, such as / to nginx, /hello to hellok8s.

In practice, though, we usually will want to serve our services in different hosts. For example, we could want to serve nginx in http://nginx.example.com and hellok8s in http://hello.example.com.

Let’s see how we can change this Ingress to do that.

apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: hello-ingress
  annotations:
    # We are defining this annotation to prevent nginx
    # from redirecting requests to `https` for now
    nginx.ingress.kubernetes.io/ssl-redirect: "false"
spec:
  rules:
    - host: nginx.local.com
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: nginx-svc
                port:
                  number: 1234

    - host: hello.local.com
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: hellok8s-svc
                port:
                  number: 4567

It’s pretty much the same manifest with two changes:

Instead of defining one rule with two paths, we now have two different rules.
Each rule will define a host attribute that will tell Kubernetes that it should match only if the request received is sent to this host (such as, the Host header in the HTTP request).


It’s common to be confused about when to use an Ingress instead of a LoadBalancer, so let’s try to clarify that.

First of all, an Ingress is not a service type. It will act just as a smart router sending traffic to services based on the rules we define, while a LoadBalancer will actually provision an entirely new load balancer for each service we have.

But couldn’t we achieve the same thing an ingress does with several LoadBalancer services?

In some cases, we can, but there are a few advantages in using an Ingress.

For each LoadBalancer service we have, a new load balancer needs to be created. If we have 50 services running in our cluster, that means we will need 50 load balancers, which can get quite expensive. An Ingress allows us to achieve the same thing with a single load balancer!

Another thing that’s very useful with ingresses is that we can set up our rules in a way that requests to different paths are sent to different services. For example, if our users access example.com/foo, we may want to send these requests to the foo service and requests to example.com/bar should go to the bar service. This is trivial to implement with an Ingress, but it would be a lot harder if foo and bar each had their own load balancer.

Personally, a LoadBalancer is the easiest way to expose our services, while an Ingress is the most powerful.



