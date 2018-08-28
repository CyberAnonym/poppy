label
##########

查看label命令帮助
========================

.. code-block:: bash

    [root@k8s1 ~]# kubectl label --help
    Update the labels on a resource.

      * A label key and value must begin with a letter or number, and may contain letters, numbers, hyphens, dots, and
    underscores, up to  63 characters each.
      * Optionally, the key can begin with a DNS subdomain prefix and a single '/', like example.com/my-app
      * If --overwrite is true, then existing labels can be overwritten, otherwise attempting to overwrite a label will
    result in an error.
      * If --resource-version is specified, then updates will use this resource version, otherwise the existing
    resource-version will be used.

    Examples:
      # Update pod 'foo' with the label 'unhealthy' and the value 'true'.
      kubectl label pods foo unhealthy=true

      # Update pod 'foo' with the label 'status' and the value 'unhealthy', overwriting any existing value.
      kubectl label --overwrite pods foo status=unhealthy

      # Update all pods in the namespace
      kubectl label pods --all status=unhealthy

      # Update a pod identified by the type and name in "pod.json"
      kubectl label -f pod.json status=unhealthy

      # Update pod 'foo' only if the resource is unchanged from version 1.
      kubectl label pods foo status=unhealthy --resource-version=1

      # Update pod 'foo' by removing a label named 'bar' if it exists.
      # Does not require the --overwrite flag.
      kubectl label pods foo bar-

    Options:
          --all=false: Select all resources, including uninitialized ones, in the namespace of the specified resource types
          --allow-missing-template-keys=true: If true, ignore any errors in templates when a field or map key is missing in
    the template. Only applies to golang and jsonpath output formats.
          --dry-run=false: If true, only print the object that would be sent, without sending it.
          --field-selector='': Selector (field query) to filter on, supports '=', '==', and '!='.(e.g. --field-selector
    key1=value1,key2=value2). The server only supports a limited number of field queries per type.
      -f, --filename=[]: Filename, directory, or URL to files identifying the resource to update the labels
          --include-uninitialized=false: If true, the kubectl command applies to uninitialized objects. If explicitly set to
    false, this flag overrides other flags that make the kubectl commands apply to uninitialized objects, e.g., "--all".
    Objects with empty metadata.initializers are regarded as initialized.
          --list=false: If true, display the labels for a given resource.
          --local=false: If true, label will NOT contact api-server but run locally.
      -o, --output='': Output format. One of:
    json|yaml|name|template|go-template|go-template-file|templatefile|jsonpath|jsonpath-file.
          --overwrite=false: If true, allow labels to be overwritten, otherwise reject label updates that overwrite existing
    labels.
          --record=false: Record current kubectl command in the resource annotation. If set to false, do not record the
    command. If set to true, record the command. If not set, default to updating the existing annotation value only if one
    already exists.
      -R, --recursive=false: Process the directory used in -f, --filename recursively. Useful when you want to manage
    related manifests organized within the same directory.
          --resource-version='': If non-empty, the labels update will only succeed if this is the current resource-version
    for the object. Only valid when specifying a single resource.
      -l, --selector='': Selector (label query) to filter on, not including uninitialized ones, supports '=', '==', and
    '!='.(e.g. -l key1=value1,key2=value2).
          --template='': Template string or path to template file to use when -o=go-template, -o=go-template-file. The
    template format is golang templates [http://golang.org/pkg/text/template/#pkg-overview].

    Usage:
      kubectl label [--overwrite] (-f FILENAME | TYPE NAME) KEY_1=VAL_1 ... KEY_N=VAL_N [--resource-version=version]
    [options]

    Use "kubectl options" for a list of global command-line options (applies to all commands).


