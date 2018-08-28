centos7下kubeadm安装k8s1.11
##########################################

安装k8s步骤

环境:
    master,etcd:k8s1
    node1:k8s2
    node2:k8s3

前提：

    #. 基于主机名通信:/etc/hosts
    #. 时间同步;
    #. 关闭firewalld和iptables.service

安装配置步骤:

    #. etcd cluster, 仅master节点；
    #. flannel， 集群所有节点
    #. 配置k8s的master： 仅mster节点；

        kubernetes-mster

        启动的服务：

            kube-apiserver, kube-scheduler,kube-controller-manager

    #. 配置k8s的各node节点;

        kubernetes-node

        先设定启动docker服务;
        启动的k8s的服务:

            kube-proxy, kubelet


#. master,nodes: 安装kubelet ,kubeadm,docker
#. master: kubeadm init
#. nodes: kubeadm join
    https://github.com/kubernetes/kubeadm/blob/master/docs/design/design_v1.10.md


k8s1的操作
================

安装配置docker和kubernetes相关组件
-------------------------------------


.. code-block:: bash

    # python -c "$(curl -fsSL https://raw.githubusercontent.com/AlvinWanCN/poppy/master/code/common_tools/pullLocalYum.py)"  ##添加我的内网仓库
    # yum install docker-ce-17.12.1.ce kubelet kubeadm kubectl
    # vim /usr/lib/systemd/system/docker.service
    Environment="HTTPS_PROXY=http://www.ik8s.io:10080"
    Environment="NO_PROXY=127.0.0.0/8,172.20.0.0/16"
    # vim /etc/sysconfig/kubelet
    KUBELET_EXTRA_ARGS="--fail-swap-on=false"
    # systemctl start docker
    # systemctl enable docker


初始化kubernetes
=======================

.. code-block:: bash

    [root@k8s1 ~]# kubeadm  init --kubernetes-version=v1.11.2 --pod-network-cidr=10.244.0.0/16 --service-cidr=10.96.0.0/12 --ignore-preflight-errors=Swap
    [init] using Kubernetes version: v1.11.2
    [preflight] running pre-flight checks
    I0824 15:01:02.176363    7767 kernel_validator.go:81] Validating kernel version
    I0824 15:01:02.176491    7767 kernel_validator.go:96] Validating kernel config
        [WARNING SystemVerification]: docker version is greater than the most recently validated version. Docker version: 18.06.1-ce. Max validated version: 17.03
    [preflight/images] Pulling images required for setting up a Kubernetes cluster
    [preflight/images] This might take a minute or two, depending on the speed of your internet connection
    [preflight/images] You can also perform this action in beforehand using 'kubeadm config images pull'

    [kubelet] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
    [kubelet] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
    [preflight] Activating the kubelet service
    [certificates] Generated ca certificate and key.
    [certificates] Generated apiserver certificate and key.
    [certificates] apiserver serving cert is signed for DNS names [k8s1.alv.pub kubernetes kubernetes.default kubernetes.default.svc kubernetes.default.svc.cluster.local] and IPs [10.96.0.1 192.168.127.94]
    [certificates] Generated apiserver-kubelet-client certificate and key.
    [certificates] Generated sa key and public key.
    [certificates] Generated front-proxy-ca certificate and key.
    [certificates] Generated front-proxy-client certificate and key.
    [certificates] Generated etcd/ca certificate and key.
    [certificates] Generated etcd/server certificate and key.
    [certificates] etcd/server serving cert is signed for DNS names [k8s1.alv.pub localhost] and IPs [127.0.0.1 ::1]
    [certificates] Generated etcd/peer certificate and key.
    [certificates] etcd/peer serving cert is signed for DNS names [k8s1.alv.pub localhost] and IPs [192.168.127.94 127.0.0.1 ::1]
    [certificates] Generated etcd/healthcheck-client certificate and key.
    [certificates] Generated apiserver-etcd-client certificate and key.
    [certificates] valid certificates and keys now exist in "/etc/kubernetes/pki"
    [kubeconfig] Wrote KubeConfig file to disk: "/etc/kubernetes/admin.conf"
    [kubeconfig] Wrote KubeConfig file to disk: "/etc/kubernetes/kubelet.conf"
    [kubeconfig] Wrote KubeConfig file to disk: "/etc/kubernetes/controller-manager.conf"
    [kubeconfig] Wrote KubeConfig file to disk: "/etc/kubernetes/scheduler.conf"
    [controlplane] wrote Static Pod manifest for component kube-apiserver to "/etc/kubernetes/manifests/kube-apiserver.yaml"
    [controlplane] wrote Static Pod manifest for component kube-controller-manager to "/etc/kubernetes/manifests/kube-controller-manager.yaml"
    [controlplane] wrote Static Pod manifest for component kube-scheduler to "/etc/kubernetes/manifests/kube-scheduler.yaml"
    [etcd] Wrote Static Pod manifest for a local etcd instance to "/etc/kubernetes/manifests/etcd.yaml"
    [init] waiting for the kubelet to boot up the control plane as Static Pods from directory "/etc/kubernetes/manifests"
    [init] this might take a minute or longer if the control plane images have to be pulled
    [apiclient] All control plane components are healthy after 40.003098 seconds
    [uploadconfig] storing the configuration used in ConfigMap "kubeadm-config" in the "kube-system" Namespace
    [kubelet] Creating a ConfigMap "kubelet-config-1.11" in namespace kube-system with the configuration for the kubelets in the cluster
    [markmaster] Marking the node k8s1.alv.pub as master by adding the label "node-role.kubernetes.io/master=''"
    [markmaster] Marking the node k8s1.alv.pub as master by adding the taints [node-role.kubernetes.io/master:NoSchedule]
    [patchnode] Uploading the CRI Socket information "/var/run/dockershim.sock" to the Node API object "k8s1.alv.pub" as an annotation
    [bootstraptoken] using token: u57o3n.hjoj7q5shutcldli
    [bootstraptoken] configured RBAC rules to allow Node Bootstrap tokens to post CSRs in order for nodes to get long term certificate credentials
    [bootstraptoken] configured RBAC rules to allow the csrapprover controller automatically approve CSRs from a Node Bootstrap Token
    [bootstraptoken] configured RBAC rules to allow certificate rotation for all node client certificates in the cluster
    [bootstraptoken] creating the "cluster-info" ConfigMap in the "kube-public" namespace
    [addons] Applied essential addon: CoreDNS
    [addons] Applied essential addon: kube-proxy

    Your Kubernetes master has initialized successfully!

    To start using your cluster, you need to run the following as a regular user:

      mkdir -p $HOME/.kube
      sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
      sudo chown $(id -u):$(id -g) $HOME/.kube/config

    You should now deploy a pod network to the cluster.
    Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
      https://kubernetes.io/docs/concepts/cluster-administration/addons/

    You can now join any number of machines by running the following on each node
    as root:

      kubeadm join 192.168.127.94:6443 --token u57o3n.hjoj7q5shutcldli --discovery-token-ca-cert-hash sha256:dd8a747519cc49cb2cce0ab993f6643c349f72b3e3771c0065b28416e69a9f53



coreDNS是1.11开始使用的。

创建kubernetes客户端环境
=================================

.. code-block:: bash

    mkdir -p $HOME/.kube
    sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chown $(id -u):$(id -g) $HOME/.kube/config
    kubectl get nodes


安装flannel
=====================
.. code-block:: bash

    kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml


在node节点都装好相应的软件
===============================


.. code-block:: bash

    # yum install docker-ce-17.12.1.ce kubelet kubeadm kubectl

将前面配置好的master上的相关通用配置文件拷贝到node节点上去
==========================================================================
.. code-block:: bash

    scp /usr/lib/systemd/system/docker.service k8s3:/usr/lib/systemd/system/docker.service
    scp /usr/lib/systemd/system/docker.service k8s3:/usr/lib/systemd/system/docker.service
    scp /etc/sysconfig/kubelet  k8s2:/etc/sysconfig/kubelet
    scp /etc/sysconfig/kubelet  k8s3:/etc/sysconfig/kubelet


所以节点都把docker和kubelet设为开自启
=======================================================

.. code-block:: bash

    systemctl enable docker kubelet


node节点加入kubernetes
====================================

.. code-block:: bash

     kubeadm join 192.168.127.94:6443 --token u57o3n.hjoj7q5shutcldli --discovery-token-ca-cert-hash sha256:dd8a747519cc49cb2cce0ab993f6643c349f72b3e3771c0065b28416e69a9f53 --ignore-preflight-errors=Swap



curl的方式访问api
=========================

.. code-block:: bash

    $ curl  -k  https://192.168.1.51:6443 --cacert /etc/kubernetes/pki/apiserver.crt --key /etc/kubernetes/pki/apiserver-kubelet-client.key --cert  /etc/kubernetes/pki/apiserver-kubelet-client.crt


查看指定namespacei的pod列表


.. code-block:: bash

    $ curl  -k  --cacert /etc/kubernetes/pki/apiserver.crt --key /etc/kubernetes/pki/apiserver-kubelet-client.key --cert  /etc/kubernetes/pki/apiserver-kubelet-client.crt  https://192.168.1.51:6443/api/v1/namespaces/poppy/pods/