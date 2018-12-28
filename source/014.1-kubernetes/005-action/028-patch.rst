patch
################


使用（patch）补丁修改、更新资源的字段。

支持JSON和YAML格式。

请参阅https://htmlpreview.github.io/?https://github.com/kubernetes/kubernetes/blob/HEAD/docs/api-reference/v1/definitions.html中说明，查找资源字段是否为可变的。

语法
=====

::

    patch (-f FILENAME | TYPE NAME) -p PATCH

示例
=====


使用patch更新Node节点。

::

    kubectl patch node k8s-node-1 -p '{"spec":{"unschedulable":true}}'

使用patch更新由“node.json”文件中指定的类型和名称标识的节点

::

    kubectl patch -f node.json -p '{"spec":{"unschedulable":true}}'

更新容器的镜像

::

    kubectl patch pod valid-pod -p '{"spec":{"containers":[{"name":"kubernetes-serve-hostname","image":"new image"}]}}'
    kubectl patch pod valid-pod --type='json' -p='[{"op": "replace", "path": "/spec/containers/0/image", "value":"new image"}]'
    kubectl patch node k8s-node-1 -p '{"spec":{"unschedulable":true}}'



