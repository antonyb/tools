# Dashboard Intall

## Dashboard Basic Install
Downloaded copy of https://raw.githubusercontent.com/kubernetes/dashboard/v2.2.0/aio/deploy/recommended.yaml

Install dashboard:  
`kubectl apply -f recommended.yaml`

Run proxy to access it:  
`kubectl proxy`

NOTE: logging in now would show no data and foebidden access errors as we don't have permission to access currently deployed resources.  
We need a new Service Account with added permissions.  
Downloaded from https://github.com/justmeandopensource/kubernetes/blob/master/dashboard/sa_cluster_admin.yaml

`kubectl apply -f sa_cluster_admin.yaml`

Access dashboard on http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/

Two login options:
- token
- kube config

Log in using the token, stored in a secret linked to the ServiceAccount found in _sa_cluster_admin.yaml_.

`kubectl -n kube-system describe sa dashboard-admin`

```
Name:                dashboard-admin
Namespace:           kube-system
Labels:              <none>
Annotations:         <none>
Image pull secrets:  <none>
Mountable secrets:   dashboard-admin-token-7p6lv
Tokens:              dashboard-admin-token-7p6lv
Events:              <none>
```

Copy the (long) token from the output of:  
`kubectl -n kube-system describe secret dashboard-admin-token-7p6lv`

Return to the dashboard UI and login.  
All being well all resources for all namespaces should be available.

At this stage we don't have memory or cpu data.  We need to install the metrics server in the next step.


# Metrics Server Install

Instructions found in https://github.com/kubernetes-sigs/metrics-server.

Download copy of https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml.

Edit components.yaml and add the following parameter to `metrics-server` deployment resource, alongside the others (in `.spec.template.spec.containers`).

- `--kubelet-insecure-tls`

Deploy the metrics server:  
`kubectl apply -f components.yaml`

Confirm successful deployment:  
`kubectl describe apiservice v1beta1.metrics.k8s.io`

Status will be similar to:  
```yaml
Status:
  Conditions:
    Last Transition Time:  <date>
    Message:               all checks passed
    Reason:                Passed
    Status:                True
    Type:                  Available
```

Another check:  
`kubectl get apiservice v1beta1.metrics.k8s.io -o yaml`

```yaml
status:
  conditions:
  - lastTransitionTime: "<date>"
    message: all checks passed
    reason: Passed
    status: "True"
    type: Available
```

## Check metrics using CLI

Eg:  
`kubectl top pod -n kubernetes-dashboard`

```
...
NAME                                         CPU(cores)   MEMORY(bytes)
dashboard-metrics-scraper-856586f554-sr8j9   0m           5Mi
kubernetes-dashboard-78c79f97b4-xj7zx        3m           12Mi
```

# Troubleshooting

## Unsuccessful metrics server deployment

### Issue

Check deployment:  
`kubectl describe apiservice v1beta1.metrics.k8s.io`

Status will be similar to:  
```yaml
Status:
  Conditions:
    Last Transition Time:  <date>
    Message:               endpoints for service/metrics-server in "kube-system" have no addresses with port name "https"
    Reason:                MissingEndpoints
    Status:                False
    Type:                  Available
```

The following would show a similar error:  
`kubectl get apiservice v1beta1.metrics.k8s.io -o yaml`

```yaml
status:
  conditions:
  - lastTransitionTime: "<date>"
    message: endpoints for service/metrics-server in "kube-system" have no addresses
      with port name "https"
    reason: MissingEndpoints
    status: "False"
    type: Available
```

### Solution

Ensure the `--kubelet-insecure-tls` argument was added to the compoments config before deploying

# Resources

https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/

https://github.com/kubernetes/dashboard

https://github.com/kubernetes/dashboard/blob/master/docs/user/integrations.md

https://github.com/kubernetes-sigs/metrics-server

Dashboard RBAC override (forbidden fix):  
https://github.com/justmeandopensource/kubernetes/blob/master/dashboard/sa_cluster_admin.yaml

Extra support:  
https://computingforgeeks.com/how-to-deploy-metrics-server-to-kubernetes-cluster/