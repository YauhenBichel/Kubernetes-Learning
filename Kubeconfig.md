When we run kubectl locally, it needs a way to know how to communicate with our Kubernetes cluster. We also have to talk to multiple different clusters. For example, we could be using our local cluster for testing, a staging cluster running in Google Cloud and a production one on AWS.

Every time we run kubectl, it will look for a config file to find that information. By default, this file is created at ~/.kube/config and is usually referred to as kubeconfig.

config:
apiVersion: v1
kind: Config
current-context: docker-for-desktop

clusters:
- cluster:
    insecure-skip-tls-verify: true
    server: https://localhost:6443
  name: docker-for-desktop-cluster

users:
- name: docker-for-desktop
  user:
    client-certificate-data: LS0tL...
    client-key-data: LS0tL...

contexts:
- context:
    cluster: docker-for-desktop-cluster
    user: docker-for-desktop
  name: docker-for-desktop

We can see that it has three main sections: Clusters, Users, and Contexts. This is a normal yaml file, and each of these sections include a list of values, so we can have multiple clusters, users, and contexts.

We start defining all the clusters kubectl can connect to. In our example, we have only one cluster that is running locally on https://localhost:6443. If we had, for example, another cluster running on AWS, it could look something like this:

clusters:
- cluster:
    insecure-skip-tls-verify: true
    server: https://localhost:6443
  name: docker-for-desktop-cluster

- cluster:
    server: https://7150E27E.us-east-1.eks.amazonaws.com
  name: production


The name defined for each cluster can be anything that helps us identify what this cluster is. That will only be referenced in this config file, so it doesn’t need to have any relation with anything that’s actually running in the cluster. It’s just a more user-friendly way to reference the cluster.

Next, we have the users section where we define how we are going to authenticate against a cluster. In our example, we have only one user that is using a X509 certificate for authentication. We can, again, define a user-friendly name for this user. In our case, it’s being called docker-for-desktop.

Lastly, we define our contexts. A context is the combination of a cluster and a user. In our example, we have a context called docker-for-desktop that is connecting to the docker-for-desktop-cluster cluster using the user docker-for-desktop.

When we run kubectl, it will always look at what is the current-context defined in the kubeconfig file. We can double check the context that is being used:
> kubectl config current-context
# docker-for-desktop

If we have more than one context, we can either change the current-context so all the subsequent commands are run using that context:
> kubectl config use-context production
# Switched to context "production"

Or define the context we want to use for individual kubectl commands:
> kubect get pods --context production

By default, kubectl will look for a config file at ~/.kube/config, but we can override that using the --kubeconfig flag:
> kubectl --kubeconfig="path/to/config" get pods

kubectl uses the kubeconfig file to find out how to connect to our cluster(s).
In this config file, we define the clusters, users, and contexts we have.

Every time we run a command with kubectl, it will use our current context that is a combination of a cluster to connect to and a user that will be used for authentication.

The current context is also defined in the kubeconfig file, and it can be overridden with the --context flag.

The kubeconfig path can be overridden with the --kubeconfig flag.

