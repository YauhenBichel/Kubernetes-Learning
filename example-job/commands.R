kubectl apply -f echo-job.yaml
# job.batch/echo-job created

kubectl get pods
# NAME             READY   STATUS
# echo-job-sttd5   0/1     Completed

kubectl logs echo-job-sttd5
# Running in a job

kubectl get jobs
# NAME       DESIRED   SUCCESSFUL
# echo-job   1         1

# Jobs are immutable, so delete it first if you already have one running.
kubectl delete job echo-job
# job.batch "echo-job" deleted

kubectl apply -f echo-job.yaml
# job.batch/echo-job created

# After a few seconds...
kubectl get pods
# NAME             READY   STATUS
# echo-job-b68j5   0/1     Completed
# echo-job-hcfnl   0/1     Completed
# echo-job-pdm6l   0/1     Completed
# echo-job-pjdcq   0/1     Completed
