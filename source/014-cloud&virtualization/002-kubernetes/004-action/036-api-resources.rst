api-resources
##########################################


查看帮助
==========

.. code-block:: bash

    [root@k8s1 ~]# kubectl api-resources --help
    Print the supported API resources on the server

    Examples:
      # Print the supported API Resources
      kubectl api-resources

      # Print the supported API Resources with more information
      kubectl api-resources -o wide

      # Print the supported namespaced resources
      kubectl api-resources --namespaced=true

      # Print the supported non-namespaced resources
      kubectl api-resources --namespaced=false

      # Print the supported API Resources with specific APIGroup
      kubectl api-resources --api-group=extensions

    Options:
          --api-group='': Limit to resources in the specified API group.
          --cached=false: Use the cached list of resources if available.
          --namespaced=true: If false, non-namespaced resources will be returned, otherwise returning namespaced resources
    by default.
          --no-headers=false: When using the default or custom-column output format, don't print headers (default print
    headers).
      -o, --output='': Output format. One of: wide|name.
          --verbs=[]: Limit to resources that support the specified verbs.

    Usage:
      kubectl api-resources [flags] [options]

    Use "kubectl options" for a list of global command-line options (applies to all commands).



查看支持的api资源
======================

.. code-block:: bash

    [root@k8s1 ~]# kubectl api-resources
    NAME                              SHORTNAMES   APIGROUP                       NAMESPACED   KIND
    bindings                                                                      true         Binding
    componentstatuses                 cs                                          false        ComponentStatus
    configmaps                        cm                                          true         ConfigMap
    endpoints                         ep                                          true         Endpoints
    events                            ev                                          true         Event
    limitranges                       limits                                      true         LimitRange
    namespaces                        ns                                          false        Namespace
    nodes                             no                                          false        Node
    persistentvolumeclaims            pvc                                         true         PersistentVolumeClaim
    persistentvolumes                 pv                                          false        PersistentVolume
    pods                              po                                          true         Pod
    podtemplates                                                                  true         PodTemplate
    replicationcontrollers            rc                                          true         ReplicationController
    resourcequotas                    quota                                       true         ResourceQuota
    secrets                                                                       true         Secret
    serviceaccounts                   sa                                          true         ServiceAccount
    services                          svc                                         true         Service
    mutatingwebhookconfigurations                  admissionregistration.k8s.io   false        MutatingWebhookConfiguration
    validatingwebhookconfigurations                admissionregistration.k8s.io   false        ValidatingWebhookConfiguration
    customresourcedefinitions         crd,crds     apiextensions.k8s.io           false        CustomResourceDefinition
    apiservices                                    apiregistration.k8s.io         false        APIService
    controllerrevisions                            apps                           true         ControllerRevision
    daemonsets                        ds           apps                           true         DaemonSet
    deployments                       deploy       apps                           true         Deployment
    replicasets                       rs           apps                           true         ReplicaSet
    statefulsets                      sts          apps                           true         StatefulSet
    tokenreviews                                   authentication.k8s.io          false        TokenReview
    localsubjectaccessreviews                      authorization.k8s.io           true         LocalSubjectAccessReview
    selfsubjectaccessreviews                       authorization.k8s.io           false        SelfSubjectAccessReview
    selfsubjectrulesreviews                        authorization.k8s.io           false        SelfSubjectRulesReview
    subjectaccessreviews                           authorization.k8s.io           false        SubjectAccessReview
    horizontalpodautoscalers          hpa          autoscaling                    true         HorizontalPodAutoscaler
    cronjobs                          cj           batch                          true         CronJob
    jobs                                           batch                          true         Job
    certificatesigningrequests        csr          certificates.k8s.io            false        CertificateSigningRequest
    events                            ev           events.k8s.io                  true         Event
    daemonsets                        ds           extensions                     true         DaemonSet
    deployments                       deploy       extensions                     true         Deployment
    ingresses                         ing          extensions                     true         Ingress
    networkpolicies                   netpol       extensions                     true         NetworkPolicy
    podsecuritypolicies               psp          extensions                     false        PodSecurityPolicy
    replicasets                       rs           extensions                     true         ReplicaSet
    networkpolicies                   netpol       networking.k8s.io              true         NetworkPolicy
    poddisruptionbudgets              pdb          policy                         true         PodDisruptionBudget
    podsecuritypolicies               psp          policy                         false        PodSecurityPolicy
    clusterrolebindings                            rbac.authorization.k8s.io      false        ClusterRoleBinding
    clusterroles                                   rbac.authorization.k8s.io      false        ClusterRole
    rolebindings                                   rbac.authorization.k8s.io      true         RoleBinding
    roles                                          rbac.authorization.k8s.io      true         Role
    priorityclasses                   pc           scheduling.k8s.io              false        PriorityClass
    storageclasses                    sc           storage.k8s.io                 false        StorageClass
    volumeattachments                              storage.k8s.io                 false        VolumeAttachment
