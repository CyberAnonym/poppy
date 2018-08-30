metrics-server
#################################

deploy 的yaml所在目录: https://github.com/kubernetes-incubator/metrics-server/tree/master/deploy


创建部署
#############


kubectl create -f https://raw.githubusercontent.com/kubernetes-incubator/metrics-server/master/deploy/1.8%2B/auth-delegator.yaml
kubectl create -f https://raw.githubusercontent.com/kubernetes-incubator/metrics-server/master/deploy/1.8%2B/auth-reader.yaml
kubectl create -f https://raw.githubusercontent.com/kubernetes-incubator/metrics-server/master/deploy/1.8%2B/metrics-apiservice.yaml
kubectl create -f https://raw.githubusercontent.com/kubernetes-incubator/metrics-server/master/deploy/1.8%2B/metrics-server-deployment.yaml
kubectl create -f https://raw.githubusercontent.com/kubernetes-incubator/metrics-server/master/deploy/1.8%2B/metrics-server-service.yaml
kubectl create -f https://raw.githubusercontent.com/kubernetes-incubator/metrics-server/master/deploy/1.8%2B/resource-reader.yaml
