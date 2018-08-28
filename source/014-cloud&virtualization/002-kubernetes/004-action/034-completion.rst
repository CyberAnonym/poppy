completion
##########################################

查看completion命令帮助
================================
.. code-block:: bash

    [root@k8s1 ~]# kubectl completion --help
    Output shell completion code for the specified shell (bash or zsh). The shell code must be evaluated to provide
    interactive completion of kubectl commands.  This can be done by sourcing it from the .bash _profile.

    Detailed instructions on how to do this are available here:
    https://kubernetes.io/docs/tasks/tools/install-kubectl/#enabling-shell-autocompletion

    Note for zsh users: [1] zsh completions are only supported in versions of zsh >= 5.2

    Examples:
      # Installing bash completion on macOS using homebrew
      ## If running Bash 3.2 included with macOS
      brew install bash-completion
      ## or, if running Bash 4.1+
      brew install bash-completion@2
      ## If kubectl is installed via homebrew, this should start working immediately.
      ## If you've installed via other means, you may need add the completion to your completion directory
      kubectl completion bash > $(brew --prefix)/etc/bash_completion.d/kubectl


      # Installing bash completion on Linux
      ## Load the kubectl completion code for bash into the current shell
      source <(kubectl completion bash)
      ## Write bash completion code to a file and source if from .bash_profile
      kubectl completion bash > ~/.kube/completion.bash.inc
      printf "
      # Kubectl shell completion
      source '$HOME/.kube/completion.bash.inc'
      " >> $HOME/.bash_profile
      source $HOME/.bash_profile

      # Load the kubectl completion code for zsh[1] into the current shell
      source <(kubectl completion zsh)
      # Set the kubectl completion code for zsh[1] to autoload on startup
      kubectl completion zsh > "${fpath[1]}/_kubectl"

    Usage:
      kubectl completion SHELL [options]

    Use "kubectl options" for a list of global command-line options (applies to all commands).