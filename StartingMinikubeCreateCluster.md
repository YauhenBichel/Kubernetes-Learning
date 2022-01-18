> minikube start --vm-driver=virtualbox
> minikube status
> minikube dashboard

Another useful Minikube command to output the environment variables is docker-env:
> minikube docker-env

The output is as follows.
export DOCKER_TLS_VERIFY="1"
export DOCKER_HOST="tcp://192.168.99.100:2376"
export DOCKER_CERT_PATH="/Users/educative/.minikube/certs"
export DOCKER_API_VERSION="1.23"
# Run this command to configure your shell:
# eval $(minikube docker-env)

If you have worked with Docker Machine, you’ll notice that the output is the same. Both docker-machine env and minikube docker-env serve the same purpose. They output the environment variables required for a local Docker client to communicate with a remote Docker server. In this case, that Docker server is the one inside a VM created by Minikube.

Once Docker is installed, we can connect the client running on your laptop with the server in the Minikube VM.
> eval $(minikube docker-env)

We can test that easily by, for example, listing all the running containers on that VM.
> docker container ls

> minikube ssh
> docker container ls
> exit

We entered into the Minikube VM, listed containers, and got out. There’s no reason to do anything else beyond showing that SSH is possible, even though you probably won’t use it.

What else is there to verify? We can, for example, confirm that kubectl is also pointing to the Minikube VM.
> kubectl config current-context
> kubectl get nodes
NAME     STATUS ROLES  AGE VERSION
minikube Ready  master 31m v1.14.0

> kubectl get all --all-namespaces

> minikube stop
> minikube start
> minikube delete

> minikube start \
    --vm-driver=virtualbox \
    --kubernetes-version="v1.14.0"

> kubectl version --output=yaml
clientVersion:
  buildDate: "2019-04-08T17:11:31Z"
  compiler: gc
  gitCommit: ...
  gitTreeState: clean
  gitVersion: v1.14.1
  goVersion: go1.12.1
  major: "1"
  minor: "14"
  platform: darwin/amd64
serverVersion:
  buildDate: "2019-03-25T15:45:25Z"
  compiler: gc
  gitCommit: ...
  gitTreeState: clean
  gitVersion: v1.14.0
  goVersion: go1.12.1
  major: "1"
  minor: "14"
  platform: linux/amd64






