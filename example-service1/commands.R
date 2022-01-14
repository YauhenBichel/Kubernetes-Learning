kubectl apply -f service.yaml
kubectl get service hellok8s-svc
kubectl apply -f deployment.yaml

curl http://localhost:30001
# [v3] Hello, Kubernetes, from hellok8s-7f4c57d446-t9ngx!

curl http://localhost:30001
# [v3] Hello, Kubernetes, from hellok8s-7f4c57d446-985dq!

curl http://localhost:30001
# [v3] Hello, Kubernetes, from hellok8s-7f4c57d446-t9ngx!