# Local Kind Cluster Setup

## Cluster Setup

cluster-config.yaml:
```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  kubeadmConfigPatches:
  - |
    kind: InitConfiguration
    nodeRegistration:
      kubeletExtraArgs:
        node-labels: "ingress-ready=true"
  extraPortMappings:
  - containerPort: 80
    hostPort: 9100
    protocol: TCP
  - containerPort: 443
    hostPort: 9543
    protocol: TCP
```

`kind create cluster --config cluster-config.yaml --name tools`
```
Creating cluster "tools" ...
 â Ensuring node image (kindest/node:v1.20.2) đŧ
 â Preparing nodes đĻ
 â Writing configuration đ
 â Starting control-plane đšī¸
 â Installing CNI đ
 â Installing StorageClass đž
Set kubectl context to "kind-tools"
You can now use your cluster with:

kubectl cluster-info --context kind-tools

Have a question, bug, or feature request? Let us know! https://kind.sigs.k8s.io/#community đ
```

Test local access to remote cluster:

`kubectl get all`
```
NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   6m20s
```

## Ingress Setup

Get https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/kind/deploy.yaml
(saved as ingress-deploy.yaml)

`kubectl apply -f ingress-deploy.yaml`

Test ingress - results in a Nginx 404 as no service has been deployed yet

`curl localhost:9100`
```xml
<html>
<head><title>404 Not Found</title></head>
<body>
<center><h1>404 Not Found</h1></center>
<hr><center>nginx</center>
</body>
</html>
```

## Resources

https://kind.sigs.k8s.io/docs/user/ingress  
