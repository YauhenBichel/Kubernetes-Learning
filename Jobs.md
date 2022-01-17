# Resource: Job
All the pods that we have run so far are intended to keep running indefinitely. That is, until we decide to kill them, they should keep running forever. That is not always what we want, though. Sometimes we need to run a process that performs a specific task and exits. A database migration is a good example where we want it to start, do what it needs to do, and exit. It doesn’t need to keep running forever. For these cases, we can use the Job resource.

A Job is a resource that (just like a Deployment) will create one or more pods for us. It will then watch these pods and make sure they do what they need to do and exit successfully. When all the pods finish, the Job is then marked as completed and its work is done.

## example-job/echo-job.yaml
example-job/echo-job.yaml  is a “one-shot” Job. It will start a container that echos a message and exits. As soon as this container finishes, it will be marked as “completed” and this Job is done.

# echo-job.yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: echo-job
spec:
  template:
    spec:
      restartPolicy: OnFailure
      containers:
      - name: echo
        image: busybox
        command: ["echo", "Running in a job"]

As you can see, the template is fairly similar to a Deployment, except for this restartPolicy that we haven’t seen before. This is a property that defines when a pod should be restarted, and the three possible values are Always, OnFailure, and Never.

The default value for this pod property is Always, meaning that the pod should always be restarted regardless of why the pod finished (for example, if it’s a successful exit or a failure). Due to the nature of a Job, this policy can’t be used, and that’s why we need to explicitly override it here, so the only two possible values for a pod being managed by a Job are OnFailure and Never.

If we define OnFailure, the pod will be restarted if it fails, and if we define Never, an entirely new pod will be created (instead of the failed one being restarted in place). Unless there is a reason for you to not want your pod to be restarted in place, a good general rule is to always stick with OnFailure, as it will avoid the creation of unnecessary pods in case of failures.

After the pod exits, it will not be deleted, so we can inspect its logs, but the status goes from Running to Completed. When we inspect the Job, we will also see that the number of desired completions (1) matches the number of successful runs, so this Job's life ends here.

One thing that’s important to notice is that this Job will not be automatically deleted, even though it will never actually do anything again. Kubernetes 1.12 introduced the ttlSecondsAfterFinished property that, as the name implies, allows us to define a number of seconds after which the Job should be automatically deleted. It’s nice to have the Jobs around for a while after they finish, so we can debug issues and read the logs. But it’s a good idea to set this property to avoid having a bunch of finished Jobs hanging around forever.

When we want to run a job more than once, we can set the completions field (which will be 1 by default) like this:
apiVersion: batch/v1
kind: Job
metadata:
  name: echo-job
spec:
  completions: 5
  template:
    spec:
      restartPolicy: OnFailure
      containers:
      - name: echo
        image: busybox
        command: ["echo", "Running in a job"]
This will create one pod, wait until it finishes, then create a new one, wait for it to finish, and so on until we have five pods completed. The pods will all run sequentially, one after the other.

Although I’m sure we can be creative and find a good reason to run the same task five times in a row, a more common use-case is to run multiple pods in parallel. For that we can set the parallelism property:
apiVersion: batch/v1
kind: Job
metadata:
  name: echo-job
spec:
  parallelism: 3
  completions: 5
  template:
    spec:
      restartPolicy: OnFailure
      containers:
      - name: echo
        image: busybox
        command: ["echo", "Running in a job"]
Now instead of running pods sequentially, this Job will run three pods at a time. As soon as one of them finishes, it will start a new one until we reach our goal of five completions. A use-case for this could be processing messages from a queue in parallel.




