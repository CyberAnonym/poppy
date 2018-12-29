deployment
##################

编写一个nginx deployment

这里我们配置了requests最小资源，和limits最大可用资源，容器内端口，存储、磁盘映射、还有  strategy,我们的滚动更新策略，这里我定义了每次最多更新40%的pod，最多不可用的pod是40%。




.. literalinclude:: ../../../code/k8s.yamls/nginx-deploy.yaml



