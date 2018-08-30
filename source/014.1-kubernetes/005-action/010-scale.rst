scale
##############
动态扩容或缩容

scale帮助文档
=====================

::

    Set a new size for a Deployment, ReplicaSet, Replication Controller, or StatefulSet.

    Scale also allows users to specify one or more preconditions for the scale action.

    If --current-replicas or --resource-version is specified, it is validated before the scale is attempted, and it is
    guaranteed that the precondition holds true when the scale is sent to the server.

    Examples:
      # Scale a replicaset named 'foo' to 3.
      kubectl scale --replicas=3 rs/foo

      # Scale a resource identified by type and name specified in "foo.yaml" to 3.
      kubectl scale --replicas=3 -f foo.yaml

      # If the deployment named mysql's current size is 2, scale mysql to 3.
      kubectl scale --current-replicas=2 --replicas=3 deployment/mysql

      # Scale multiple replication controllers.
      kubectl scale --replicas=5 rc/foo rc/bar rc/baz

      # Scale statefulset named 'web' to 3.
      kubectl scale --replicas=3 statefulset/web

    Options:
          --all=false: Select all resources in the namespace of the specified resource types
          --allow-missing-template-keys=true: If true, ignore any errors in templates when a field or map key is missing in
    the template. Only applies to golang and jsonpath output formats.
          --current-replicas=-1: Precondition for current size. Requires that the current size of the resource match this
    value in order to scale.
      -f, --filename=[]: Filename, directory, or URL to files identifying the resource to set a new size
      -o, --output='': Output format. One of:
    json|yaml|name|go-template|go-template-file|templatefile|template|jsonpath|jsonpath-file.
          --record=false: Record current kubectl command in the resource annotation. If set to false, do not record the
    command. If set to true, record the command. If not set, default to updating the existing annotation value only if one
    already exists.
      -R, --recursive=false: Process the directory used in -f, --filename recursively. Useful when you want to manage
    related manifests organized within the same directory.
          --replicas=0: The new desired number of replicas. Required.
          --resource-version='': Precondition for resource version. Requires that the current resource version match this
    value in order to scale.
      -l, --selector='': Selector (label query) to filter on, supports '=', '==', and '!='.(e.g. -l key1=value1,key2=value2)
          --template='': Template string or path to template file to use when -o=go-template, -o=go-template-file. The
    template format is golang templates [http://golang.org/pkg/text/template/#pkg-overview].
          --timeout=0s: The length of time to wait before giving up on a scale operation, zero means don't wait. Any other
    values should contain a corresponding time unit (e.g. 1s, 2m, 3h).

    Usage:
      kubectl scale [--resource-version=version] [--current-replicas=count] --replicas=COUNT (-f FILENAME | TYPE NAME)
    [options]

    Use "kubectl options" for a list of global command-line options (applies to all commands).


创建一个deployment和service
=========================================
.. code-block:: bash

    [root@k8s1 ~]# kubectl run myapp --image=ikubernetes/myapp:v1 --replicas=2
    deployment.apps/myapp created
    [root@k8s1 ~]# kubectl expose deployment myapp --name=myapp --port=80
    service/myapp exposed
    [root@k8s1 ~]# kubectl get svc -l run=myapp
    NAME      TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
    myapp     ClusterIP   10.101.46.221   <none>        80/TCP    23s

这个时候，service是自带负载均衡的，对service的请求会调度到后端的pod

我们对service myapp的ip的80端口请求50次，看每个主机请求了多少次。

::

    [root@k8s1 ~]# for i in {1..50};do curl -s 10.101.46.221/hostname.html;done|sort |uniq -c
         22 myapp-848b5b879b-hfdnr
         28 myapp-848b5b879b-q8jnl

上面的结果可以看到，一个pod请求了22次，另一个请求了28次。


通过scale管理pod数量
=========================

- 现在我们使用scale命令将pod数量提高到5个

::

    [root@k8s1 ~]# kubectl scale --replicas=5 deployment myapp
    deployment.extensions/myapp scaled


- 然后再访问那个service，这次我们访问500次

.. code-block:: bash

    [root@k8s1 ~]# for i in {1..500};do curl -s 10.101.46.221/hostname.html;done|sort |uniq -c
        118 myapp-848b5b879b-hfdnr
         97 myapp-848b5b879b-k2dvt
        103 myapp-848b5b879b-m8gwh
         90 myapp-848b5b879b-q8jnl
         92 myapp-848b5b879b-q8wmm


结果可以看到，请求被随机分配到了五个pod上，平均每个pod100次左右。


- 然后我们将pod数量减少到3个,然后访问300次。

.. code-block:: bash

    [root@k8s1 ~]# kubectl scale --replicas=3 deployment myapp
    deployment.extensions/myapp scaled
    [root@k8s1 ~]#
    [root@k8s1 ~]# for i in {1..300};do curl -s 10.101.46.221/hostname.html;done|sort |uniq -c
        106 myapp-848b5b879b-hfdnr
         89 myapp-848b5b879b-q8jnl
        105 myapp-848b5b879b-q8wmm


