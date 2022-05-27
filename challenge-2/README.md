# [Challenge-2](https://kodekloud.com/topic/kubernetes-challenge-2/)


> Note: -

1. At location of `/etc/kubernetes/manifests`, in `kube-apiserver.yaml` client ca file name is incorrect. Fix it with correct name.
2. After fixing the `kube-apiserver.yaml` manifest file, move to the path of `/root/.kube/`, as per description match the name of `user` and `api-server` port number.
3. After fixing the issues, cluster should be up. Do `kubectl get nodes` to check the status of nodes.
4. Worker node is not set to schedule pods. Fix it with the certain command.

```
$ kubectl uncordon node01
```

5. Check the CoreDNS Pods in the `kube-system` namespace.
6. Edit the CoreDNS deployment manifest file and update image name as per description. Run the following commands:-

```

$ kubectl edit deploy coredns -n kube-system

$ kubectl get deploy coredns -n kube-system

$ kubectl get pods -n kube-system
```

7. Now cluster in configured to perform the following tasks. 

