kubeadm
##############

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

