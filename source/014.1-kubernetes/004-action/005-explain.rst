explain
#############

我们可以通过编写一个yaml的配置清单来创建一个内容丰富的对象，而各种对象的都有些什么字段呢？ 也就是都有哪些属性呢？我们可以通过explain来查看



查看pod有哪些字段
========================

::

    [alvin@k8s1 ~]$ kubectl explain pods
    KIND:     Pod
    VERSION:  v1

    DESCRIPTION:
         Pod is a collection of containers that can run on a host. This resource is
         created by clients and scheduled onto hosts.

    FIELDS:
       apiVersion	<string>
         APIVersion defines the versioned schema of this representation of an
         object. Servers should convert recognized schemas to the latest internal
         value, and may reject unrecognized values. More info:
         https://git.k8s.io/community/contributors/devel/api-conventions.md#resources

       kind	<string>
         Kind is a string value representing the REST resource this object
         represents. Servers may infer this from the endpoint the client submits
         requests to. Cannot be updated. In CamelCase. More info:
         https://git.k8s.io/community/contributors/devel/api-conventions.md#types-kinds

       metadata	<Object>
         Standard object's metadata. More info:
         https://git.k8s.io/community/contributors/devel/api-conventions.md#metadata

       spec	<Object>
         Specification of the desired behavior of the pod. More info:
         https://git.k8s.io/community/contributors/devel/api-conventions.md#spec-and-status

       status	<Object>
         Most recently observed status of the pod. This data may not be up to date.
         Populated by the system. Read-only. More info:
         https://git.k8s.io/community/contributors/devel/api-conventions.md#spec-and-status


查看pod下的metadata有哪些字段
==================================

那么如果我们想知道pod里的metadata又有哪些字段呢？那么我们可以进行如下操作

::

    [alvin@k8s1 ~]$ kubectl explain pods.metadata
    KIND:     Pod
    VERSION:  v1

    RESOURCE: metadata <Object>

    DESCRIPTION:
         Standard object's metadata. More info:
         https://git.k8s.io/community/contributors/devel/api-conventions.md#metadata

         ObjectMeta is metadata that all persisted resources must have, which
         includes all objects users must create.

    FIELDS:
       annotations	<map[string]string>
         Annotations is an unstructured key value map stored with a resource that
         may be set by external tools to store and retrieve arbitrary metadata. They
         are not queryable and should be preserved when modifying objects. More
         info: http://kubernetes.io/docs/user-guide/annotations

       clusterName	<string>
         The name of the cluster which the object belongs to. This is used to
         distinguish resources with same name and namespace in different clusters.
         This field is not set anywhere right now and apiserver is going to ignore
         it if set in create or update request.

       creationTimestamp	<string>
         CreationTimestamp is a timestamp representing the server time when this
         object was created. It is not guaranteed to be set in happens-before order
         across separate operations. Clients may not set this value. It is
         represented in RFC3339 form and is in UTC. Populated by the system.
         Read-only. Null for lists. More info:
         https://git.k8s.io/community/contributors/devel/api-conventions.md#metadata

       deletionGracePeriodSeconds	<integer>
         Number of seconds allowed for this object to gracefully terminate before it
         will be removed from the system. Only set when deletionTimestamp is also
         set. May only be shortened. Read-only.

       deletionTimestamp	<string>
         DeletionTimestamp is RFC 3339 date and time at which this resource will be
         deleted. This field is set by the server when a graceful deletion is
         requested by the user, and is not directly settable by a client. The
         resource is expected to be deleted (no longer visible from resource lists,
         and not reachable by name) after the time in this field, once the
         finalizers list is empty. As long as the finalizers list contains items,
         deletion is blocked. Once the deletionTimestamp is set, this value may not
         be unset or be set further into the future, although it may be shortened or
         the resource may be deleted prior to this time. For example, a user may
         request that a pod is deleted in 30 seconds. The Kubelet will react by
         sending a graceful termination signal to the containers in the pod. After
         that 30 seconds, the Kubelet will send a hard termination signal (SIGKILL)
         to the container and after cleanup, remove the pod from the API. In the
         presence of network partitions, this object may still exist after this
         timestamp, until an administrator or automated process can determine the
         resource is fully terminated. If not set, graceful deletion of the object
         has not been requested. Populated by the system when a graceful deletion is
         requested. Read-only. More info:
         https://git.k8s.io/community/contributors/devel/api-conventions.md#metadata

       finalizers	<[]string>
         Must be empty before the object is deleted from the registry. Each entry is
         an identifier for the responsible component that will remove the entry from
         the list. If the deletionTimestamp of the object is non-nil, entries in
         this list can only be removed.

       generateName	<string>
         GenerateName is an optional prefix, used by the server, to generate a
         unique name ONLY IF the Name field has not been provided. If this field is
         used, the name returned to the client will be different than the name
         passed. This value will also be combined with a unique suffix. The provided
         value has the same validation rules as the Name field, and may be truncated
         by the length of the suffix required to make the value unique on the
         server. If this field is specified and the generated name exists, the
         server will NOT return a 409 - instead, it will either return 201 Created
         or 500 with Reason ServerTimeout indicating a unique name could not be
         found in the time allotted, and the client should retry (optionally after
         the time indicated in the Retry-After header). Applied only if Name is not
         specified. More info:
         https://git.k8s.io/community/contributors/devel/api-conventions.md#idempotency

       generation	<integer>
         A sequence number representing a specific generation of the desired state.
         Populated by the system. Read-only.

       initializers	<Object>
         An initializer is a controller which enforces some system invariant at
         object creation time. This field is a list of initializers that have not
         yet acted on this object. If nil or empty, this object has been completely
         initialized. Otherwise, the object is considered uninitialized and is
         hidden (in list/watch and get calls) from clients that haven't explicitly
         asked to observe uninitialized objects. When an object is created, the
         system will populate this list with the current set of initializers. Only
         privileged users may set or modify this list. Once it is empty, it may not
         be modified further by any user.

       labels	<map[string]string>
         Map of string keys and values that can be used to organize and categorize
         (scope and select) objects. May match selectors of replication controllers
         and services. More info: http://kubernetes.io/docs/user-guide/labels

       name	<string>
         Name must be unique within a namespace. Is required when creating
         resources, although some resources may allow a client to request the
         generation of an appropriate name automatically. Name is primarily intended
         for creation idempotence and configuration definition. Cannot be updated.
         More info: http://kubernetes.io/docs/user-guide/identifiers#names

       namespace	<string>
         Namespace defines the space within each name must be unique. An empty
         namespace is equivalent to the "default" namespace, but "default" is the
         canonical representation. Not all objects are required to be scoped to a
         namespace - the value of this field for those objects will be empty. Must
         be a DNS_LABEL. Cannot be updated. More info:
         http://kubernetes.io/docs/user-guide/namespaces

       ownerReferences	<[]Object>
         List of objects depended by this object. If ALL objects in the list have
         been deleted, this object will be garbage collected. If this object is
         managed by a controller, then an entry in this list will point to this
         controller, with the controller field set to true. There cannot be more
         than one managing controller.

       resourceVersion	<string>
         An opaque value that represents the internal version of this object that
         can be used by clients to determine when objects have changed. May be used
         for optimistic concurrency, change detection, and the watch operation on a
         resource or set of resources. Clients must treat these values as opaque and
         passed unmodified back to the server. They may only be valid for a
         particular resource or set of resources. Populated by the system.
         Read-only. Value must be treated as opaque by clients and . More info:
         https://git.k8s.io/community/contributors/devel/api-conventions.md#concurrency-control-and-consistency

       selfLink	<string>
         SelfLink is a URL representing this object. Populated by the system.
         Read-only.

       uid	<string>
         UID is the unique in time and space value for this object. It is typically
         generated by the server on successful creation of a resource and is not
         allowed to change on PUT operations. Populated by the system. Read-only.
         More info: http://kubernetes.io/docs/user-guide/identifiers#uids

    [alvin@k8s1 ~]$

查看更深的字段，如pods.spec.containers.livenessProbe
==============================================================

那如果是更深一点的字段呢？ 比如pods.spec.containers.livenessProbe

::

    [alvin@k8s1 ~]$ kubectl explain pods.spec.containers.livenessProbe
    KIND:     Pod
    VERSION:  v1

    RESOURCE: livenessProbe <Object>

    DESCRIPTION:
         Periodic probe of container liveness. Container will be restarted if the
         probe fails. Cannot be updated. More info:
         https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#container-probes

         Probe describes a health check to be performed against a container to
         determine whether it is alive or ready to receive traffic.

    FIELDS:
       exec	<Object>
         One and only one of the following should be specified. Exec specifies the
         action to take.

       failureThreshold	<integer>
         Minimum consecutive failures for the probe to be considered failed after
         having succeeded. Defaults to 3. Minimum value is 1.

       httpGet	<Object>
         HTTPGet specifies the http request to perform.

       initialDelaySeconds	<integer>
         Number of seconds after the container has started before liveness probes
         are initiated. More info:
         https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#container-probes

       periodSeconds	<integer>
         How often (in seconds) to perform the probe. Default to 10 seconds. Minimum
         value is 1.

       successThreshold	<integer>
         Minimum consecutive successes for the probe to be considered successful
         after having failed. Defaults to 1. Must be 1 for liveness. Minimum value
         is 1.

       tcpSocket	<Object>
         TCPSocket specifies an action involving a TCP port. TCP hooks not yet
         supported

       timeoutSeconds	<integer>
         Number of seconds after which the probe times out. Defaults to 1 second.
         Minimum value is 1. More info:
         https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#container-probes


