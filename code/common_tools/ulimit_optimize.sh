#!/bin/bash

echo '* soft nofile 65535
* hard nofile 65535
* soft nproc 65535
* hard nproc 65535
' > /etc/security/limits.conf
