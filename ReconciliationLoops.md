Fundamental to the desired state is the concept of background reconciliation loops (a.k.a. control loops).

For example, ReplicaSets implement a background reconciliation loop that is constantly checking whether the right number of Pod replicas are present on the cluster.

If there aren’t enough, it adds more. If there are too many, it terminates some. To be crystal clear, Kubernetes is constantly making sure that the current state matches the desired state.

If they don’t match – maybe the desired state is 10 replicas, but only 8 are running – Kubernetes declares a red alert condition, orders the control plane to battle-stations, and brings up two more replicas. And the best part, it does all of this without calling you at 04:20 am!

But it’s not just failure scenarios. These very same reconciliation loops enable scaling.

For example, if you POST an updated config that changes the replica count from 3 to 5, the new value of 5 will be registered as the application’s new desired state. The next time the ReplicaSet reconciliation loop runs, it will notice the discrepancy and follow the same process – sounding the klaxon horn for red alert and spinning up two more replicas.

It really is a beautiful thing.


