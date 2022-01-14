## Rolling Update
The kind of release that was done is called a RollingUpdate, which means we first create one pod with the new version. And after it’s running, we terminate one pod running the previous versions, and we keep doing that until all the pods running are using the desired version.

Let’s say we have 10 pods running v1, and we wanted to manually release v2. We would need to manually start a new pod and wait until it was up and running. Then, terminate one of the pods still running v1, and repeat that process 10 times.

In this case, we only have two replicas, so rolling out a new version doesn’t take too long. But imagine if we had, say, 100 replicas running, and we wanted to roll out a new version in the same way. We’d have to add one new pod with the new version, wait until it’s ready, and then remove one pod with the old version. It would take forever!

There are two properties we can use to define how fast our rollout will happen: maxSurge and maxUnavailable.

The maxSurge property will define how many pods we can have exceeding our desired replica count, which is specified in the deployment manifest. maxUnavailable defines how many pods we can have below this count. These properties can be defined as an absolute number (for example, 10) or as a percentage (for example, 20%). The default value for both is 25%. Here’s an example of how that would work, assuming a Deployment with 3 replicas and a maxSurge and maxUnavailable of 1 .

Kubernetes will ensure that during this rollout we will have a minimum of 2 (desired - maxUnavailable) and maximum of 4 (desired + maxSurge) replicas.

We can change the default value for these properties in our manifest:
