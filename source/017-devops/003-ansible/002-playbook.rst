playbook
##################



创建一个简单的playbook

::

    $ vim ping.yaml
    ---
    - hosts: redis1
      remote_user: root
      tasks:
        - shell: 'echo `whoami` > /tmp/ansi.txt'
          remote_user: root

    $ ansible-playbook ping.yaml