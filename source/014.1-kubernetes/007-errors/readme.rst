kubernetes errors
###########################


Failed to get kubernetes address: No kubernetes source found
============================================================================


it seems because deploy/1.8+/metrics-server-deployment.yaml doesn't have any options.

I've started metrics-server by adding "source" option referenced from https://github.com/kubernetes/heapster/blob/master/deploy/kube-config/google/heapster.yaml

+++ b/deploy/1.8+/metrics-server-deployment.yaml
@@ -31,6 +31,9 @@ spec:

::

           - name: metrics-server
             image: gcr.io/google_containers/metrics-server-amd64:v0.2.1
             imagePullPolicy: Always
    +        command:
    +        - /metrics-server
    +        - --source=kubernetes:https://kubernetes.default
             volumeMounts:
             - name: tmp-dir
               mountPath: /tmp


failed to get cpu utilization: missing request for cpu on container
============================================================================================

原因：定义pod的时候，没有设置resources，HPA取不到CPU当前值

::

            resources:
              requests:
                memory: "64Mi"
                cpu: "25m"
              limits:
                memory: "128Mi"
                cpu: "50m"