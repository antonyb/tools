## Jenkins setup on kubernetes

### Requisites

Following already installed in host
- k8s cluster (with ingress)
- helm

### Install

Setup k8s resources

`kubectl create namespace jenkins`

`kubectl apply -f jenkins-pv.yaml`

`kubectl apply -f jenkins-pvc.yaml`

`kubectl apply -f jenkins-sa.yaml`

Setup helm repo

`helm repo add jenkinsci https://charts.jenkins.io`

`helm repo update`

Install

`helm install jenkins -n jenkins --values ./helm/jenkins-values.yaml jenkinsci/jenkins`

Get default admin password:

``
```
NAME: jenkins
LAST DEPLOYED: Thu Jun  3 17:16:27 2021
NAMESPACE: jenkins
STATUS: deployed
REVISION: 1
NOTES:
1. Get your 'admin' user password by running:
  kubectl exec --namespace jenkins -it svc/jenkins -c jenkins -- /bin/cat /run/secrets/chart-admin-password && echo
2. Get the Jenkins URL to visit by running these commands in the same shell:
  echo http://127.0.0.1:8080
  kubectl --namespace jenkins port-forward svc/jenkins 8080:8080

3. Login with the password from step 1 and the username: admin
4. Configure security realm and authorization strategy
5. Use Jenkins Configuration as Code by specifying configScripts in your values.yaml file, see documentation: http:///configuration-as-code and examples: https://github.com/jenkinsci/configuration-as-code-plugin/tree/master/demos

For more information on running Jenkins on Kubernetes, visit:
https://cloud.google.com/solutions/jenkins-on-container-engine

For more information about Jenkins Configuration as Code, visit:
https://jenkins.io/projects/jcasc/


NOTE: Consider using a custom image with pre-installed plugins
```

Check install events:  
`watch kubectl get events --sort-by=.lastTimestamp -n jenkins`

### clean all
```
kubectl delete namespace jenkins
```

## Resources

### Jenkins setup with k8s

https://www.jenkins.io/doc/book/installing/kubernetes/

https://www.youtube.com/watch?v=2Kc3fUJANAc
