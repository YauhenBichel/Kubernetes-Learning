echo 'It works with a Secret' | base64
# SXQgd29ya3Mgd2l0aCBhIFNlY3JldAo=

kubectl apply -f hellok8s-secret.yaml
kubectl apply -f deployment.yaml

kubectl get pods
# NAME                        READY   STATUS
# hellok8s-6d7579848d-f56wb   1/1     Running
# hellok8s-6d7579848d-kzq57   1/1     Running

# Replace the pod name to what you have running locally
kubectl exec -it hellok8s-6d7579848d-kzq57 --  env | grep MESSAGE
# MESSAGE=It works with a Secret

kubectl get secret hellok8s-secret -o yaml

# apiVersion: v1
# kind: Secret
# data:
#   SECRET_MESSAGE: SXQgd29ya3Mgd2l0aCBhIFNlY3JldAo=
# ...


