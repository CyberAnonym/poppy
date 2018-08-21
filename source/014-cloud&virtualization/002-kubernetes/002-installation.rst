k8s1.6.2在ubuntu16.04的二进制部署
##########################################

.. contents::

安装环境
============

 三台服务器，一台master，两台node，三台服务器之间已做了ssh免密码登录认证。

k8s.alv.pub enviroment

**三台服务器上都存在的配置**

.. code:: bash

    cat /etc/hosts
    127.0.0.1   localhost
    192.168.127.94 k8s1.alv.pub k8s1
    192.168.127.95 k8s2.alv.pub k8s2
    192.168.127.96 k8s3.alv.pub k8s3

-  三台服务器系统版本都是ubuntu16.04。

**master服务器信息**  Hostname: k8s1.alv.pub IP: 192.168.127.94

**node1服务器信息** Hostname: k8s2.alv.pub IP: 192.168.127.95

**node2服务器信息** Hostname: k8s3.alv.pub IP: 192.168.127.96

安装docker
==========

.. code-block:: bash

    yum install docker -y

    ssh-keygen

    ssh-copy-id k8s1

    ssh-copy-id k8s2

    ssh-copy-id k8s3

创建证书
========

创建证书部分参考地址：http://blog.csdn.net/u010278923/article/details/71082349

.. code:: shell

    wget https://pkg.cfssl.org/R1.2/cfssl_linux-amd64
    chmod +x cfssl_linux-amd64
    sudo mv cfssl_linux-amd64 /usr/local/bin/cfssl

    wget https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64
    chmod +x cfssljson_linux-amd64
    sudo mv cfssljson_linux-amd64 /usr/local/bin/cfssljson

    wget https://pkg.cfssl.org/R1.2/cfssl-certinfo_linux-amd64
    chmod +x cfssl-certinfo_linux-amd64
    sudo mv cfssl-certinfo_linux-amd64 /usr/local/bin/cfssl-certinfo

创建ca-config.json

.. code:: json

    vim ca-config.json

    {
      "signing": {
        "default": {
          "expiry": "8760h"
        },
        "profiles": {
          "kubernetes": {
            "usages": [
                "signing",
                "key encipherment",
                "server auth",
                "client auth"
            ],
            "expiry": "8760h"
          }
        }
      }
    }

创建ca-csr.json vim ca-csr.json

.. code:: json

    {
      "CN": "kubernetes",
      "key": {
        "algo": "rsa",
        "size": 2048
      },
      "names": [
        {
          "C": "CN",
          "ST": "Shanghai",
          "L": "Shanghai",
          "O": "k8s",
          "OU": "System"
        }
      ]
    }

生成证书

.. code:: shell

    cfssl gencert -initca ca-csr.json | cfssljson -bare ca

查看ca证书

.. code:: shell

    ls ca*
    ca-config.json  ca.csr  ca-csr.json  ca-key.pem  ca.pem

生成kubernetes证书 创建kubernetes-csr.json

.. code:: json

    vim kubernetes-csr.json

    {
      "CN": "kubernetes",
      "hosts": [
        "127.0.0.1",
        "192.168.127.94",
        "192.168.127.95",
        "192.168.127.96",
        "172.18.0.1",
        "k8s1",
        "k8s2",
        "k8s3",
        "k8s1.alv.pub",
        "k8s2.alv.pub",
        "k8s3.alv.pub",
        "kubernetes",
        "kubernetes.default",
        "kubernetes.default.svc",
        "kubernetes.default.svc.cluster",
        "kubernetes.default.svc.cluster.local"
      ],
      "key": {
        "algo": "rsa",
        "size": 2048
      },
      "names": [
        {
          "C": "CN",
          "ST": "Shanghai",
          "L": "Shanghai",
          "O": "k8s",
          "OU": "System"
        }
      ]
    }

这个里面配置的IP，是使用该证书机器的IP，根据自己的环境填写其中172.18.0.1是kubernetes自带的service，执行生成命令
生成证书

.. code:: bash

    cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=kubernetes kubernetes-csr.json | cfssljson -bare kubernetes

**创建admin证书**\  创建admin-csr.json vim admin-csr.json

.. code:: json

    {
      "CN": "admin",
      "hosts": [],
      "key": {
        "algo": "rsa",
        "size": 2048
      },
      "names": [
        {
          "C": "CN",
          "ST": "Shanghai",
          "L": "Shanghai",
          "O": "system:masters",
          "OU": "System"
        }
      ]
    }

**生成证书**\

.. code:: bash

    cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=kubernetes admin-csr.json | cfssljson -bare admin
    ls admin*

**创建proxy证书**\  创建kube-proxy-csr.json vim kube-proxy-csr.json

.. code:: json

    {
      "CN": "system:kube-proxy",
      "hosts": [],
      "key": {
        "algo": "rsa",
        "size": 2048
      },
      "names": [
        {
          "C": "CN",
          "ST": "Shanghai",
          "L": "Shanghai",
          "O": "k8s",
          "OU": "System"
        }
      ]
    }

**生成证书**\

.. code:: bash

    cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=kubernetes  kube-proxy-csr.json | cfssljson -bare kube-proxy

秘钥分发

.. code:: bash

    for i in k8s1 k8s2 k8s3;do ssh  $i 'mkdir -p /etc/kubernetes/ssl';done
    for i in k8s1 k8s2 k8s3;do scp *.pem  $i:/etc/kubernetes/ssl;done

查看验证证书 openssl x509 -noout -text -in kubernetes.pem

配置kubeconfig
==============

-  下载并解压软件到指定位置 #下载软件

.. code-block:: bash

    wget https://github.com/kubernetes/kubernetes/releases/download/v1.11.2/kubernetes.tar.gz
    tar xf kubernetes.tar.gz
    ./kubernetes/cluster/get-kube-binaries.sh
    y
    cd kubernetes/server/
    tar xf kubernetes-server-linux-amd64.tar.gz
    cd kubernetes/server/bin/
    for i in k8s1 k8s2 k8s3;do ssh $i "mkdir -p /opt/bin";done
    for i in k8s1 k8s2 k8s3;do scp kube-apiserver kube-controller-manager kube-scheduler $i:/opt/bin/;done
    for i in k8s1 k8s2 k8s3;do scp kubelet kubectl kube-proxy $i:/opt/bin;done

创建 TLS Bootstrapping Token Token auth file Token可以是任意的包涵128
bit的字符串，可以使用安全的随机数发生器生成。

.. code:: bash

    export BOOTSTRAP_TOKEN=$(head -c 16 /dev/urandom | od -An -t x | tr -d ' ')
    cat > token.csv <<EOF
    ${BOOTSTRAP_TOKEN},kubelet-bootstrap,10001,"system:kubelet-bootstrap"
    EOF

后三行是一句，直接复制上面的脚本运行即可。
将token.csv发到所有机器（Master 和 Node）的 /etc/kubernetes/ 目录。

.. code:: bash

    for i in k8s1 k8s2 k8s3;do scp token.csv  $i:/etc/kubernetes;done

创建 Kubelet Bootstrapping Kubeconfig 文件
----------------------------------------------------------

.. code:: bash

    cd /etc/kubernetes
    export KUBE_APISERVER="https://192.168.127.94:6443"
    echo 'export PATH=$PATH:/opt/bin ' >> /etc/profile
    source /etc/profile
    # 设置集群参数
    kubectl config set-cluster kubernetes \
      --certificate-authority=/etc/kubernetes/ssl/ca.pem \
      --embed-certs=true \
      --server=${KUBE_APISERVER} \
      --kubeconfig=bootstrap.kubeconfig
    # 设置客户端认证参数
    kubectl config set-credentials kubelet-bootstrap \
      --token=${BOOTSTRAP_TOKEN} \
      --kubeconfig=bootstrap.kubeconfig
    # 设置上下文参数
    kubectl config set-context default \
      --cluster=kubernetes \
      --user=kubelet-bootstrap \
      --kubeconfig=bootstrap.kubeconfig
    # 设置默认上下文
    kubectl config use-context default --kubeconfig=bootstrap.kubeconfig

-  --embed-certs 为 true 时表示将 certificate-authority 证书写入到生成的
   bootstrap.kubeconfig 文件中；
-  设置客户端认证参数时没有指定秘钥和证书，后续由 kube-apiserver
   自动生成；
-  创建Kube-Proxy Kubeconfig 文件

.. code:: bash

    export KUBE_APISERVER="https://192.168.127.94:6443"
    # 设置集群参数
     kubectl config set-cluster kubernetes \
      --certificate-authority=/etc/kubernetes/ssl/ca.pem \
      --embed-certs=true \
      --server=${KUBE_APISERVER} \
      --kubeconfig=kube-proxy.kubeconfig
    # 设置客户端认证参数
    kubectl config set-credentials kube-proxy \
      --client-certificate=/etc/kubernetes/ssl/kube-proxy.pem \
      --client-key=/etc/kubernetes/ssl/kube-proxy-key.pem \
      --embed-certs=true \
      --kubeconfig=kube-proxy.kubeconfig
    # 设置上下文参数
    kubectl config set-context default \
      --cluster=kubernetes \
      --user=kube-proxy \
      --kubeconfig=kube-proxy.kubeconfig
    # 设置默认上下文
    kubectl config use-context default --kubeconfig=kube-proxy.kubeconfig

-  设置集群参数和客户端认证参数时 --embed-certs 都为 true，这会将
   certificate-authority、client-certificate 和 client-key
   指向的证书文件内容写入到生成的 kube-proxy.kubeconfig 文件中；
-  kube-proxy.pem 证书中 CN 为 system:kube-proxy，kube-apiserver
   预定义的 RoleBinding cluster-admin 将User system:kube-proxy 与 Role
   system:node-proxier 绑定，该 Role 授予了调用 kube-apiserver Proxy
   相关 API 的权限；

-  分发 Kubeconfig 文件 将两个 kubeconfig 文件分发到所有 Node 机器的
   /etc/kubernetes/ 目录

.. code:: bash

    for i in k8s1 k8s2 k8s3;do scp bootstrap.kubeconfig kube-proxy.kubeconfig  $i:/etc/kubernetes/;done

安装etcd服务
============

| **下载etcd**

etcd的github地址：https://github.com/coreos/etcd/releases

`这里我们下载3.1.10版本 <https://github.com/coreos/etcd/releases/download/v3.1.10/etcd-v3.1.10-linux-amd64.tar.gz>`__

.. code:: bash

    wget https://github.com/coreos/etcd/releases/download/v3.1.10/etcd-v3.1.10-linux-amd64.tar.gz

-  创建用于存放服务文件的的目录

.. code:: bash

    for i in k8s1 k8s2 k8s3;do ssh $i 'mkdir -p /opt/bin';done

-  解压etcd安装包到/tmp目录

.. code:: bash

    tar xf etcd-v3.1.10-linux-amd64.tar.gz -C /tmp/

-  将etcd的运行文件发到相应的服务器上去

.. code:: bash

    for i in k8s1 k8s2 k8s3;do scp /tmp/etcd-v3.1.10-linux-amd64/etcd* $i:/opt/bin/;done

-  定义服务器环境
-  以下配置在三台服务器上都做，ETCD\_NAME和IP分别写每台服务器自己的。

   .. code:: bash

       export ETCD_NAME=k8s1
       export INTERNAL_IP=192.168.127.94

-  | 创建相关目录

.. code-block:: bash

    for i in k8s1 k8s2 k8s3;do ssh $i 'mkdir -p /var/lib/etcd';done

- 创建启动启动脚本

.. code:: bash

    cat > /lib/systemd/system/etcd.service  <<EOF
    [Unit]
    Description=Etcd Server
    After=network.target
    After=network-online.target
    Wants=network-online.target
    Documentation=https://github.com/coreos

    [Service]
    Type=notify
    WorkingDirectory=/var/lib/etcd/
    EnvironmentFile=-/etc/etcd/etcd.conf
    ExecStart=/opt/bin/etcd \\
      --name ${ETCD_NAME} \\
      --cert-file=/etc/kubernetes/ssl/kubernetes.pem \\
      --key-file=/etc/kubernetes/ssl/kubernetes-key.pem \\
      --peer-cert-file=/etc/kubernetes/ssl/kubernetes.pem \\
      --peer-key-file=/etc/kubernetes/ssl/kubernetes-key.pem \\
      --trusted-ca-file=/etc/kubernetes/ssl/ca.pem \\
      --peer-trusted-ca-file=/etc/kubernetes/ssl/ca.pem \\
      --initial-advertise-peer-urls https://${INTERNAL_IP}:2380 \\
      --listen-peer-urls https://${INTERNAL_IP}:2380 \\
      --listen-client-urls https://${INTERNAL_IP}:2379,https://127.0.0.1:2379 \\
      --advertise-client-urls https://${INTERNAL_IP}:2379 \\
      --initial-cluster-token etcd-cluster-0 \\
      --initial-cluster k8s1=https://k8s1:2380,k8s2=https://k8s2:2380,k8s3=https://k8s3:2380 \\
      --initial-cluster-state new \\
      --data-dir=/var/lib/etcd
    Restart=on-failure
    RestartSec=5
    LimitNOFILE=65536

    [Install]
    WantedBy=multi-user.target
    EOF

-  重新加载服务并启动 三台服务器最后同时启动。
   如果有报错，修改配置后重新启动之前需要先删除旧的数据，否则会有影响 rm
   -rf /var/lib/etcd/\* 如果加如了saltstack，用salt来同时启动 salt
   'k8s\*' cmd.run 'systemctl start etcd'

   .. code:: bash

       systemctl daemon-reload
       systemctl enable etcd
       systemctl start etcd

-  在三台服务器都配置、启动好了etcd之后，我们可以来检查一下ETCD是否正常运行。

检查ETCD是否正常运行，在任一 kubernetes master 机器上执行如下命令：

.. code:: bash

    /opt/bin/etcdctl \
      --ca-file=/etc/kubernetes/ssl/ca.pem \
      --cert-file=/etc/kubernetes/ssl/kubernetes.pem \
      --key-file=/etc/kubernetes/ssl/kubernetes-key.pem \
     --endpoint=https://k8s1:2379  cluster-health

-  接下来要为k8s提供服务，这里我们尝试为k8s创建一个目录

.. code:: bash

    /opt/bin/etcdctl \
      --ca-file=/etc/kubernetes/ssl/ca.pem \
      --cert-file=/etc/kubernetes/ssl/kubernetes.pem \
      --key-file=/etc/kubernetes/ssl/kubernetes-key.pem \
      --endpoint=https://k8s1:2379,https://k8s2:2379,https://k8s3:2379 \
      mk /coreos.com/network/config '{"Network":"192.168.0.0/16", "Backend": {"Type": "vxlan"}}'

安装配置flanneld服务
====================

flannel的历史版本在这里 https://github.com/coreos/flannel/releases
这里我们下载的是0.8.0版本。

.. code:: bash

     wget https://github.com/coreos/flannel/releases/download/v0.8.0/flannel-v0.8.0-linux-amd64.tar.gz

-  解压包，并将flanneld传到指定的服务器指定目录

.. code:: bash

    tar xf flannel-v0.8.0-linux-amd64.tar.gz -C /tmp/
    cd /tmp/
    for i in k8s1 k8s2 k8s3;do scp flanneld $i:/opt/bin/;done

这里我们用systemd来管理flanneld，

.. code:: bash

    IFACE=192.168.127.94
    cat > /lib/systemd/system/flanneld.service << EOF
    [Unit]
    Description=Flanneld overlay address etcd agent
    After=network.target
    After=network-online.target
    Wants=network-online.target
    After=etcd.service
    Before=docker.service

    [Service]
    Type=notify
    ExecStart=/opt/bin/flanneld \\
      --etcd-endpoints="//k8s1:2379,https://k8s2:2379,https://k8s3:2379" \\
      --iface=$IFACE \\
       --etcd-cafile=/etc/kubernetes/ssl/ca.pem \\
      --ip-masq

    Restart=on-failure

    [Install]
    WantedBy=multi-user.target
    EOF

-  然后启动flannel。

.. code:: bash

    systemctl daemon-reload
    systemctl enable flanneld.service
    systemctl start flanneld.service

-  然后我们需要让docker的网段与flanneld的一样，执行下面的命令。

   .. code:: bash

       curl -s https://raw.githubusercontent.com/AlvinWanCN/poppy/master/code/shell/k8s/syncFlannelToDocker_k8s.sh|bash

安装k8s的master
=====================

编写配置文件
----------------------

-  公共配置文件


.. code:: bash

    vim /etc/kubernetes/config
    ###
    # kubernetes system config
    #
    # The following values are used to configure various aspects of all
    # kubernetes services, including
    #
    #   kube-apiserver.service
    #   kube-controller-manager.service
    #   kube-scheduler.service
    #   kubelet.service
    #   kube-proxy.service
    # logging to stderr means we get it in the systemd journal
    KUBE_LOGTOSTDERR="--logtostderr=true"

    # journal message level, 0 is debug
    KUBE_LOG_LEVEL="--v=0"

    # Should this cluster be allowed to run privileged docker containers
    KUBE_ALLOW_PRIV="--allow-privileged=false"

    # How the controller-manager, scheduler, and proxy find the apiserver
    KUBE_MASTER="--master=http://127.0.0.1:8080"

-  kube-apiserver的配置文件

.. code:: bash

    vim /etc/kubernetes/apiserver
    ###
    ## kubernetes system config
    ##
    ## The following values are used to configure the kube-apiserver
    ##
    #
    ## The address on the local server to listen to.
    #KUBE_API_ADDRESS="--insecure-bind-address=sz-pg-oam-docker-test-001.tendcloud.com"
    KUBE_API_ADDRESS="--advertise-address=192.168.127.94 --bind-address=192.168.127.94 --insecure-bind-address=127.0.0.1"
    #
    ## The port on the local server to listen on.
    #KUBE_API_PORT="--port=8080"
    #
    ## Port minions listen on
    #KUBELET_PORT="--kubelet-port=10250"
    #
    ## Comma separated list of nodes in the etcd cluster
    KUBE_ETCD_SERVERS="--etcd-servers=https://k8s1:2379,https://k8s2:2379,https://k8s3:2379"
    #
    ## Address range to use for services
    KUBE_SERVICE_ADDRESSES="--service-cluster-ip-range=172.18.0.0/16"
    #
    ## default admission control policies
    KUBE_ADMISSION_CONTROL="--admission-control=ServiceAccount,NamespaceLifecycle,NamespaceExists,LimitRanger,ResourceQuota"
    #
    ## Add your own!
    KUBE_API_ARGS="--authorization-mode=RBAC --runtime-config=rbac.authorization.k8s.io/v1beta1 --kubelet-https=true --token-auth-file=/etc/kubernetes/token.csv --service-node-port-range=30000-32767 --tls-cert-file=/etc/kubernetes/ssl/kubernetes.pem --tls-private-key-file=/etc/kubernetes/ssl/kubernetes-key.pem --client-ca-file=/etc/kubernetes/ssl/ca.pem --service-account-key-file=/etc/kubernetes/ssl/ca-key.pem --etcd-cafile=/etc/kubernetes/ssl/ca.pem --etcd-certfile=/etc/kubernetes/ssl/kubernetes.pem --etcd-keyfile=/etc/kubernetes/ssl/kubernetes-key.pem --enable-swagger-ui=true --apiserver-count=3 --audit-log-maxage=30 --audit-log-maxbackup=3 --audit-log-maxsize=100 --audit-log-path=/var/lib/audit.log --event-ttl=1h"

-  kube-apiserver的启动文件

.. code:: bash

    vim /lib/systemd/system/kube-apiserver.service
    [Unit]
    Description=Kubernetes API Server
    Documentation=https://github.com/GoogleCloudPlatform/kubernetes
    After=network.target
    After=etcd.service

    [Service]
    EnvironmentFile=-/etc/kubernetes/config
    EnvironmentFile=-/etc/kubernetes/apiserver
    User=root
    ExecStart=/opt/bin/kube-apiserver \
            $KUBE_LOGTOSTDERR \
            $KUBE_LOG_LEVEL \
            $KUBE_ETCD_SERVERS \
            $KUBE_API_ADDRESS \
            $KUBE_API_PORT \
            $KUBELET_PORT \
            $KUBE_ALLOW_PRIV \
            $KUBE_SERVICE_ADDRESSES \
            $KUBE_ADMISSION_CONTROL \
            $KUBE_API_ARGS
    Restart=on-failure
    Type=notify
    LimitNOFILE=65536

    [Install]
    WantedBy=multi-user.target

-  kube-controller-manager的配置文件

.. code:: bash

    vim /etc/kubernetes/controller-manager

    ###
    # The following values are used to configure the kubernetes controller-manager

    # defaults from config and apiserver should be adequate

    # Add your own!
    KUBE_CONTROLLER_MANAGER_ARGS="--allocate-node-cidrs=true --cluster-cidr=192.168.0.0/16  --service-cluster-ip-range=172.18.0.0/16 --cluster-signing-cert-file=/etc/kubernetes/ssl/ca.pem --cluster-signing-key-file=/etc/kubernetes/ssl/ca-key.pem --service-account-private-key-file=/etc/kubernetes/ssl/ca-key.pem --root-ca-file=/etc/kubernetes/ssl/ca.pem"

-  kube-controller-manager的启动文件

.. code:: bash

    vim /lib/systemd/system/kube-controller-manager.service
    [Unit]
    Description=Kubernetes Controller Manager
    Documentation=https://github.com/GoogleCloudPlatform/kubernetes

    [Service]
    EnvironmentFile=-/etc/kubernetes/config
    EnvironmentFile=-/etc/kubernetes/controller-manager
    User=root
    ExecStart=/opt/bin/kube-controller-manager \
            $KUBE_LOGTOSTDERR \
            $KUBE_LOG_LEVEL \
            $KUBE_MASTER \
            $KUBE_CONTROLLER_MANAGER_ARGS
    Restart=on-failure
    LimitNOFILE=65536

    [Install]
    WantedBy=multi-user.target

-  kube-scheduler的配置文件

.. code:: bash

    vim /etc/kubernetes/scheduler
    ###
    # kubernetes scheduler config

    # default config should be adequate

    # Add your own!
    KUBE_SCHEDULER_ARGS="--port=10251"

-  kube-scheduler的启动文件

.. code:: bash

    vim /lib/systemd/system/kube-scheduler.service
    [Unit]
    Description=Kubernetes Scheduler Plugin
    Documentation=https://github.com/GoogleCloudPlatform/kubernetes

    [Service]
    EnvironmentFile=-/etc/kubernetes/config
    EnvironmentFile=-/etc/kubernetes/scheduler
    User=root
    ExecStart=/opt/bin/kube-scheduler \
            $KUBE_LOGTOSTDERR \
            $KUBE_LOG_LEVEL \
            $KUBE_MASTER \
            $KUBE_SCHEDULER_ARGS
    Restart=on-failure
    LimitNOFILE=65536

    [Install]
    WantedBy=multi-user.target

启动服务
----------------

::

    systemctl daemon-reload
    systemctl enable kube-apiserver
    systemctl enable kube-controller-manager
    systemctl enable kube-scheduler

    systemctl start kube-apiserver
    systemctl start kube-controller-manager
    systemctl start kube-scheduler

-  确认各个组件的状态是否都是正常运行。

.. code:: bash

    root@k8s1:~# kubectl get cs
    NAME                 STATUS    MESSAGE              ERROR
    scheduler            Healthy   ok
    controller-manager   Healthy   ok
    etcd-1               Healthy   {"health": "true"}
    etcd-0               Healthy   {"health": "true"}
    etcd-2               Healthy   {"health": "true"

安装k8s的node
=============

-  角色绑定

现在要去master上做角色绑定
------------------------------------

.. code:: bash

    kubectl create clusterrolebinding kubelet-bootstrap --clusterrole=system:node-bootstrapper --user=kubelet-bootstrap

-  编写公共配置文件

.. code:: bash

    vim /etc/kubernetes/config
    # logging to stderr means we get it in the systemd journal
    KUBE_LOGTOSTDERR="--logtostderr=true"

    # journal message level, 0 is debug
    KUBE_LOG_LEVEL="--v=0"

    # Should this cluster be allowed to run privileged docker containers
    KUBE_ALLOW_PRIV="--allow-privileged=true"

    # How the controller-manager, scheduler, and proxy find the apiserver
    KUBE_MASTER="--master=https://k8s1:6443"

-  编写kubelet的配置文件

不同的node上在IP和NAME上都写自己的。
---------------------------------------------

.. code:: bash

    cat > /etc/kubernetes/kubelet <<EOF
    ###
    # kubernetes kubelet (minion) config

    # The address for the info server to serve on (set to 0.0.0.0 or "" for all interfaces)
    KUBELET_ADDRESS="--address=0.0.0.0"

    # The port for the info server to serve on
    # KUBELET_PORT="--port=10250"

    # You may leave this blank to use the actual hostname
    KUBELET_HOSTNAME="--hostname-override=k8s2"

    # location of the api-server
    #KUBELET_API_SERVER="--api-servers=http://192.168.127.94:8080"

    # pod infrastructure container
    # KUBELET_POD_INFRA_CONTAINER="--pod-infra-container-image=registry.access.redhat.com/rhel7/pod-infrastructure:latest"

    # Add your own!
    KUBELET_ARGS=" --cluster-dns=172.18.8.8 --cluster-domain=cluster.local --experimental-bootstrap-kubeconfig=/etc/kubernetes/bootstrap.kubeconfig --kubeconfig=/etc/kubernetes/kubelet.kubeconfig --cert-dir=/etc/kubernetes/ssl --cgroup-driver=systemd"
    EOF

-  创建一个kubelet的目录

.. code:: bash

    mkdir -p /var/lib/kubelet

-  编写kubelet服务启动文件

.. code:: bash

    echo '
    [Unit]
    Description=Kubernetes Kubelet Server
    Documentation=https://github.com/GoogleCloudPlatform/kubernetes
    After=docker.service
    Requires=docker.service

    [Service]
    WorkingDirectory=/var/lib/kubelet
    EnvironmentFile=-/etc/kubernetes/config
    EnvironmentFile=-/etc/kubernetes/kubelet
    ExecStart=/opt/bin/kubelet \
            $KUBE_LOGTOSTDERR \
            $KUBE_LOG_LEVEL \
            $KUBELET_ADDRESS \
            $KUBELET_HOSTNAME \
            $KUBE_ALLOW_PRIV \
            $KUBELET_ARGS
    Restart=on-failure

    [Install]
    WantedBy=multi-user.target
    ' > /lib/systemd/system/kubelet.service

-  编写kube-proxy的配置文件

.. code:: bash

    echo '
    # kubernetes proxy config
    # default config should be adequate
    # Add your own!
    KUBE_PROXY_ARGS="--bind-address=192.168.127.95 --hostname-override=k8s2 --proxy-mode=iptables --cluster-cidr=172.18.0.0/16 --kubeconfig=/etc/kubernetes/kube-proxy.kubeconfig
    ' > /etc/kubernetes/proxy

-  编写kube-proxy启动文件

.. code:: bash

    echo '
    [Unit]
    Description=Kubernetes Kube-Proxy Server
    Documentation=https://github.com/GoogleCloudPlatform/kubernetes
    After=network.target

    [Service]
    EnvironmentFile=-/etc/kubernetes/config
    EnvironmentFile=-/etc/kubernetes/proxy
    ExecStart=/opt/bin/kube-proxy \
            $KUBE_LOGTOSTDERR \
            $KUBE_LOG_LEVEL \
            $KUBE_MASTER \
            $KUBE_HOSTNAME \
            $KUBE_PROXY_ARGS
    Restart=on-failure
    LimitNOFILE=65536

    [Install]
    WantedBy=multi-user.target
    ' > /lib/systemd/system/kube-proxy.service

-  启动kubelet

.. code:: bash

    systemctl daemon-reload
    systemctl start kubelet

-  做完上面的这一操作，要去maser上授权这个kubelet访问

做完这一步要去master节点上授权 下面是示例

.. code:: bash

    root@k8s1:~# kubectl get csr
    NAME        AGE       REQUESTOR           CONDITION
    csr-qdn47   14s       kubelet-bootstrap   Pending
    root@k8s1:~# kubectl certificate approve csr-qdn47
    certificatesigningrequest "csr-qdn47" approved
    root@k8s1:~# kubectl get node
    NAME      STATUS    AGE       VERSION
    k8s2        Ready     30s       v1.6.2

    #然后kubelet 那边就注册成功了。

-  然后启动kube-proxy

.. code:: bash

    systemctl start kube-proxy

安装dns
=======

-  创建configmap配置文件

.. code:: yaml

    echo '
    # Copyright 2016 The Kubernetes Authors.
    #
    # Licensed under the Apache License, Version 2.0 (the "License");
    # you may not use this file except in compliance with the License.
    # You may obtain a copy of the License at
    #
    #     http://www.apache.org/licenses/LICENSE-2.0
    #
    # Unless required by applicable law or agreed to in writing, software
    # distributed under the License is distributed on an "AS IS" BASIS,
    # WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    # See the License for the specific language governing permissions and
    # limitations under the License.

    apiVersion: v1
    kind: ConfigMap
    metadata:
      name: kube-dns
      namespace: kube-system
      labels:
        addonmanager.kubernetes.io/mode: EnsureExists
    ' > kubedns-cm.yaml

-  创建kubedns-sa.yaml

.. code:: yaml

    echo '

    apiVersion: v1
    kind: ServiceAccount
    metadata:
      name: kube-dns
      namespace: kube-system
      labels:
        kubernetes.io/cluster-service: "true"
        addonmanager.kubernetes.io/mode: Reconcile
    ' > kubedns-sa.yaml

-  创建kubedns-svc.yaml

.. code:: yaml

    echo '
    # Copyright 2016 The Kubernetes Authors.
    #
    # Licensed under the Apache License, Version 2.0 (the "License");
    # you may not use this file except in compliance with the License.
    # You may obtain a copy of the License at
    #
    #     http://www.apache.org/licenses/LICENSE-2.0
    #
    # Unless required by applicable law or agreed to in writing, software
    # distributed under the License is distributed on an "AS IS" BASIS,
    # WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    # See the License for the specific language governing permissions and
    # limitations under the License.

    # __MACHINE_GENERATED_WARNING__

    apiVersion: v1
    kind: Service
    metadata:
      name: kube-dns
      namespace: kube-system
      labels:
        k8s-app: kube-dns
        kubernetes.io/cluster-service: "true"
        addonmanager.kubernetes.io/mode: Reconcile
        kubernetes.io/name: "KubeDNS"
    spec:
      selector:
        k8s-app: kube-dns
      clusterIP: 172.18.8.8
      ports:
      - name: dns
        port: 53
        protocol: UDP
      - name: dns-tcp
        port: 53
        protocol: TCP
    ' > kubedns-svc.yaml

**这个里面注意clusterIP和kubelet里面配置的保持一致即可** -
创建kubedns-controller.yaml

.. code:: yaml

    echo '
    # Copyright 2016 The Kubernetes Authors.
    #
    # Licensed under the Apache License, Version 2.0 (the "License");
    # you may not use this file except in compliance with the License.
    # You may obtain a copy of the License at
    #
    #     http://www.apache.org/licenses/LICENSE-2.0
    #
    # Unless required by applicable law or agreed to in writing, software
    # distributed under the License is distributed on an "AS IS" BASIS,
    # WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    # See the License for the specific language governing permissions and
    # limitations under the License.

    # Should keep target in cluster/addons/dns-horizontal-autoscaler/dns-horizontal-autoscaler.yaml
    # in sync with this file.

    # __MACHINE_GENERATED_WARNING__

    apiVersion: extensions/v1beta1
    kind: Deployment
    metadata:
      name: kube-dns
      namespace: kube-system
      labels:
        k8s-app: kube-dns
        kubernetes.io/cluster-service: "true"
        addonmanager.kubernetes.io/mode: Reconcile
    spec:
      # replicas: not specified here:
      # 1. In order to make Addon Manager do not reconcile this replicas parameter.
      # 2. Default is 1.
      # 3. Will be tuned in real time if DNS horizontal auto-scaling is turned on.
      strategy:
        rollingUpdate:
          maxSurge: 10%
          maxUnavailable: 0
      selector:
        matchLabels:
          k8s-app: kube-dns
      template:
        metadata:
          labels:
            k8s-app: kube-dns
          annotations:
            scheduler.alpha.kubernetes.io/critical-pod: ''
        spec:
          tolerations:
          - key: "CriticalAddonsOnly"
            operator: "Exists"
          volumes:
          - name: kube-dns-config
            configMap:
              name: kube-dns
              optional: true
          containers:
          - name: kubedns
            image: gcr.io/google_containers/k8s-dns-kube-dns-amd64:1.14.1
            resources:
              # TODO: Set memory limits when we've profiled the container for large
              # clusters, then set request = limit to keep this container in
              # guaranteed class. Currently, this container falls into the
              # "burstable" category so the kubelet doesn't backoff from restarting it.
              limits:
                memory: 170Mi
              requests:
                cpu: 100m
                memory: 70Mi
            livenessProbe:
              httpGet:
                path: /healthcheck/kubedns
                port: 10054
                scheme: HTTP
              initialDelaySeconds: 60
              timeoutSeconds: 5
              successThreshold: 1
              failureThreshold: 5
            readinessProbe:
              httpGet:
                path: /readiness
                port: 8081
                scheme: HTTP
              # we poll on pod startup for the Kubernetes master service and
              # only setup the /readiness HTTP server once that's available.
              initialDelaySeconds: 3
              timeoutSeconds: 5
            args:
            - --domain=cluster.local.
            - --dns-port=10053
            - --config-dir=/kube-dns-config
            - --v=2
            env:
            - name: PROMETHEUS_PORT
              value: "10055"
            ports:
            - containerPort: 10053
              name: dns-local
              protocol: UDP
            - containerPort: 10053
              name: dns-tcp-local
              protocol: TCP
            - containerPort: 10055
              name: metrics
              protocol: TCP
            volumeMounts:
            - name: kube-dns-config
              mountPath: /kube-dns-config
          - name: dnsmasq
            image: gcr.io/google_containers/k8s-dns-dnsmasq-nanny-amd64:1.14.1
            livenessProbe:
              httpGet:
                path: /healthcheck/dnsmasq
                port: 10054
                scheme: HTTP
              initialDelaySeconds: 60
              timeoutSeconds: 5
              successThreshold: 1
              failureThreshold: 5
            args:
            - -v=2
            - -logtostderr
            - -configDir=/etc/k8s/dns/dnsmasq-nanny
            - -restartDnsmasq=true
            - --
            - -k
            - --cache-size=1000
            - --log-facility=-
            - --server=/cluster.local./127.0.0.1#10053
            - --server=/in-addr.arpa/127.0.0.1#10053
            - --server=/ip6.arpa/127.0.0.1#10053
            ports:
            - containerPort: 53
              name: dns
              protocol: UDP
            - containerPort: 53
              name: dns-tcp
              protocol: TCP
            # see: https://github.com/kubernetes/kubernetes/issues/29055 for details
            resources:
              requests:
                cpu: 150m
                memory: 20Mi
            volumeMounts:
            - name: kube-dns-config
              mountPath: /etc/k8s/dns/dnsmasq-nanny
          - name: sidecar
            image: gcr.io/google_containers/k8s-dns-sidecar-amd64:1.14.1
            livenessProbe:
              httpGet:
                path: /metrics
                port: 10054
                scheme: HTTP
              initialDelaySeconds: 60
              timeoutSeconds: 5
              successThreshold: 1
              failureThreshold: 5
            args:
            - --v=2
            - --logtostderr
            - --probe=kubedns,127.0.0.1:10053,kubernetes.default.svc.cluster.local.,5,A
            - --probe=dnsmasq,127.0.0.1:53,kubernetes.default.svc.cluster.local.,5,A
            ports:
            - containerPort: 10054
              name: metrics
              protocol: TCP
            resources:
              requests:
                memory: 20Mi
                cpu: 10m
          dnsPolicy: Default  # Don't use cluster DNS.
          serviceAccountName: kube-dns
    ' > kubedns-controller.yaml

-  然后通过kubectl逐一创建就行，也可以放到一个目录下面，kubectl create
   -f .批量创建。

.. code:: bash

    kubectl create -f kubedns-cm.yaml
    kubectl create -f kubedns-sa.yaml
    kubectl create -f kubedns-svc.yaml
    kubectl create -f kubedns-controller.yaml

-  然后验证 起一个pod通过dns验证

.. code-block:: bash

    vim busybox.yaml
    apiVersion: v1
    kind: Pod
    metadata:
      name: busybox
      namespace: default
    spec:
      containers:
      - image: busybox
        command:
          - sleep
          - "3600"
        imagePullPolicy: IfNotPresent
        name: busybox
      restartPolicy: Always


 - 创建busybox

::

    kubectl create -f busybox.yaml

 创建完成之后exec到容器内，执行nslookup kubernetes看能否解析到IP


安装Heapster,dashboard,influxDB,grafana
===================================================

创建heapster-deployment.yaml


-  创建heapster-deployment.yaml

.. code:: yaml

    vim heapster-deployment.yaml

    apiVersionheapster-deployment.yaml
    : extensions/v1beta1
    kind: Deployment
    metadata:
      name: heapster
      namespace: kube-system
    spec:
      replicas: 1
      template:
        metadata:
          labels:
            task: monitoring
            k8s-app: heapster
        spec:
          serviceAccountName: heapster
          containers:
          - name: heapster
            image: gcr.io/google_containers/heapster-amd64:v1.3.0
            imagePullPolicy: IfNotPresent
            command:
            - /heapster
            - --source=kubernetes:https://kubernetes.default
            - --sink=influxdb:http://monitoring-influxdb:8086

这个里面source是从kubernetes获取监控对象信息，sink制定数据存储的路径，通过influxdb的api保存数据。上面serviceAccountName是1.6后的rbac准备的。

-  创建heapster-rbac.yaml

.. code-block:: bash

    vim heapster-rbac.yaml

    iVersion: v1
    kind: ServiceAccount
    metadata:
      name: heapster
      namespace: kube-system

    ---

    kind: ClusterRoleBinding
    apiVersion: rbac.authorization.k8s.io/v1alpha1
    metadata:
      name: heapster
    subjects:
      - kind: ServiceAccount
        name: heapster
        namespace: kube-system
    roleRef:
      kind: ClusterRole
      name: system:heapster
      apiGroup: rbac.authorization.k8s.io


.. code:: yaml

    vim heapster-service.yaml
    apiVersion: v1
    kind: Service
    metadata:
      labels:
        task: monitoring
        # For use as a Cluster add-on (https://github.com/kubernetes/kubernetes/tree/master/cluster/addons)
        # If you are NOT using this as an addon, you should comment out this line.
        kubernetes.io/cluster-service: 'true'
        kubernetes.io/name: Heapster
      name: heapster
      namespace: kube-system
    spec:
      ports:
      - port: 80
        targetPort: 8082
      selector:
        k8s-app: heapster

因为dashboard需要访问heapster，所以这里配置service。紧接着是数据库influxdb，先定义配置文件，通过configmap挂载到容器里面。
- 创建influxdb-cm.yaml

.. code:: yaml

    vim influxdb-cm.yaml

    apiVersion: v1
    kind: ConfigMap
    metadata:
      name: influxdb-config
      namespace: kube-system
    data:
      config.toml: |
        reporting-disabled = true
        bind-address = ":8088"

        [meta]
          dir = "/data/meta"
          retention-autocreate = true
          logging-enabled = true

        [data]
          dir = "/data/data"
          wal-dir = "/data/wal"
          query-log-enabled = true
          cache-max-memory-size = 1073741824
          cache-snapshot-memory-size = 26214400
          cache-snapshot-write-cold-duration = "10m0s"
          compact-full-write-cold-duration = "4h0m0s"
          max-series-per-database = 1000000
          max-values-per-tag = 100000
          trace-logging-enabled = false

        [coordinator]
          write-timeout = "10s"
          max-concurrent-queries = 0
          query-timeout = "0s"
          log-queries-after = "0s"
          max-select-point = 0
          max-select-series = 0
          max-select-buckets = 0

        [retention]
          enabled = true
          check-interval = "30m0s"

        [admin]
          enabled = true
          bind-address = ":8083"
          https-enabled = false
          https-certificate = "/etc/ssl/influxdb.pem"

        [shard-precreation]
          enabled = true
          check-interval = "10m0s"
          advance-period = "30m0s"

        [monitor]
          store-enabled = true
          store-database = "_internal"
          store-interval = "10s"

        [subscriber]
          enabled = true
          http-timeout = "30s"
          insecure-skip-verify = false
          ca-certs = ""
          write-concurrency = 40
          write-buffer-size = 1000

        [http]
          enabled = true
          bind-address = ":8086"
          auth-enabled = false
          log-enabled = true
          write-tracing = false
          pprof-enabled = false
          https-enabled = false
          https-certificate = "/etc/ssl/influxdb.pem"
          https-private-key = ""
          max-row-limit = 10000
          max-connection-limit = 0
          shared-secret = ""
          realm = "InfluxDB"
          unix-socket-enabled = false
          bind-socket = "/var/run/influxdb.sock"

        [[graphite]]
          enabled = false
          bind-address = ":2003"
          database = "graphite"
          retention-policy = ""
          protocol = "tcp"
          batch-size = 5000
          batch-pending = 10
          batch-timeout = "1s"
          consistency-level = "one"
          separator = "."
          udp-read-buffer = 0

        [[collectd]]
          enabled = false
          bind-address = ":25826"
          database = "collectd"
          retention-policy = ""
          batch-size = 5000
          batch-pending = 10
          batch-timeout = "10s"
          read-buffer = 0
          typesdb = "/usr/share/collectd/types.db"

        [[opentsdb]]
          enabled = false
          bind-address = ":4242"
          database = "opentsdb"
          retention-policy = ""
          consistency-level = "one"
          tls-enabled = false
          certificate = "/etc/ssl/influxdb.pem"
          batch-size = 1000
          batch-pending = 5
          batch-timeout = "1s"
          log-point-errors = true

        [[udp]]
          enabled = false
          bind-address = ":8089"
          database = "udp"
          retention-policy = ""
          batch-size = 5000
          batch-pending = 10
          read-buffer = 0
          batch-timeout = "1s"
          precision = ""

        [continuous_queries]
          log-enabled = true
          enabled = true
          run-interval = "1s"

-  创建influxdb-deployment.yaml 这个里使用上面的配置文件

.. code:: yaml

    vim influxdb-deployment.yaml

    apiVersion: extensions/v1beta1
    kind: Deployment
    metadata:
      name: monitoring-influxdb
      namespace: kube-system
    spec:
      replicas: 1
      template:
        metadata:
          labels:
            task: monitoring
            k8s-app: influxdb
        spec:
          containers:
          - name: influxdb
            image: gcr.io/google_containers/heapster-influxdb-amd64:v1.1.1
            volumeMounts:
            - mountPath: /data
              name: influxdb-storage
            - mountPath: /etc/
              name: influxdb-config
          volumes:
          - name: influxdb-storage
            emptyDir: {}
          - name: influxdb-config
            configMap:
              name: influxdb-config

-  创建influxdb服务，创建一个influxdb-service.yaml文件

.. code:: yaml

    vim influxdb-service.yaml

    apiVersion: v1
    kind: Service
    metadata:
      labels:
        task: monitoring
        # For use as a Cluster add-on (https://github.com/kubernetes/kubernetes/tree/master/cluster/addons)
        # If you are NOT using this as an addon, you should comment out this line.
        kubernetes.io/cluster-service: 'true'
        kubernetes.io/name: monitoring-influxdb
      name: monitoring-influxdb
      namespace: kube-system
    spec:
      type: NodePort
      ports:
      - port: 8086
        targetPort: 8086
        name: http
      - port: 8083
        targetPort: 8083
        name: admin
      selector:
        k8s-app: influxdb

通过heapster服务地址就可以获取监控数据了。
dashboard的安装也是通过yaml文件，设计到调用kubernetes接口权限问题，所以也是一样先授权
- 创建dashboard-rbac.yaml

.. code:: yaml

    vim dashboard-rbac.yaml

    apiVersion: v1
    kind: ServiceAccount
    metadata:
      name: dashboard
      namespace: kube-system

    ---

    kind: ClusterRoleBinding
    apiVersion: rbac.authorization.k8s.io/v1alpha1
    metadata:
      name: dashboard
    subjects:
      - kind: ServiceAccount
        name: dashboard
        namespace: kube-system
    roleRef:
      kind: ClusterRole
      name: cluster-admin
      apiGroup: rbac.authorization.k8s.io

  配置了cluster-admin最高访问权限 - 创建dashboard-controller.yaml

.. code:: yaml

    vim dashboard-controller.yaml

    apiVersion: extensions/v1beta1
    kind: Deployment
    metadata:
      name: kubernetes-dashboard
      namespace: kube-system
      labels:
        k8s-app: kubernetes-dashboard
        kubernetes.io/cluster-service: "true"
        addonmanager.kubernetes.io/mode: Reconcile
    spec:
      selector:
        matchLabels:
          k8s-app: kubernetes-dashboard
      template:
        metadata:
          labels:
            k8s-app: kubernetes-dashboard
          annotations:
            scheduler.alpha.kubernetes.io/critical-pod: ''
        spec:
          serviceAccountName: dashboard
          containers:
          - name: kubernetes-dashboard
            image: gcr.io/google_containers/kubernetes-dashboard-amd64:v1.6.1
            imagePullPolicy: IfNotPresent
            resources:
              # keep request = limit to keep this container in guaranteed class
              limits:
                cpu: 100m
                memory: 50Mi
              requests:
                cpu: 100m
                memory: 50Mi
            ports:
            - containerPort: 9090
            livenessProbe:
              httpGet:
                path: /
                port: 9090
              initialDelaySeconds: 30
              timeoutSeconds: 30
          tolerations:
          - key: "CriticalAddonsOnly"
            operator: "Exists"

配置从外部访问服务需要用到的service - 创建dashboard-service.yaml

.. code:: yaml

    vim dashboard-service.yaml

    piVersion: v1
    kind: Service
    metadata:
      name: kubernetes-dashboard
      namespace: kube-system
      labels:
        k8s-app: kubernetes-dashboard
        kubernetes.io/cluster-service: "true"
        addonmanager.kubernetes.io/mode: Reconcile
    spec:
      type: NodePort
      selector:
        k8s-app: kubernetes-dashboard
      ports:
      - port: 80
        targetPort: 9090

这里为了从外部访问所以设置NodePort。这样dashboard就可以访问了。

.. code:: bash

    kubectl get svc --namespace=kube-system

那么就可以通过任意计算节点+端口31508访问服务了

-  然后我们开始安装grafana
-  创建grafana.yaml

.. code:: yaml

    vim grafana.yaml

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
    #      nodeName: uat1
          containers:
          - name: grafana
            image: gcr.io/google_containers/heapster-grafana-amd64:v4.0.2
            ports:
            - containerPort: 3000
              protocol: TCP
            volumeMounts:
            - mountPath: /var
              name: grafana-storage
            - mountPath: /var/lib/grafana
              name: lib-grafana
    #        - name: run
    #          mountPath: /run.sh
            env:
            - name: INFLUXDB_HOST
              value: monitoring-influxdb
            - name: GF_SERVER_HTTP_PORT
              value: "3000"
              # The following env variables are required to make Grafana accessible via
              # the kubernetes api-server proxy. On production clusters, we recommend
              # removing these env variables, setup auth for grafana, and expose the grafana
              # service using a LoadBalancer or a public IP.
    #        - name: GF_AUTH_BASIC_ENABLED
    #          value: "false"
            - name: GF_AUTH_ANONYMOUS_ENABLED
              value: "true"
            - name: GF_AUTH_ANONYMOUS_ORG_ROLE
              value: Admin
            - name: GF_SERVER_ROOT_URL
              # If you're only using the API Server proxy, set this value instead:
              # value: /api/v1/proxy/namespaces/kube-system/services/monitoring-grafana/
              value: /
            - name: GF_SMTP_ENABLED
              value: "true"
            - name: GF_SMTP_SKIP_VERIFY
              value: "true"
            - name: GF_SMTP_HOST
              value: "smtp.exmail.qq.com:465"
            - name: GF_SMTP_USER
              value: "admin@shenmintech.com"
            - name: GF_SMTP_PASSWORD
              value: "xxxxxxx"
            - name: GF_SMTP_FROM_ADDRESS
              value: "admin@shenmintech.com"
            - name: GF_SERVER_DOMAIN
              value: "uat.shenmintech.com"
            - name: GF_SERVER_ROOT_URL
              value: "%(protocol)s://%(domain)s:30110/"
            - name: GF_AUTH_GRAFANANET_HOSTED_DOMAIN
              value: "uat.shenmintech.com"
            - name: GF_AUTH_ANONYMOUS_ENABLED
              value: "false"
    #        - name: GF_AUTH_GENERIC_OAUTH_ALLOWED_DOMAINS
    #          value: "test3.shenmin.com"
    #        - name: GF_AUTH_GENERIC_OAUTH_HOSTED_DOMAIN
    #          value: "test3.shenmin.com"
    #        - name: GF_AUTH_GOOGLE_HOSTED_DOMAIN
    #          value: "test3.shenmin.com"
    #        - name: GF_AUTH_GOOGLE_ALLOWED_DOMAINS
    #          value: "test3.shenmin.com"
    #        - name: GF_AUTH_GRAFANANET_ALLOWED_DOMAINS
    #          value: "test3.shenmin.com"
    #        - name: GF_AUTH_GRAFANANET_HOSTED_DOMAIN
    #          value: "test3.shenmin.com"
          volumes:
          - name: grafana-storage
            emptyDir: {}
          - name: lib-grafana
            hostPath:
              path: /data/k8s_pods_config/lib_grafana
    #      - name: run
    #        hostPath:
    #          path: /docker/grafana/run.sh

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
      type: NodePort
      ports:
      - port: 80
        targetPort: 3000
        nodePort: 30110
    #  clusterIP: 172.18.12.200
      selector:
        k8s-app: grafana

然后创建

.. code:: bash

    kubectl create -f heapster-deployment.yaml
    kubectl create -f heapster-rbac.yaml
    kubectl create -f heapster-service.yaml
    kubectl create -f influxdb-cm.yaml
    kubectl create -f influxdb-deployment.yaml
    kubectl create -f influxdb-service.yaml
    kubectl create -f dashboard-rbac.yaml
    kubectl create -f dashboard-controller.yaml
    kubectl create -f dashboard-service.yaml
    kubectl create -f grafana.yaml

