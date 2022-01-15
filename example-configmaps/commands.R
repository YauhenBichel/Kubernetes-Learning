# If we want to make sure we are starting clean for these examples, we can also delete all the resources that we may have created previously:
kubectl delete deployment,service,ingress --all

kubectl apply -f hellok8s.yaml 

curl localhost:30001
# [v4] Hello, Kubernetes (from hellok8s-69dbd44879-vt8dv)

kubectl apply -f hellok8s-updated.yaml 

curl localhost:30001
# [v4] It works! (from hellok8s-568f64dd94-bfxhs)

kubectl apply -f hellok8s-config.yaml

kubectl apply -f hellok8s.yaml

kubectl apply -f service.yaml

curl localhost:30001
# [v4] It works with a ConfigMap! (from hellok8s-54d5fb5765-nl62z)

kubectl apply -f hellok8s-updated.yaml

curl localhost:30001
# [v4] It works with a ConfigMap! (from hellok8s-54d5fb5765-nl62z)


