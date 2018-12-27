零停机滚动发布
####################

本文参考网络地址：https://www.cnblogs.com/justmine/p/8688828.html

前言
=====


在当下微服务架构盛行的时代，用户希望应用程序时时刻刻都是可用，为了满足不断变化的新业务，需要不断升级更新应用程序，有时可能需要频繁的发布版本。实现"零停机"、“零感知”的持续集成(Continuous Integration)和持续交付/部署(Continuous Delivery)应用程序，一直都是软件升级换代不得不面对的一个难题和痛点，也是一种追求的理想方式，也是DevOps诞生的目的。

滚动发布
============
一次完整的发布过程，合理地分成多个批次，每次发布一个批次，成功后，再发布下一个批次，最终完成所有批次的发布。在整个滚动过程期间，保证始终有可用的副本在运行，从而平滑的发布新版本，实现零停机(without an outage)、用户零感知，是一种非常主流的发布方式。由于其自动化程度比较高，通常需要复杂的发布工具支撑，而k8s可以完美的胜任这个任务


k8s滚动更新机制
====================

k8s创建副本应用程序的最佳方法就是部署(Deployment)，部署自动创建副本集(ReplicaSet)，副本集可以精确地控制每次替换的Pod数量，从而可以很好的实现滚动更新。具体来说，k8s每次使用一个新的副本控制器(replication controller)来替换已存在的副本控制器，从而始终使用一个新的Pod模板来替换旧的pod模板。


大致步骤如下：

    #. 创建一个新的replication controller。
    #. 加或减少pod副本数量，直到满足当前批次期望的数量。
    #. 删除旧的replication controller。


演示
=======

使用kubectl更新一个已部署的应用程序，并模拟回滚。为了方便分析，将应用程序的pod副本数量设置为10。 这里我们更新的deployment 名叫myapp

::

    kubectl scale --replicas=10 deployment myapp


发布微服务
-------------

查看部署列表

::

    kubectl get deployments

查看正在运行的pod

::

    kubectl get pods

通过pod描述，查看应用程序的当前映像版本

::

    kubectl describe pods myapp

升级镜像版本到v2

::

    kubectl set image  deployment myapp   myapp=ikubernetes/myapp:v2


验证发布
-------------

检查rollout状态

::

    kubectl rollout status deployment/myapp



回滚发布
------------

::

    kubectl rollout undo deployment/myapp


那么如果我们想回滚到指定版本呢？答案是k8s完美支持，并且还可以通过资源文件进行配置保留的历史版次量。这里我们先查看历史版次

::

    [root@k8s1 ~]# kubectl rollout history deployment myapp
    deployment.extensions/myapp
    REVISION  CHANGE-CAUSE
    6         <none>
    7         <none>


查看单个revision 的详细信息：

::

    [root@k8s1 ~]# kubectl rollout history deployment myapp --revision=6
    deployment.extensions/myapp with revision #6
    Pod Template:
      Labels:	pod-template-hash=65899575cd
        run=myapp
      Containers:
       myapp:
        Image:	ikubernetes/myapp:v2
        Port:	<none>
        Host Port:	<none>
        Environment:	<none>
        Mounts:	<none>
      Volumes:	<none>

恢复到指定版次

::

    [root@k8s1 ~]# kubectl  rollout undo deployment/myapp  --to-revision=6
    deployment.extensions/myapp rolled back


原理
======

k8s精确地控制着整个发布过程，分批次有序地进行着滚动更新，直到把所有旧的副本全部更新到新版本。实际上，k8s是通过两个参数来精确地控制着每次滚动的pod数量：

    - maxSurge 滚动更新过程中运行操作期望副本数的最大pod数，可以为绝对数值(eg：5)，但不能为0；也可以为百分数(eg：10%)。默认为25%。
    - maxUnavailable 滚动更新过程中不可用的最大pod数，可以为绝对数值(eg：5)，但不能为0；也可以为百分数(eg：10%)。默认为25%。

如果未指定这两个可选参数，则k8s会使用默认配置：

::

    kubectl get deployment myapp -o yaml


剖析部署概况
----------------

::

    [root@k8s1 ~]# kubectl get deployment myapp
    NAME    READY   UP-TO-DATE   AVAILABLE   AGE
    myapp   10/10   10           10          74m



- DESIRED 最终期望处于READY状态的副本数
-  CURRENT 当前的副本总数
- UP-TO-DATE 当前完成更新的副本数
- AVAILABLE 当前可用的副本数


