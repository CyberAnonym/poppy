监控
######


官方yaml地址：

https://github.com/kubernetes/heapster/tree/master/deploy/kube-config/influxdb

raw地址：


https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/influxdb/influxdb.yaml
https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/influxdb/grafana.yaml
https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/influxdb/heapster.yaml





grafana这里我们也是下载文件后修改一下

.. code-block:: bash

    $ wget https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/influxdb/grafana.yaml
    $ vim grafana.yaml
    apiVersion: extensions/v1beta1
    kind: Deployment
    metadata:
      name: monitoring-grafana
      namespace: kube-system
    spec:
      replicas: 1
      template:
        metadata:
          labels:
            task: monitoring
            k8s-app: grafana
        spec:
          containers:
          - name: grafana
            image: k8s.gcr.io/heapster-grafana-amd64:v5.0.4
            ports:
            - containerPort: 3000
              protocol: TCP
            volumeMounts:
            - mountPath: /etc/ssl/certs
              name: ca-certificates
              readOnly: true
            - mountPath: /var
              name: grafana-storage
            env:
            - name: INFLUXDB_HOST
              value: monitoring-influxdb
            - name: GF_SERVER_HTTP_PORT
              value: "3000"
              # The following env variables are required to make Grafana accessible via
              # the kubernetes api-server proxy. On production clusters, we recommend
              # removing these env variables, setup auth for grafana, and expose the grafana
              # service using a LoadBalancer or a public IP.
            - name: GF_AUTH_BASIC_ENABLED
              value: "false"
            - name: GF_AUTH_ANONYMOUS_ENABLED
              value: "true"
            - name: GF_AUTH_ANONYMOUS_ORG_ROLE
              value: Admin
            - name: GF_SERVER_ROOT_URL
              # If you're only using the API Server proxy, set this value instead:
              # value: /api/v1/namespaces/kube-system/services/monitoring-grafana/proxy
              value: /
          volumes:
          - name: ca-certificates
            hostPath:
              path: /etc/ssl/certs
          - name: grafana-storage
            emptyDir: {}
    ---
    apiVersion: v1
    kind: Service
    metadata:
      labels:
        # For use as a Cluster add-on (https://github.com/kubernetes/kubernetes/tree/master/cluster/addons)
        # If you are NOT using this as an addon, you should comment out this line.
        kubernetes.io/cluster-service: 'true'
        kubernetes.io/name: monitoring-grafana
      name: monitoring-grafana
      namespace: kube-system
    spec:
      # In a production setup, we recommend accessing Grafana through an external Loadbalancer
      # or through a public IP.
      # type: LoadBalancer
      # You could also use NodePort to expose the service at a randomly-generated port
      type: NodePort
      ports:
      - port: 80
        targetPort: 3000
        nodePort: 30110
      selector:
        k8s-app: grafana
    $ kubectl create -f grafana.yaml


这里我们是将service的 spec.type的值设置为了NodePort, 然后添加了nodePort:30110
这里heapster我们可以直接创建

.. code-block:: bash

    $ kubectl create -f