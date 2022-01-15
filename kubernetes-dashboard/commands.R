kubectl create -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.2.0/aio/deploy/recommended.yaml

kubectl proxy
# Starting to serve on 127.0.0.1:8001

# To run it on the platform, run the following command
kubectl proxy --address 0.0.0.0 --accept-hosts='.*'

kubectl describe secret default-token

# Name:         default-token-f9kl9
# Namespace:    default
# Labels:       <none>
# Annotations:  kubernetes.io/service-account.name: default
#               kubernetes.io/service-account.uid: 0bbbfb03
# Type:  kubernetes.io/service-account-token
# 
# Data
# ====
# ca.crt:     1025 bytes
# namespace:  7 bytes
# token:      eyJhbGciOiJS...

# After all the resources are created, we should be ready to start using the dashboard. We will create a proxy to be able to connect to the Kubernetes API Server from our local machine:
kubectl proxy
# Starting to serve on 127.0.0.1:8001

# To run it on the platform, run the following command
kubectl proxy --address 0.0.0.0 --accept-hosts='.*'

kubectl describe secret default-token

# Name:         default-token-f9kl9
# Namespace:    default
# Labels:       <none>
# Annotations:  kubernetes.io/service-account.name: default
#               kubernetes.io/service-account.uid: 0bbbfb03
# Type:  kubernetes.io/service-account-token
# 
# Data
# ====
# ca.crt:     1025 bytes
# namespace:  7 bytes
# token:      eyJhbGciOiJS...

