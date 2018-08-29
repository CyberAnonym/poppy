annotate
###########

查看annotate帮助
========================

.. code-block:: bash

    [root@k8s1 ~]# kubectl annotate --help
    Update the annotations on one or more resources

    All Kubernetes objects support the ability to store additional data with the object as annotations. Annotations are
    key/value pairs that can be larger than labels and include arbitrary string values such as structured JSON. Tools and
    system extensions may use annotations to store their own data.

    Attempting to set an annotation that already exists will fail unless --overwrite is set. If --resource-version is
    specified and does not match the current resource version on the server the command will fail.

    Use "kubectl api-resources" for a complete list of supported resources.

    Examples:
      # Update pod 'foo' with the annotation 'description' and the value 'my frontend'.
      # If the same annotation is set multiple times, only the last value will be applied
      kubectl annotate pods foo description='my frontend'

      # Update a pod identified by type and name in "pod.json"
      kubectl annotate -f pod.json description='my frontend'

      # Update pod 'foo' with the annotation 'description' and the value 'my frontend running nginx', overwriting any
    existing value.
      kubectl annotate --overwrite pods foo description='my frontend running nginx'

      # Update all pods in the namespace
      kubectl annotate pods --all description='my frontend running nginx'

      # Update pod 'foo' only if the resource is unchanged from version 1.
      kubectl annotate pods foo description='my frontend running nginx' --resource-version=1

      # Update pod 'foo' by removing an annotation named 'description' if it exists.
      # Does not require the --overwrite flag.
      kubectl annotate pods foo description-

    Options:
          --all=false: Select all resources, including uninitialized ones, in the namespace of the specified resource types.
          --allow-missing-template-keys=true: If true, ignore any errors in templates when a field or map key is missing in
    the template. Only applies to golang and jsonpath output formats.
          --dry-run=false: If true, only print the object that would be sent, without sending it.
          --field-selector='': Selector (field query) to filter on, supports '=', '==', and '!='.(e.g. --field-selector
    key1=value1,key2=value2). The server only supports a limited number of field queries per type.
      -f, --filename=[]: Filename, directory, or URL to files identifying the resource to update the annotation
          --include-uninitialized=false: If true, the kubectl command applies to uninitialized objects. If explicitly set to
    false, this flag overrides other flags that make the kubectl commands apply to uninitialized objects, e.g., "--all".
    Objects with empty metadata.initializers are regarded as initialized.
          --local=false: If true, annotation will NOT contact api-server but run locally.
      -o, --output='': Output format. One of:
    json|yaml|name|template|go-template|go-template-file|templatefile|jsonpath|jsonpath-file.
          --overwrite=false: If true, allow annotations to be overwritten, otherwise reject annotation updates that
    overwrite existing annotations.
          --record=false: Record current kubectl command in the resource annotation. If set to false, do not record the
    command. If set to true, record the command. If not set, default to updating the existing annotation value only if one
    already exists.
      -R, --recursive=false: Process the directory used in -f, --filename recursively. Useful when you want to manage
    related manifests organized within the same directory.
          --resource-version='': If non-empty, the annotation update will only succeed if this is the current
    resource-version for the object. Only valid when specifying a single resource.
      -l, --selector='': Selector (label query) to filter on, not including uninitialized ones, supports '=', '==', and
    '!='.(e.g. -l key1=value1,key2=value2).
          --template='': Template string or path to template file to use when -o=go-template, -o=go-template-file. The
    template format is golang templates [http://golang.org/pkg/text/template/#pkg-overview].

    Usage:
      kubectl annotate [--overwrite] (-f FILENAME | TYPE NAME) KEY_1=VAL_1 ... KEY_N=VAL_N [--resource-version=version]
    [options]

    Use "kubectl options" for a list of global command-line options (applies to all commands).


